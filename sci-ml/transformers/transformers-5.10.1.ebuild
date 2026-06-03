# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
#
# blobfile
# datasets
# deepspeed
# faiss-cpu
# fugashi
# dev-python/ipadic
# kenlm
# keras-nlp
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
# sudachipy
# sudachidict-core
# tensorboard
# tiktoken
# unidic-lite

CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LANGS=(
	"ja"
)
PYTHON_COMPAT=( "python3_"{10,11} ) # Package lists up to 3.10 for this release.  Relax for open-webui

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="The model-definition framework for state-of-the-art machine learning models in text, vision, audio, and multimodal models, for both inference and training"
HOMEPAGE="
	https://pypi.org/project/transformers/
	https://huggingface.co/
"
LICENSE="Apache-2.0"
RESTRICT="test" # Need some modules, not yet packaged
SLOT="0"
IUSE="
${LANGS[@]/#/l10n_}
accelerate agents all audio av benchmark chat_template codecarbon deepspeed
deepspeed-testing doc integrations kernels mistral-common natten num2words
optuna pillow torch quality ray retrieval sentencepiece serving sagemaker
sklearn test tiktoken timm torchhub tokenizers video vision
ebuild_revision_9
"
REQUIRED_USE="
	all? (
		audio
		chat_template
		kernels
		mistral-common
		num2words
		sentencepiece
		tiktoken
		timm
		torch
		video
		vision
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
	integrations? (
		codecarbon
		kernels
		optuna
		ray
	)
	torch? (
		accelerate
	)
	serving? (
		torch
	)
	test? (
		mistral-common
		sentencepiece
		retrieval
	)
	video? (
		av
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/regex-2025.10.22[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.27[${PYTHON_USEDEP}]
		>=sci-ml/safetensors-0.4.3[${PYTHON_USEDEP}]
		dev-python/typer[${PYTHON_USEDEP}]

		audio? (
			>=dev-python/pyctcdecode-0.4.0[${PYTHON_USEDEP}]
			dev-python/librosa[${PYTHON_USEDEP}]
			dev-python/phonemizer[${PYTHON_USEDEP}]
		)
		chat_template? (
			>=dev-python/jinja2-3.1.0[${PYTHON_USEDEP}]
			>=dev-python/jmespath-1.0.1[${PYTHON_USEDEP}]
		)
		codecarbon? (
			>=dev-python/codecarbon-2.8.1[${PYTHON_USEDEP}]
		)
		deepspeed? (
			>=dev-python/deepspeed-0.9.3[${PYTHON_USEDEP}]
		)
		kernels? (
			>=dev-python/kernels-0.12.0[${PYTHON_USEDEP}]
			<dev-python/kernels-0.13[${PYTHON_USEDEP}]
		)
		l10n_ja? (
			>=dev-python/fugashi-1.0[${PYTHON_USEDEP}]

			>=dev-python/ipadic-1.0.0[${PYTHON_USEDEP}]
			<dev-python/ipadic-2.0[${PYTHON_USEDEP}]

			>=dev-python/rhoknp-1.1.0[${PYTHON_USEDEP}]
			<dev-python/rhoknp-1.3.1[${PYTHON_USEDEP}]

			>=dev-python/unidic-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/unidic-lite-1.0.7[${PYTHON_USEDEP}]
		)
		mistral-common? (
			>=dev-python/mistral-common-1.10.0[image]
		)
		num2words? (
			dev-python/num2words[${PYTHON_USEDEP}]
		)
		optuna? (
			dev-python/optuna[${PYTHON_USEDEP}]
		)
		ray? (
			>=dev-python/ray-2.7.0[${PYTHON_USEDEP},tune]
		)
		retrieval? (
			>=dev-python/datasets-2.15.0[${PYTHON_USEDEP}]
			<dev-python/pandas-2.3.0[${PYTHON_USEDEP}]
			dev-python/faiss-cpu[${PYTHON_USEDEP}]
		)
		sagemaker? (
			>=dev-python/sagemaker-2.31.0[${PYTHON_USEDEP}]
		)
		sentencepiece? (
			!~sci-ml/sentencepiece-0.1.92[${PYTHON_USEDEP}]
			>=sci-ml/sentencepiece-0.1.91[${PYTHON_USEDEP}]

			dev-python/protobuf[${PYTHON_USEDEP}]
			dev-python/protobuf:=
		)
		serving? (
			dev-python/fastapi[${PYTHON_USEDEP}]
			>=dev-python/openai-1.98.0[${PYTHON_USEDEP}]
			>=dev-python/pydantic-2[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/starlette[${PYTHON_USEDEP}]
			dev-python/uvicorn[${PYTHON_USEDEP}]
		)
		sklearn? (
			dev-python/scikit-learn[${PYTHON_USEDEP}]
		)
		tiktoken? (
			dev-python/blobfile[${PYTHON_USEDEP}]
			dev-python/tiktoken[${PYTHON_USEDEP}]
		)
		vision? (
			>=virtual/pillow-10.0.1[${PYTHON_USEDEP}]
			<virtual/pillow-15.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/huggingface-hub-1.5.0[${PYTHON_SINGLE_USEDEP}]
	<dev-python/huggingface-hub-2.0[${PYTHON_SINGLE_USEDEP}]
	=sci-ml/tokenizers-0.22*[${PYTHON_SINGLE_USEDEP}]
	sci-ml/tokenizers:=
	accelerate? (
		>=sci-ml/accelerate-1.1.0[${PYTHON_SINGLE_USEDEP}]
	)
	audio? (
		sci-ml/torchaudio[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/kenlm[${PYTHON_SINGLE_USEDEP}]
		' python3_{10..12})
	)
	av? (
		dev-python/av[${PYTHON_SINGLE_USEDEP}]
	)
	torch? (
		>=sci-ml/pytorch-2.4[${PYTHON_SINGLE_USEDEP}]
	)
	l10n_ja? (
		$(python_gen_cond_dep '
			>=dev-python/sudachipy-0.6.6[${PYTHON_USEDEP}]
			>=dev-python/sudachidict-core-20220729[${PYTHON_USEDEP}]
		' python3_{10..13})
	)
	timm? (
		>dev-python/timm-1.0.23[${PYTHON_SINGLE_USEDEP}]
	)
	vision? (
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
"
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/schedulefree-1.2.6[${PYTHON_USEDEP}]
		dev-python/peft[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		benchmark? (
			>=dev-python/optimum-benchmark-0.3.0[${PYTHON_USEDEP}]
		)
		doc? (
			dev-python/hf-doc-builder[${PYTHON_USEDEP}]
		)
		quality? (
			>=dev-python/datasets-2.15.0[${PYTHON_USEDEP}]
			<dev-python/pandas-2.3.0[${PYTHON_USEDEP}]
			<dev-python/GitPython-3.1.19[${PYTHON_USEDEP}]
			dev-python/libcst[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			<dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/ty-0.0.20[${PYTHON_USEDEP}]
			dev-python/tomli[${PYTHON_USEDEP}]
			>=dev-ptyhon/transformers-mlinter-0.1.1[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.14.10
		)
		test? (
			!~dev-python/rouge-score-0.0.7[${PYTHON_USEDEP}]
			!~dev-python/rouge-score-0.0.8[${PYTHON_USEDEP}]
			!~dev-python/rouge-score-0.1[${PYTHON_USEDEP}]
			!~dev-python/rouge-score-0.1.1[${PYTHON_USEDEP}]
			dev-python/rouge-score[${PYTHON_USEDEP}]

			>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
			<dev-python/pytest-9.0.0[${PYTHON_USEDEP}]

			>=dev-python/sacrebleu-1.4.12[${PYTHON_USEDEP}]
			<dev-python/sacrebleu-2.0.0[${PYTHON_USEDEP}]

			>=sci-ml/evaluate-0.4.6[${PYTHON_USEDEP}]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			<dev-python/dill-0.3.5[${PYTHON_USEDEP}]
			<dev-python/nltk-3.8.2[${PYTHON_USEDEP}]
			dev-python/filelock[${PYTHON_USEDEP}]
			>=dev-python/parameterized-0.9[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-1.2.0[${PYTHON_USEDEP}]
			dev-python/pytest-random-order[${PYTHON_USEDEP}]
			<dev-python/pytest-rerunfailures-16.0[${PYTHON_USEDEP}]
			dev-python/pytest-env[${PYTHON_USEDEP}]
			dev-python/pytest-order[${PYTHON_USEDEP}]
			dev-python/pytest-rich[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/rjieba[${PYTHON_USEDEP}]
			dev-python/sacremoses[${PYTHON_USEDEP}]
			dev-python/tensorboard[${PYTHON_USEDEP}]
			dev-python/timeout-decorator[${PYTHON_USEDEP}]
		)
	')
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
"

distutils_enable_tests "pytest"

pkg_setup() {
	python-single-r1_pkg_setup
}
