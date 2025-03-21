# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# webdataset

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mlfoundations/open_clip.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/mlfoundations/open_clip/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An open source implementation of CLIP"
HOMEPAGE="
	https://github.com/mlfoundations/open_clip
	https://pypi.org/project/open-clip-torch
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test training"
REQUIRED_USE="
	test? (
		training
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/ftfy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/timm[${PYTHON_USEDEP}]
		sci-ml/huggingface_hub[${PYTHON_USEDEP}]
		sci-ml/safetensors[${PYTHON_USEDEP}]
		training? (
			>=dev-python/timm-1.0.10[${PYTHON_USEDEP}]
			>=dev-python/webdataset-0.2.5[${PYTHON_USEDEP}]
			>=sci-ml/pytorch-2.0[${PYTHON_USEDEP}]
			dev-python/fsspec[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			sci-ml/transformers[${PYTHON_SINGLE_USEDEP},sentencepiece]
		)
	')
	>=sci-ml/pytorch-1.9.0[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-split[${PYTHON_USEDEP}]
		')
	)
"
DOCS=( "HISTORY.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"1.8.2\"" "${S}/pyproject.toml" \
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
