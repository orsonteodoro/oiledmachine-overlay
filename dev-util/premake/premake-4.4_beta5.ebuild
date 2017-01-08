# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator eutils

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV//_/-}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="app-arch/unzip"
REQUIRED_USE=""

S="${WORKDIR}/${PN}-${PV//_/-}"

src_prepare() {
	sed -i -e "s|\$(ALL_CPPFLAGS) \$(ARCH) -Wall|\$(ALL_CPPFLAGS) -Wall|" build/gmake.unix/Premake4.make
	sed -i -e "s|\$(RESOURCES) \$(ARCH) \$(ALL_LDFLAGS)|\$(RESOURCES) \$(ALL_LDFLAGS)|" build/gmake.unix/Premake4.make

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
	dobin "bin/${mydebug}/${PN}4"
}
