# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CivetWeb is an embedded C++ web server"
HOMEPAGE="https://github.com/civetweb"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cgi cpp debug doc ipv6 ssl static websocket"
LUA_VER="5.2"
inherit cmake-static-libs multilib-minimal
REQUIRED_USE+=" static-libs? ( static )"
RDEPEND="dev-db/sqlite:3[${MULTILIB_USEDEP}]
	 dev-lang/lua:${LUA_VER}=[static=,civetweb]
	 dev-lua/luafilesystem
	 dev-lua/luasqlite3"
DEPEND="${RDEPEND}"
SRC_URI="\
https://github.com/civetweb/civetweb/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils flag-o-matic
S="${WORKDIR}/civetweb-${PV}"
PATCHES=( "${FILESDIR}/${PN}-1.12-cflags.patch" )
DOCS=( docs/Embedding.md docs/OpenSSL.md README.md RELEASE_NOTES.md \
docs/UserManual.md )

src_prepare() {
	default
	multilib_copy_sources
	prepare_abi() {
		cmake-static-libs_copy_sources
		cd "${BUILD_DIR}" || die
		prepare_impl() {
			cd "${BUILD_DIR}" || die
			sed -i -e "s|__LUA_VER__|${LUA_VER}|g" Makefile || die
			sed -i -e "s|lib64|$(get_libdir)|g" Makefile || die
		}
		cmake-static-libs_foreach_impl prepare_impl
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		cmake-static-libs_copy_sources
		cd "${BUILD_DIR}" || die
		configure_impl() {
			cd "${BUILD_DIR}" || die
			if use ssl ; then
				sed -i \
			-e "s|__LIBSSL__|$(pkg-config --libs openssl)|g" \
					Makefile || die
			fi
		}
		cmake-static-libs_foreach_impl configure_impl
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_impl() {
			cd "${BUILD_DIR}" || die
			local myuse=()
			local mycopt=""
			local mystatic=""
			myuse+=( $(usex ssl "SSL_LIB=libssl" "") )
			myuse+=( $(usex cpp "WITH_CPP=1" \
				"WITH_CPP=0") )
			myuse+=( $(usex debug "WITH_DEBUG=1" \
				"WITH_DEBUG=0") )
			myuse+=( $(usex ipv6 "WITH_IPV6=1" \
				"WITH_IPV6=0") )
			myuse+=( $(usex static-libs "WITH_LUA=1" \
				"WITH_LUA_SHARED=1") )
			myuse+=( "WITH_LUA_VERSION=502" )
			mycopt+=$(usex debug "-DDEBUG" \
				"-DNDEBUG")" "
			mycopt+=$(usex cgi "" "-DNO_CGI")" "
			mycopt+=$(usex ssl "-DNO_SSL_DL" "-DNO_SSL")" "
			if [[ "${ABI}" == "amd64" ]] ; then
				append-cflags -fPIC
			fi
			if [[ "${ECMAKE_LIB_TYPE}" == "static-libs" ]] ; then
				mystatic="lib"
			else
				mystatic="slib"
			fi
			make build ${mystatic} ${myuse[@]} COPT="${mycopt}" || die
		}
		cmake-static-libs_foreach_impl compile_impl
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}" || die
		install_impl() {
			cd "${BUILD_DIR}" || die
			emake PREFIX="${D}/usr" install
			if [[ "${ECMAKE_LIB_TYPE}" == "static-libs" ]] ; then
				dolib.a libcivetweb.a
			else
				dolib.so libcivetweb.so.${PV}.0
				cd "${D}/usr/$(get_libdir)" || die
				ln -s libcivetweb.so.${PV}.0 \
					libcivetweb.so.1 || die
				ln -s libcivetweb.so.1 \
					libcivetweb.so || die
			fi
			cd "${BUILD_DIR}" || die
			insinto "/usr/include/${PN}"
			doins include/*
		}
		cmake-static-libs_foreach_impl install_impl
	}
	multilib_foreach_abi install_abi
}
