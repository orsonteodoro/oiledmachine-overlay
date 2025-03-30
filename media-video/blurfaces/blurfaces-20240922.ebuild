# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="a2f2a08d47f387a50fcbc18786837e9b8741d74b" # Sep 22, 2024
PYTHON_COMPAT=( "python3_"{10..12} )

inherit python-single-r1 python-utils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/raviksharma/blurfaces.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/raviksharma/blurfaces/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Blurs faces in video"
HOMEPAGE="
	https://github.com/raviksharma/blurfaces
"
LICENSE="
	AGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/asttokens-2.0.8[${PYTHON_USEDEP}]
		>=dev-python/backcall-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
		>=dev-python/decorator-5.1.1[${PYTHON_USEDEP}]
		>=dev-python/executing-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/face-recognition-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/face_recognition_models-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/ffmpeg-python-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-5.0.4[${PYTHON_USEDEP}]
		>=dev-python/future-0.18.3[${PYTHON_USEDEP}]
		>=dev-python/ipython-8.10.0[${PYTHON_USEDEP}]
		>=dev-python/jedi-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-inline-0.1.6[${PYTHON_USEDEP}]
		>=dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.3[${PYTHON_USEDEP}]
		>=dev-python/parso-0.8.3[${PYTHON_USEDEP}]
		>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/pickleshare-0.7.5[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.31[${PYTHON_USEDEP}]
		>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pure-eval-0.2.2[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.15.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/stack-data-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66.3[${PYTHON_USEDEP}]
		>=dev-python/traitlets-5.4.0[${PYTHON_USEDEP}]
		>=dev-python/wcwidth-0.2.5[${PYTHON_USEDEP}]
		>=sci-libs/dlib-19.24.0[${PYTHON_USEDEP}]
		>=virtual/pillow-10.3.0[${PYTHON_USEDEP}]
		media-video/ffmpeg[encode]
	')
	>=media-libs/opencv-4.8.1.78[${PYTHON_SINGLE_USEDEP},ffmpeg,imgproc,python]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	sed -i -e "1i #!/usr/bin/env python3" blur_faces.py || die
}

src_install() {
	einstalldocs
	docinto "licenses"
	dodoc "LICENSE"
	python_foreach_impl python_newscript "blur_faces.py" "blur_faces"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (build date 20240922 a2f2a08, test date 20241219)
# opencv ffmpeg backend:  pass
# gaussian blur (default):  pass, but shows face on edge cases (requires manual frame cropping)
