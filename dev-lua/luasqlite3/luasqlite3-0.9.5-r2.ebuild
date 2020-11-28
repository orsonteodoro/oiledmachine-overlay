# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="LuaSQLite3"
HOMEPAGE="http://lua.sqlite.org"
LICENSE="all-rights-reserved MIT"
# The vanilla MIT license does not include all rights reserved.
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0/${PV}"
IUSE="doc static-libs"
LUA_COMPAT=( lua5-{1..4} )
inherit lua multilib-minimal
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}
	dev-db/sqlite:3[${MULTILIB_USEDEP},static-libs?]
	dev-lang/lua:*[${MULTILIB_USEDEP}]
	${DEPEND}"
DEPEND="${RDEPEND}"
S="${WORKDIR}/lsqlite3_fsl09y"
inherit eutils toolchain-funcs
SRC_URI="http://lua.sqlite.org/index.cgi/zip/lsqlite3_fsl09y.zip"
DOCS=( HISTORY README )

src_prepare() {
	default
	multilib_copy_sources
	prepare_abi()
	{
		einfo "Preparing..."
		cd "${BUILD_DIR}" || die
		lua_copy_sources
	}
        multilib_foreach_abi prepare_abi
}

src_configure() {
	:;
}

lua_src_compile()
{
	local chost=$(get_abi_CHOST ${ABI})
	cd "${BUILD_DIR}" || die
	CC=$(tc-getCC ${ABI})
	mkdir -p "shared" || die
	einfo "ELUA=${ELUA}"
	einfo "Building shared"
	${CC} -I$(lua_get_include_dir) -DLSQLITE_VERSION=\"${PV}\" -fPIC -Wall \
		-c lsqlite3.c \
		-o shared/lsqlite3.o || die
	einfo "Linking shared"
	${CC} -shared -Wl,-soname,lsqlite3.so.0 \
		-o shared/lsqlite3.so \
		shared/lsqlite3.o \
		-lsqlite3 || die
	if use static-libs ; then
		einfo "Building static"
		mkdir -p "static" || die
		${CC} -I$(lua_get_include_dir) -DLSQLITE_VERSION=\"${PV}\" \
			-Dluaopen_lsqlite3=luaopen_lsqlite3complete -fPIC \
			-Wall \
			-c sqlite3.c \
			-o static/sqlite3.o || die
		${CC} -I$(lua_get_include_dir) -DLSQLITE_VERSION=\"${PV}\" \
			-Dluaopen_lsqlite3=luaopen_lsqlite3complete -fPIC \
			-Wall \
			-c lsqlite3.c \
			-o static/lsqlite3.o || die
		einfo "Linking static"
		ar rcs static/lsqlite3complete.a \
			static/lsqlite3.o \
			static/sqlite3.o || die
	fi
}

src_compile() {
	compile_abi()
	{
		cd "${BUILD_DIR}" || die
		lua_foreach_impl lua_src_compile
	}
        multilib_foreach_abi compile_abi
}

src_install() {
	install_abi()
	{
		cd "${BUILD_DIR}" || die
		lua_src_install()
		{
			cd "${BUILD_DIR}" || die
			exeinto $(lua_get_cmod_dir)
			doexe shared/lsqlite3.so
			insinto $(lua_get_cmod_dir)
			doins static/lsqlite3complete.a
		}
		lua_foreach_impl lua_src_install
		dodoc doc/lsqlite3.wiki
	}
        multilib_foreach_abi install_abi
}
