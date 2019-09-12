# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

MY_PN="LibMaker"
DESCRIPTION="An open source Library Editor for Game Maker and LateralGM Libraries."
HOMEPAGE="https://github.com/IsmAvatar/LibMaker"
COMMIT="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
SRC_URI="https://github.com/IsmAvatar/${MY_PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""
ECJ_V="4.4"
JAVA_V="1.7"
SLOT_JOSHEDIT="0"

RDEPEND="virtual/jre
	 "
DEPEND="${RDEPEND}
	 games-engines/lateralgm
	 virtual/jdk
	 dev-java/eclipse-ecj:${ECJ_V}
	 "

S="${WORKDIR}/${MY_PN}-${COMMIT}"

src_prepare() {
	cp -r "${ROOT}//usr/share/joshedit-${SLOT_JOSHEDIT}/source/org" ./ || die
	eapply_user
}

src_compile() {
	MAKEOPTS="-j1" \
	/usr/bin/ecj-${ECJ_V} -${JAVA_V} -nowarn -cp . -cp /usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar:/usr/lib64/enigma/lateralgm.jar $(find . -name "*.java")
	jar cmvf META-INF/MANIFEST.MF ${PN}.jar $(find . -name '*.class') $(find . -name '*.txt') $(find . -name '*.png') $(find . -name '*.properties') $(find . -name "*.svg")
}

src_install() {
	mkdir -p "${D}/usr/share/${PN}-${SLOT}/lib" || die
	cp ${PN}.jar "${D}/usr/share/${PN}-${SLOT}/lib" || die

	mkdir -p "${D}/usr/bin" || die
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}" || die
	echo "java -jar /usr/share/${PN}-${SLOT}/lib/libmaker.jar \$*" >> "${D}/usr/bin/${PN}" || die
	chmod +x "${D}/usr/bin/${PN}" || die

	cp "${S}"/org/lateralgm/${PN}/icons/lgl-128.png "${D}"/usr/share/${PN}-${SLOT}/ || die

	make_desktop_entry "/usr/bin/libmaker" "${MY_PN}" "/usr/share/${PN}-${SLOT}/lgl-128.png" "Utility;FileTools"
}
