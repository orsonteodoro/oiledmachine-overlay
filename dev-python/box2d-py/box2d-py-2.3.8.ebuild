# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream tested up to 3.7 for this release

inherit distutils-r1

SRC_URI="
https://github.com/openai/box2d-py/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A repackaged version of pybox2d"
HOMEPAGE="
https://github.com/openai/box2d-py
"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" examples test"
DEPEND+="
	${PYTHON_DEPS}
	!dev-python/pybox2d
	>=dev-lang/swig-4
	examples? (
		|| (
			dev-python/pygame[${PYTHON_USEDEP}]
			dev-python/pygame_sdl2[${PYTHON_USEDEP}]
			dev-python/pyglet[${PYTHON_USEDEP}]
			dev-python/PyQt4[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},python]
		)
	)
"
RDEPEND+="
	${DEPEND}
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} setup.py test || die
	}
	python_foreach_impl run_test
}

src_install() {
	distutils-r1_src_install
	cd "${S}" || die
	insinto /usr/share/${PN}/examples
	doins -r examples/*
	doins LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
