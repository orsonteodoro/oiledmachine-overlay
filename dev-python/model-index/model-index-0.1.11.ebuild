# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/paperswithcode/model-index.git"
	FALLBACK_COMMIT="a39af5f8aaa2a90b8fc7180744a855282360067a" # Mar 22, 2021
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="a39af5f8aaa2a90b8fc7180744a855282360067a" # Mar 22, 2021
	KEYWORDS="~amd64"
	S="${WORKDIR}/model-index-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/paperswithcode/model-index/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Create a source of truth for ML model results and browse it on \
Papers with Code"
HOMEPAGE="
	https://github.com/paperswithcode/model-index
	https://pypi.org/project/model-index
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/ordered-set[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-3.5.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6.2.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.11.1[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

distutils_enable_sphinx "docs"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '${PV}'" "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

python_install() {
	distutils-r1_python_install
	rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/tests"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
