# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{9..11} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"

DESCRIPTION="An Abstract Syntax Tree (AST) unparser for Python"
HOMEPAGE="
	https://github.com/simonpercivall/astunparse/
	https://pypi.org/project/astunparse/
"
LICENSE="BSD"
SLOT="0"
RDEPEND="
	(
		>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
		<dev-python/six-2[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/wheel-0.23.0[${PYTHON_USEDEP}]
		<dev-python/wheel-1.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/astunparse-1.6.2-tests.patch"
	# From Fedora
	"${FILESDIR}/${P}-py39.patch"
	# From Debian
	"${FILESDIR}/${P}-test-py311.patch"
)

distutils_enable_tests "unittest"

python_install_all() {
	distutils-r1_python_install_all
	dodoc *".rst"
}
