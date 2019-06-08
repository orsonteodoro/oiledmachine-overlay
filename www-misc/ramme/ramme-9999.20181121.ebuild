# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.3
	 sys-apps/yarn"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

COMMIT="ee922919f432f0d22b56b47a9d5d10a875184811"

DESCRIPTION="Unofficial Instagram Desktop App"
HOMEPAGE="https://github.com/terkelg/ramme"
SRC_URI="https://github.com/terkelg/ramme/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-analytics-tracking"

S="${WORKDIR}/${PN}-${COMMIT}"

ELECTRON_APP_INSTALL_AUDIT=0

TAR_V="^4.4.2"
UNDERSCORE_STRING_V="^3.3.5"
GULP_CLI_V="2.0.1"
HOEK_V="<5.0.0"
JS_YAML_V="^3.13.1"
LODASH_V="^4.17.11"
GULP_BABEL_V="<7.0.0"
BABEL_CORE_V="^6.26.0"
BABEL_RUNTIME_V="^6.26.0"

_patch_caw() {
	local path="$1"
	pushd "${path}" || die
	patch -p1 -i "${FILESDIR}/caw-1.2.0-replace-tunnel-agent-with-node-tunnel.patch" || die
	cd ../..
	npm install || die
	popd
}

_fix_vulnerabilities() {
	cd "${S}"

	npm audit fix --force

	rm -rf node_modules/zopflipng-bin/node_modules/tunnel-agent || die
	rm -rf node_modules/guetzli/node_modules/tunnel-agent || die

	#_patch_caw node_modules/guetzli/node_modules/caw # not found
	#_patch_caw node_modules/zopflipng-bin/node_modules/caw

	# sshpk is for deep dependency of gulp-sass
	npm install sshpk@"^1.14.1" --save-dev || die

	npm_install_sub node_modules/node-sass

	sed -i -e "s|\"tar\": \"^2.0.0\",|\"tar\": \"${TAR_V}\",|g" node_modules/node-sass/node_modules/node-gyp/package.json || die
	rm -rf node_modules/tar || die
	npm install tar@"${TAR_V}" --no-save || die

	pushd node_modules/micromatch
		npm install underscore.string@"${UNDERSCORE_STRING_V}" || die
	popd

	electron-app_audit_fix

	#sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_V}\"|g" node_modules/zopflipng-bin/node_modules/upath/package.json || die
	sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_V}\"|g" node_modules/upath/package.json || die
	#sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_V}\"|g" node_modules/guetzli/node_modules/upath/package.json || die
}

electron-app_src_preprepare() {
	einfo "electron-app_src_preprepare"
	cd "${S}"

	if ! use analytics-tracking ; then
		epatch "${FILESDIR}"/${PN}-3.2.5-disable-analytics.patch
		rm "${S}"/app/src/main/analytics.js
	fi

	npm install yarn --save-dev || die
	pushd node_modules/micromatch/ || die
	npm install braces@"^2.3.2" --save-prod || die
	popd
}

electron-app_src_prepare() {
	S="${WORKDIR}/${PN}-${COMMIT}/app" \
	electron-app_fetch_deps

	S="${WORKDIR}/${PN}-${COMMIT}/" \
	electron-app_fetch_deps
}

electron-app_src_postprepare() {
	einfo "electron-app_src_postprepare START"
	_fix_vulnerabilities

	# fix breakage from update
	npm uninstall gulp-babel
	npm install gulp-babel@"${GULP_BABEL_V}" --save-dev || die
	npm install gulp-header --save-dev || die
	npm install babel-register --save-dev || die

	# babel-* circular dependency exist here

	npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-traverse/node_modules/babel-runtime

	npm dedupe

	npm install babel-core@"${BABEL_CORE_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die

	npm_audit_package_lock_update node_modules/babel-register
	npm_audit_package_lock_update node_modules/babel-runtime

	# fix cirular dependency here
	npm dedupe

	# must do again for some reason
	npm_audit_package_lock_update node_modules/babel-runtime

	# fix cirular dependency again for some reason
	npm dedupe

	einfo "electron-app_src_postprepare DONE"
}

electron-app_src_compile() {
	einfo "electron-app_src_compile"
	cd "${S}"

	electron-app_src_compile_default

	cd "${S}"

	npm uninstall yarn || die
	einfo "electron-app_src_compile DONE"
}

src_install() {
	electron-app_desktop_install "*" "media/icon.png" "${PN^}" "Network" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/app"
	einfo "This program has login issues but still works as of Mar 12 2019."
	einfo "You may need to close it several times to get it to show the feed."
}
