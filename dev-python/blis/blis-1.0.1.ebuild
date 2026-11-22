# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BLIS_COMMIT="8137f660d8351c3a3c3b38f4606121578e128b70"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{13..14} ) # NumPy needs >= 3.13

inherit cython dep-prepare pypi secure-version distutils-r1

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
	https://github.com/explosion/cython-blis
	https://pypi.org/project/blis
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
test
ebuild_revision_8
"
RDEPEND+="
	virtual/numpy[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-${CYTHON_PV}:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	virtual/numpy[${PYTHON_USEDEP}]
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
