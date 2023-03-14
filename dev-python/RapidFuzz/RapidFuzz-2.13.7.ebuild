# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

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
		>=dev-util/ninja-1.10.2.3
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g")
	if ver_test ${cython_pv} -lt 3 && use cpp ; then
		eerror "Switch cython to >= 3.0.0_alpha10 via eselect-cython"
		die
	fi
	export RAPIDFUZZ_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
