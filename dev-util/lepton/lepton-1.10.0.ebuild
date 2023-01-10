# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION=14
ELECTRON_APP_ELECTRON_PV="13.1.2"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="17.0.0"
NODE_ENV="development"

inherit desktop electron-app npm-utils

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
THIRD_PARTY_LICENSES="
	( MIT all-rights-reserved )
	( MIT all-rights-reserved keep-copyright-notice )
	( WTFPL-2 ISC )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-3.0
	ISC
	MIT
	MIT CC0-1.0
	PSF-2.4
	Unlicense
	|| ( Apache-2.0 MPL-2.0 )
"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( MIT all-rights-reserved ) - node_modules/string_decoder/LICENSE
# ( MIT all-rights-reserved keep-copyright-notice ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( WTFPL-2 ISC ) - node_modules/sanitize-filename/LICENSE.md
# 0BSD - node_modules/tslib/CopyrightNotice.txt
# Apache-2.0
# BSD
# BSD-2
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# ISC
# MIT
# MIT CC0-1.0 - node_modules/lodash.sortby/LICENSE
# PSF-2.4  - node_modules/argparse/LICENSE
# Unlicense - node_modules/tweetnacl/LICENSE
# || ( Apache-2.0 MPL-2.0 ) - node_modules/dompurify/LICENSE

KEYWORDS="~amd64"
SLOT="0"
IUSE=" r2"
DEPEND+="
	dev-libs/libsass
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	sys-apps/yarn
"
SRC_URI="
https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"
LIBSASS_EXT="auto"

pkg_setup() {
#
# This is why emerge needs an API or procedure for sensitive data.
#
# It is possible to save these datas in environment.bz2 across other prior
# ebuilds.
#
ewarn
ewarn "Do not provide LEPTON_CLIENT_ID or LEPTON_CLIENT_SECRET if multiple"
ewarn "ebuilds are being emerged prior to ${PN}.  It should be the only"
ewarn "ebuild package to pass on this data."
ewarn
ewarn "After being built, this information provided via package.env or"
ewarn "by patch should be sanitized from forensics attacks."
ewarn
	sleep 30
	if [[ -z "${LEPTON_CLIENT_ID}" || -z "${LEPTON_CLIENT_SECRET}" ]] ; then
eerror
eerror "You must define LEPTON_CLIENT_ID and LEPTON_CLIENT_SECRET"
eerror "as environment variable."
eerror
eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
eerror "https://github.com/hackjutsu/Lepton/issues/265"
eerror
		die
	fi
	electron-app_pkg_setup
}

sanitize_variables() {
	export LEPTON_CLIENT_ID=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export LEPTON_CLIENT_SECRET=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
}

vrun() {
einfo "Running:\t${@}"
	"${@}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

electron-app_src_preprepare() {
	cp "${FILESDIR}"/account.js "${S}"/configs || die
	sed -i -e "s|<your_client_id>|${LEPTON_CLIENT_ID}|" \
		-e "s|<your_client_secret>|${LEPTON_CLIENT_SECRET}|" \
		"${S}"/configs/account.js || die

	sanitize_variables

	unset LEPTON_CLIENT_ID
	unset LEPTON_CLIENT_SECRET
}

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	vrun yarn run build
	vrun electron-builder -l --dir
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"dist/linux-unpacked/*" \
		"build/icon/icon.png" \
		"${PN^}" \
		"Development" \
		"${ELECTRON_APP_INSTALL_PATH}/${PN}"
	LCNR_SOURCE="${WORKDIR}/Lepton-${PV}"
	npm-utils_install_licenses
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
	shred "${S}"/configs/account.js
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
