# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

YARN_INSTALL_PATH="/opt/${PN}"
ELECTRON_APP_ELECTRON_PV="18.3.7"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
NODE_ENV=development
NODE_VERSION="16"
inherit desktop electron-app lcnr yarn

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
# Initially generated from:
#   grep "resolved" /var/tmp/portage/www-misc/instatron-1.5.0_p20221110/work/instatron-1.5.0_p20221110/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/alexdevero/instatron/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	yarn run "package:linux" || die
}

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r "builds/${PN}-linux-$(electron-app_get_arch)/"*
	fperms 0755 "${YARN_INSTALL_PATH}/${PN}"
	electron-app_gen_wrapper \
		"${PN}" \
		"${YARN_INSTALL_PATH}/${PN}"
	newicon "assets/instagram-uploader-icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Network"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
