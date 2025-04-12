# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# bs4
# chromadb
# cohere
# dashscope
# google-cloud-aiplatform
# google-search-results
# langchain
# langchain-google-vertexai
# langchain-openai
# langchain-anthropic
# langchain-aws
# langchain-cohere
# langchain-community
# langchain-mistralai
# langchain-groq
# langchain-ollama
# langgraph
# llama-index
# llama-index-llms-anthropic
# pdoc

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="A client library for accessing langfuse"
HOMEPAGE="
	https://github.com/rec/tdir
	https://pypi.org/project/langfuse
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc langchain llama-index openai test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/anyio-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/backoff-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.15.4[${PYTHON_USEDEP}]
		>=dev-python/idna-3.7[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.10.7[${PYTHON_USEDEP}]
		>=dev-python/requests-2[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.14[${PYTHON_USEDEP}]
		llama-index? (
			>=dev-python/llama-index-0.10.12[${PYTHON_USEDEP}]
		)
		openai? (
			>=dev-python/openai-0.27.8[${PYTHON_USEDEP}]
		)
	')
	langchain? (
		>=dev-python/langchain-0.0.309[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/anthropic-0.17.0[${PYTHON_USEDEP}]
			>=dev-python/boto3-1.28.59[${PYTHON_USEDEP}]
			>=dev-python/bson-0.5.10[${PYTHON_USEDEP}]
			>=dev-python/bs4-0.0.1[${PYTHON_USEDEP}]
			>=dev-python/cohere-4.46[${PYTHON_USEDEP}]
			>=dev-python/dashscope-1.14.1[${PYTHON_USEDEP}]
			>=dev-python/langgraph-0.2.62[${PYTHON_USEDEP}]
			>=dev-python/lark-1.1.7[${PYTHON_USEDEP}]
			>=dev-python/llama-index-llms-anthropic-0.1.1[${PYTHON_USEDEP}]
			>=dev-python/google-cloud-aiplatform-1.38.1[${PYTHON_USEDEP}]
			>=dev-python/google-search-results-2.4.2[${PYTHON_USEDEP}]
			>=dev-python/pymongo-4.6.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-7.4[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-httpserver-1.0.8[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.3.1[${PYTHON_USEDEP}]
			>=dev-python/respx-0.20.2[${PYTHON_USEDEP}]
			>=dev-python/tiktoken-0.7.0[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.1.8
		)
		doc? (
			>=dev-python/pdoc-14.4.0[${PYTHON_USEDEP}]
		)
	')
	dev? (
		>=dev-python/chromadb-0.4.2[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/huggingface_hub-0.16.4[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-anthropic-0.1.4[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-aws-0.1.3[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-groq-0.1.3[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-cohere-0.3.3[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-community-0.2.14[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-google-vertexai-1.0.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-mistralai-0.0.1[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-ollama-0.2.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/langchain-openai-0.0.5[${PYTHON_SINGLE_USEDEP}]
		>=dev-vcs/pre-commit-3.2.2[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
