# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update use:
# PNPM_UPDATER_PROJECT_ROOT="Signal-Desktop-7.46.0" pnpm_updater_update_locks.sh

# Ignore if error:
# Could not detect abi for version ' + target + ' and runtime ' + runtime + '.  Updating "node-abi" might help solve this issue if it is a new release of ' + runtime)
# https://github.com/signalapp/Signal-Desktop/blob/v7.47.0/CONTRIBUTING.md#known-issues

MY_PN="Signal-Desktop"
MY_PN2="Signal"
NPM_INSTALL_ARGS=(
	"--prefer-offline"
)
NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)
NPM_DEDUPE_ARGS=(
)

# See
# https://releases.electronjs.org/releases.json
# https://github.com/electron/node-abi/blob/v3.71.0/abi_registry.json
# prebuilt-install depends on node-abi
# Use the newer Electron to increase mitigation with vendor static libs.
AT_TYPES_NODE_PV="20.17.6"
ELECTRON_BUILDER_PV="26.0.14"
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer's choice
	ELECTRON_APP_ELECTRON_PV="37.2.0" # Cr 138.0.7204.97, node 22.17.0
else
	# Upstream's choice
	ELECTRON_APP_ELECTRON_PV="36.3.2" # Cr 136.0.7103.115, node 22.15.1
fi
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK="1"
NPM_SLOT=3
PNPM_SLOT=9
NODE_VERSION="22" # Upstream uses 22.15.0 from .nvmrc
NODE_ENV="development"
if [[ "${PNPM_UPDATE_LOCK}" != "1" ]] ; then
	PNPM_INSTALL_ARGS+=( "--force" )
fi
RUST_MAX_VER="1.81.0" # Inclusive
RUST_MIN_VER="1.81.0" # Corresponds to llvm-19.1.  Rust is required for @swc/core
RUST_PV="${RUST_MIN_VER}"
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
	LICENSE+="
		electron-37.1.0-chromium.html
	"
else
	LICENSE+="
		electron-36.3.2-chromium.html
	"
fi
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="splitdebug binchecks strip"
IUSE+="
firejail wayland X
ebuild_revision_32
"
# RRDEPEND already added from electron-app
RDEPEND+="
	!net-im/signal-desktop-bin
	>=media-fonts/noto-emoji-20231130
	media-libs/libpulse
"
BDEPEND+="
	net-libs/nodejs:${NODE_VERSION}[webassembly(+)]
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[firejail_profiles_signal-desktop]
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
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

get_deps() {
	cd "${S}" || die
	[[ -d "${S}/node_modules/.bin" ]] || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	epnpm run build:acknowledgments
	patch-package --error-on-fail --error-on-warn || die
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
}

pnpm_unpack_post() {
	sed -i -e "s|postinstall|disabled_postinstall|g" "${S}/package.json" || die
}

pnpm_unpack_install_post() {
	:
	#die
}

src_unpack() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		pnpm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

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

		sed -i -e "s|postinstall|disabled_postinstall|g" "package.json" || die

		epnpm install ${PNPM_INSTALL_ARGS[@]}

		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect attack)
		# VS = Vulnerable System (Direct attack)
		# ZC = Zero Click Attack (AV:N, PR:N, UI:N)

ewarn "QA:  Manually add (patch_hash=cfe393dc1cca8970377087e9555a285d1121f75d57223ddd872b1a8d3f8c909b) suffix to dependencies section to match got@11.8.5(patch_hash=cfe393dc1cca8970377087e9555a285d1121f75d57223ddd872b1a8d3f8c909b) from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove (encoding@0.1.13) suffix @octokit/request@8.4.1(encoding@0.1.13) from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove cross-spawn@5.1.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove electron@23.3.13 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove got@6.7.1 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @types/keyv@3.1.4 from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove node_modules/vite/node_modules/esbuild and all @esbuild/<arch>@0.18.20 associated packages from ${S}/sticker-creator/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/core from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/plugin-paginate-rest from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/plugin-request-log from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/request from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/request-error from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove node_modules/memfs-or-file-map-to-github-branch/node_modules/@octokit/rest from ${S}/danger/pnpm-lock.yaml"

ewarn "QA:  Manually remove @octokit/rest@18.12.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/types@6.41.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/core@3.6.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-rest-endpoint-methods@5.16.2 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-paginate-rest@9.2.2 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-request-log@1.0.4 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/auth-token@2.5.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/graphql@4.8.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/request-error@2.1.0 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/endpoint@6.0.12 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/request@5.6.3 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-paginate-rest@2.21.3 from ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2 to 11.4.4-cjs.2 in ${S}/danger/package.json and ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2(@octokit/core@3.6.0) to 11.4.4-cjs.2(@octokit/core@5.2.1) in ${S}/danger/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/request-error references from 2.1.0 to 5.1.1 in ${S}/danger/pnpm-lock.yaml"

ewarn "QA:  Manually remove @octokit/request@5.6.3 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-paginate-rest@2.21.3 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/core@3.6.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/types@6.41.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/auth-token@2.5.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/graphql@4.8.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-request-log@1.0.4 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-rest-endpoint-methods@5.16.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/rest@18.12.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/rest@18.12.0 references to @octokit/rest@20.1.2"
ewarn "QA:  Manually remove @octokit/request-error@2.1.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2 to 11.4.4-cjs.2 in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change @octokit/plugin-paginate-rest references from 9.2.2(@octokit/core@3.6.0(encoding@0.1.13)) to 11.4.4-cjs.2(@octokit/core@5.2.1) in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/request-error@2.1.0 from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove esbuild@0.24.0 and arch implementations (@esbuild/<arch>@0.24.0) from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove esbuild@0.18.20 and arch implementations from ${S}/sticker-creator/pnpm-lock.yaml"

ewarn "QA:  Manually remove danger@12.3.4 from ${S}/danger/pnpm-lock.yaml and ${S}/pnpm-lock.yaml"
		patch_edits_npm() {
			pushd "sticker-creator" >/dev/null 2>&1 || die
				sed -i -e "s|\"cross-spawn\": \"^6.0.5\"|\"cross-spawn\": \"^6.0.6\"|g" "package-lock.json" || die								# CVE-2024-21538; DoS; High
				sed -i -e "s|\"esbuild\": \"^0.18.10\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die									# GHSA-67mh-4wv8-2f99; ID; Moderate
				sed -i -e "s|\"happy-dom\": \"8.9.0\"|\"happy-dom\": \"15.10.2\"|g" "package-lock.json" || die									# CVE-2024-51757; DoS, DT, ID; Critical
				sed -i -e "s|\"rollup\": \"^3.27.1\"|\"rollup\": \"^3.29.5\"|g" "package-lock.json" || die									# CVE-2024-47068; DT, ID; Medium
				sed -i -e "s|\"vite\": \"4.5.3\"|\"vite\": \"4.5.14\"|g" "package-lock.json" || die										# CVE-2025-24010; ID; Medium
																								# CVE-2024-45812; DoS, DT, ID; Medium
																								# CVE-2024-45811; ID; Medium
																								# CVE-2025-46565; VS(ID); Medium
			popd >/dev/null 2>&1 || die
			pushd "danger" >/dev/null 2>&1 || die
				sed -i -e "s|\"cross-spawn\": \"^7.0.3\"|\"cross-spawn\": \"^7.0.5\"|g" "package-lock.json" || die								# CVE-2024-21538; DoS; High
				sed -i -e "s|\"danger: \"^10.5.3\"|\"danger\": \"13.0.4\"|g" "pnpm-lock.yaml" || die										# CVE-2025-25975; DoS, DT, ID; High
				sed -i -e "s|\"danger: \"12.3.4\"|\"danger\": \"13.0.4\"|g" "pnpm-lock.yaml" || die										# CVE-2025-25975; DoS, DT, ID; High
				sed -i -e "s|\"micromatch\": \"^4.0.2\"|\"micromatch\": \"^4.0.8\"|g" "package-lock.json" || die								# CVE-2024-4067; DoS; Medium
				sed -i -e "s|\"micromatch\": \"^4.0.4\"|\"micromatch\": \"^4.0.8\"|g" "package-lock.json" || die								# CVE-2024-4067; DoS; Medium
				sed -i -e "s|\"@octokit/rest\": \"^18.12.0\"|\"@octokit/rest\": \"^20.1.2\"|g" "package-lock.json" || die							# Bump for
																								#   @octokit/request
																								#   @octokit/plugin-paginate-rest
																								#   @octokit/request-error
																								# CVE-2025-25289, CVE-2025-25288, CVE-2025-25290; DoS; Low
			popd >/dev/null 2>&1 || die
			sed -i -e "s|\"@octokit/rest\": \"^18.12.0\"|\"@octokit/rest\": \"^20.1.2\"|g" "package-lock.json" || die								# Bump for
																								#   @octokit/request
																								#   @octokit/plugin-paginate-rest
																								#   @octokit/request-error
																								# CVE-2025-25289, CVE-2025-25288, CVE-2025-25290; DoS; Low

			sed -i -e "s|\"danger: \"^10.5.3\"|\"danger\": \"13.0.4\"|g" "pnpm-lock.yaml" || die											# CVE-2025-25975; DoS, DT, ID; High
			sed -i -e "s|\"danger: \"12.3.4\"|\"danger\": \"13.0.4\"|g" "pnpm-lock.yaml" || die											# CVE-2025-25975; DoS, DT, ID; High
			sed -i -e "s|\"electron\": \"^23.1.2\"|\"electron\": \"^${ELECTRON_APP_ELECTRON_PV}\"|g" "package-lock.json" || die							# CVE-2023-44402; DoS, DT, ID; High
			sed -i -e "s|\"esbuild\": \"0.24.0\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die										# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#\"esbuild\": \"^0.18.0 || ^0.19.0 || ^0.20.0 || ^0.21.0 || ^0.22.0 || ^0.23.0 || ^0.24.0\"#\"esbuild\": \"^0.25.0\"#g" "package-lock.json" || die		# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#\"esbuild\": \"^0.18.0 || ^0.19.0 || ^0.20.0\"#\"esbuild\": \"^0.25.0\"#g" "package-lock.json" || die							# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#\"esbuild\": \">=0.12 <1\"#\"esbuild\": \"^0.25.0\"#g" "package-lock.json" || die										# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s|\"got\": \"^11.7.0\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die											# CVE-2022-33987; DT; Medium
			sed -i -e "s|\"got\": \"^11.8.2\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die											# CVE-2022-33987; DT; Medium
			sed -i -e "s|\"got\": \"^6.7.1\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die											# CVE-2022-33987; DT; Medium
		}

		patch_edits_pnpm() {
			pushd "sticker-creator" >/dev/null 2>&1 || die
				sed -i -e "s|'@babel/runtime': 7.26.7|'@babel/runtime': 7.26.10|g" "pnpm-lock.yaml" || die									# CVE-2025-27789, DoS, Moderate
				sed -i -e "s|'@babel/helpers': 7.26.7|'@babel/helpers': 7.26.10|g" "pnpm-lock.yaml" || die									# CVE-2025-27789, DoS, Moderate
				sed -i -e "s|cross-spawn: 6.0.5|cross-spawn: 6.0.6|g" "pnpm-lock.yaml" || die											# CVE-2024-21538; DoS; High
				sed -i -e "s|esbuild: 0.18.10|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die											# GHSA-67mh-4wv8-2f99; ID; Moderate
				sed -i -e "s|esbuild: 0.18.20|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die											# GHSA-67mh-4wv8-2f99; ID; Moderate
				sed -i -e "s|happy-dom: 8.9.0|happy-dom: 15.10.2|g" "pnpm-lock.yaml" || die											# CVE-2024-51757; DoS, DT, ID; Critical
				sed -i -e "s|rollup: 3.27.1|rollup: 3.29.5|g" "pnpm-lock.yaml" || die												# CVE-2024-47068; DT, ID; Medium

				sed -i -e "s|vite: 4.5.3|vite: 4.5.14|g" "pnpm-lock.yaml" || die												# CVE-2025-24010; ID; Medium
																								# CVE-2024-45812; DoS, DT, ID; Medium
																								# CVE-2024-45811; ID; Medium
																								# CVE-2025-46565; VS(ID); Medium


				sed -i -e "s|vite: ^4.1.0-beta.0|vite: 4.5.14|g" "pnpm-lock.yaml" || die											# CVE-2025-24010; ID; Medium
																								# CVE-2024-45812; DoS, DT, ID; Medium
																								# CVE-2024-45811; ID; Medium
																								# CVE-2025-46565; VS(ID); Medium
			popd >/dev/null 2>&1 || die
			pushd "danger" >/dev/null 2>&1 || die
				sed -i -e "s|'@octokit/plugin-paginate-rest': 2.21.3|'@octokit/plugin-paginate-rest': 9.2.2|g" "pnpm-lock.yaml" || die						# CVE-2025-25288, DoS, Moderate
				sed -i -e "s|'@octokit/request': 5.6.3|'@octokit/request': 8.4.1|g" "pnpm-lock.yaml" || die									# CVE-2025-25290, DoS, Moderate
				sed -i -e "s|'@octokit/request-error': 2.1.0|'@octokit/request-error': 2.1.0|g" "pnpm-lock.yaml" || die								# CVE-2025-25289, DoS, Moderate
				sed -i -e "s|cross-spawn: 7.0.3|cross-spawn: 7.0.5|g" "pnpm-lock.yaml" || die											# CVE-2024-21538; DoS; High
				sed -i -e "s|danger: ^10.5.3|danger: 13.0.4|g" "pnpm-lock.yaml" || die												# CVE-2025-25975; DoS, DT, ID; High
				sed -i -e "s|danger: 12.3.4|danger: 13.0.4|g" "pnpm-lock.yaml" || die												# CVE-2025-25975; DoS, DT, ID; High
				sed -i -e "s|micromatch: 4.0.2|micromatch: 4.0.8|g" "pnpm-lock.yaml" || die											# CVE-2024-4067; DoS; Medium
				sed -i -e "s|micromatch: 4.0.4|micromatch: 4.0.8|g" "pnpm-lock.yaml" || die											# CVE-2024-4067; DoS; Medium
				sed -i -e "s|'@octokit/rest': 18.12.0|'@octokit/rest': 20.1.2|g" "pnpm-lock.yaml" || die									# Bump for
																								#   @octokit/request
																								#   @octokit/plugin-paginate-rest
																								#   @octokit/request-error
																								# CVE-2025-25289, CVE-2025-25288, CVE-2025-25290; DoS; Low


			popd >/dev/null 2>&1 || die
			sed -i -e "s|'@babel/runtime': 7.26.7|'@babel/runtime': 7.26.10|g" "pnpm-lock.yaml" || die										# CVE-2025-27789, DoS, Moderate
			sed -i -e "s|'@babel/helpers': 7.26.7|'@babel/helpers': 7.26.10|g" "pnpm-lock.yaml" || die										# CVE-2025-27789, DoS, Moderate
			sed -i -e "s|'@octokit/plugin-paginate-rest': 2.21.3|'@octokit/plugin-paginate-rest': 9.2.2|g" "pnpm-lock.yaml" || die							# CVE-2025-25288, DoS, Moderate
			sed -i -e "s|'@octokit/request': 5.6.3|'@octokit/request': 8.4.1|g" "pnpm-lock.yaml" || die										# CVE-2025-25290, DoS, Moderate
			sed -i -e "s|'@octokit/request-error': 2.1.0|'@octokit/request-error': 5.1.1|g" "pnpm-lock.yaml" || die									# CVE-2025-25289, DoS, Moderate
			sed -i -e "s|@octokit/rest: 18.12.0|@octokit/rest: 20.1.2|g" "pnpm-lock.yaml" || die											# Bump for
																								#   @octokit/request
																								#   @octokit/plugin-paginate-rest
																								#   @octokit/request-error
			sed -i -e "s|axios: 1.7.9|axios: 1.8.2|g" "pnpm-lock.yaml" || die													# CVE-2025-27152, ID, High
			sed -i -e "s|brace-expansion: 1.1.11|brace-expansion: 1.1.12|g" "pnpm-lock.yaml" || die											# CVE-2025-5889; DoS; Low
			sed -i -e "s|brace-expansion: 2.0.1|brace-expansion: 2.0.2|g" "pnpm-lock.yaml" || die											# CVE-2025-5889; DoS; Low
			sed -i -e "s|brace-expansion: 1.1.11|brace-expansion: 1.1.12|g" "sticker-creator/pnpm-lock.yaml" || die									# CVE-2025-5889; DoS; Low
			sed -i -e "s|brace-expansion: 2.0.1|brace-expansion: 2.0.2|g" "sticker-creator/pnpm-lock.yaml" || die									# CVE-2025-5889; DoS; Low
			sed -i -e "s|cross-spawn: 5.1.0|cross-spawn: 6.0.6|g" "pnpm-lock.yaml" || die												# CVE-2024-21538, DoS, High
			sed -i -e "s|danger: ^10.5.3|danger: 13.0.4|g" "pnpm-lock.yaml" || die													# CVE-2025-25975; DoS, DT, ID; High
			sed -i -e "s|danger: 12.3.4|danger: 13.0.4|g" "pnpm-lock.yaml" || die													# CVE-2025-25975; DoS, DT, ID; High
			sed -i -e "s|electron: 23.1.2|electron: ${ELECTRON_APP_ELECTRON_PV}|g" "pnpm-lock.yaml" || die										# CVE-2023-44402; DoS, DT, ID; High
			sed -i -e "s|electron: 23.3.13|electron: ${ELECTRON_APP_ELECTRON_PV}|g" "pnpm-lock.yaml" || die										# CVE-2023-44402; DoS, DT, ID; High
			sed -i -e "s|esbuild: 0.24.0|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die													# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#esbuild: 0.18.0 || ^0.19.0 || ^0.20.0 || ^0.21.0 || ^0.22.0 || ^0.23.0 || ^0.24.0#esbuild: 0.25.0#g" "pnpm-lock.yaml" || die				# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#esbuild: 0.18.0 || ^0.19.0 || ^0.20.0#esbuild: 0.25.0#g" "pnpm-lock.yaml" || die										# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#esbuild: 0.24.0#esbuild: 0.25.0#g" "pnpm-lock.yaml" || die													# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s#esbuild: '>=0.12 <1'#esbuild: 0.25.0#g" "pnpm-lock.yaml" || die												# GHSA-67mh-4wv8-2f99; ID; Moderate
			sed -i -e "s|got: 11.7.0|got: 11.8.5|g" "pnpm-lock.yaml" || die														# CVE-2022-33987; DT; Medium
			sed -i -e "s|got: 11.8.2|got: 11.8.5|g" "pnpm-lock.yaml" || die														# CVE-2022-33987; DT; Medium
			sed -i -e "s|got: 6.7.1|got: 11.8.5|g" "pnpm-lock.yaml" || die														# CVE-2022-33987; DT; Medium
																								# CVE-2025-25289, CVE-2025-25288, CVE-2025-25290; DoS; Low
			sed -i -e "s|tar-fs: 2.1.2|tar-fs: 2.1.3|g" "pnpm-lock.yaml" || die													# CVE-2025-48387; ZC, DT; High

			sed -i -e "s|webpack-dev-server: 5.1.0|webpack-dev-server: 5.2.1|g" "pnpm-lock.yaml" || die										# CVE-2025-30359; ID; Medium
																								# CVE-2025-30360; ID; Medium

			sed -i -e "s|http-proxy-middleware: 2.0.7|http-proxy-middleware: 2.0.9|g" "pnpm-lock.yaml" || die									# CVE-2025-32997; DT; Medium
																								# CVE-2025-32996; DoS; Medium
		}
		patch_edits_pnpm

		local deps=()
		pushd "sticker-creator" >/dev/null 2>&1 || die
			deps=(
				"@babel/runtime@7.26.10"
				"@babel/helpers@7.26.10"
				"brace-expansion@2.0.2"
			)
			epnpm install ${deps[@]} -P ${PNPM_INSTALL_ARGS[@]}
			deps=(
				"brace-expansion@1.1.12"
				"cross-spawn@6.0.6"
				"esbuild@0.25.0"
				"happy-dom@15.10.2"
				"rollup@3.29.5"
				"vite@4.5.14"
			)
			epnpm install ${deps[@]} -D ${PNPM_INSTALL_ARGS[@]}
		popd >/dev/null 2>&1 || die

		pushd "danger" >/dev/null 2>&1 || die
			deps=(
				"danger@13.0.4"
				"@octokit/plugin-paginate-rest@9.2.2"
				"@octokit/request@8.4.1"
				"@octokit/request-error@2.1.0"
				"cross-spawn@7.0.5"
				"micromatch@4.0.8"
				"@octokit/rest@20.1.2"
			)
			epnpm install ${deps[@]} -P ${PNPM_INSTALL_ARGS[@]}
		popd >/dev/null 2>&1 || die

		deps=(
			"@babel/runtime@7.26.10"
			"@babel/helpers@7.26.10"
			"esbuild@0.25.0"
			"got@11.8.5"
			"tar-fs@2.1.3"
		)
		epnpm install ${deps[@]} -P ${PNPM_INSTALL_ARGS[@]}
		deps=(
			"danger@13.0.4"
			"@octokit/plugin-paginate-rest@9.2.2"
			"@octokit/request@8.4.1"
			"@octokit/request-error@5.1.1"
			"@octokit/rest@20.1.2"
			"axios@1.8.2"
			"brace-expansion@2.0.2"
			"brace-expansion@1.1.12"
			"patch-package@8.0.0"
			"webpack-dev-server@5.2.1"
			"http-proxy-middleware@2.0.9"		# This must go after webpack-dev-server.
		)
		epnpm install ${deps[@]} -D ${PNPM_INSTALL_ARGS[@]}

		epnpm audit fix ${PNPM_AUDIT_FIX_ARGS[@]}

ewarn "QA:  Manually remove node_modules/react-devtools/node_modules/electron from pnpm-lock.yaml"												# CVE-2023-44402

		deps=(
	# Required for custom version bump
			"electron@${ELECTRON_APP_ELECTRON_PV}"
		)
		epnpm install ${deps[@]} -D ${PNPM_INSTALL_ARGS[@]}

		patch_edits_pnpm
		epnpm dedupe
		patch_edits_pnpm

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
		for x in ${LOCKFILES_PNPM[@]} ; do
			local d=$(dirname "${x}")
			mkdir -p "${WORKDIR}/lockfile-image/${d}" || die
			if [[ -e "${d}/package.json" ]] ; then
				cp -av "${d}/package.json" "${WORKDIR}/lockfile-image/${d}" || die
			fi
			if [[ -e "${d}/pnpm-lock.yaml" ]] ; then
				cp -av "${d}/pnpm-lock.yaml" "${WORKDIR}/lockfile-image/${d}" || die
			fi
		done

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

	epnpm run build

	electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
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
	for x in ${L[@]} ; do
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

	lcnr_install_files
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For using the tray icon on compatible desktop environments, start Signal with"
	elog " '--start-in-tray' or '--use-tray-icon'."
}
# OILEDMACHINE-OVERLAY-TEST:  passed (7.59.0, 20250701, electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.46.0, 20250313, electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.45.1, 20250311, electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.44.0, 20250227, electron 35.0.0-beta.11)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.42.0, 20250214, electron 35.0.0-beta.6)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.41.0, 20250116, electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.41.0, 20250207, electron 35.0.0-beta.3)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.40.1, 20250205, electron 35.0.0-beta.2)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, electron 34.0.0-beta.5)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.36.1, 20250105, electron 34.0.0-beta.14)
# OILEDMACHINE-OVERLAY-TEST:  passed (7.38.0, 20250116, electron 34.0.0)
# UI load - pass
