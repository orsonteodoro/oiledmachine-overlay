# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop electron-app eutils npm-utils

DESCRIPTION="GitHub Notifications Manager & Activity Watcher - Web, Mobile & \
Desktop"
HOMEPAGE="https://devhubapp.com"
LICENSE="AGPL-3"
KEYWORDS="~amd64"
SLOT="0"
BDEPEND+=" >=net-libs/nodejs-12[npm]
	>=sys-apps/yarn-1.13.0"
ELECTRON_APP_MODE=yarn
ELECTRON_APP_ELECTRON_V="11.0.3"
ELECTRON_APP_REACT_NATIVE_V="0.64.0_rc1"
SRC_URI="\
https://github.com/devhubapp/devhub/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	yarn workspace @devhub/web build || die
	yarn workspace @devhub/desktop build:base || die
	yarn workspace @devhub/desktop build:web:post || die
	yarn workspace @devhub/desktop build:electron --linux dir || die
	cd "${S}" || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install_program \
"packages/desktop/build/linux-unpacked/*"
	electron-app_store_jsons_for_security_audit
	npm-utils_install_licenses

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"

        newicon "node_modules/@devhub/desktop/assets/icons/icon.png" "${PN}.png"
        make_desktop_entry ${PN} "${MY_PN}" ${PN} "Development"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}
