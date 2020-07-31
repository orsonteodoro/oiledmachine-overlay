# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Github pull request monitoring tool for Mac and Linux"
HOMEPAGE="https://github.com/rkclark/pullp"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
SRC_URI="\
https://github.com/rkclark/pullp/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="4.1.0"
ELECTRON_APP_REACT_V="16.3.2"
inherit eutils desktop electron-app npm-utils
S="${WORKDIR}/${PN}-${PV}"

if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL}" == "1" ]] ; then

BABEL_CODE_FAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"
BABEL_TRAVERSE_V="^6.26.0"
BABEL_CORE_V="^6.26.0"

ELECTRON_UPDATER_V="4.0.6"
ELECTRON_BUILDER_V="20.41.0"
WEBPACK_DEV_SERVER_V="2.11.5"
CSS_LOADER_V="0.28.1"
JS_YAML_V="^3.13.1"
BRACES_V="^2.3.1"
CHOKIDAR_V="^3.0.2"

_fix_vulnerabilities1() {
	einfo "Running: npm update lodash --depth 4"
	npm update lodash --depth 4 || die

	rm -rf node_modules/svgo/node_modules/js-yaml || die
	sed -i -e "s|\"js-yaml\": \"~3.7.0\",|\"js-yaml\": \"${JS_YAML_V}\",|g" \
		node_modules/svgo/package.json || die

	npm_audit_package_lock_update \
		node_modules/rst-selector-parser/node_modules/registry-auth-token

#	npm_audit_package_lock_update ./

	rm -rf node_modules/rst-selector-parser/node_modules/braces
	sed -i -e "s|\"braces\": \"^1.8.2\",|\"braces\": \"${BRACES_V}\",|g" \
	  node_modules/rst-selector-parser/node_modules/micromatch/package.json || die
	pushd node_modules/rst-selector-parser || die
	npm uninstall braces
	npm install braces@"${BRACES_V}" --save-prod || die
	popd
}

_fix_vulnerabilities2() {
	npm uninstall chokidar
	npm install chokidar@"${CHOKIDAR_V}" || die

	npm audit fix --force || die
}

_fix_vulnerabilities3() {
	pushd node_modules/babel-runtime || die
		npm update debug --depth 4
		npm update lodash --depth 5
		npm audit fix --force || die
		# it has to be done twice for some reason to pass the audit...
		npm update debug --depth 4
		npm update lodash --depth 5
		npm audit fix --force || die
	popd
}

electron-app_src_postprepareA() {
        ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=0 per-package-wise."
	# likely update breakage
	npm uninstall css-loader
	npm install css-loader@"^${CSS_LOADER_V}" --save-dev || die

	npm uninstall webpack-dev-server
	npm install webpack-dev-server@"${WEBPACK_DEV_SERVER_V}" --save-dev || die

	npm uninstall electron-builder
	npm install electron-builder@"${ELECTRON_BUILDER_V}" --save-dev || die

	npm uninstall electron-updater
	npm install electron-updater@"${ELECTRON_UPDATER_V}" --save-prod || die

	npm install babel-code-frame@"${BABEL_CODE_FAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die
	npm install babel-traverse@"${BABEL_TRAVERSE_V}" || die
	npm install babel-core@"${BABEL_CORE_V}" || die

	npm_audit_package_lock_update \
	  node_modules/babel-template/node_modules/babel-traverse

	npm_audit_package_lock_update \
	  node_modules/babel-register/node_modules/babel-core/node_modules/babel-template

	# prevent dependency chain dependency cycle with babel-register
	npm dedupe || die

	npm_audit_package_lock_update node_modules/babel-traverse

	_fix_vulnerabilities1

	npm_audit_package_lock_update \
	  node_modules/rst-selector-parser
	npm_audit_package_lock_update \
	  node_modules/rst-selector-parser/node_modules/babel-template
	npm_audit_package_lock_update \
	  node_modules/rst-selector-parser/node_modules/babel-register

	_fix_vulnerabilities2

	npm_audit_package_lock_update node_modules/babel-types/

	_fix_vulnerabilities3
}

fi

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:$PATH"
	npm run electron:pack || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install "*" "public/icons/512x512.png" "${PN}" "Development" \
	"{ELECTRON_APP_INSTALL_PATH}/dist/linux-unpacked/pullp"
	fperms 0755 \
"{ELECTRON_APP_INSTALL_PATH}/dist/linux-unpacked/pullp"
}
