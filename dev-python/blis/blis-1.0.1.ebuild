# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
BLIS_COMMIT="8137f660d8351c3a3c3b38f4606121578e128b70"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython dep-prepare distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/cython-${PN}-release-v${PV}"
SRC_URI="
https://github.com/explosion/cython-blis/archive/refs/tags/release-v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/explosion/blis/archive/${BLIS_COMMIT}.tar.gz
	-> blis-${BLIS_COMMIT:0:7}.tar.gz
"

DESCRIPTION="A self-contained 💥 fast matrix-multiplication Python library without system dependencies!"
HOMEPAGE="
	https://github.com/explosion/blis
	https://pypi.org/project/blis
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
test
ebuild_revision_2
"
RDEPEND+="
	>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-0.25:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hypothesis-4.0.0
		dev-python/pytest
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/blis-${BLIS_COMMIT}" "flame-blis"
}

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
