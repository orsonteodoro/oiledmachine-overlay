# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional)
# mathy_pydoc
# typer-cli
# pytest-coverage
# types-mock

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/justindujardin/pathy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A simple, flexible, offline capable, cloud storage with a Python path-like interface"
HOMEPAGE="
	https://github.com/justindujardin/pathy
	https://pypi.org/project/pathy
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/smart-open-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/typer-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/pathlib-abc-0.1.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.0[${PYTHON_USEDEP}]
		>=dev-python/autoflake-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/mock-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/mathy_pydoc-0.7.27[${PYTHON_USEDEP}]
		>=dev-python/typer-cli-0.0.12[${PYTHON_USEDEP}]
		dev-python/pytest-coverage[${PYTHON_USEDEP}]
		dev-python/types-mock[${PYTHON_USEDEP}]
		dev-python/types-dataclasses[${PYTHON_USEDEP}]
	)

"
DOCS=( "CHANGELOG.md" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
