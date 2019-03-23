# Copyright 1999-2019 Gentoo Foundation
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
	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|$LEPTON_CLIENT_ID|" -e "s|<your_client_secret>|$LEPTON_CLIENT_SECRET|" "${S}"/configs/account.js || die
	electron-app_src_unpack
}

src_install() {
	electron-desktop-app-install "*" "build/icon/icon.png" "${PN^}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/main.js"
}
