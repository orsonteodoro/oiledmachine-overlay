# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
SLOT_MAJOR="${PV%%.*}"
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE+=" ebuild-revision-2"
CDEPEND+="
	>=net-libs/nodejs-18.14[corepack,ssl]
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
