# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Python 2/3 compatibility layer for C extensions"
HOMEPAGE="https://github.com/encukou/py3c"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1
SRC_URI=\
"https://github.com/encukou/py3c/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
