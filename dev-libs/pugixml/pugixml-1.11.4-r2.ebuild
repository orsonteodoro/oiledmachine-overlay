# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION=\
"Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="https://pugixml.org/ https://github.com/zeux/pugixml/"
LICENSE="MIT"
KEYWORDS=\
"amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE+=" doc static-libs"
SLOT="0/${PV}"
DEPEND+=" virtual/libc"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" || (
		sys-devel/clang
		sys-devel/gcc
	)
	>=dev-util/cmake-3.4"
SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz"
RESTRICT="mirror"
DOCS=( readme.txt docs )

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_AND_STATIC_LIBS=$(usex static-libs)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	dodoc LICENSE.md
	use doc && einstalldocs
}
