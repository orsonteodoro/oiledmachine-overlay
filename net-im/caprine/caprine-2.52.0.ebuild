# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop electron-app eutils

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
CDEPEND=">=net-libs/nodejs-12[npm]"
RDEPEND+=" ${CDEPEND}"
BDEPEND+=" ${CDEPEND}
	>=dev-lang/typescript-4.1.2"
ELECTRON_APP_ELECTRON_V="10.1.5"
ELECTRON_APP_TYPESCRIPT_V="4.1.2"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
SRC_URI=\
"https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
RESTRICT="mirror"

electron-app_src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	tsc || die
	electron-builder -l dir || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install "*" "static/Icon.png" "${PN^}" "Network" \
"env PATH=\"${ELECTRON_APP_INSTALL_PATH}/node_modules/.bin:\$PATH\" \
electron ${ELECTRON_APP_INSTALL_PATH}/"
}
