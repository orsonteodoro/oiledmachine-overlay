# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Direct conection layer for openwebrx"
HOMEPAGE="https://github.com/jketterl/owrx_connector"
LICENSE="GPL-3 LGPL-3+"
# LGPL-3 only applies to a build file
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
DEPEND+="
	net-wireless/rtl-sdr
	net-wireless/soapysdr
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.0
	virtual/pkgconfig"
SRC_URI="
https://github.com/jketterl/owrx_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )
