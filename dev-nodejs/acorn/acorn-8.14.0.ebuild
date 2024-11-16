# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="A small, fast, JavaScript-based JavaScript parser Resources"
HOMEPAGE="
https://github.com/acornjs/acorn
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="$(ver_cut 1-2 ${PV})"
IUSE+=" "
CDEPEND+="
	!sys-apps/npm:0
	sys-apps/npm
"
DEPEND+="
	${CDEPEND}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
"

pkg_postinst() {
	npm install -g "acorn@${PV}"
}

pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		npm uninstall -g "acorn@${PV}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
