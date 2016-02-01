# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="LateralGM LibMaker"
HOMEPAGE="https://github.com/IsmAvatar/LibMaker"
SRC_URI=""

RESTRICT="nofetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/jre
	 "
DEPEND="${RDEPEND}
	 games-misc/lateralgm
	 virtual/jdk
	 dev-java/eclipse-ecj:4.4
	 "
#	 dev-java/swing-layout
#	 dev-java/gnu-classpath

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        #EGIT_REPO_URI="https://github.com/IsmAvatar/LibMaker.git"
        EGIT_REPO_URI="https://github.com/enigma-dev/LibMaker.git"
        EGIT_BRANCH="master"
        #EGIT_COMMIT="072e3eda2f0c4495838f94ad3cd5a376b1fc7ff5"
        EGIT_COMMIT="f79825ef28064d18b7c170d5b75af74b4bd46c94"
        git-r3_fetch
        git-r3_checkout
}

S="${WORKDIR}/libmaker-9999"

src_prepare() {
	cp -r "${ROOT}//usr/share/joshedit-0/source/org" ./
}

src_compile() {
	#javac -cp "/usr/share/lateralgm-0/lib/lateralgm.jar" $(find . -name "*.java")
	MAKEOPTS="-j1" \
	/usr/bin/ecj-4.4 -1.7 -nowarn -cp . -cp /usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar:/usr/lib64/enigma/lateralgm.jar $(find . -name "*.java")
	jar cmvf META-INF/MANIFEST.MF libmaker.jar $(find . -name '*.class') $(find . -name '*.txt') $(find . -name '*.png') $(find . -name '*.properties') $(find . -name "*.svg")
}

src_install() {
	mkdir -p "${D}/usr/share/libmaker-0/lib"
	cp libmaker.jar "${D}/usr/share/libmaker-0/lib"

	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/libmaker"
	echo "java -jar /usr/share/libmaker-0/lib/libmaker.jar \$*" >> "${D}/usr/bin/libmaker"
	chmod +x "${D}/usr/bin/libmaker"

	mkdir -p "${D}/usr/share/libmaker"
	cp "${S}"/org/lateralgm/libmaker/icons/lgl-128.png "${D}"/usr/share/libmaker/

	make_desktop_entry "/usr/bin/libmaker" "LibMaker" "/usr/share/libmaker/lgl-128.png" "Utility;FileTools"
}
