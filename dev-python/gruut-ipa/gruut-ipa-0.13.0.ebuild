# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.9

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/rhasspy/gruut-ipa/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python library for manipulating pronunciations using the International Phonetic Alphabet (IPA)"
HOMEPAGE="
	https://github.com/rhasspy/gruut-ipa
	https://pypi.org/project/gruut-ipa
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/black-19.10_beta0
		>=dev-python/coverage-5.0.4
		>=dev-python/flake8-3.7.9
		>=dev-python/mypy-0.910
		>=dev-python/pylint-2.10.2
		>=dev-python/pytest-5.4.1
		>=dev-python/pytest-cov-2.8.1
	)
	test? (
		dev-python/pytest
	)
"
DOCS=( "README.md" )

python_install() {
	distutils-r1_python_install
	delete_benchmark() {
		local path=$(python_get_sitedir)
		rm -rf "${ED}/${path}/tests" || die
	}
	python_foreach_impl delete_benchmark
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
