# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ORB-HD/deface.git"
	FALLBACK_COMMIT="1e6a87fbf7dd92c16d36418ed019ea8781ca1d72" # Oct 15, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/ORB-HD/deface/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Video anonymization by face detection"
HOMEPAGE="
	https://github.com/ORB-HD/deface
	https://pypi.org/project/deface
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda dev ffmpeg gtk3 gstreamer openvino qt5 qt6 wayland"
REQUIRED_USE="
	^^ (
		gtk3
		qt5
		qt6
		wayland
	)
"
RDEPEND+="
	>=dev-python/imageio-2.25[${PYTHON_USEDEP}]
	>=dev-python/imageio-ffmpeg-0.4.6[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/scikit-image[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},contribdnn,ffmpeg?,gstreamer?,gtk3?,imgproc,python,qt5?,qt6?,wayland?]
	cuda? (
		$(python_gen_any_dep '
			sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python,cuda]
		')
		sci-ml/onnx[${PYTHON_USEDEP}]
	)
	openvino? (
		$(python_gen_any_dep '
			sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python,openvino]
		')
		sci-ml/onnx[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-67.6[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-7.1[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		dev-util/ruff
	)
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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
