# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake edo flag-o-matic rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_CLR_REPO_URI="https://github.com/ROCm-Developer-Tools/ROCclr"
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/clr-rocm-${PV}/opencl"
	SRC_URI="
https://github.com/ROCm-Developer-Tools/clr/archive/refs/tags/rocm-${PV}.tar.gz
	-> roc-clr-${PV}.tar.gz
	"
fi
CLR_S="${WORKDIR}/clr-rocm-${PV}"
ROCCLR_S="${WORKDIR}/clr-rocm-${PV}/rocclr"

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
# all-rights-reserved MIT - ./clr-rocm-6.1.2/CMakeLists.txt
# custom - ./clr-rocm-6.1.2/opencl/khronos/headers/opencl2.2/LICENSE.txt
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
debug test
ebuild_revision_7
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
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=x11-apps/mesa-progs-8.5.0[X]
		media-libs/glew
	)
"
OCL_PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-include-search-path.patch"
	"${FILESDIR}/${PN}-5.7.0-defs.patch"
	"${FILESDIR}/${PN}-5.7.0-link-path.patch"
)
ROCCLR_PATCHES=(
	# Bug #753377
	# patch re-enables accidentally disabled gfx800 family
	"${FILESDIR}/${PN}-6.0.2-enable-gfx800.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_unpack () {
	if [[ ${PV} == "9999" ]]; then
		git-r3_fetch
		git-r3_checkout
		git-r3_fetch "${EGIT_CLR_REPO_URI}"
		git-r3_checkout "${EGIT_CLR_REPO_URI}" "${ROCCLR_S}"
	else
		default
	fi
}
src_prepare() {
	pushd "${ROCCLR_S}" || die
		eapply ${ROCCLR_PATCHES[@]}
	popd || die
	eapply ${OCL_PATCHES[@]}
	cmake_src_prepare

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-6.2.4-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

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
		-DCLR_PATH="${CLR_S}"
		-DEMU_ENV=ON
		-DBUILD_ICD=OFF
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCCLR_PATH="${ROCCLR_S}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-Wno-dev
	)
	pushd "${ROCCLR_S}" || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		rocm_src_configure
	popd || die
	rocm_src_configure
}

src_compile() {
	pushd "${ROCCLR_S}" || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		cmake_src_compile
	popd || die
	cmake_src_compile
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
