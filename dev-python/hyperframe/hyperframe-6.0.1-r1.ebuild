# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} "pypy3" ) # Upstream lists up to to 3.8

inherit distutils-r1 pypi

DESCRIPTION="HTTP/2 framing layer for Python"
HOMEPAGE="
	https://python-hyper.org/projects/hyperframe/en/latest/
	https://pypi.org/project/hyperframe/
	https://github.com/python-hyper/hyperframe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests "pytest"
