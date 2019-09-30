# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Application for Reporting System Info "
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/roc-${PV}.tar.gz -> ${PV}.tar.gz"

LICENSE="NCSA"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="rock-latest rock-milestone rock-snapshot"
REQUIRED_USE="|| ( rock-latest rock-milestone rock-snapshot )"

RDEPEND="sys-kernel/ot-sources[rock-latest?,rock-milestone?,rock-snapshot?]
	 || ( x11-drivers/amdgpu-pro[hsa] dev-libs/roct-thunk-interface )
	 dev-libs/rocm-cmake
	 dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DROCM_DIR="${ESYSROOT}/usr"
		-DROCR_INC_DIR="${ESYSROOT}/usr/include"
		-DROCR_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake-utils_src_configure
}
