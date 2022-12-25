# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for the csdr library"
HOMEPAGE="https://github.com/jketterl/pycsdr"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+="
	${PYTHON_DEPS}
	>=media-radio/csdr-0.18
"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
SRC_URI="
https://github.com/jketterl/pycsdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
