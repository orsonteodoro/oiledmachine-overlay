# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="28.3.1"
MY_PN="LLocal"
NODE_VERSION=18
NPM_AUDIT_FIX=0
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

MY_PV="${PV/_beta/-beta.}"

inherit electron-app npm lcnr

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
	electron-28.2.10-chromium.html
	MIT
"
SLOT="0"
RDEPEND="
	app-misc/ollama
"
BDEPEND="
"

src_compile() {
	npm_hydrate
        electron-app_cp_electron
	enpm run "build:unpack"
}

npm_update_lock_audit_post() {
	:
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
