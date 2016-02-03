# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="AVR Studio"
HOMEPAGE="http://www.atmel.com/tools/STUDIOARCHIVE.aspx"
SRC_URI="AvrStudio${PV:0:1}Setup.exe"

LICENSE="AVRSTUDIO-4.19 jungo? ( AVR-STUDIO-JUNGO  )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-emulation/wine-1.8[abi_x86_32]
	 app-emulation/winetricks
	 ico? ( media-gfx/icoutils )"
DEPEND="${RDEPEND}"

RESTRICT="fetch"
IUSE="jungo ico"

S="${WORKDIR}"

pkg_setup() {
	einfo "This is not a Linux package but a Windows package."
	einfo "It will be a user install instead of a system-wide install."
	einfo "A wine solution is provided instead."
}

src_install() {
	mkdir -p "${D}/usr/share/avr-studio"/
	cp "${FILESDIR}/setup.iss" "${D}/usr/share/avr-studio"/
	cp "${FILESDIR}/jungo-setup.iss" "${D}/usr/share/avr-studio"/
	cp "${FILESDIR}/install.sh" "${D}/usr/share/avr-studio"
	chmod +x "${D}/usr/share/avr-studio/install.sh"
	if use jungo; then
		sed -i -e 's|#jungo usb driver wine|wine|' "${D}/usr/share/avr-studio/install.sh"
	fi
}

pkg_postinst() {
	einfo "You need to do a first time install by running /usr/share/avr-studio/install.sh"
	einfo "After the first time install you can call \${HOME}/bin/avrstudio"
}
