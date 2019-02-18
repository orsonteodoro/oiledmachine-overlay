# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-4.0.5
	 >=dev-lang/typescript-3.2.4"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

COMMIT="ee922919f432f0d22b56b47a9d5d10a875184811"

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
SRC_URI="https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

pkg_setup() {
	ewarn "This is a dev ebuild.  Electron 4.x is not released for Gentoo yet."
}

src_compile() {
	electron-app-build "${S}"
}

src_install() {
	electron-desktop-app-install "*" "" "static/Icon.png" "${PN^}" "Network"
}

pkg_postinst() {
	electron-app-register
}
