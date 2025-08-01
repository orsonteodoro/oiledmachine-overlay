# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="scikit-build-core"
PYTHON_COMPAT=( "python3_"{8..13} )

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
		>=dev-python/RapidFuzz-3.9.0[${PYTHON_USEDEP}]
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
	>=dev-python/cython-3.0.12:3.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.3.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die

	distutils-r1_src_prepare
}

src_configure() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${acutal_cython_pv}")
	local expected_cython_slot="3.0"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Switch cython to ${expected_cython_slot} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
	distutils-r1_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
