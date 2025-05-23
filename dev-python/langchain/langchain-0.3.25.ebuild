# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# autodoc_pydantic
# linkchecker
# nbdoc
# sphinx-typlog-theme

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{11..13} ) # Python 3.12 used for benchmarking

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="⚡ Building applications with LLMs through composability ⚡"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/tree/master/libs/langchain
	https://pypi.org/project/langchain
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
anthropic aws azure-ai codespell cohere community deepseek dev doc fireworks
huggingface google-genai google-vertexai groq lint mistralai openai ollama
perplexity test test-integration together typing xai
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/langsmith-0.1.17[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
		>=dev-python/requests-2[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		codespell? (
			>=dev-python/codespell-2.2.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/langchain-core-0.3.58[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/langchain-text-splitters-0.3.8[${PYTHON_SINGLE_USEDEP}]
	anthropic? (
		dev-python/langchain-anthropic[${PYTHON_SINGLE_USEDEP}]
	)
	aws? (
		dev-python/langchain-aws[${PYTHON_SINGLE_USEDEP}]
	)
	azure-ai? (
		dev-python/langchain-azure-ai[${PYTHON_SINGLE_USEDEP}]
	)
	cohere? (
		dev-python/langchain-cohere[${PYTHON_SINGLE_USEDEP}]
	)
	community? (
		dev-python/langchain-community[${PYTHON_SINGLE_USEDEP}]
	)
	deepseek? (
		dev-python/langchain-deepseek[${PYTHON_SINGLE_USEDEP}]
	)
	fireworks? (
		dev-python/langchain-fireworks[${PYTHON_SINGLE_USEDEP}]
	)
	google-genai? (
		dev-python/langchain-google-genai[${PYTHON_SINGLE_USEDEP}]
	)
	google-vertexai? (
		dev-python/langchain-google-vertexai[${PYTHON_SINGLE_USEDEP}]
	)
	groq? (
		dev-python/langchain-groq[${PYTHON_SINGLE_USEDEP}]
	)
	huggingface? (
		dev-python/langchain-huggingface[${PYTHON_SINGLE_USEDEP}]
	)
	mistralai? (
		dev-python/langchain-mistralai[${PYTHON_SINGLE_USEDEP}]
	)
	ollama? (
		dev-python/langchain-ollama[${PYTHON_SINGLE_USEDEP}]
	)
	openai? (
		dev-python/langchain-openai[${PYTHON_SINGLE_USEDEP}]
	)
	perplexity? (
		dev-python/langchain-perplexity[${PYTHON_SINGLE_USEDEP}]
	)
	together? (
		dev-python/langchain-together[${PYTHON_SINGLE_USEDEP}]
	)
	xai? (
		dev-python/langchain-xai[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/playwright-1.28.0[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
		)
		lint? (
			>=dev-util/ruff-0.9.2
			dev-python/cffi[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/blockbuster-1.5.18[${PYTHON_USEDEP}]
			>=dev-python/duckdb-engine-0.9.2[${PYTHON_USEDEP}]
			>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
			>=dev-python/lark-1.1.5[${PYTHON_USEDEP}]
			>=dev-python/packaging-24.2[${PYTHON_USEDEP}]
			>=dev-python/pandas-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-8[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-0.23.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
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
			>=dev-python/cassio-0.1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-vcr-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/python-dotenv-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/wrapt-1.15.0[${PYTHON_USEDEP}]
		)
		typing? (
			>=dev-python/mypy-1.15[${PYTHON_USEDEP}]
			>=dev-python/mypy-protobuf-3.0.0[${PYTHON_USEDEP}]
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
			>=dev-python/types-chardet-5.0.4.6[${PYTHON_USEDEP}]
			>=dev-python/types-pytz-2023.3.0.0[${PYTHON_USEDEP}]
			>=dev-python/types-pyyaml-6.0.12.2[${PYTHON_USEDEP}]
			>=dev-python/types-redis-4.3.21.6[${PYTHON_USEDEP}]
			>=dev-python/types-requests-2.28.11.5[${PYTHON_USEDEP}]
			>=dev-python/types-toml-0.10.8.1[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		' python3_{11,12})
		$(python_gen_cond_dep '
			>=dev-python/numpy-2.1.0[${PYTHON_USEDEP}]
		' python3_13)
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-openai[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-tests[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
	)
	test-integration? (
		>=dev-python/langchainhub-0.1.16[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
	)
	typing? (
		$(python_gen_cond_dep '
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		' python3_{11,12})
		$(python_gen_cond_dep '
			>=dev-python/numpy-2.1.0[${PYTHON_USEDEP}]
		' python3_13)
		dev-python/langchain-core[${PYTHON_SINGLE_USEDEP}]
		dev-python/langchain-text-splitters[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
