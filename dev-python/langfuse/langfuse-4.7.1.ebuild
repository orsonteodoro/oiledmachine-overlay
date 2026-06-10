# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="uv-build"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="A client library for accessing langfuse"
HOMEPAGE="
	https://pypi.org/project/langfuse
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev docs"
REQUIRED_USE="
"
RDEPEND+="
	>=dev-python/httpx-0.15.4[${PYTHON_USEDEP}]
	<dev-python/httpx-1.0[${PYTHON_USEDEP}]

	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]

	>=dev-python/backoff-1.10.0[${PYTHON_USEDEP}]

	>=dev-python/wrapt-1.14[${PYTHON_USEDEP}]
	<dev-python/wrapt-2[${PYTHON_USEDEP}]

	>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
	<dev-python/packaging-27.0[${PYTHON_USEDEP}]

	>=dev-python/opentelemetry-api-1.33.1[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-api-2[${PYTHON_USEDEP}]

	>=dev-python/opentelemetry-sdk-1.33.1[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-sdk-2[${PYTHON_USEDEP}]

	>=dev-python/opentelemetry-exporter-otlp-proto-http-1.33.1[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-exporter-otlp-proto-http-1.33.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/uv-build-0.11.2[${PYTHON_USEDEP}]
	<dev-python/uv-build-0.12.0[${PYTHON_USEDEP}]

	dev? (
		>=dev-python/pytest-7.4[${PYTHON_USEDEP}]
		<dev-python/pytest-9.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		<dev-python/pytest-timeout-3[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.3.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4[${PYTHON_USEDEP}]

		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-3.2.2[${PYTHON_SINGLE_USEDEP}]
			<dev-vcs/pre-commit-4[${PYTHON_SINGLE_USEDEP}]
		')

		>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-1.2.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-httpserver-1.0.8[${PYTHON_USEDEP}]
		<dev-python/pytest-httpserver-2[${PYTHON_USEDEP}]

		>=dev-python/ruff-0.15.2[${PYTHON_USEDEP}]
		<dev-python/ruff-0.16[${PYTHON_USEDEP}]

		>=dev-python/mypy-1.0.0[${PYTHON_USEDEP}]
		<dev-python/mypy-2[${PYTHON_USEDEP}]

		>=dev-python/openai-0.27.8[${PYTHON_USEDEP}]

		>=dev-python/langchain-openai-0.0.5[${PYTHON_USEDEP}]
		<dev-python/langchain-openai-0.4[${PYTHON_USEDEP}]

		>=dev-python/langchain-1[${PYTHON_USEDEP}]
		<dev-python/langchain-2[${PYTHON_USEDEP}]

		>=dev-python/langgraph-1[${PYTHON_USEDEP}]
		<dev-python/langgraph-2[${PYTHON_USEDEP}]

		>=dev-python/autoevals-0.0.130[${PYTHON_USEDEP}]
		<dev-python/autoevals-0.1[${PYTHON_USEDEP}]

		>=dev-python/opentelemetry-instrumentation-threading-0.59_beta0[${PYTHON_USEDEP}]
		<dev-python/opentelemetry-instrumentation-threading-1[${PYTHON_USEDEP}]

		>=dev-python/tenacity-9.1.4[${PYTHON_USEDEP}]
	)
	docs? (
		>=dev-python/pdoc-15.0.4[${PYTHON_USEDEP}]
		<dev-python/pdoc-16[${PYTHON_USEDEP}]
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
