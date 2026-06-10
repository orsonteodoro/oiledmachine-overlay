# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/langchain-ai/langgraph.git"
	FALLBACK_COMMIT="d1e2ff0561a8b0b09212d0795c9d7b390a5de23a" # May 22, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/libs/checkpoint"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/libs/checkpoint"
	SRC_URI="
https://github.com/langchain-ai/langgraph/archive/refs/tags/checkpoint==${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Library with base interfaces for LangGraph checkpoint savers"
HOMEPAGE="
	https://github.com/langchain-ai/langgraph/blob/main/libs/checkpoint/pyproject.toml
	https://github.com/langchain-ai/langgraph
	https://pypi.org/project/langgraph-checkpoint
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev lint test
ebuild_revision_1
"
REQUIRED_USE="
	dev? (
		lint
		test
	)
"
RDEPEND+="
	>=dev-python/langchain-core-0.2.38[${PYTHON_USEDEP}]
	>=dev-python/ormsgpack-1.12.0[${PYTHON_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/pycryptodome-3.23.0[${PYTHON_USEDEP}]
	)
	lint? (
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/codespell[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-watcher[${PYTHON_USEDEP}]
		dev-python/dataclasses-json[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		>=dev-python/pandas-stubs-2.2.2.240807[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
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
