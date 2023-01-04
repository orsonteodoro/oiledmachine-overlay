# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="18.3.7"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
NODE_ENV=development
NODE_VERSION="16"
inherit desktop electron-app

DESCRIPTION="A simple Instagram desktop uploader & client app build with \
electron.Mobile Instagram on desktop!"
HOMEPAGE="https://github.com/alexdevero/instatron"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

KEYWORDS="~amd64"
SLOT="0"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
EGIT_COMMIT="0916d8dd64f06580d640e645334586d8ba319cbf"
SRC_URI="
https://github.com/alexdevero/instatron/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

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
		"${PN^}" \
		"Network" \
		"${ELECTRON_APP_INSTALL_PATH}/${PN}"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
