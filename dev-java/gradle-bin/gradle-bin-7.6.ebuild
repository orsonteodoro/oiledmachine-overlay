# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

IUSE="doc"
JAVA_PKG_IUSE="source"
MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV/_rc/-rc-}"

inherit java-pkg-2

KEYWORDS="amd64"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://services.gradle.org/distributions/${MY_P}-all.zip
	-> ${P}.zip
"

DESCRIPTION="A project automation and build tool with a Groovy based DSL"
HOMEPAGE="https://www.gradle.org/"
LICENSE="Apache-2.0"
SLOT="${PV}"
DEPEND="
	app-eselect/eselect-gradle
"
BDEPEND="
	app-arch/unzip
"
RDEPEND="
	${DEPEND}
	>=virtual/jre-1.8:*
"

src_compile() {
	:
}

src_install() {
	local gradle_dir="/usr/share/${PN}-${SLOT}"

	if use source; then
		java-pkg_dosrc "src"
	fi

	docinto "html"
	dodoc -r "docs/release-notes.html"
	if use doc; then
		dodoc -r "docs/"{"dsl","userguide"}
		java-pkg_dojavadoc "docs/javadoc"
	fi

	insinto "${gradle_dir}"
	doins -r "bin/" "lib/"
	fperms 0755 "${gradle_dir}/bin/gradle"
	dosym "${gradle_dir}/bin/gradle" "/usr/bin/${PN}-${SLOT}"
}

pkg_postinst() {
	eselect gradle update ifunset
}

pkg_postrm() {
	eselect gradle update ifunset
}
