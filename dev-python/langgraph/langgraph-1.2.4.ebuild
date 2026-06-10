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
	FALLBACK_COMMIT="054a6f3d8b48d022a4881af3ba3dc0ddc3ac0690" # Jun 2, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/libs/langgraph"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/libs/langgraph"
	SRC_URI="
https://github.com/langchain-ai/langgraph/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Building stateful, multi-actor applications with LLMs"
HOMEPAGE="
	https://github.com/langchain-ai/langgraph/tree/1.2.4/libs/langgraph
	https://pypi.org/project/langgraph
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev lint test
"
REQUIRED_USE="
	dev? (
		lint
		test
	)
"
RDEPEND+="
	>=dev-python/langchain-core-1.4.0[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2[${PYTHON_USEDEP}]

	>=dev-python/langgraph-checkpoint-4.1.0[${PYTHON_USEDEP}]
	<dev-python/langgraph-checkpoint-5.0.0[${PYTHON_USEDEP}]

	>=dev-python/langgraph-sdk-0.4.2[${PYTHON_USEDEP}]
	<dev-python/langgraph-sdk-0.5.0[${PYTHON_USEDEP}]

	>=dev-python/langgraph-prebuilt-1.1.0[${PYTHON_USEDEP}]
	<dev-python/langgraph-prebuilt-1.2.0[${PYTHON_USEDEP}]

	>=dev-python/xxhash-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.7.4[${PYTHON_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		dev-python/jupyter[${PYTHON_USEDEP}]
	)
	lint? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/types-requests[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-dotenv[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/syrupy[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-watcher[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP},psutil]
		dev-python/pytest-repeat[${PYTHON_USEDEP}]
		>=dev-python/langchain-core-1.0.0[${PYTHON_USEDEP}]
		dev-python/langgraph-prebuilt[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint-sqlite[${PYTHON_USEDEP}]
		dev-python/langgraph-checkpoint-postgres[${PYTHON_USEDEP}]
		dev-python/langgraph-sdk[${PYTHON_USEDEP}]
		dev-python/psycopg[${PYTHON_USEDEP},binary]
		~dev-python/uvloop-0.22.1[${PYTHON_USEDEP}]
		dev-python/pyperf[${PYTHON_USEDEP}]
		dev-python/py-spy[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/langgraph-cli[${PYTHON_USEDEP}]
		' python3_{10..13})
		$(python_gen_cond_dep '
			dev-python/langgraph-cli[${PYTHON_USEDEP},inmem]
		' python3_{10..13})
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
	dodoc "${WORKDIR}/${P}/LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
