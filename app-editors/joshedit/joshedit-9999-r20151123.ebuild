# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="JoshEdit"
HOMEPAGE="https://github.com/JoshDreamland/JoshEdit"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/jdk"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S="${WORKDIR}/joshedit-9999"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/JoshDreamland/JoshEdit.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="ef98d4e879b4b1649345b20c3459106485cea087"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	epatch "${FILESDIR}"/joshedit-9999-exception-handler.patch
}

src_compile() {
	cd "${S}"/org/lateralgm/joshedit
	javac $(find . -name "*.java")
	cd "${S}"
	mkdir META-INF
	echo 'Main-Class: org.lateralgm.joshedit.Runner' > META-INF/MANIFEST.MF
	jar cmvf META-INF/MANIFEST.MF joshedit.jar $(find . -name "*.class") $(find . -name "*.properties") $(find . -name "*.flex") $(find . -name "*.gif") $(find . -name "*.png") $(find . -name "*.txt")
}

src_install() {
	mkdir -p "${D}/usr/share/joshedit-${SLOT}/source"
	cp -r "${S}"/* "${D}/usr/share/joshedit-${SLOT}/source"
	rm "${D}/usr/share/joshedit-${SLOT}/source/joshedit.jar"
	mkdir -p "${D}/usr/share/joshedit-${SLOT}/lib/"
	cp joshedit.jar "${D}/usr/share/joshedit-${SLOT}/lib/"
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/joshedit"
	echo "java -jar /usr/share/joshedit-${SLOT}/lib/joshedit.jar \$*" > "${D}/usr/bin/joshedit"
	chmod +x "${D}/usr/bin/joshedit"
	make_desktop_entry "/usr/bin/joshedit" "JoshEdit" "" "Utility;TextEditor"
}
