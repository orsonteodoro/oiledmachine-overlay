# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A simple Instagram desktop uploader & client app build with \
electron.Mobile Instagram on desktop!"
HOMEPAGE="https://github.com/alexdevero/instatron"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
BDEPEND+=" >=net-libs/nodejs-9[npm]"
ELECTRON_APP_ELECTRON_V="9.1.2"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
inherit desktop electron-app eutils
SRC_URI=\
"https://github.com/alexdevero/instatron/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz"
RESTRICT="mirror"

electron-app_src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	npm run package:linux || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"builds/${PN}-linux-"$(electron-app_get_arch)"/*" \
		"assets/instagram-uploader-icon.png" \
		"${PN^}" "Network" "${ELECTRON_APP_INSTALL_PATH}/${PN}"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN} \"\$@\""
}
