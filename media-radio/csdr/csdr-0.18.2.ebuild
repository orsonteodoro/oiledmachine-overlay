# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools cmake

SRC_URI="
https://github.com/jketterl/csdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A simple DSP library and command-line tool for Software Defined Radio."
HOMEPAGE="https://github.com/jketterl/csdr"
LICENSE="BSD GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
DEPEND+="
	>=sci-libs/fftw-3.3:=
	>=media-libs/libsamplerate-0.1.8
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.0
"
RESTRICT="mirror"
DOCS=( README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
