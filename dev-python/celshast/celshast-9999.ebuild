# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-design

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..12} )
NODE_SLOT="18"

inherit distutils-r1 npm

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI="https://github.com/Farama-Foundation/Celshast.git"
	FALLBACK_COMMIT="c5909e4cd31057120d2955e67e7414a9a51e9601" # Dec 14, 2023
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="FIXME"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="A Sphinx documentation theme based on the Furo template"
HOMEPAGE="https://github.com/Farama-Foundation/Celshast"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc test
ebuild_revision_1
"
RDEPEND+="
	(
		>=dev-python/sphinx-6.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-8[${PYTHON_USEDEP}]
	)
	>=dev-python/pygments-2.7[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/sphinx-basic-ng[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-python/sphinx-theme-builder-0.2.0_alpha10[${PYTHON_USEDEP}]
		=net-libs/nodejs-18*:${NODE_SLOT}
		net-libs/nodejs:=
	)
	doc? (
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-design[${PYTHON_USEDEP}]
		dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
		dev-python/sphinx-tabs[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "docs/index.md" "README.md" )

distutils_enable_sphinx "docs"

pkg_setup() {
	npm_pkg_setup
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
