# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 pypi

DESCRIPTION="Python library for fast approximate string matching using Jaro and \
Jaro-Winkler similarity"
LICENSE=""
HOMEPAGE="https://github.com/maxbachmann/JaroWinkler"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cpp"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/cython-3.0.0_alpha11[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz_capi-1.0.5[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	cpp? (
		>=dev-util/cmake-3.12
		>=sys-devel/gcc-10.2.1
		dev-util/ninja
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
	export JAROWINKLER_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
