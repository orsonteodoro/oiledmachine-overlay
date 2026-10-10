# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild uses AI generated fixes.

# TODO:  Replace prebuilt node sharp with source based build of node sharp

# FIXME:
# Error occurred in handler for 'downloadingOllama': download-failed

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="1.0.0_beta12" npm_updater_update_locks.sh

MY_PN="LLocal"
MY_PV="${PV/_beta/-beta.}"

_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
NODE_SLOT="24" # Upstream uses 20
NPM_AUDIT_FATAL=0
NPM_AUDIT_FIX=1
NPM_LOCKFILE_SOURCE="ebuild"
NPM_INSTALL_PATH="/opt/${PN}"
RUST_MAX_VER="1.93.1" # Inclusive
RUST_MIN_VER="1.93.1" # llvm-21.1, required by @swc/core
RUST_PV="${RUST_MIN_VER}"
ELECTRON_BUILDER_PV="26.15.7" # 24.13.3 used upstream.  Old pinned version required
SECURE_VERSION_NODE_EBUILD_UPDATE=1791575863

inherit secure-version secure-version-node

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="${NODE_24_ELECTRON_PV}"
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="28.3.3" # Cr 120.0.6099.291, node 18.18.2
fi

NODE_SHARP_PATCHES=(
	"${FILESDIR}/sharp-0.35.3-remove-sover-suffix.patch"
)

# Force can be used with Node 24 but not Node 22 Electron.
NPM_AUDIT_FIX_ARGS=(
	#"--legacy-peer-deps"
	"--force"
	"--prefer-offline"
)

NPM_DEDUPE_ARGS=(
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
	"/opt/llocal/libvk_swiftshader.so"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/x64/libonnxruntime_providers_tensorrt.so"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/x64/libonnxruntime_providers_shared.so"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/x64/libonnxruntime.so.1"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/x64/libonnxruntime.so.1.21.0"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/x64/libonnxruntime_providers_cuda.so"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/arm64/libonnxruntime.so.1"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/onnxruntime-node/bin/napi-v3/linux/arm64/libonnxruntime.so.1.21.0"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/faiss-node/build/Release/libopenblas.so.0"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/faiss-node/build/Release/libgfortran.so.5"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/faiss-node/build/Release/libgomp.so.1"
	"/opt/llocal/resources/app.asar.unpacked/node_modules/faiss-node/build/Release/libquadmath.so.0"
#	"/opt/llocal/resources/app.asar.unpacked/node_modules/@img/sharp-libvips-linuxmusl-x64/lib/libvips-cpp.so.8.17.3"
#	"/opt/llocal/resources/app.asar.unpacked/node_modules/@img/sharp-libvips-linux-x64/lib/libvips-cpp.so.8.17.3"
	"/opt/llocal/libvulkan.so.1"
	"/opt/llocal/chrome-sandbox"
	"/opt/llocal/llocal"
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
	LICENSE+="
		electron-44.4.1-chromium.html
	"
else
	LICENSE+="
		electron-28.3.3-chromium.html
	"
fi
RESTRICT="mirror" # Speed up downloads
SLOT="0"
IUSE+=" ebuild_revision_31"
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
	"${FILESDIR}/${PN}-1.0.0_beta12-ollama-changes.patch"
	"${FILESDIR}/${PN}-1.0.0_beta12-langchain-updates.patch"
	"${FILESDIR}/${PN}-1.0.0_beta12-puppeteer-update.patch"
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
	secure-version-node_check_update
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
ewarn "QA:  Remove node_modules/vite/node_modules/esbuild and @esbuild/* <0.25.12 in package-lock.json"
ewarn "QA:  Remove node_modules/npm/node_modules/ip-address in package-lock.json"
		node-sharp_npm_lockfile_add_sharp

		patch_lockfile() {
			sed -i -e "s|\"file-type\": \"^16.5.4\"|\"file-type\": \"^${NODE_FILE_TYPE_22_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"handlebars\": \"^4.7.9\"|\"handlebars\": \"^${NODE_HANDLEBARS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"ip-address\": \"^10.1.1\"|\"ip-address\": \"^${NODE_IP_ADDRESS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"katex\": \"^0.16.47\"|\"katex\": \"^${NODE_KATEX_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"minimatch\": \"9.0.3\"|\"minimatch\": \"^${NODE_MINIMATCH_9_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"minimatch\": \"^9.0.3\"|\"minimatch\": \"^${NODE_MINIMATCH_9_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"pdfjs-dist\": \"^5.3.31\"|\"pdfjs-dist\": \"^${NODE_PDFJS_DIST_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss-selector-parser\": \"^6.1.1\"|\"postcss-selector-parser\": \"^${NODE_POSTCSS_SELECTOR_PARSER_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss-selector-parser\": \"^6.1.2\"|\"postcss-selector-parser\": \"^${NODE_POSTCSS_SELECTOR_PARSER_7_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"sharp\": \"^0.34.1\"|\"sharp\": \"^${NODE_SHARP_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"source-map-js\": \"^1.2.1\"|\"source-map-js\": \"^${NODE_SOURCE_MAP_JS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"uuid\": \"^8.3.2\"|\"uuid\": \"^${NODE_UUID_11_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"uuid\": \"^10.0.0\"|\"uuid\": \"^${NODE_UUID_11_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"undici\": \"^6.25.0\"|\"undici\": \"^${NODE_UNDICI_6_PV}\"|g" "package-lock.json" || die
		}
		patch_lockfile

		# Clean out first
		L=(
			"@langchain/core"
			"@langchain/textsplitters"
			"@langchain/community"
			"langchain"
			"ollama"
			"officeparser"
			"langsmith"

			"puppeteer"
			"puppeteer-core"
			"puppeteer-in-electron"
		)
		enpm uninstall "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

		# Install secure active maintained replacements
		L=(
			"@langchain/classic@1.0.50"
			"@langchain/ollama@1.3.0"
			"@langchain/core@1.2.13"
			"@langchain/textsplitters@1.0.2"
			"langchain@1.5.14"
			"langsmith@0.7.3"
			"ollama@0.6.3"
			"pdf-parse@2.4.5" # Dep of PDFLoader
			"mammoth@1.13.0" # Dep of DocxLoader

			"puppeteer@^25.12.0"
			"puppeteer-core@^25.12.0"
		)
		enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

		# Required pinned dependencies
		L=(
			"@types/node@^20.19.43"				# For import.meta.dirname
			"kokoro-js@1.2.1"				# For package.json
			"react-icons@5.2.1"
# works			"puppeteer@24.4.0"
# works			"puppeteer-core@24.4.0"
# works			"puppeteer-in-electron@3.0.5"
		)
		enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

		# Required pinned dependencies
		L=(
			"electron-builder@${ELECTRON_BUILDER_PV}"
			"source-map-js@^${NODE_SOURCE_MAP_JS_PV}"
		)
		enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"

		# Security fixes
		L=(
			"brace-expansion@^${NODE_BRACE_EXPANSION_2_PV}"
			"file-type@^${NODE_FILE_TYPE_22_PV}"
			"handlebars@^${NODE_HANDLEBARS_PV}"
			"ip-address@^${NODE_IP_ADDRESS_PV}"
			"katex@^${NODE_KATEX_PV}"
			"pdfjs-dist@^${NODE_PDFJS_DIST_PV}"
			"sharp@^${NODE_SHARP_PV}"
			"tar@^${NODE_TAR_PV}"
			"undici@^${NODE_UNDICI_6_PV}"
			"uuid@^${NODE_UUID_11_PV}"
		)
		enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"
		L=(
			"minimatch@^${NODE_MINIMATCH_9_PV}"
		)
		enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"
		patch_lockfile

		enpm dedupe "${NPM_DEDUPE_ARGS[@]}"

		# Remove vulnerable dependencies
		enpm uninstall "npm" "${NPM_INSTALL_ARGS[@]}"

		sed -i -e "s|index.mjs|index.js|g" "${S}/package.json" || die
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

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260928 with electron 44.4.5)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (with bugs) 1.0.0_beta12 (20260922 with electron 44.4.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (with bugs) 1.0.0_beta12 (20260917 with electron 44.4.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (with bugs) 1.0.0_beta12 (20260728 with electron 43.2.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260422 with electron 41.2.2)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260321 with electron 41.0.3)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta11 (20250630 with electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250312 with electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250208 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta7 (20250117 with electron 34.0.0)
