# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="PySceneDetect"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Breakthrough/PySceneDetect.git"
	FALLBACK_COMMIT="c0459fe3408c765c1708949abebffb33084c518b" # Nov 24, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}-release"
	SRC_URI="
https://github.com/Breakthrough/PySceneDetect/archive/refs/tags/v${PV}-release.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="🎥 Python and OpenCV-based scene cut/transition detection program & library"
HOMEPAGE="
	https://www.scenedetect.com
	https://github.com/Breakthrough/PySceneDetect
	https://pypi.org/project/scenedetect
"
LICENSE="
	BSD
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev moviepy opencv pyav test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/click-8.0[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
	moviepy? (
		dev-python/moviepy[${PYTHON_SINGLE_USEDEP}]
	)
	opencv? (
		media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	)
	pyav? (
		>=dev-python/av-9.2[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		test? (
			>=dev-python/pytest-7.0[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "CITATION.cff" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
