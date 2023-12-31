# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )
inherit lua toolchain-funcs

DESCRIPTION="LuaSQLite3"
HOMEPAGE="http://lua.sqlite.org"
LICENSE="all-rights-reserved MIT"
# The vanilla MIT license template does not include all rights reserved.
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc static-libs"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${DEPEND}
	${LUA_DEPS}
	dev-db/sqlite:3[static-libs?]
	dev-lang/lua:*
"
DEPEND="
	${RDEPEND}
"
MY_PN="lsqlite3_v096"
S="${WORKDIR}/${MY_PN}"
SRC_URI="http://lua.sqlite.org/index.cgi/zip/${MY_PN}.zip"
DOCS=( HISTORY README )

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

src_prepare() {
	default
	local lib_type
	for lib_type in $(get_lib_types) ; do
		lua_src_prepare() {
			cp -a "${S}" "${S}_${lib_type}_${ELUA}" || die
		}
		lua_foreach_impl lua_src_prepare
	done
}

src_configure() {
	:;
}

lua_src_compile()
{
	export BUILD_DIR="${S}_${lib_type}_${ELUA}"
	cd "${BUILD_DIR}"
	export CC=$(tc-getCC ${ABI})
	mkdir -p "shared" || die
einfo "ELUA:\t${ELUA}"
einfo "Building shared-lib"
	${CC} -I$(lua_get_include_dir) \
		-DLSQLITE_VERSION=\"${PV}\" \
		-fPIC \
		-Wall \
		-c lsqlite3.c \
		-o shared/lsqlite3.o \
		|| die
einfo "Linking shared-lib"
	${CC} -shared -Wl,-soname,lsqlite3.so.0 \
		-o shared/lsqlite3.so \
		shared/lsqlite3.o \
		-lsqlite3 \
		|| die
	if use static-libs ; then
einfo "Building static-lib"
		mkdir -p "static" || die
		${CC} -I$(lua_get_include_dir) \
			-DLSQLITE_VERSION=\"${PV}\" \
			-Dluaopen_lsqlite3=luaopen_lsqlite3complete \
			-fPIC \
			-Wall \
			-c sqlite3.c \
			-o static/sqlite3.o \
			|| die
		${CC} -I$(lua_get_include_dir) \
			-DLSQLITE_VERSION=\"${PV}\" \
			-Dluaopen_lsqlite3=luaopen_lsqlite3complete \
			-fPIC \
			-Wall \
			-c lsqlite3.c \
			-o static/lsqlite3.o \
			|| die
einfo "Linking static-lib"
		ar rcs \
			static/lsqlite3complete.a \
			static/lsqlite3.o \
			static/sqlite3.o || die
	fi
}

src_compile() {
	local lib_type
	for lib_type in $(get_lib_types) ; do
		lua_foreach_impl lua_src_compile
	done
}

src_install() {
	local lib_type
	for lib_type in $(get_lib_types) ; do
		lua_src_install()
		{
			export BUILD_DIR="${S}_${lib_type}_${ELUA}"
			cd "${BUILD_DIR}" || die
			exeinto $(lua_get_cmod_dir)
			doexe shared/lsqlite3.so
			if use static-libs ; then
				insinto $(lua_get_cmod_dir)
				doins static/lsqlite3complete.a
			fi
		}
		lua_foreach_impl lua_src_install
		dodoc doc/lsqlite3.wiki
	done
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:
