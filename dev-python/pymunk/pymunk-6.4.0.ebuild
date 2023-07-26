# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
	EGIT_OVERRIDE_REPO_GIT_GITHUB_COM_VIBLO_CHIPMUNK2D="https://github.com/viblo/Chipmunk2D.git"
else
	CHIPMUNK2D_COMMIT="0593976ef47fcb3957166bd342f6b2bafe4d0e44"
	SRC_URI="
https://github.com/viblo/pymunk/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/viblo/Chipmunk2D/archive/${CHIPMUNK2D_COMMIT}.tar.gz
	-> Chipmunk2D-${CHIPMUNK2D_COMMIT:0:7}.tar.gz
	"
fi

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
IUSE+=" doc test"
DEPEND+="
	>=dev-python/cffi-1.15.0[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-util/cmake
	doc? (
		dev-python/aafigure[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		<dev-python/pyglet-2.0.0[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.rst CITATION.cff THANKS.txt README.rst )

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		EGIT_REPO_URI="https://github.com/viblo/pymunk.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="HEAD"
		use fallback-commit && EGIT_COMMIT="ec7bf669729d72a81e8dd0333966d8328c4c4ca0"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		rm -rf "${S}/Chipmunk2D" || die
		mv \
			"${WORKDIR}/Chipmunk2D-${CHIPMUNK2D_COMMIT}" \
			"${S}/Chipmunk2D" \
			|| die
	fi
}

src_test() {
	run_test() {
		pushd "${S}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages" || die
einfo "${LD_LIBRARY_PATH}"
einfo "Running test for ${EPYTHON}"
			${EPYTHON} -m pymunk.tests || die
		popd
	}
	python_foreach_impl run_test
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.txt
}

distutils_enable_sphinx "docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
