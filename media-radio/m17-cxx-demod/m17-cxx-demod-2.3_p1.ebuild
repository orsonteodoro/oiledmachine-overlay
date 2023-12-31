# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="
https://github.com/mobilinkd/m17-cxx-demod/archive/refs/tags/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="M17 Demodulator in C++"
HOMEPAGE="https://github.com/mobilinkd/m17-cxx-demod"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	dev-libs/boost
	media-libs/codec2
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.9
	dev-cpp/blaze
	test? (
		dev-cpp/gtest
	)
"
EGIT_COMMIT="kalman-v1.0"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
