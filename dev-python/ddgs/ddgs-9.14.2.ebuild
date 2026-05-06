# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# primp

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/deedy5/ddgs.git"
	FALLBACK_COMMIT="783308af96ed4c23dad4f21be7108f2ce48c4890" # May 3, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/deedy5/ddgs/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION=""
HOMEPAGE="
	https://github.com/deedy5/ddgs
	https://pypi.org/project/tdir
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" api dht  dev mcp"
RDEPEND+="
	>=dev-python/click-8.1.8[${PYTHON_USEDEP}]
	>=dev-python/primp-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.4[${PYTHON_USEDEP}]
	mcp? (
		>=dev-python/mcp-1.26.0[${PYTHON_USEDEP}]
	)
	api? (
		>=dev-python/fastapi-0.135.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.41.0[${PYTHON_USEDEP},standard]
	)
	dht? (
		>=dev-python/fastapi-0.135.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.41.0[${PYTHON_USEDEP},standard]
		>=dev-python/trio-0.25.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/mypy-1.17.1[${PYTHON_USEDEP}]
		dev-python/prek[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.4.1[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		>=dev-python/ruff-0.13.0[${PYTHON_USEDEP}]
		dev-python/lxml-stubs[${PYTHON_USEDEP}]
		dev-python/types-Pygments[${PYTHON_USEDEP}]
		dev-python/types-pexpect[${PYTHON_USEDEP}]
		dev-python/types-PyYAML[${PYTHON_USEDEP}]
		dev-python/types-ujson[${PYTHON_USEDEP}]
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
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
