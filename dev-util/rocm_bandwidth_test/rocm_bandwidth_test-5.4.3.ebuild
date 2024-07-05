# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=15
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

SRC_URI="
https://github.com/RadeonOpenCompute/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/RadeonOpenCompute/rocm_bandwidth_test/commit/a58f9fd4cb5d1120b9ce58c912ca87fa14720f73.patch
	-> ${PN}-pr90-a58f9fd.patch
"
# a58f9fd - fix include for rocm 5.5.0

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
LICENSE="NCSA-AMD"
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
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
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${DISTDIR}/${PN}-pr90-a58f9fd.patch"
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
