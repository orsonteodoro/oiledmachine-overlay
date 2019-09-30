# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Application for Reporting System Info "
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
LICENSE="NCSA"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0/$(ver_cut 1-2)"
IUSE="rock-latest rock-milestone rock-snapshot"
REQUIRED_USE="|| ( rock-latest rock-milestone rock-snapshot )"
RDEPEND="sys-kernel/ot-sources[rock-latest?,rock-milestone?,rock-snapshot?]
	 || ( x11-drivers/amdgpu-pro[hsa] dev-libs/roct-thunk-interface )
	 dev-libs/rocm-cmake
	 dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"
MY_PN="rocminfo-roc"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DROCM_DIR="${ESYSROOT}/usr"
		-DROCR_INC_DIR="${ESYSROOT}/usr/include"
		-DROCR_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake-utils_src_configure
}
