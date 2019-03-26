# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-lang/typescript-3.2.4"
#	 >=dev-util/electron-4.0.5
# electron requirements are only necessary if you don't use the electron-builder

DEPEND="${RDEPEND}
        >=net-libs/nodejs-10[npm]"

inherit eutils desktop electron-app

COMMIT="ee922919f432f0d22b56b47a9d5d10a875184811"

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
SRC_URI="https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

electron-app_src_compile() {
	cd "${S}"

	PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}/node_modules/.bin:$PATH" \
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "static/Icon.png" "${PN^}" "Network" "PATH=\"/usr/$(get_libdir)/node/${PN}/${SLOT}/node_modules/.bin:\$PATH\" electron /usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
