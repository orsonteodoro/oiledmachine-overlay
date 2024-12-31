# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package
# flake8-pyproject
# pep8-naming
# sphinx-substitution-extensions
# types-PyYAML

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/alexdlaird/pyngrok.git"
	FALLBACK_COMMIT="3954d6f998d0982560c772459a0af5944cc000e9" # Dec 13, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/alexdlaird/pyngrok/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python wrapper for ngrok"
HOMEPAGE="
	https://github.com/alexdlaird/pyngrok
	https://pypi.org/project/pyngrok
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc"
RDEPEND+="
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/make
	dev? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-pyproject[${PYTHON_USEDEP}]
		dev-python/pep8-naming[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-autodoc-typehints-1.25.2[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-notfound-page[${PYTHON_USEDEP}]
		dev-python/sphinx-substitution-extensions[${PYTHON_USEDEP}]
		dev-python/types-PyYAML[${PYTHON_USEDEP}]
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
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
