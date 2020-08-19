# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal toolchain-funcs
DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="doc luajit test"
RESTRICT="!test? ( test )"
# See doc/us/index.html for current versions of lua supported
RDEPEND=">=dev-lang/lua-5.1:*[${MULTILIB_USEDEP}]
	 <=dev-lang/lua-5.4:*[${MULTILIB_USEDEP}]
	luajit? ( dev-lang/luajit:2 )"
BDEPEND="test? ( ${RDEPEND} )
	virtual/pkgconfig[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
MY_PV=${PV//./_}
SRC_URI=\
"https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local chost=$(get_abi_CHOST ${ABI})
	local _pkgconfig="${chost}-pkg-config"
	einfo "pkgconfig=${chost}-pkg-config"
	local pkgcfgpath="${EROOT}/usr/$(get_libdir)/pkgconfig/$(usex luajit 'luajit' 'lua').pc"
	if [[ ! -L "${pkgcfgpath}" ]] ; then
		die "You are missing ${pkgcfgpath}.  You must manually symlink it because eselect for lua is broken for multilib abi_x86_32."
	fi
	cat > "${BUILD_DIR}/config" <<-EOF
		# Installation directories
		# Default installation prefix
		PREFIX="$(${chost}-pkg-config --variable exec_prefix ${pkgcfgpath})"
		# System's libraries directory (where binary libraries are installed)
		LUA_LIBDIR="$(${chost}-pkg-config --variable INSTALL_CMOD ${pkgcfgpath})"
		# Lua includes directory
		LUA_INC=-I$(pwd)/src
		LUA_INC+=-I$(${chost}-pkg-config --variable includedir ${pkgcfgpath})
		# OS dependent
		LIB_OPTION=\$(LDFLAGS) -shared
		LIBNAME=$T.so.$V
		# Compilation directives
		WARN=-O2 -Wall -fPIC -W -Waggregate-return -Wcast-align \
			-Wmissing-prototypes -Wnested-externs -Wshadow \
			-Wwrite-strings -pedantic
		INCS=\$(LUA_INC)
		CFLAGS+=\$(WARN) \$(INCS)
		CC=$(tc-getCC)
	EOF
	einfo  "src_configure done"
}

multilib_src_compile() {
	export PKG_CONFIG_PATH="/usr/lib64/pkgconfig"
	cd "${BUILD_DIR}" || die
	emake
}

multilib_src_test() {
	LUA_CPATH=./src/?.so $(usex luajit 'luajit' 'lua') tests/test.lua || die
}

multilib_src_install() {
	use doc && local HTML_DOCS=( doc/us/. )
	einstalldocs
	emake DESTDIR="${D}" install
	docinto licenses
	dodoc LICENSE
}
