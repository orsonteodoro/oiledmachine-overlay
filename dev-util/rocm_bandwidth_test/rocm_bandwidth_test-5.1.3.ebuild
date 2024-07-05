# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/RadeonOpenCompute/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
LICENSE="NCSA-AMD"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" ebuild-revision-5"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.6.3
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
	cmake_src_configure
}

src_install() {
	cmake_src_install
#	rm -rfv "${ED}/usr/share/doc/rocm-bandwidth-test"
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
