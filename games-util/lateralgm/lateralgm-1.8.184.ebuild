# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="libmaker +vanilla"
SLOT_JOSHEDIT="1"
inherit multilib-build
RDEPEND="=dev-java/joshedit-1_p20190429*:${SLOT_JOSHEDIT}[lateralgm]
	 virtual/jre"
DEPEND="${RDEPEND}
	 virtual/jdk"
inherit desktop enigma eutils
MY_PN="LateralGM"
SRC_URI=\
"https://github.com/IsmAvatar/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"
JAVA_V="1.7"

src_prepare() {
	default
	cp -r "${ROOT}"/usr/share/joshedit-${SLOT_JOSHEDIT}/source/org ./ || die
	sed -i -e "s|-source 1.7|-source ${JAVA_V}|g" \
		-e "s|-target 1.7|-target ${JAVA_V}|g" Makefile || die
	# no need to call enigma_copy_sources
	# it will complain about cd (change directory) failure in src_install phase
}

src_compile() {
	MAKEOPTS="-j1" \
	emake jar
}

src_install() {
	platform_install() {
		ml_install_abi() {
			# use same .jars but distribute based on lateral-EENIGMA
			local suffix=""
			local descriptor_suffix=""
			if [[ "${EENIGMA}" == "linux" ]] ; then
				suffix="-${ABI}"
				descriptor_suffix=" (${ABI})"
			fi
			insinto /usr/$(get_libdir)/enigma/${EENIGMA}${suffix}
			doins lateralgm.jar
			exeinto /usr/bin
			cp "${FILESDIR}/lateralgm" \
				"${T}/lateralgm-${EENIGMA}${suffix}" || die
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${T}/lateralgm-${EENIGMA}${suffix}" || die
			sed -i -e "s|PLATFORM|${EENIGMA}${suffix}|g" \
				"${T}/lateralgm-${EENIGMA}${suffix}" || die
			doexe "${T}/lateralgm-${EENIGMA}${suffix}"
			doicon org/lateralgm/main/lgm-logo.ico
			make_desktop_entry \
				"/usr/bin/lateralgm-${EENIGMA}${suffix}" \
				"${MY_PN}${descriptor_suffix}" \
				"/usr/share/pixmap/lgm-logo.ico" "Development;IDE"
		}
		multilib_foreach_abi ml_install_abi
	}
	enigma_foreach_impl platform_install
}

pkg_postinst() {
	einfo "Consider adding games-util/libmaker to extend ${MY_PN}"
	elog \
"If you are using dwm or non-parenting window manager or a non-responsive\n\
title bar menus, you need to:\n\
  emerge wmname\n\
  wmname LG3D\n\
Run 'wmname LG3D' before you run 'lateralgm'"
}
