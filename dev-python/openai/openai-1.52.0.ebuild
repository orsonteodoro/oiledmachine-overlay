# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# types-pyaudio
# types-tqdm

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-python-${PV}"
SRC_URI="
https://github.com/openai/openai-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The official Python library for the OpenAI API"
HOMEPAGE="
	https://github.com/openai/openai-python
	https://pypi.org/project/openai/
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" datalib rye"
RDEPEND+="
	>=dev-python/anyio-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.25.2[${PYTHON_USEDEP}]
	>=dev-python/jiter-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.66.1[${PYTHON_USEDEP}]
	datalib? (
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/pandas-2.2.2[${PYTHON_USEDEP}]
		>=dev-python/pandas-stubs-2.2.1.240316[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	rye? (
		>=dev-python/azure-identity-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/dirty-equals-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.11.2[${PYTHON_USEDEP}]
		>=dev-python/nox-2023.4.22[${PYTHON_USEDEP}]
		>=dev-python/pyright-1.1.380[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/respx-0.20.2[${PYTHON_USEDEP}]
		>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
		>=dev-python/time-machine-2.9.0[${PYTHON_USEDEP}]
		>=dev-python/trio-0.22.2[${PYTHON_USEDEP}]
		>=dev-python/types-pyaudio-0.2.16.20240106[${PYTHON_USEDEP}]
		>=dev-python/types-tqdm-4.66.0.2[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.6.5
	)
"
DOCS=()
