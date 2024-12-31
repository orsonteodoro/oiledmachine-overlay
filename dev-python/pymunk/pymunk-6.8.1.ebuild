# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

if [[ ${PV} =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	EGIT_OVERRIDE_REPO_GIT_GITHUB_COM_VIBLO_CHIPMUNK2D="https://github.com/viblo/Chipmunk2D.git"
	EGIT_REPO_URI="https://github.com/viblo/pymunk.git"
	FALLBACK_COMMIT="b56e6de2130095b7596d30a0cf3d39db246bda57" # Jun 5, 2024
	inherit git-r3
else
	CHIPMUNK2D_COMMIT="7a29dcfa49931f26632f3019582f289ba811a2b9" # May 9, 2024
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/viblo/pymunk/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/viblo/Chipmunk2D/archive/${CHIPMUNK2D_COMMIT}.tar.gz
	-> Chipmunk2D-${CHIPMUNK2D_COMMIT:0:7}.tar.gz
	"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="A Pythonic 2D rigid body physics library"
HOMEPAGE="
http://www.pymunk.org/
https://github.com/viblo/pymunk
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
REQUIRED_USE+="
	test? (
		doc
	)
"
DEPEND+="
	>=dev-python/cffi-1.15.0[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.7
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-3.0[${PYTHON_USEDEP}]
		dev-python/aafigure[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
	)
	test? (
		<dev-python/pyglet-2.0.0[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.rst" "CITATION.cff" "THANKS.txt" "README.rst" )

distutils_enable_sphinx "docs"

src_unpack() {
	if [[ ${PV} =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		rm -rf \
			"${S}/Chipmunk2D" \
			|| die
		mv \
			"${WORKDIR}/Chipmunk2D-${CHIPMUNK2D_COMMIT}" \
			"${S}/Chipmunk2D" \
			|| die
	fi
}

src_test() {
	run_test() {
		pushd "${S}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages" || die
einfo "LD_LIBRARY_PATH:  ${LD_LIBRARY_PATH}"
einfo "Running test for ${EPYTHON}"
			${EPYTHON} -m pymunk.tests || die
		popd
	}
	python_foreach_impl run_test
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
