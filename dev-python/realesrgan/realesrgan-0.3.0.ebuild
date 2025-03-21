# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.8

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/xinntao/Real-ESRGAN.git"
	FALLBACK_COMMIT="fa4c8a03ae3dbc9ea6ed471a6ab5da94ac15c2ea" # Sep 22, 2022
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/xinntao/Real-ESRGAN/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Real-ESRGAN aims at developing practical algorithms for general image or video restoration"
HOMEPAGE="
	https://github.com/xinntao/Real-ESRGAN
	https://pypi.org/project/realesrgan
"
LICENSE="
	Apache-2.0
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},python]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=dev-python/basicsr-1.4.2[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/facexlib-0.2.5[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/gfpgan-1.3.5[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/pytorch-1.7[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" "README_CN.md" )

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
