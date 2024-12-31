# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="amd64 arm arm64 x86"

DESCRIPTION="Models used by the face_recognition package."
HOMEPAGE="
	https://github.com/ageitgey/face_recognition_models
	https://pypi.org/project/face_recognition_models/
"
LICENSE="
	CC0-1.0
	MIT
"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

distutils_enable_tests "pytest"

python_test() {
	py.test -v -v || die
}
