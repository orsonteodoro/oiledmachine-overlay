# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PyPI sdist is missing test fixtures, as of 4.0.0

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} "pypy3" "pypy3_11" )

inherit distutils-r1

KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
SRC_URI="
https://github.com/python-hyper/hpack/archive/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="Pure-Python HPACK header compression"
HOMEPAGE="
	https://python-hyper.org/projects/hpack/en/latest/
	https://github.com/python-hyper/hpack/
	https://pypi.org/project/hpack/
"
LICENSE="MIT"
RESTRICT="test" # Untested
SLOT="0"
BDEPEND="
	test? (
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.1.0-toml-compat.patch"
)

distutils_enable_tests "pytest"
