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
	EGIT_REPO_URI="https://github.com/aboutcode-org/gemfileparser2.git"
	FALLBACK_COMMIT="41c18b07ff8bdc986849a0d6a25545b37908314e" # Aug 20, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/gemfileparser2/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Parse Ruby Gemfile, .gemspec and Cocoapod .podspec files using Python"
HOMEPAGE="
	https://github.com/aboutcode-org/gemfileparser2
	https://pypi.org/project/gemfileparser2
"
LICENSE="
	|| (
		GPL-3+
		MIT
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml(+)]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-5.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-reredirects-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.11.2[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-7.0.2[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS" "CHANGELOG.rst" "README.rst" )

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
	dodoc "LICENSE" "LICENSE.GPLv3" "LICENSE.MIT"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
