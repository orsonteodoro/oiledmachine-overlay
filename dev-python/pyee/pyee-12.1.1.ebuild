# Copyright 1999-2021,2025 Gentoo Authors
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
		>=dev-python/build-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/flake8-7.0.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-black-0.3.6[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.23.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-trio-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/black-24.3.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.13.2[${PYTHON_USEDEP}]
		>=dev-python/jupyter-console-6.6.3[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-1.5.3[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-include-markdown-plugin-6.0.4[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.24.0[${PYTHON_USEDEP},python(+)]
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/tox-4.13.0[${PYTHON_USEDEP}]
		>=dev-python/trio-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/trio-typing-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/twine-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-24.7.0[${PYTHON_USEDEP}]
		>=dev-python/validate-pyproject-0.16[${PYTHON_USEDEP},all(+)]
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.23.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-trio-0.8.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
