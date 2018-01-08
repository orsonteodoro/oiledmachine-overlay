# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

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
S="${WORKDIR}/${P}"

python_prepare_all() {
	eapply_user
        distutils-r1_python_prepare_all
}
