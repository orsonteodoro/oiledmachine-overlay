# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/modelcontextprotocol/python-sdk.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/python-sdk-${PV}"
	SRC_URI="
https://github.com/modelcontextprotocol/python-sdk/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Model Context Protocol SDK"
HOMEPAGE="
	https://modelcontextprotocol.io
	https://github.com/modelcontextprotocol/python-sdk
	https://pypi.org/project/mcp
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" cli dev doc rich ws"
RDEPEND+="
	>=dev-python/pydantic-2.11.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]

	>=dev-python/anyio-4.5[${PYTHON_USEDEP}]

	>=dev-python/httpx-0.27.1[${PYTHON_USEDEP}]
	<dev-python/httpx-1.0.0[${PYTHON_USEDEP}]

	>=dev-python/httpx-sse-0.4[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.20.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2.5.2[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.10.1[${PYTHON_USEDEP},crypto(+)]
	>=dev-python/python-multipart-0.0.9[${PYTHON_USEDEP}]
	>=dev-python/sse-starlette-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.27[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.31.1[${PYTHON_USEDEP}]
	cli? (
		>=dev-python/python-dotenv-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/typer-0.16.0[${PYTHON_USEDEP}]
	)
	rich? (
		>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
	)
	ws? (
		>=dev-python/websockets-15.0.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/hatchling[${PYTHON_USEDEP}]
	dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]
	dev? (
		~dev-python/coverage-7.10.7[${PYTHON_USEDEP},toml(+)]
		>=dev-python/dirty-equals-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/pyright-1.1.400[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-flakefinder-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-examples-0.0.14[${PYTHON_USEDEP}]
		>=dev-python/pytest-pretty-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/ruff-0.8.5[${PYTHON_USEDEP}]
		>=dev-python/trio-0.26.2[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/mkdocs-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-glightbox-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-material-9.5.45[${PYTHON_USEDEP},imaging(+)]
		>=dev-python/mkdocstrings-python-1.12.2[${PYTHON_USEDEP}]
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
