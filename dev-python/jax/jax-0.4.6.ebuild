# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..9} )
# Limited by flax
inherit distutils-r1

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
IUSE+=" australis cpu cuda doc rocm test"
# We don't add tpu because licensing issue with libtpu_nightly.
gen_jaxlib_depend() {
	local pv="${1}"
	echo "
		|| (
			>=dev-python/jaxlib-${pv}[${PYTHON_USEDEP},cpu?,cuda?,rocm?]
			>=dev-python/jaxlib-bin-${pv}[${PYTHON_USEDEP}]
		)
	"
}
# flax and tensorstore are missing in setup.py *_require sections but referenced
# in experimental but not in tests folder.
DEPEND+="
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	dev-python/opt-einsum[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tensorstore[${PYTHON_USEDEP}]
	australis? (
		dev-libs/protobuf:=
	)
	cpu? (
		$(gen_jaxlib_depend ${PV})
	)
	cuda? (
		$(gen_jaxlib_depend ${PV})
		=dev-util/nvidia-cuda-toolkit-11*
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-libs/protobuf:=
	dev-python/flake8[${PYTHON_USEDEP}]
	test? (
		$(gen_jaxlib_depend 0.4.4)
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	dev-python/flax[${PYTHON_USEDEP}]
" # Avoid circular
SRC_URI="
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${P}.tar.gz
"
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
