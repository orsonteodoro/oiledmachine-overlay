# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Manages the /usr/include/node symlink"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"

# Live ebuilds do not get keyworded

RESTRICT="fetch"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cp "${FILESDIR}/nodejs-${PVR}.eselect" "${S}/nodejs.eselect" || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins nodejs.eselect
}
