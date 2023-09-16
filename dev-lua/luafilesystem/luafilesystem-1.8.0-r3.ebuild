# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )
inherit lua toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE+=" doc luajit test"
RESTRICT="!test? ( test )"
# See doc/us/index.html for current versions of lua supported
RDEPEND+="
	${LUA_DEPS}
	dev-lang/lua:*
	luajit? (
		dev-lang/luajit:2
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[pkg-config(+)]
	test? (
		${RDEPEND}
	)
"
MY_PV=${PV//./_}
SRC_URI="
https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	lua_src_prepare() {
		cp -a "${S}" "${S}_${ELUA}" || die
	}
	lua_foreach_impl lua_src_prepare
}

_gen_config() {
cat > "${BUILD_DIR}/config" <<-EOF
# Installation directories
# Default installation prefix
PREFIX="$(${CHOST}-pkg-config --variable exec_prefix ${pkgcfgpath})"
# System's libraries directory (where binary libraries are installed)
LUA_LIBDIR="$(${CHOST}-pkg-config --variable INSTALL_CMOD ${pkgcfgpath})"
# Lua includes directory
# OS dependent
LIB_OPTION=\$(LDFLAGS) -shared
LIBNAME=$T.so.$V
# Compilation directives
WARN=-O2 -Wall -fPIC -W -Waggregate-return -Wcast-align \
	-Wmissing-prototypes -Wnested-externs -Wshadow \
	-Wwrite-strings -pedantic
INCS=${LUA_INC[@]}
CFLAGS+=\$(WARN) \$(INCS)
CC=$(tc-getCC)
EOF
}

lua_src_configure()
{
	export BUILD_DIR="${S}_${ELUA}"
	cd "${BUILD_DIR}" || die
	local _pkgconfig="${CHOST}-pkg-config"
einfo "pkgconfig:\t${CHOST}-pkg-config"
	local lua_v=$(ver_cut 1-2 $(lua_get_version))
	local pkgcfgpath="${ESYSROOT}/usr/$(get_libdir)/pkgconfig/$(usex luajit luajit lua${lua_v}).pc"
	if [[ ! -e "${pkgcfgpath}" ]] ; then
eerror
eerror "You are missing ${pkgcfgpath}.  You must manually symlink."
eerror
		die
	fi
	LUA_INC=(
		-I"$(pwd)/src"
		-I$(${CHOST}-pkg-config --variable includedir ${pkgcfgpath})
	)
	_gen_config
}

src_configure() {
	lua_foreach_impl lua_src_configure
}

src_compile() {
	lua_src_compile()
	{
		export BUILD_DIR="${S}_${ELUA}"
		cd "${BUILD_DIR}" || die
		emake PKG_CONFIG_PATH="/usr/$(get_libdir)/pkgconfig"
	}
	lua_foreach_impl lua_src_compile
}

src_test() {
	lua_src_test() {
		export BUILD_DIR="${S}_${ELUA}"
		cd "${BUILD_DIR}" || die
		LUA_CPATH=./src/?.so $(usex luajit 'luajit' 'lua') \
			tests/test.lua || die
	}
	lua_foreach_impl lua_src_test
}

src_install() {
	lua_src_install() {
		export BUILD_DIR="${S}_${ELUA}"
		cd "${BUILD_DIR}" || die
		emake DESTDIR="${D}" install
	}
	lua_foreach_impl lua_src_install

	cd "${S}" || die
	use doc && local HTML_DOCS=( doc/us/. )
	einstalldocs
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:
