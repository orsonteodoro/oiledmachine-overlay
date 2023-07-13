# Copyright 2019-2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Manages the cython symlinks"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-cython"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
SLOT="0"
SRC_URI=""
RESTRICT="fetch"
IUSE+=" r1"

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
