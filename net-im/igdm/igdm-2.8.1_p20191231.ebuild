# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Desktop application for Instagram DMs "
HOMEPAGE="https://igdm.me/"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.10" #workaround
#	 >=dev-util/electron-2.0.12" #real requirement
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
inherit eutils desktop electron-app npm-utils
EGIT_COMMIT="728a432efc928110f9a530cebf3494ee1b1266fe"
SRC_URI=\
"https://github.com/igdmapps/igdm/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
MY_PN="IG:dm"
REQUEST_PROMISE_VER="^4.2.4"
DEBUG_V="^2.6.9"

electron-app_src_postprepare() {
	ewarn \
"The audit may fail unexpectedly.  Re-emerge if it has a connection problem."

	pushd node_modules/electron-connect || die
		rm package-lock.json
		npm i --package-lock-only
		npm audit fix --force
	popd
	einfo "Running npm_audit_fix_recursive_and_converging"
	npm_audit_fix_recursive_and_converging $(realpath ./)
	einfo "Done running npm_audit_fix_recursive_and_converging"
}

electron-app_src_compile() {
	cd "${S}"

	PATH="${S}/node_modules/.bin:${PATH}" \
	gulp build || die
}

src_install() {
	electron-app_desktop_install "*" "docs/img/icon.png" "${MY_PN}" \
		"Network" "/usr/bin/electron \
		/usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
