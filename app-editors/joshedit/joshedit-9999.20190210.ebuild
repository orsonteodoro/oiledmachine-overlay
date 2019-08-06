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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="lateralgm maven ecj"
REQUIRED_USE="^^ ( maven ecj )"

RDEPEND="virtual/jdk"
DEPEND="${RDEPEND}
	maven? ( dev-java/maven-bin )"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
	eapply_user
}

src_compile() {
	if use maven ; then
		src_compile_maven
	elif use ecj ; then
		src_compile_ecj
	fi
}

src_compile_maven() {
	mvn package || die
}

src_compile_ecj() {
	cd "${S}"/src/main/java/org/lateralgm/joshedit || die
	javac $(find . -name "*.java") || die
	cd "${S}"/src/main/java/ || die
	cp -a "${S}"/src/main/resources/* ./ || die
	mkdir META-INF || die
	echo 'Main-Class: org.lateralgm.joshedit.Runner' > META-INF/MANIFEST.MF || die
	jar cmvf META-INF/MANIFEST.MF joshedit.jar $(find . -name "*.class") $(find . -name "*.properties") $(find . -name "*.flex") $(find . -name "*.gif") $(find . -name "*.png") $(find . -name "*.txt") || die
}

src_install() {
	if use lateralgm ; then
		mkdir -p "${D}/usr/share/joshedit-${SLOT}/source" || die
		cp -r "${S}"/src/main/java/org "${D}/usr/share/joshedit-${SLOT}/source" || die
		cp -r "${S}"/src/main/java/META-INF "${D}/usr/share/joshedit-${SLOT}/source" || die
		cp -r "${S}"/eclipse "${D}/usr/share/joshedit-${SLOT}/source" || die
	fi
	mkdir -p "${D}/usr/share/joshedit-${SLOT}/lib/" || die
	cp "${S}"/src/main/java/joshedit.jar "${D}/usr/share/joshedit-${SLOT}/lib/" || die
	mkdir -p "${D}/usr/bin" || die
	echo "#!/bin/bash" > "${D}/usr/bin/joshedit" || die
	echo "java -jar /usr/share/joshedit-${SLOT}/lib/joshedit.jar \$*" > "${D}/usr/bin/joshedit" || die
	chmod +x "${D}/usr/bin/joshedit" || die
	make_desktop_entry "/usr/bin/joshedit" "JoshEdit" "" "Utility;TextEditor"
}
