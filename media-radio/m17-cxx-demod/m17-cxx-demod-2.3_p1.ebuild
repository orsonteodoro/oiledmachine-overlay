# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="kalman-v1.0"

inherit cmake

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/mobilinkd/m17-cxx-demod/archive/refs/tags/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="M17 Demodulator in C++"
HOMEPAGE="https://github.com/mobilinkd/m17-cxx-demod"
LICENSE="GPL-3"
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
	>=dev-build/cmake-3.9
	dev-cpp/blaze
	test? (
		dev-cpp/gtest
	)
"
RESTRICT="mirror"
DOCS=( "LICENSE" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
