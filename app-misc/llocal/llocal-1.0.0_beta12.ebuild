# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  Replace prebuilt node sharp with source based build of node sharp

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="1.0.0_beta12" npm_updater_update_locks.sh

MY_PN="LLocal"
MY_PV="${PV/_beta/-beta.}"

_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
NODE_SLOT="20"
NPM_AUDIT_FATAL=0
#NPM_AUDIT_FIX=0
NPM_LOCKFILE_SOURCE="ebuild"
NPM_INSTALL_PATH="/opt/${PN}"
RUST_MAX_VER="1.81.0" # Inclusive
RUST_MIN_VER="1.81.0" # llvm-18.1, required by @swc/core
RUST_PV="${RUST_MIN_VER}"

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="41.2.2" # Cr 146.0.7680.188, node 24.14.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="28.3.3" # Cr 120.0.6099.291, node 18.18.2
fi

NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)

NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
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

inherit electron-app npm lcnr rust xdg

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
	# The fingerprint of 41.2.2 and 41.2.1 are the same.
	LICENSE+="
		electron-41.2.1-chromium.html
	"
else
	LICENSE+="
		electron-28.3.3-chromium.html
	"
fi
SLOT="0"
IUSE+=" ebuild_revision_17"
RDEPEND="
	app-misc/ollama
"
BDEPEND="
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-beta.12-cacheDir.patch"
	"${FILESDIR}/${PN}-1.0.0-beta.12-filePath.patch"
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
	patch_lockfile() {
#ewarn "QA:  Manually remove node_modules/vite/node_modules/esbuild and @esbuild/* <0.25.12 from package-lock.json"
#ewarn "QA:  Manually remove node_modules/vite/node_modules/esbuild@0.21.5 and arches in package-lock.json"
		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect attack)
		# VS = Vulnerable System (Direct attack)

	# The pinned version of @langchain/community is required.
	# The pinned version of react-icons is required.
	#	sed -i -e "s|\"@langchain/community\": \"^0.2.25\"|\"@langchain/community\": \"^1.1.18\"|g" "package-lock.json" || die		# CVE-2024-7042; DoS, DT, ID; Critical
	#																	# CVE-2026-26019; ID; Moderate
	#																	# CVE-2026-27795; ID; Moderate
		sed -i -e "s|\"langsmith\": \">=0.4.0 <1.0.0\"|\"langsmith\": \"^0.5.19\"|g" "package-lock.json" || die				# CVE-2026-25528; ZC, ID; Moderate
		sed -i -e "s|\"langsmith\": \">=0.4.0 <1.0.0\"|\"langsmith\": \"^0.5.19\"|g" "package-lock.json" || die				# CVE-2026-25528; ZC, ID; Moderate
		sed -i -e "s|\"langsmith\": \"^0.3.67\"|\"langsmith\": \"^0.5.19\"|g" "package-lock.json" || die				# CVE-2026-25528; ZC, ID; Moderate
																		# CVE-2026-40190; ZC, DoS, DT, ID; Moderate
																		# GHSA-rr7j-v2q5-chgv; ZC, ID; Moderate

		sed -i -e "s#\"vite\": \"^4.0.0 || ^5.0.0\"#\"vite\": \"^6.4.2\"#g" "package-lock.json" || die					# CVE-2025-30208; ID; Medium
		sed -i -e "s#\"vite\": \"^4.2.0 || ^5.0.0 || ^6.0.0 || ^7.0.0-beta.0\"#\"vite\": \"^6.4.2\"#g" "package-lock.json" || die	# CVE-2025-30208; ID; Medium
		sed -i -e "s|\"vite\": \"^5.0.12\"|\"vite\": \"^6.4.2\"|g" "package-lock.json" || die						# CVE-2025-24010; ID; Medium
		sed -i -e "s|\"vite\": \"^5.4.12\"|\"vite\": \"^6.4.2\"|g" "package-lock.json" || die						# CVE-2025-30208; ID; Medium
		sed -i -e "s|\"vite\": \"5.4.12\"|\"vite\": \"^6.4.2\"|g" "package-lock.json" || die						# CVE-2025-30208; ID; Medium
																		# CVE-2025-46565; VS(ID); Medium
																		# CVE-2025-32395; VS(ID); Medium
																		# CVE-2025-31486; ID; Medium
																		# CVE-2025-58752; ID; Low
																		# CVE-2025-62522; VS(ID); Moderate
																		# CVE-2026-39365; ZC, VS(ID); Moderate

		sed -i -e "s|\"ws\": \"^8.14.2\"|\"ws\": \"^8.17.1\"|g" "package-lock.json" || die						# CVE-2024-37890; DoS; High
		sed -i -e "s|\"ws\": \"8.13.0\"|\"ws\": \"^8.17.1\"|g" "package-lock.json" || die

		sed -i -e "s|\"form-data\": \"^4.0.0\"|\"form-data\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2025-7783; VS(DT, ID), SS(DT, ID); Critical

		sed -i -e "s|\"tmp\": \"^0.2.0\"|\"tmp\": \"^0.2.4\"|g" "package-lock.json" || die						# CVE-2025-54798; DT

		sed -i -e "s|\"mermaid\": \"^11.4.1\"|\"mermaid\": \"^11.10.0\"|g" "package-lock.json" || die					# CVE-2025-54881; SS(DT, ID); Medium
																		# CVE-2025-54880; SS(DT, ID); Medium
		sed -i -e "s|\"tar-fs\": \"^2.0.0\"|\"tar-fs\": \"^2.1.4\"|g" "package-lock.json" || die					# CVE-2025-59343; VS(DT); High
		sed -i -e "s|\"tar-fs\": \"^3.1.0\"|\"tar-fs\": \"^3.1.1\"|g" "package-lock.json" || die					# CVE-2025-59343, GHSA-vj76-c3g6-qr5v; VS(DT); High # Not mentioned in the GH scanner for llocal but in a different package

		sed -i -e "s|\"tar\": \"^7.4.3\"|\"tar\": \"^7.5.11\"|g" "package-lock.json" || die						# CVE-2026-23950; DoS, DT, ID; High
		sed -i -e "s|\"tar\": \"^7.5.10\"|\"tar\": \"^7.5.11\"|g" "package-lock.json" || die						# CVE-2026-23950; DoS, DT, ID; High
		sed -i -e "s|\"tar\": \"^6.1.12\"|\"tar\": \"^7.5.11\"|g" "package-lock.json" || die						# CVE-2026-23950; DoS, DT, ID; High
																		# CVE-2026-24842; DT, ID; High
																		# CVE-2026-29786; DoS, DT; High
																		# CVE-2026-31802; VS(DoS), SS(DoS); High
																		# CVE-2026-23745; VS(DT, ID), SS(DT, ID); High
																		# CVE-2026-26960; DT, ID; High
		sed -i -e "s|\"@tootallnate/once\": \"2\"|\"@tootallnate/once\": \"^3.0.1\"|g" "package-lock.json" || die			# CVE-2026-3449; VS(DoS); Low
		sed -i -e "s|\"file-type\": \"^16.5.4\"|\"file-type\": \"^21.3.2\"|g" "package-lock.json" || die				# CVE-2026-31808; ZC, DoS; Moderate
																		# CVE-2026-32630; ZC, DoS; Moderate



	}
	patch_lockfile

	local L

	L=(
		"node-gyp"
	)
	enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	L=(
		"langsmith@^0.5.19"
	#	"@langchain/community@^1.1.18"
		"ws@^8.17.1"

		# Fix breakage
		"react-icons@5.2.1" # Must be pinned

		"form-data@^4.0.4"
		"mermaid@^11.10.0"

		"tar-fs@^2.1.4"
		"tar-fs@^3.1.1"
		"tar@^7.5.11"
		"file-type@^21.3.2"

		"react-icons@5.2.1"	# Must be pinned test remove after testing
		"kokoro-js"		# Required missing dep in package.json
	)
	enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

	L=(
		"vite@^6.4.2"
		"tmp@^0.2.4"
		"@tootallnate/once@^3.0.1"
	)
	enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	patch_lockfile
}

npm_update_lock_audit_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
ewarn "QA:  Remove node_modules/vite/node_modules/esbuild and @esbuild/* <0.25.12 from package-lock.json"
		patch_lockfile() {
			sed -i -e "s|\"@babel/runtime\": \"^7.3.1\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"axios\": \"^1.6.8\"|\"axios\": \"^1.12.0\"|g" "package-lock.json" || die						# CVE-2025-27152; ID; High
																			# CVE-2025-58754; ZC, DoS; High
			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^0.25.12\"|g" "package-lock.json" || die					# GHSA-67mh-4wv8-2f99; ID; Medium
			sed -i -e "s|\"esbuild\": \"^0.21.5\"|\"esbuild\": \"^0.25.12\"|g" "package-lock.json" || die					# GHSA-67mh-4wv8-2f99; ID; Medium
			sed -i -e "s|\"esbuild\": \"^0.25.0\"|\"esbuild\": \"^0.25.12\"|g" "package-lock.json"						# GHSA-67mh-4wv8-2f99; ID; Medium
			sed -i -e "s|\"prismjs\": \"^1.27.0\"|\"prismjs\": \"^1.30.0\"|g" "package-lock.json" || die					# CVE-2024-53382; DT, ID; Medium
			sed -i -e "s|\"prismjs\": \"~1.27.0\"|\"prismjs\": \"^1.30.0\"|g" "package-lock.json" || die					# CVE-2024-53382; DT, ID; Medium

			sed -i -e "s|\"minimatch\": \"^9.0.9\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^9.0.5\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^9.0.4\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"9.0.3\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^9.0.0\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^5.1.1\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^5.0.1\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.1.2\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.1.1\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.0.5\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.0.5\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.0.4\"|\"minimatch\": \"^9.0.0\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High

			sed -i -e "s|\"picomatch\": \"^4.0.3\"|\"picomatch\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2026-33671; ZC, DoS; High
			sed -i -e "s|\"picomatch\": \"^4.0.2\"|\"picomatch\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2026-33671; ZC, DoS; High
			sed -i -e "s@\"picomatch\": \"^3 || ^4\"@\"picomatch\": \"^4.0.4\"@g" "package-lock.json" || die				# CVE-2026-33671; ZC, DoS; High
			sed -i -e "s|\"picomatch\": \"^2.3.1\"|\"picomatch\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2026-33671; ZC, DoS; High
			sed -i -e "s|\"picomatch\": \"^2.2.1\"|\"picomatch\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2026-33671; ZC, DoS; High
			sed -i -e "s|\"picomatch\": \"^2.0.4\"|\"picomatch\": \"^4.0.4\"|g" "package-lock.json" || die					# CVE-2026-33671; ZC, DoS; High
																			# CVE-2026-33672; DT; Moderate

#			sed -i -e "s|\"brace-expansion\": \"^5.0.2\"|\"brace-expansion\": \"^5.0.5\"|g" "package-lock.json" || die			# CVE-2026-33750; DoS; Moderate
#			sed -i -e "s|\"brace-expansion\": \"^2.0.2\"|\"brace-expansion\": \"^5.0.5\"|g" "package-lock.json" || die			# CVE-2026-33750; DoS; Moderate
#			sed -i -e "s|\"brace-expansion\": \"^2.0.1\"|\"brace-expansion\": \"^5.0.5\"|g" "package-lock.json" || die			# CVE-2026-33750; DoS; Moderate
#			sed -i -e "s|\"brace-expansion\": \"^1.1.7\"|\"brace-expansion\": \"^5.0.5\"|g" "package-lock.json" || die			# CVE-2026-33750; DoS; Moderate
		}
		patch_lockfile

		L=(
			"@babel/runtime@^7.26.10"
			"axios@^1.12.0"
			"prismjs@^1.30.0"
			"minimatch@^9.0.0"
			"picomatch@^4.0.4"
		)
		enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

		L=(
			"esbuild@^0.25.12"
			"minimatch@^9.0.0"
#			"brace-expansion@^5.0.5"
		)
		enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"

		patch_lockfile
	fi
}

src_compile() {
	npm_hydrate
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

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260422 with electron 41.2.2)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta12 (20260321 with electron 41.0.3)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta11 (20250630 with electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250312 with electron 35.0.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250208 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta7 (20250117 with electron 34.0.0)
