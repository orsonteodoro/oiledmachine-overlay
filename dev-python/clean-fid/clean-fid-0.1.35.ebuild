# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="8426fc12f29934754015967cc013bca18f874bc2" # Dec 18, 2022
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/GaParmar/clean-fid.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/GaParmar/clean-fid/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="FID calculation in PyTorch with proper image resizing and quantization steps"
HOMEPAGE="
	https://github.com/GaParmar/clean-fid
	https://pypi.org/project/clean-fid
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.14.3[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.28.1[${PYTHON_USEDEP}]
		>=virtual/pillow-8.1[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	sci-libs/torch[${PYTHON_SINGLE_USEDEP}]
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
