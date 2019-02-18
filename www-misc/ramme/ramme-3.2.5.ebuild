# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.3"

DEPEND="${RDEPEND}
	dev-lang/sassc
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Unofficial Instagram Desktop App"
HOMEPAGE="https://github.com/terkelg/ramme"
SRC_URI="https://github.com/terkelg/ramme/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-analytics-tracking"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default

	if ! use analytics-tracking ; then
		epatch "${FILESDIR}"/${PN}-3.2.5-disable-analytics.patch
		rm "${S}"/app/src/main/analytics.js
	fi
}

src_compile() {
	electron-app-build "${S}/app"

	cd "${S}"

	sassc ./app/src/renderer/styles/app.scss > ./app/src/renderer/styles/app.css
	sassc ./app/src/renderer/styles/theme-dark/main.scss > ./app/src/renderer/styles/theme-dark/main.css
}

src_install() {
	electron-desktop-app-install "*" "app/src/main" "media/icon.png" "${PN^}" "Network"

	pushd "${D}"/usr/$(get_libdir)/node/${PN}/${SLOT}/app/
	ln -s src dist
	popd
}

pkg_postinst() {
	electron-app-register "app"
}
