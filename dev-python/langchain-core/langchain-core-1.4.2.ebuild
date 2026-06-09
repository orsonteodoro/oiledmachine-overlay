# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit distutils-r1 caret pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="LangChain Core contains the base abstractions that power the rest of the LangChain ecosystem"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/tree/master/libs/core
	https://pypi.org/project/langchain-core
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev extended-testing lint test typing
"
# For numpy:
REQUIRED_USE="
	|| (
		python_targets_python3_11
		python_targets_python3_12
		python_targets_python3_13
		python_targets_python3_14
	)
"
RDEPEND+="
	>=dev-python/pydantic-1[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]

	$(caret dev-python/langsmith 0.1.0 '[${PYTHON_USEDEP}]')
	$(caret dev-python/tenacity 8.1.0 '[${PYTHON_USEDEP}]')
	$(caret dev-python/jsonpatch 1.33 '[${PYTHON_USEDEP}]')
	$(caret dev-python/pyyaml 5.3 '[${PYTHON_USEDEP}]')
	$(caret dev-python/packaging 23.2 '[${PYTHON_USEDEP}]')
	$(caret dev-python/jinja2 3 '[${PYTHON_USEDEP}]')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
	dev? (
		$(caret dev-python/jupyter 1.0.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/setuptools 67.6.1 '[${PYTHON_USEDEP}]')
		$(caret dev-python/grandalf 0.8 '[${PYTHON_USEDEP}]')
	)
	extended-testing? (
		dev-python/jinja2[${PYTHON_USEDEP}]
	)
	lint? (
		$(caret dev-util/ruff 0.1.5)
	)
	test? (
		$(caret dev-python/pytest 7.3.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/freezegun 1.2.2 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-mock 3.10.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/syrupy 4.0.2 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-watcher 0.3.4 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-asyncio 0.21.1 '[${PYTHON_USEDEP}]')
		$(caret dev-python/grandalf 0.8 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-profiling 1.7.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/responses 0.25.0 '[${PYTHON_USEDEP}]')
		virtual/numpy[${PYTHON_USEDEP}]
	)
	typing? (
		$(caret dev-python/mypy 1 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-pyyaml 6.0.12.2 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-requests 2.28.11.5 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-jinja2 2.11.9 '[${PYTHON_USEDEP}]')
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
