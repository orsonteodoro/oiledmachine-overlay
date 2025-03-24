# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )

inherit distutils-r1

KEYWORDS="amd64 ~arm64 x86"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

DESCRIPTION="A port of node.js's EventEmitter to python."
HOMEPAGE="
	https://pypi.python.org/pypi/pyee
	https://github.com/jfhbrook/pyee
"
LICENSE="MIT"
SLOT="0"
IUSE="dev test"
RDEPEND="
	>=dev-python/typing-extensions-4.9.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/trio-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-24.7.0[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
