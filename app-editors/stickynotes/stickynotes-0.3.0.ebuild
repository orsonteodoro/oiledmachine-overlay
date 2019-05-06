# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app versionator

MY_PN="StickyNotes"

DESCRIPTION="A Sticky Note Application"
HOMEPAGE="https://github.com/Playork/StickyNotes/"
SRC_URI="https://github.com/Playork/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

ELECTRON_V="<5.0.0"

electron-app_src_preprepare() {
	sed -i -e "s|\"electron\": \"latest\",|\"electron\": \"${ELECTRON_V}\",|g" package.json || die
}

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"

	vue-cli-service electron:serve || die
	vue-cli-service electron:build -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "src/assets/logo.png" "${PN}" "Utility" "/usr/$(get_libdir)/node/${PN}/${SLOT}/dist_electron/linux-unpacked/stickynotes"
}
