# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

MY_P=${P/pp/++}

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="http://webserver2.tecgraf.puc-rio.br/~celes/tolua/"
SRC_URI="http://webserver2.tecgraf.puc-rio.br/~celes/tolua/tolua-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="static"
REQUIRED_USE="static"

RDEPEND="dev-lang/lua"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e 's|LUA=/usr/local|LUA=/usr|' config
	if use static; then
		true
	else
		echo 'LDFLAGS= -shared -Wl,-fuse-ld=bfd' >> config
		#sed -i 's|LUAINC=$(LUA)/include|LUAINC=$(LUA)/include|' config
		sed -i -e 's|T= \$(TOLUA)/lib/libtolua.a|T= \$(TOLUA)/lib/libtolua.so|' src/lib/Makefile
		sed -i -e 's|\.o|.c|' src/lib/Makefile
		sed -i -e 's|OBJS=|OBJS = $(SRCS:.c=.o)\nSRCS=|' src/lib/Makefile
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|\$\(AR\) \$@ \$\(OBJS\)\n\t\$\(RANLIB\) \$@|$(CC) ${LDFLAGS} $^ -o $@\n%.o: %.c\n\t$(CC) $(CFLAGS) $< >$@ -llua5.2\n|' src/lib/Makefile
#		sed -i -e 's|CFLAGS= -g $(WARN) $(INC)|CFLAGS= -g $(WARN) $(INC) -fPIC|' config
		sed -i -e 's|CFLAGS= -g $(WARN) $(INC)|CFLAGS= $(INC) -fPIC|' config
#		sed -i -e 's|CPPFLAGS=  -g $(WARN) $(INC)|CPPFLAGS= -g $(WARN) $(INC) -fPIC|' config
		sed -i -e 's|CPPFLAGS=  -g $(WARN) $(INC)|CPPFLAGS= -g $(INC) -fPIC|' config
	fi
}

src_compile() {
	emake || die
}

src_install() {
	dobin bin/tolua || die "dobin failed"
	dobin bin/tolua_lua || die "dobin failed"
	if use static; then
		dolib.a lib/libtolua.a || die "dolib.a failed"
	else
		dolib.so lib/libtolua.so || die "dolib.so failed"
	fi
	insinto /usr/include
	doins include/tolua.h || die "doins failed"
	dodoc README
}
