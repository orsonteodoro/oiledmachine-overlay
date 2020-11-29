# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CivetWeb is an embedded C++ web server"
HOMEPAGE="https://github.com/civetweb"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+asan +c11 c89 c99 c++98 c++11 +c++14 +cgi gnu17 urho3d -cxx +caching \
debug doc -duktape -ipv6 -lto -lua -serve_no_files +server_executable \
-server_stats +ssl ssl_1_0 +ssl_1_1 static -test -websockets"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	lua? ( gnu17 )
	ssl? ( ^^ ( ssl_1_0 ssl_1_1 ) )
	^^ ( c11 c89 c99 gnu17 )
	^^ ( c++98 c++11 c++14 )"
LUA_COMPAT=( lua5-{2..4} )
inherit cmake-static-libs cmake-utils lua multilib-minimal
# CMakeLists.txt lists versions
RDEPEND=">=dev-db/sqlite-3.8.9:3[${MULTILIB_USEDEP}]
	 lua? (
		${LUA_DEPS}
		urho3d? (
			lua_targets_lua5-2? (
		>=dev-lang/lua-5.2.4:5.2=[${MULTILIB_USEDEP},static=,civetweb]
			)
		)
		>=dev-lua/luafilesystem-1.6.3[${MULTILIB_USEDEP},${LUA_USEDEP}]
		>=dev-lua/luasqlite3-0.9.3[${MULTILIB_USEDEP},${LUA_USEDEP}]
		>=dev-lua/luaxml-1.8[${LUA_USEDEP}]
	 )
	 ssl? (
		ssl_1_1? ( =dev-libs/openssl-1.1*[${MULTILIB_USEDEP}] )
		ssl_1_0? (
			|| (
				=dev-libs/openssl-1.0*[${MULTILIB_USEDEP}]
				dev-libs/openssl-compat:1.0.0[${MULTILIB_USEDEP}]
			)
		)
	 )"
DEPEND="${RDEPEND}"
SRC_URI="\
https://github.com/civetweb/civetweb/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils flag-o-matic
S="${WORKDIR}/civetweb-${PV}"
DOCS=( docs/Embedding.md docs/OpenSSL.md README.md RELEASE_NOTES.md \
docs/UserManual.md )
_PATCHES=(
	"${FILESDIR}/civetweb-1.13-disable-pedantic-errors.patch"
	"${FILESDIR}/civetweb-1.13-change-cmake-for-lua-dependencies.patch"
	"${FILESDIR}/civetweb-1.13-disable-fvisibility-for-c.patch"
)

pkg_setup() {
	if use lua_targets_lua5-3 ; then
		ewarn "Lua 5.3 support is for testing only"
	fi
	if use test ; then
		ewarn "The test USE flag has not been tested yet."
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to\n\
download test dependencies."
		fi
	fi

	V_SLOT=( 5.1.5 5.2.4 5.3.5 5.4.0 )
	for s in ${V_SLOT[@]} ; do
		if has_version "dev-lang/lua:$(ver_cut 1-2 ${s})" ; then
			best_v=$(best_version "dev-lang/lua:$(ver_cut 1-2 ${s})")
			best_v=$(echo "${best_v}" | cut -f 3- -d '-')
			best_v=$(ver_cut 1-3 ${best_v})
			if ver_test ${best_v} -ne ${s} ; then
				die \
"The system's Lua is not ${s}.  Disable the lua dep or emerge with same point \
release."
			fi
		fi
	done
}

_prepare() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_prepare
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		cmake-static-libs_copy_sources
		prepare_stsh()
		{
			cd "${BUILD_DIR}" || die
			if use lua ; then
				lua_copy_sources
				lua_foreach_impl _prepare
			else
				_prepare
			fi
		}
		cmake-static-libs_foreach_impl prepare_stsh
	}
	multilib_foreach_abi prepare_abi
}

_configure() {
	cd "${BUILD_DIR}" || die
	# CIVETWEB_CXX_STANDARD auto is c++14 > c++11 > c++98 depending on
	#   the compiler
	# CIVETWEB_C_STANDARD auto is c11 > c98 > c89 depending on compiler
	# CIVETWEB_LUA_VERSION is either 5.1.5 5.2.4 5.3.5 5.4.0 based
	#   on src/third_party/lua-<PV>

	local mycmakeargs=(
		-D_GET_LIBDIR=$(get_libdir)
		-DCIVETWEB_BUILD_TESTING=$(usex test)
		-DCIVETWEB_C_STANDARD=$(usex gnu17 gnu17 \
			$(usex c11 c11 \
			$(usex c99 c99 \
			$(usex c89 c89 auto))))
		-DCIVETWEB_CXX_ENABLE_LTO=$(usex lto)
		-DCIVETWEB_CXX_STANDARD=$(usex c++14 c++14 \
						$(usex c++11 c++11 \
						$(usex c++98 c++11 auto)))
		-DCIVETWEB_ENABLE_SERVER_EXECUTABLE=$(usex server_executable)
		-DCIVETWEB_DISABLE_CACHING=$(usex caching "OFF" "ON")
		-DCIVETWEB_DISABLE_CGI=$(usex cgi "OFF" "ON")
		-DCIVETWEB_ENABLE_ASAN=$(usex asan)
		-DCIVETWEB_ENABLE_CXX=$(usex cxx)
		-DCIVETWEB_ENABLE_DUKTAPE=$(usex duktape)
		-DCIVETWEB_ENABLE_LTO=$(usex lto)
		-DCIVETWEB_ENABLE_LUA=$(usex lua)
		-DCIVETWEB_ENABLE_LUA_SHARED=$(usex lua)
		-DCIVETWEB_ENABLE_IPV6=$(usex ipv6)
		-DCIVETWEB_ENABLE_SERVER_STATS=$(usex server_stats)
		-DCIVETWEB_ENABLE_WEBSOCKETS=$(usex websockets)
		-DCIVETWEB_SERVE_NO_FILES=$(usex serve_no_files)
		-DCIVETWEB_ENABLE_LUA_FILESYSTEM_SHARED=$(usex lua)
		-DCIVETWEB_ENABLE_LUA_SQLITE_SHARED=$(usex lua)
		-DCIVETWEB_ENABLE_LUA_XML_SHARED=$(usex lua)
		-DCIVETWEB_ENABLE_SQLITE_SHARED=$(usex lua)
		-DCIVETWEB_LUA_VERSION=$(lua_get_version)
		-DLUA_CDIR="$(lua_get_cmod_dir)"
	)
	cmake-utils_src_configure
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}" || die
		configure_stsh()
		{
			cd "${BUILD_DIR}" || die
			if use lua ; then
				lua_foreach_impl _configure
			else
				_configure
			fi
		}
		cmake-static-libs_foreach_impl configure_stsh
	}
	multilib_foreach_abi configure_abi
}

_compile() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_compile
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_stsh()
		{
			cd "${BUILD_DIR}" || die
			if use lua ; then
				lua_foreach_impl _compile
			else
				_compile
			fi
		}
		cmake-static-libs_foreach_impl compile_stsh
	}
	multilib_foreach_abi compile_abi
}

_install() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_install
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_stsh()
		{
			cd "${BUILD_DIR}" || die
			if use lua ; then
				lua_foreach_impl _install
			else
				_install
			fi
		}
		cmake-static-libs_foreach_impl install_stsh
	}
	multilib_foreach_abi install_abi
}
