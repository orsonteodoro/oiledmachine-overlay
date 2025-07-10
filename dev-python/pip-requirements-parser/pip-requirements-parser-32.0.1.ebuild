# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aboutcode-org/pip-requirements-parser.git"
	FALLBACK_COMMIT="c009a483a899f0b39b474be434ef5c9cf7fe0a41" # Dec 21, 2022
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/pip-requirements-parser/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A mostly correct pip requirements parsing library because it uses pip's own code"
HOMEPAGE="
	https://github.com/aboutcode-org/pip-requirements-parser
	https://pypi.org/project/pip-requirements-parser
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP},toml(+)]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/doc8-0.8.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		!=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2[${PYTHON_USEDEP}]
		>=dev-python/aboutcode-toolkit-6.0.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS.rst" "CHANGELOG.rst" "README.rst" )

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
	dodoc "mit.LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
