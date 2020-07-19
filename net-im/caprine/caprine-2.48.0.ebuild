# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
DEPEND="${RDEPEND}
	>=dev-lang/typescript-3.9.5
        >=net-libs/nodejs-12[npm]"
ELECTRON_APP_ELECTRON_V="9.0.5"
inherit desktop electron-app eutils
SRC_URI=\
"https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
RESTRICT="mirror"

electron-app_src_compile() {
	cd "${S}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	tsc || die
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "static/Icon.png" "${PN^}" "Network" \
"PATH=\"/usr/$(get_libdir)/node/${PN}/${SLOT}/node_modules/.bin:\
\$PATH\" electron /usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
