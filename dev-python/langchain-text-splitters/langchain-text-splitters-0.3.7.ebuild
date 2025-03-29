# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..12} )

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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev lint test test-integration typing"
RDEPEND+="
	>=dev-python/langchain-core-0.3.45[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-util/ruff-0.9.2
		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/freezegun-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-socket-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-watcher-0.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		dev-python/langchain-core[${PYTHON_USEDEP}]
	)
	test-integration? (
		$(python_gen_cond_dep '
			>=dev-python/spacy-3.0.0[${PYTHON_USEDEP}]
		' python3_{10,11,12})
		>=dev-python/nltk-3.9.1[${PYTHON_USEDEP}]
		>=dev-python/transformers-4.47.0[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			>=dev-python/sentence-transformers-2.6.0[${PYTHON_SINGLE_USEDEP}]
		' python3_{10,11,12})
	)
	typing? (
		>=dev-python/lxml-stubs-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.10[${PYTHON_USEDEP}]
		>=dev-python/tiktoken-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.31.0.20240218[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
