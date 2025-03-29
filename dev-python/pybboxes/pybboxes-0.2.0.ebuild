# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/devrimcavusoglu/pybboxes.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/devrimcavusoglu/pybboxes/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Lightweight toolkit for bounding boxes providing conversion between bounding box types and simple computations"
HOMEPAGE="
	https://github.com/devrimcavusoglu/pybboxes
	https://pypi.org/project/pybboxes
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	>=dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
	>=dev-python/pycocotools-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/click-8.0.4[${PYTHON_USEDEP}]
		>=dev-python/deepdiff-5.5.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.9.2[${PYTHON_USEDEP}]
		>=dev-python/isort-5.9.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-depends-1.0.1[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			>=sci-ml/huggingface_hub-0.25.0[${PYTHON_SINGLE_USEDEP}]
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

python_install() {
	distutils-r1_python_install
	rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/tests"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
