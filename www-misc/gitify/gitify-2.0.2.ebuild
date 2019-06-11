# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-1.6.10"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

DESCRIPTION="GitHub Notifications on your desktop."
HOMEPAGE="https://www.gitify.io/"
SRC_URI="https://github.com/manosim/gitify/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"
BABEL_TRAVERSE_V="^6.26.0"

electron-app_src_preprepare() {
	sed -i -e "s|\"electron\": \"=1.6.10\",|\"electron\": \"^1.6.10\",|g" package.json || die
	sed -i -e "s|\"sass-lint\": \"=1.10.2 -v\",|\"sass-lint\": \"=1.10.2\",|g" package.json || die
	sed -i -e 's|path: process.execPath.match|//path: process.execPath.match|' main.js || die
}

electron-app_src_postprepare() {
	einfo "Entering electron-app_src_postprepare"

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die
	npm install babel-traverse@"${BABEL_TRAVERSE_V}" || die

	npm_audit_package_lock_update node_modules/babel-plugin-transform-es2015-destructuring/node_modules/babel-runtime/node_modules/babel-template

	npm_audit_package_lock_update node_modules/babel-plugin-transform-es2015-destructuring/node_modules/babel-runtime/node_modules/babel-traverse

	npm_audit_package_lock_update node_modules/babel-plugin-transform-es2015-destructuring/node_modules/babel-runtime/node_modules/babel-runtime
	npm_audit_fix node_modules/babel-plugin-transform-es2015-destructuring/node_modules/babel-runtime/node_modules/babel-runtime

	npm_audit_package_lock_update node_modules/babel-plugin-transform-es2015-destructuring/node_modules/babel-runtime/node_modules/babel-runtime/node_modules/babel-template

	# fix circular dependency babel-runtime->babel-runtime
	npm dedupe || die

	npm_audit_package_lock_update node_modules/babel-traverse

	npm_audit_package_lock_update node_modules/babel-polyfill

	npm_audit_package_lock_update node_modules/babel-runtime

	# missing
	#npm_audit_package_lock_update node_modules/babel-plugin-transform-async-to-generator/node_modules/babel-runtime

	npm_audit_package_lock_update node_modules/babel-types

	einfo "Exiting electron-app_src_postprepare"
}

src_install() {
	cp -a "${FILESDIR}"/app-icon.png images/
	electron-app_desktop_install "*" "images/app-icon.png" "${PN^}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
