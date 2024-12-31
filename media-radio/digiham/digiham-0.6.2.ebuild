# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22

inherit cmake

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/jketterl/digiham/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tools for decoding digital ham communication"
HOMEPAGE="https://github.com/jketterl/digiham"
LICENSE="GPL-3"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=media-radio/codecserver-0.1.0
	>=media-radio/csdr-0.18
	>=dev-libs/icu-57.0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.0
"
DOCS=( "LICENSE" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
