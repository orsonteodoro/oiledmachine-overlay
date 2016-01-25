# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator eutils

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="https://github.com/${PN}/${PN}-core/releases/download/v${PV}-alpha${PR/r/}/premake-${PV}-alpha${PR/r/}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="amd64 ppc x86"
IUSE="nss gnutls openssl axtls polarssl"

DEPEND="app-arch/unzip
        nss? ( dev-libs/nss )
	gnutls? ( net-libs/gnutls )
	polarssl? ( net-libs/polarssl )
	openssl? ( dev-libs/openssl )
	axtls? ( net-libs/axtls )
	dev-libs/libzip
	sys-libs/zlib
	net-misc/curl
       "
REQUIRED_USE="^^ ( nss gnutls openssl polarssl )"

S="${WORKDIR}/${PN}-${PV}-alpha${PR/r/}"
src_prepare() {
	sed -i -e 's|.PHONY: all clean help $(PROJECTS) contrib|.PHONY: all clean help $(PROJECTS)|g' ./build/gmake.unix/Makefile
	sed -i -e 's|Premake5: zip-lib zlib-lib curl-lib|Premake5: |g' ./build/gmake.unix/Makefile
	sed -i -e 's|PROJECTS := Premake5 zlib-lib zip-lib curl-lib|PROJECTS := Premake5|g' ./build/gmake.unix/Makefile

	sed -i -e 's|../../contrib/curl/build/bin/Release/libcurl-lib.a|-lcurl|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|../../contrib/zlib/build/bin/Release/libzlib-lib.a|-lz|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|../../contrib/libzip/build/bin/Release/libzip-lib.a|-lzip|g' ./build/gmake.unix/Premake5.make

	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/curl/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/zlib/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/libzip/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./premake4.lua
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./build/gmake.macosx/Premake5.make
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./premake5.lua:
}

src_compile() {
	emake -C build/gmake.unix/
}

src_install() {
	dobin "bin/release/${PN}5"
}
