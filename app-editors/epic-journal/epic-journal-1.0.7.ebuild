# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-1.7.5"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

MY_PN="Epic Journal"

DESCRIPTION="A clean and modern encrypted journal/diary app"
HOMEPAGE="https://epicjournal.xyz/"
SRC_URI="https://github.com/alangrainger/epic-journal/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-NC-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-v.${PV}"

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	node .electron-vue/build.js || die
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "build/icons/256x256.png" "${MY_PN}" "Office" "cd /usr/$(get_libdir)/node/${PN}/${SLOT}/ && /usr/bin/electron ./dist/electron/main.js"
}
