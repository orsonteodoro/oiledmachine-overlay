# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-1.6.10"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="GitHub Notifications on your desktop."
HOMEPAGE="https://www.gitify.io/"
SRC_URI="https://github.com/manosim/gitify/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	sed -i -e "s|\"electron\": \"=1.6.10\",|\"electron\": \"^1.6.10\",|g" package.json || die
	sed -i -e "s|\"sass-lint\": \"=1.10.2 -v\",|\"sass-lint\": \"=1.10.2\",|g" package.json || die
	sed -i -e 's|path: process.execPath.match|//path: process.execPath.match|' main.js || die

	electron-app-fetch-deps
}

src_install() {
	cp -a "${FILESDIR}"/app-icon.png images/
	electron-desktop-app-install "*" "" "images/app-icon.png" "${PN^}" "Network"
}
