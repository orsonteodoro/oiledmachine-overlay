# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Lepton"

NODE_VERSION=14
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${MY_PN}_${PV}_amd64.snap"
ELECTRON_APP_ELECTRON_PV="13.1.2"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="17.0.0"
NODE_ENV="development"
YARN_INSTALL_UNPACK_ARGS="--legacy-peer-deps"
YARN_INSTALL_UNPACK_AUDIT_FIX_ARGS="--legacy-peer-deps"
YARN_INSTALL_PATH="/opt/${PN}"

inherit desktop electron-app lcnr yarn

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
THIRD_PARTY_LICENSES="
	( custom MIT all-rights-reserved keep-copyright-notice )
	( MIT all-rights-reserved )
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

# ( custom MIT all-rights-reserved keep-copyright-notice ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( MIT all-rights-reserved ) - node_modules/string_decoder/LICENSE
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
IUSE=" r3"
REQUIRED_USE="
!wayland X
"
DEPEND+="
	dev-libs/libsass
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/lepton-1.10.0/work/lepton-1.10.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="

"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"
LIBSASS_EXT="auto"

check_credentials() {
	if [[ -z "${LEPTON_CLIENT_ACCOUNT_JS_PATH}" \
		|| ! -f "${LEPTON_CLIENT_ACCOUNT_JS_PATH}" ]] ; then
eerror
eerror "You must define LEPTON_CLIENT_ACCOUNT_JS_PATH as the absolute path to"
eerror "account.js.  A template can be found in the files directory of this"
eerror "ebuild."
eerror
eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
eerror "https://github.com/hackjutsu/Lepton/issues/265"
eerror
		die
	fi
}

pkg_setup() {
	check_credentials
	yarn_pkg_setup
}

__yarn_run() {
	local cmd=( "${@}" )
einfo "Running:\t${cmd[@]}"
	"${cmd[@]}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

__npm_run() {
	local cmd=( "${@}" )
	local tries
	tries=0

	while (( ${tries} < 5 )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\t${cmd[@]}"
		"${cmd[@]}" || die
		if ! grep -q -r -e "ERR_SOCKET_TIMEOUT" "${HOME}/.npm/_logs" ; then
			break
		fi
		rm -rf "${HOME}/.npm/_logs"
		tries=$((${tries} + 1))
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

src_prepare() {
	default
	cat \
		"${LEPTON_CLIENT_ACCOUNT_JS_PATH}" \
		> \
		"${S}/configs/account.js" \
		|| die
}

src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	electron-app_cp_electron
	__yarn_run yarn run build
	__yarn_run electron-builder -l --dir
}

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	newicon "build/icon/icon.png" "${PN}.png"
	make_desktop_entry \
		"${YARN_INSTALL_PATH}/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Development"
	fperms 0755 "${YARN_INSTALL_PATH}/${PN}"
	shred "${S}/configs/account.js"
	electron-app_gen_wrapper \
		"${PN^}" \
		"${YARN_INSTALL_PATH}/${PN}"
	dosym "/usr/bin/${PN^}" "/usr/bin/${PN}"
	LCNR_SOURCE="${WORKDIR}/${PN^}-${PV}"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
