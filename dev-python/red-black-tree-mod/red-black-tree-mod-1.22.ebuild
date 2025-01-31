# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz
"

DESCRIPTION="Flexible python implementation of red black trees"
HOMEPAGE="
	https://pypi.org/project/red-black-tree-mod
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "COPYING"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
