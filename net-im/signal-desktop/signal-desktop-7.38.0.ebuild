# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update use:
# NPM_UPDATER_PROJECT_ROOT="Signal-Desktop-7.36.1" npm_updater_update_locks.sh 7.36.1

# Ignore if error:
# Could not detect abi for version ' + target + ' and runtime ' + runtime + '.  Updating "node-abi" might help solve this issue if it is a new release of ' + runtime)
# https://github.com/signalapp/Signal-Desktop/blob/v7.36.1/CONTRIBUTING.md#known-issues

MY_PN="Signal-Desktop"
MY_PN2="Signal"
NPM_INSTALL_ARGS=( "--prefer-offline" )
NPM_AUDIT_FIX_ARGS=( "--prefer-offline" )

# See
# https://releases.electronjs.org/releases.json
# https://github.com/electron/node-abi/blob/v3.71.0/abi_registry.json
# prebuilt-install depends on node-abi
# Use the newer Electron to increase mitigation with vendor static libs.
ELECTRON_BUILDER_PV="24.13.3"
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer's choice
	ELECTRON_APP_ELECTRON_PV="34.0.0" # Cr 132.0.6834.83, node 20.18.1
else
	# Upstream's choice
	ELECTRON_APP_ELECTRON_PV="33.2.1" # Cr 130.0.6723.137, node 20.18.1
fi
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
NPM_SLOT=3
NODE_VERSION=20 # Upstream uses 20.18.0
NODE_ENV="development"
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS+=( "--force" )
fi
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

inherit electron-app lcnr npm pax-utils unpacker xdg

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
	AGPL-3
"
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	LICENSE+="
		electron-34.0.0-beta.7-chromium.html
	"
else
	LICENSE+="
		electron-33.0.0-beta.9-chromium.html
	"
fi
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="splitdebug binchecks strip"
IUSE+="
wayland X
ebuild-revision-2
"
# RRDEPEND already added from electron-app
RDEPEND+="
	!net-im/signal-desktop-bin
	>=media-fonts/noto-emoji-20231130
	media-libs/libpulse
"
BDEPEND+="
	net-libs/nodejs:${NODE_VERSION}[webassembly(+)]
"

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	enpm run build:acknowledgments
	patch-package --error-on-fail --error-on-warn || die
	enpm run electron:install-app-deps
}

pkg_setup() {
	npm_pkg_setup
}

npm_unpack_post() {
	sed -i -e "s|postinstall|disabled_postinstall|g" "${S}/package.json" || die
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

		sed -i -e "s|postinstall|disabled_postinstall|g" "package.json" || die

		enpm install ${NPM_INSTALL_ARGS[@]}
		enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}

	# Required for custom version bump
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D --prefer-offline

		sed -i -e "s|disabled_postinstall|postinstall|g" "package.json" || die

#einfo "Applying mitigation"

einfo "Copying lockfiles"
		mkdir -p "${WORKDIR}/lockfile-image" || die
		local L=(
			"danger/package-lock.json"
			"sticker-creator/package-lock.json"
			"package-lock.json"
		)
		local x
		for x in ${L[@]} ; do
			local d=$(dirname "${x}")
			mkdir -p "${WORKDIR}/lockfile-image/${d}" || die
			if [[ -e "${d}/package.json" ]] ; then
				cp -av "${d}/package.json" "${WORKDIR}/lockfile-image/${d}" || die
			fi
			if [[ -e "${d}/package-lock.json" ]] ; then
				cp -av "${d}/package-lock.json" "${WORKDIR}/lockfile-image/${d}" || die
			fi
		done

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
}

src_configure() {
	export SIGNAL_ENV="production"
}

src_compile() {
	npm_hydrate

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	# Prevent:
	# fatal: not a git repository (or any of the parent directories): .git
	gen_git_tag "${S}" "v${PV}"

	enpm run build

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		|| die

	# All the node package managers make errors non-fatal.
	# This is why we do these custom checks below.
	grep -q -e "⨯" "${T}/build.log" && die "Detected error"
	[[ -e "dist/linux-unpacked/signal-desktop" ]] || die "Build failed"
}

src_install() {
	insinto "/opt/${MY_PN2}"
	doins -r "dist/linux-unpacked/"*

	local L=(
		"signal-desktop"
		"libffmpeg.so"
		"libGLESv2.so"
		"libvk_swiftshader.so"
		"libEGL.so"
		"chrome-sandbox"
		"libvulkan.so.1"
		"chrome_crashpad_handler"
	)

	local x
	for x in ${L[@]} ; do
		fperms 0755 "/opt/${MY_PN2}/${x}"
	done

	electron-app_gen_wrapper "${MY_PN2,,}" "/opt/${MY_PN2}/signal-desktop"
	electron-app_set_sandbox_suid "/opt/${MY_PN2}/chrome-sandbox"
	pax-mark m "opt/${MY_PN2}/electron" "opt/${MY_PN2}/chrome-sandbox" "opt/${MY_PN2}/chrome_crashpad_handler"

	local sizes=(
		1024
		128
		16
		24
		256
		32
		48
		512
		64
	)

	local x
	for x in ${sizes[@]} ; do
		newicon -s ${x} "build/icons/png/${x}x${x}.png" "${MY_PN2}.png"
	done

	make_desktop_entry \
		"/usr/bin/${MY_PN2,,}" \
		"${MY_PN2}" \
		"${MY_PN2}.png" \
		"Network;InstantMessaging;Chat"

	lcnr_install_files
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For using the tray icon on compatible desktop environments, start Signal with"
	elog " '--start-in-tray' or '--use-tray-icon'."
}
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, electron 34.0.0-beta.5)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, electron 34.0.0-beta.14)
# UI load - pass
