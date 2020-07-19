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
inherit desktop electron-app eutils npm-utils
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"

if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
NODE_SASS_V="^4.12.0"
LIBSASS_EXT="auto"

_fix_nodejs12_compatibility() {
	einfo "Updating node-sass to ${NODE_SASS_V}"
	#npm uninstall node-sass || true
	sed -i -e "s|\
\"node-sass\": \"^4.10.0\",|\
\"node-sass\": \"${NODE_SASS_V}\",|g" \
		./package.json || die
	npm install node-sass@"${NODE_SASS_V}" --save-dev || die
}
fi

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
	if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		#_fix_nodejs12_compatibility
		:;
	fi
}

src_install() {
	electron-app_desktop_install "*" "build/icon/icon.png" "${PN^}" \
	"Development" \
	"/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/main.js"
}
