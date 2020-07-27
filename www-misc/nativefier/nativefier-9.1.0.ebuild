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
ELECTRON_APP_ELECTRON_V="9.1.0" # See https://github.com/jiahaog/nativefier/blob/v9.1.0/src/constants.ts
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
	# for stopping version lock warning from audit.  production packages installed only.
	npm uninstall gulp -D
}

src_install() {
	electron-app_desktop_install "*"

	# create wrapper
	exeinto /usr/bin
	echo "#!/bin/bash" > "${T}/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${T}/${PN}"
	doexe "${T}/${PN}"
}
