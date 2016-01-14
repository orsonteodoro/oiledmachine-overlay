# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P="setiathome-boincdir-${PV}"
DESCRIPTION="Boinc"
HOMEPAGE="http://boinc.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

IUSE=""
RDEPEND=""

BOINC_VER="${PV}"
BOINC_MAJOR=`echo $BOINC_VER | cut -d. -f1`
BOINC_MINOR=`echo $BOINC_VER | cut -d. -f2`
DEPEND="${RDEPEND}
	=sci-misc/boinc-${BOINC_VER}*
"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	URL="https://github.com/BOINC/boinc/archive/client_release/$BOINC_MAJOR.$BOINC_MINOR/$BOINC_VER.zip"

	wget -O "${T}/boinc-${BOINC_VER}.zip" ${URL}
	unzip "${T}/boinc-${BOINC_VER}.zip" -d "${WORKDIR}/${MY_P}"
	mv "${WORKDIR}/${MY_P}/boinc-client_release-${BOINC_MAJOR}.${BOINC_MINOR}-${BOINC_VER}" "${WORKDIR}/${MY_P}/boinc"
}

src_install() {
	mkdir -p "${D}"/usr/share/boinc/client
	cp -r "${WORKDIR}/${MY_P}/boinc/api" ${D}/usr/share/boinc
	cp -r "${WORKDIR}/${MY_P}/boinc/lib" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/version.h" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/version.cpp" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/COPYING" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/COPYING.LESSER" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/COPYRIGHT" ${D}/usr/share/boinc
	cp "${WORKDIR}/${MY_P}/boinc/client/client_state.cpp" ${D}/usr/share/boinc
	#cp "${WORKDIR}/${MY_P}/boinc/client/client_state.h" ${D}/usr/share/boinc/client
}
