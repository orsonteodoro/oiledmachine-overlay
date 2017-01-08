# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="LuaXML"
HOMEPAGE="http://viremo.eludi.net/LuaXML/"
SRC_URI="http://viremo.eludi.net/LuaXML/LuaXML_130610.zip"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lua5_1 lua5_2"

RDEPEND="lua5_1? ( dev-lang/lua:5.1 )
	 lua5_2? ( dev-lang/lua:5.2 )
"
DEPEND="${RDEPEND}
"

S="${WORKDIR}"
REQUIRED_USE="^^ ( lua5_1 lua5_2 )"

src_prepare() {
	if use lua5_1; then
		sed -i -e "s|-llua52|-llua5.2|g" Makefile
		sed -i -e "s|-llua -ldl|-llua5.1 -ldl|g" Makefile
		sed -i -e 's|INCDIR =|INCDIR = -I /usr/include/lua5.1|' Makefile
	fi

	if use lua5_2; then
		sed -i -e "s|-llua -ldl|-llua5.2 -ldl|g" Makefile
		sed -i -e 's|INCDIR =|INCDIR = -I /usr/include/lua5.2|' Makefile
	fi

	eapply_user
}

src_compile() {
	emake || die
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
	cp LuaXML_lib.so "${D}/usr/$(get_libdir)/lua/${luaver}"

	dodoc readme.txt
}
