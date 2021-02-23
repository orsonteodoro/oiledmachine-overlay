# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic pax-utils toolchain-funcs

MY_PV="$(ver_cut 1-5)"
MY_PV="${MY_PV/_beta/-beta}"
MY_P="LuaJIT-${MY_PV}"

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://luajit.org/"
SRC_URI="https://luajit.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
# this should probably be pkgmoved to 2.0 for sake of consistency.
SLOT="2"
KEYWORDS="~arm64"
IUSE="lua52compat static-libs"
IUSE+=" urho3d"

PATCHES=(
	"${FILESDIR}/${PN}-2-ldconfig.patch"
	"${FILESDIR}/CVE-2020-15890.patch"
)

S="${WORKDIR}/${MY_P}"

_emake() {
	if use urho3d ; then
		append-cppflags -DURHO3D
	fi
	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		MULTILIB="$(get_libdir)" \
		DESTDIR="${D}" \
		CFLAGS="" \
		LDFLAGS="" \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CFLAGS="${BUILD_CPPFLAGS} ${BUILD_CFLAGS}" \
		HOST_LDFLAGS="${BUILD_LDFLAGS}" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_CFLAGS="${CPPFLAGS} ${CFLAGS}" \
		TARGET_LDFLAGS="${LDFLAGS}" \
		TARGET_AR="$(tc-getAR) rcus" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED}/usr/$(get_libdir)" \
		"$@"
}

src_prepare() {
	default
	if use urho3d ; then
		eapply "${FILESDIR}/LuaJIT-2.1.0-urho3d-lua_getmainthread.patch"
	fi
}

src_compile() {
	tc-export_build_env
	_emake XCFLAGS="$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")"
}

src_install() {
	_emake install

	pax-mark m "${ED}/usr/bin/luajit-${MY_PV}"

	HTML_DOCS="doc/." einstalldocs
}
