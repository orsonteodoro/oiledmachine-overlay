# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package
# kornia-moons
# kornia-rs
# sphinx-autodoc-defaultargs
# sphinxcontrib-gtagjs

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/kornia/kornia.git"
	FALLBACK_COMMIT="b2edb53ec7db87fedfb78a395d7b096a33e09cd4" # Nov 5, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/kornia/kornia/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Geometric computer vision library for spatial AI"
HOMEPAGE="
	https://github.com/kornia/kornia
	https://pypi.org/project/kornia
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda dev doc x"
REQUIRED_USE="
	x? (
		cuda
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/kornia-rs-0.1.0[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		x? (
			dev-python/accelerate[${PYTHON_USEDEP}]
		)
	')
	>=sci-ml/pytorch-1.9.1[${PYTHON_SINGLE_USEDEP}]
	x? (
		>=sci-ml/onnxruntime-1.16[${PYTHON_SINGLE_USEDEP},cuda?,python]
	)
"
DEPEND+="
	${RDEPEND}
"
# ivy-9999 is forced for license compatibility.  Upstream listed >= 1.0.0.1
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
	')
	dev? (
		$(python_gen_cond_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
			>=dev-python/setuptools-61.2[${PYTHON_USEDEP}]
			dev-python/accelerate[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/diffusers[${PYTHON_USEDEP}]
			dev-python/mypy[${PYTHON_USEDEP}]
			dev-python/onnx[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/types-requests[${PYTHON_USEDEP}]
			sci-ml/transformers[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		')
		>=dev-python/ivy-9999[${PYTHON_SINGLE_USEDEP}]
		>=dev-vcs/pre-commit-2[${PYTHON_SINGLE_USEDEP}]
		sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
	)
	doc? (
		$(python_gen_cond_dep '
			>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			dev-python/furo[${PYTHON_USEDEP}]
			dev-python/kornia-moons[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/onnx[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-autodoc-defaultargs[${PYTHON_USEDEP}]
			dev-python/sphinx-autodoc-typehints[${PYTHON_USEDEP}]
			dev-python/sphinx-design[${PYTHON_USEDEP}]
			dev-python/sphinx-notfound-page[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-gtagjs[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-youtube[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},python]
		')
		>=dev-python/ivy-9999[${PYTHON_SINGLE_USEDEP}]
		sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
	)
"
DOCS=( "CHANGELOG.md" "README.md" "README_zh-CN.md" )

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
	dodoc "COPYRIGHT"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
