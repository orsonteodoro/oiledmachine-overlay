# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="SQLiteCpp"

inherit cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/SRombauts/SQLiteCpp.git"
	FALLBACK_COMMIT="08aa70a45ea52abcd8ee6b5d1ab1542140b3c7f5" # Aug 16, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~amd64-linux ~arm64 ~arm64-macos"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="SQLiteC++ (SQLiteCpp) is a smart and easy to use C++ SQLite3 wrapper"
HOMEPAGE="
	https://github.com/SRombauts/SQLiteCpp
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	dev-db/sqlite
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.5
	virtual/pkgconfig
"
DOCS=( "CHANGELOG.md" "README.md" )

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
		-DBUILD_SHARED_LIBS=ON
		-DSQLITECPP_BUILD_TESTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"

	# Collisions
	rm -rf "${ED}/usr/include/sqlite3.h"
	rm -rf "${ED}/usr/$(get_libdir)/libsqlite3.so"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
