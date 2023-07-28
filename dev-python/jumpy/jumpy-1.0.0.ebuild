# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_{10..11} )
# Limited by jax
inherit distutils-r1

DESCRIPTION="On-the-fly conversions between Jax and NumPy tensors"
HOMEPAGE="
https://github.com/Farama-Foundation/Jumpy
"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" jax test r1"
REQUIRED_USE="
	test? (
		jax
	)
"
DEPEND+="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	jax? (
		>=dev-python/jax-0.3.24[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.24[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/hatchling-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/Farama-Foundation/Jumpy/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/Jumpy-${PV}"
RESTRICT="mirror"

src_install() {
	python_moduleinto ${PN}
	python_foreach_impl python_domodule .
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
