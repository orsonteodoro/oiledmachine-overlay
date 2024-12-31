# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/fastapi/typer/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Typer, build great CLIs. Easy to code. Based on Python type hints."
HOMEPAGE="
	https://typer.tiangolo.com/
	https://github.com/fastapi/typer
	https://pypi.org/project/typer
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_any_dep '
		>=dev-vcs/pre-commit-2.17.0[${PYTHON_SINGLE_USEDEP}]
	')
	doc? (
		>=dev-python/mkdocs-material-9.5.33[${PYTHON_USEDEP}]
		>=dev-python/mdx-include-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-redirects-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		>=virtual/pillow-10.4.0[${PYTHON_USEDEP}]
		>=dev-python/cairosvg-2.7.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-macros-plugin-1.0.5[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.2[${PYTHON_USEDEP},toml]
		>=dev-python/pytest-xdist-1.32.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-sugar-0.9.4[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/rich-10.11.0[${PYTHON_USEDEP}]
		>=dev-python/shellingham-1.3.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.2.0
	)
"
DOCS=( "README.md" )
