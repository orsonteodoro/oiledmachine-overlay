# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
# Limited by flax

inherit distutils-r1

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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
australis doc experimental test
r2
"
# flax and tensorstore are missing in setup.py *_require sections but referenced
# in experimental but not in tests folder.
DEPEND+="
	>=dev-python/jaxlib-${PV}
	>=dev-python/ml_dtypes-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.7[${PYTHON_USEDEP}]
	dev-python/opt-einsum[${PYTHON_USEDEP}]
	australis? (
		dev-libs/protobuf:0/3.21
	)
	experimental? (
		dev-python/tensorstore[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-libs/protobuf:0/3.21
	dev-python/flake8[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	experimental? (
		dev-python/flax[${PYTHON_USEDEP}]
	)
" # Avoid circular
S="${WORKDIR}/jax-jax-v${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md CITATION.bib README.md )

distutils_enable_tests "pytest"

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
