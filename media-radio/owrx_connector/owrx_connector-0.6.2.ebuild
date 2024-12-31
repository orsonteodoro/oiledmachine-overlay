# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22

inherit cmake

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/jketterl/owrx_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A direct connection layer for OpenWebRX"
HOMEPAGE="https://github.com/jketterl/owrx_connector"
LICENSE="
	LGPL-3+
	GPL-3+
"
# LGPL-3 only applies to a build file
SLOT="0/$(ver_cut 1-2 ${PV})"
DEPEND+="
	>=media-radio/csdr-0.18
	net-wireless/rtl-sdr
	net-wireless/soapysdr
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.0
	virtual/pkgconfig
"
RESTRICT="mirror"
DOCS=( "LICENSE" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
