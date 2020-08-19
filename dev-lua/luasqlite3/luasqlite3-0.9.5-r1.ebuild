# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="LuaSQLite3"
HOMEPAGE="http://lua.sqlite.org"
LICENSE="all-rights-reserved MIT"
# The vanilla MIT license does not include all rights reserved.
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0/${PV}"
IUSE="doc"
inherit multilib-minimal
RDEPEND=">=dev-lang/lua-5.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
S="${WORKDIR}/lsqlite3_fsl09y"
inherit eutils toolchain-funcs
SRC_URI="http://lua.sqlite.org/index.cgi/zip/lsqlite3_fsl09y.zip"
DOCS=( HISTORY README )

src_configure() {
	:;
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	CC=$(tc-getCC ${ABI})
	${CC} -DLSQLITE_VERSION=\"${PV}\" -fPIC -Wall -c lsqlite3.c || die
	${CC} -shared -Wl,-soname,lsqlite3.so.0 \
		-o lsqlite3.so lsqlite3.o -lsqlite3 || die
}

multilib_src_install() {
	dolib.so lsqlite3.so
	dodoc doc/lsqlite3.wiki
}
