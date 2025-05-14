# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# mir_eval
# presets
# resampy
# sphinxcontrib-svg2pdfconverter
# types-decorator
# velin


if [[ "${PV}" =~ "_p" ]]; then
	MY_PV="$(ver_cut 1-3 ${PV}).post$(ver_cut 5 ${PV})"
else
	MY_PV="$(ver_cut 1-3 ${PV})"
fi

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )
TEST_DATA_COMMIT="72bd79e448829187f6336818b3f6bdc2c2ae8f5a" # Dec 15, 2022

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]]; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/librosa/librosa.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="
https://github.com/librosa/librosa/archive/refs/tags/${MY_PV}.tar.gz
	-> ${P}.tar.gz
	test? (
https://github.com/librosa/librosa-test-data/archive/${TEST_DATA_COMMIT}.tar.gz
	-> librosa-test-data-${TEST_DATA_COMMIT:0:7}.tar.gz
	)
	"
fi

DESCRIPTION="A Python package for music and audio analysis"
HOMEPAGE="https://github.com/librosa/librosa"
LICENSE="ISC"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" display doc lint test"
RDEPEND+="
	>=dev-python/audioread-2.1.9[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/lazy-loader-0.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22.3[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/numba-0.51.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pooch-1.1[${PYTHON_USEDEP}]
	>=dev-python/python-soxr-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/soundfile-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.1.1[${PYTHON_USEDEP}]
	dev-python/samplerate[${PYTHON_USEDEP}]
	display? (
		>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-48[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.29.0[${PYTHON_USEDEP}]
	doc? (
		!~dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/ipython-7.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/mir_eval-0.6[${PYTHON_USEDEP}]
		>=dev-python/numba-0.51[${PYTHON_USEDEP}]
		>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-gallery-0.7[${PYTHON_USEDEP}]
		>=dev-python/sphinx-multiversion-0.2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-googleanalytics-0.4[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-svg2pdfconverter-1.1.1[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/presets[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/numpy-1.23.4[${PYTHON_USEDEP}]
		dev-python/bandit[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/types-decorator[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pydocstyle[${PYTHON_USEDEP}]
		dev-python/velin[${PYTHON_USEDEP}]
		dev-util/codespell[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/resampy-0.2.2[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
		dev-python/samplerate[${PYTHON_USEDEP}]
		dev-python/types-decorator[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS.md" "README.md" )

distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		if use test ; then
			rm -rf "${S}/tests/data"
			mv \
				"${WORKDIR}/librosa-test-data-${TEST_DATA_COMMIT}" \
				"${S}/tests/data" \
				|| die
		fi
	fi
}

python_test() {
	epytest -n auto
}
