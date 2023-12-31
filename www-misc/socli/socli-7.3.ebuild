# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Stack overflow command line client. Search and browse stack \
overflow without leaving the terminal"
HOMEPAGE="https://github.com/gautamkrishnar/socli"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE+=" man test"
SLOT="0"
# Last DEPENDs commit date Jan 17, 2021
DEPEND+="
	>=dev-python/beautifulsoup4-4.9.1[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/py-stackexchange-2.2.007[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.18.0[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/gautamkrishnar/socli/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

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
einfo
einfo "You may need to enter your StackOverflow API key with \`socli --api\`"
einfo "for this program to work.  See"
einfo
einfo "  ${HOMEPAGE}"
einfo
einfo "for details on additional information in configuring ${PN}.  API keys"
einfo "can be obtained from"
einfo
einfo "  http://stackapps.com/apps/oauth/register"
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
