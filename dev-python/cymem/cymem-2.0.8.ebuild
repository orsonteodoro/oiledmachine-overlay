# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/cymem/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="💥 Cython memory pool for RAII-style memory management"
HOMEPAGE="
	https://github.com/explosion/cymem
	https://pypi.org/project/cymem
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev
ebuild_revision_1
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-0.25:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
