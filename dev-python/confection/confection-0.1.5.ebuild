# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/confection/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🍬 Confection: the sweetest config system for Python"
HOMEPAGE="
	https://github.com/explosion/confection
	https://pypi.org/project/confection
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
	>=dev-python/srsly-2.4.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/catalogue-2.0.3[${PYTHON_USEDEP}]
		>=dev-python/pathy-0.3.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/black-22.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.8.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
