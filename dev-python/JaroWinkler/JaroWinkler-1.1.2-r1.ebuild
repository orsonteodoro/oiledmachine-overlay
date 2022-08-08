# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python library for fast approximate string matching using Jaro and
Jaro-Winkler similarity"
LICENSE=""
HOMEPAGE="https://github.com/maxbachmann/JaroWinkler"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" cpp"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cython-3.0.0_alpha10[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz-capi-1.0.5[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-63.1.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	cpp? (
		dev-util/cmake
		dev-util/ninja
		>=sys-devel/gcc-10.2.1
	)
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local cython_pv=$(cython --version 2>&1 | cut -f 3 -d " " | sed -e "s|a|_alpha|g")
	if ver_test ${cython_pv} -lt 3 && use cpp ; then
		eerror "Switch cython to >= 3.0.0_alpha10 via eselect-cython"
		die
	fi
	export JAROWINKLER_IMPLEMENTATION=$(usex cpp "cpp" "python")
	distutils-r1_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
