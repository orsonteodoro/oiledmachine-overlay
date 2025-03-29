# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# nncf
# tensorflow-2.12 or lift version restriction
# monai
# paddlepaddle

MY_PV="$(ver_cut 1-2)-R$(ver_cut 4)"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_10" ) # Upstream list only 3.8

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/intel/openvino-ai-plugins-gimp.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	FALLBACK_COMMIT="6aa535ec6ef0cddbd964ac52921e98456fd1e17d" # Apr 24, 2024
	inherit git-r3
else
#	KEYWORDS="~amd64" # Missing dependencies
	SRC_URI="
https://github.com/intel/openvino-ai-plugins-gimp/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="GIMP AI plugins with OpenVINO Backend"
HOMEPAGE="https://github.com/intel/openvino-ai-plugins-gimp"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
STABLE_DIFFUSION_MODEL_RDEPEND="
	$(python_gen_any_dep '
		>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/torchmetrics-0.11.0[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/torchvision-0.14.1[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/transformers-4.38.0[${PYTHON_SINGLE_USEDEP}]
		dev-python/pytorch-lightning[${PYTHON_SINGLE_USEDEP}]
	')
	(
		>=sci-ml/tensorflow-2.5[${PYTHON_USEDEP}]
		<sci-ml/tensorflow-2.12[${PYTHON_USEDEP}]
	)
	>=sci-libs/nncf-2.4.0[${PYTHON_USEDEP}]
	>=sci-ml/onnx-1.13.0[${PYTHON_USEDEP}]
	>=sci-ml/openvino-2022.2.0[${PYTHON_USEDEP}]
	>=sci-ml/tensorflow-datasets-4.2.0[${PYTHON_USEDEP}]

	(
		>=dev-python/matplotlib-3.4[${PYTHON_USEDEP}]
		<dev-python/matplotlib-3.5.3[${PYTHON_USEDEP}]
	)
	>=dev-python/librosa-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/pytube-12.1.0[${PYTHON_USEDEP}]
	>=dev-python/shapely-1.7.1[${PYTHON_USEDEP}]
	>=virtual/pillow-8.3.2[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},python]
	net-misc/gdown[${PYTHON_USEDEP}]


	>=sci-libs/paddlepaddle-2.4.0[${PYTHON_USEDEP}]
	>=sci-libs/paddle2onnx-0.6[${PYTHON_USEDEP}]
	>=sci-libs/paddlenlp-2.0.8[${PYTHON_USEDEP}]

	(
		>=dev-python/monai-0.9.1[${PYTHON_USEDEP}]
		<dev-python/monai-1.0.0[${PYTHON_USEDEP}]
	)
	>=sci-ml/safetensors-0.3.2[${PYTHON_USEDEP}]

	>=dev-python/jedi-0.17.2[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/rsa-4.7[${PYTHON_USEDEP}]
	>=dev-python/seaborn-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/scikit-image-0.19.2[${PYTHON_USEDEP}]

	>=dev-python/diffusers-0.9.0[${PYTHON_USEDEP}]
	>=sci-ml/huggingface_hub-0.9.1[${PYTHON_USEDEP}]

	>=dev-python/diffusers-0.23.0[${PYTHON_USEDEP}]
	>=sci-ml/huggingface_hub-0.9.1[${PYTHON_USEDEP}]

	>=dev-python/controlnet-aux-0.0.6[${PYTHON_USEDEP}]
"
PLUGIN_RDEPEND="
	$(python_gen_any_dep '
		>=sci-ml/transformers-4.38.0[${PYTHON_SINGLE_USEDEP}]
	')
	>=dev-python/controlnet-aux-0.0.6[${PYTHON_USEDEP}]
	>=dev-python/diffusers-0.22.0[${PYTHON_USEDEP}]
	>=dev-python/ftfy-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/streamlit-1.30.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.64.0[${PYTHON_USEDEP}]
	>=dev-python/watchdog-2.1.9[${PYTHON_USEDEP}]
	>=sci-ml/safetensors-0.4.1[${PYTHON_USEDEP}]
	dev-python/accelerate[${PYTHON_USEDEP}]
	sci-ml/huggingface_hub[${PYTHON_USEDEP}]
	sci-ml/openvino[${PYTHON_USEDEP}]
"
#	${STABLE_DIFFUSION_MODEL_RDEPEND}
RDEPEND+="
	$(python_gen_any_dep '
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
	')
	${PLUGIN_RDEPEND}
	>=dev-python/controlnet-aux-0.0.6[${PYTHON_USEDEP}]
	>=dev-python/timm-0.4.5[${PYTHON_USEDEP}]
	dev-python/diffusers[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/scikit-image[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},python]
	media-gfx/gimp:0/3
	net-misc/gdown[${PYTHON_USEDEP}]
	sci-ml/openvino[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-56.0.0[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.0.1\"" "${S}/gimpopenvino/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.md"
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
