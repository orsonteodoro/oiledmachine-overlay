# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.3"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

COMMIT="ee922919f432f0d22b56b47a9d5d10a875184811"

DESCRIPTION="Unofficial Instagram Desktop App"
HOMEPAGE="https://github.com/terkelg/ramme"
SRC_URI="https://github.com/terkelg/ramme/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-analytics-tracking"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	if ! use analytics-tracking ; then
		epatch "${FILESDIR}"/${PN}-3.2.5-disable-analytics.patch
		rm "${S}"/app/src/main/analytics.js
	fi

	# fix stall bug in sandbox
	sed -i -e "s|\"electron\": \"\^[0-9.]*\",||g" package.json || die

	npm install yarn || die
	electron-app_src_prepare
}

src_compile() {
	electron-app_src_compile
	npm uninstall yarn || die
	cd "${S}/app"
	npm install electron-config || die
}

src_install() {
	electron-desktop-app-install "*" "media/icon.png" "${PN^}" "Network" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/app"
}
