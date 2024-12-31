# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # D10 uses 3.7

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/jketterl/pycsdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python bindings for the csdr library"
HOMEPAGE="https://github.com/jketterl/pycsdr"
LICENSE="GPL-3+"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=media-radio/csdr-${PV}:${SLOT}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RESTRICT="mirror"
DOCS=( "LICENSE" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
