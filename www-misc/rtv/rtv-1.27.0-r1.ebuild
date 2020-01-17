# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Browse Reddit from your terminal"
HOMEPAGE="https://github.com/michael-lazar/rtv"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-lang/python[ncurses]
	>=dev-python/beautifulsoup-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.0.10[${PYTHON_USEDEP}]
	>=dev-python/kitchen-1.2.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
inherit eutils
SRC_URI=\
"https://github.com/michael-lazar/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
