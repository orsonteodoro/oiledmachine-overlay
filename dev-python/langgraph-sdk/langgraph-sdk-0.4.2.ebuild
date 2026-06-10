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
	EGIT_REPO_URI="https://github.com/rec/tdir.git"
	FALLBACK_COMMIT="13f2ecc84bdf257af19b370a2f03a0f02d15674d" # Jun 1, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/libs/sdk-py"
	SRC_URI="
https://github.com/langchain-ai/langgraph/archive/refs/tags/sdk==${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="SDK for interacting with LangGraph API"
HOMEPAGE="
	https://github.com/langchain-ai/langgraph/tree/main/libs/sdk-py
	https://github.com/rec/tdir
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
	>=dev-python/httpx-0.25.2[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.11.5[${PYTHON_USEDEP}]
	>=dev-python/langchain-protocol-0.0.15[${PYTHON_USEDEP}]

	>=dev-python/langchain-core-1.4.0[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2[${PYTHON_USEDEP}]

	>=dev-python/websockets-14[${PYTHON_USEDEP}]
	<dev-python/websockets-16[${PYTHON_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		dev-python/langgraph[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.12.4[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-util/ruff-0.15.12
		dev-python/codespell[${PYTHON_USEDEP}]
		dev-python/ty[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-watch[${PYTHON_USEDEP}]
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
