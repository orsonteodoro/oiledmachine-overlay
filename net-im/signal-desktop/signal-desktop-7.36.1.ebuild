# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Signal-Desktop"
NPM_INSTALL_ARGS=( "--prefer-offline" )
NPM_AUDIT_FIX_ARGS=( "--prefer-offline" )

# See https://releases.electronjs.org/releases.json
# Use the newer Electron to increase mitigation with vendor static libs.
ELECTRON_APP_ELECTRON_PV="34.0.0-beta.5" # Cr 132.0.6834.6, node 20.18.0
#ELECTRON_APP_ELECTRON_PV="33.1.0" # Cr 130.0.6723.91, node 20.18.0
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
NPM_SLOT=3
NODE_VERSION=20 # Upstream uses 20.18.0
NODE_ENV="development"
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS+=( "--force" )
fi

inherit electron-app npm pax-utils unpacker xdg

S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/signalapp/Signal-Desktop/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Allows you to send and receive messages of Signal Messenger on your computer"
HOMEPAGE="
	https://signal.org/
	https://github.com/signalapp/Signal-Desktop
"

# electron-34.0.0-beta.5-chromium.html fingerprint is the same as electron-34.0.0-beta.7-chromium.html
# electron-33.1.0-chromium.html fingerprint is the same as electron-33.0.0-beta.9-chromium.html
LICENSE="
	${ELECTRON_APP_LICENSES}
	electron-34.0.0-beta.7-chromium.html
	AGPL-3
"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="splitdebug"
IUSE+=" wayland X"
# RRDEPEND already added from electron-app
RDEPEND+="
	>=media-fonts/noto-emoji-20231130
	media-libs/libpulse
"

QA_PREBUILT="
	opt/Signal/chrome_crashpad_handler
	opt/Signal/chrome-sandbox
	opt/Signal/libEGL.so
	opt/Signal/libGLESv2.so
	opt/Signal/libffmpeg.so
	opt/Signal/libvk_swiftshader.so
	opt/Signal/libvulkan.so.1
	opt/Signal/resources/app.asar.unpacked/node_modules/*
	opt/Signal/signal-desktop
	opt/Signal/swiftshader/libEGL.so
	opt/Signal/swiftshader/libGLESv2.so
"

pkg_setup() {
	npm_pkg_setup
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	#electron-builder \
	#	install-app-deps \
	#	|| die
}

npm_unpack_post() {
	pushd "${S}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/signal-desktop-7.36.1-node-abi-overrides.patch"
	popd >/dev/null 2>&1 || die
	enpm install "node-abi@3.71.0" --prefer-offline
	:
}

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

	# The package contains multiple package-lock.json.
		local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
		export NPM_ENABLE_OFFLINE_MODE=1
		export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${P}"
		einfo "DEBUG:  Default cache folder:  ${HOME}/.npm/_cacache"
		einfo "NPM_ENABLE_OFFLINE_MODE:  ${YARN_ENABLE_OFFLINE_MODE}"
		einfo "NPM_CACHE_FOLDER:  ${NPM_CACHE_FOLDER}"
		rm -rf "${HOME}/.npm/_cacache"
		ln -s "${NPM_CACHE_FOLDER}" "${HOME}/.npm/_cacache" # npm likes to remove the ${HOME}/.npm folder
		addwrite "${EDISTDIR}"
		addwrite "${NPM_CACHE_FOLDER}"
		mkdir -p "${NPM_CACHE_FOLDER}"

		enpm install ${NPM_INSTALL_ARGS[@]}
		enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}

#einfo "Applying mitigation"
		pushd "${S}" >/dev/null 2>&1 || die
			eapply "${FILESDIR}/signal-desktop-7.36.1-node-abi-overrides.patch"
		popd >/dev/null 2>&1 || die
		enpm install "node-abi@3.71.0" --prefer-offline

		grep -e "TypeError:" "${T}/build.log" && die "Detected error.  Retry."
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
	default
	sed \
		-e 's| --no-sandbox||g' \
		-i "usr/share/applications/signal-desktop.desktop" \
		|| die
	unpack "usr/share/doc/signal-desktop/changelog.gz"
}

src_compile() {
	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		|| die
}

src_install() {
	insinto "/"
	dodoc "changelog"
	doins -r "opt"
	insinto "/usr/share"

	doins -r "usr/share/applications"
	doins -r "usr/share/icons"
	fperms +x "/opt/Signal/signal-desktop" "/opt/Signal/chrome-sandbox" "/opt/Signal/chrome_crashpad_handler"
	fperms u+s "/opt/Signal/chrome-sandbox"
	pax-mark m "opt/Signal/signal-desktop" "opt/Signal/chrome-sandbox" "opt/Signal/chrome_crashpad_handler"

	dosym -r "/opt/Signal/${MY_PN}" "/usr/bin/${MY_PN}"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For using the tray icon on compatible desktop environments, start Signal with"
	elog " '--start-in-tray' or '--use-tray-icon'."
}
