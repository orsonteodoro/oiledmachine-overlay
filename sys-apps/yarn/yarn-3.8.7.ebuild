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
SLOT_MAJOR="6" # Based on yarn.lock
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE+="
+ssl
ebuild_revision_5
"
CDEPEND+="
	!sys-apps/yarn:0
	>=net-libs/nodejs-14.10.0[corepack,ssl?]
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

get_min_node_slot() {
	local x
	for x in $(seq 14 30) ; do
		if [[ -e "${ESYSROOT}/usr/lib/node/${x}/bin/node" ]] ; then
			echo "${x}"
			return
		fi
	done
	echo ""
}

pkg_setup() {
	local node_pv=$(get_min_node_slot)
	export PATH="${ESYSROOT}/usr/lib/node/${node_pv}/bin:${PATH}"
einfo "PATH:  ${PATH}"
}

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
