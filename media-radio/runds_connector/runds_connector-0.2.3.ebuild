# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22

inherit cmake

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/jketterl/runds_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="OpenWebRX connector implementation for R&S EB200 or Ammos protocol based receivers"
HOMEPAGE="https://github.com/jketterl/runds_connector"
LICENSE="GPL-3+"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	media-radio/owrx_connector
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.0
	virtual/pkgconfig
"
RESTRICT="mirror"
DOCS=( "LICENSE" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
