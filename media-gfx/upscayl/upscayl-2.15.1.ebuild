# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${PN}-${PV}-linux.AppImage"
ELECTRON_APP_MODE="npm"
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
# See https://releases.electronjs.org/releases.json for version details.
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
#	ELECTRON_APP_ELECTRON_PV="34.1.1" # Cr 132.0.6834.194, node 20.18.1
	ELECTRON_APP_ELECTRON_PV="34.3.2" # Cr 132.0.6834.210, node 20.18.3
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="27.3.10" # Cr 118.0.5993.159, node 18.17.1
fi
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_REACT_PV="18.3.1"
NODE_ENV="development"
NODE_VERSION="18"
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)

inherit desktop electron-app git-r3 lcnr npm

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/upscayl/upscayl/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Upscayl is an AI based image upscaler"
HOMEPAGE="https://upscayl.github.io/"
# Same sha1sum hash for electron-28.2.10-chromium.html and electron-28.3.2-chromium.html
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		CC-BY-4.0
		custom
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License-2015
	)
	(
		CC0-1.0
		MIT
	)
	(
		0BSD
		Apache-2.0
		BSD
		BSD-2
		ISC
		MIT
		(
			all-rights-reserved
			MIT
		)
	)
	(
		ISC
		WTFPL-2
	)
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-4.0
	CC-BY-SA-4.0
	ISC
	GPL-3
	MIT
	PSF-2.4
	|| (
		GPL-2
		MIT
	)
	|| (
		CC0-1.0
		MIT
	)
"
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	THIRD_PARTY_LICENSES+="
		electron-34.3.2-chromium.html
	"
else
	THIRD_PARTY_LICENSES+="
		electron-27.3.10-chromium.html
	"
fi
LICENSE="
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
	AGPL-3
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
	custom-models
	ebuild_revision_7
	firejail
"
# Upstream uses U 18.04.6 for CI
RDEPEND+="
	media-libs/vulkan-drivers
	media-libs/vulkan-loader
	custom-models? (
		media-gfx/upscayl-custom-models
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	virtual/pkgconfig
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[firejail_profiles_upscayl]
	)
"

pkg_setup() {
	export NEXT_TELEMETRY_DISABLED=1
	npm_pkg_setup
}

npm_update_lock_install_post() {
	enpm uninstall "@types/electron"
}

npm_update_lock_audit_post() {
	# --prefer-offline is broken
	enpm install -D "electron@${ELECTRON_APP_ELECTRON_PV}"

	sed -i -e "s|\"undici\": \"6.19.7\"|\"undici\": \"6.21.1\"|g" "package-lock.json" || die # CVE-2025-22150; DT, ID; Medium
	enpm install -D "undici@6.21.1" --prefer-offline
}

src_compile() {
ewarn "Using pgo with x11-libs/cairo with an old pgo profile may produce artifacts or missing tiles."
	export NEXT_TELEMETRY_DISABLED=1
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	npm_hydrate
	electron-app_cp_electron
	enpm run build
	electron-builder build --linux dir
	cd "${S}" || die
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|\${INSTALL_DIR}|${NPM_INSTALL_PATH}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${PN}|${PN}|g" \
		"${ED}/usr/bin/${PN}" || die
        newicon "build/icon.png" "${PN}.png"
        make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		 "Graphics"
	# Generated from:
	# find "${S}/dist" -executable -type f | cut -f 11- -d "/" | sort
	local L=(
		"chrome-sandbox"
		"chrome_crashpad_handler"
		"libEGL.so"
		"libGLESv2.so"
		"libffmpeg.so"
		"libvk_swiftshader.so"
		"libvulkan.so.1"
		"resources/bin/upscayl-bin"
		"upscayl"
	)
	for f in ${L[@]} ; do
		fperms 0755 "${NPM_INSTALL_PATH}/${f}"
	done
	lcnr_install_files

	electron-app_set_sandbox_suid "/opt/upscayl/chrome-sandbox"
}

pkg_postinst() {
ewarn "You need vulkan drivers to use ${PN}."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.5.5 (20230608)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.9.1 (20231107)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.9.5 (20231209) load test, switch color theme test, digital filter test
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.9.8 (20230203) load test, switch color theme test, digital filter test
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.10.9 (20230203) load test only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.11.0 (20230203) load test only
# USE="X unpacked wayland -r2"
# X:  passed
# wayland:  passed
# digital art:  passed
# real-esrgan:  passed
# fast real-esrgan:  passed
# ultramix balanced:  passed
# color theme (randomly chosen):  passed
# preview:  passed (with PNG), fail (with JPG)
# notes:  the jpg with preview is broken for 2.9.1

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.7.5 with runtime black empty preview bug.
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.8.6 (20240211)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.9.9 (20240211)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250115, electron 34.0.0)
