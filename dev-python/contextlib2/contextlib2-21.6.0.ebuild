# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_10" "pypy3" ) # Upstream supports up to 3.10.  See README.rst.

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/jazzband/contextlib2/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="contextlib2 is a backport of the standard library's contextlib module to earlier Python versions."
HOMEPAGE="
	https://contextlib2.readthedocs.io/en/stable/
	https://github.com/jazzband/contextlib2
	https://pypi.org/project/contextlib2/
"
LICENSE="
	Apache-2.0
	PSF-3.3
"
# See https://github.com/jazzband/contextlib2/blob/21.6.0/LICENSE.txt
RESTRICT="mirror test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )
PATCHES=(
)

distutils_enable_sphinx "docs"

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
