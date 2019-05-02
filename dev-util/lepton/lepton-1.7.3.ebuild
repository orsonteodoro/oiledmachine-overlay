# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 dev-util/electron" # workaround
#	 >=dev-util/electron-4.0.5" # real requirements, it is already an internal dependency

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
SRC_URI="https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN^}-${PV}"

TAR_V="^4.4.2"

pkg_setup() {
	if [[ -z "$LEPTON_CLIENT_ID" || -z "$LEPTON_CLIENT_ID" ]] ; then
		eerror "You must define LEPTON_CLIENT_ID and LEPTON_CLIENT_SECRET in your package.env.  See:"
		eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
		eerror "https://wiki.gentoo.org/wiki//etc/portage/package.env"
		eerror "https://github.com/hackjutsu/Lepton/issues/265"
		die
	fi
	electron-app_pkg_setup
}

src_unpack() {
	default_src_unpack

	electron-app_src_prepare_default

	cd "${S}"

	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|$LEPTON_CLIENT_ID|" -e "s|<your_client_secret>|$LEPTON_CLIENT_SECRET|" "${S}"/configs/account.js || die

	ELECTRON_APP_INSTALL_AUDIT=0
	electron-app_fetch_deps
	ELECTRON_APP_INSTALL_AUDIT=1

	rm package-lock.json || die
	npm i --package-lock-only
	npm audit fix --force || die

	sed -i -e "s|\"tar\": \"^2.0.0\",|\"tar\": \"${TAR_V}\",|g" node_modules/node-gyp/package.json || die
	rm -rf node_modules/tar || die
	npm install tar@"${TAR_V}" || die

	_electron-app_audit_fix_npm

	cd "${S}"

	electron-app_src_compile_default

	cd "${S}"

	electron-app_src_preinst_default
}

src_install() {
	electron-app_desktop_install "*" "build/icon/icon.png" "${PN^}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/main.js"
}
