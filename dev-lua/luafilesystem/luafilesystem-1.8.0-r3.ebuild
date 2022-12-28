# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-{1..4} )
inherit lua multilib-minimal toolchain-funcs
DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="doc luajit test"

RESTRICT="!test? ( test )"
# See doc/us/index.html for current versions of lua supported
RDEPEND="${LUA_DEPS}
	dev-lang/lua:*[${MULTILIB_USEDEP}]
	luajit? ( dev-lang/luajit:2 )"
BDEPEND="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? ( ${RDEPEND} )"
DEPEND="${RDEPEND}"
MY_PV=${PV//./_}
SRC_URI=\
"https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	prepare_abi()
	{
		lua_src_prepare() {
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}" || die
		}
		lua_foreach_impl lua_src_prepare
	}
        multilib_foreach_abi prepare_abi
}

lua_src_configure()
{
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
	cd "${BUILD_DIR}" || die
	local chost=$(get_abi_CHOST ${ABI})
	local _pkgconfig="${chost}-pkg-config"
	einfo "pkgconfig=${chost}-pkg-config"
	local lua_v=$(ver_cut 1-2 $(lua_get_version))
	local pkgcfgpath="${EROOT}/usr/$(get_libdir)/pkgconfig/$(usex luajit luajit lua${lua_v}).pc"
	if [[ ! -e "${pkgcfgpath}" ]] ; then
		die \
"You are missing ${pkgcfgpath}.  You must manually symlink it because eselect \
for lua is broken for multilib abi_x86_32."
	fi
	LUA_INC=("-I$(pwd)/src")
	LUA_INC+=(" -I$(${chost}-pkg-config --variable includedir ${pkgcfgpath})")
	cat > "${BUILD_DIR}/config" <<-EOF
		# Installation directories
		# Default installation prefix
		PREFIX="$(${chost}-pkg-config --variable exec_prefix ${pkgcfgpath})"
		# System's libraries directory (where binary libraries are installed)
		LUA_LIBDIR="$(${chost}-pkg-config --variable INSTALL_CMOD ${pkgcfgpath})"
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
	einfo  "src_configure done"
}

src_configure() {
	configure_abi()
	{
		lua_foreach_impl lua_src_configure
	}
        multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi()
	{
		lua_src_compile()
		{
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
			cd "${BUILD_DIR}" || die
			emake PKG_CONFIG_PATH="/usr/$(get_libdir)/pkgconfig"
		}
		lua_foreach_impl lua_src_compile
	}
        multilib_foreach_abi compile_abi
}

src_test() {
	test_abi()
	{
		lua_src_test() {
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
			cd "${BUILD_DIR}" || die
			LUA_CPATH=./src/?.so $(usex luajit 'luajit' 'lua') \
				tests/test.lua || die
		}
		lua_foreach_impl lua_src_test
	}
        multilib_foreach_abi test_abi
}

src_install() {
	install_abi()
	{
		lua_src_install() {
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${ELUA}"
			cd "${BUILD_DIR}" || die
			emake DESTDIR="${D}" install
		}
		lua_foreach_impl lua_src_install
		multilib_check_headers
	}
        multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	use doc && local HTML_DOCS=( doc/us/. )
	einstalldocs
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
