# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app versionator

MY_PN="StickyNotes"
MY_PV="${PV%_*}"
MY_PR="beta.2"

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/Playork/StickyNotes/archive/v${MY_PV}-${MY_PR}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${MY_PV}-${MY_PR}"

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder -l dir || die
}

electron-app_src_install() {
	electron-desktop-app-install "*" "src/assets/logo.png" "${PN}" "Utility" ""
}
