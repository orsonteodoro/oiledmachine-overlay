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
	EGIT_REPO_URI="https://github.com/aboutcode-org/saneyaml.git"
	FALLBACK_COMMIT="133462863e3877a8beeec0c37444de1581bbf275" # Aug 13, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aboutcode-org/saneyaml/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Read and write readable YAML safely preserving order and avoiding bad surprises with unwanted infered type conversions"
HOMEPAGE="
	https://github.com/aboutcode-org/saneyaml
	https://pypi.org/project/saneyaml
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-4[${PYTHON_USEDEP}]
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
		>=dev-python/aboutcode-toolkit-7.0.2[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.rst" "README.rst" )

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
	dodoc "apache-2.0.LICENSE" "AUTHORS.rst" "LICENSE" "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
