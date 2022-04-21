# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Tools for decoding digital ham communication"
HOMEPAGE="https://github.com/jketterl/digiham"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
DEPEND+="
	>=media-radio/codecserver-0.1.0
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.0"
SRC_URI="
https://github.com/jketterl/digiham/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )
