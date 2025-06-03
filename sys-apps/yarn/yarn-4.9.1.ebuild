# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="Fast, reliable, and secure dependency management."
HOMEPAGE="
https://yarnpkg.com/
https://github.com/yarnpkg/berry
"
LICENSE="
	BSD-2
"
RESTRICT="mirror"
SLOT_MAJOR="8" # See https://github.com/yarnpkg/berry/blob/%40yarnpkg/cli/4.9.1/yarn.lock#L5
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE+=" +ssl ebuild_revision_3"
CDEPEND+="
	!sys-apps/yarn:0
	>=net-libs/nodejs-18.12.0[corepack,ssl?]
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
# Although a previous ebuild with the same name exists, this ebuild is
# independently created.  This is the a hydrated tarball version.
