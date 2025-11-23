# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# bangla
# bnnumerizer
# bnunicodenormalizer
# hangul_romanize
# jamo
# g2pkk
# mecab-python3
# unidic-lite
# cutlet
# umap-learn

MY_PN="coqui-ai-TTS"

CYTHON_SLOT="3.0"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
LANGS=(
	"bn"
	"ko"
	"ja"
	"zh"
)

inherit cython distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/idiap/coqui-ai-TTS/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🐸💬 - a deep learning toolkit for Text-to-Speech, battle-tested in research and production"
HOMEPAGE="
	https://github.com/idiap/coqui-ai-TTS
	https://pypi.org/project/coqui-tts
"
LICENSE="
	MPL-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LANGS[@]/#/l10n_}
-cors dev doc notebooks server
ebuild_revision_7
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/anyascii-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/coqpit-0.0.16[${PYTHON_USEDEP}]
		=dev-python/cython-3*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/einops-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/fsspec-2023.6.0[${PYTHON_USEDEP},http(+)]
		>=dev-python/gruut-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/inflect-5.6.0[${PYTHON_USEDEP}]
		>=dev-python/librosa-0.10.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/num2words-0.5.11[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.25.2[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.11.2[${PYTHON_USEDEP}]
		>=dev-python/soundfile-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
		cors? (
			dev-python/flask-cors[${PYTHON_USEDEP}]
		)
		l10n_bn? (
			>=dev-python/bangla-0.0.2[${PYTHON_USEDEP}]
			>=dev-python/bnnumerizer-0.0.2[${PYTHON_USEDEP}]
			>=dev-python/bnunicodenormalizer-0.1.0[${PYTHON_USEDEP}]
		)
		l10n_ko? (
			>=dev-python/hangul_romanize-0.1.0[${PYTHON_USEDEP}]
			>=dev-python/jamo-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/g2pkk-0.1.1[${PYTHON_USEDEP}]
		)
		l10n_ja? (
			>=dev-python/mecab-python3-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/unidic-lite-1.0.8[${PYTHON_USEDEP}]
			>=dev-python/cutlet-0.2.0[${PYTHON_USEDEP}]
		)
		l10n_zh? (
			>=dev-python/jieba-0.42.1[${PYTHON_USEDEP}]
			>=dev-python/pypinyin-0.40.0[${PYTHON_USEDEP}]
		)
		notebooks? (
			>=dev-python/bokeh-1.4.0[${PYTHON_USEDEP}]
			>=dev-python/pandas-1.4[${PYTHON_USEDEP}]
			>=dev-python/umap-learn-0.5.1[${PYTHON_USEDEP}]
		)
		server? (
			>=dev-python/flask-3.0.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/coqui-tts-trainer-0.1.4[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/encodec-0.1.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/pysbd-0.3.4[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/spacy-3[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/pytorch-2.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/transformers-4.42.0[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchaudio[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		=dev-python/cython-3*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/numpy-1.25.2[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/black-24.2.0[${PYTHON_USEDEP}]
			>=dev-python/coverage-7[${PYTHON_USEDEP},toml(+)]
			>=dev-python/nose2-0.15[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.4.9
		)
		doc? (
			>=dev-python/furo-2023.5.20[${PYTHON_USEDEP}]
			>=dev-python/myst-parser-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-7.2.5[${PYTHON_USEDEP}]
			>=dev-python/sphinx-inline-tabs-2023.4.21[${PYTHON_USEDEP}]
			>=dev-python/sphinx-copybutton-0.1[${PYTHON_USEDEP}]
			>=dev-python/linkify-it-py-2.0.0[${PYTHON_USEDEP}]
		)
	')
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/tomli-2[${PYTHON_USEDEP}]
		)
	' python3_{10..11})
	>=dev-vcs/pre-commit-3[${PYTHON_SINGLE_USEDEP}]
"
DOCS=( "README.md" )

python_prepare_all() {
	distutils-r1_python_prepare_all
	if use cors ; then
		eapply "${FILESDIR}/${PN}-0.24.2-cors.patch"
	fi
}

python_configure() {
	cython_set_cython_slot "3"
	cython_python_configure
}

pkg_postinst() {
einfo
einfo "You may need to download the default models first.  It can be with the"
einfo "following command:"
einfo
einfo "Do \`tts --text \"Text for TTS\" --pipe_out  | aplay\`"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (0.24.2, 20241122)
# Command line text to wavfile - passed
