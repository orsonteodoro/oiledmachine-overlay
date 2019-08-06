# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
SRC_URI="https://github.com/IsmAvatar/LateralGM/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
ECJ_V="4.4"
SLOT_JOSHEDIT="0"
JAVA_V="1.7"

RDEPEND="app-editors/joshedit[lateralgm]
	 dev-java/eclipse-ecj:${ECJ_V}
	 virtual/jre
	 "
DEPEND="${RDEPEND}
	 virtual/jdk
	 "

S="${WORKDIR}/LateralGM-${PV}"

src_prepare() {
	#epatch "${FILESDIR}"/lateralgm-1.8.6.844-prefs-languagename.patch

	cp -r "${ROOT}"/usr/share/joshedit-${SLOT_JOSHEDIT}/source/org ./ || die
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-${ECJ_V}) -${JAVA_V} -nowarn -cp .|" Makefile || die
	sed -i -e "s|/usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar|/usr/share/eclipse-ecj-${ECJ_V}/lib/ecj.jar|g" Makefile || die
	sed -i -e "s|@jar|jar|g" Makefile || die
	touch README

	eapply_user
}

src_compile() {
	MAKEOPTS="-j1" \
	emake classes jar || die
	jar cf swinglayout-lgm.jar META-INF/MANIFEST.MF $(find javax -name "*.class") || die
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/enigma" || die
	cp lateralgm.jar "${D}/usr/$(get_libdir)/enigma" || die
	cp swinglayout-lgm.jar "${D}/usr/$(get_libdir)/enigma" || die

	mkdir -p "${D}/usr/bin" || die
	echo "#!/bin/bash" > "${D}/usr/bin/lateralgm" || die
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/lateralgm" || die
	echo "java -jar /usr/$(get_libdir)/enigma/lateralgm.jar \$*" >> "${D}/usr/bin/lateralgm" || die
	chmod +x "${D}/usr/bin/lateralgm" || die

	mkdir -p "${D}/usr/share/lateralgm"
	cp "${S}"/org/lateralgm/main/lgm-logo.ico "${D}"/usr/share/lateralgm || die

	make_desktop_entry "/usr/bin/lateralgm" "LateralGM" "/usr/share/lateralgm/lgm-logo.ico" "Development;IDE"
}
