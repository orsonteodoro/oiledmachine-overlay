# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="libmaker"
SLOT_JOSHEDIT="1"
RDEPEND="dev-java/joshedit:${SLOT_JOSHEDIT}[lateralgm]
	 libmaker? ( dev-java/libmaker )
	 virtual/jre"
DEPEND="${RDEPEND}
	 virtual/jdk"
inherit desktop eutils
SRC_URI=\
"https://github.com/IsmAvatar/LateralGM/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/IsmAvatar/LateralGM/commit/af0cadc1557914f02fb316b74d112d0fb9a00c6d.patch \
	-> ${PN}-${PV}-revert-casts.patch"
RESTRICT="mirror"
S="${WORKDIR}/LateralGM-${PV}"
JAVA_V="1.7"

src_prepare() {
	default
	cp -r "${ROOT}"/usr/share/joshedit-${SLOT_JOSHEDIT}/source/org ./ || die
	sed -i -e "s|-source 1.7|-source ${JAVA_V}|g" \
		-e "s|-target 1.7|-target ${JAVA_V}|g" Makefile || die
	eapply -R "${DISTDIR}/${PN}-${PV}-revert-casts.patch"
}

src_compile() {
	MAKEOPTS="-j1" \
	emake jar
}

src_install() {
	insinto /usr/$(get_libdir)/enigma
	doins lateralgm.jar
	exeinto /usr/bin
	doexe "${FILESDIR}/lateralgm"
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
		"${D}/usr/bin/lateralgm" || die
	insinto /usr/share/lateralgm
	doins org/lateralgm/main/lgm-logo.ico
	make_desktop_entry "/usr/bin/lateralgm" "LateralGM" \
		"/usr/share/lateralgm/lgm-logo.ico" "Development;IDE"
}

pkg_postinst() {
	elog \
"If you are using dwm or non-parenting window manager or a non-responsive\n\
title bar menus, you need to:\n\
  emerge wmname\n\
  wmname LG3D\n\
Run 'wmname LG3D' before you run 'lateralgm'"
}
