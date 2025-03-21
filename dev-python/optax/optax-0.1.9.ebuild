# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# myst-nb
# sphinx-collections
# sphinxcontrib-katex

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_"{10..11} )
TENSORFLOW_PV="2.4.0"
TENSORFLOW_DATASETS_PV="4.2.0"
# Limited by jax/flax

inherit distutils-r1

SRC_URI="
https://github.com/deepmind/optax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Optax is a gradient processing and optimization library for JAX."
HOMEPAGE="
https://optax.readthedocs.io/
https://github.com/deepmind/optax
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples dp-accounting test"
REQUIRED_USE+="
	dp-accounting? (
		test
	)
	test? (
		dp-accounting
		examples
	)
"
RDEPEND+="
	>=dev-python/absl-py-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/chex-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/jax-0.1.55[${PYTHON_USEDEP}]
	>=dev-python/jaxlib-0.1.37[${PYTHON_USEDEP}]
	dp-accounting? (
		>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
	)
	examples? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_USEDEP}]
		>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_USEDEP}]
		>=sci-ml/tensorflow-datasets-${TENSORFLOW_DATASETS_PV}[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-python/flit-core-3.2[${PYTHON_USEDEP}]
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
	)
	app-arch/zip
	doc? (
		>=dev-python/ipython-8.8.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/myst-nb-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-book-theme-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-collections-0.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-gallery-0.14.0[${PYTHON_USEDEP}]
		>=dev-python/dm-haiku-0.0.11[${PYTHON_USEDEP}]
		dev-python/sphinx-autodoc-typehints[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-katex[${PYTHON_USEDEP}]
	)
	dp-accounting? (
		>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
		>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.4[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_USEDEP}]
		>=dev-python/dm-tree-0.1.7[${PYTHON_USEDEP}]
	)
"
# Avoid circular depends with flax \
# Avoid circular depends with tensorflow \
PDEPEND+="
	doc? (
		>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_USEDEP}]
		>=sci-ml/tensorflow-datasets-${TENSORFLOW_DATASETS_PV}[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/flax-0.5.3[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( "README.md" )

distutils_enable_sphinx "docs"

src_test() {
	sed -i -e "s|^pip |#pip |g" "test.sh" || die
	sed -i -e "s|^wget |#wget |g" "test.sh" || die
ewarn "src_test() is not tested"
	run_test() {
einfo "Running test for ${EPYTHON}"
		./test.sh || die
	}
	python_foreach_impl run_test
}

src_install() {
	if use examples ; then
		insinto "/usr/share/${PN}"
		doins -r "examples"
	fi

	rm_examples() {
		rm -rf "${WORKDIR}/optax-${PV}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages/examples" || die
	}
	python_foreach_impl rm_examples

	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
