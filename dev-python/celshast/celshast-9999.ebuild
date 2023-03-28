# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="A Sphinx documentation theme based on the Furo template"
HOMEPAGE="https://github.com/Farama-Foundation/Celshast"
LICENSE="
	MIT
"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Ebuild is not tested.
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-python/myst_parser[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/sphinx_design[${PYTHON_USEDEP}]
	dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
	dev-python/furo[${PYTHON_USEDEP}]
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md docs/index.md README.md )

src_unpack() {
	EGIT_REPO_URI="https://github.com/Farama-Foundation/Celshast.git"
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	use fallback-commit && EGIT_COMMIT="d103808d9d864dd1d9f2eab7b99d12a79248f8b9"
	git-r3_fetch
	git-r3_checkout
}

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
