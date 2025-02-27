# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="tree"

ABSEIL_CPP_PV="20210324.2"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/deepmind/tree/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/abseil/abseil-cpp/archive/refs/tags/${ABSEIL_CPP_PV}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
"

DESCRIPTION="tree is a library for working with nested data structures"
HOMEPAGE="https://github.com/deepmind/tree"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test ebuild_revision_1"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/pybind11[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/absl-py-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/attrs-18.2.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.15.4[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.11.2[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-0.1.8-no-download.patch"
)

distutils_enable_sphinx "docs"

src_unpack() {
	export MAKEOPTS="-j1"
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
