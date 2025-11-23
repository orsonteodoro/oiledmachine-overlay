# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="0.29"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/TencentARC/GFPGAN.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/TencentARC/GFPGAN/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="GFPGAN aims at developing Practical Algorithms for Real-world Face Restoration"
HOMEPAGE="
	https://github.com/TencentARC/GFPGAN
	https://pypi.org/project/gfpgan
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_2
"
# Tensorboard based on author-date:2022-09-16 and RELEASE.md
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/lmdb[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/yapf[${PYTHON_USEDEP}]
	')
	>=dev-python/basicsr-1.4.2[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/facexlib-0.2.5[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/pytorch-1.7[${PYTHON_SINGLE_USEDEP}]
	>=sci-visualization/tensorboard-2.10.0[${PYTHON_SINGLE_USEDEP}]
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/cython:'${CYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/cython:=
		dev-python/numpy[${PYTHON_USEDEP}]
	')
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

python_configure() {
	cython_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
