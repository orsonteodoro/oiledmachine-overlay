# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="Fastest freeware utility to crack RAR password"
HOMEPAGE="http://www.crark.net/"
SRC_URI="http://www.crark.net/download/crark51-linux.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=""

DEPEND="app-arch/unrar"
RDEPEND="${DEPEND}
"
PROPERTIES="interactive"
S="${WORKDIR}"

src_prepare() {
	eapply_user
}

src_unpack() {
	einfo "The author said that there is no password.  Press enter to continue."
	echo "${DISTDIR}/${A}"
	unrar x -p "${DISTDIR}/${A}"
}

src_install() {
	mkdir -p "${D}/opt/crark"
	cp -R "${WORKDIR}"/* "${D}/opt/crark"
	mkdir -p "${D}/usr/bin"
	cp "${FILESDIR}/crark" "${D}/usr/bin" #wrapper script
	cp "${FILESDIR}/crark-hp" "${D}/usr/bin" #wrapper script
}

