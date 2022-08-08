# Copyright 2022 Orson Teodoro <orsonteododoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

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

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
