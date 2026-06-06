# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"

DESCRIPTION="Building applications with LLMs through composability"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/blob/master/libs/langchain/pyproject.toml
	https://github.com/langchain-ai/langchain/tree/master/libs/langchain/langchain_classic
	https://github.com/langchain-ai/langchain
	https://pypi.org/project/langchain-classic
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
anthropic aws azure-ai cohere community deepseek dev fireworks lint google-genai
google-vertexai groq huggingface mistralai ollama openai perplexity test
test-integration together typing xai
"
REQUIRED_USE="
	test? (
		|| (
			python_targets_python3_12
			python_targets_python3_13
		)
	)
"
RDEPEND+="
	>=dev-python/langchain-core-1.3.3[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/langchain-text-splitters-1.1.2[${PYTHON_USEDEP}]
	<dev-python/langchain-text-splitters-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/langsmith-0.1.17[${PYTHON_USEDEP}]
	<dev-python/langsmith-1.0.0[${PYTHON_USEDEP}]

	>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/sqlalchemy-1.4.0[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/pyyaml-5.3.0[${PYTHON_USEDEP}]
	<dev-python/pyyaml-7.0.0[${PYTHON_USEDEP}]

	$(python_gen_cond_dep '
		>=dev-python/async-timeout-4.0.0[${PYTHON_USEDEP}]
		<dev-python/async-timeout-5.0.0[${PYTHON_USEDEP}]
	' python3_10)

	anthropic? (
		dev-python/langchain-anthropic[${PYTHON_USEDEP}]
	)
	aws? (
		dev-python/langchain-aws[${PYTHON_USEDEP}]
	)
	azure-ai? (
		dev-python/langchain-azure-ai[${PYTHON_USEDEP}]
	)
	cohere? (
		dev-python/langchain-cohere[${PYTHON_USEDEP}]
	)
	community? (
		dev-python/langchain-community[${PYTHON_USEDEP}]
	)
	deepseek? (
		dev-python/langchain-deepseek[${PYTHON_USEDEP}]
	)
	fireworks? (
		dev-python/langchain-fireworks[${PYTHON_USEDEP}]
	)
	google-genai? (
		dev-python/langchain-google-genai[${PYTHON_USEDEP}]
	)
	google-vertexai? (
		dev-python/langchain-google-vertexai[${PYTHON_USEDEP}]
	)
	groq? (
		dev-python/langchain-groq[${PYTHON_USEDEP}]
	)
	huggingface? (
		dev-python/langchain-huggingface[${PYTHON_USEDEP}]
	)
	mistralai? (
		dev-python/langchain-mistralai[${PYTHON_USEDEP}]
	)
	openai? (
		dev-python/langchain-openai[${PYTHON_USEDEP}]
	)
	ollama? (
		dev-python/langchain-ollama[${PYTHON_USEDEP}]
	)
	perplexity? (
		dev-python/langchain-perplexity[${PYTHON_USEDEP}]
	)
	together? (
		dev-python/langchain-together[${PYTHON_USEDEP}]
	)
	xai? (
		dev-python/langchain-xai[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		<dev-python/jupyter-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/playwright-1.28.0[${PYTHON_USEDEP}]
		<dev-python/playwright-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		<dev-python/setuptools-83.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/ruff-0.15.0[${PYTHON_USEDEP}]
		<dev-python/ruff-0.16.0[${PYTHON_USEDEP}]

		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' python3_{10..13})
	)
	test? (
		>=dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
		<dev-python/pytest-10.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		<dev-python/pytest-cov-8.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-dotenv-0.5.2[${PYTHON_USEDEP}]
		<dev-python/pytest-dotenv-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-watcher-0.2.6[${PYTHON_USEDEP}]
		<dev-python/pytest-watcher-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-asyncio-1.3.0[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-socket-0.6.0[${PYTHON_USEDEP}]
		<dev-python/pytest-socket-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4.0.0[${PYTHON_USEDEP}]

		$(python_gen_cond_dep '
			dev-python/cffi
		' python3_{10..13})

		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		<dev-python/freezegun-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/responses-0.22.0[${PYTHON_USEDEP}]
		<dev-python/responses-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/lark-1.1.5[${PYTHON_USEDEP}]
		<dev-python/lark-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pandas-2.0.0[${PYTHON_USEDEP}]
		<dev-python/pandas-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/syrupy-5.0.0[${PYTHON_USEDEP}]
		<dev-python/syrupy-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
		<dev-python/requests-mock-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		<dev-python/toml-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/packaging-24.2.0[${PYTHON_USEDEP}]
		<dev-python/packaging-27.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-tests[${PYTHON_USEDEP}]
		dev-python/langchain-core[${PYTHON_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_USEDEP}]
		dev-python/langchain-openai[${PYTHON_USEDEP}]

		virtual/numpy[${PYTHON_USEDEP}]
	)
	test-integration? (
		>=dev-python/vcrpy-8.0.0[${PYTHON_USEDEP}]
		<dev-python/vcrpy-9.0.0[${PYTHON_USEDEP}]

		>=dev-python/wrapt-1.15.0[${PYTHON_USEDEP}]
		<dev-python/wrapt-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/python-dotenv-1.0.0[${PYTHON_USEDEP}]
		<dev-python/python-dotenv-2.0.0[${PYTHON_USEDEP}]

		$(python_gen_cond_dep '
			>=dev-python/cassio-0.1.0[${PYTHON_USEDEP}]
			<dev-python/cassio-1.0.0[${PYTHON_USEDEP}]
		' python3_{10..13})

		dev-python/langchain-core[${PYTHON_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_USEDEP}]
	)
	typing? (
		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		<dev-python/mypy-1.20.0[${PYTHON_USEDEP}]

		>=dev-python/mypy-protobuf-3.0.0[${PYTHON_USEDEP}]
		<dev-python/mypy-protobuf-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
		<dev-python/types-pyyaml-7.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
		<dev-python/types-requests-3.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-toml-0.10.8.1[${PYTHON_USEDEP}]
		<dev-python/types-toml-1.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-redis-4.3.21.6[${PYTHON_USEDEP}]
		<dev-python/types-redis-5.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-pytz-2023.3.0.0[${PYTHON_USEDEP}]
		<dev-python/types-pytz-2027.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-chardet-5.0.4.6[${PYTHON_USEDEP}]
		<dev-python/types-chardet-6.0.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_USEDEP}]

		>=dev-python/fastapi-0.116.1[${PYTHON_USEDEP}]
		<dev-python/fastapi-1.0.0[${PYTHON_USEDEP}]

		virtual/numpy[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
