# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}"
# actual requirement:
#	 >=dev-util/electron-4.0.6

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

DESCRIPTION="A notification and insights app for stock markets"
HOMEPAGE="https://samyakjain.me/Stockifier/"
COMMIT="f126ee746f1986a20b9b0ef70ac0a6be995d113d"
SRC_URI="https://github.com/jainsamyak/Stockifier/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN^}-${COMMIT}"

electron-app_src_compile() {
	einfo "electron-app_src_compile"
	cd "${S}"

	npm run build-linux || die

	cd "${S}"

	einfo "electron-app_src_compile DONE"
}

src_install() {
	electron-app_desktop_install "*" "res/Stockifier.png" "${PN^}" "Office;Finance" "/usr/$(get_libdir)/node/${PN}/${SLOT}/dist/Stockifier-linux-x64/Stockifier"
}

pkg_postinst() {
	electron-app_pkg_postinst

	einfo "You need an API key from: https://www.alphavantage.co/support/#api-key"
}
