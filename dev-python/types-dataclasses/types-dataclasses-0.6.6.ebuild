# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Typing stubs for dataclasses"
HOMEPAGE="
	https://github.com/python/typeshed
	https://pypi.org/project/types-dataclasses
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # no tests
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "CHANGELOG.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
