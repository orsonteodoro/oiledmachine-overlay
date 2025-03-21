# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# bert_score
# cachier
# dev-python/ipadic
# dython
# fairlearn
# fast-bss-eval
# faster-coco-eval
# gammatone
# kornia
# lai-sphinx-theme
# lpips
# mecab-ko
# mecab-ko-dic
# mecab-python3
# mir-eval
# monai
# netcal
# pesq
# phmdoctest
# piq
# pypesq
# pystoi
# pytorch-msssim
# rouge-score
# sacrebleu
# sewar
# speechmetrics
# sphinxcontrib-fulltoc
# sphinxcontrib-mockautodoc
# srmrpy
# torchaudio
# torch-fidelity
# torch_complex

if [[ "${PV}" =~ "_p" ]] ; then
	MY_PV="$(ver_cut 1-3 ${PV}).post$(ver_cut 5 ${PV})"
else
	MY_PV="${PV}"
fi

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Lightning-AI/torchmetrics.git"
	FALLBACK_COMMIT="3f112395b1ca0141ad2d8622628110fa363f9953" # May 15, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="
https://github.com/Lightning-AI/torchmetrics/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="PyTorch native Metrics"
HOMEPAGE="
	https://github.com/Lightning-AI/torchmetrics
	https://pypi.org/project/torchmetrics
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" audio debug detection doc image multimodal text -strict test visual"
AUDIO_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/pystoi-0.3.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pystoi-0.5.0[${PYTHON_USEDEP}]
			)
		)
		=dev-python/gammatone-9999[${PYTHON_USEDEP}]
		dev-python/pesq[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/torchaudio-0.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchaudio-2.4.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
DEBUG_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/pretty-errors-1.2.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pretty-errors-1.3.0[${PYTHON_USEDEP}]
			)
		)
	')
"
DETECTION_RDEPEND="
	$(python_gen_cond_dep '
		(
			>dev-python/pycocotools-2.0.0[${PYTHON_USEDEP}]
			strict? (
				>=dev-python/pycocotools-2.0.8[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>=sci-ml/torchvision-0.8[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchvision-0.19.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
IMAGE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scipy-1.11.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			sci-libs/torch-fidelity[${PYTHON_USEDEP}]
		)
		strict? (
			<sci-libs/torch-fidelity-0.4.1[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-ml/torchvision-0.8[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchvision-0.19.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
MULTIMODAL_RDEPEND="
	$(python_gen_cond_dep '
		!strict? (
			dev-python/piq[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/piq-0.8.1[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-ml/transformers-4.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/transformers-4.41.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
TEXT_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/ipadic-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/ipadic-1.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/mecab-python3-1.0.6[${PYTHON_USEDEP}]
			strict? (
				<dev-python/mecab-python3-1.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/nltk-3.6[${PYTHON_USEDEP}]
			strict? (
				<dev-python/nltk-3.8.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/regex-2021.9.24[${PYTHON_USEDEP}]
			strict? (
				<dev-python/regex-2024.5.11[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sentencepiece-0.2.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sentencepiece-0.3.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/tqdm-4.41.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/tqdm-4.67.0[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>sci-ml/transformers-4.4.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/transformers-4.41.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
VISUAL_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/matplotlib-3.3.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/matplotlib-3.9.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/SciencePlots-2.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/SciencePlots-2.2.0[${PYTHON_USEDEP}]
			)
		)
	')
"
BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
			)
		)
		>dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
		!strict? (
			dev-python/packaging[${PYTHON_USEDEP}]
		)
		strict? (
			>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-ml/pytorch-1.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
RDEPEND+="
	${BASE_RDEPEND}
	audio? (
		${AUDIO_RDEPEND}
	)
	debug? (
		${DEBUG_RDEPEND}
	)
	detection? (
		${DETECTION_RDEPEND}
	)
	image? (
		${IMAGE_RDEPEND}
	)
	multimodal? (
		${MULTIMODAL_RDEPEND}
	)
	test? (
		${TEXT_RDEPEND}
	)
	visual? (
		${VISUAL_RDEPEND}
	)
"
DEPEND+="
	${RDEPEND}
"
AUDIO_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/fast-bss-eval-0.1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/fast-bss-eval-0.1.5[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/mir-eval-0.6[${PYTHON_USEDEP}]
			strict? (
				<dev-python/mir-eval-0.7.1[${PYTHON_USEDEP}]
			)
		)
		dev-python/pypesq[${PYTHON_USEDEP}]
		dev-python/speechmetrics[${PYTHON_USEDEP}]
		dev-python/srmrpy[${PYTHON_USEDEP}]
	')
	!strict? (
		sci-libs/torch_complex[${PYTHON_SINGLE_USEDEP}]
	)
	strict? (
		<sci-libs/torch_complex-0.4.4[${PYTHON_SINGLE_USEDEP}]
	)
"
CLASSIFICATION_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/netcal-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/netcal-1.3.6[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pandas-1.4.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandas-2.0.4[${PYTHON_USEDEP}]
			)
		)
		dev-python/fairlearn[${PYTHON_USEDEP}]
		!strict? (
			dev-python/numpy[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/numpy-1.27.0[${PYTHON_USEDEP}]
		)
	')
"
DOCS_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/lightning-1.8.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/lightning-2.3.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pydantic-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
			)
		)
		>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/nbsphinx-0.9.3[${PYTHON_USEDEP}]
		>=dev-python/pandoc-2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.3.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.23.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-paramlinks-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-togglebutton-0.3.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-fulltoc-1.0[${PYTHON_USEDEP}]
		>=dev-python/lightning-utilities-0.11.2[${PYTHON_USEDEP}]
		dev-python/lai-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-mockautodoc[${PYTHON_USEDEP}]
	')
"
DOCS_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/pytest-8.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pytest-9.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pytest-doctestplus-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pytest-doctestplus-1.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pytest-rerunfailures-13.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pytest-rerunfailures-5.0[${PYTHON_USEDEP}]
			)
		)
	')
"
DEBUG_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/pretty-errors-1.2.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pretty-errors-1.3.0[${PYTHON_USEDEP}]
			)
		)
	')
"
DETECTION_TEST_BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/faster-coco-eval-1.3.3[${PYTHON_USEDEP}]
	')
"
IMAGE_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/kornia-0.6.7[${PYTHON_USEDEP}]
			strict? (
				<dev-python/kornia-0.8.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/scikit-image-0.19.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scikit-image-0.23.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sewar-0.4.4[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sewar-0.4.7[${PYTHON_USEDEP}]
			)
		)
		=sci-libs/torch-fidelity-9999[${PYTHON_USEDEP}]
		!strict? (
			dev-python/lpips[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			sci-libs/pytorch-msssim[${PYTHON_SINGLE_USEDEP}]
		)
		strict? (
			<dev-python/lpips-0.1.5[${PYTHON_USEDEP}]
			<dev-python/numpy-1.27.0[${PYTHON_USEDEP}]
			>=sci-libs/pytorch-msssim-1.0.0[${PYTHON_SINGLE_USEDEP}]
		)
	')
"
NOMINAL_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/pandas-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandas-2.0.4[${PYTHON_USEDEP}]
			)
		)
		(
			=dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scipy-1.11.0[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/statsmodels-0.13.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/statsmodels-0.15.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			dev-python/dython[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/dython-0.7.6[${PYTHON_USEDEP}]
		)
	')
"
SEGMENTATION_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scipy-1.11.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			dev-python/monai[${PYTHON_USEDEP}]
		)
		strict? (
			>=dev-python/monai-1.3.0[${PYTHON_USEDEP}]
		)
	')
"
TESTS_BDEPEND="
	$(python_gen_cond_dep '
		(
			>dev-python/cloudpickle-1.3[${PYTHON_USEDEP}]
			strict? (
				<dev-python/cloudpickle-3.0.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/scikit-learn-1.4.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scikit-learn-1.5.0[${PYTHON_USEDEP}]
			)
		)
		>=dev-python/cachier-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.5.1[${PYTHON_USEDEP}]
		>=dev-python/phmdoctest-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/PyGithub-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-doctestplus-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
		!strict? (
			dev-python/fire[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/fire-0.6.1[${PYTHON_USEDEP}]
			<dev-python/psutil-5.10.0[${PYTHON_USEDEP}]
		)
	')
"
TEXT_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/bert_score-0.3.13[${PYTHON_USEDEP}]
			strict? (
				>=dev-python/bert_score-0.3.13[${PYTHON_USEDEP}]
			)
		)
		(
			>=sci-ml/jiwer-2.3.0[${PYTHON_USEDEP}]
			strict? (
				<sci-ml/jiwer-3.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/mecab-ko-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/mecab-ko-1.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/mecab-ko-dic-1.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/mecab-ko-dic-1.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/rouge-score-0.1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/rouge-score-0.1.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sacrebleu-2.3.0[${PYTHON_USEDEP}]
			strict? (
				>=dev-python/sacrebleu-2.5.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			sci-ml/huggingface_hub[${PYTHON_USEDEP}]
		)
		strict? (
			<sci-ml/huggingface_hub-0.23[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	doc? (
		${DOCS_BDEPEND}
	)
	test? (
		${CLASSIFICATION_TEST_BDEPEND}
		${NOMINAL_TEST_BDEPEND}
		${SEGMENTATION_TEST_BDEPEND}
		audio? (
			${AUDIO_TEST_BDEPEND}
		)
		debug? (
			${DEBUG_BDEPEND}
		)
		detection? (
			${DETECTION_TEST_BDEPEND}
		)
		doc? (
			${DOCS_TEST_BDEPEND}
		)
		image? (
			${IMAGE_TEST_BDEPEND}
		)
		text? (
			${TEXT_TEST_BDEPEND}
		)
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"1.4.0.post0\"" "${S}/src/torchmetrics/__about__.py" \
			|| die "QA:  Bump version"
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
