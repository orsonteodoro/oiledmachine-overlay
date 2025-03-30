# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream tested up to 3.7 for this release

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/openai/box2d-py/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A repackaged version of pybox2d"
HOMEPAGE="
https://github.com/openai/box2d-py
"
LICENSE="ZLIB"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" examples test"
RDEPEND+="
	${PYTHON_DEPS}
	!dev-python/pybox2d
	>=dev-lang/swig-4
	examples? (
		|| (
			(
				$(python_gen_cond_dep '
					dev-python/pygame[${PYTHON_USEDEP}]
				')
			)
			(
				$(python_gen_cond_dep '
					dev-python/pygame_sdl2[${PYTHON_USEDEP}]
				')
			)
			(
				$(python_gen_cond_dep '
					dev-python/pyglet[${PYTHON_USEDEP}]
				')
			)
			(
				$(python_gen_cond_dep '
					dev-python/PyQt4[${PYTHON_USEDEP}]
				')
			)
			(
				media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
			)
		)
	)
"
DEPEND+="
	${RDEPEND}
"

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
	insinto "/usr/share/${PN}/examples"
	doins -r "examples/"*
	doins "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
