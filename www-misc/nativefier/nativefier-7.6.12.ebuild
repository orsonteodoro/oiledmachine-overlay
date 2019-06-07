# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 dev-util/electron"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop npm-secaudit

DESCRIPTION="Make any web page a desktop application"
HOMEPAGE="https://github.com/jiahaog/nativefier"
SRC_URI="https://github.com/jiahaog/nativefier/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

_npm_install_sub() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	npm install
	[ -e package-lock.json ] && rm package-lock.json
	npm i --package-lock-only
	popd
}

_npm_audit_package_lock_update() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	# audit fix may fail on dependency but that is okay.  the eclass does another audit pass.
	npm audit fix --force > /dev/null
	rm package-lock.json
	npm i --package-lock-only
	popd
}

_npm_audit_fix() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	npm audit fix --force
	popd
}

npm-secaudit_src_prepare() {
	S="${WORKDIR}/${PN}-${PV}/app" \
	npm-secaudit_fetch_deps

	S="${WORKDIR}/${PN}-${PV}" \
	npm-secaudit_fetch_deps
}

npm-secaudit_src_postprepare() {
	# fix breakage caused by npm audix fix --force
	npm uninstall gulp
	npm install gulp@"<4.0.0" --save-dev || die

	npm install babel-code-frame@"${BABEL_CODE_FRAME_V}" || die
	npm install babel-messages@"${BABEL_MESSAGES_V}" || die
	npm install babel-runtime@"${BABEL_RUNTIME_V}" || die
	npm install babel-types@"${BABEL_TYPES_V}" || die
	npm install babel-generator@"${BABEL_GENERATOR_V}" || die

	_npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-traverse
	_npm_audit_package_lock_update node_modules/babel-template/node_modules/babel-runtime

	# stop circular chain
	npm dedupe

	_npm_audit_package_lock_update node_modules/babel-runtime

	# stop circular chain again
	npm dedupe

	_npm_audit_fix node_modules/babel-runtime

	# stop circular chain again
	npm dedupe

	_npm_audit_package_lock_update node_modules/babel-types
	_npm_audit_fix node_modules/babel-types

	_npm_audit_package_lock_update node_modules/babel-types/node_modules/babel-runtime
	_npm_audit_fix node_modules/babel-types/node_modules/babel-runtime

	# stop circular chain again
	npm dedupe
}

npm-secaudit_src_postcompile() {
	# for stopping version lock warning from audit.  production packages installed only.
	npm uninstall gulp -D
}

src_install() {
	npm-secaudit_install "*"

	# create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}
}
