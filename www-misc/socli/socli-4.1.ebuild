# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Stack overflow command line client. Search and browse stack \
overflow without leaving the terminal"
HOMEPAGE="https://github.com/gautamkrishnar/socli"
SRC_URI="https://github.com/gautamkrishnar/socli/archive/${PV}.tar.gz \
	-> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1 eutils
SLOT="0"
DEPEND="dev-python/py-stackexchange[${PYTHON_USEDEP}]
        dev-python/requests[${PYTHON_USEDEP}]
        dev-python/colorama[${PYTHON_USEDEP}]
        dev-python/urwid[${PYTHON_USEDEP}]
        dev-python/beautifulsoup:4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${D}/usr/socli"
}

pkg_postinst() {
	einfo \
"You may need to enter your StackOverflow API key with \`socli --api\` for\n\
this program to work.  See\n\
  ${HOMEPAGE}\n\n
for details on additional information in configuring ${PN}.  API keys can\n\
be obtained from\n\
  http://stackapps.com/apps/oauth/register"
}
