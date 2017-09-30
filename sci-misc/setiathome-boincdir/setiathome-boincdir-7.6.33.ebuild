# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

BOINC_VER="${PV}"
BOINC_MAJOR=`echo $BOINC_VER | cut -d. -f1`
BOINC_MINOR=`echo $BOINC_VER | cut -d. -f2`

MY_P="boinc-client_release-$BOINC_MAJOR.$BOINC_MINOR-$BOINC_VER"
DESCRIPTION="Boinc"
HOMEPAGE="http://boinc.berkeley.edu/"
SRC_URI="https://github.com/BOINC/boinc/archive/client_release/$BOINC_MAJOR.$BOINC_MINOR/$BOINC_VER.zip -> boinc-$BOINC_VER.zip"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

IUSE=""
RDEPEND=""

DEPEND="${RDEPEND}
	=sci-misc/boinc-${BOINC_VER}*
"

S="${WORKDIR}/${MY_P}"

src_install() {
	mkdir -p "${D}"/usr/share/boinc/${PV}
	cp -r "${WORKDIR}/${MY_P}/api" ${D}/usr/share/boinc/${PV}
	cp -r "${WORKDIR}/${MY_P}/lib" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/version.h" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/version.cpp" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/COPYING" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/COPYING.LESSER" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/COPYRIGHT" ${D}/usr/share/boinc/${PV}
	cp "${WORKDIR}/${MY_P}/client/client_state.cpp" ${D}/usr/share/boinc/${PV}
	#cp "${WORKDIR}/${MY_P}/client/client_state.h" ${D}/usr/share/boinc/${PV}
}
