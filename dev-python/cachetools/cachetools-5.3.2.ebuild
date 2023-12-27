# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} pypy3 )

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
	>=dev-python/setuptools-68.2.2[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.41.2[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/black-22.12.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-black-0.3.6[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-23.9.16[${PYTHON_USEDEP}]
		>=dev-python/flake8-import-order-0.18.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
	)
"
RESTRICT="test"

distutils_enable_tests "pytest"
