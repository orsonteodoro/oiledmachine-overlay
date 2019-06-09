# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0" # workaround
#	 >=dev-util/electron-3.0.0" # real requirement

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Autosaving sticky note with support for multiple notes without needing multiple windows. "
HOMEPAGE="https://github.com/fabiospampinato/noty"
COMMIT="33d273ff432d480377cb536665ae034904be38bd"
SRC_URI="https://github.com/fabiospampinato/noty/archive/33d273ff432d480377cb536665ae034904be38bd.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${COMMIT}"

TAR_V="^4.4.2"
LODASH_V="<4.14.120"
JS_YAML_V="^3.13.1"
MOCHA_V="6.1.4"
BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"

electron-app_src_preprepare() {
	npm install electron@"^${ELECTRON_VER}" --save-dev --verbose --maxsockets=${ELECTRON_APP_MAXSOCKETS} # try to fix io starvation problem (testing)
}

_fix_vulnerabilities() {
	cd "${S}"

	sed -i -e "s|\"tar\": \"^2.0.0\",|\"tar\": \"${TAR_V}\",|g" node_modules/node-gyp/package.json || die

	# fix vulnerabilities
	rm -rf node_modules/tar
	npm install tar@"${TAR_V}" --save-prod || die

	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/app-builder-lib/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.1\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/dmg-builder/package.json || die
	#sed -i -e "s|\"js-yaml\": \"^3.13.0\",|\"js-yaml\": \"${JS_YAML_V}\",|g" node_modules/electron-builder-squirrel-windows/node_modules/builder-util/package.json || die
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
}

electron-app_src_postprepare()
{
	_fix_vulnerabilities

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die

	npm_audit_package_lock_update node_modules/babel-runtime/node_modules/babel-template/node_modules/babel-traverse
	npm_audit_fix node_modules/postcss-svgo/node_modules/svgo

	npm_audit_package_lock_update node_modules/babel-runtime
	npm_audit_fix node_modules/babel-runtime

	# fix circular dependency chain
	npm dedupe || die

	npm install babel-traverse@"${BABEL_TRAVERSE_V}" || die
	npm_audit_package_lock_update node_modules/babel-template

	npm_audit_package_lock_update node_modules/babel-traverse

	npm_audit_package_lock_update node_modules/babel-types
}

electron-app_src_postcompile() {
	# remove from dev list to prevent bad audit
	npm uninstall -D electron-webpack || die
}

electron-app_src_prepare() {
	electron-app_fetch_deps
	# defer audit
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
