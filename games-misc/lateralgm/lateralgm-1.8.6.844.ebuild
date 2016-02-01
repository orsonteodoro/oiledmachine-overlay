# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="LateralGM"
HOMEPAGE="http://lateralgm.org/"
SRC_URI="https://github.com/IsmAvatar/LateralGM/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="app-editors/joshedit
	 dev-java/eclipse-ecj:4.4
	 virtual/jre
	 "
DEPEND="${RDEPEND}
	 virtual/jdk
	 "

S="${WORKDIR}/LateralGM-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/lateralgm-1.8.6.844-prefs-languagename.patch

	cp -r "${ROOT}"/usr/share/joshedit-0/source/org ./
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-4.4) -1.7 -nowarn -cp .|" Makefile
	touch README
}

src_compile() {
	MAKEOPTS="-j1" \
	emake classes jar || die
	jar cf swinglayout-lgm.jar $(find javax -name "*.class")
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/enigma"
	cp lateralgm.jar "${D}/usr/$(get_libdir)/enigma"
	cp swinglayout-lgm.jar "${D}/usr/$(get_libdir)/enigma"

	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/lateralgm"
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/lateralgm"
	echo "java -jar /usr/$(get_libdir)/enigma/lateralgm.jar \$*" >> "${D}/usr/bin/lateralgm"
	chmod +x "${D}/usr/bin/lateralgm"

	mkdir -p "${D}/usr/share/lateralgm"
	cp "${S}"/org/lateralgm/main/lgm-logo.png "${D}"/usr/share/lateralgm

	make_desktop_entry "/usr/bin/lateralgm" "LateralGM" "/usr/share/lateralgm/lgm-logo.png" "Development;IDE"
}
