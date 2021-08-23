# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ELECTRON_APP_ELECTRON_V="13.1.2"
ELECTRON_APP_MODE="npm"
inherit eutils desktop electron-app npm-utils

DESCRIPTION="Blockbench - A boxy 3D model editor"
HOMEPAGE="https://www.blockbench.net"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
BDEPEND+=" net-libs/nodejs[npm]"
SRC_URI="
https://github.com/JannisX11/blockbench/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	electron-app_pkg_setup
}

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder -l dir || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}/"
	electron-app_desktop_install "dist/linux-unpacked/*" "icon.png" "${PN^}" \
	"Graphics;3DGraphics" "${ELECTRON_APP_INSTALL_PATH}/blockbench \"\$@\""
	fperms 755 ${ELECTRON_APP_INSTALL_PATH}/blockbench
	npm-utils_install_licenses
}
