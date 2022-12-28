# Copyright 2019-2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Manages the cython symlinks"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-cython"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"

# Live ebuilds do not get keyworded

RESTRICT="fetch"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cat "${FILESDIR}/cython-${PVR}.eselect" > "${S}/cython.eselect" || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins cython.eselect
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
