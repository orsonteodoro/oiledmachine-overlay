# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-2 ${PV})"

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="
	https://pugixml.org/
	https://github.com/zeux/pugixml/
"
LICENSE="MIT"
KEYWORDS="
~amd64 ~arm64 ~x86
"
IUSE+=" doc static-libs"
SLOT="0/$(ver_cut 1-2 ${PV})"
# U 22.04
DEPEND+="
	virtual/libc
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	|| (
		>=llvm-core/clang-14.0
		>=sys-devel/gcc-11.2.0
	)
	>=dev-build/cmake-3.5
"
RESTRICT="mirror"
DOCS=( docs readme.txt )

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DPUGIXML_BUILD_SHARED_AND_STATIC_LIBS=$(usex static-libs)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	dodoc LICENSE.md
	use doc && einstalldocs
}
