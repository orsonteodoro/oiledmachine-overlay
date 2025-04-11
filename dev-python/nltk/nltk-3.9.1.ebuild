# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# python-crfsuite
# mdit-plain

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nltk/nltk.git"
	FALLBACK_COMMIT="aca78cb2add4084f76b9eac921d8a73927d7a086" # Aug 18, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/nltk/nltk/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A suite of open source Python modules, data sets, and tutorials supporting research and development in Natural Language Processing"
HOMEPAGE="
	https://github.com/nltk/nltk
	https://pypi.org/project/nltk
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ci ci-test corenlp dev machine-learning plot test tgrep twitter"
RDEPEND+="
	corenlp? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
	machine-learning? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/python-crfsuite[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	plot? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
	tgrep? (
		dev-python/pyparsing[${PYTHON_USEDEP}]
	)
	twitter? (
		dev-python/twython[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/regex-2021.8.3[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	ci? (
		>=dev-python/gensim-4.0.0[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/markdown-it-py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mdit-plain[${PYTHON_USEDEP}]
		dev-python/mdit-py-plugins[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP},psutil]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/twython[${PYTHON_USEDEP}]
	)
	ci-test? (
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/joblib-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/pre-commit-2.13.0[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.0.1[${PYTHON_USEDEP}]
		>=dev-python/python-crfsuite-0.8.2[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.59.0[${PYTHON_USEDEP}]
		>=dev-python/regex-2021.8.3[${PYTHON_USEDEP}]
		>=dev-python/scikit-learn-0.14.1[${PYTHON_USEDEP}]
		>=dev-python/scipy-0.13.2[${PYTHON_USEDEP}]
		>=dev-python/tox-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/twython-3.2.0[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-6.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.10.1[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
DOCS=( "ChangeLog" "README.md" )

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
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
