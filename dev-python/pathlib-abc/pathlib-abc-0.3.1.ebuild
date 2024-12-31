# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CPYTHON_COMMIT="e42c190b6732ae52390607463cd247739852c8a0"
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit dep-prepare distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/barneygale/pathlib-abc/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/barneygale/cpython/archive/${CPYTHON_COMMIT}.tar.gz
	-> cpython-${CPYTHON_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Python base classes for rich path objects"
HOMEPAGE="
	https://github.com/barneygale/pathlib-abc
	https://pypi.org/project/pathlib-abc
"
LICENSE="
	PSF-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/hatchling[${PYTHON_USEDEP}]
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/cpython-${CPYTHON_COMMIT}" "${S}/cpython"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
