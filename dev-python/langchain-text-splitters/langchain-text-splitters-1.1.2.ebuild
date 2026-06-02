# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="LangChain text splitting utilities"
HOMEPAGE="
	https://github.com/langchain-ai/langchain/blob/master/libs/text-splitters
	https://pypi.org/project/langchain-text-splitters
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev lint test test-integration typing
"
RDEPEND+="
	>=dev-python/langchain-core-1.2.31[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		<dev-python/jupyter-2.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-util/ruff-0.15.0[${PYTHON_USEDEP}]
		<dev-util/ruff-0.16.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
		<dev-python/pytest-10.0.0[${PYTHON_USEDEP}]

		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		<dev-python/freezegun-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
		<dev-python/pytest-watcher-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-asyncio-1.3.0[${PYTHON_USEDEP}]
		<dev-python/pytest-asyncio-2.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		<dev-python/pytest-socket-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-4.0.0[${PYTHON_USEDEP}]

		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	test-integration? (
		>=dev-python/spacy-3.8.13[${PYTHON_USEDEP}]
		<dev-python/spacy-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/nltk-3.9.1[${PYTHON_USEDEP}]
		<dev-python/nltk-4.0.0[${PYTHON_USEDEP}]

		>=dev-python/transformers-4.51.3[${PYTHON_USEDEP}]
		<dev-python/transformers-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/sentence-transformers-5.3.0[${PYTHON_USEDEP}]
		<dev-python/sentence-transformers-6.0.0[${PYTHON_USEDEP}]

		>=dev-python/tiktoken-0.8.0[${PYTHON_USEDEP}]
		<dev-python/tiktoken-1.0.0[${PYTHON_USEDEP}]

		dev-python/en-core-web-sm[${PYTHON_USEDEP}]
	)
	typing? (
		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		<dev-python/mypy-1.20.0[${PYTHON_USEDEP}]

		>=dev-python/lxml-stubs-0.5.1[${PYTHON_USEDEP}]
		<dev-python/lxml-stubs-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/types-requests-2.31.0.20240218[${PYTHON_USEDEP}]
		<dev-python/types-requests-3.0.0.0[${PYTHON_USEDEP}]

		>=dev-python/tiktoken-0.8.0[${PYTHON_USEDEP}]
		<dev-python/tiktoken-1.0.0[${PYTHON_USEDEP}]

		>=dev-python/beautifulsoup4-4.13.5[${PYTHON_USEDEP}]
		<dev-python/beautifulsoup4-5.0.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
