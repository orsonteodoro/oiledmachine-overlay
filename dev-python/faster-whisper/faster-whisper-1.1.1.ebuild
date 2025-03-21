# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only tests up to 3.11

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/SYSTRAN/faster-whisper.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/SYSTRAN/faster-whisper/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Faster Whisper transcription with CTranslate2"
HOMEPAGE="
	https://github.com/SYSTRAN/faster-whisper
	https://pypi.org/project/faster-whisper
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" conversion dev"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/ctranslate2-4.0[${PYTHON_USEDEP}]
		>=sci-ml/huggingface_hub-0.13[${PYTHON_USEDEP}]
		>=dev-python/av-11[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
	>=sci-ml/onnxruntime-1.14[${PYTHON_SINGLE_USEDEP},python]
	>=sci-libs/tokenizers-0.13[${PYTHON_SINGLE_USEDEP}]
	conversion? (
		>=sci-libs/transformers-4.23[${PYTHON_SINGLE_USEDEP},pytorch]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(python_gen_cond_dep '
			>=dev-python/black-23[${PYTHON_USEDEP}]
			>=dev-python/flake8-6[${PYTHON_USEDEP}]
			>=dev-python/isort-5[${PYTHON_USEDEP}]
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
		')
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
