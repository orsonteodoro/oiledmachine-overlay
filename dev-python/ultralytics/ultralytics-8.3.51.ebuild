# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# albumentations
# comet
# coremltools
# dvclive
# hub-sdk
# mkdocs-macros-plugin
# mkdocs-ultralytics-plugin
# tensorflowjs
# ultralytics-thop

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ultralytics/ultralytics.git"
	FALLBACK_COMMIT="31aaf0e057450ea0bf42426e9e9e2d0b2b5f0a32" # Dec 17, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/ultralytics/ultralytics/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Ultralytics YOLO 🚀 for SOTA object detection, multi-object tracking, instance segmentation, pose estimation and image classification"
HOMEPAGE="
	https://ultralytics.com
	https://github.com/ultralytics/ultralytics
	https://pypi.org/project/ultralytics
"
LICENSE="
	AGPL-3
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev export extra logging solutions test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/matplotlib-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.1.4[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.64.0[${PYTHON_USEDEP}]
		>=virtual/pillow-7.1.2[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
	')
	>=dev-python/ultralytics-thop-2.0.0[${PYTHON_SINGLE_USEDEP}]
	>=media-libs/opencv-4.6.0[${PYTHON_SINGLE_USEDEP},python]
	>=sci-ml/pytorch-1.8.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/torchvision-0.9.0[${PYTHON_SINGLE_USEDEP}]
	export? (
		$(python_gen_cond_dep '
			>=dev-python/coremltools-7.0[${PYTHON_USEDEP}]
			>=dev-python/scikit-learn-1.3.2[${PYTHON_USEDEP}]
		' python3_{10..11})
		$(python_gen_cond_dep '
			amd64? (
				>=dev-python/tensorstore-0.1.63[${PYTHON_USEDEP}]
			)
		')
		$(python_gen_cond_dep '
			>=dev-python/onnx-1.12.0[${PYTHON_USEDEP}]
			>=dev-python/openvino-2024.0.0[${PYTHON_USEDEP}]
			>=dev-python/tensorflowjs-3.9.0[${PYTHON_USEDEP}]
			arm64? (
				(
					>=dev-libs/flatbuffers-23.5.26
					<dev-libs/flatbuffers-100
				)
				!=dev-python/h5py-3.11.0[${PYTHON_USEDEP}]
				>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
			)
		')
		>=sci-ml/tensorflow-2.0.0[${PYTHON_SINGLE_USEDEP}]
		dev-python/keras[${PYTHON_SINGLE_USEDEP}]
	)
	logging? (
		$(python_gen_cond_dep '
			>=dev-python/dvclive-2.12.0[${PYTHON_USEDEP}]
			dev-python/comet[${PYTHON_USEDEP}]
		')
		>=dev-python/tensorboard-2.13.0[${PYTHON_SINGLE_USEDEP}]
	)
	solutions? (
		$(python_gen_cond_dep '
			>=dev-python/shapely-2.0.0[${PYTHON_USEDEP}]
			dev-python/streamlit[${PYTHON_USEDEP}]
		')
	)
	extra? (
		$(python_gen_cond_dep '
			>=dev-python/hub-sdk-0.0.12[${PYTHON_USEDEP}]
			>=dev-python/albumentations-1.4.6[${PYTHON_USEDEP}]
			>=dev-python/pycocotools-2.0.7[${PYTHON_USEDEP}]
			dev-python/ipython[${PYTHON_USEDEP}]
		')
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-70.0.0[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/mkdocs-1.6.0[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-macros-plugin-1.0.5[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-material-9.5.9[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-ultralytics-plugin-0.1.8[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP},toml]
			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/mkdocstrings[${PYTHON_USEDEP},python]
			dev-python/mkdocs-jupyter[${PYTHON_USEDEP}]
			dev-python/mkdocs-redirects[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" "README.zh-CN.md" )

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
	rm -rf "${ED}/usr/lib/python3.10/site-packages/tests"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
