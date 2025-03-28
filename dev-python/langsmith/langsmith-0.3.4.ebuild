# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# langsmith-pyo3
# pytest-watcher
# types-pyyaml
# types-tqdm

DISTUTILS_USE_PEP517="poetry"
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev langsmith_pyo3 lint test vcr"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pydantic-1[${PYTHON_USEDEP}]
		<dev-python/pydantic-3[${PYTHON_USEDEP}]
	' python3_{10..11})
	$(python_gen_cond_dep '
		>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]
	' python3_{12..13})
	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.9.14[${PYTHON_USEDEP}]
	>=dev-python/requests-2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
	dev-python/zstandard
	langsmith_pyo3? (
		>=dev-python/langsmith-pyo3-0.1.0_rc2[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/openai-1.10[${PYTHON_USEDEP}]
	)
	vcr? (
		>=dev-python/vcrpy-6.0.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/poetry-core[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/black-23.3[${PYTHON_USEDEP}]
		>=dev-python/dataclasses-json-0.6.4[${PYTHON_USEDEP}]
		>=dev-python/fastapi-0.115.4[${PYTHON_USEDEP}]
		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/multipart-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-stubs-2.0.1.230501[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
		>=dev-python/py-spy-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/pyperf-2.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-subtests-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/types-psutil-5.9.5.16[${PYTHON_USEDEP}]
		>=dev-python/types-pyyaml-6.0.12.10[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.31.0.1[${PYTHON_USEDEP}]
		>=dev-python/types-tqdm-4.66.0.20240106[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.29.0[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-6.0.1[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.6.9
	)
	test? (
		>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/vcrpy-6.0.1[${PYTHON_USEDEP}]
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
