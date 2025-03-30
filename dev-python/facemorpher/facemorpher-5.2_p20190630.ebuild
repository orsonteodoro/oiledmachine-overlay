# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="face_morpher"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="7a30611cd9d33469e843cec9cfa23ccf819386a8" # Jun 30, 2019
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="dlib"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/alyssaq/face_morpher.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/alyssaq/face_morpher/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	model? (
http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
	)
	"
fi

DESCRIPTION="👼 Morph faces with Python, Numpy, Scipy"
HOMEPAGE="
	https://github.com/alyssaq/face_morpher
	https://pypi.org/project/facemorpher
"
LICENSE="
	MIT
	model? (
		custom
		non-commerical-only
	)
"
# custom - shape_predictor_68_face_landmarks.dat - See https://github.com/davisking/dlib-models?tab=readme-ov-file#shape_predictor_68_face_landmarksdatbz2
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ffmpeg gstreamer +jpeg +model +png stasm"
# opencv[ffmpeg] or opencv[gstreamer] enables mjpeg encoding for saving video morphing animation.
REQUIRED_USE="
	|| (
		ffmpeg
		gstreamer
	)
	|| (
		jpeg
		png
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/docopt[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		sci-libs/dlib[${PYTHON_USEDEP},jpeg?,png?]
	')
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},ffmpeg?,gstreamer?,python]
	stasm? (
		dev-python/stasm[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.rst" )
PATCHES=(
	"${FILESDIR}/${PN}-7a30611-change-model-dir.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_install() {
	distutils-r1_python_install
	rm -rf "${ED}/usr/readme"
}

src_install() {
	distutils-r1_src_install
	if use model ; then
		insinto "/usr/share/${PN}/model"
		doins "${WORKDIR}/shape_predictor_68_face_landmarks.dat"
	fi
}

pkg_postinst() {
	if ! use model ; then
ewarn "DLIB_DATA_DIR must be defined to your custom model containing your own version of shape_predictor_68_face_landmarks.dat."
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (7a30611, 20241220)
# cli test jpeg1 + jpeg2 -> x264 pass
# cli test png1 + png2 -> x264 pass
