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

electron-app_src_postprepare() {
	# likely update breakage
	npm uninstall css-loader
	npm install css-loader@"^0.28.1" --save-dev || die

	npm uninstall webpack-dev-server
	npm install webpack-dev-server@"^2.4.5" --save-dev || die

	npm uninstall electron-builder
	npm install electron-builder@"<20.20.0" --save-dev || die

	npm uninstall electron-updater
	npm install electron-updater@"^2.21.8" --save-prod || die
}

electron-app_src_postcompile() {
	npm uninstall webpack-dev-server -D
	npm uninstall css-loader -D
}

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:$PATH"
	npm run react-build || die
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "public/icons/512x512.png" "${PN}" "Development" "/usr/$(get_libdir)/node/${PN}/${SLOT}/dist/linux-unpacked/pullp"
}
