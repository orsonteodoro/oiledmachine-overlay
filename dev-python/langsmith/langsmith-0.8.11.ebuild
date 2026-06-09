# Copyright 2025-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Client library to connect to the LangSmith LLM Tracing and Evaluation Platform"
HOMEPAGE="
	https://github.com/langchain-ai/langsmith-sdk
	https://pypi.org/project/langsmith
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
claude-agent-sdk dev google-adk langsmith_pyo3 lint openai-agents
otel pytest strands-agents test vcr
"
RDEPEND+="
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]

	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.9.14[${PYTHON_USEDEP}]

	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]

	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.2[${PYTHON_USEDEP}]

	>=dev-python/uuid-utils-0.12.0[${PYTHON_USEDEP}]
	<dev-python/uuid-utils-1.0[${PYTHON_USEDEP}]

	>=dev-python/xxhash-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/websockets-15.0[${PYTHON_USEDEP}]

	claude-agent-sdk? (
		$(python_gen_cond_dep '
			>=dev-python/claude-agent-sdk-0.1.0[${PYTHON_USEDEP}]
		' python3_{10..14})
	)
	google-adk? (
		>=dev-python/google-adk-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
	)
	langsmith_pyo3? (
		>=dev-python/langsmith-pyo3-0.1.0_rc2[${PYTHON_USEDEP}]
	)
	openai-agents? (
		>=dev-python/openai-agents-0.0.3[${PYTHON_USEDEP}]
	)
	otel? (
		>=dev-python/opentelemetry-sdk-1.30.0[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-api-1.30.0[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-exporter-otlp-proto-http-1.30.0[${PYTHON_USEDEP}]
	)
	strands-agents? (
		>=dev-python/strands-agents-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/strands-agents-tools-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-sdk-1.30.0[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-api-1.30.0[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-exporter-otlp-proto-http-1.30.0[${PYTHON_USEDEP}]
	)
	vcr? (
		>=dev-python/vcrpy-7.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/ruff-0.6.9[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.31.0.1[${PYTHON_USEDEP}]
		>=dev-python/pandas-stubs-2.0.1.230501[${PYTHON_USEDEP}]
		>=dev-python/types-pyyaml-6.0.12.10[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.0[${PYTHON_USEDEP}]
		>=dev-python/types-psutil-5.9.5.16[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-subtests-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/dataclasses-json-0.6.4[${PYTHON_USEDEP}]
		>=dev-python/types-tqdm-4.66.0.20240106[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/fastapi-0.115.4[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.29.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pyperf-2.7.0[${PYTHON_USEDEP}]
		>=dev-python/py-spy-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/multipart-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		<dev-python/httpx-0.29.0[${PYTHON_USEDEP}]

		>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-retry-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-dotenv-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-sdk-1.34.1[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-exporter-otlp-proto-http-1.34.1[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-api-1.34.1[${PYTHON_USEDEP}]
		>=dev-python/bump2version-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/openai-agents-0.2.4[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/claude-agent-sdk-0.1.0[${PYTHON_USEDEP}]
		' python3_{10..14})
		>=dev-python/strands-agents-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/strands-agents-tools-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/langchain-core-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/langchain-openai-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/langchain-anthropic-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/debugpy-1.8.17[${PYTHON_USEDEP}]
		>=dev-python/google-genai-1.2.0[${PYTHON_USEDEP}]
		>=virtual/pillow-12.0.0[${PYTHON_USEDEP}]
		~dev-python/ty-0.0.35[${PYTHON_USEDEP}]
		>=dev-python/pytest-httpx-0.30.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/google-adk-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.3.1[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/openai-2.6.0[${PYTHON_USEDEP}]
	)
	pytest? (
		>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-7.0.0[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/anthropic-0.45.0[${PYTHON_USEDEP}]
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
