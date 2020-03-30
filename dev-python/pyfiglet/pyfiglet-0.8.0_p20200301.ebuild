# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="An implementation of figlet written in Python"
HOMEPAGE="https://github.com/pwaller/pyfiglet"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
EGIT_COMMIT="da49f613f40cb02ba635b8a1cb2afcd575312bb7"
SRC_URI="\
https://github.com/pwaller/pyfiglet/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
RESTRICT="mirror"
