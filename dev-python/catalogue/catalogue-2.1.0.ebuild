# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/catalogue/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Super lightweight function registries for your library"
HOMEPAGE="
	https://github.com/explosion/catalogue
	https://pypi.org/project/catalogue
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pytest-4.6.5[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/types-dataclasses[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	dev-python/srsly[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
