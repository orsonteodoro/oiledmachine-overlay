# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 pypi

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/RapidFuzz"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cpp doc numpy test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+="
	(
		<dev-python/JaroWinkler-2.0.0
		>=dev-python/JaroWinkler-1.1.0
	)
	numpy? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
	)
	cpp? (
		>=dev-python/cython-3.0.0_alpha11[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz_capi-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/scikit-build-0.15.0[${PYTHON_USEDEP}]
		>=dev-util/cmake-3.22.5
		>=dev-build/ninja-1.10.2.3
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RESTRICT="mirror"

src_configure() {
	local actual_cython_pv=$(cython --version \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3.0.0_alpha10"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -lt ${required_cython_major} && use cpp ; then
eerror
eerror "Switch cython to >= ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
	export RAPIDFUZZ_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
