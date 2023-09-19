# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake linux-info rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
	inherit git-r3
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCT-Thunk-Interface-rocm-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface"
CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	!dev-libs/roct-thunk-interface:0
	>=sys-apps/pciutils-3.9.0
	>=sys-process/numactl-2.0.16
	~virtual/amdgpu-drm-3.2.230
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.6.3
	>=x11-libs/libdrm-2.4.114[video_cards_amdgpu]
"
CMAKE_BUILD_TYPE="Release"
PATCHES=(
	"${FILESDIR}/roct-thunk-interface-5.7.0-path-changes.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" \
		-i \
		CMakeLists.txt \
		|| die
	sed \
		-e "s:ubuntu:gentoo:" \
		-i \
		CMakeLists.txt \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPACK_PACKAGING_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
