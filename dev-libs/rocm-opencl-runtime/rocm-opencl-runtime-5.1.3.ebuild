# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake edo flag-o-matic prefix rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz
	-> rocclr-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz
	-> rocm-opencl-runtime-${PV}.tar.gz
"

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
LICENSE="
	Apache-2.0
	MIT
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
debug test
r1
"
KEYWORDS="~amd64"
# ROCclr uses clang -print-libgcc-file-name which may output a static-lib to link to.
RDEPEND="
	!dev-libs/rocm-opencl-runtime:0
	=sys-libs/compiler-rt-${LLVM_MAX_SLOT}*:=
	>=media-libs/mesa-22.3.6
	>=virtual/opencl-3
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
	>=dev-util/opencl-headers-2023.02.06
"
BDEPEND="
	>=media-libs/glew-2.2.0
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=x11-apps/mesa-progs-8.5.0[X]
	)
"
RESTRICT="
	!test? (
		test
	)
"
OCL_PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-remove-clinfo.patch"
	"${FILESDIR}/${PN}-3.5.0-do-not-install-libopencl.patch"
	"${FILESDIR}/${PN}-5.3.3-gcc13.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)
ROCCLR_PATCHES=(
	# Bug #753377
	# patch re-enables accidentally disabled gfx800 family
	"${FILESDIR}/${PN}-5.0.2-enable-gfx800.patch"
	"${FILESDIR}/rocclr-5.1.3-fix-include.patch"
	"${FILESDIR}/rocclr-5.3.3-gcc13.patch"
	"${FILESDIR}/ROCclr-5.1.3-path-changes.patch"
)
S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
ROCCLR_S="${WORKDIR}/ROCclr-rocm-${PV}"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	# Remove "clinfo" - use "dev-util/clinfo" instead
	[ -d tools/clinfo ] && rm -rf tools/clinfo || die

	pushd "${ROCCLR_S}" || die
		eapply ${ROCCLR_PATCHES[@]}
	popd || die

	eapply ${OCL_PATCHES[@]}
	cmake_src_prepare
	rocm_src_prepare

	# remove trailing CR or it won't work
	sed \
		-e "s/\r$//g" \
		-i tests/ocltst/module/perf/oclperf.exclude \
		|| die
}

src_configure() {
#
# Reported upstream:
#
# https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
#
	append-cflags -fcommon

	replace-flags -O0 -O1
	local mycmakeargs=(
		-DAMD_OPENCL_PATH="${S}"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DEMU_ENV=ON
		-DROCCLR_PATH="${ROCCLR_S}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-Wno-dev
		# -DCMAKE_STRIP=""
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/$(get_libdir)/rocm/${ROCM_SLOT}/etc/OpenCL/vendors
	doins config/amdocl64.icd
	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/rocm/${ROCM_SLOT}/$(get_libdir)
	doins amdocl/libamdocl64.so
	doins tools/cltrace/libcltrace.so
	# TODO symlinks:
	# /usr/$(get_libdir)/rocm/${ROCM_SLOT}/etc/OpenCL/vendors/amdocl64.icd -> /etc/OpenCL/vendors/amdocl64.icd
	# /usr/$(get_libdir)/rocm/${ROCM_SLOT}/$(get_libdir)/libamdocl64.so /usr/$(get_libdir)/libamdocl64.so
	# /usr/$(get_libdir)/rocm/${ROCM_SLOT}/$(get_libdir)/libcltrace.so /usr/$(get_libdir)/libcltrace.so
}

# Copied from rocm.eclass. This ebuild does not need amdgpu_targets
# USE_EXPANDS, so it should not inherit rocm.eclass; it only uses the
# check_amdgpu function in src_test. Rename it to check-amdgpu to avoid
# pkgcheck warning.
check-amdgpu() {
	for device in "/dev/kfd" "/dev/dri/render"*; do
		addwrite "${device}"
		if [[ ! -r "${device}" || ! -w "${device}" ]]; then
eerror
eerror "${device} is inaccessible and cannot read or write ${device}!"
eerror
eerror "Make sure it is present and check the permission.  By default render"
eerror "group have access to it. Check if portage user is in the render group."
eerror
			die
		fi
	done
}

_print_instructions() {
eerror "Please start an X server using amdgpu driver (not Xvfb!), and"
eerror "export OCLGL_DISPLAY=\${DISPLAY} OCLGL_XAUTHORITY=\${XAUTHORITY}"
eerror "before reruning the test."
}

src_test() {
	check-amdgpu
	cd "${BUILD_DIR}/tests/ocltst" || die
	export OCL_ICD_FILENAMES="${BUILD_DIR}/amdocl/libamdocl64.so"
	if [[ -n "${OCLGL_DISPLAY+x}" ]]; then
		export DISPLAY="${OCLGL_DISPLAY}"
		export XAUTHORITY="${OCLGL_XAUTHORITY}"
		ebegin "Running oclgl test under DISPLAY ${OCLGL_DISPLAY}"
		if ! glxinfo | grep "OpenGL vendor string: AMD" ; then
eerror
_print_instructions
eerror
eerror "This display does not have AMD OpenGL vendor!"
eerror
			die
		fi
		./ocltst -m $(realpath liboclgl.so) -A ogl.exclude
		eend $? || die "oclgl test failed"
	else
eerror
_print_instructions
eerror
eerror "\${OCLGL_DISPLAY} is not set."
eerror
		die
	fi
	edob ./ocltst -m $(realpath liboclruntime.so) -A oclruntime.exclude
	edob ./ocltst -m $(realpath liboclperf.so) -A oclperf.exclude
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
