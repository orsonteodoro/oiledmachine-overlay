# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 dev-util/electron" # workaround
#	 >=dev-util/electron-4.0.5" # real requirements, it is already an internal dependency

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
SRC_URI="https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN^}-${PV}"

TAR_V="^4.4.2"
NODE_SASS_V="^4.12.0"
BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"
BABEL_TRAVERSE_V="^6.26.0"
BABEL_HELPER_FUNCTION_NAME_V="^6.24.1"

pkg_setup() {
	if [[ -z "$LEPTON_CLIENT_ID" || -z "$LEPTON_CLIENT_ID" ]] ; then
		eerror "You must define LEPTON_CLIENT_ID and LEPTON_CLIENT_SECRET in your package.env.  See:"
		eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
		eerror "https://wiki.gentoo.org/wiki//etc/portage/package.env"
		eerror "https://github.com/hackjutsu/Lepton/issues/265"
		die
	fi
	electron-app_pkg_setup
}

electron-app_src_preprepare() {
	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|$LEPTON_CLIENT_ID|" -e "s|<your_client_secret>|$LEPTON_CLIENT_SECRET|" "${S}"/configs/account.js || die
}

_fix_vulnerabilities() {
	npm uninstall node-sass || die
	npm install node-sass@"${NODE_SASS_V}" || die

	npm_install_sub node_modules/node-sass

	sed -i -e "s|\"tar\": \"^2.0.0\",|\"tar\": \"${TAR_V}\",|g" node_modules/node-gyp/package.json || die
	rm -rf node_modules/tar || die
	npm install tar@"${TAR_V}" || die

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die

	npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-runtime
	npm_audit_fix node_modules/babel-template/node_modules/babel-runtime

	# fix circular chain with babel
	npm dedupe || die

	npm install babel-traverse@"${BABEL_TRAVERSE_V}" || die

	npm_audit_package_lock_update node_modules/babel-template
	npm_audit_package_lock_update node_modules/babel-traverse

	npm_audit_fix node_modules/node-sass

	npm install babel-helper-function-name@"${BABEL_HELPER_FUNCTION_NAME_V}" || die

	npm_audit_package_lock_update node_modules/babel-helper-define-map

	npm_audit_package_lock_update node_modules/babel-helper-regex

	npm_audit_package_lock_update node_modules/babel-plugin-transform-es2015-block-scoping

	npm_audit_package_lock_update node_modules/babel-runtime
	npm_audit_fix node_modules/babel-runtime

	# fix circular dependency chain with babel-runtime
	npm dedupe || die

	npm_audit_package_lock_update node_modules/babel-types

	npm_audit_fix ./
}

electron-app_src_postprepare() {
	_fix_vulnerabilities
}

src_install() {
	electron-app_desktop_install "*" "build/icon/icon.png" "${PN^}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/main.js"
}
