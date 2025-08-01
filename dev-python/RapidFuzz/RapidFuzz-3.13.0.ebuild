# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_PEP517="scikit-build-core"
EPYTEST_XDIST=1
PYTHON_COMPAT=( "python3_"{8..13} )

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
	>=dev-cpp/taskflow-3.9.0
	numpy? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.15
	doc? (
		>=dev-python/docutils-0.18.1[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
	)
	cpp? (
		>=dev-python/cython-3.0.12:3.0[${PYTHON_USEDEP}]
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

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die
	# remove bundled libraries
	rm -r extern || die
	# force recythonization
	find src -name '*.cxx' -delete || die
	# do not require exact taskflow version
	sed -i -e '/Taskflow/s:3\.9\.0::' CMakeLists.txt || die
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.11:0.8:' pyproject.toml || die

	distutils-r1_src_prepare

	export RAPIDFUZZ_BUILD_EXTENSION=1
}

src_configure() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="3.0"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" && use cpp ; then
eerror
eerror "Switch cython to >= ${expected_cython_slot} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
	export RAPIDFUZZ_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
