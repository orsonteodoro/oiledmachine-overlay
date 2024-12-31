# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/omry/omegaconf.git"
	FALLBACK_COMMIT="350bdb632865c5dd2286f2f6521acefe4abd843d" # Dec 8, 2022
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/omry/omegaconf/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A flexible configuration library"
HOMEPAGE="
	https://github.com/omry/omegaconf
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
REQUIRED_USE="
"
RDEPEND+="
	>=dev-python/antlr4-python3-runtime-4.9[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(python_gen_any_dep '
			dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/isort-5.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/coveralls[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/nox[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/towncrier[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/pydevd[${PYTHON_USEDEP}]
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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "DISCLAIMER"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
