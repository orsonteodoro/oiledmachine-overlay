# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

KEYWORDS="~amd64 ~arm64"
SRC_URI=""

DESCRIPTION="Manages the cython symlinks"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-cython"
LICENSE="GPL-2"
RESTRICT="fetch"
SLOT="0"
IUSE+=" ebuild_revision_1"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cat \
		"${FILESDIR}/cython-${PVR}.eselect" \
		> \
		"${S}/cython.eselect" \
		|| die
}

src_install() {
	insinto "/usr/share/eselect/modules"
	doins "cython.eselect"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
