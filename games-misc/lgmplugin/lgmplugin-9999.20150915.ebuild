# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="LateralGM Plugin"
HOMEPAGE="https://github.com/enigma-dev/lgmplugin"
COMMIT="9bfe9c0788c9ea13bcd304c41739932be231ba0b"
SRC_URI="https://github.com/enigma-dev/lgmplugin/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

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
	default
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-${ECJ_V}*) -${JAVA_V} -nowarn -cp .|" Makefile || die
	sed -i -e "s|../plugins/shared/jna.jar:../lgm16b4.jar:/usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar|/usr/share/jna/lib/jna.jar:/usr/$(get_libdir)/enigma/lateralgm.jar:/usr/share/eclipse-ecj-${ECJ_V}/lib/ecj.jar|" Makefile || die
	sed -i -e "s|../plugins/enigma.jar|enigma.jar|" Makefile || die
	sed -i -e "s|        |\t|" Makefile || die
	sed -i -e "s|../lateralgm.jar shared/svnkit.jar shared/jna.jar|../lateralgm.jar /usr/$(get_libdir)/enigma/swinglayout-lgm.jar /usr/share/jna/lib/jna.jar|" META-INF/MANIFEST.MF || die
}

src_compile() {
	#icedtea is required because of missing classes
	MAKEOPTS="-j1" \
	emake
}

src_install() {
	insinto "/usr/$(get_libdir)/enigma/plugins"
	doins enigma.jar
}
