# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package
# kornia

MY_PV="0.1.1.post1"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/crowsonkb/k-diffusion.git"
	FALLBACK_COMMIT="0c6cc822e050e59d3e59128c57d350074969b267" # Dec 7, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Missing dependendencies
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="
https://github.com/crowsonkb/k-diffusion/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Diffusion models for PyTorch"
HOMEPAGE="
	https://github.com/crowsonkb/k-diffusion
	https://pypi.org/project/k-diffusion
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/accelerate[${PYTHON_USEDEP}]
		dev-python/einops[${PYTHON_USEDEP}]
		dev-python/jsonmerge[${PYTHON_USEDEP}]
		dev-python/scikit-image[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-ml/safetensors[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-2.0[${PYTHON_SINGLE_USEDEP}]
	dev-python/clean-fid[${PYTHON_SINGLE_USEDEP}]
	dev-python/clip-anytorch[${PYTHON_SINGLE_USEDEP}]
	dev-python/dctorch[${PYTHON_SINGLE_USEDEP}]
	dev-python/kornia[${PYTHON_SINGLE_USEDEP}]
	dev-python/torchdiffeq[${PYTHON_SINGLE_USEDEP}]
	dev-python/torchsde[${PYTHON_SINGLE_USEDEP}]
	dev-python/wandb[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
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
