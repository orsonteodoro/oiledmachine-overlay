# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} )
# Limited by flax

inherit distutils-r1

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}/jax-jaxlib-v${PV}"
SRC_URI="
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Differentiate, compile, and transform Numpy code"
HOMEPAGE="
http://jax.readthedocs.io/
https://github.com/google/jax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cpu cuda doc experimental rocm test
ebuild_revision_2
"
# flax and tensorstore are missing in setup.py *_require sections but referenced
# in experimental but not in tests folder.
DEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.24[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10[${PYTHON_USEDEP}]
	' python3_11)
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.11.1[${PYTHON_USEDEP}]
	' python3_12)
	$(python_gen_cond_dep '
		>=dev-python/ml-dtypes-0.2.0[${PYTHON_USEDEP}]
		dev-python/opt-einsum[${PYTHON_USEDEP}]
		cuda? (
			=dev-libs/cudnn-9*
			dev-libs/cudnn:=
			=dev-util/nvidia-cuda-toolkit-12.3*
			dev-util/nvidia-cuda-toolkit:=
			>=x11-drivers/nvidia-drivers-545.23
		)
	')
	>=dev-python/jaxlib-${PV}[${PYTHON_SINGLE_USEDEP},cpu=,cuda=,rocm=]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
"
# Avoid circular depends \
PDEPEND+="
	experimental? (
		dev-python/flax[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "CITATION.bib" "README.md" )

distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc \
		"AUTHORS" \
		"LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
