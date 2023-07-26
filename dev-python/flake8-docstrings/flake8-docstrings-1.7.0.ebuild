# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Integration of pydocstyle and flake8 for combined linting and reporting"
HOMEPAGE="https://github.com/pycqa/flake8-docstrings"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
DEPEND+="
	>=dev-python/flake8-3[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-2.1[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_any_dep 'dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]')
	dev-python/tox[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
"
SRC_URI="
https://github.com/PyCQA/flake8-docstrings/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( HISTORY.rst README.rst )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
