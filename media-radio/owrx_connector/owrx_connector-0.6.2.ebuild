# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/jketterl/owrx_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Direct conection layer for openwebrx"
HOMEPAGE="https://github.com/jketterl/owrx_connector"
LICENSE="GPL-3 LGPL-3+"
# LGPL-3 only applies to a build file
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
	>=dev-util/cmake-3.0
	virtual/pkgconfig
"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
