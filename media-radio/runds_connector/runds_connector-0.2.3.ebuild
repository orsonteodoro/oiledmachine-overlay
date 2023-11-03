# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/jketterl/runds_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="OpenWebRX connector implementation for R&S EB200 or Ammos protocol based receivers"
HOMEPAGE="https://github.com/jketterl/runds_connector"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
DEPEND+="
	media-radio/owrx_connector
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.0
	virtual/pkgconfig
"
RESTRICT="mirror"
DOCS=( LICENSE )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
