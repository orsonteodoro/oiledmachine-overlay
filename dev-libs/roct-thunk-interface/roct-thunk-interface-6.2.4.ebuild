# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic linux-info rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCT-Thunk-Interface-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD-2
	custom
"
# all-rights-reserved MIT custom - tests/kfdtest/LICENSE.kfdtest
# The distro's MIT license template does not contain All Rights Reserved.
# Don't strip hsaKmtReplaceAsanHeaderPage \
RESTRICT="
	strip
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+="
ebuild_revision_10
"
# See https://github.com/ROCm/rocm-install-on-linux/blob/docs/6.2.4/docs/reference/user-kernel-space-compat-matrix.rst
RDEPEND="
	!dev-libs/roct-thunk-interface:0
	>=sys-apps/pciutils-3.9.0
	>=sys-process/numactl-2.0.16
	|| (
		virtual/kfd-ub:6.2
		virtual/kfd:6.1
		virtual/kfd-lb:6.0
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.6.3
	>=x11-libs/libdrm-2.4.114[video_cards_amdgpu]
	dev-util/patchelf
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	linux-info_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" \
		-i \
		"CMakeLists.txt" \
		|| die
	sed \
		-e "s:ubuntu:gentoo:" \
		-i \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
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

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCPACK_PACKAGING_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

_fix_rpath() {
	local path="${1}"
	einfo "Fixing rpath for ${path}"
	patchelf \
		--add-rpath "${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)" \
		"${path}" \
		|| die
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	_fix_rpath "${ED}/opt/rocm-${ROCM_VERSION}/$(rocm_get_libdir)/libhsakmt.so.1.0.6"
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
