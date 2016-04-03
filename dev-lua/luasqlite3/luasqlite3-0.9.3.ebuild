# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="LuaSQLite3"
HOMEPAGE="http://lua.sqlite.org"
SRC_URI="http://lua.sqlite.org/index.cgi/zip/lsqlite3_fsl09w.zip"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lua5_1 lua5_2"

RDEPEND="lua5_1? ( dev-lang/lua:5.1 )
	 lua5_2? ( dev-lang/lua:5.2 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lsqlite3_fsl09w"
REQUIRED_USE="^^ ( lua5_1 lua5_2 )"

src_configure() {
	true
}

src_compile() {
	gcc -DLSQLITE_VERSION=\"${PV}\" -fPIC -Wall -c lsqlite3.c || die
	gcc -shared -Wl,-soname,lsqlite3.so.0 \
		-o lsqlite3.so lsqlite3.o -lsqlite3
}

src_install() {
	luaver="5.1"
	if use lua5_1; then
		luaver="5.1"
	fi

	if use lua5_2; then
		luaver="5.2"
	fi

	mkdir -p "${D}/usr/$(get_libdir)/lua/${luaver}"
	cp lsqlite3.so "${D}/usr/$(get_libdir)/lua/${luaver}"
	cd "${D}/usr/$(get_libdir)/lua/${luaver}"
}
