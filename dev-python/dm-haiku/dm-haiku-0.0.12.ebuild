# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="dm-haiku"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only tests up to 3.11

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/deepmind/dm-haiku/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="JAX-based neural network library"
HOMEPAGE="
https://dm-haiku.readthedocs.io/
https://github.com/deepmind/dm-haiku
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc jax test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/jmp-0.0.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.9[${PYTHON_USEDEP}]
	')
	>=dev-python/flax-0.7.1[${PYTHON_SINGLE_USEDEP}]
	jax? (
		>=dev-python/jax-0.4.24[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/jaxlib-0.4.24[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		doc? (
			>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-bibtex-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-katex-0.8.6[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-book-theme-0.3.3[${PYTHON_USEDEP}]
			>=dev-python/nbsphinx-0.8.9[${PYTHON_USEDEP}]
			>=dev-python/ipykernel-5.3.4[${PYTHON_USEDEP}]
			>=dev-python/ipython-7.16.1[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/cloudpickle-1.2.2[${PYTHON_USEDEP}]
			>=dev-python/mock-3.0.5[${PYTHON_USEDEP}]
			>=dev-python/chex-0.0.4[${PYTHON_USEDEP}]
			>=dev-python/dm-tree-0.1.1[${PYTHON_USEDEP}]
			dev-python/dill[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/virtualenv[${PYTHON_USEDEP}]
		)
	')
	test? (
		>=dev-python/optax-0.0.1[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-2.16.0[${PYTHON_SINGLE_USEDEP},python]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
