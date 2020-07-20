# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A snippet management app for developers"
HOMEPAGE="https://zerox-dg.github.io/SnippetStoreWeb/"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
RDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="1.8.8" # todo update
ELECTRON_APP_REACT_V="16.3.2"
inherit desktop electron-app eutils npm-utils
MY_PN="SnippetStore"
SRC_URI="\
https://github.com/ZeroX-DG/${MY_PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then

TAR_V="^4.4.2"
BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"

_fix_vulnerabilities() {
	pushd node_modules/node-gyp
	npm uninstall tar
	npm uninstall tar@"${TAR_V}"
	popd
}

electron-app_src_postprepare() {
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX=0 per-package-wise."

	_fix_vulnerabilities

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die

	npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-traverse
	npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-runtime

	# prevent circular dependency chain with babel-runtime -> babel-traverse -> babel-runtime
	npm dedupe || die

	npm_audit_package_lock_update node_modules/babel-polyfill
	npm_audit_package_lock_update node_modules/babel-runtime

	# again, prevent circular dependency chain with babel-runtime -> babel-traverse -> babel-runtime
	npm dedupe || die

	# required again
	npm_audit_package_lock_update node_modules/babel-runtime

	# again and again, prevent circular dependency chain with babel-runtime -> babel-traverse -> babel-runtime
	npm dedupe || die

	npm_audit_package_lock_update node_modules/babel-types
}

fi

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"
	npm run build || die

	rm -rf dist/ # same as `rimraf dist/` in package.json

	# This is required for compleness and for the program to run properly.
	# We deviate since we are not building for other distros.
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "resources/icon/icon512.png" \
		"${MY_PN}" "Development" \
	"/usr/$(get_libdir)/node/${PN}/${SLOT}/dist/linux-unpacked/snippetstore"
}
