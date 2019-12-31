# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="libmaker"
RDEPEND="app-editors/joshedit[lateralgm]
	 libmaker? ( dev-java/libmaker )
	 virtual/jre"
DEPEND="${RDEPEND}
	 virtual/jdk"
inherit desktop eutils
SRC_URI=\
"https://github.com/IsmAvatar/LateralGM/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/LateralGM-${PV}"
JAVA_V="1.7"
SLOT_JOSHEDIT="0"

src_prepare() {
	default
	cp -r "${ROOT}"/usr/share/joshedit-${SLOT_JOSHEDIT}/source/org ./ || die
	touch README
}

src_compile() {
	MAKEOPTS="-j1" \
	emake jar
}

src_install() {
	insinto /usr/$(get_libdir)/enigma
	doins lateralgm.jar swinglayout-lgm.jar
	exeinto /usr/bin
	doexe "${FILESDIR}/lateralgm"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/lateralgm" || die
	insinto /usr/share/lateralgm
	doins org/lateralgm/main/lgm-logo.ico
	make_desktop_entry "/usr/bin/lateralgm" "LateralGM" \
		"/usr/share/lateralgm/lgm-logo.ico" "Development;IDE"
}
