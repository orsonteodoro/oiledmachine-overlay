# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit distutils-r1

S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/maxbachmann/Levenshtein/archive/refs/tags/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"

DESCRIPTION="The Levenshtein Python C extension module contains functions for \
fast computation of Levenshtein distance and string similarity"
LICENSE="GPL-2+"
HOMEPAGE="https://github.com/maxbachmann/Levenshtein"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
RDEPEND+="
	(
		>=dev-python/RapidFuzz-3.8.0[${PYTHON_USEDEP}]
		<dev-python/RapidFuzz-4[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
# See CI
BDEPEND+="
	>=dev-build/cmake-3.22.1
	>=dev-build/ninja-1.10.1
	>=dev-python/cython-3.0:3.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-69.2.0[${PYTHON_USEDEP}]
        >=dev-python/wheel-0.32.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.3.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"

src_configure() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3.0.2"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -lt ${required_cython_major} ; then
eerror
eerror "Switch cython to >= ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
	distutils-r1_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
