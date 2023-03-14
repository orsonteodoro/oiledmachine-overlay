# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A chess library for Python, with move generation and validation, \
PGN parsing and writing, Polyglot opening book reading, Gaviota tablebase \
probing, Syzygy tablebase probing, and UCI/XBoard engine communication"
HOMEPAGE="
	https://github.com/niklasf/python-chess
"
LICENSE="
	GPL-3+
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" crafty doc stockfish test"
REQUIRED_USE+="
	test? (
		crafty
		stockfish
	)
"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		games-board/crafty[${PYTHON_USEDEP}]
		games-board/stockfish[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		net-libs/tox[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	crafty? (
		games-board/crafty[${PYTHON_USEDEP}]
	)
	stockfish? (
		games-board/stockfish[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/niklasf/python-chess/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.rst CHANGELOG-OLD.rst README.rst )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.txt
}

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
