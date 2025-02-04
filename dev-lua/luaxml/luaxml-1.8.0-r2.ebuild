# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Partially based on luaxml-9999.ebuild from the lua overlay.
# The civetweb build scripts uses the same SRC_URI.

EAPI=8

MY_PN="LuaXML"

LUA_COMPAT=( "lua5-"{1..3} ) # See https://github.com/n1tehawk/LuaXML/#luaxml

inherit flag-o-matic lua

KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/n1tehawk/LuaXML/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A minimal set of XML processing funcs & simple XML<->Tables mapping"
HOMEPAGE="http://viremo.eludi.net/LuaXML/"
LICENSE="MIT"
SLOT="0"
IUSE+="
${LUA_COMPAT[@]/#/lua_targets_}
ebuild_revision_1
"
REQUIRED_USE+=" ${LUA_REQUIRED_USE}"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/luaxml-1.8.0-lua-lib-suffix.patch"
)
DOCS=( "README.md" )

src_prepare() {
	default
	lua_src_prepare() {
		cp -a \
			"${S}" \
			"${S}_${ELUA}" \
			|| die
	}
	lua_foreach_impl lua_src_prepare
}

src_configure() {
	lua_src_configure() {
		export BUILD_DIR="${S}_${ELUA}"
		cd "${BUILD_DIR}" || die
		local flags=$(get_abi_CFLAGS ${ABI})
		sed -i \
			-e "s|^CFLAGS = |CFLAGS = ${flags} |g" \
			-e "s|LFLAGS = |LFLAGS = ${flags} |g" \
			"Makefile" \
			|| die
	}
	lua_foreach_impl lua_src_configure
}

lua_src_compile() {
	export BUILD_DIR="${S}_${ELUA}"
	cd "${BUILD_DIR}" || die
	local myemakeargs=(
		LUA_INC="$(lua_get_CFLAGS)"
		LUA_VERSION="$(lua_get_version)"
		LUA_VERSION_MAJOR_MINOR=$(ver_cut 1-2 $(lua_get_version))
	)
	sed -i \
		-e "s|INCDIR = |INCDIR = $(lua_get_CFLAGS) |g" \
		-e "s|LIBDIR = |LIBDIR = -L/usr/$(get_libdir) |g" \
		"Makefile" \
		|| die
	emake ${myemakeargs[@]} all
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	export BUILD_DIR="${S}_${ELUA}"
	cd "${BUILD_DIR}" || die
	exeinto $(lua_get_cmod_dir)
	doexe "LuaXML_lib.so"
	local lua_pv=$(lua_get_version)

	# Fix linking issues
	dosym \
		"/usr/$(get_libdir)/lua/${lua_pv%.*}/LuaXML_lib.so" \
		"/usr/$(get_libdir)/lua/${lua_pv%.*}/libLuaXML_lib.so"
}

src_install() {
	lua_foreach_impl lua_src_install
	cd "${S}" || die
	dodoc ${DOCS[@]}
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:
