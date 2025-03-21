# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream tests up to 3.10

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rwightman/efficientdet-pytorch.git"
	FALLBACK_COMMIT="94136afe0b3042037f6ec0f85a5077524ddca380" # May 21, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
fi

DESCRIPTION="A PyTorch implementation of EfficientDet"
HOMEPAGE="
	https://github.com/rwightman/efficientdet-pytorch
	https://pypi.org/project/effdet
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/omegaconf-2.0[${PYTHON_USEDEP}]
		>=dev-python/pycocotools-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/timm-0.9.2[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-1.12.1[${PYTHON_SINGLE_USEDEP}]
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
