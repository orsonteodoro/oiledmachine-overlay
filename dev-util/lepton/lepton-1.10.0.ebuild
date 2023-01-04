# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="13.0.0"
ELECTRON_APP_REACT_PV="17.0.0"

inherit desktop electron-app npm-utils

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

KEYWORDS="~amd64"
SLOT="0"
DEPEND+="
	dev-libs/libsass
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	net-libs/nodejs[npm]
"
SRC_URI="
https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"
LIBSASS_EXT="auto"

pkg_setup() {
	if [[ -z "$LEPTON_CLIENT_ID" || -z "$LEPTON_CLIENT_ID" ]] ; then
eerror
eerror "You must define LEPTON_CLIENT_ID and LEPTON_CLIENT_SECRET in your"
eerror "package.env. See:"
eerror
eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
eerror "https://wiki.gentoo.org/wiki//etc/portage/package.env"
eerror "https://github.com/hackjutsu/Lepton/issues/265"
eerror
		die
	fi
	electron-app_pkg_setup
}

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	npm run build || die
	electron-builder -l --dir || die
}

electron-app_src_preprepare() {
	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|$LEPTON_CLIENT_ID|" \
		-e "s|<your_client_secret>|$LEPTON_CLIENT_SECRET|" \
		"${S}"/configs/account.js || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"dist/linux-unpacked/*" \
		"build/icon/icon.png" \
		"${PN^}" \
		"Development" \
		"${ELECTRON_APP_INSTALL_PATH}/${PN}"
	npm-utils_install_licenses
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
