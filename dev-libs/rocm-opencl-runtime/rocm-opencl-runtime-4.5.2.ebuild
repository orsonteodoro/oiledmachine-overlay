# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=13
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake edo flag-o-matic prefix rocm

KEYWORDS="~amd64"
S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
ROCCLR_S="${WORKDIR}/ROCclr-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz
	-> rocclr-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz
	-> rocm-opencl-runtime-${PV}.tar.gz
"

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	custom
	MIT
"
# all-rights-reserved MIT - ./ROCclr-rocm-4.5.2/elf/test/CMakeLists.txt
# custom - ./ROCm-OpenCL-Runtime-rocm-4.5.2/khronos/headers/opencl1.2/CL/cl_gl_ext.h
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
debug test
ebuild_revision_6
"
# ROCclr uses clang -print-libgcc-file-name which may output a static-lib to link to.
RDEPEND="
	!dev-libs/rocm-opencl-runtime:0
	=llvm-runtimes/compiler-rt-${LLVM_SLOT}*:=
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
	${ROCM_GCC_DEPEND}
	>=media-libs/glew-2.2.0
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=x11-apps/mesa-progs-8.5.0[X]
	)
"
OCL_PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-remove-clinfo.patch"
	"${FILESDIR}/${PN}-3.5.0-do-not-install-libopencl.patch"
	"${FILESDIR}/${PN}-5.3.3-gcc13.patch"
)
ROCCLR_PATCHES=(
	# Bug #753377
	# patch re-enables accidentally disabled gfx800 family
	"${FILESDIR}/${PN}-5.0.2-enable-gfx800.patch"
	"${FILESDIR}/rocclr-4.5.2-fix-include.patch"
	"${FILESDIR}/rocclr-5.3.3-gcc13.patch"
)

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

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-4.5.2-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	rocm_src_prepare

	# remove trailing CR or it won't work
	sed \
		-i \
		-e "s/\r$//g" \
		"tests/ocltst/module/perf/oclperf.exclude" \
		|| die
}

src_configure() {
	rocm_set_default_gcc
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
	rocm_src_configure
}

src_install() {
	insinto "/opt/rocm-${ROCM_VERSION}/etc/OpenCL/vendors"
	doins "config/amdocl64.icd"
	cd "${BUILD_DIR}" || die
	insinto "/opt/rocm-${ROCM_VERSION}/$(rocm_get_libdir)"
	doins "amdocl/libamdocl64.so"
	doins "tools/cltrace/libcltrace.so"
	# TODO symlinks:
	# /opt/rocm-${ROCM_VERSION}/etc/OpenCL/vendors/amdocl64.icd -> /etc/OpenCL/vendors/amdocl64.icd
	# /opt/rocm-${ROCM_VERSION}/$(rocm_get_libdir)/libamdocl64.so /usr/$(get_libdir)/libamdocl64.so
	# /opt/rocm-${ROCM_VERSION}/$(rocm_get_libdir)/libcltrace.so /usr/$(get_libdir)/libcltrace.so
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
		"./ocltst" -m $(realpath "liboclgl.so") -A "ogl.exclude"
		eend $? || die "oclgl test failed"
	else
eerror
_print_instructions
eerror
eerror "\${OCLGL_DISPLAY} is not set."
eerror
		die
	fi
	edob "./ocltst" -m $(realpath "liboclruntime.so") -A "oclruntime.exclude"
	edob "./ocltst" -m $(realpath "liboclperf.so") -A "oclperf.exclude"
}

pkg_postinst() {
ewarn "This package requires PCIe atomics."
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
