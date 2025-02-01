# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/scanny/python-oxmsg.git"
	FALLBACK_COMMIT="29cb91e80f3af95ae57d99952e613f8bf865cd9e" # Jun 1, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/scanny/python-oxmsg/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Extract Outlook email messages and attachments from MSG files"
HOMEPAGE="
	https://github.com/scanny/python-oxmsg
	https://pypi.org/project/python-oxmsg
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	>=dev-python/typing-extensions-4.9.0[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/olefile[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	dev? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/pyright[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-util/ruff-lsp[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocstrings[${PYTHON_USEDEP}]
		dev-python/mkdocstrings-python[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

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
