# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Integrates the Stockfish chess engine with Python"
HOMEPAGE="
https://pypi.python.org/pypi/stockfish
https://github.com/zhelyabuzhsky/stockfish
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	games-board/stockfish
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/mypy[${PYTHON_USEDEP}]
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/zhelyabuzhsky/stockfish/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( README.md )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
