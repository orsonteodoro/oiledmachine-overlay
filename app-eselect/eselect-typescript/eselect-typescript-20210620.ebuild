# Copyright 2019-2021 Orson Teodoro
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages the /usr/bin/tsc /usr/bin/tsserver symlinks"
HOMEPAGE="https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/app-eselect/eselect-typescript"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
SRC_URI=""
RESTRICT="fetch"

src_unpack() {
	default
	mkdir -p "${S}" || die
	cp "${FILESDIR}/typescript-${PV}.eselect" \
		"${S}/typescript.eselect" || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins typescript.eselect
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
