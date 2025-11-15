# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipBLAS-common-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipBLAS-common/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Common files shared by hipBLAS and hipBLASLt"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
LICENSE="
	MIT
"
SLOT="0/${ROCM_SLOT}"
IUSE+="
ebuild_revision_0
"
REQUIRED_USE="
"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	>=dev-build/cmake-3.11
"
PATCHES=(
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
