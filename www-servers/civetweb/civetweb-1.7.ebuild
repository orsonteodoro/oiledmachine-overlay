# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="CivetWeb"
HOMEPAGE="https://github.com/civetweb"
SRC_URI="https://github.com/civetweb/civetweb/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="${PV:0:3}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ipv6 debug websocket cpp ssl cgi abi_x86_64 static"

LUA_VER="5.2"
RDEPEND="dev-db/sqlite:3
	 dev-lang/lua:${LUA_VER}[static=]
	 dev-lua/luafilesystem[lua5_2]
	 dev-lua/luaxml[lua5_2]
	 dev-lua/luasqlite3[lua5_2]
	 "
DEPEND="${RDEPEND}"

S="${WORKDIR}/civetweb-${PV}"

src_prepare() {
	sed -i -e "s|include resources/Makefile.in-lua|CFLAGS += -I/usr/include/lua${LUA_VER} \nLIBS += -llua${LUA_VER} /usr/$(get_libdir)/lua/${LUA_VER}/lfs.so /usr/$(get_libdir)/lua/${LUA_VER}/LuaXML_lib.so -lsqlite3 /usr/$(get_libdir)/lua/${LUA_VER}/lsqlite3.so \nCFLAGS += -DLUA_COMPAT_ALL -DUSE_LUA -DLUA_USE_POSIX -DLUA_USE_DLOPEN -DTHREADSAFE=1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DUSE_LUA_SQLITE3 -DUSE_LUA_FILE_SYSTEM -DUSE_LUA_LUAXML\n|" Makefile
}

src_configure() {
	true
}

src_compile() {
	myuse=""
	if ! use static; then
		myuse+="WITH_LUA=1 "
	else
		myuse+="WITH_LUA_SHARED=1"
	fi
	if use debug; then
		myuse+="WITH_DEBUG=1 "
	else
		myuse+="WITH_DEBUG=0 "
	fi
	if use ipv6; then
		myuse+="WITH_IPV6=1 "
	else
		myuse+="WITH_IPV6=0 "
	fi
	if use cpp; then
		myuse+="WITH_CPP=1 "
	else
		myuse+="WITH_CPP=0 "
	fi

	mycopt=""
	if use debug; then
		mycopt+="-DNDEBUG "
	else
		mycopt+="-DDEBUG "
	fi

	if use cgi; then
		true
	else
		mycopt+="-DNO_CGI "
	fi

	if use ssl; then
		mycopt+="-DNO_SSL_DL "
	else
		mycopt+="-DNO_SSL "
	fi

	if use abi_x86_64; then
		CFLAGS+="${CFLAGS} -fPIC"
	else
		true
	fi

	mystatic="slib"
	if use static; then
		mystatic="lib"
	else
		mystatic="slib"
	fi

	make build slib ${myuse} COPT="${mycopt}"
}

src_install() {
	emake PREFIX="${D}" install
	mkdir -p "${D}/usr/$(get_libdir)"
	cp libcivetweb.so.1.7.0 "${D}/usr/$(get_libdir)"
	cd "${D}/usr/$(get_libdir)"
	if use static; then
		true
	else
		ln -s libcivetweb.so.1.7.0 libcivetweb.so.1
		ln -s libcivetweb.so.1 libcivetweb.so
	fi
	cd "${S}"
	dodoc RELEASE_NOTES.md README.md
	cd docs
	dodoc UserManual.md Embedding.md OpenSSL.md
	mkdir -p "${D}/usr/include/${PN}"
	cd ..
	cp include/* "${D}/usr/include/${PN}"
}
