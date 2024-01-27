# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LOCKFILE_VER="3" # See https://docs.npmjs.com/cli/v10/configuring-npm/package-lock-json#lockfileversion
# See also https://github.com/npm/cli/blob/v10.2.4/package-lock.json#L4

DESCRIPTION="The package manager for JavaScript"
HOMEPAGE="
https://docs.npmjs.com/cli
https://github.com/npm/cli
"
LICENSE="
	Artistic-2
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="${LOCKFILE_VER}/$(ver_cut 1-2 ${PV})"
IUSE+=" +ssl r1"
CDEPEND+="
	!sys-apps/npm:0
	|| (
		>=net-libs/nodejs-18.17:18[corepack,ssl?]
		>=net-libs/nodejs-20.5[corepack,ssl?]
	)
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
	corepack prepare "${PN}@${PV}" -o="${EROOT}/usr/share/${PN}/${PN}-${LOCKFILE_VER}.tgz"
}

pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
einfo "Removing ${PN}-${LOCKFILE_VER}.tgz"
		rm -rf "${EROOT}/usr/share/${PN}/${PN}-${LOCKFILE_VER}.tgz"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# Although a previous ebuild with the same name exists, this ebuild is
# independently created.  This is the a hydrated tarball version.
