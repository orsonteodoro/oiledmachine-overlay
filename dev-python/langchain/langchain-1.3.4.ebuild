# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Building applications with LLMs through composability"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/tree/master/libs/langchain
	https://pypi.org/project/langchain
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
anthropic aws azure-ai baseten community deepseek fireworks google-genai
google-vertexai groq huggingface lint mistralai ollama openai perplexity test
test-integration together typing xai
"
RDEPEND+="
	>=dev-python/langchain-core-1.4.0[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/langgraph-1.2.4[${PYTHON_USEDEP}]
	<dev-python/langgraph-1.3.0[${PYTHON_USEDEP}]

	>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]

	anthropic? (
		dev-python/langchain-anthropic[${PYTHON_USEDEP}]
	)
	aws? (
		dev-python/langchain-aws[${PYTHON_USEDEP}]
	)
	azure-ai? (
		dev-python/langchain-azure-ai[${PYTHON_USEDEP}]
	)
	baseten? (
		>=dev-python/langchain-baseten-0.2.0[${PYTHON_USEDEP}]
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
	ollama? (
		dev-python/langchain-ollama[${PYTHON_USEDEP}]
	)
	openai? (
		dev-python/langchain-openai[${PYTHON_USEDEP}]
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
	lint? (
		>=dev-util/ruff-0.15.0
		<dev-util/ruff-0.16.0
	)
	test? (
		>=dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
		<dev-python/pytest-10.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		<dev-python/pytest-cov-8.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-watcher-0.2.6[${PYTHON_USEDEP}]
		<dev-python/pytest-watcher-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-asyncio-1.3.0[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-socket-0.6.0[${PYTHON_USEDEP}]
		<dev-python/pytest-socket-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4.0.0[${PYTHON_USEDEP}]

		dev-python/pytest-mock[${PYTHON_USEDEP}]

		>=dev-python/pytest-benchmark-5.1.0[${PYTHON_USEDEP}]
		<dev-python/pytest-benchmark-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/syrupy-5.0.0[${PYTHON_USEDEP}]
		<dev-python/syrupy-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		<dev-python/toml-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/blockbuster-1.5.26[${PYTHON_USEDEP}]
		<dev-python/blockbuster-1.6.0[${PYTHON_USEDEP}]

		>=dev-python/langchain-tests-1.1.9[${PYTHON_USEDEP}]
		<dev-python/langchain-tests-2.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-openai[${PYTHON_USEDEP}]
	)
	test-integration? (
		>=dev-python/vcrpy-8.0.0[${PYTHON_USEDEP}]
		<dev-python/vcrpy-9.0.0[${PYTHON_USEDEP}]

		>=dev-python/wrapt-1.15.0[${PYTHON_USEDEP}]
		<dev-python/wrapt-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/python-dotenv-1.0.0[${PYTHON_USEDEP}]
		<dev-python/python-dotenv-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/langchainhub-0.1.16[${PYTHON_USEDEP}]
		<dev-python/langchainhub-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/langchain-core-1.4.0[${PYTHON_USEDEP}]
		<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/langchain-text-splitters-1.0.0[${PYTHON_USEDEP}]
		<dev-python/langchain-text-splitters-2.0.0[${PYTHON_USEDEP}]
	)
	typing? (
		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		<dev-python/mypy-1.20.0[${PYTHON_USEDEP}]

		>=dev-python/types-toml-0.10.8.20240310[${PYTHON_USEDEP}]
		<dev-python/types-toml-1.0.0.0[${PYTHON_USEDEP}]
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
