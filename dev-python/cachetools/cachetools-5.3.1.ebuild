# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Extensible memoizing collections and decorators"
HOMEPAGE="
	https://github.com/tkem/cachetools/
	https://pypi.org/project/cachetools/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc test"
# TODO:  package
# flake8-black
# dev-python/flake8-bugbear
# dev-python/flake8-import-order
BDEPEND="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-black[${PYTHON_USEDEP}]
		dev-python/flake8-bugbear[${PYTHON_USEDEP}]
		dev-python/flake8-import-order[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
RESTRICT="test"

distutils_enable_tests "pytest"
