# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only tests up to 3.7

inherit distutils-r1

KEYWORDS="~amd64 ~x86"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

DESCRIPTION="Color scales in Python for humans"
HOMEPAGE="https://github.com/plotly/colorlover"
LICENSE="MIT"
SLOT="0"

# no tests in package
