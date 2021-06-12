# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop electron-app npm-utils

DESCRIPTION="Make any web page a desktop application"
HOMEPAGE="https://github.com/nativefier/nativefier"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE+=" images-to-icons"
DEPEND+=" images-to-icons? ( media-gfx/imagemagick )"
BDEPEND+=" >=net-libs/nodejs-12.9[npm]"
ELECTRON_APP_AT_TYPES_NODE_V="12"
ELECTRON_APP_ELECTRON_V="12.0.10" # See https://github.com/nativefier/nativefier/blob/v44.0.2/src/constants.ts
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
SRC_URI=\
"https://github.com/nativefier/nativefier/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

if [[ "${ELECTRON_APP_ALLOW_AUDIT}" == "1" ]] ; then
electron-app_src_postprepare() {
	einfo "Fixing missing package-lock.json"
	npm_package_lock_update ./
}
fi

electron-app_src_prepare() {
	S="${WORKDIR}/${PN}-${PV}/app" \
	electron-app_fetch_deps

	S="${WORKDIR}/${PN}-${PV}" \
	electron-app_fetch_deps
}

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	npm run build || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install_program "*"
	fperms 755 ${ELECTRON_APP_INSTALL_PATH}/nativefier
	electron-app_store_jsons_for_security_audit
	npm-utils_install_licenses

	exeinto /usr/bin
	cp -a "${FILESDIR}/${PN}" "${T}" || die
	sed -i -e "s|\${PN}|${PN}|g" \
		"${T}/${PN}"
	doexe "${T}/${PN}"
}

pkg_postinst() {
	electron-app_pkg_postinst
	ewarn \
"${PN} is insecure by design and utilizes some parts of the Chromium code.\n\
Chromium itself has recurrance interval of NVD critical vulnerabilites\n\
between 5 days to ~5 months and high vulnerability advisories with higher\n\
frequency.  This ebuild should be updated weekly with an updated version of\n\
internal Chromium and programs produced by it must be updated weekly."
	einfo \
"You should add a /etc/portage/bashrc pkg_postinst ebuild phase hook in\n\
order to update all executables produced by this app in order to close\n\
vulnerabilities related to Chromium and its internal dependencies."
}
