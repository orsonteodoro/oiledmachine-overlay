# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit multilib toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.com/luafilesystem/"
SRC_URI="mirror://github/keplerproject/luafilesystem/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="lua5_1 lua5_2"
REQUIRED_USE="^^ ( lua5_1 lua5_2 )"

DEPEND="lua5_1? ( dev-lang/lua:5.1 )
        lua5_2? ( dev-lang/lua:5.2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	LUA_VER="5.1"
	if use lua5_1; then
		LUA_VER="5.1"
	elif use lua5_2; then
		LUA_VER="5.2"
	fi

	sed -i \
		-e "s|gcc|$(tc-getCC)|" \
		-e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|-O2|${CFLAGS}|" \
		-e "/^LIB_OPTION/s|= |= ${LDFLAGS} |" \
		-e "s|lua/5.1|lua/${LUA_VER}|" \
		config || die
	if use lua5_2; then
		sed -i -e "s|luaL_reg fslib|luaL_Reg fslib|g" src/lfs.c || die
	fi
}

src_install() {
	emake PREFIX="${ED}usr" install || die
	dodoc README || die
	dohtml doc/us/* || die
}
