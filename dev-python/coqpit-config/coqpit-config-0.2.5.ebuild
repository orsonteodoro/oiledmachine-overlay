# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/idiap/coqui-ai-coqpit.git"
	FALLBACK_COMMIT="86ef1642fc15093f5f19325ee54391edeeb81feb" # Apr 9, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/idiap/coqui-ai-coqpit/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Simple (maybe too simple), light-weight config management through python data-classes"
HOMEPAGE="
	https://github.com/idiap/coqui-ai-coqpit
	https://pypi.org/project/coqpit-config/
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev"
RDEPEND+="
	>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/coverage-7[${PYTHON_USEDEP}]
		~dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-4[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/pytest-9[${PYTHON_USEDEP}]
		~dev-python/ruff-0.14.10
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
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
