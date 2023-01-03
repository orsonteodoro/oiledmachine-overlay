# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="21.2.3"
ELECTRON_APP_TYPESCRIPT_PV="4.8.4"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"

inherit desktop electron-app

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

KEYWORDS="~amd64"
SLOT="0"
BDEPEND+="
	>=net-libs/nodejs-16[npm]
" # Based on their CI
SRC_URI="
https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
RESTRICT="mirror"

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder install-app-deps || die
	tsc || die
	electron-builder -l dir || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"dist/linux-unpacked/*" \
		"static/Icon.png" \
		"${PN^}" "Network" \
	"${ELECTRON_APP_INSTALL_PATH}/${PN} \"\$@\""
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
	npm-utils_install_licenses
}

pkg_postinst() {
	electron-app_pkg_postinst
einfo
einfo "If you see"
einfo
einfo "  \"Config schema violation: vibrancy should be string; \
vibrancy should be equal to one of the allowed values,\""
einfo
einfo "then you may need to run \`rm -rf ~/.config/Caprine\`"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
