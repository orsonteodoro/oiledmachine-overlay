# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator eutils

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="https://github.com/${PN}/${PN}-core/releases/download/v${PV//_/-}/premake-${PV//_/-}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="amd64 ppc x86"
IUSE="nss gnutls openssl axtls polarssl debug"

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

S="${WORKDIR}/${PN}-${PV//_/-}"

src_prepare() {
	sed -i -e 's|.PHONY: all clean help $(PROJECTS) contrib|.PHONY: all clean help $(PROJECTS)|g' ./build/gmake.unix/Makefile
	sed -i -e 's|Premake5: zip-lib zlib-lib curl-lib|Premake5: |g' ./build/gmake.unix/Makefile
	sed -i -e 's|PROJECTS := Premake5 zlib-lib zip-lib curl-lib|PROJECTS := Premake5|g' ./build/gmake.unix/Makefile

	sed -i -e 's|../../contrib/curl/build/bin/Release/libcurl-lib.a|-lcurl|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|../../contrib/zlib/build/bin/Release/libzlib-lib.a|-lz|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|../../contrib/libzip/build/bin/Release/libzip-lib.a|-lzip|g' ./build/gmake.unix/Premake5.make

	sed -i -e 's|bin/Release/libzip-lib.a|-lzip|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|bin/Debug/libzip-lib.a|-lzip|g' ./build/gmake.unix/Premake5.make

	sed -i -e 's|bin/Release/libzlib-lib.a|-lz|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|bin/Debug/libzlib-lib.a|-lz|g' ./build/gmake.unix/Premake5.make

	sed -i -e 's|bin/Release/libcurl-lib.a|-lcurl|g' ./build/gmake.unix/Premake5.make
	sed -i -e 's|bin/Debug/libcurl-lib.a|-lcurl|g' ./build/gmake.unix/Premake5.make

	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/curl/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/zlib/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./contrib/libzip/build/Makefile
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./premake4.lua
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./build/gmake.macosx/Premake5.make
	sed -i -r -e "s|-mmacosx-version-min=10.4||g" ./premake5.lua:

	eapply_user
}

src_compile() {
	mydebug="debug=0"
	if use debug; then
		mydebug="debug=1"
	else
		mydebug="debug=0"
	fi
	emake -C build/gmake.unix/ ${mydebug} verbose=1
}

src_install() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	else
		mydebug="release"
	fi
	dobin "bin/release/${PN}5"
}
