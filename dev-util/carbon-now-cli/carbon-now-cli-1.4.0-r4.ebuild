# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
LICENSE="MIT"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="clipboard"
RDEPEND="clipboard? ( x11-misc/xclip )"
NODE_VERSION=14
DEPEND=">=net-libs/nodejs-${NODE_VERSION}[npm]"
inherit desktop npm-secaudit npm-utils
MY_PN="${PN//-cli/}"
SRC_URI=\
"https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

npm-secaudit_src_compile() {
	:;
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/opt/${PN}"
	npm-secaudit_install "*"
	cp "${FILESDIR}/${MY_PN}" "${T}" || die
	sed -i -e "s|__NODE_VERSION__|${NODE_VERSION}|g" \
		"${T}/${MY_PN}" || die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
