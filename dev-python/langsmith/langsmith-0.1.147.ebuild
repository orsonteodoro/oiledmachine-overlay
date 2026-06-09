# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 caret pypi

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
dev langsmith-pyo3 lint test vcr
"
RDEPEND+="
	python_targets_python3_10? (
		>=dev-python/pydantic-1[${PYTHON_USEDEP}]
		<dev-python/pydantic-3[${PYTHON_USEDEP}]
	)
	python_targets_python3_11? (
		>=dev-python/pydantic-1[${PYTHON_USEDEP}]
		<dev-python/pydantic-3[${PYTHON_USEDEP}]
	)
	python_targets_python3_12? (
		$(caret dev-python/pydantic 2.7.4 '[${PYTHON_USEDEP}]')
	)
	python_targets_python3_13? (
		$(caret dev-python/pydantic 2.7.4 '[${PYTHON_USEDEP}]')
	)

	$(caret dev-python/requests 2 '[${PYTHON_USEDEP}]')
	$(caret dev-python/orjson 3.9.14 '[${PYTHON_USEDEP}]')

	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]

	$(caret dev-python/requests-toolbelt 1.0.0 '[${PYTHON_USEDEP}]')

	langsmith-pyo3? (
		$(caret dev-python/langsmith-pyo3 0.1.0_rc2 '[${PYTHON_USEDEP}]')
	)

	vcr? (
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(caret dev-python/pytest 7.3.1 '[${PYTHON_USEDEP}]')

		>=dev-python/black-23.3[${PYTHON_USEDEP}]
		<dev-python/black-25.0[${PYTHON_USEDEP}]

		$(caret dev-python/mypy 1.9.0 '[${PYTHON_USEDEP}]')
		$(caret dev-util/ruff 0.6.9)
		$(caret dev-python/types-requests 2.31.0.1 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pandas-stubs 2.0.1.230501 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-pyyaml 6.0.12.10 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-asyncio 0.21.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-psutil 5.9.5.16 '[${PYTHON_USEDEP}]')
		$(caret dev-python/psutil 5.9.5 '[${PYTHON_USEDEP}]')
		$(caret dev-python/freezegun 1.2.2 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-subtests 0.11.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-watcher 0.3.4 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-xdist 3.5.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-cov 4.1.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/dataclasses-json 0.6.4 '[${PYTHON_USEDEP}]')
		$(caret dev-python/types-tqdm 4.66.0.20240106 '[${PYTHON_USEDEP}]')
		$(caret dev-python/vcrpy 6.0.1 '[${PYTHON_USEDEP}]')
		$(caret dev-python/fastapi 0.115.4 '[${PYTHON_USEDEP}]')
		$(caret dev-python/uvicorn 0.29.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-rerunfailures 14.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pytest-socket 0.7.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/pyperf 2.7.0 '[${PYTHON_USEDEP}]')
		$(caret dev-python/py-spy 0.3.14 '[${PYTHON_USEDEP}]')
		$(caret dev-python/multipart 1.0.0 '[${PYTHON_USEDEP}]')
	)
	lint? (
		$(caret dev-python/openai 1.10 '[${PYTHON_USEDEP}]')
	)
	test? (
		$(caret dev-python/pytest-socket 0.7.0 '[${PYTHON_USEDEP}]')
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
