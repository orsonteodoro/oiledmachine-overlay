# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

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
REQUIRED="^^( opencl cuda cpu )"

DEPEND="app-arch/unrar"
RDEPEND="${DEPEND}
"

src_unpack() {
	einfo "The author said that there is no password.  Press enter to continue."
	unpack "${A}"
}

src_install() {
	mkdir -p "${D}/opt/crark"
	cp -R "${WORKDIR}"/* "${D}/opt/crark"
	mkdir -p "${D}/usr/bin"
	cp "${FILESDIR}/crark" "${D}/usr/bin" #wrapper script
	cp "${FILESDIR}/crark-hp" "${D}/usr/bin" #wrapper script
}

