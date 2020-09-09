# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A lightweight code editor for use in Java applications."
HOMEPAGE="https://github.com/JoshDreamland/JoshEdit"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="lateralgm maven"
SLOT="$(ver_cut 1 ${PV})"
RDEPEND="virtual/jre"
DEPEND="maven? ( app-arch/zip \
		dev-java/maven-bin )
	virtual/jdk"
PROJECT_NAME="JoshEdit"
EGIT_COMMIT="d50db861f57a142483fd44be2cd70fad929d1eba"
SRC_URI=\
"https://github.com/JoshDreamland/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz\
	-> ${P}.tar.gz"
inherit desktop eutils
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	if use maven ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download micropackages."
		fi
	fi
}

src_compile() {
	if use maven ; then
		src_compile_maven
	else
		src_compile_direct
	fi
}

src_compile_maven() {
	mkdir "${S}"/src/main/java/META-INF || die
	mvn package || die
	mkdir t || die
	local archive_name="${PROJECT_NAME}-$(ver_cut 1 ${PV}).jar"
	cp target/${archive_name} t || die
	pushd t || die
		unzip ${archive_name}
		echo "Main-Class: org.lateralgm.${PN}.Runner" \
			> META-INF/MANIFEST.MF || die
		rm ${archive_name} || die
		zip -r ${archive_name} LICENSE META-INF org README.md || die
	popd
	cp -a t/${archive_name} target || die
}

src_compile_direct() {
	cd "${S}"/src/main/java/org/lateralgm/${PN} || die
	javac $(find . -name "*.java") || die
	cd "${S}"/src/main/java/ || die
	cp -a "${S}"/src/main/resources/* ./ || die
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
		doins -r src/main/java/org src/main/java/META-INF eclipse
	fi
	insinto /usr/share/${PN}-${SLOT}/lib/
	if use maven ; then
		mv target/${PROJECT_NAME}-$(ver_cut 1 ${PV}).jar \
			target/${PN}.jar || die
		doins target/${PN}.jar
	else
		doins src/main/java/${PN}.jar
	fi
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i -e "s|${PN}-0|${PN}-${SLOT}|" "${D}/usr/bin/${PN}" || die
	make_desktop_entry "/usr/bin/${PN}" "${PROJECT_NAME}" "" \
		"Utility;TextEditor"
}
