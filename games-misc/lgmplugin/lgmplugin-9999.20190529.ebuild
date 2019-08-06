# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="LateralGM Plugin"
HOMEPAGE="https://github.com/enigma-dev/lgmplugin"
COMMIT="2bd2060f19114f81d3f808ed7ce2661986cadb75"
SRC_URI="https://github.com/enigma-dev/lgmplugin/archive/${COMMIT}.zip -> ${P}.zip"

RESTRICT=""

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""
JAVA_V="1.7"
ECJ_V="4.4"

RDEPEND="virtual/jre
	 dev-java/eclipse-ecj:${ECJ_V}
	 dev-java/jna[nio-buffers]
	 games-engines/lateralgm
	 || ( dev-java/icedtea dev-java/icedtea-bin )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-${ECJ_V}*) -${JAVA_V} -nowarn -cp .|" Makefile
	sed -i -e "s|../plugins/shared/jna.jar:../lgm16b4.jar:/usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar|/usr/share/jna/lib/jna.jar:/usr/$(get_libdir)/enigma/lateralgm.jar:/usr/share/eclipse-ecj-${ECJ_V}/lib/ecj.jar|" Makefile
	sed -i -e "s|../plugins/enigma.jar|enigma.jar|" Makefile
	sed -i -e "s|        |\t|" Makefile
	sed -i -e "s|../lateralgm.jar shared/svnkit.jar shared/jna.jar|../lateralgm.jar /usr/$(get_libdir)/enigma/swinglayout-lgm.jar /usr/share/jna/lib/jna.jar|" META-INF/MANIFEST.MF

	eapply_user
}

src_compile() {
	#icedtea is required because of missing classes
	MAKEOPTS="-j1" \
	make
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/enigma/plugins"
	cp enigma.jar "${D}/usr/$(get_libdir)/enigma/plugins"
}
