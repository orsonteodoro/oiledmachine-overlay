# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop electron-app eutils npm-utils

DESCRIPTION="GitHub Notifications Manager & Activity Watcher - Web, Mobile & \
Desktop"
HOMEPAGE="https://devhubapp.com"
LICENSE="AGPL-3"
KEYWORDS="~amd64"
SLOT="0"
MIN_NODE_VERSION=12
RDEPEND+=" >=net-libs/nodejs-${MIN_NODE_VERSION}"
DEPEND+=" ${RDEPEND}
	>=net-libs/nodejs-${MIN_NODE_VERSION}[npm]
	>=sys-apps/yarn-1.13.0"
ELECTRON_APP_MODE=yarn
ELECTRON_APP_ELECTRON_V="11.0.3"
ELECTRON_APP_REACT_NATIVE_V="0.64.0_rc1"
SRC_URI="\
https://github.com/devhubapp/devhub/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"
BABEL_TRAVERSE_V="^6.26.0"
BABEL_TEMPLATE_V="7.4.4"
REACT_NATIVE_V="0.59.8"
BRACES_V="^2.3.1"
RESTRICT="mirror"

pkg_setup() {
	electron-app_pkg_setup
	NODE_VERSION=$(/usr/bin/node --version | sed -e "s|v||g" | cut -f 1 -d ".")
        if (( ${NODE_VERSION} < ${MIN_NODE_VERSION} )) ; then
                echo "NODE_VERSION must be >=${MIN_NODE_VERSION}"
		die "Switch Node.js to >=${MIN_NODE_VERSION}"
        fi
	einfo "Node.js is ${NODE_VERSION}"
}

electron-app_src_postprepare() {
	if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL}" == "1" ]] ; then
        ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=0 per-package-wise."
	einfo "electron-app_src_postprepare START"
	npm install react-native@"${REACT_NATIVE_V}" || die

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die
	npm install babel-traverse@"${BABEL_TRAVERSE_V}" || die

	rm -rf node_modules/babel-template || die

	npm install @babel/template@"${BABEL_TEMPLATE_V}" || die

	npm_audit_package_lock_update node_modules/babel-traverse

	npm_audit_package_lock_update node_modules/babel-runtime

	npm_audit_package_lock_update node_modules/babel-types

	rm -rf node_modules/metro/node_modules/cross-spawn || die
	rm -rf node_modules/metro/node_modules/sane || die
	rm -rf node_modules/metro-core/node_modules/sane || die
	rm -rf node_modules/react-native/node_modules/cross-spawn || die
	rm -rf node_modules/metro/node_modules/sane/node_modules/cross-spawn || die

	rm -rf node_modules/jest-haste-map/node_modules/braces || die

	rm -rf node_modules/metro/node_modules/braces || die
	rm -rf node_modules/metro-core/node_modules/braces || die

	npm_audit_package_lock_update ./

	npm audit fix --force || die

	sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"${BRACES_V}\"|g" \
		node_modules/jest-haste-map/node_modules/micromatch/package.json || die

	pushd node_modules/jest-haste-map || die
	npm i braces@"${BRACES_V}" --no-save || die
	popd

	npm_audit_package_lock_update ./

	npm audit fix --force || die

	sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"${BRACES_V}\"|g" \
		node_modules/metro-core/node_modules/micromatch/package.json || die
	sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"${BRACES_V}\"|g" \
		node_modules/metro/node_modules/micromatch/package.json || die

	rm -rf node_modules/metro/node_modules/braces || die
	rm -rf node_modules/metro-core/node_modules/braces || die

	pushd node_modules/metro || die
	npm i braces@"${BRACES_V}" --no-save || die
	popd

	pushd node_modules/metro-core || die
	npm i braces@"${BRACES_V}" --no-save || die
	popd

	rm package-lock.json || die
	npm i --package-lock-only || die

	einfo "electron-app_src_postprepare DONE"
	fi
}

electron-app_src_compile() {
	einfo "electron-app_src_compile START"
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"

	yarn workspace @devhub/web build || die
	yarn workspace @devhub/desktop build:base || die
	yarn workspace @devhub/desktop build:web:post || die
	yarn workspace @devhub/desktop build:electron --linux dir || die

	cd "${S}"

	einfo "electron-app_src_compile DONE"
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install_program "*"

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"

        newicon "node_modules/@devhub/desktop/assets/icons/icon.png" "${PN}.png"
        make_desktop_entry ${PN} "${MY_PN}" ${PN} "Development"
	fperms 0755 \
"${ELECTRON_APP_INSTALL_PATH}/packages/desktop/build/linux-unpacked/devhub"
}
