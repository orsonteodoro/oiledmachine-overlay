# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.10" #workaround
#	 >=dev-util/electron-2.0.12" #real requirement

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Desktop application for Instagram DMs "
HOMEPAGE="https://igdm.me/"
SRC_URI="https://github.com/ifedapoolarewaju/igdm/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

MY_PN="IG:dm"

REQUEST_PROMISE_VER="^4.2.4"

src_unpack() {
	default_src_unpack

	electron-app_src_prepare_default

	sed -i -e "s|\"request-promise\": \"^1.0.2\",|\"request-promise\": \"${REQUEST_PROMISE_VER}\",|" instagram-private-api/package.json

	electron-app_fetch_deps

	# fix vulnerabilities
	pushd node_modules/tough-cookie-filestore
	npm uninstall tough-cookie
	npm install tough-cookie@"^2.3.3" --save || die
	npm install --lock-file
	popd
	pushd node_modules/instagram-private-api
	npm uninstall request-promise
	npm install request-promise@"${REQUEST_PROMISE_VER}" --save || die
	popd
	npm install --lock-file
	npm install --lock-file # it must be done twice for some reason

	electron-app_src_compile
	electron-app_src_preinst_default
}

electron-app_src_compile() {
	PATH="${S}/node_modules/.bin:${PATH}" \
	gulp build
}

src_install() {
	electron-app_desktop_install "*" "docs/img/icon.png" "${MY_PN}" "Network" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/"
}
