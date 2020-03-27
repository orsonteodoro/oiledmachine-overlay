# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="CivetWeb is an embedded C++ web server"
HOMEPAGE="https://github.com/civetweb"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cgi cpp debug doc ipv6 +shared ssl static websocket"
LUA_VER="5.2"
inherit multilib-minimal
RDEPEND="dev-db/sqlite:3[${MULTILIB_USEDEP}]
	 dev-lang/lua:${LUA_VER}[static=,civetweb]
	 dev-lua/luafilesystem
	 dev-lua/luasqlite3"
DEPEND="${RDEPEND}"
SRC_URI="\
https://github.com/civetweb/civetweb/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit civetweb eutils flag-o-matic
S="${WORKDIR}/civetweb-${PV}"
PATCHES=( "${FILESDIR}/${PN}-1.12-cflags.patch" )
DOCS=( docs/Embedding.md docs/OpenSSL.md README.md RELEASE_NOTES.md \
docs/UserManual.md )

src_prepare() {
	default
	multilib_copy_sources
	prepare_abi() {
		cd "${BUILD_DIR}" || die
		prepare_impl() {
			cd "${BUILD_DIR}" || die
			sed -i -e "s|__LUA_VER__|${LUA_VER}|g" Makefile || die
			sed -i -e "s|lib64|$(get_libdir)|g" Makefile || die
		}
		civetweb_foreach_impl prepare_impl
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	:;
}

src_compile() {
	compile_abi() {
		cd "${BUILD_DIR}" || die
		compile_impl() {
			cd "${BUILD_DIR}" || die
			local myuse=""
			local mycopt=""
			local mystatic=""
			myuse+=" "$(usex static "WITH_LUA=1" \
				"WITH_LUA_SHARED=1")
			myuse+=" "$(usex debug "WITH_DEBUG=1" \
				"WITH_DEBUG=0")
			myuse+=" "$(usex ipv6 "WITH_IPV6=1" \
				"WITH_IPV6=0")
			myuse+=" "$(usex cpp "WITH_CPP=1" \
				"WITH_CPP=0")
			mycopt=" "$(usex debug "-DNDEBUG" \
				"-DDEBUG")
			mycopt=" "$(usex cgi "" "-DNO_CGI")
			mycopt=" "$(usex ssl "-DNO_SSL_DL" "-DNO_SSL")
			if [[ "${ABI}" == "amd64" ]] ; then
				append-cflag -fPIC
			fi
			mystatic="slib"
			mystatic=" "$(usex static "lib" "slib")
			emake build ${mystatic} ${myuse} COPT="${mycopt}"
		}
		civetweb_foreach_impl compile_impl
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		cd "${BUILD_DIR}"
		install_impl() {
			cd "${BUILD_DIR}" || die
			emake PREFIX="${D}" install
			dolib.so libcivetweb.so.${PV}.0
			cd "${D}/usr/$(get_libdir)" || die
			if ! use static; then
				ln -s libcivetweb.so.1.7.0 \
					libcivetweb.so.1 || die
				ln -s libcivetweb.so.1 \
					libcivetweb.so || die
			fi
			cd "${BUILD_DIR}" || die
			insinto "/usr/include/${PN}"
			doins include/*
		}
		civetweb_foreach_impl install_impl
	}
	multilib_foreach_abi install_abi
}
