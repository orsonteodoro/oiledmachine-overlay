# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_"{12..16} "pypy3_"{11..12} )
PYTHON_REQ_USE="threads(+)"

inherit cython secure-version distutils-r1

MY_P=${P/_}
DESCRIPTION="Python documentation generator"
HOMEPAGE="
	https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinx/
	https://pypi.org/project/Sphinx/
"
SRC_URI="
	https://github.com/sphinx-doc/sphinx/archive/v${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
if [[ ${PV} != *_rc* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
IUSE="
doc latex package lint translations types type-stubs
ebuild_revision_1
"
REQUIRED_USE="
	types? (
		type-stubs
	)
"
RDEPEND="
	>=dev-python/alabaster-1.0[${PYTHON_USEDEP}]
	>=dev-python/babel-2.18[${PYTHON_USEDEP}]

	>=dev-python/docutils-0.21[${PYTHON_USEDEP}]
	<dev-python/docutils-0.24[${PYTHON_USEDEP}]

	>=dev-python/imagesize-1.3[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-25.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
	>=dev-python/roman-numerals-3.0[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-applehelp-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-devhelp-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-htmlhelp-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-qthelp-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-serializinghtml-1.1.9[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)
"
# The second group in test is for doc tests.
BDEPEND="
	>=dev-python/flit-core-3.11
	doc? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	lint? (
		>=dev-python/sphinx-lint-0.9[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.17.1
	)
	package? (
		dev-python/build
		~dev-python/pypi-attestations-0.0.30
		>=dev-python/twine-6.1
	)
	test? (
		>=dev-python/pytest-9.1
		>=dev-python/pytest-xdist-3.7[psutil]
		>=dev-python/cython-${CYTHON_PV}:${CYTHON_SLOT}=[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/setuptools-80.0[${PYTHON_USEDEP}]
		>=dev-python/typing_extensions-4.15[${PYTHON_USEDEP}]

		app-text/dvipng
		dev-texlive/texlive-langcyrillic
		dev-texlive/texlive-langgreek
		dev-texlive/texlive-luatex
		dev-texlive/texlive-xetex
		media-fonts/freefont
		virtual/imagemagick-tools[jpeg,png,svg]
	)
	translations? (
		>=dev-python/babel-2.18[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1[${PYTHON_USEDEP}]
	)
	types? (
		~dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		~dev-python/mypy-2.4.0[${PYTHON_USEDEP}]
		dev-python/pyrefly[${PYTHON_USEDEP}]
		~dev-python/pyright-1.1.414[${PYTHON_USEDEP}]
		~dev-python/ty-0.0.90[${PYTHON_USEDEP}]
	)
	type-stubs? (
		~virtual/pillow-11[${PYTHON_USEDEP}]
		~dev-python/types-colorama-0.4.15.20260508[${PYTHON_USEDEP}]
		~dev-python/types-defusedxml-0.7.0.20260504[${PYTHON_USEDEP}]
		~dev-python/types-docutils-0.23.0.20260923[${PYTHON_USEDEP}]
		~dev-python/types-Pygments-2.21.0.20260819[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/sphinx-3.2.1-doc-link.patch"
)

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
# EPYTEST_XDIST breaks stuff
distutils_enable_tests pytest

python_prepare_all() {
	# disable internet access
	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		doc/conf.py || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cython_python_configure
}

python_compile_all() {
	# we can't use distutils_enable_sphinx because it would
	# introduce a dep on itself
	use doc && build_sphinx doc
}

python_test() {
	mkdir -p "${BUILD_DIR}/sphinx_tempdir" || die
	local -x SPHINX_TEST_TEMPDIR="${BUILD_DIR}/sphinx_tempdir"

	epytest
}
