# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A small, fast, JavaScript-based JavaScript parser Resources"
HOMEPAGE="
https://github.com/acornjs/acorn
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
SRC_URI=""
S="${WORKDIR}"
RESTRICT="mirror"

pkg_postinst() {
	npm install -g "acorn@${PV}"
}

pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		npm uninstall -g "acorn@${PV}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
