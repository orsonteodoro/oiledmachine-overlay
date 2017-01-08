# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="Password recovery for 7zip, rar and zip archives"
HOMEPAGE="http://rarcrack.sourceforge.net"
SRC_URI="opencl? ( http://www.crark.net/download/crark34-linux-opencl.rar )
         cpu? ( http://www.crark.net/download/crark34-linux.rar )
         cuda? ( http://www.crark.net/download/crark34-linux-cuda.rar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opencl cuda cpu"
REQUIRED_USE="^^ ( opencl cuda cpu )"

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

