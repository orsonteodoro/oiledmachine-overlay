# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="dockerpy-creds"

# pypi and setup.py uses docker-pycreds but the github project uses dockerpy-creds.

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Up to to 3.6 listed

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/shin-/dockerpy-creds/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python bindings for the docker credentials store API"
HOMEPAGE="
	https://github.com/shin-/dockerpy-creds
	https://pypi.org/project/dockerpy-creds
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/pytest-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-2.4.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.1[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
