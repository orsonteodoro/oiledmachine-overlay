# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO fork @signalapp/libsignal-client for custom hardening
# This ebuild uses AI for synthetic data or estimations.

# To update use:
# PATH=$(realpath "../../scripts")":${PATH}"
# PNPM_UPDATER_PROJECT_ROOT="Signal-Desktop-8.19.0" pnpm_updater_update_locks.sh

# Ignore if error:
# Could not detect abi for version ' + target + ' and runtime ' + runtime + '.  Updating "node-abi" might help solve this issue if it is a new release of ' + runtime)
# https://github.com/signalapp/Signal-Desktop/blob/v8.19.0/CONTRIBUTING.md#known-issues

MY_PN="Signal-Desktop"
MY_PN2="Signal"

# See
# https://releases.electronjs.org/releases.json
# https://github.com/electron/node-abi/blob/v3.71.0/abi_registry.json
# prebuilt-install depends on node-abi
# Use the newer Electron to increase mitigation with vendor static libs.
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
NPM_SLOT="3"
PNPM_AUDIT_FIX_ARG="override" # Avoid [ELIFECYCLE] Command failed.
PNPM_SLOT="9"
NODE_SLOT="24" # Upstream uses 24.14.0 from .nvmrc
NODE_ENV="development"
RUST_MAX_VER="1.91.1" # Inclusive
RUST_MIN_VER="1.91.1" # llvm-21.1.  Rust is required for @swc/core@1.10.16
# https://github.com/rust-lang/rust/commits/main/src/version		# nightly-2024-10-07
# https://github.com/swc-project/swc/blob/v1.10.16/rust-toolchain	# Find date at or before 2024-10-07

RUST_PV="${RUST_MIN_VER}"
#export CI="true" # Avoid error during `pnpm install -P`

inherit secure-version secure-version-node

AT_TYPES_NODE_PV="24.12.0"
ELECTRON_BUILDER_PV="26.11.1"

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer's choice
	ELECTRON_APP_ELECTRON_PV="${ELECTRON_PV}"
else
	# Upstream's choice
	ELECTRON_APP_ELECTRON_PV="42.3.0" # Cr 148.0.7778.180, node 24.15.0
fi

NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)

NPM_DEDUPE_ARGS=(
)

#if [[ "${PNPM_UPDATE_LOCK}" != "1" ]] ; then
#	PNPM_INSTALL_ARGS+=( "--force" )
#fi

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

inherit electron-app lcnr pax-utils pnpm rust unpacker xdg

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

# The electron 37.2.0 license file fingerprint is the same as 37.1.0.
LICENSE="
	${ELECTRON_APP_LICENSES}
	AGPL-3
"
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# The fingerprints of 42.4.0 and 42.2.0 are the same.
	LICENSE+="
		electron-42.2.0-chromium.html
	"
else
	LICENSE+="
		electron-42.3.0-chromium.html
	"
fi
SLOT="0"
#KEYWORDS="-* amd64" # Unfinished update
RESTRICT="splitdebug binchecks strip mirror" # Prevent slow down and snooping
IUSE+="
firejail wayland X
ebuild_revision_80
"
# RRDEPEND already added from electron-app
RDEPEND+="
	!net-im/signal-desktop-bin
	>=media-fonts/noto-emoji-20231130:=
	>=media-libs/libpulse-${LIBPULSE_PV}:=
"
BDEPEND+="
	>=net-libs/nodejs-${NODEJS_24_PV}:${NODE_SLOT}=[webassembly(+)]
	>=sys-apps/pnpm-11:9
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
"
PDEPEND+="
	firejail? (
		sys-apps/firejail
	)
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
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	epnpm run build:acknowledgments
	#patch-package --error-on-fail --error-on-warn || die
	epnpm run electron:install-app-deps
}

pkg_setup() {
	pnpm_pkg_setup
	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	else
eerror "Rust ${RUST_PV} required for @swc/core"
		die
	fi
	electron-app_pkg_setup

	# Prevent error when doing `pnpm audit --fix=update`
	# FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS="--max-old-space-size=4096"
}

pnpm_audit_post() {
einfo "DEBUG:  Fixing audit changes"
einfo "DEBUG:  Deleting old electron changes suggested by pnpm audit --fix"
	sed -i -e "\|23.3.14|d" "${S}/pnpm-workspace.yaml" || die
	sed -i -e "\|28.3.2|d" "${S}/pnpm-workspace.yaml" || die
	sed -i -e "\|35.7.5|d" "${S}/pnpm-workspace.yaml" || die
	sed -i -e "\|38.8.6|d" "${S}/pnpm-workspace.yaml" || die
	sed -i -e "\|39.8.5|d" "${S}/pnpm-workspace.yaml" || die
	sed -i -e "\|patches/fabric|d" "${S}/pnpm-workspace.yaml" || die
}

_apply_patches() {
	[[ "${ALREADY_PATCHED}" == "1" ]] && return
	[[ "${PNPM_UPDATE_LOCK}" == "1" ]] || return
einfo "DEBUG:  Called pnpm_unpack_post()"
	eapply "${FILESDIR}/${PN}-8.19.0-pnpm-workspace-changes.patch"
#einfo "DEBUG:  Applying sed based patches..."
#	sed -i -e "s|postinstall|disabled_postinstall|g" "${S}/package.json" || die
#	sed -i -e "s|minimumReleaseAgeStrict: true|minimumReleaseAgeStrict: false|g" "${S}/pnpm-workspace.yaml" || die
#	sed -i -e "\|minimumReleaseAge:|d" "${S}/pnpm-workspace.yaml" || die
	ALREADY_PATCHED=1
}

pnpm_unpack_post() {
	_apply_patches
}

src_unpack() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		pnpm_hydrate
		unpack "${P}.tar.gz"
		cd "${S}" || die

		_apply_patches

	# The package contains multiple pnpm-lock.yaml.
		local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
		export PNPM_ENABLE_OFFLINE_MODE=1
		export PNPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${PNPM_SLOT}/${CATEGORY}/${P}"
		einfo "DEBUG:  Default cache folder:  ${HOME}/.npm/_cacache"
		einfo "PNPM_ENABLE_OFFLINE_MODE:  ${YARN_ENABLE_OFFLINE_MODE}"
		einfo "PNPM_CACHE_FOLDER:  ${PNPM_CACHE_FOLDER}"
		rm -rf "${HOME}/.npm/_cacache"
		mkdir -p "${HOME}/.npm" || die
		ln -s "${PNPM_CACHE_FOLDER}" "${HOME}/.npm/_cacache" # npm likes to remove the ${HOME}/.npm folder
		addwrite "${EDISTDIR}"
		addwrite "${PNPM_CACHE_FOLDER}"
		mkdir -p "${PNPM_CACHE_FOLDER}"

		#epnpm install "${PNPM_INSTALL_ARGS[@]}"

		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect attack)
		# VS = Vulnerable System (Direct attack)
		# ZC = Zero Click Attack (AV:N, PR:N, UI:N)
		# RCE = Remote Code Execution

ewarn "QA:  Manually remove picomatch@2.3.1 in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove jws@3.2.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change jws@3.2.2 to jws@3.2.3 from ${S}/package.json and ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove patch-package from ${S}/package.json and ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-paginate-rest@9.2.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2 to 11.4.4-cjs.2 in ${S}/pnpm-lock.yaml and in ${S}/package.json"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2(@octokit/core@5.2.2) to 11.4.4-cjs.2(@octokit/core@5.2.2) in ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove picomatch@2.3.1 from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove immutable@4.3.7 from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove @remix-run/router@1.23.1 from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove @remix-run/router@1.5.0 from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove ajv@6.12.6 from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove react-router@6.10.0 from ${S}/sticker-creator/pnpm-lock.yaml"

ewarn "QA:  Manually remove jws@3.2.2 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove picomatch@2.3.1 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove qs@6.14.0 from ${S}/danger/pnpm-lock.yaml"

	# The brace-expansion version changes breaks build.
	# The pinned version of fabric is required.
	# The pinned version of minimatch is required.

einfo "DEBUG: A"
		epnpm audit --fix=${PNPM_AUDIT_FIX_ARG}
einfo "DEBUG: B"
		pnpm_audit_post

		local deps=()
		pushd "sticker-creator" >/dev/null 2>&1 || die
			deps=(
			)
			#epnpm install "${deps[@]}" -P "${PNPM_INSTALL_ARGS[@]}"
			deps=(
			)
			#epnpm install "${deps[@]}" -D "${PNPM_INSTALL_ARGS[@]}"
		popd >/dev/null 2>&1 || die

		pushd "danger" >/dev/null 2>&1 || die
			deps=(
			)
			#epnpm install "${deps[@]}" -P "${PNPM_INSTALL_ARGS[@]}"
		popd >/dev/null 2>&1 || die

		deps=(
		)
		#epnpm install "${deps[@]}" -P "${PNPM_INSTALL_ARGS[@]}"
		deps=(
		)
		#epnpm install "${deps[@]}" -D "${PNPM_INSTALL_ARGS[@]}"

		epnpm audit --fix=${PNPM_AUDIT_FIX_ARG} "${PNPM_AUDIT_FIX_ARGS[@]}" || true
		pnpm_audit_post

		deps=(
	# Required for custom version bump
			#"electron@${ELECTRON_APP_ELECTRON_PV}"
		)
		#epnpm install "${deps[@]}" -D -w "${PNPM_INSTALL_ARGS[@]}"

		#epnpm dedupe

	# Re-add missing dependencies
		pushd "danger" >/dev/null 2>&1 || die
			deps=(
			)
			#epnpm install "${deps[@]}" -P "${PNPM_INSTALL_ARGS[@]}"
		popd >/dev/null 2>&1 || die

		sed -i -e "s|disabled_postinstall|postinstall|g" "package.json" || die


einfo "Copying lockfiles"
		mkdir -p "${WORKDIR}/lockfile-image" || die
		local LOCKFILES_NPM=(
			"danger/package-lock.json"
			"sticker-creator/package-lock.json"
			"package-lock.json"
		)
		local LOCKFILES_PNPM=(
			"danger/pnpm-lock.yaml"
			"pnpm-lock.yaml"
			"sticker-creator/pnpm-lock.yaml"
		)
		local x
		for x in "${LOCKFILES_PNPM[@]}" ; do
			local d=$(dirname "${x}")
			mkdir -p "${WORKDIR}/lockfile-image/${d}" || die
			if [[ -e "${d}/package.json" ]] ; then
				cp -av "${d}/package.json" "${WORKDIR}/lockfile-image/${d}" || die
			fi
			if [[ -e "${d}/pnpm-lock.yaml" ]] ; then
				cp -av "${d}/pnpm-lock.yaml" "${WORKDIR}/lockfile-image/${d}" || die
			fi
		done
		cp -av "pnpm-workspace.yaml" "${WORKDIR}/lockfile-image" || die

		grep -e "TypeError:" "${T}/build.log" && die "Detected error.  Retry."
		#_pnpm_check_errors
einfo "Updating lockfile done."
		exit 0
	else
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		export ELECTRON_CUSTOM_DIR="v${ELECTRON_APP_ELECTRON_PV}"
		pnpm_src_unpack
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
	pnpm_hydrate

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	# Prevent:
	# fatal: not a git repository (or any of the parent directories): .git
	gen_git_tag "${S}" "v${PV}"

	epnpm run "build:emoji-data"
	epnpm run "build-linux"

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l "dir" \
		|| die

	# All the node package managers make errors non-fatal.
	# This is why we do these custom checks below.
#	grep -q -e "⨯" "${T}/build.log" && die "Detected error"
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
	for x in "${L[@]}" ; do
		fperms 0755 "/opt/${MY_PN2}/${x}"
	done

	electron-app_gen_wrapper "${PN}" "/opt/${MY_PN2}/signal-desktop"
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
		"${PN}" \
		"${MY_PN2}" \
		"${MY_PN2}.png" \
		"Network;InstantMessaging;Chat"

#	lcnr_install_files
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For using the tray icon on compatible desktop environments, start Signal with"
	elog " '--start-in-tray' or '--use-tray-icon'."
}
# OILEDMACHINE-OVERLAY-TEST:  passed (8.14.0, 20260610, Electron 42.4.0 with Firejail and GPU acceleration off hardening)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.11.0, 20260525, Electron 42.2.0, Node (build-time): 24.16.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.8.0, 20250504, Electron 41.5.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.8.0, 20250501, Electron 41.4.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.7.0, 20250422, Electron 41.2.2) with updated lockfile to reduce the attack surface
# OILEDMACHINE-OVERLAY-TEST:  passed (8.7.0, 20250421, Electron 41.2.2)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.7.0, 20250419, Electron 41.2.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.4.1, 20260331, Electorn 41.1.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.2.1, 20260318, Electron 41.0.3)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.0.0, 20260304, Electron 40.7.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (8.0.0, 20260226, Electron 40.6.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.90.0, 20260225, Electron 40.6.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.73.0, 20251003, Electron 38.2.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.64.0, 20250807, Electron 37.2.6)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.60.0, 20250704, Electron 37.2.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.59.0, 20250701, Electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.46.0, 20250313, Electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.45.1, 20250311, Electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.44.0, 20250227, Electron 35.0.0-beta.11)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.42.0, 20250214, Electron 35.0.0-beta.6)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.41.0, 20250116, Electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.41.0, 20250207, Electron 35.0.0-beta.3)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.40.1, 20250205, Electron 35.0.0-beta.2)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, Electron 34.0.0-beta.5)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, Electron 34.0.0-beta.14)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.38.0, 20250116, Electron 34.0.0)
# UI load - pass
