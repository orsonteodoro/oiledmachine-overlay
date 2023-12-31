# Copyright 2019-2020,2023 Orson Teodoro
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages the /usr/include/node symlink"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-nodejs"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos"
SLOT="0"
SRC_URI=""
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
