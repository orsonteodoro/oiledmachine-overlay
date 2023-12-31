# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
	>=dev-python/chex-0.1.8[${PYTHON_USEDEP}]
	>=dev-python/jax-0.4.13[${PYTHON_USEDEP}]
	>=dev-python/jaxlib-0.1.37[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
	examples? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_USEDEP}]
		>=dev-python/tensorflow-datasets-4.2.0[${PYTHON_USEDEP}]
		>=sci-libs/tensorflow-2.4.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
# TODO: package
# dp-accounting
# myst_nb
# sphinxcontrib-katex
BDEPEND+="
	app-arch/zip
	doc? (
		>=dev-python/dm-haiku-0.0.8[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
		>=dev-python/ipython-7.16.3[${PYTHON_USEDEP}]
		>=dev-python/ipykernel-5.3.4[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/myst_nb-0.13.1[${PYTHON_USEDEP}]
		>=dev-python/pandoc-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-book-theme-0.3.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-bibtex-2.4.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.9.0[${PYTHON_USEDEP}]

	)
	dp-accounting? (
		>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
		>=dev-python/dp-accounting-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.4[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_USEDEP}]
		>=dev-python/dm-tree-0.1.7[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	test? (
		>=dev-python/flax-0.5.3
	)
" # Avoid circular depends with flax
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( README.md )

distutils_enable_sphinx "docs"

src_test() {
	sed -i -e "s|^pip |#pip |g" test.sh || die
	sed -i -e "s|^wget |#wget |g" test.sh || die
ewarn "src_test() is not tested"
	run_test() {
einfo "Running test for ${EPYTHON}"
		./test.sh || die
	}
	python_foreach_impl run_test
}

src_install() {
	if use examples ; then
		insinto /usr/share/${PN}
		doins -r "examples"
	fi

	rm_examples() {
		rm -rf "${WORKDIR}/optax-${PV}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages/examples" || die
	}
	python_foreach_impl rm_examples

	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
