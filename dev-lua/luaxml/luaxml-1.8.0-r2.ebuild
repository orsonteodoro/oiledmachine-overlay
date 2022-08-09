# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Partially based on luaxml-9999.ebuild from the lua overlay
# For civetweb which uses the same SRC_URI

EAPI=8

LUA_COMPAT=( lua5-{1..3} ) # See https://github.com/n1tehawk/LuaXML/#luaxml
IS_MULTILIB=true

inherit flag-o-matic lua multilib-build

DESCRIPTION="A minimal set of XML processing funcs & simple XML<->Tables mapping"
HOMEPAGE="http://viremo.eludi.net/LuaXML/"
SRC_URI="https://github.com/n1tehawk/LuaXML/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE+=" ${LUA_COMPAT[@]/#/lua_targets_}" # for some reason the lua eclass is broken
REQUIRED_USE+=" ${LUA_REQUIRED_USE}"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
MY_PN="LuaXML"
S="${WORKDIR}/${MY_PN}-${PV}"
PATCHES=( "${FILESDIR}/luaxml-1.8.0-lua-lib-suffix.patch" )
DOCS=( README.md )

src_prepare() {
	default

	prepare_abi() {
		lua_src_prepare() {
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}" || die
		}
		lua_foreach_impl lua_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		lua_src_configure() {
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
			cd "${BUILD_DIR}" || die
			local flags=$(get_abi_CFLAGS ${ABI})
			sed -i -e "s|^CFLAGS = |CFLAGS = ${flags} |g" "Makefile" || die
			sed -i -e "s|LFLAGS = |LFLAGS = ${flags} |g" "Makefile" || die
		}
		lua_foreach_impl lua_src_configure
	}
	multilib_foreach_abi configure_abi
}

lua_src_compile() {
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
	cd "${BUILD_DIR}" || die
	local myemakeargs=(
		LUA_INC="$(lua_get_CFLAGS)"
		LUA_VERSION="$(lua_get_version)"
		LUA_VERSION_MAJOR_MINOR=$(ver_cut 1-2 $(lua_get_version))
	)
	sed -i \
		-e "s|INCDIR = |INCDIR = $(lua_get_CFLAGS) |g" \
		-e "s|LIBDIR = |LIBDIR = -L/usr/$(get_libdir) |g" \
		Makefile \
		|| die
	emake ${myemakeargs[@]} all
}

src_compile() {
	compile_abi() {
		lua_foreach_impl lua_src_compile
	}
	multilib_foreach_abi compile_abi
}

lua_src_install() {
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
	cd "${BUILD_DIR}" || die
	exeinto $(lua_get_cmod_dir)
	doexe LuaXML_lib.so
}

src_install() {
	install_abi() {
		lua_foreach_impl lua_src_install
	}
	multilib_foreach_abi install_abi
	cd "${S}" || die
	dodoc ${DOCS[@]}
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: multilib
