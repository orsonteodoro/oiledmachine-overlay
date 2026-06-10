# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYPI_PN="${PN}"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rec/tdir.git"
	FALLBACK_COMMIT="8246ac0b6c2db63fc3d9ffb257faa9325d49c8d2" # May 28, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/streaming/py"
	SRC_URI="
https://github.com/langchain-ai/agent-protocol/archive/refs/tags/langchain-protocol==${PV}.tar.gz
	-> ${P}.gh.tar.gz
	"
fi

DESCRIPTION="Python bindings for the LangChain agent streaming protocol"
HOMEPAGE="
	https://github.com/langchain-ai/agent-protocol/blob/main/streaming/py/pyproject.toml
	https://pypi.org/project/langchain-protocol
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev"
RDEPEND+="
	>=dev-python/typing-extensions-4.13.0[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
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
