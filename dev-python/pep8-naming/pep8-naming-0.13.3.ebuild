# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Naming Convention checker for Python"
HOMEPAGE="
http://pypi.python.org/pypi/pep8-naming
https://github.com/PyCQA/pep8-naming
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	dev-python/flake8[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
SRC_URI="
https://github.com/PyCQA/pep8-naming/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.rst README.rst )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

src_test() {
	run_test() {
einfo "Running test for ${PYTHON}"
		${EPYTHON} setup.py test
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
