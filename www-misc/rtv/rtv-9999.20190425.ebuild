# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 python3_6 python3_7 )

inherit distutils-r1 eutils

COMMIT="ccef2af042566ad384977028cf0bde01bc524dda"

DESCRIPTION="Browse Reddit from your terminal"
HOMEPAGE="https://github.com/michael-lazar/rtv"
SRC_URI="https://github.com/michael-lazar/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${PN}-${COMMIT}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/kitchen-1.2.4[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	dev-lang/python[ncurses]
	>=dev-python/decorator-4.0.10[${PYTHON_USEDEP}]"
