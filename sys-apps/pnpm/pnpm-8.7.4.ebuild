# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager"
HOMEPAGE="
https://pnpm.io/
https://github.com/pnpm/pnpm
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT_MAJOR="${PV%%.*}"
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE+=" r2"
CDEPEND+="
	>=net-libs/nodejs-16.18[corepack,ssl]
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
	corepack enable
	mkdir -p "${EROOT}/usr/share/${PN}"
	corepack prepare "${PN}@${PV}" -o="${EROOT}/usr/share/${PN}/${PN}-${SLOT_MAJOR}.tgz"
}

pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
einfo "Removing ${PN}-${SLOT_MAJOR}.tgz"
		rm -rf "${EROOT}/usr/share/${PN}/${PN}-${SLOT_MAJOR}.tgz"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
