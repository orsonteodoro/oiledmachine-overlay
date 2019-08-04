# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1 eutils

DESCRIPTION="Stack overflow command line client. Search and browse stack overflow without leaving the terminal"
HOMEPAGE="https://github.com/gautamkrishnar/socli"
SRC_URI="https://github.com/gautamkrishnar/socli/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND="dev-python/py-stackexchange[${PYTHON_USEDEP}]
        dev-python/requests[${PYTHON_USEDEP}]
        dev-python/colorama[${PYTHON_USEDEP}]
        dev-python/urwid[${PYTHON_USEDEP}]
        dev-python/beautifulsoup:4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${PV}"

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${D}/usr/socli"
}
