# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.10"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="A Github pull request monitoring tool for Mac and Linux"
HOMEPAGE="https://github.com/rkclark/pullp"
SRC_URI="https://github.com/rkclark/pullp/archive/v2.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:$PATH"
	npm run react-build || die
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "public/icons/512x512.png" "${PN}" "Development" "/usr/$(get_libdir)/node/${PN}/${SLOT}/dist/linux-unpacked/pullp"
}
