# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..10} ) # Upstream lists only up to 3.10

# Limited by orbax
inherit distutils-r1

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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
# TODO: package
# atari-py
# clu
# codediff
# einops
# jraph
# ml-collections
# myst_nb
# nbstripout
# orbax-checkpoint
# pytest-custom_exit_code
# pytype
# sentencepiece
# tensorflow_datasets
# tensorflow_text
DEPEND+="
	>=dev-python/jax-0.4.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.12[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/rich-11.1[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/optax[${PYTHON_USEDEP}]
	dev-python/orbax[${PYTHON_USEDEP}]
	dev-python/orbax-checkpoint[${PYTHON_USEDEP}]
	dev-python/tensorstore[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		dev-python/codediff[${PYTHON_USEDEP}]
		dev-python/myst_nb[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_design[${PYTHON_USEDEP}]
		dev-python/sphinx-book-theme[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/atari-py-0.2.5[${PYTHON_USEDEP}]
		>=dev-python/gymnasium-0.18.3[${PYTHON_USEDEP},atari,accept-rom-license]
		>=dev-python/jraph-0.0.6_pre0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.34.0[${PYTHON_USEDEP}]
		>=dev-python/tensorflow_text-2.11.0[${PYTHON_USEDEP}]
		dev-python/clu[${PYTHON_USEDEP}]
		dev-python/einops[${PYTHON_USEDEP}]
		dev-python/jaxlib[${PYTHON_USEDEP}]
		dev-python/ml-collections[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/nbstripout[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-custom_exit_code[${PYTHON_USEDEP}]
		dev-python/pytorch[${PYTHON_USEDEP}]
		dev-python/pytype[${PYTHON_USEDEP}]
		dev-python/sentencepiece[${PYTHON_USEDEP}]
		dev-python/tensorflow[${PYTHON_USEDEP},python]
		dev-python/tensorflow_datasets[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},python]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror test"
DOCS=( CHANGELOG.md README.md )

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
