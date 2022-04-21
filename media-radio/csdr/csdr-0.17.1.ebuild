# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A simple DSP library and command-line tool for Software Defined Radio."
HOMEPAGE="https://github.com/jketterl/csdr"
LICENSE="BSD GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
DEPEND+=" >=sci-libs/fftw-3.3:="
RDEPEND+=" ${DEPEND}"
BDEPEND+=" "
SRC_URI="
https://github.com/jketterl/csdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
DOCS=( README.md )

src_prepare() {
	default
	eautoreconf
}
