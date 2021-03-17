# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ELECTRON_APP_APPIMAGEABLE=1
ELECTRON_APP_SNAPABLE=1

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Free, Cross-Platform, GPU-Accelerated Procedural Texture Generator"
HOMEPAGE="https://njbrown.itch.io/texturelab"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND+=" || (
		net-libs/nodejs:12
		<net-libs/nodejs-14
	   )"
BDEPEND+=" net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="5.0.10"
ELECTRON_APP_VUE_V="2.6.10"
ELECTRON_APP_MODE="yarn"
ASSETS_COMMIT="e794d2d766069e137825c8258d53988e85a7e123"
SRC_URI=\
"https://github.com/njbrown/texturelab/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz
https://github.com/njbrown/texturelabdata/archive/${ASSETS_COMMIT}.tar.gz \
	-> ${PN}-assets-${ASSETS_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
MY_PN="TextureLab"
NODE_VERSION="12"
THREE_V="0.106.2"

pkg_setup() {
	export ELECTRON_APP_APPIMAGE_PATH="dist_electron/texturelab-${PV}.AppImage"
	export ELECTRON_APP_SNAP_PATH_BASENAME="texturelab_${PV}_$(electron-app_get_arch_suffix_snap ${ARCH}).snap"
	export ELECTRON_APP_SNAP_PATH="dist_electron/${ELECTRON_APP_SNAP_PATH_BASENAME}"
	electron-app_pkg_setup
	if has_version  'net-libs/nodejs:12' ; then
		einfo "Using nodejs:12"
		export NODE_VERSION="12"
	elif has_version  'net-libs/nodejs:10' ; then
		einfo "Using nodejs:10"
		export NODE_VERSION="10"
	else
		die "<net-libs/nodejs-14 must be used."
	fi
	local node_v=$(node --version | sed -e "s|v||")
	if ver_test ${node_v} -ge 14 ; then
		die "Switch your node version to <14.  Found ${node_v} instead."
	else
		export NODE_VERSION=$(echo ${node_v} | cut -f 1 -d ".")
		einfo "Using nodejs-${NODE_VERSION}"
	fi
}

electron-app_src_preprepare() {
	cd "${WORKDIR}" || die
	unpack "${PN}-assets-${ASSETS_COMMIT}.tar.gz"
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
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install "*" "src/assets/logo.png" "${MY_PN}" \
	"Graphics;2DGraphics" \
"env NODE_VERSION=\"${NODE_VERSION}\" PATH=\"${ELECTRON_APP_INSTALL_PATH}/node_modules/.bin:\$PATH\" \
electron ${ELECTRON_APP_INSTALL_PATH}/dist_electron/bundled/"
}
