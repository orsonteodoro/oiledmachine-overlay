# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake edo flag-o-matic rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
	EGIT_CLR_REPO_URI="https://github.com/ROCm-Developer-Tools/ROCclr"
	inherit git-r3
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz
	-> rocclr-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz
	-> rocm-opencl-runtime-${PV}.tar.gz
	"
	S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
fi

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
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=x11-apps/mesa-progs-8.5.0[X]
		media-libs/glew
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-gcc13.patch"
	"${FILESDIR}/${PN}-5.3.3-path-changes.patch"
)
CLR_S="${WORKDIR}/ROCclr-rocm-${PV}"

pkg_setup() {
	rocm_pkg_setup
}

src_unpack () {
	if [[ ${PV} == "9999" ]]; then
		git-r3_fetch
		git-r3_checkout
		git-r3_fetch "${EGIT_CLR_REPO_URI}"
		git-r3_checkout "${EGIT_CLR_REPO_URI}" "${CLR_S}"
	else
		default
	fi
}
src_prepare() {
	cmake_src_prepare
	rocm_src_prepare

	pushd "${CLR_S}" || die
	# Bug #753377
	# patch re-enables accidentally disabled gfx800 family
		eapply "${FILESDIR}/${PN}-5.0.2-enable-gfx800.patch"
		eapply "${FILESDIR}/rocclr-5.3.3-gcc13.patch"
		eapply "${FILESDIR}/ROCclr-5.6.0-path-changes.patch"
	popd || die
}

src_configure() {
#
# Reported upstream:
#
# https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
#
	append-cflags -fcommon
	local mycmakeargs=(
		-DAMD_OPENCL_PATH="${S}"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DEMU_ENV=ON
		-DBUILD_ICD=OFF
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCCLR_PATH="${CLR_S}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-Wno-dev
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
