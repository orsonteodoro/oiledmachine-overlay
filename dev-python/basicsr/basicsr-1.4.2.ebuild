# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-markdown-tables

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream list only up to 3.8

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/XPixelGroup/BasicSR.git"
	FALLBACK_COMMIT="8d56e3a045f9fb3e1d8872f92ee4a4f07f886b0a" # May 17, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/XPixelGroup/BasicSR/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An open source image and video super-resolution toolbox"
HOMEPAGE="
	https://github.com/XPixelGroup/BasicSR
	https://pypi.org/project/basicsr
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
# tensorboard based on author-date:2022-08-29 and RELEASE.md
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
		dev-python/addict[${PYTHON_USEDEP}]
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/lmdb[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scikit-image[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/yapf[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=sci-visualization/tensorboard-2.10.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/pytorch-1.7[${PYTHON_SINGLE_USEDEP}]
	media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev? (
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-util/codespell[${PYTHON_USEDEP}]
		)
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx-markdown-tables[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
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
	cython_set_cython_slot
	cython_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
