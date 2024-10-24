# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# update DEPENDs for examples
# verify/fix examples install

# TODO package:
# atari-py
# clu
# einops
# jraph
# myst-nb
# nbstripout
# penzai
# pytest-custom_exit_code
# pytype
# sphinx_design
# tensorflow_text

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream lists only up to 3.11 in classifiers section.  CI only tests up to 3.11.

# Limited by orbax
inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/google/flax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Flax is a neural network library for JAX that is designed for \
flexibility."
HOMEPAGE="
https://flax.readthedocs.io/
https://github.com/google/flax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda doc examples test"
REQUIRED_USE="
	examples? (
		cuda
	)
"
# Some examples require cuda11+cudnn
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.23.2[${PYTHON_USEDEP}]
	' python3_11)
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.0[${PYTHON_USEDEP}]
	' python3_12)
	<sci-libs/orbax-checkpoint-0.4.5[${PYTHON_USEDEP}]
	(
		!examples? (
			>=sci-libs/jax-0.4.19[${PYTHON_USEDEP}]
		)
		examples? (
			>=sci-libs/jax-0.4.19[${PYTHON_USEDEP},cuda?]
			<sci-libs/jax-0.4.26[${PYTHON_USEDEP},cuda?]
		)
	)
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/rich-11.1[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	sci-libs/optax[${PYTHON_USEDEP}]
	sci-libs/orbax[${PYTHON_USEDEP}]
	sci-libs/tensorstore[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
		>=dev-python/jupytext-1.13.8[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.6.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-3.3.1[${PYTHON_USEDEP}]
		>=sci-libs/jax-0.4[${PYTHON_USEDEP}]
		dev-python/einops[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/myst-nb[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/sphinx_design[${PYTHON_USEDEP}]
		dev-python/sphinx-book-theme[${PYTHON_USEDEP}]
		sci-libs/dm-haiku[${PYTHON_USEDEP}]
		sci-libs/jaxlib[${PYTHON_USEDEP}]
		sci-libs/ml-collections[${PYTHON_USEDEP}]
		sci-libs/tensorflow[${PYTHON_USEDEP}]
		sci-libs/tensorflow-datasets[${PYTHON_USEDEP}]
		sci-libs/transformers[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/black-23.7.0[${PYTHON_USEDEP}]
		>=dev-python/jraph-0.0.6_pre0[${PYTHON_USEDEP}]
		>=dev-python/pyink-23.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.34.0[${PYTHON_USEDEP}]
		>=sci-libs/gymnasium-0.18.3[${PYTHON_USEDEP},atari,accept-rom-license]
		>=sci-libs/tensorflow_text-2.11.0[${PYTHON_USEDEP}]
		dev-python/clu[${PYTHON_USEDEP}]
		dev-python/einops[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/nbstripout[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-custom_exit_code[${PYTHON_USEDEP}]
		dev-python/pytorch[${PYTHON_USEDEP}]
		dev-python/pytype[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},python]
		sci-libs/jaxlib[${PYTHON_USEDEP}]
		sci-libs/ml-collections[${PYTHON_USEDEP}]
		sci-libs/sentencepiece[${PYTHON_USEDEP},python]
		sci-libs/tensorflow[${PYTHON_USEDEP},python]
		sci-libs/tensorflow-datasets[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc \
		"AUTHORS" \
		"LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
