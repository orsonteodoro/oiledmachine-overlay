# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/jketterl/digiham/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Tools for decoding digital ham communication"
HOMEPAGE="https://github.com/jketterl/digiham"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
DEPEND+="
	>=media-radio/codecserver-0.1.0
	>=media-radio/csdr-0.18
	>=dev-libs/icu-57
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.0
"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
