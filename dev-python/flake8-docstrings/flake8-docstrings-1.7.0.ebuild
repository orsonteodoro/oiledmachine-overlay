# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
FLAKE8_PV="3"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI only tests up to 3.10

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/PyCQA/flake8-docstrings/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Integration of pydocstyle and flake8 for combined linting and reporting"
HOMEPAGE="https://github.com/pycqa/flake8-docstrings"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/flake8-${FLAKE8_PV}[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-2.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_any_dep '
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	')
	>=dev-python/tox-1.6[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flake8-${FLAKE8_PV}[${PYTHON_USEDEP}]
	)
"
DOCS=( "HISTORY.rst" "README.rst" )

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
