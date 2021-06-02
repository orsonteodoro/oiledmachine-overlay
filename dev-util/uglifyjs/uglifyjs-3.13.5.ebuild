# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="UglifyJS"
inherit npm-secaudit

DESCRIPTION="JavaScript parser / mangler / compressor / beautifier toolkit"
HOMEPAGE="https://github.com/mishoo/UglifyJS"
LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"
NODEJS_V="0.8"
RDEPEND+=" >=net-libs/nodejs-${NODEJS_V}"
BDEPEND+=" >=net-libs/nodejs-${NODEJS_V}"
SRC_URI="https://github.com/mishoo/UglifyJS/archive/refs/tags/v3.13.5.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"

npm-secaudit_src_preprepare()
{
	npm i --package-lock-only || die
	[ ! -e package-lock.json ] \
	&& ewarn "package-lock.json was not created in $(pwd)"
}

src_install()
{
	npm-secaudit_src_postinst
}

npm-secaudit_src_compile() {
	# no need to build
	:;
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/opt/${PN}"
	npm-secaudit_install "*"
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
}

pkg_postinst() {
	npm-secaudit-register "/opt/${PN}"
}
