# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Make any web page a desktop application"
HOMEPAGE="https://github.com/jiahaog/nativefier"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}
	>=net-libs/nodejs-10[npm]"
ELECTRON_APP_AT_TYPES_NODE_V="10"
ELECTRON_APP_ELECTRON_V="9.1.0" # See https://github.com/jiahaog/nativefier/blob/v9.1.0/src/constants.ts
inherit eutils desktop npm-secaudit npm-utils
SRC_URI=\
"https://github.com/jiahaog/nativefier/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL}" == "1" ]] ; then

AXIOS_V="^0.18.1"

fix_vulnerabilities() {
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=0 per-package-wise."
	rm package-lock.json || die
	npm i --package-lock-only
	npm audit fix --force
	rm package-lock.json || die
	npm i --package-lock-only

	pushd node_modules/gitcloud || die
		npm uninstall axios
		npm_install_prod axios@"${AXIOS_V}"
	popd
	pushd node_modules/page-icon || die
		npm uninstall axios
		npm_install_prod axios@"${AXIOS_V}"
	popd

	rm package-lock.json || die
	npm i --package-lock-only
}

npm-secaudit_src_postprepare() {
	npm_package_lock_update ./
	fix_vulnerabilities
	npm_update_package_locks_recursive ./
}

fi

npm-secaudit_src_prepare() {
	S="${WORKDIR}/${PN}-${PV}/app" \
	npm-secaudit_fetch_deps

	S="${WORKDIR}/${PN}-${PV}" \
	npm-secaudit_fetch_deps
}

npm-secaudit_src_postcompile() {
	# for stopping version lock warning from audit.  production packages installed only.
	npm uninstall gulp -D
}

src_install() {
	npm-secaudit_install "*"

	# create wrapper
	exeinto /usr/bin
	echo "#!/bin/bash" > "${T}/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${T}/${PN}"
	doexe "${T}/${PN}"
}
