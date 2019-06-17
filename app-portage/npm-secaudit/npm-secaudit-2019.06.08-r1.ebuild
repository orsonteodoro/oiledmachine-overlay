# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Sync hook for npm security checks."
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="sys-apps/portage
         app-shells/bash"
IUSE=""

S="${WORKDIR}"

src_install() {
	mkdir -p "${D}"/etc/portage/postsync.d/
	cp "${FILESDIR}/${PN}-v${PV}" "${D}"/etc/portage/postsync.d/${PN} || die
}
