# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="An open source Library Editor for Game Maker and LateralGM Libraries."
HOMEPAGE="https://github.com/IsmAvatar/LibMaker"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
MY_PN="LibMaker"
EGIT_COMMIT="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
SRC_URI="https://github.com/IsmAvatar/${MY_PN}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
SLOT="0"
ECJ_V="4.4"
JAVA_V="1.7"
SLOT_JOSHEDIT="0"
RDEPEND="virtual/jre"
DEPEND="${RDEPEND}
	 games-util/lateralgm
	 virtual/jdk
	 dev-java/eclipse-ecj:${ECJ_V}"
inherit desktop eutils
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	cp -r "${ROOT}//usr/share/joshedit-${SLOT_JOSHEDIT}/source/org" ./ || die
}

src_compile() {
	MAKEOPTS="-j1" \
	/usr/bin/ecj-${ECJ_V} -${JAVA_V} -nowarn -cp . -cp /usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar:/usr/lib64/enigma/lateralgm.jar $(find . -name "*.java")
	jar cmvf META-INF/MANIFEST.MF ${PN}.jar $(find . -name '*.class') $(find . -name '*.txt') $(find . -name '*.png') $(find . -name '*.properties') $(find . -name "*.svg") || die
}

src_install() {
	insinto /usr/share/${PN}-${SLOT}/lib
	doins ${PN}.jar

	exeinto /usr/bin
	cp -a "${FILESDIR}/${PN}" "${T}"
	sed -i -e "s|${PN}-0|${PN}-${SLOT}|g" "${T}/${PN}"
	doexe "${T}/${PN}"

	doicon "${S}"/org/lateralgm/${PN}/icons/lgl-128.png

	make_desktop_entry "/usr/bin/libmaker" "${MY_PN}" "/usr/share/pixmaps/lgl-128.png" "Utility;FileTools"
}
