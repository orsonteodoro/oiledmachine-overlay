# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/psf/pyperf/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Toolkit to run Python benchmarks"
HOMEPAGE="
http://pyperf.readthedocs.io/
https://github.com/psf/pyperf
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc psutil test"
RDEPEND+="
	psutil? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

distutils_enable_sphinx "docs"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		sed -i -e "s|deps|allowlist_externals|g" tox.ini || die
		tox -e testenv || die
	}
	python_foreach_impl run_test
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "COPYING"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
