# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/weasel/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🦦 weasel: A small and easy workflow system"
HOMEPAGE="
	https://github.com/explosion/weasel
	https://pypi.org/project/weasel
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/confection-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/wasabi-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/srsly-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/typer-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpathlib-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/smart-open-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.13.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
	dev? (
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-3.2.0[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/types-setuptools-57.0.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.0.259
		>=dev-python/isort-5.12.0[${PYTHON_USEDEP}]
		dev-python/types-requests[${PYTHON_USEDEP}]
	)
"
BDEPEND+="
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
