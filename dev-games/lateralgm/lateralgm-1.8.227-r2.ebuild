# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EPLATFORMS="vanilla android linux wine"
inherit desktop eutils multilib-build platforms

DESCRIPTION="A free Game Maker source file editor"
HOMEPAGE="http://lateralgm.org/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+=" libmaker +vanilla"
SLOT_JOSHEDIT="1"
RDEPEND+=" virtual/jre"
BDEPEND+=" virtual/jdk"
MY_PN="LateralGM"
JE_COMMIT="487ddbe470032124dcb50ebee01a24b600ae900e"
JE_PN="JoshEdit"
JE_FN="${JE_PN}-${JE_COMMIT:0:7}.zip"
SRC_URI=\
"https://github.com/IsmAvatar/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
 https://github.com/JoshDreamland/JoshEdit/archive/${JE_COMMIT}.zip -> ${JE_FN}"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"
JAVA_V="1.7"

src_unpack() {
	unpack ${A}
	rm -rf "${S}/modules/joshedit" || die
	mv "${WORKDIR}/${JE_PN}-${JE_COMMIT}" "${S}/modules/joshedit" || die
}

src_prepare() {
	default
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
			# use same .jars but distribute based on lateral-EPLATFORM
			local suffix=""
			local descriptor_suffix=""
			if [[ "${EPLATFORM}" == "linux" ]] ; then
				suffix="-${ABI}"
				descriptor_suffix=" (${ABI})"
			fi
			insinto /usr/$(get_libdir)/enigma/${EPLATFORM}${suffix}
			doins lateralgm.jar
			exeinto /usr/bin
			cp "${FILESDIR}/lateralgm" \
				"${T}/lateralgm-${EPLATFORM}${suffix}" || die
			sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" \
				"${T}/lateralgm-${EPLATFORM}${suffix}" || die
			sed -i -e "s|PLATFORM|${EPLATFORM}${suffix}|g" \
				"${T}/lateralgm-${EPLATFORM}${suffix}" || die
			doexe "${T}/lateralgm-${EPLATFORM}${suffix}"
			doicon org/lateralgm/main/lgm-logo.ico
			make_desktop_entry \
				"/usr/bin/lateralgm-${EPLATFORM}${suffix}" \
				"${MY_PN}${descriptor_suffix}" \
				"/usr/share/pixmap/lgm-logo.ico" "Development;IDE"
		}
		multilib_foreach_abi ml_install_abi
	}
	platforms_foreach_impl platform_install
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
