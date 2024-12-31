# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# TODO package:
# flake8-black
# flake8-bugbear
# flake8-import-order

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )

inherit distutils-r1 pypi

DESCRIPTION="Extensible memoizing collections and decorators"
HOMEPAGE="
	https://github.com/tkem/cachetools/
	https://pypi.org/project/cachetools/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
BDEPEND="
	>=dev-python/setuptools-46.4.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/black-22.12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-black[${PYTHON_USEDEP}]
		dev-python/flake8-bugbear[${PYTHON_USEDEP}]
		dev-python/flake8-import-order[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
RESTRICT="test"

distutils_enable_tests "pytest"
