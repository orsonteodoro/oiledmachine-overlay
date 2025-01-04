# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${PN}-${PV}-linux.AppImage"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_ELECTRON_PV="28.3.2" # cr 120.0.6099.291
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_REACT_PV="18.3.1"
ELECTRON_APP_SHARP_PV="0.32.6"
ELECTRON_APP_VIPS_PV="8.14.5"
NODE_ENV="development"
NODE_VERSION="18"

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
inherit desktop electron-app git-r3 lcnr npm
if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
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
	electron-28.2.10-chromium.html
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
LICENSE="
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
	AGPL-3
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
	custom-models
	ebuild_revision_6
	firejail
"
# Upstream uses U 18.04.6 for CI
RDEPEND+="
	>=media-libs/vips-${ELECTRON_APP_VIPS_PV}[cxx,lcms,jpeg,png,webp]
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
	if ! use system-vips ; then
# Vendored vips requires SSE 4.2.
ewarn
ewarn "You need a CPU with SSE 4.2 to use system-vips USE flag disabled."
ewarn
	fi
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
	npm_pkg_setup
}

npm_update_lock_install_post() {
	enpm uninstall "@types/electron"
}

npm_update_lock_audit_post() {
	enpm install -D "electron@${ELECTRON_APP_ELECTRON_PV}"
}

src_compile() {
ewarn "Using pgo with x11-libs/cairo with an old pgo profile may produce artifacts or missing tiles."
	electron-app_set_sharp_env
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

	if use system-vips ; then
		find "${ED}" -name "libvips-cpp.so*" -delete
	fi
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
