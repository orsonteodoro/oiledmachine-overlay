# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# flake8-pyi

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/metaopt/optree/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="tree is a library for working with nested data structures"
HOMEPAGE="https://github.com/metaopt/optree"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
benchmark doc jax numpy pytorch test
ebuild_revision_2
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		numpy? (
			dev-python/numpy[${PYTHON_USEDEP}]
		)
	')
	jax? (
		dev-python/jax[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		benchmark? (
			(
				>=dev-python/dm-tree-0.1[${PYTHON_USEDEP}]
				<dev-python/dm-tree-0.2.0_alpha0[${PYTHON_USEDEP}]
			)
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
			dev-python/termcolor[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/sphinx-5.2.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.19.2[${PYTHON_USEDEP}]
			dev-python/sphinx-autoapi[${PYTHON_USEDEP}]
			dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
			dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]

			<dev-python/doc8-1.0.0_alpha0
			>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.11.0[${PYTHON_USEDEP}]
			>=dev-python/mypy-0.990[${PYTHON_USEDEP}]
			>=dev-python/pylint-2.15.0[${PYTHON_USEDEP}]
			dev-cpp/cpplint[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/flake8-bugbear[${PYTHON_USEDEP}]
			dev-python/flake8-comprehensions[${PYTHON_USEDEP}]
			dev-python/flake8-docstrings[${PYTHON_USEDEP}]
			dev-python/flake8-pyi[${PYTHON_USEDEP}]
			dev-python/flake8-simplify[${PYTHON_USEDEP}]
			dev-python/pydocstyle[${PYTHON_USEDEP}]
			dev-python/pyenchant[${PYTHON_USEDEP}]
			dev-python/xdoctest[${PYTHON_USEDEP}]
			dev-util/ruff
		)
	')
	benchmark? (
		(
			>=dev-python/jax-0.4.6[${PYTHON_SINGLE_USEDEP},cpu]
			<dev-python/jax-0.5.0_alpha0[${PYTHON_SINGLE_USEDEP},cpu]
		)
		(
			>=sci-ml/pytorch-2.0[${PYTHON_SINGLE_USEDEP}]
			<sci-ml/pytorch-2.1.0_alpha0[${PYTHON_SINGLE_USEDEP}]
		)
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
	doc? (
		>=dev-python/jax-0.3[${PYTHON_SINGLE_USEDEP},cpu]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

distutils_enable_sphinx "docs"

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
