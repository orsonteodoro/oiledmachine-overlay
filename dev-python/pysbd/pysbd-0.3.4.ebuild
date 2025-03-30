# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# stanza
# blingfire

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="pySBD"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.8

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/nipunsadvilkar/pySBD/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🐍💯pySBD (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box."
HOMEPAGE="
	https://github.com/nipunsadvilkar/pySBD
	https://pypi.org/project/pysbd
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" benchmark dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		benchmark? (
			>=dev-python/nltk-3.5[${PYTHON_USEDEP}]
			>=dev-python/stanza-1.0.1[${PYTHON_USEDEP}]
			>=dev-python/syntok-1.3.1[${PYTHON_USEDEP}]
			>=dev-python/blingfire-0.1.2[${PYTHON_USEDEP}]
		)
		dev? (
			>=dev-python/pytest-5.4.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-2.10.0[${PYTHON_USEDEP}]
		)
	')
	benchmark? (
		>=dev-python/spacy-2.1.8[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

python_install() {
	distutils-r1_python_install
	delete_benchmark() {
		local path=$(python_get_sitedir)
		rm -rf "${ED}/${path}/benchmarks" || die
	}
	python_foreach_impl delete_benchmark
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
