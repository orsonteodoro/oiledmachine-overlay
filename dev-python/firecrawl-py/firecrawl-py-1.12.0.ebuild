# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="firecrawl_py"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10,11} ) # Upstream lists up to 3.10

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Python SDK for Firecrawl API"
HOMEPAGE="
	https://github.com/mendableai/firecrawl
	https://pypi.org/project/firecrawl-py
"
LICENSE="
	GPL-3
	MIT
"
# MIT - LICENSE, pyproject.toml
# GPL-3 - setup.py
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
#	dev-python/asyncio[${PYTHON_USEDEP}]
RDEPEND+="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
