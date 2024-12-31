# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..11} )
# Limited by jax

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/Jumpy-${PV}"
SRC_URI="
https://github.com/Farama-Foundation/Jumpy/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="On-the-fly conversions between Jax and NumPy tensors"
HOMEPAGE="
https://farama.org/
https://github.com/Farama-Foundation/Jumpy
"
LICENSE="Apache-2.0"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" jax test ebuild_revision_1"
REQUIRED_USE="
	test? (
		jax
	)
"
RDEPEND+="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	jax? (
		>=sci-libs/jax-0.3.24[${PYTHON_USEDEP}]
		>=sci-libs/jaxlib-0.3.24[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/hatchling-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
	)
"

src_install() {
	python_moduleinto ${PN}
	python_foreach_impl python_domodule .
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
