# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# types-pyaudio
# types-tqdm

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} )

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
IUSE+="
aiohttp datalib dev realtime voice_helpers
"
RDEPEND+="
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	<dev-python/anyio-5[${PYTHON_USEDEP}]

	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	<dev-python/distro-2.0.0[${PYTHON_USEDEP}]

	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]

	>=dev-python/jiter-0.10.0[${PYTHON_USEDEP}]
	<dev-python/jiter-1[${PYTHON_USEDEP}]

	>=dev-python/pydantic-1.9.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]

	dev-python/sniffio[${PYTHON_USEDEP}]

	>=dev-python/typing-extensions-4.14[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]

	>=dev-python/tqdm-4[${PYTHON_USEDEP}]

	aiohttp? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		>=dev-python/httpx_aiohttp-0.1.9[${PYTHON_USEDEP}]
	)
	datalib? (
		>=dev-python/numpy-1[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/pandas-stubs-1.1.0.11[${PYTHON_USEDEP}]
	)
	realtime? (
		>=dev-python/websockets-13[${PYTHON_USEDEP}]
		<dev-python/websockets-16[${PYTHON_USEDEP}]
	)
	voice_helpers? (
		>=dev-python/sounddevice-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.0.2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/hatchling-1.26.3[${PYTHON_USEDEP}]
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/azure-identity-1.14.1[${PYTHON_USEDEP}]
		>=dev-python/dirty-equals-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/griffe-1[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.7.0[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.28.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.17[${PYTHON_USEDEP}]
		~dev-python/nest_asyncio-1.6.0[${PYTHON_USEDEP}]
		dev-python/nox[${PYTHON_USEDEP}]
		>=dev-python/pyright-1.1.399[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
		>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
		dev-python/time-machine[${PYTHON_USEDEP}]
		>=dev-python/trio-0.22.2[${PYTHON_USEDEP}]
		>dev-python/types-pyaudio-0[${PYTHON_USEDEP}]
		>dev-python/types-tqdm-4[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"
DOCS=()
