# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 eutils

DESCRIPTION="Stack overflow command line client. Search and browse stack \
overflow without leaving the terminal"
HOMEPAGE="https://github.com/gautamkrishnar/socli"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE+=" man"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
SLOT="0"
DEPEND+=" ${PYTHON_DEPS}
	  dev-python/argcomplete
	>=dev-python/beautifulsoup-4.9.1:4[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/py-stackexchange-2.2.007[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.18.0[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
EGIT_COMMIT="57c60e01981111d2559cb6339640ab377e752485"
SRC_URI="
https://github.com/gautamkrishnar/socli/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	sed -i "/setup_requires/d" setup.py || die
	sed -i "/tests_require/d" setup.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${ED}/usr/socli" || die
}

src_install() {
	default
	distutils-r1_src_install
	if use man ; then
		cp "${ED}/usr/man/man1/${PN}.1" "${T}" || die
		rm -rf "${ED}/usr/man" || die
		doman "${T}/${PN}.1"
	else
		rm -rf "${ED}/usr/man" || die
	fi
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
