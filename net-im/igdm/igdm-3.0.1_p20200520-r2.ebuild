# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Desktop application for Instagram DMs "
HOMEPAGE="https://igdm.me/"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="3.1.13"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
inherit eutils desktop electron-app npm-utils
EGIT_COMMIT="728a432efc928110f9a530cebf3494ee1b1266fe"
SRC_URI=\
"https://github.com/igdmapps/igdm/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
MY_PN="IG:dm"

electron-app_src_postprepare() {
	if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL}" == "1" ]] ; then
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=0 per-package-wise."
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
	fi
}

electron-app_src_compile() {
	cd "${S}"

	PATH="${S}/node_modules/.bin:${PATH}" \
	gulp build || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install "*" "docs/img/icon.png" "${MY_PN}" \
	"Network" \
"env PATH=\"${ELECTRON_APP_INSTALL_PATH}/node_modules/.bin:\$PATH\" \
electron ${ELECTRON_APP_INSTALL_PATH}/"
}
