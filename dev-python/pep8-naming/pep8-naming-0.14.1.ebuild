# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} "pypy3" )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/PyCQA/pep8-naming/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Naming Convention checker for Python"
HOMEPAGE="
https://github.com/PyCQA/pep8-naming
https://pypi.python.org/pypi/pep8-naming
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/flake8-5.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/twine-1.4.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.rst" "README.rst" )

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

src_test() {
	run_test() {
einfo "Running test for ${PYTHON}"
		${EPYTHON} setup.py test
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
