# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="LLocal"
MY_PV="${PV/_beta/-beta.}"

_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="34.1.1" # Cr 132.0.6834.194, node 20.18.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="28.3.3" # Cr 120.0.6099.291, node 18.18.2
fi
NODE_VERSION=18
#NPM_AUDIT_FIX=0
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_LOCKFILE_SOURCE="ebuild"
NPM_EXE_LIST="
/opt/llocal/libffmpeg.so
/opt/llocal/libGLESv2.so
/opt/llocal/libvk_swiftshader.so
/opt/llocal/libEGL.so
/opt/llocal/chrome-sandbox
/opt/llocal/llocal
/opt/llocal/libvulkan.so.1
/opt/llocal/chrome_crashpad_handler
"
NPM_INSTALL_PATH="/opt/${PN}"
RUST_PV="1.81.0" # llvm-18.1, required by @swc/core
RUST_MAX_VER="1.81.1" # Excludes
RUST_MIN_VER="${RUST_PV}"

inherit electron-app npm lcnr rust

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
# The fingerprint of electron-28.2.10-chromium.html and the electron-28.3.1-chromium.html is the same
LICENSE="
	${ELECTRON_APP_LICENSES}
	MIT
"
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	LICENSE+="
		electron-34.0.0-alpha.7-chromium.html
	"
else
	LICENSE+="
		electron-28.2.10-chromium.html
	"
fi
SLOT="0"
IUSE+=" ebuild_revision_4"
RDEPEND="
	app-misc/ollama
"
BDEPEND="
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
"

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
	_puppeteer_setup_offline_cache
}

npm_update_lock_install_post() {
	if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D --prefer-offline
	fi
	patch_lockfile() {
		sed -i -e "s|\"@langchain/community\": \"^0.2.25\"|\"@langchain/community\": \"0.3.3\"|g" "package-lock.json" || die		# CVE-2024-7042; DoS, DT, ID; Critical
		sed -i -e "s|\"vite\": \"^5.0.12\"|\"vite\": \"5.4.12\"|g" "package-lock.json" || die						# CVE-2025-24010; ID; Medium
		sed -i -e "s#\"vite\": \"^4.0.0 || ^5.0.0\"#\"vite\": \"5.4.12\"#g" "package-lock.json" || die
		sed -i -e "s|\"ws\": \"^8.14.2\"|\"ws\": \"^8.17.1\"|g" "package-lock.json" || die						# CVE-2024-37890; DoS; High
		sed -i -e "s|\"ws\": \"8.13.0\"|\"ws\": \"^8.17.1\"|g" "package-lock.json" || die
	}
	patch_lockfile

	enpm install "@langchain/community@0.3.3" -P ${NPM_INSTALL_ARGS[@]}
	enpm install "vite@5.4.12" -D ${NPM_INSTALL_ARGS[@]}
	enpm install "ws@8.17.1" -P ${NPM_INSTALL_ARGS[@]}

	# Fix breakage
	enpm install "react-icons@5.2.1" -P --prefer-offline ${NPM_INSTALL_ARGS[@]}
	patch_lockfile
}

npm_update_lock_audit_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		patch_lockfile() {
			sed -i -e "s|\"esbuild\": \"^0.21.3\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die					# GHSA-67mh-4wv8-2f99
			sed -i -e "s|\"esbuild\": \"^0.21.5\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die					# GHSA-67mh-4wv8-2f99
		}
		patch_lockfile
		enpm install "esbuild@^0.25.0" -D # --prefer-offline is bugged, must follow vite
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
	for path in ${NPM_EXE_LIST} ; do
		fperms 0755 "${path}"
	done
	electron-app_set_sandbox_suid "/opt/${PN}/chrome-sandbox"
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta8 (20250208 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.0.0_beta7 (20250117 with electron 34.0.0)
