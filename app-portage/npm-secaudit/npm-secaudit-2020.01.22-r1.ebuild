# Copyright 1999-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Sync hook for npm security checks."
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
LICENSE="|| ( GPL-2 MIT )"
KEYWORDS="amd64"
SLOT="0"
RDEPEND="app-shells/bash
	sys-apps/portage"
inherit eutils
S="${WORKDIR}"

src_install() {
	exeinto /etc/portage/postsync.d
	cat "${FILESDIR}/${PN}-v${PV}" > "${T}/${PN}"
	doexe "${T}/${PN}"
}

pkg_postinst() {
	elog \
"If emerge complains about a missing npm package and @npm-security-update\n\
emerge set, you can edit and remove the problematic package from\n\
/etc/portage/sets/npm-security-update."
}
