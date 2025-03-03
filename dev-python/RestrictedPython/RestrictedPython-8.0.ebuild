# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV1="${PV/_beta/b}"
MY_PV="${MY_PV1/_alpha/a}"

PYTHON_COMPAT=( "python3_"{10..13} )
PYTHON_MODULES="${PN}"
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

S="${WORKDIR}/${PN}-${MY_PV}"
KEYWORDS="amd64 arm arm64 x86"
SRC_URI="
https://github.com/zopefoundation/${PN}/archive/refs/tags/${MY_PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="A subset of Python which allows program input into a trusted environment"
HOMEPAGE="
	https://github.com/zopefoundation/RestrictedPython
	https://pypi.org/project/RestrictedPython/
	https://pypi.python.org/pypi/RestrictedPython
"
LICENSE="ZPL"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="doc test"
DOCS=( "README.rst" )
DEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
