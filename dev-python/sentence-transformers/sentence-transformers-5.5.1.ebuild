# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/UKPLab/sentence-transformers.git"
	FALLBACK_COMMIT="7d52a069e0b37d976b3ed3f674a6180436c27574" # Jan 29, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/UKPLab/sentence-transformers/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="State-of-the-Art Text Embeddings"
HOMEPAGE="
	https://github.com/UKPLab/sentence-transformers
	https://pypi.org/project/sentence-transformers
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev doc lint test
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
		>=dev-python/scikit-learn-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]

		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=sci-ml/huggingface-hub-0.23.0[${PYTHON_SINGLE_USEDEP}]

	>=sci-ml/transformers-4.41.0[${PYTHON_SINGLE_USEDEP}]
	<sci-ml/transformers-6.0.0[${PYTHON_SINGLE_USEDEP}]

	>=sci-ml/pytorch-1.11.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-64[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/datasets-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/accelerate-0.20.3[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-env[${PYTHON_USEDEP}]
			dev-python/pytest-subtests[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/peft[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
			>=dev-python/myst-parser-4.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-8.1.3[${PYTHON_USEDEP}]
			>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-inline-tabs-2023.4.21[${PYTHON_USEDEP}]
			>=dev-python/sphinx-markdown-tables-0.0.17[${PYTHON_USEDEP}]
			>=dev-python/sphinx-toolbox-3.9.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-mermaid-1.0.0[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/datasets-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/accelerate-0.20.3[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-env[${PYTHON_USEDEP}]
			dev-python/pytest-subtests[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/peft[${PYTHON_USEDEP}]
		)
	')
	dev? (
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP},audio,video,vision]
	)
	lint? (
		dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP},vision,audio,video]
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
	dodoc "NOTICE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
