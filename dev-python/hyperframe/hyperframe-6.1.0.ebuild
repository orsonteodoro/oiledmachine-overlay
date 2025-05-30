# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} "pypy3" "pypy3_11" )

inherit distutils-r1 pypi

DESCRIPTION="HTTP/2 framing layer for Python"
HOMEPAGE="
	https://python-hyper.org/projects/hyperframe/en/latest/
	https://pypi.org/project/hyperframe/
	https://github.com/python-hyper/hyperframe/
"

LICENSE="MIT"
RESTRICT="test" # Untested
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
PATCHES=(
	"${FILESDIR}/${PN}-6.1.0-toml-compat.patch"
)

distutils_enable_tests "pytest"
