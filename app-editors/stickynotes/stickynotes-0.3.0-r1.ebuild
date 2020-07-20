# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Sticky Note Application"
HOMEPAGE="https://github.com/Playork/StickyNotes/"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="9.1.0" # actually it is always latest
ELECTRON_APP_VUE_V="2.6.11" # always latest.  See https://www.npmjs.com/package/vue
inherit desktop electron-app eutils
MY_PN="StickyNotes"
SRC_URI=\
"https://github.com/Playork/${MY_PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"

	vue-cli-service electron:serve || die
	vue-cli-service electron:build -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "src/assets/logo.png" "${PN}" \
		"Utility" \
"/usr/$(get_libdir)/node/${PN}/${SLOT}/dist_electron/linux-unpacked/stickynotes"
}
