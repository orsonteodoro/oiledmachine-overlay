# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="OpenWebRX connector implementation for R&S EB200 or Ammos protocol based receivers"
HOMEPAGE="https://github.com/jketterl/runds_connector"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
DEPEND+="
	media-radio/owrx_connector
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.0
	virtual/pkgconfig"
SRC_URI="
https://github.com/jketterl/runds_connector/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE )
