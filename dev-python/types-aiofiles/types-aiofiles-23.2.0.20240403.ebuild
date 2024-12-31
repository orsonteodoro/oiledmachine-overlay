# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz
"

DESCRIPTION="Typing stubs for aiofiles"
HOMEPAGE="
	https://github.com/python/typeshed
	https://github.com/python/typeshed/tree/main/stubs/aiofiles
	https://pypi.org/project/types-aiofiles/
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "CHANGELOG.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
