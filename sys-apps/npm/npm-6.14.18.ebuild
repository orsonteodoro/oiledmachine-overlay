# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LOCKFILE_VER="1" # See also https://github.com/npm/cli/blob/v6.14.18/package-lock.json#L4

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="The package manager for JavaScript"
HOMEPAGE="
https://docs.npmjs.com/cli
https://github.com/npm/cli
"
LICENSE="
	Artistic-2
"
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}/$(ver_cut 1-2 ${PV})"
IUSE+=" +ssl ebuild_revision_2"
CDEPEND+="
	!sys-apps/npm:0
	|| (
		>=net-libs/nodejs-9.3.0[corepack,ssl?]
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

src_configure() {
	local node_version=$(node --version | sed -e "s|v||g")
	if ver_test "${node_version%%.*}" -ge "9" ; then
		:
	else
eerror
eerror "Do either:"
eerror
eerror "  eselect nodejs set node9"
eerror
eerror "    or"
eerror
eerror "  eselect nodejs set node16"
eerror
eerror "    or"
eerror
eerror "  eselect nodejs set node18"
eerror
eerror "    or"
eerror
eerror "  eselect nodejs set node20"
eerror
eerror "    or"
eerror
eerror "  eselect nodejs set node22"
eerror
eerror "    or"
eerror
eerror "  eselect nodejs set node23"
eerror
		die
	fi
}

pkg_postinst() {
	local node_slot=$(node --version \
		| sed -e "s|^v||g" \
		| cut -f 1 -d ".")
	if ver_test "${node_slot}" -eq "18" ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
	fi

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
