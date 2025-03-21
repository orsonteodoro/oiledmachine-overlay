# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO package:
# auto-round
# tensorflow-addons
# tf2onnx from tensorflow-onnx?
# tf-slim
# intel-extension-for-pytorch
# intel-tensorflow
# mxnet-mkl
# sphinx-md
# optimum
# peft
# onnxruntime-extensions

# TODO cat rename:
# dev-python/accelerate to sci-libs/accelerate

# For versioning see also
# https://github.com/intel/neural-compressor/blob/v2.6.1/.azure-pipelines/scripts/fwk_version.sh

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # U22 uses 3.10 but PyTorch is 3.12 inclusive.

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/intel/neural-compressor/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="State of the art low-bit LLM quantization (INT8/FP8/INT4/FP4/NF4) & sparsity; \
leading model compression techniques on TensorFlow, PyTorch, and ONNX Runtime"
HOMEPAGE="
https://intel.github.io/neural-compressor/
https://github.com/intel/neural-compressor
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	Apache-2.0
	BSD
	GPL-3
	MIT
"
# BSD - neural-compressor-2.6.1/neural_coder/extensions/neural_compressor_ext_lab/LICENSE
# MIT - neural-compressor-2.6.1/neural_insights/web/app/static/js/main.b053b871.js.LICENSE.txt
# Apache-2.0 - neural-compressor-2.6.1/LICENSE
# (all rights reserved Apache) MIT - neural-compressor-2.6.1/examples/pytorch/object_detection/maskrcnn/quantization/ptq/fx/pytorch/LICENSE
# GPL-3 - neural-compressor-2.6.1/examples/pytorch/object_detection/yolo_v3/quantization/ptq_static/fx/LICENSE
# The distro's Apache-2.0 license template does not contain all rights reserved.
SLOT="0"
IUSE="doc ipex mxnet ort pytorch tensorflow test"
REQUIRED_USE="
	ipex? (
		pytorch
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/deprecated-1.2.13[${PYTHON_USEDEP}]
		<dev-python/numpy-2.0[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/prettytable[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
		dev-python/pycocotools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/schema[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},python]
		virtual/pillow[${PYTHON_USEDEP}]
		mxnet? (
			>=sci-libs/mxnet-1.9.1[${PYTHON_USEDEP}]
		)
		ort? (
			>=sci-ml/onnx-1.15.0[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/onnxruntime-extensions[${PYTHON_USEDEP}]
		)
		pytorch? (
			>=dev-python/peft-0.10.0[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
		)
		tensorflow? (
			>=sci-libs/tensorflow-2.15.0[${PYTHON_USEDEP}]
			dev-python/prettytable[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
		)
	')
	ipex? (
		>sci-libs/intel-extension-for-pytorch-1.10[${PYTHON_SINGLE_USEDEP}]
	)
	ort? (
		>=sci-ml/onnxruntime-1.17.1[${PYTHON_SINGLE_USEDEP},extensions,python,training-ort]
		>=sci-ml/transformers-4.34.0[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		>=sci-ml/pytorch-2.2.1[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=sci-ml/transformers-4.30.2[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		doc? (
			>=dev-python/sphinx-6.1.1[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx-autoapi[${PYTHON_USEDEP}]
			dev-python/sphinx-markdown-tables[${PYTHON_USEDEP}]
			dev-python/sphinx-md[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/accelerate-0.21.0[${PYTHON_USEDEP}]
			>=sci-libs/dynast-1.6.0_rc1[${PYTHON_USEDEP}]
			>=sci-libs/intel-tensorflow-2.12.0[${PYTHON_USEDEP}]
			>=sci-ml/onnx-1.15.0[${PYTHON_USEDEP}]
			sci-libs/auto-round[${PYTHON_USEDEP}]
			sci-libs/horovod[${PYTHON_USEDEP}]
			sci-libs/mxnet-mkl[${PYTHON_USEDEP}]
			sci-libs/optimum[${PYTHON_USEDEP}]
			sci-libs/peft[${PYTHON_USEDEP}]
			sci-libs/tensorflow-addons[${PYTHON_USEDEP}]
			sci-libs/tf2onnx[${PYTHON_USEDEP}]
			sci-libs/tf-slim[${PYTHON_USEDEP}]
			dev-python/xgboost[${PYTHON_USEDEP}]

			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/black[${PYTHON_USEDEP}]
			dev-util/codespell[${PYTHON_USEDEP}]
			dev-util/ruff

		)
	')
	$(python_gen_cond_dep '
		test? (
			dev-python/onnxruntime-extensions[${PYTHON_USEDEP}]
		)
	' python3_10)
	test? (
		>=sci-libs/intel-extension-for-pytorch-1.10[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/onnxruntime-1.17.1[${PYTHON_SINGLE_USEDEP},python]
		>=sci-ml/torchvision-0.17.1[${PYTHON_SINGLE_USEDEP}]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
