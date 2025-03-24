# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/scanny/python-pptx.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/scanny/python-pptx/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Create Open XML PowerPoint documents in Python"
HOMEPAGE="
	https://github.com/scanny/python-pptx
	https://pypi.org/project/python-pptx
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
	>=dev-python/lxml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/xlsxwriter-0.5.7[${PYTHON_USEDEP}]
	>=virtual/pillow-3.3.2[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-util/ruff
	)
	doc? (
		>=dev-python/sphinx-1.8.6[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-0.23[${PYTHON_USEDEP}]
		<dev-python/alabaster-0.7.14[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/behave-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.5[${PYTHON_USEDEP}]
		dev-python/pytest-coverage[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-util/ruff

		>=dev-python/behave-1.2.5[${PYTHON_USEDEP}]
		>=dev-python/flake8-2.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.5[${PYTHON_USEDEP}]
		>=dev-python/xlsxwriter-0.5.7[${PYTHON_USEDEP}]
		>=virtual/pillow-3.3.2[${PYTHON_USEDEP}]
	)

"
DOCS=( "HISTORY.rst" "README.rst" )

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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
