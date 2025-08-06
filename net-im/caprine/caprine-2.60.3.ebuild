# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Security bump electron every week

MY_PN="${PN^}"

#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${PN}_${PV}_amd64.snap"
# See https://releases.electronjs.org/releases.json for version details.
# The preferred nightly does not have prebuilt.
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="37.2.6" # Cr 138.0.7204.185, node 22.17.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="29.0.1" # Cr 122.0.6261.57, node 20.9.0
fi
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
ELECTRON_APP_TYPESCRIPT_PV="5.4.4"
NODE_ENV="development"
NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)
NPM_INSTALL_PATH="/opt/${PN}"
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS+=( "--force" )
fi
NODE_VERSION=20 # Upstream uses 20.11.1

inherit desktop electron-app lcnr npm

SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="
	${ELECTRON_APP_LICENSES}
	electron-37.1.0-chromium.html
	MIT
"
# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67
RESTRICT="mirror"
SLOT="0"
# Deps based on their CI
IUSE+="
	firejail
	ebuild_revision_14
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}[webassembly(+)]
	>=net-libs/nodejs-16[npm,webassembly(+)]
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[X?,firejail_profiles_caprine]
	)
"

pkg_setup() {
	npm_pkg_setup
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder \
		install-app-deps \
		|| die
}

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

		rm -vf package-lock.json
		enpm install ${NPM_INSTALL_ARGS[@]}
		enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}

einfo "Applying mitigation"
		patch_edits() {
			sed -i -e "s|\"got\": \"^11.8.0\"|\"got\": \"^11.8.5\"|g" \
				"package-lock.json" \
				|| die
			sed -i -e "s|\"got\": \"^9.6.0\"|\"got\": \"^11.8.5\"|g" \
				"package-lock.json" \
				|| die
		}
		patch_edits

	# DT = Data Tampering
		enpm install "got@^11.8.5" -P ${NPM_INSTALL_ARGS[@]}					# DT		# CVE-2022-33987
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D ${NPM_INSTALL_ARGS[@]}

		patch_edits

		_npm_check_errors
einfo "Updating lockfile done."
		exit 0
	else
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		npm_src_unpack
		get_deps
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.60.3-app-dock-optional-chaining.patch"
	eapply_user
}

src_compile() {
	cd "${S}" || die
	chmod +x "${S}/node_modules/electron/install.js" || die
	tsc || die

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		|| die
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "static/Icon.png" "${PN}.png"
	make_desktop_entry \
		"${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Network"
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/${PN}"
	lcnr_install_files
	electron-app_set_sandbox_suid "/opt/caprine/chrome-sandbox"
}

pkg_postinst() {
einfo
einfo "If you see"
einfo
einfo "  \"Config schema violation: vibrancy should be string; \
vibrancy should be equal to one of the allowed values,\""
einfo
einfo "then you may need to run \`rm -rf ~/.config/Caprine\`"
einfo
	electron-app_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20240924)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20241009 with Electron 33.0.0-beta.9)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.1, 20241031 with Electron 34.0.0-alpha.5)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.2, 20241130 with Electron 34.0.0-alpha.7)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.3, 20241206 with Electron 34.0.0-beta.14)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.3, 20250116 with Electron 34.0.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.3, 20250228 with Electron 35.0.0-beta.11)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.3, 20250311 with Electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (2.60.3, 20250629 with Electron 37.1.0)
