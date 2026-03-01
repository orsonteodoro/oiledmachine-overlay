# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream uses U 18.04.6 for CI

# For Cr version correspondance, see https://releases.electronjs.org/releases.json for version details.

_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
NPM_AUDIT_FATAL=0
NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${PN}-${PV}-linux.AppImage"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_MODE="npm"
ELECTRON_APP_REACT_PV="18.3.1"
NODE_ENV="development"
NODE_SLOT="20"

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="40.6.1" # Cr 144.0.7559.220, node 24.13.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="27.3.10" # Cr 118.0.5993.159, node 18.17.1
fi

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
		electron-40.6.1-chromium.html
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
	custom-models firejail
	ebuild_revision_22
"
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
	>=net-libs/nodejs-${NODE_SLOT}:${NODE_SLOT}
	>=net-libs/nodejs-${NODE_SLOT}[npm]
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

	patch_lockfile() {
		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect attack)
		# VS = Vulnerable System (Direct attack)
		sed -i -e "s|\"@babel/runtime\": \"^7.5.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die	# CVE-2025-27789; DoS; Medium
		sed -i -e "s|\"@babel/runtime\": \"^7.8.7\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die	# CVE-2025-27789; DoS; Medium
		sed -i -e "s|\"@babel/runtime\": \"^7.12.0\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die	# CVE-2025-27789; DoS; Medium
		sed -i -e "s|\"@babel/runtime\": \"^7.12.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die	# CVE-2025-27789; DoS; Medium
		sed -i -e "s|\"@babel/runtime\": \"^7.18.3\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die	# CVE-2025-27789; DoS; Medium

		sed -i -e "s|\"undici\": \"^6.21.2\"|\"undici\": \"^6.23.0\"|g" "package-lock.json" || die			# CVE-2026-22036; ZC, DoS; Moderdate
		sed -i -e "s|\"undici\": \"^6.21.1\"|\"undici\": \"^6.23.0\"|g" "package-lock.json" || die			# CVE-2025-47279; DoS; Low
		sed -i -e "s|\"undici\": \"6.21.2\"|\"undici\": \"^6.23.0\"|g" "package-lock.json" || die			# CVE-2026-22036; ZC, DoS; Moderdate
		sed -i -e "s|\"undici\": \"6.19.7\"|\"undici\": \"^6.23.0\"|g" "package-lock.json" || die			# CVE-2025-22150; DT, ID; Medium
																# CVE-2025-47279; DoS; Low

		sed -i -e "s|\"next\": \"^14.2.10\"|\"next\": \"^15.0.8\"|g" "package-lock.json" || die				# CVE-2025-29927; DT, ID; Critical
		sed -i -e "s|\"next\": \"^14.2.25\"|\"next\": \"^15.0.8\"|g" "package-lock.json" || die				# CVE-2025-48068; VS(ID), SS(ID); Low
		sed -i -e "s|\"next\": \"^14.2.32\"|\"next\": \"^15.0.8\"|g" "package-lock.json" || die				# CVE-2025-48068; VS(ID), SS(ID); Low
																# CVE-2025-48068; VS(ID), SS(ID); Low
																# CVE-2025-30218; VS(ID)
																# GHSA-h25m-26qc-wcjf; DoS; High
																# GHSA-5j59-xgg2-r9c4; DoS; High
																# GHSA-mwv6-3258-q52c; ZC, DoS; High

		sed -i -e "s|\"next\": \"^14.2.30\"|\"next\": \"^15.0.8\"|g" "package-lock.json" || die				# CVE-2025-57752; ID; Medium
																# CVE-2025-57822; DT, ID; Medium
																# CVE-2025-55173; DT, Medium

		sed -i -e "s|\"form-data\": \"^4.0.0\"|\"form-data\": \"4.0.4\"|g" "package-lock.json" || die			# CVE-2025-7783; VS(DT, ID), SS(DT, ID); Critical
		sed -i -e "s|\"tmp\": \"^0.2.0\"|\"tmp\": \"0.2.4\"|g" "package-lock.json" || die				# CVE-2025-54798; DT; Low

		sed -i -e "s|\"tar\": \"^6.1.12\"|\"tar\": \"^7.5.7\"|g" "package-lock.json" || die				# CVE-2026-23950; DoS, DT, ID; High
																# CVE-2026-24842; DT, ID; High
																# CVE-2026-23745; VS(DT, ID), SS(DT, ID)
		sed -i -e "s|\"glob\": \"^10.3.10\"|\"glob\": \"^10.5.0\"|g" "package-lock.json" || die				# CVE-2025-64756; DoS, DT, ID; High
		sed -i -e "s|\"glob\": \"10.3.10\"|\"glob\": \"^10.5.0\"|g" "package-lock.json" || die				# CVE-2025-64756; DoS, DT, ID; High

	}
	patch_lockfile
	local pkgs
	pkgs=(
		"undici@^6.23.0"
		"next@^15.0.8"
		"form-data@4.0.4"
		"tmp@0.2.4"
		"tar@^7.5.7"
		"glob@^10.5.0"
	)
	enpm install -D "${pkgs[@]}"

	pkgs=(
		"@babel/runtime@7.26.10"
		"glob@^10.5.0"
		"undici@^6.23.0"
	)
	enpm install -P "${pkgs[@]}" --prefer-offline
	patch_lockfile
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
	exeinto "/usr/bin"
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|@INSTALL_DIR@|${NPM_INSTALL_PATH}|g" \
		-e "s|@PN@|${PN}|g" \
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
	local f
	for f in "${L[@]}" ; do
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
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250115, Electron 34.0.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250312, Electron 34.3.2)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250630, Electron 37.1.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250806, Electron 37.2.6)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20250905, Electron 38.0.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.15.1 (20260228, Electron 40.6.1)
