# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="5c2abe2658ee4d2563f3c73b90c6f59124839802"
SRC_URI="
https://github.com/hessu/aprs-symbols/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DESCRIPTION="An Automatic Packet Reporting System (APRS) symbol set for amateur radio maps"
HOMEPAGE="https://github.com/hessu/aprs-symbols"
LICENSE="all-rights-reserved CC-BY-SA-2.0"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
DOCS=( "COPYRIGHT.md" "README.md" )

src_install() {
	insinto "/usr/share/aprs-symbols"
	doins -r "png"
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
