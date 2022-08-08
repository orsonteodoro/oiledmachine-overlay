# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="M17 Demodulator in C++"
HOMEPAGE="https://github.com/mobilinkd/m17-cxx-demod"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" test"
DEPEND+="
	dev-libs/boost
	media-libs/codec2
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.9
	test? ( dev-cpp/gtest )
"
SRC_URI="
https://github.com/mobilinkd/m17-cxx-demod/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
