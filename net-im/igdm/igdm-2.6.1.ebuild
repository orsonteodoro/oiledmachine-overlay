# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.12"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Desktop application for Instagram DMs "
HOMEPAGE="https://igdm.me/"
SRC_URI="https://github.com/ifedapoolarewaju/igdm/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

MY_PN="IG:dm"

src_compile() {
	PATH="${S}/node_modules/.bin:${PATH}" \
	gulp build
}

src_install() {
	electron-desktop-app-install "*" "" "docs/img/icon.png" "${MY_PN}" "Network"
}
