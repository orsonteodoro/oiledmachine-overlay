# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream only list up to 3.8

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://files.pythonhosted.org/packages/0a/0a/cc1cb791ce7f55d3da49f79ea4786d947e993ad7c106f06e5f5f9a901c52/fastapi_simple_cachecontrol-0.1.0.tar.gz
"

DESCRIPTION="Cache-Control header management for FastAPI"
HOMEPAGE="
	https://pypi.org/project/fastapi-simple-cachecontrol
"
LICENSE="
	Apache-2.0
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
	>=dev-python/poetry-0.12[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/black-19.10_beta0[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.7.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.3.5[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
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
