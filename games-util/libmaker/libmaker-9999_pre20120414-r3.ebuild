# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For versioning see https://github.com/IsmAvatar/LibMaker/blob/master/org/lateralgm/libmaker/messages.properties

EAPI=7
DESCRIPTION="An open source Library Editor for Game Maker and LateralGM \
Libraries."
HOMEPAGE="https://github.com/IsmAvatar/LibMaker"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
MY_PN="LibMaker"
EGIT_COMMIT="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
JOSHEDIT_COMMIT="5844d7f047eac15408f7ccf8a9183d2015b962e0"
  # dated 20120417, this is required because of namespace changes, KeywordSet
  # changes, fails to build
PN_JOSHEDIT="JoshEdit"
SRC_URI=\
"https://github.com/IsmAvatar/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz
https://github.com/JoshDreamland/${PN_JOSHEDIT}/archive/${JOSHEDIT_COMMIT}.tar.gz\
	-> ${P}-joshedit-${JOSHEDIT_COMMIT}.tar.gz"
SLOT="0"
ECJ_V="4.4"
JAVA_V="1.7"
RDEPEND="games-util/lateralgm
	 virtual/jre"
DEPEND="${RDEPEND}
	 dev-java/eclipse-ecj:${ECJ_V}
	 games-util/lateralgm
	 virtual/jdk"
inherit desktop eutils
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( README )

src_prepare() {
	default
	cp -r "${WORKDIR}/${PN_JOSHEDIT}-${JOSHEDIT_COMMIT}/org/" ./ \
		|| die
}

src_compile() {
	MAKEOPTS="-j1" \
	/usr/bin/ecj-${ECJ_V} -${JAVA_V} -nowarn -cp . -cp \
/usr/share/java/eclipse-ecj.jar:\
/usr/share/java/ecj.jar:\
/usr/$(get_libdir)/enigma/lateralgm.jar\
		$(find . -name "*.java")
	jar cmvf META-INF/MANIFEST.MF ${PN}.jar \
		$(find . -name '*.class') \
		$(find . -name '*.png') \
		$(find . -name '*.properties') \
		$(find . -name "*.svg") \
		$(find . -name '*.txt') \
		|| die
}

src_install() {
	insinto /usr/share/${PN}-${SLOT}/lib
	doins ${PN}.jar
	exeinto /usr/bin
	cp -a "${FILESDIR}/${PN}" "${T}" || die
	sed -i -e "s|${PN}-0|${PN}-${SLOT}|g" "${T}/${PN}" || die
	doexe "${T}/${PN}"
	doicon "${S}"/org/lateralgm/${PN}/icons/lgl-128.png
	make_desktop_entry "/usr/bin/libmaker" "${MY_PN}" \
		"/usr/share/pixmaps/lgl-128.png" "Utility;FileTools"
	dodoc COPYING LICENSE
}

pkg_postinst() {
	elog \
"If you are using dwm or non-parenting window manager or a non-responsive\n\
title bar menus, you need to:\n\
  emerge wmname\n\
  wmname LG3D\n\
Run 'wmname LG3D' before you run 'libmaker'"
}
