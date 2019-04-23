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

TAR_V="^4.4.2"
LODASH_V="<4.14.120"
JS_YAML_V="^3.13.1"
MOCHA_V="6.1.4"

src_unpack() {
	default_src_unpack

	electron-app_src_prepare_default

	cd "${S}"

	npm install electron@"^${ELECTRON_VER}" --save-dev --verbose --maxsockets=${ELECTRON_APP_MAXSOCKETS} # try to fix io starvation problem (testing)

	einfo "Running electron-app_fetch_deps"
	export ELECTRON_APP_INSTALL_AUDIT="0"
	electron-app_fetch_deps
	export ELECTRON_APP_INSTALL_AUDIT="1"

	cd "${S}"

	sed -i -e "s|\"tar\": \"^2.0.0\",|\"tar\": \"${TAR_V}\",|g" node_modules/node-gyp/package.json || die

	# fix vulnerabilities
	rm -rf node_modules/tar
	npm install tar@"${TAR_V}" --save-prod || die

	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/app-builder-lib/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/dmg-builder/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.13.0\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/electron-builder-squirrel-windows/node_modules/builder-util/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/electron-updater/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/builder-util/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/read-config-file/package.json || die
	pushd node_modules/postcss-svgo/node_modules/svgo
	npm uninstall js-yaml
	npm install js-yaml@"${JS_YAML_V}" --save-prod || die
	npm install --save-dev mocha@"${MOCHA_V}"
	popd

	# fix brekage
	# breaks with @types/lodash@4.14.123
	# works with 4.14.116
	npm uninstall @types/lodash
	npm install @types/lodash@"${LODASH_V}" --save-dev || die

	_electron-app_audit_fix_npm

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
