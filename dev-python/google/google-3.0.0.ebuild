# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"

DESCRIPTION="Python bindings to the Google search engine."
HOMEPAGE="
	http://breakingcode.wordpress.com/
	https://pypi.org/project/google
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/beautifulsoup4-4.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
