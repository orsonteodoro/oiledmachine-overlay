# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/srsly/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🦉 Modern high-performance serialization utilities for Python (JSON, MessagePack, Pickle)"
HOMEPAGE="
	https://github.com/explosion/srsly
	https://pypi.org/project/srsly
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev test
ebuild_revision_1
"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	>=dev-python/catalogue-2.0.3[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-0.29.1:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	dev? (
		>=dev-python/pytest-4.6.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.3.3[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.15.0[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

python_configure() {
	cython_python_configure
}

src_configure() {
	distutils-r1_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
