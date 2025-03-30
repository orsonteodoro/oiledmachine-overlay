# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (required):
# httpx-sse

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

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Community contributed LangChain integrations"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/tree/master/libs/community
	https://pypi.org/project/langchain-community
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" codespell dev lint test test-integration typing"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.2[${PYTHON_USEDEP}]
		<dev-python/numpy-3[${PYTHON_USEDEP}]
	' python3_{10..11})
	$(python_gen_cond_dep '
		(
			!=dev-python/tenacity-8.4.0[${PYTHON_USEDEP}]
			>=dev-python/tenacity-8.1.0[${PYTHON_USEDEP}]
		)
		>=dev-python/aiohttp-3.8.3[${PYTHON_USEDEP}]
		>=dev-python/dataclasses-json-0.5.7[${PYTHON_USEDEP}]
		>=dev-python/httpx-sse-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/langsmith-0.1.125[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
		>=dev-python/requests-2[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		codespell? (
			>=dev-python/codespell-2.2.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/langchain-0.3.21[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/langchain-core-0.3.45[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		)
		lint? (
			>=dev-util/ruff-0.9
			dev-python/cffi[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/blockbuster-1.5.18[${PYTHON_USEDEP}]
			>=dev-python/duckdb-engine-0.13.6[${PYTHON_USEDEP}]
			>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
			>=dev-python/lark-1.1.5[${PYTHON_USEDEP}]
			>=dev-python/pandas-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-0.20.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-dotenv-0.5.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-socket-0.6.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-watcher-0.2.6[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
			>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
			>=dev-python/responses-0.22.0[${PYTHON_USEDEP}]
			>=dev-python/syrupy-4.0.2[${PYTHON_USEDEP}]
			>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
			dev-python/cffi[${PYTHON_USEDEP}]
		)
		test-integration? (
			>=dev-python/pytest-vcr-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/vcrpy-6[${PYTHON_USEDEP}]
		)
		typing? (
			>=dev-python/mypy-1.12[${PYTHON_USEDEP}]
			>=dev-python/types-chardet-5.0.4.6[${PYTHON_USEDEP}]
			>=dev-python/types-pytz-2023.3.0.0[${PYTHON_USEDEP}]
			>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
			>=dev-python/types-redis-4.3.21.6[${PYTHON_USEDEP}]
			>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
			>=dev-python/types-toml-0.10.8.1[${PYTHON_USEDEP}]
			>=dev-python/mypy-protobuf-3.0.0[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		dev-python/langchain[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-tests[${PYTHON_SINGLE_USEDEP}]
	)
	typing? (
		dev-python/langchain[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
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
