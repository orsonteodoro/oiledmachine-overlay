# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# quartodoc

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/has2k1/plotnine.git"
	FALLBACK_COMMIT="90605ad9bb1e4b906a20f0c5dee15a0aaaf2177b" # May 9, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/has2k1/plotnine/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Grammar of Graphics for Python "
HOMEPAGE="
	https://plotnine.org/
	https://github.com/has2k1/plotnine
	https://pypi.org/project/plotnine
"
LICENSE="
	MIT
	BSD
"
RESTRICT="mirror test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev extra test"
RDEPEND+="
	(
		>=dev-python/pandas-2.1.0[${PYTHON_USEDEP}]
		<dev-python/pandas-3.0.0[${PYTHON_USEDEP}]
	)
	>=dev-python/matplotlib-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/mizani-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/statsmodels-0.14.0[${PYTHON_USEDEP}]
	extra? (
		>=dev-python/numpydoc-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/quartodoc-0.7.2[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/importlib-resources[${PYTHON_USEDEP}]
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/nbsphinx[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-59[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
	dev-python/build[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		$(python_gen_any_dep '
			dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		')
		dev-util/ruff

		dev-python/twine[${PYTHON_USEDEP}]

		dev-python/pyright[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/pandas-stubs[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_test() {
	export MATPLOTLIB_BACKEND="agg"
	pytest || die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "licences/SEABORN_LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
