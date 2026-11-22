# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython pypi secure-version distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/murmurhash/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="💥 Cython bindings for MurmurHash2"
HOMEPAGE="
	https://github.com/explosion/murmurhash
	https://pypi.org/project/murmurhash
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
ebuild_revision_5
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-${CYTHON_PV}:${CYTHON_SLOT}=
	dev-python/cython:=
	dev-python/pytest
"
DOCS=( "README.md" )

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
