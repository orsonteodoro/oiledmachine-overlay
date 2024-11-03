# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit python-single-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/mezbaul-h/june/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Local voice chatbot for engaging conversations, powered by Ollama, Hugging Face Transformers, and Coqui TTS Toolkit"
HOMEPAGE="
	https://github.com/mezbaul-h/june
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=app-misc/ollama-0.2.1[${PYTHON_USEDEP}]
		>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
		>=dev-python/coqui-tts-0.24.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/PyAudio-0.2.14[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pygame-2.5.2[${PYTHON_USEDEP}]
	')
	>=sci-libs/pytorch-2.3.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/torchaudio-2.3.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/transformers-4.40.2[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="

	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-69.1.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/bandit-1.7.8[${PYTHON_USEDEP},toml(+)]
			>=dev-python/black-24.4.2[${PYTHON_USEDEP},jupyter(+)]
			>=dev-python/coverage-7.5.3[${PYTHON_USEDEP}]
			>=dev-python/isort-5.13.2[${PYTHON_USEDEP},colors(+)]
			>=dev-python/mypy-1.10.0[${PYTHON_USEDEP}]
			>=dev-python/pylint-3.2.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.2.2[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
