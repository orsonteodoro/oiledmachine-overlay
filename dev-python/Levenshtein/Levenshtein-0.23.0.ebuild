# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="The Levenshtein Python C extension module contains functions for \
fast computation of Levenshtein distance and string similarity"
LICENSE="GPL-2+"
HOMEPAGE="https://github.com/maxbachmann/Levenshtein"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc"
DEPEND+="
	(
		<dev-python/RapidFuzz-4
		>=dev-python/RapidFuzz-3.1.0
	)
"
RDEPEND+="
	${DEPEND}
"
# See CI
BDEPEND+="
	>=dev-python/cython-3.0.0_beta3[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-63.1.0[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.22.5
	>=dev-util/ninja-1.10.2.3
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/maxbachmann/Levenshtein/archive/refs/tags/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local actual_cython_pv=$(cython --version \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3.0.0_beta3"
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

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
