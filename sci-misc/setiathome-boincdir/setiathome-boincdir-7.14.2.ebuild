# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

BOINC_VER="${PV}"
export BOINC_MAJOR="$(get_version_component_range 1 ${PV})"
export BOINC_MINOR="$(get_version_component_range 2 ${PV})"

MY_P="boinc-client_release-$BOINC_MAJOR.$BOINC_MINOR-$BOINC_VER"
SRC_URI="https://github.com/BOINC/boinc/archive/client_release/$BOINC_MAJOR.$BOINC_MINOR/$BOINC_VER.zip -> boinc-$BOINC_VER.zip"
DESCRIPTION="Boinc"
HOMEPAGE="http://boinc.berkeley.edu/"

LICENSE="GPL-2"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

IUSE=""
RDEPEND=""

DEPEND="${RDEPEND}
	=sci-misc/boinc-${BOINC_VER}*
"

S="${WORKDIR}/${MY_P}"

src_install() {
	mkdir -p "${D}"/usr/share/boinc/${SLOT}
	cp -r "${WORKDIR}/${MY_P}/api" ${D}/usr/share/boinc/${SLOT} || die
	cp -r "${WORKDIR}/${MY_P}/lib" ${D}/usr/share/boinc/${SLOT} || die
	cp "${WORKDIR}/${MY_P}/version.h" ${D}/usr/share/boinc/${SLOT} || die
	#cp "${WORKDIR}/${MY_P}/version.cpp" ${D}/usr/share/boinc/${SLOT} || die
	cp "${WORKDIR}/${MY_P}/COPYING" ${D}/usr/share/boinc/${SLOT} || die
	cp "${WORKDIR}/${MY_P}/COPYING.LESSER" ${D}/usr/share/boinc/${SLOT} || die
	cp "${WORKDIR}/${MY_P}/COPYRIGHT" ${D}/usr/share/boinc/${SLOT} || die
	cp "${WORKDIR}/${MY_P}/client/client_state.cpp" ${D}/usr/share/boinc/${SLOT} || die
	#cp "${WORKDIR}/${MY_P}/client/client_state.h" ${D}/usr/share/boinc/${SLOT} || die
}
