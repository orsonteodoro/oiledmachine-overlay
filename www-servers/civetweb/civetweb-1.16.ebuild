# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="server untrusted-data"
CMAKE_MAKEFILE_GENERATOR="emake"
# CMakeLists.txt lists versions
# See https://github.com/civetweb/civetweb/tree/v1.15/src/third_party
LUA_5_1_MIN="5.1.5"
LUA_5_2_MIN="5.2.4"
LUA_5_3_MIN="5.3.6"
LUA_5_4_MIN="5.4.3"
# Building with 5.1 is broken.
LUA_COMPAT=( "lua5-"{1..4} )
# CI uses U 14.04
LUA_IMPLS=(
	"5.1"
	"5.2"
	"5.3"
	"5.4"
)
LUA_PV_SUPPORTED=(
	"5.1.5"
	"5.2.4"
	"5.3.5"
	"5.4.0"
) # Upstream supported specifically

inherit cflags-hardened check-compiler-switch cmake flag-o-matic lua multilib-minimal sandbox-changes

KEYWORDS="~amd64 ~ppc ~x86"
S="${WORKDIR}/civetweb-${PV}"
SRC_URI="
https://github.com/civetweb/civetweb/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="CivetWeb is an embedded C++ web server"
HOMEPAGE="https://github.com/civetweb/civetweb"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LUA_COMPAT[@]/#/lua_targets_}
+asan +c11 c89 c99 cxx98 cxx11 +cxx14 +cgi gnu17 -cxx +caching debug doc
-duktape +ipv6 -lua -serve_no_files +server_executable -server_stats +ssl
static-libs -test -websockets -zlib
ebuild_revision_15
"
REQUIRED_USE+="
	lua? (
		!static-libs
		${LUA_REQUIRED_USE}
		gnu17
	)
	lua_targets_lua5-1? (
		lua
	)
	lua_targets_lua5-2? (
		lua
	)
	lua_targets_lua5-3? (
		lua
	)
	lua_targets_lua5-4? (
		lua
	)
	^^ (
		c11
		c89
		c99
		gnu17
	)
	^^ (
		cxx11
		cxx14
		cxx98
	)
	?? (
		lua_targets_lua5-1
		lua_targets_lua5-2
		lua_targets_lua5-3
		lua_targets_lua5-4
	)
"
gen_lua_targets() {
	for x in ${LUA_IMPLS[@]} ; do
		local v="LUA_${x/./_}_MIN"
		echo "
		lua_targets_lua${x/./-}? (
			>=dev-lang/lua-${!v}:${x}=[static-libs?]
			>=dev-lang/lua-extra-headers-${!v}:${x}=
		)
		"
	done
}
RDEPEND+="
	>=dev-db/sqlite-3.8.9:3[${MULTILIB_USEDEP}]
	virtual/libc
	ssl? (
		>=dev-libs/openssl-1.0[${MULTILIB_USEDEP}]
	)
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	lua? (
		$(gen_lua_targets)
		${LUA_DEPS}
		>=dev-db/sqlite-0.1.2[static-libs?]
		>=dev-lua/luafilesystem-1.6.3[${LUA_USEDEP}]
		>=dev-lua/luasqlite3-0.9.3[${LUA_USEDEP},static-libs?]
		>=dev-lua/luaxml-1.8[${LUA_USEDEP}]
	)
"
BDEPEND+="
	>=dev-build/cmake-3.3.0
	virtual/pkgconfig
"
DOCS=(
	"docs/Embedding.md"
	"docs/OpenSSL.md"
	"docs/UserManual.md"
	"README.md"
	"RELEASE_NOTES.md"
)
PATCHES=(
	"${FILESDIR}/civetweb-1.13-disable-pedantic-errors.patch"
	"${FILESDIR}/civetweb-1.13-change-cmake-for-lua-dependencies-v3.patch"
	"${FILESDIR}/civetweb-1.13-disable-fvisibility-for-c.patch"
)

pkg_setup() {
	check-compiler-switch_start
	if use lua_targets_lua5-3 || use lua_targets_lua5-4 ; then
ewarn "Lua >=5.3 support is for testing only."
	fi
	if use test ; then
ewarn "The test USE flag has not been tested yet."
		sandbox-changes_no_network_sandbox "For USE=test to download test dependencies"
	fi

	if use lua ; then
		local s
		for s in ${LUA_PV_SUPPORTED[@]} ; do
			local _s="${s%.*}"
			if use "lua_targets_lua${_s/./-}" && has_version "dev-lang/lua:$(ver_cut 1-2 ${s})" ; then
				local best_pv
				best_pv=$(best_version "dev-lang/lua:$(ver_cut 1-2 ${s})")
				best_pv=$(echo "${best_pv}" | cut -f 3- -d '-')
				best_pv=$(ver_cut 1-3 ${best_pv})
				if ver_test ${best_pv} -ne ${s} ; then
eerror
eerror "The system's Lua is not ${s}.  Disable the lua dep or emerge with same"
eerror "point release.  The package's supported version must be exact with the"
eerror "the installed version."
eerror
eerror "LUA slot:  ${s%.*}"
eerror "Installed version for slot:  ${best_pv}"
eerror "Package supported version for slot:  ${s}"
eerror
					die
				fi
			fi
		done
	fi

	if [[ -e "${ESYSROOT}/usr/include/lua.h" ]] ; then
eerror
eerror "${ESYSROOT}/usr/include/lua.h must be removed.  Switch lua"
eerror "implementation to alternative and back again via eselect."
eerror
		die
	fi
}

get_lib_types() {
	if use static-libs ; then
		echo "static"
	fi
	echo "shared"
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	if use lua ; then
		sed -i \
			-e 's|"lauxlib.h"|<lauxlib.h>|' \
			-e 's|"lua.h"|<lua.h>|' \
			-e 's|"lualib.h"|<lualib.h>|' \
			"src/third_party/civetweb_lua.h" \
			|| die
		rm -rf "src/third_party/lua-"* || die
	fi
	local nabis=0
	prepare_abi() {
		nabis=$((${nabis} + 1))
		local lib_type
		for lib_type in $(get_lib_types) ; do
			if multilib_is_native_abi && use lua ; then
				prepare_lua() {
					cp -a \
						"${S}" \
						"${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}" \
						|| die
				}
				lua_foreach_impl prepare_lua
			else
				cp -a \
					"${S}" \
					"${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" \
					|| die
			fi
		done
	}
	multilib_foreach_abi prepare_abi
}

WANT_LTO=0
_usex_lto() {
	if is-flagq '-flto*' || [[ "${WANT_LTO}" == "1" ]] ; then
		WANT_LTO=1
		echo "ON"
	else
		echo "OFF"
	fi
}

_configure() {
	cflags-hardened_append
	# CIVETWEB_CXX_STANDARD auto is c++14 > c++11 > c++98 depending on
	#   the compiler
	# CIVETWEB_C_STANDARD auto is c11 > c98 > c89 depending on compiler
	# CIVETWEB_LUA_VERSION is either 5.1.5 5.2.4 5.3.5 5.4.0 based
	#   on src/third_party/lua-<PV>

	export PKG_CONFIG_LIBDIR="${ESYSROOT}/usr/$(get_libdir)/pkgconfig"
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/share/pkgconfig"

	local mycmakeargs=(
		-D_GET_LIBDIR=$(get_libdir)
		-DCIVETWEB_BUILD_TESTING=$(usex test)
		-DCIVETWEB_C_STANDARD=$(usex gnu17 gnu17 \
			$(usex c11 c11 \
				$(usex c99 c99 \
					$(usex c89 c89 auto) \
				) \
			) \
		)
		-DCIVETWEB_CXX_ENABLE_LTO=$(_usex_lto)
		-DCIVETWEB_CXX_STANDARD=$(usex cxx14 cxx14 \
						$(usex cxx11 cxx11 \
							$(usex cxx98 cxx11 auto) \
						) \
					)
		-DCIVETWEB_DISABLE_CACHING=$(usex caching "OFF" "ON")
		-DCIVETWEB_DISABLE_CGI=$(usex cgi "OFF" "ON")
		-DCIVETWEB_ENABLE_ASAN=$(usex asan)
		-DCIVETWEB_ENABLE_CXX=$(usex cxx)
		-DCIVETWEB_ENABLE_DUKTAPE=$(usex duktape)
		-DCIVETWEB_ENABLE_LTO=$(_usex_lto)
		-DCIVETWEB_ENABLE_IPV6=$(usex ipv6)
		-DCIVETWEB_ENABLE_SERVER_EXECUTABLE=$(usex server_executable)
		-DCIVETWEB_ENABLE_SERVER_STATS=$(usex server_stats)
		-DCIVETWEB_ENABLE_WEBSOCKETS=$(usex websockets)
		-DCIVETWEB_ENABLE_ZLIB=$(usex zlib)
		-DCIVETWEB_SERVE_NO_FILES=$(usex serve_no_files)
	)

	if multilib_is_native_abi ; then
		mycmakeargs+=(
			-DCIVETWEB_ENABLE_LUA=$(usex lua)
		)
	else
		mycmakeargs+=(
			-DCIVETWEB_ENABLE_LUA=OFF
		)
	fi

	filter-lto

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if has_version "dev-libs/openssl:0/3" ; then
		mycmakeargs+=(
			-DCIVETWEB_SSL_OPENSSL_API_1_0=OFF
			-DCIVETWEB_SSL_OPENSSL_API_1_1=OFF
			-DCIVETWEB_SSL_OPENSSL_API_3_0=ON
		)
	elif has_version "dev-libs/openssl:0/1.1" ; then
		mycmakeargs+=(
			-DCIVETWEB_SSL_OPENSSL_API_1_0=OFF
			-DCIVETWEB_SSL_OPENSSL_API_1_1=ON
			-DCIVETWEB_SSL_OPENSSL_API_3_0=OFF
		)
	elif has_version "dev-libs/openssl:0" ; then
		mycmakeargs+=(
			-DCIVETWEB_SSL_OPENSSL_API_1_0=ON
			-DCIVETWEB_SSL_OPENSSL_API_1_1=OFF
			-DCIVETWEB_SSL_OPENSSL_API_3_0=OFF
		)
	else
		mycmakeargs+=(
			-DCIVETWEB_SSL_OPENSSL_API_1_0=OFF
			-DCIVETWEB_SSL_OPENSSL_API_1_1=OFF
			-DCIVETWEB_SSL_OPENSSL_API_3_0=OFF
		)
	fi
	if [[ "${lib_type}" == "shared" ]] ;then
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=ON
			-DCIVETWEB_LUA_STATIC=OFF
		)
	else
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=OFF
			-DCIVETWEB_LUA_STATIC=ON
		)
	fi
	if multilib_is_native_abi && use lua ; then
		local lua_pv=$(lua_get_version)
		local lua_pv2=${lua_pv%.*}
		local cdir=$(lua_get_cmod_dir)
		local inc=$(lua_get_include_dir)
		mycmakeargs+=(
			-DCIVETWEB_LUA_VERSION=${lua_pv}
			-DCIVETWEB_LUA_VERSION_MAJOR_MINOR=${lua_pv2}
			-DLUA_CDIR="${cdir}"
			-DLUA_INC="${inc}"
		)
einfo "LUA:  ON (ABI=${ABI})"
	else
einfo "LUA:  OFF (ABI=${ABI})"
	fi
	cmake_src_configure
}

src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			if multilib_is_native_abi && use lua ; then
				configure_lua() {
					export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}"
					export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}_build"
					cd "${CMAKE_USE_DIR}" || die
					_configure
				}
				lua_foreach_impl configure_lua
			else
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
				cd "${CMAKE_USE_DIR}" || die
				_configure
			fi
		done
	}
	multilib_foreach_abi configure_abi
}

_compile() {
	cd "${BUILD_DIR}" || die
	SUFFIX="_${ABI}_${ESTSH_LIB_TYPE}"
	if multilib_is_native_abi && use lua ; then
		SUFFIX+="_${ELUA}"
	fi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			if multilib_is_native_abi && use lua ; then
				compile_lua() {
					export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}"
					export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}_build"
					cd "${BUILD_DIR}" || die
					cmake_src_compile
				}
				lua_foreach_impl compile_lua
			else
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
				cd "${BUILD_DIR}" || die
				_compile
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			if multilib_is_native_abi && use lua ; then
				install_lua() {
					export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}"
					export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${ELUA}_build"
					cd "${BUILD_DIR}" || die
					cmake_src_install
				}
				lua_foreach_impl install_lua
			else
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
				cd "${BUILD_DIR}" || die
				cmake_src_install
			fi
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi

	if use lua ; then
		local libdir=$(get_libdir)
		local s
		if use lua_targets_lua5-1 ; then
			s="5.1"
		elif use lua_targets_lua5-2 ; then
			s="5.2"
		elif use lua_targets_lua5-3 ; then
			s="5.3"
		elif use lua_targets_lua5-4 ; then
			s="5.4"
		fi
	einfo "Fixing ${ED}/usr/${libdir}/cmake/civetweb/civetweb-targets.cmake"
		sed \
			-i \
			-e "s|;lua5.1|;lua5.1|g" \
			-e "s|;lfs_lib|;lfs|g" \
			-e "s|;lsqlite3_lib|;lsqlite3|g" \
			-e "s|;luaxml_lib|;LuaXML_lib|g" \
			-e "s|;sqlite_lib|;sqlite3|g" \
			"${ED}/usr/${libdir}/cmake/civetweb/civetweb-targets.cmake" \
			|| die
		sed \
			-i \
			-e "73i\ \ INTERFACE_LINK_DIRECTORIES \"/usr/lib64/lua/${s}\"" \
			"${ED}/usr/${libdir}/cmake/civetweb/civetweb-targets.cmake" \
			|| die
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib, lua-support, static-libs
