# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="A lightweight code editor for use in Java applications."
HOMEPAGE="https://github.com/JoshDreamland/JoshEdit"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
EGIT_COMMIT="ef98d4e879b4b1649345b20c3459106485cea087"
PROJECT_NAME="JoshEdit"
SRC_URI="https://github.com/JoshDreamland/${PROJECT_NAME}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
SLOT="0"
IUSE="lateralgm"
RDEPEND="virtual/jdk"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	if use lateralgm ; then
		eapply "${FILESDIR}"/joshedit-9999-exception-handler.patch
	fi
}

src_compile() {
	cd "${S}"/org/lateralgm/joshedit || die
	javac $(find . -name "*.java") || die
	cd "${S}" || die
	mkdir META-INF || die
	echo 'Main-Class: org.lateralgm.joshedit.Runner' > META-INF/MANIFEST.MF || die
	jar cmvf META-INF/MANIFEST.MF joshedit.jar $(find . -name "*.class") $(find . -name "*.properties") $(find . -name "*.flex") $(find . -name "*.gif") $(find . -name "*.png") $(find . -name "*.txt") || die
}

src_install() {
	if use lateralgm ; then
		doins /usr/share/joshedit-${SLOT}/source
		doins -r *
		rm "${D}/usr/share/joshedit-${SLOT}/source/joshedit.jar" || die
	fi
	insinto /usr/share/joshedit-${SLOT}/lib/
	doins joshedit.jar
	exeinto /usr/bin
	doexe "${FILESDIR}/joshedit"
	sed -i -e "s|joshedit-0|${PN}-${SLOT}|" "${D}/usr/bin/joshedit"
	make_desktop_entry "/usr/bin/joshedit" "JoshEdit" "" "Utility;TextEditor"
}
