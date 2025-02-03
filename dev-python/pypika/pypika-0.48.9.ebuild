# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# bumpversion
# tox-gh-actions

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/kayak/pypika.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/kayak/pypika/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A SQL query builder API for Python"
HOMEPAGE="
	https://github.com/kayak/pypika
	https://pypi.org/project/PyPika
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/black-21.5_beta1[${PYTHON_USEDEP}]
		>=dev-python/bumpversion-0.5.3[${PYTHON_USEDEP}]
		>=dev-python/coverage-5.1[${PYTHON_USEDEP}]
		>=dev-python/parameterized-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.6.5[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/tox-3.14.3[${PYTHON_USEDEP}]
		>=dev-python/tox-gh-actions-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/tox-venv-0.4.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

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
