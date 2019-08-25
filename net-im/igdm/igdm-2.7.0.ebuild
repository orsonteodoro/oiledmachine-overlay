# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.10" #workaround
#	 >=dev-util/electron-2.0.12" #real requirement

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Desktop application for Instagram DMs "
HOMEPAGE="https://igdm.me/"
SRC_URI="https://github.com/ifedapoolarewaju/igdm/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

MY_PN="IG:dm"

REQUEST_PROMISE_VER="^4.2.4"
DEBUG_V="^2.6.9"
BABEL_CODE_FRAME_V="^6.26.0"
BABEL_MESSSAGES_V="^6.23.0"
BABEL_RUNTIME_V="^6.26.0"
BABEL_TYPES_V="^6.26.0"
BABEL_GENERATOR_V="^6.26.0"

_fix_vulnerabilities() {
	#pushd node_modules/tough-cookie-filestore || die
	#npm uninstall tough-cookie
	#npm install tough-cookie@"^2.3.3" --save-prod || die
	#npm install --lock-file
	#popd
	pushd node_modules/instagram-private-api || die
	npm uninstall request-promise
	npm install request-promise@"${REQUEST_PROMISE_VER}" --save-prod || die
	popd
	npm install --lock-file
	npm install --lock-file # it must be done twice for some reason

	einfo "Performing recursive package-lock.json audit fix"
	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l)
		[ -e package-lock.json ] && rm package-lock.json
		einfo "Running \`npm i --package-lock-only\`"
		npm i --package-lock-only || die
		einfo "Running \`npm audit fix --force\`"
		npm audit fix --force --maxsockets=${ELECTRON_APP_MAXSOCKETS}
		#npm audit || die
		popd
	done
	einfo "Auditing fix done"

	[ ! -e node_modules/instagram-private-api/node_modules/image-diff/node_modules/gm/package.json ] && die "missing"

	sed -i -e "s|\"debug\": \"~2.2.0\"|\"debug\": \"${DEBUG_V}\"|g" node_modules/instagram-private-api/node_modules/image-diff/node_modules/gm/package.json || die
	pushd ./node_modules/instagram-private-api/node_modules/image-diff/node_modules/gm || die
	npm uninstall debug
	npm install debug@"${DEBUG_V}" --save-prod || die
	popd

	npm_audit_package_lock_update node_modules/instagram-private-api

	# break babel-runtime circular dependency

	npm i babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm i babel-messages@"${BABEL_MESSSAGES_V}" || die
	npm i babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm i babel-types@"${BABEL_TYPES_V}" || die
	npm i babel-generator@"${BABEL_GENERATOR_V}" || die

	npm_audit_package_lock_update node_modules/babel-runtime

	npm dedupe

	#npm_audit_package_lock_update node_modules/babel-traverse

	# has to be done again
	npm_audit_package_lock_update node_modules/babel-runtime

	npm dedupe

	npm_audit_package_lock_update node_modules/babel-types
}

electron-app_src_postprepare() {
	ewarn "The audit may fail unexpectedly.  Re-emerge if it has a connection problem."
	_fix_vulnerabilities
}

electron-app_src_compile() {
	cd "${S}"

	PATH="${S}/node_modules/.bin:${PATH}" \
	gulp build || die
}

src_install() {
	electron-app_desktop_install "*" "docs/img/icon.png" "${MY_PN}" "Network" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
