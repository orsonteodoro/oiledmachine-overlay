# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/RapidFuzz"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cpp doc numpy test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+="
	(
		>=dev-python/JaroWinkler-3.0.4[${PYTHON_USEDEP}]
		<dev-python/JaroWinkler-4.0.0[${PYTHON_USEDEP}]
	)
	>=dev-cpp/taskflow-3.3.0
	numpy? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/docutils-0.18.1[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
	)
	cpp? (
		>=dev-python/cython-3.0.9:3.0[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz_capi-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/scikit-build-0.17.0[${PYTHON_USEDEP}]
		>=dev-build/cmake-3.22.5
		>=dev-build/ninja-1.10.2.3
	)
	test? (
		>=dev-python/pytest-6.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_configure() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3.0.0_alpha11"
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
