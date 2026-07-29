# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  Replace prebuilt node sharp with source based build of node sharp

# FIXME:
# Error occurred in handler for 'downloadingOllama': download-failed

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="1.0.0_beta12" npm_updater_update_locks.sh

MY_PN="LLocal"
MY_PV="${PV/_beta/-beta.}"

_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
NODE_SLOT="20"
NPM_AUDIT_FATAL=0
NPM_AUDIT_FIX=1
NPM_LOCKFILE_SOURCE="ebuild"
NPM_INSTALL_PATH="/opt/${PN}"
RUST_MAX_VER="1.93.1" # Inclusive
RUST_MIN_VER="1.93.1" # llvm-21.1, required by @swc/core
RUST_PV="${RUST_MIN_VER}"
ELECTRON_BUILDER_PV="26.15.3" # 24.13.3 used upstream.  Old pinned version required

inherit secure-version

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="${ELECTRON_PV}"
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="28.3.3" # Cr 120.0.6099.291, node 18.18.2
fi

NODE_SHARP_PATCHES=(
	"${FILESDIR}/sharp-0.35.3-remove-sover-suffix.patch"
)

NPM_AUDIT_FIX_ARGS=(
	#"--legacy-peer-deps"
	"--force"
	"--prefer-offline"
)

NPM_INSTALL_ARGS=(
	#"--legacy-peer-deps"
	"--force"
	"--prefer-offline"
)

NPM_EXE_LIST=(
	"/opt/llocal/libffmpeg.so"
	"/opt/llocal/libGLESv2.so"
	"/opt/llocal/libvk_swiftshader.so"
	"/opt/llocal/libEGL.so"
	"/opt/llocal/chrome-sandbox"
	"/opt/llocal/llocal"
	"/opt/llocal/libvulkan.so.1"
	"/opt/llocal/chrome_crashpad_handler"
)

inherit edo electron-app npm lcnr node-sharp rust xdg

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/kartikm7/llocal/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Aiming to provide a seamless and privacy driven AI chatting experience with open-sourced technologies"
HOMEPAGE="
	https://www.llocal.in/
	https://github.com/kartikm7/llocal
"
LICENSE="
	${ELECTRON_APP_LICENSES}
	MIT
	OFL-1.1
"
# OFL-1.1 - Poppins-*.ttf
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# The fingerprint of 42.2.0 and 43.2.0 are the same.
	LICENSE+="
		electron-42.2.0-chromium.html
	"
else
	LICENSE+="
		electron-28.3.3-chromium.html
	"
fi
SLOT="0"
IUSE+=" ebuild_revision_20"
RDEPEND="
	>=sci-ml/ollama-${OLLAMA_PV}:=
"
BDEPEND="
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0_beta12-cacheDir.patch"
	"${FILESDIR}/${PN}-1.0.0_beta12-filePath.patch"
	"${FILESDIR}/${PN}-1.0.0_beta12-fix-config.patch"
)

_puppeteer_setup_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ -z "${PUPPETEER_CACHE_FOLDER}" ]] ; then
		export PUPPETEER_CACHE_FOLDER="${EDISTDIR}/puppeteer-download-cache/${CATEGORY}/${P}"
	fi
einfo "DEBUG:  Default cache folder:  ${HOME}/.cache/puppeteer"
einfo "PUPPETEER_CACHE_FOLDER:  ${PUPPETEER_CACHE_FOLDER}"
	rm -rf "${HOME}/.cache/puppeteer"
	mkdir -p "${HOME}/.cache" || die
	ln -sf "${PUPPETEER_CACHE_FOLDER}" "${HOME}/.cache/puppeteer"
	addwrite "${EDISTDIR}"
	addwrite "${PUPPETEER_CACHE_FOLDER}"
	mkdir -p "${PUPPETEER_CACHE_FOLDER}"

}

pkg_setup() {
	npm_pkg_setup
	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	fi
	node-sharp_pkg_setup
}

npm_unpack_post() {
	einfo "DEBUG:  called npm_unpack_post()"
	_puppeteer_setup_offline_cache
	sed -i -e "/kokoro-js/d" "package.json" || die
}

npm_update_lock_install_post() {
	if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D
	fi
}

npm_update_lock_audit_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
ewarn "QA:  Remove node_modules/vite/node_modules/esbuild and @esbuild/* <0.25.12 from package-lock.json"
		node-sharp_npm_lockfile_add_sharp

		# Required pinned dependencies
		L=(
			"@types/node@^20.19.43"				# For import.meta.dirname
			"langchain@0.3.33"
			"@langchain/core@0.3.75"			# For langchain/vectorstores/memory
			"@langchain/textsplitters@0.1.0"
			"@langchain/community@0.3.55"			# For langchain/document_loaders/fs/text
			"kokoro-js@1.2.1"				# For package.json
			"react-icons@5.2.1"
			"officeparser@4.1.1"				# For parseOfficeAsync used in node_modules/@langchain/community/dist/document_loaders/fs/pptx.js

			"langsmith@0.3.67"
			"ollama@0.5.17"
			"puppeteer@24.4.0"
			"puppeteer-core@24.4.0"
			"puppeteer-in-electron@3.0.5"
		)
		enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

		# Required pinned dependencies
		L=(
			"electron-builder@^${ELECTRON_BUILDER_PV}"
		)
		enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"
	fi
}

src_compile() {
	npm_hydrate

	local configuration="Debug"
	local nconfiguration="Release"
	if [[ "${NODE_SHARP_DEBUG}" != "1" ]] ; then
		configuration="Release"
		nconfiguration="Debug"
	fi
	local sharp_platform=$(node-sharp_get_platform)

        pushd "${S}" >/dev/null 2>&1 || die
		node-sharp_npm_rebuild_sharp

	# The prebuilt sharp node binary builds are x86-64-v2 which are not
	# compatible with older CPUs.

		local fn="sharp-${sharp_platform}-${NODE_SHARP_PV}.node"
	# Copy sharp binary to expected location and replace other copies.
		mkdir -p "node_modules/sharp/build/${configuration}" \
			|| die "Failed to create node_modules/sharp/build/${configuration}"
		cp \
			"node_modules/sharp/src/build/${configuration}/${fn}" \
			"node_modules/sharp/build/${configuration}/${fn}" \
			|| die "Failed to copy ${fn} (1)"

	# Allow only the source based sharp node build to pass to avoid illegal instruction crash.
		node-sharp_verify_dedupe
        popd >/dev/null 2>&1 || die

        electron-app_cp_electron

	enpm run "build:unpack"
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "resources/icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Utility"
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/${PN}"
	lcnr_install_files
	local path
	for path in "${NPM_EXE_LIST[@]}" ; do
		fperms 0755 "${path}"
	done
	electron-app_set_sandbox_suid "/opt/${PN}/chrome-sandbox"
}

pkg_postinst() {
	xdg_pkg_postinst
ewarn "The ollama service must be started from init system in order to list models."
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (with bugs) 1.0.0_beta12 (20260728 with electron 43.2.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260422 with electron 41.2.2)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260321 with electron 41.0.3)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta11 (20250630 with electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250312 with electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250208 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta7 (20250117 with electron 34.0.0)
