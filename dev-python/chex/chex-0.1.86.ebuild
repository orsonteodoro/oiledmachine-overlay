# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# myst-nb
# pandoc
# sphinxcontrib-katex

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # See https://github.com/deepmind/chex/blob/v0.1.82/.github/workflows/ci.yml
# Limited by jax

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/deepmind/chex/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Chex is a library of utilities for helping to write reliable JAX code."
HOMEPAGE="
https://chex.readthedocs.io/
https://github.com/deepmind/chex
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" docs test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.24.1[${PYTHON_USEDEP}]
		>=dev-python/toolz-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
	')
	>=dev-python/jax-0.4.16[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/jaxlib-0.1.37[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		docs? (
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			>=dev-python/ipython-7.16.3[${PYTHON_USEDEP}]
			>=dev-python/ipykernel-5.3.4[${PYTHON_USEDEP}]
			>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
			>=dev-python/myst-nb-0.13.1[${PYTHON_USEDEP}]
			>=dev-python/pandoc-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-katex-0.8.6[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/cloudpickle-2.2.0[${PYTHON_USEDEP}]
			>=dev-python/dm-tree-0.1.5[${PYTHON_USEDEP}]
		)
	')
"

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
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
