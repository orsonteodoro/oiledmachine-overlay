# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 eutils

DESCRIPTION="Browse Reddit from your terminal"
HOMEPAGE="https://github.com/michael-lazar/rtv"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND+=" ${PYTHON_DEPS}
	dev-lang/python[ncurses]
	>=dev-python/beautifulsoup-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.0.10[${PYTHON_USEDEP}]
	>=dev-python/kitchen-1.2.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/michael-lazar/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
