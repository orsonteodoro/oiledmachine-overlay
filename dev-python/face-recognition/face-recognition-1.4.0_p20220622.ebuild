# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="2e2dccea9dd0ce730c8d464d0f67c6eebb40c9d1"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN/-/_}-${FALLBACK_COMMIT}"
SRC_URI="
https://github.com/ageitgey/face_recognition/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${PN}-${FALLBACK_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Recognize faces from Python or from the command line"
HOMEPAGE="
	https://github.com/ageitgey/face_recognition
	https://pypi.org/project/face-recognition/
"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE=" dev"
RDEPEND="
	>=dev-python/click-6.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.17.0[${PYTHON_USEDEP}]
	>=sci-libs/dlib-19.3.0[${PYTHON_USEDEP}]
	dev-python/face_recognition_models[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/pillow[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/bumpversion-0.5.3[${PYTHON_USEDEP}]
		>=dev-python/click-6.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.1[${PYTHON_USEDEP}]
		>=dev-python/cryptography-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/pip-21.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-4.2_beta1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.4.8[${PYTHON_USEDEP}]
		>=dev-python/tox-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/watchdog-0.8.3[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.29.0[${PYTHON_USEDEP}]
		>=sci-libs/dlib-19.3.0[${PYTHON_USEDEP}]
		dev-python/face_recognition_models[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

distutils_enable_tests "pytest"

python_test() {
	py.test -v -v || die
}
