# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="A lightweight code editor for use in Java applications."
HOMEPAGE="https://github.com/JoshDreamland/JoshEdit"
COMMIT="1eb8e3af94ed24e4508e922629c39c3b16e93ec1"
PROJECT_NAME="JoshEdit"
SRC_URI="https://github.com/JoshDreamland/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lateralgm"

RDEPEND="virtual/jdk"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
#	if use lateralgm ; then
#		eapply "${FILESDIR}"/joshedit-9999.20190210-exception-handler.patch
#	fi
	eapply_user
}

src_compile() {
	cd "${S}"/src/main/java/org/lateralgm/joshedit
	javac $(find . -name "*.java")
	cd "${S}"
	mkdir META-INF
	echo 'Main-Class: org.lateralgm.joshedit.Runner' > META-INF/MANIFEST.MF
	jar cmvf META-INF/MANIFEST.MF joshedit.jar $(find . -name "*.class") $(find . -name "*.properties") $(find . -name "*.flex") $(find . -name "*.gif") $(find . -name "*.png") $(find . -name "*.txt")
}

src_install() {
	if use lateralgm ; then
		mkdir -p "${D}/usr/share/joshedit-${SLOT}/source"
		cp -r "${S}"/* "${D}/usr/share/joshedit-${SLOT}/source"
		rm "${D}/usr/share/joshedit-${SLOT}/source/joshedit.jar"
	fi
	mkdir -p "${D}/usr/share/joshedit-${SLOT}/lib/"
	cp joshedit.jar "${D}/usr/share/joshedit-${SLOT}/lib/"
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/joshedit"
	echo "java -jar /usr/share/joshedit-${SLOT}/lib/joshedit.jar \$*" > "${D}/usr/bin/joshedit"
	chmod +x "${D}/usr/bin/joshedit"
	make_desktop_entry "/usr/bin/joshedit" "JoshEdit" "" "Utility;TextEditor"
}
