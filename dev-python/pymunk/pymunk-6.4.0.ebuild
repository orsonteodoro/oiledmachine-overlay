# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Pymunk is a easy-to-use pythonic 2d physics library that can be \
used whenever you need 2d rigid body physics from Python"
HOMEPAGE="
http://www.pymunk.org/
https://github.com/viblo/pymunk
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc"
DEPEND+="
	>=dev-python/cffi-1.15.0[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
# TODO: package
# aafigure
BDEPEND+="
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-util/cmake
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
	dev? (
		<dev-python/pyglet-2.0.0[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
		dev-python/aafigure[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"
CHIPMUNK2D_COMMIT="0593976ef47fcb3957166bd342f6b2bafe4d0e44"
SRC_URI="
https://github.com/viblo/pymunk/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/viblo/Chipmunk2D/archive/${CHIPMUNK2D_COMMIT}.tar.gz
	-> Chipmunk2D-${CHIPMUNK2D_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.rst CITATION.cff THANKS.txt README.rst )

src_unpack() {
	unpack ${A}
	rm -rf "${S}/Chipmunk2D" || die
	mv \
		"${WORKDIR}/Chipmunk2D-${CHIPMUNK2D_COMMIT}" \
		"${S}/Chipmunk2D" \
		|| die
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.txt
}

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
