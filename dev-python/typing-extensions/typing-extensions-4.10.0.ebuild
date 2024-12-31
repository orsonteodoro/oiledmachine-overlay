# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-/_}"

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos
~x64-solaris
"
S="${WORKDIR}/${MY_P}"
SRC_URI="
	https://github.com/python/typing_extensions/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"

DESCRIPTION="Backported and experimental type hints for Python"
HOMEPAGE="
	https://pypi.org/project/typing-extensions
	https://github.com/python/typing_extensions
"
LICENSE="PSF-2"
SLOT="0"
IUSE+=" doc"
BDEPEND="
	(
		>=dev-python/flit-core-3.4[${PYTHON_USEDEP}]
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-bugbear[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "unittest"

python_test() {
	cd src || die
	eunittest
}
