# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="antlr4"

inherit cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/antlr/antlr4.git"
	FALLBACK_COMMIT="cc82115a4e7f53d71d9d905caa2c2dfa4da58899" # Aug 3, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/runtime/Cpp"
	S_PROJ="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~amd64-linux ~arm64 ~arm64-macos"
	S="${WORKDIR}/${MY_PN}-${PV}/runtime/Cpp"
	S_PROJ="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/antlr/antlr4/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="C++ runtime support for ANTLR 4"
HOMEPAGE="
	https://github.com/antlr/antlr4/tree/master/runtime/Cpp
"
LICENSE="
	BSD
"
RESTRICT="mirror test" # Untested, avoid downloading
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.15
"
DOCS=( "${S_PROJ}/CHANGES.txt" "${S_PROJ}/README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DEMO=OFF
		-DWITH_LIBCXX=OFF
		-DANTLR_BUILD_CPP_TESTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "${S_PROJ}/LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
