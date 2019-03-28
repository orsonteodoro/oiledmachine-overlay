# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0" # workaround
#	 >=dev-util/electron-3.0.0" # real requirement

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Autosaving sticky note with support for multiple notes without needing multiple windows. "
HOMEPAGE="https://github.com/fabiospampinato/noty"
SRC_URI="https://github.com/fabiospampinato/noty/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	default_src_unpack

	electron-app_src_prepare_default

	cd "${S}"

	npm install electron@"^${ELECTRON_VER}" --save-dev --verbose --maxsockets=${ELECTRON_APP_MAXSOCKETS} # try to fix io starvation problem (testing)

	einfo "Running electron-app_fetch_deps"
	electron-app_fetch_deps

	# fix brekage
	# breaks with @types/lodash@4.14.123
	# works with 4.14.116
	npm uninstall @types/lodash
	npm install @types/lodash@"<4.14.120" --save-dev || die

	electron-app_src_compile

	cd "${S}"

	# remove from dev list to prevent bad audit
	npm uninstall -D electron-webpack || die

	electron-app_src_preinst_default
}

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-webpack app --env.minify=false || die

	# This is required for compleness and for the program to run properly.
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "resources/icon/icon.png" "${PN^}" "Utility" "/usr/$(get_libdir)/node/${PN}/${SLOT}/releases/linux-unpacked/noty"
}
