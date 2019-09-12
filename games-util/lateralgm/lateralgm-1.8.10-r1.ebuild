# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~arm ~arm64"
SRC_URI="https://github.com/IsmAvatar/LateralGM/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE=""
ECJ_V="4.4"
SLOT_JOSHEDIT="0"
JAVA_V="1.7"
RDEPEND="app-editors/joshedit[lateralgm]
	 dev-java/eclipse-ecj:${ECJ_V}
	 virtual/jre"
DEPEND="${RDEPEND}
	 virtual/jdk"

S="${WORKDIR}/LateralGM-${PV}"

src_prepare() {
	default
	cp -r "${ROOT}"/usr/share/joshedit-${SLOT_JOSHEDIT}/source/org ./ || die
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-${ECJ_V}) -${JAVA_V} -nowarn -cp .|" Makefile || die
	touch README
}

src_compile() {
	MAKEOPTS="-j1" \
	emake classes jar
	jar cf swinglayout-lgm.jar META-INF/MANIFEST.MF $(find javax -name "*.class") || die
}

src_install() {
	insinto /usr/$(get_libdir)/enigma
	doins lateralgm.jar swinglayout-lgm.jar

	exeinto /usr/bin
	doexe "${FILESDIR}/lateralgm"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" "${D}/usr/bin/lateralgm" || die

	insinto /usr/share/lateralgm
	doins org/lateralgm/main/lgm-logo.ico

	make_desktop_entry "/usr/bin/lateralgm" "LateralGM" "/usr/share/lateralgm/lgm-logo.png" "Development;IDE"
}
