# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="Fast, disk space efficient package manager"
HOMEPAGE="
https://pnpm.io/
https://github.com/pnpm/pnpm
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT_MAJOR="9" # See https://github.com/pnpm/pnpm/blob/v9.15.3/pnpm-lock.yaml#L1
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE+=" ebuild_revision_2"
CDEPEND+="
	>=net-libs/nodejs-18.19[corepack,ssl]
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
# OILEDMACHINE-OVERLAY-TEST:  passed (8.10.5, 20231219)
