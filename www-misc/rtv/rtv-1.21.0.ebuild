# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5} )

inherit distutils-r1 eutils

DESCRIPTION="RTV provides an interface to view and interact with reddit from your terminal."
HOMEPAGE="https://github.com/michael-lazar/rtv"
SRC_URI="https://github.com/michael-lazar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/mailcap-fix-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/kitchen-1.2.4[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	dev-lang/python[ncurses]
	>=dev-python/decorator-4.0.10[${PYTHON_USEDEP}]"
