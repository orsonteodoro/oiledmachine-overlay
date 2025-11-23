# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream lists to 3.11

inherit cython distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/preshed/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="💥 Cython hash tables that assume keys are pre-hashed"
HOMEPAGE="
	https://github.com/explosion/preshed
	https://pypi.org/project/preshed
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev
ebuild_revision_2
"
RDEPEND+="
	>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/murmurhash-0.28.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-0.28:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/murmurhash-0.28.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
