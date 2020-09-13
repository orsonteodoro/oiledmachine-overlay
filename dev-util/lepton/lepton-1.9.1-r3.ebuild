# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}
	 dev-libs/libsass"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
SRC_URI="\
https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
ELECTRON_APP_ELECTRON_V="8.4.0"
ELECTRON_APP_REACT_V="16.6.3"
inherit desktop electron-app eutils npm-utils
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"

LIBSASS_EXT="auto"

pkg_setup() {
	if [[ -z "$LEPTON_CLIENT_ID" || -z "$LEPTON_CLIENT_ID" ]] ; then
		eerror \
"You must define LEPTON_CLIENT_ID and LEPTON_CLIENT_SECRET in your\n\
package.env. See:
\n\
https://github.com/hackjutsu/Lepton#client-idsecret\n\
https://wiki.gentoo.org/wiki//etc/portage/package.env\n\
https://github.com/hackjutsu/Lepton/issues/265"
		die
	fi
	electron-app_pkg_setup
}

electron-app_src_preprepare() {
	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|$LEPTON_CLIENT_ID|" \
		-e "s|<your_client_secret>|$LEPTON_CLIENT_SECRET|" \
		"${S}"/configs/account.js || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	electron-app_desktop_install "*" "build/icon/icon.png" "${PN^}" \
	"Development" \
"env PATH=\"${ELECTRON_APP_INSTALL_PATH}/node_modules/.bin:\$PATH\" \
electron ${ELECTRON_APP_INSTALL_PATH}/main.js"
}
