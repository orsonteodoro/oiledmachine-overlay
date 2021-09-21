# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Free, Cross-Platform, GPU-Accelerated Procedural Texture Generator"
HOMEPAGE="https://njbrown.itch.io/texturelab"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
BDEPEND+="
	|| (
		net-libs/nodejs:12
		net-libs/nodejs:14
		net-libs/nodejs:16
	)
	net-libs/nodejs[npm]
"
ELECTRON_APP_ELECTRON_V="13.1.4"
ELECTRON_APP_VUE_V="2.6.11"
ELECTRON_APP_MODE="yarn"
ASSETS_COMMIT="db62cecd809465235f5bbc3cf2c69ef1b5c495ae"
SRC_URI=\
"https://github.com/njbrown/texturelab/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz
https://github.com/njbrown/texturelabdata/archive/${ASSETS_COMMIT}.tar.gz \
	-> ${PN}-assets-${ASSETS_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
MY_PN="TextureLab"

electron-app_src_preprepare() {
	cd "${WORKDIR}" || die
	unpack "${PN}-assets-${ASSETS_COMMIT:0:7}.tar.gz"
	rm -rf "${S}/public/assets" || die
	mkdir -p "${S}/public/assets" || die
	cp -aT "${WORKDIR}/${PN}data-${ASSETS_COMMIT}" "${S}/public/assets" || die
}

electron-app_src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	yarn electron:build --publish=never || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install "dist_electron/linux-unpacked/*" "src/assets/logo.png" "${MY_PN}" \
	"Graphics;2DGraphics" "${ELECTRON_APP_INSTALL_PATH}/texturelab \"\$@\""
	fperms 755 ${ELECTRON_APP_INSTALL_PATH}/texturelab
	npm-utils_install_licenses
}
