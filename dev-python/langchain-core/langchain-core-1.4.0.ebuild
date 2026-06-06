# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{12..14} )

inherit distutils-r1 pypi

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
dev lint test typing
"
# For numpy:
REQUIRED_USE="
	|| (
		python_targets_python3_12
		python_targets_python3_13
		python_targets_python3_14
	)
"
RDEPEND+="
	>=dev-python/langsmith-0.3.45[${PYTHON_USEDEP}]
	<dev-python/langsmith-1.0.0[${PYTHON_USEDEP}]

	!~dev-python/tenacity-8.4.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.1.0[${PYTHON_USEDEP}]
	<dev-python/tenacity-10.0.0[${PYTHON_USEDEP}]

	>=dev-python/jsonpatch-1.33.0[${PYTHON_USEDEP}]
	<dev-python/jsonpatch-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/pyyaml-5.3.0[${PYTHON_USEDEP}]
	<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

	>=dev-python/typing-extensions-4.7.0[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5.0.0[${PYTHON_USEDEP}]

	>=dev-python/packaging-23.2.0[${PYTHON_USEDEP}]

	>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/uuid-utils-0.12.0[${PYTHON_USEDEP}]
	<dev-python/uuid-utils-1.0[${PYTHON_USEDEP}]

	>=dev-python/langchain-protocol-0.0.14[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		<dev-python/jupyter-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		<dev-python/setuptools-83.0.0[${PYTHON_USEDEP}]

		>=dev-python/grandalf-0.8.0[${PYTHON_USEDEP}]
		<dev-python/grandalf-1.0.0[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-util/ruff-0.15.0
		<dev-util/ruff-0.16.0
	)
	test? (
		>=dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
		<dev-python/pytest-10.0.0[${PYTHON_USEDEP}]

		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		<dev-python/freezegun-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/syrupy-5.0.0[${PYTHON_USEDEP}]
		<dev-python/syrupy-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
		<dev-python/pytest-watcher-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-asyncio-1.3.0[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/grandalf-0.8.0[${PYTHON_USEDEP}]
		<dev-python/grandalf-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/responses-0.25.0[${PYTHON_USEDEP}]
		<dev-python/responses-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		<dev-python/pytest-socket-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/blockbuster-1.5.18[${PYTHON_USEDEP}]
		<dev-python/blockbuster-1.6.0[${PYTHON_USEDEP}]

		dev-python/langchain-tests[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-codspeed[${PYTHON_USEDEP}]

		virtual/numpy[${PYTHON_USEDEP}]
	)
	typing? (
		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		<dev-python/mypy-1.20.0[${PYTHON_USEDEP}]

		>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
		<dev-python/types-pyyaml-7.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
		<dev-python/types-requests-3.0.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-text-splitters[${PYTHON_USEDEP}]
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
