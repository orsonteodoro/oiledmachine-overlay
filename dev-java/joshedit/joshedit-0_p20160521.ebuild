# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A lightweight code editor for use in Java applications."
HOMEPAGE="https://github.com/JoshDreamland/JoshEdit"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="lateralgm"
SLOT="$(ver_cut 1 ${PV})"
RDEPEND="virtual/jre"
DEPEND="virtual/jdk"
PROJECT_NAME="JoshEdit"
EGIT_COMMIT="101a599f6c936775216faf56db4399567eabbfad"
SRC_URI=\
"https://github.com/JoshDreamland/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz\
	-> ${P}.tar.gz"
inherit desktop eutils
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_compile() {
	cd "${S}"/org/lateralgm/${PN} || die
	javac $(find . -name "*.java") || die
	mkdir META-INF || die
	echo "Main-Class: org.lateralgm.${PN}.Runner" > META-INF/MANIFEST.MF \
		|| die
	jar cmvf META-INF/MANIFEST.MF ${PN}.jar \
		$(find . -name "*.class" \
			-o -name "*.properties" \
			-o -name "*.flex" \
			-o -name "*.gif" \
			-o -name "*.png" \
			-o -name "*.txt") || die
}

src_install() {
	if use lateralgm ; then
		insinto /usr/share/${PN}-${SLOT}/source
		doins -r org org/lateralgm/joshedit/META-INF eclipse
	fi
	insinto /usr/share/${PN}-${SLOT}/lib/
	doins org/lateralgm/joshedit/${PN}.jar
	exeinto /usr/bin
	cat "${FILESDIR}/${PN}" > "${T}/${PN}-${SLOT}" || die
	doexe "${T}/${PN}-${SLOT}"
	sed -i -e "s|${PN}-0|${PN}-${SLOT}|" "${D}/usr/bin/${PN}-${SLOT}" || die
	make_desktop_entry "/usr/bin/${PN}-${SLOT}" "${PROJECT_NAME} (${SLOT})" "" \
		"Utility;TextEditor"
}
