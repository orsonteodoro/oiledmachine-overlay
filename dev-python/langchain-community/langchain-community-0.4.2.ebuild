# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# duckdb-engine
# langsmith
# mypy-protobuf
# pytest-dotenv
# pytest-watcher
# types-pytz
# types-pyyaml
# types-redis
# types-toml

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{12..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Community contributed LangChain integrations"
HOMEPAGE="
	https://github.com/langchain-ai/langchain-community/tree/main/libs/community
	https://pypi.org/project/langchain-community
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev lint test test-integration typing
"
# For Numpy:
REQUIRED_USE="
	|| (
		python_targets_python3_12
		python_targets_python3_13
	)
"
RDEPEND+="
	>=dev-python/langchain-core-1.4.0[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/langchain-classic-1.0.7[${PYTHON_USEDEP}]
	<dev-python/langchain-classic-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/sqlalchemy-1.4.0[${PYTHON_USEDEP}]
	<dev-python/sqalchemy-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/pyyaml-5.3.0[${PYTHON_USEDEP}]
	<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

	>=dev-python/aiohttp-3.8.3[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4.0.0[${PYTHON_USEDEP}]

	!=dev-python/tenacity-8.4.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.1.0[${PYTHON_USEDEP}]
	<dev-python/tenacity-10.0.0[${PYTHON_USEDEP}]

	>=dev-python/pydantic-settings-2.10.1[${PYTHON_USEDEP}]
	<dev-python/pydantic-settings-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/langsmith-0.1.125[${PYTHON_USEDEP}]
	<dev-python/langsmith-1.0.0[${PYTHON_USEDEP}]

	>=dev-python/httpx-sse-0.4.0[${PYTHON_USEDEP}]
	<dev-python/httpx-sse-1.0.0[${PYTHON_USEDEP}]

	virtual/numpy[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		<dev-python/jupyter-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		<dev-python/setuptools-79.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/ruff-0.13.1[${PYTHON_USEDEP}]
		<dev-python/ruff-1.0.0[${PYTHON_USEDEP}]

		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' python3_{10..13})
	)
	test? (
		>=dev-python/pytest-8.4.1[${PYTHON_USEDEP}]
		<dev-python/pytest-9.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-cov-6.2.1[${PYTHON_USEDEP}]
		<dev-python/pytest-cov-7.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-dotenv-0.5.2[${PYTHON_USEDEP}]
		<dev-python/pytest-dotenv-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/duckdb-engine-0.13.6[${PYTHON_USEDEP}]
		<dev-python/duckdb-engine-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-watcher-0.4.3[${PYTHON_USEDEP}]
		<dev-python/pytest-watcher-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		<dev-python/freezegun-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/responses-0.22.0[${PYTHON_USEDEP}]
		<dev-python/responses-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-asyncio-0.20.3[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/lark-1.1.5[${PYTHON_USEDEP}]
		<dev-python/lark-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pandas-2.0.0[${PYTHON_USEDEP}]
		<dev-python/pandas-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-socket-0.6.0[${PYTHON_USEDEP}]
		<dev-python/pytest-socket-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/syrupy-4.0.2[${PYTHON_USEDEP}]
		<dev-python/syrupy-5.0.0[${PYTHON_USEDEP}]

		>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
		<dev-python/requests-mock-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/blockbuster-1.5.18[${PYTHON_USEDEP}]
		<dev-python/blockbuster-1.6.0[${PYTHON_USEDEP}]

		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' python3_{10..13})

		>=dev-python/langchain-tests-1.0.0[${PYTHON_USEDEP}]
		<dev-python/langchain-tests-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		<dev-python/toml-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/mypy-extensions-1.0.0[${PYTHON_USEDEP}]
	)
	test-integration? (
		>=dev-python/vcrpy-6.0.0[${PYTHON_USEDEP}]
	)
	typing? (
		>=dev-python/mypy-1.17.1[${PYTHON_USEDEP}]
		<dev-python/mypy-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
		<dev-python/types-pyyaml-7.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
		<dev-python/types-requests-3.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-toml-0.10.8.1[${PYTHON_USEDEP}]
		<dev-python/types-toml-1.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-pytz-2023.3.0.0[${PYTHON_USEDEP}]
		<dev-python/types-pytz-2024.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-chardet-5.0.4.6[${PYTHON_USEDEP}]
		<dev-python/types-chardet-6.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-redis-4.3.21.6[${PYTHON_USEDEP}]
		<dev-python/types-redis-5.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/mypy-protobuf-3.0.0[${PYTHON_USEDEP}]
		<dev-python/mypy-protobuf-4.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]

		>=dev-python/langchain-text-splitters-1.0.0[${PYTHON_USEDEP}]
		<dev-python/langchain-text-splitters-2.0.0[${PYTHON_USEDEP}]

		dev-python/langchain[${PYTHON_USEDEP}]
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
