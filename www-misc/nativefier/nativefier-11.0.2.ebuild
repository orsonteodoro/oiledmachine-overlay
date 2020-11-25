# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Make any web page a desktop application"
HOMEPAGE="https://github.com/jiahaog/nativefier"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE="images-to-icons"
RDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}
	images-to-icons? ( media-gfx/imagemagick )
	>=net-libs/nodejs-10[npm]"
ELECTRON_APP_AT_TYPES_NODE_V="10"
ELECTRON_APP_ELECTRON_V="11.0.2" # See https://github.com/jiahaog/nativefier/blob/v11.0.2/src/constants.ts
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
inherit eutils desktop electron-app npm-utils
SRC_URI=\
"https://github.com/jiahaog/nativefier/archive/v${PV}.tar.gz \
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

electron-app_src_postcompile() {
	# for stopping version lock warning from audit.  production packages
	# installed only.
	npm uninstall gulp -D
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install_program "*"

	exeinto /usr/bin
	cp -a "${FILESDIR}/${PN}" "${T}" || die
	sed -i -e "s|\${SLOT}|${SLOT}|" \
		-e "s|\$(get_libdir)|$(get_libdir)|" \
		-e "s|\${PN}|${PN}|" \
		"${T}/${PN}"
	doexe "${T}/${PN}"

	ewarn \
"${PN} is insecure by design and utilizes some parts of the Chromium code.\n\
Chromium itself has recurrance interval of NVD critical vulnerabilites\n\
between 5 days to ~5 months and high vulunerability advisories with higher\n\
frequency.  This ebuild should be updated weekly with an updated version of\n\
internal Chromium and programs produced by it must be updated weekly."
}
