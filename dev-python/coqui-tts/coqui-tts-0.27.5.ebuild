# Copyright 2024-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

MY_PN="coqui-ai-TTS"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..14} )
LANGS=(
	"bn"
	"ja"
	"ko"
	"zh"
)

inherit distutils-r1

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
all cpu cuda codec codec-cuda -cors dev doc notebooks server languages

ebuild_revision_8
"
REQUIRED_USE="
	all? (
		notebooks
		server
		languages
	)
	languages? (
		${LANGS[@]/#/l10n_}
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		virtual/numpy[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.13.0[${PYTHON_USEDEP}]
		>=dev-python/soundfile-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/librosa-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/numba-0.58.0[${PYTHON_USEDEP}]
		>=dev-python/inflect-5.6.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
		>=dev-python/anyascii-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/fsspec-2023.6.0[${PYTHON_USEDEP},http(+)]
		>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.8.4[${PYTHON_USEDEP}]

		>=dev-python/coqpit-config-0.2.0[${PYTHON_USEDEP}]
		<dev-python/coqpit-config-0.3.0[${PYTHON_USEDEP}]

		>=dev-python/monotonic-alignment-search-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/ko-speech-tools-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/einops-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/num2words-0.5.14[${PYTHON_USEDEP}]

		notebooks? (
			>=dev-python/bokeh-3.0.3[${PYTHON_USEDEP}]

			>=dev-python/pandas-1.4[${PYTHON_USEDEP}]
			<dev-python/pandas-3.0[${PYTHON_USEDEP}]

			>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP},notebook]
			>=dev-python/umap-learn-0.5.1[${PYTHON_USEDEP}]
		)
		server? (
			>=dev-python/flask-3.0.0[${PYTHON_USEDEP}]
		)
		l10n_bn? (
			>=dev-python/bangla-0.0.2[${PYTHON_USEDEP}]
			>=dev-python/bnnumerizer-0.0.2[${PYTHON_USEDEP}]
			>=dev-python/bnunicodenormalizer-0.1.0[${PYTHON_USEDEP}]
		)
		l10n_ja? (
			>=dev-python/cutlet-0.2.0[${PYTHON_USEDEP}]
			>=dev-python/fugashi-1.3.0[${PYTHON_USEDEP},unidic-lite]
		)
		l10n_zh? (
			>=dev-python/spacy-pkuseg-1.0.1[${PYTHON_USEDEP}]
			>=dev-python/pypinyin-0.40.0[${PYTHON_USEDEP}]
		)
		languages? (
			>=dev-python/gruut-2.4.0[${PYTHON_USEDEP},l10n_de,l10n_es,l10n_fr]
			>=dev-python/uroman-1.3.1.1[${PYTHON_USEDEP}]
		)
	')


	>=dev-python/coqui-tts-trainer-0.3.0[${PYTHON_SINGLE_USEDEP}]
	<dev-python/coqui-tts-trainer-0.4.0[${PYTHON_SINGLE_USEDEP}]

	>=dev-python/pysbd-0.3.4[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/transformers-4.57[${PYTHON_SINGLE_USEDEP}]

	cpu? (
		>=dev-python/pytorch-2.2[${PYTHON_SINGLE_USEDEP},cpu]
		>=dev-python/torchaudio-2.2.0[${PYTHON_SINGLE_USEDEP}]
	)
	cuda? (
		>=dev-python/pytorch-2.2[${PYTHON_SINGLE_USEDEP},cuda]
		>=dev-python/torchaudio-2.2.0[${PYTHON_SINGLE_USEDEP}]
	)
	codec? (
		>=dev-python/torchcodec-0.8.0[${PYTHON_SINGLE_USEDEP}]
	)
	codec-cuda? (
		>=dev-python/torchcodec-0.8.0[${PYTHON_SINGLE_USEDEP}]
	)
	l10n_ko? (
		$(python_gen_cond_dep '
			>=dev-python/ko-speech-tools-0.1.0[${PYTHON_USEDEP},g2p]
		' python3_{10..13})
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/coverage-7[${PYTHON_USEDEP},toml]
			>=dev-python/pre-commit-4[${PYTHON_USEDEP}]
			>=dev-python/pytest-9[${PYTHON_USEDEP}]
			~dev-util/ruff-0.14.11[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/furo-2025.9.25[${PYTHON_USEDEP}]
			~dev-python/myst-parser-4.0.1[${PYTHON_USEDEP}]
			~dev-python/sphinx-8.1.3[${PYTHON_USEDEP}]
			>=dev-python/sphinx-inline-tabs-2023.4.21[${PYTHON_USEDEP}]
			>=dev-python/sphinx_copybutton-0.5.2[${PYTHON_USEDEP}]
			>=dev-python/linkify-it-py-2.0.3[${PYTHON_USEDEP}]
			>=dev-python/click-extra-7.3.0[${PYTHON_USEDEP},sphinx]
		)
	')
"
DOCS=( "README.md" )

python_prepare_all() {
	distutils-r1_python_prepare_all
	if use cors ; then
		eapply "${FILESDIR}/${PN}-0.24.2-cors.patch"
	fi
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
