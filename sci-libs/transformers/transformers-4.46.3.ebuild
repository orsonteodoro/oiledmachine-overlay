# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
#
# blobfile
# cookiecutter
# datasets
# deepspeed
# diffusers
# faiss-cpu
# fugashi
# dev-python/ipadic
# kenlm
# keras-nlp
# onnxconverter-common
# onnxruntime-tools
# optuna
# phonemizer
# pyctcdecode
# pytest-rich
# ray
# rjieba
# rhoknp
# rouge-score
# sagemaker
# sacrebleu
# sacremoses
# sigopt
# sudachipy
# sudachidict-core
# tensorboard
# tiktoken
# tf2onnx
# unidic-lite

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LANGS=(
	"ja"
)
PYTHON_COMPAT=( "python3_10" ) # Package lists up to 3.10 for this release.

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow"
HOMEPAGE="
	https://pypi.org/project/transformers/
	https://huggingface.co/
"
LICENSE="Apache-2.0"
RESTRICT="test" # Need some modules, not yet packaged
SLOT="0"
IUSE="
${LANGS[@]/#/l10n_}
accelerate agents audio av benchmark codecarbon deepspeed deepspeed-testing
dev-tensorflow dev-torch flax flax-speech ftfy integrations modelcreation natten
onnx onnxruntime optuna pillow pytorch quality ray retrieval ruff sentencepiece
serving sagemaker sigopt sklearn speech test tf tf-cpu tf-speech tiktoken timm
torch-speech torch-vision torchhub tokenizers vision
"
REQUIRED_USE="
	agents? (
		accelerate
		sentencepiece
		pillow
	)
	deepspeed? (
		accelerate
	)
	deepspeed-testing? (
		deepspeed
		optuna
		sentencepiece
		test
	)
	dev-tensorflow? (
		modelcreation
		onnx
		quality
		sentencepiece
		sklearn
		test
		tf
		tf-speech
		tokenizers
		vision
	)
	dev-torch? (
		codecarbon
		integrations
		l10n_ja
		modelcreation
		onnxruntime
		pytorch
		quality
		sentencepiece
		sklearn
		test
		timm
		tokenizers
		torch-speech
		torch-vision
		vision
	)
	flax-speech? (
		audio
	)
	integrations? (
		optuna
		ray
		sigopt
	)
	onnx? (
		onnxruntime
	)
	pytorch? (
		accelerate
	)
	quality? (
		ruff
	)
	speech? (
		audio
	)
	test? (
		ruff
		sentencepiece
		retrieval
		modelcreation
	)
	tf? (
		onnx
	)
	tf-cpu? (
		tf
	)
	tf-speech? (
		audio
	)
	torch-speech? (
		audio
	)
	torch-vision? (
		vision
	)
	torchhub? (
		sentencepiece
		tokenizers
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		!=dev-python/regex-2019.12.17[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.27[${PYTHON_USEDEP}]
		>=sci-libs/huggingface_hub-0.23.2[${PYTHON_USEDEP}]
		>=sci-libs/safetensors-0.4.1[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		audio? (
			>=dev-python/pyctcdecode-0.4.0[${PYTHON_USEDEP}]
			dev-python/kenlm[${PYTHON_USEDEP}]
			dev-python/librosa[${PYTHON_USEDEP}]
			dev-python/phonemizer[${PYTHON_USEDEP}]
		)
		agents? (
			dev-python/datasets[${PYTHON_USEDEP}]
			dev-python/diffusers[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP}]
		)
		av? (
			>=dev-python/av-9.2.0[${PYTHON_USEDEP}]
		)
		codecarbon? (
			>=dev-python/codecarbon-1.2.0[${PYTHON_USEDEP}]
		)
		deepspeed? (
			>=dev-python/deepspeed-0.9.3[${PYTHON_USEDEP}]
		)
		flax? (
			>=dev-python/flax-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/jax-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/jaxlib-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/optax-0.0.8[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		)
		ftfy? (
			dev-python/ftfy[${PYTHON_USEDEP}]
		)
		l10n_ja? (
			>=dev-python/fugashi-1.0[${PYTHON_USEDEP}]
			>=dev-python/ipadic-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/rhoknp-1.1.0[${PYTHON_USEDEP}]
			>=dev-python/sudachipy-0.6.6[${PYTHON_USEDEP}]
			>=dev-python/sudachidict-core-20220729[${PYTHON_USEDEP}]
			>=dev-python/unidic-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/unidic-lite-1.0.7[${PYTHON_USEDEP}]
		)
		modelcreation? (
			>=dev-python/cookiecutter-1.7.3[${PYTHON_USEDEP}]
		)
		natten? (
			>=dev-python/natten-0.14.6[${PYTHON_USEDEP}]
		)
		onnx? (
			dev-python/onnxconverter-common[${PYTHON_USEDEP}]
			dev-python/tf2onnx[${PYTHON_USEDEP}]
		)
		onnxruntime? (
			>=sci-libs/onnxruntime-1.4.0[${PYTHON_SINGLE_USEDEP},python]
			>=sci-misc/onnxruntime-tools-1.4.2[${PYTHON_USEDEP}]
		)
		optuna? (
			dev-python/optuna[${PYTHON_USEDEP}]
		)
		ray? (
			>=dev-python/ray-2.7.0[${PYTHON_USEDEP},tune]
		)
		retrieval? (
			dev-python/faiss-cpu[${PYTHON_USEDEP}]
			dev-python/datasets[${PYTHON_USEDEP}]
			!=dev-python/datasets-2.5.0[${PYTHON_USEDEP}]
		)
		sagemaker? (
			>=dev-python/sagemaker-2.31.0[${PYTHON_USEDEP}]
		)
		sentencepiece? (
			!=dev-python/sentencepiece-0.1.92[${PYTHON_USEDEP}]
			>=dev-python/sentencepiece-0.1.91[${PYTHON_USEDEP}]
			dev-python/protobuf[${PYTHON_USEDEP}]
		)
		serving? (
			dev-python/fastapi[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/starlette[${PYTHON_USEDEP}]
			dev-python/uvicorn[${PYTHON_USEDEP}]
		)
		sigopt? (
			dev-python/sigopt[${PYTHON_USEDEP}]
		)
		sklearn? (
			dev-python/scikit-learn[${PYTHON_USEDEP}]
		)
		tiktoken? (
			dev-python/blobfile[${PYTHON_USEDEP}]
			dev-python/tiktoken[${PYTHON_USEDEP}]
		)
		tf? (
			>=dev-python/keras-nlp-0.3.1[${PYTHON_USEDEP}]
			>=sci-libs/tensorflow-2.9[${PYTHON_USEDEP}]
			sci-libs/tensorflow-text[${PYTHON_USEDEP}]
		)
		tf-cpu? (
			>=dev-python/keras-2.9[${PYTHON_USEDEP}]
			dev-python/tensorflow-probability[${PYTHON_USEDEP}]
		)
		timm? (
			dev-python/timm[${PYTHON_USEDEP}]
		)
		torchhub? (
			dev-python/importlib-metadata[${PYTHON_USEDEP}]
			dev-python/protobuf[${PYTHON_USEDEP}]
		)
		vision? (
			virtual/pillow[${PYTHON_USEDEP}]
		)
	')
	agents? (
		sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
	accelerate? (
		>=dev-python/accelerate-0.26.0[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
	speech? (
		sci-libs/torchaudio[${PYTHON_SINGLE_USEDEP}]
	)
	torch-speech? (
		sci-libs/torchaudio[${PYTHON_SINGLE_USEDEP}]
	)
	torch-vision? (
		sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
	tokenizers? (
		=sci-libs/tokenizers-0.20*[${PYTHON_SINGLE_USEDEP}]
	)
	torchhub? (
		sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
BDEPEND="
	$(python_gen_cond_dep '
		benchmark? (
			>=dev-python/optimum-benchmark-0.3.0[${PYTHON_USEDEP}]
		)
		quality? (
			dev-python/datasets[${PYTHON_USEDEP}]
			dev-python/GitPython[${PYTHON_USEDEP}]
			>=dev-python/isort-5.5.4[${PYTHON_USEDEP}]
			dev-python/libcst[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
		)
		ruff? (
			>=dev-util/ruff-0.5.1
		)
		test? (
			!=dev-python/rouge-score-0.0.7[${PYTHON_USEDEP}]
			!=dev-python/rouge-score-0.0.8[${PYTHON_USEDEP}]
			!=dev-python/rouge-score-0.1[${PYTHON_USEDEP}]
			!=dev-python/rouge-score-0.1.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
			>=dev-python/sacrebleu-1.4.12[${PYTHON_USEDEP}]
			>=sci-libs/evaluate-0.2.0[${PYTHON_USEDEP}]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/datasets[${PYTHON_USEDEP}]
			dev-python/dill[${PYTHON_USEDEP}]
			dev-python/GitPython[${PYTHON_USEDEP}]
			dev-python/nltk[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pytest-rich[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/rjieba[${PYTHON_USEDEP}]
			dev-python/rouge-score[${PYTHON_USEDEP}]
			dev-python/sacremoses[${PYTHON_USEDEP}]
			dev-python/tensorboard[${PYTHON_USEDEP}]
			dev-python/timeout-decorator[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
		)
	')
"

distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	if has_version ">=dev-python/keras-3" ; then
ewarn "You must emerge dev-python/tf-keras"
	fi
}
