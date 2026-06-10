# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/langchain-ai/langgraph.git"
	FALLBACK_COMMIT="3614e88c58af63f597764218646e85c49952b2da" # May 11, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/libs/prebuilt"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/libs/prebuilt"
	SRC_URI="
https://github.com/langchain-ai/langgraph/archive/refs/tags/prebuilt==${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Library with high-level APIs for creating and executing LangGraph agents and tools"
HOMEPAGE="
	https://github.com/langchain-ai/langgraph/tree/main/libs/prebuilt
	https://pypi.org/project/langgraph-prebuilt
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev lint test"
REQUIRED_USE="
	dev? (
		lint
		test
	)
"
RDEPEND+="
	>=dev-python/langgraph-checkpoint-2.1.0[${PYTHON_USEDEP}]
	<dev-python/langgraph-checkpoint-5.0.0[${PYTHON_USEDEP}]

	>=dev-python/langchain-core-1.3.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	lint? (
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/codespell[${PYTHON_USEDEP}]
		dev-python/ty[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-watcher[${PYTHON_USEDEP}]
		dev-python/langchain-core[${PYTHON_USEDEP}]
		dev-python/langgraph[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint-sqlite[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint-postgres[${PYTHON_USEDEP}]
		dev-python/syrupy[${PYTHON_USEDEP}]
		dev-python/psycopg-binary[${PYTHON_USEDEP}]
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
