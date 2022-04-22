# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="aprs.fi APRS symbol set, high-resolution, vector"
HOMEPAGE="https://github.com/hessu/aprs-symbols"
LICENSE="all-rights-reserved CC-BY-SA-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
EGIT_COMMIT="5c2abe2658ee4d2563f3c73b90c6f59124839802"
SRC_URI="
https://github.com/hessu/aprs-symbols/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( COPYRIGHT.md README.md )

src_install() {
	insinto "/usr/share/aprs-symbols"
	doins -r "png"
	einstalldocs
}
