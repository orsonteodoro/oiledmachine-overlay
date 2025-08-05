# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Using npm breaks
# Avoid "npm error code EUNSUPPORTEDPROTOCOL" when "patch:file-type@npm%3A19.4.1#~/.yarn/patches/file-type-npm-19.4.1-d18086444c.patch" encountered

MY_PN="${PN/-/}"

# See https://releases.electronjs.org/releases.json
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	ELECTRON_APP_ELECTRON_PV="37.2.5" # Cr 138.0.7204.168, node 22.17.1
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="31.3.1" # Cr 126.0.6478.185, node 20.15.1
fi
# TODO:  Fix newer sharp with ICON_TYPE="png"
ICON_TYPE=${ICON_TYPE:-"png"} # svg or png.  png is used by upstream and is broken for newer sharp.
NPM_AUDIT_FIX=0 # Breaks build
YARN_AUDIT_FIX=0
NODE_SHARP_PATCHES=(
	"${FILESDIR}/sharp-0.34.2-debug.patch"
	"${FILESDIR}/sharp-0.34.2-format-fixes.patch"
	"${FILESDIR}/sharp-0.34.2-static-libs.patch"
	"${FILESDIR}/icon-gen-3.0.1-png-return.patch"
)
NODE_SHARP_USE="png svg"
NODE_GYP_PV="9.3.0"
NODE_VERSION="20" # originally 20
PATENT_STATUS=(
	patent_status_nonfree
)
YARN_INSTALL_PATH="/opt/${MY_PN}"
YARN_LOCKFILE_SOURCE="ebuild"
YARN_SLOT=8
export NODE_SHARP_DEBUG=1
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
)
SHARP_PV="0.34.2" # patched 0.34.7 works, non-patched 0.30.7 works; 0.31.0 introduced format() regression
VIPS_PV="8.16.1"

inherit edo electron-app flag-o-matic lcnr node-sharp optfeature xdg yarn

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mifi/lossless-cut.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/mifi/lossless-cut/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="The swiss army knife of lossless video/audio editing"
HOMEPAGE="
	https://github.com/mifi/lossless-cut
"
LICENSE="
	${ELECTRON_APP_LICENSES}
	CC0-1.0
	GPL-2
"
# Electron's 37.2.5 license fingerprint is the same as 37.1.0
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	LICENSE+="
		electron-37.1.0-chromium.html
	"
else
	LICENSE+="
		electron-31.3.1-chromium.html
	"
fi
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${PATENT_STATUS[@]}
mp3 opus svt-av1 theora vorbis vpx x264
ebuild_revision_12
"
REQUIRED_USE="
	!patent_status_nonfree? (
		!x264
	)
	x264? (
		patent_status_nonfree
	)
"
PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		|| (
			media-video/ffmpeg:58.60.60[encode,mp3?,opus?,-patent_status_nonfree,svt-av1?,theora?,vorbis?,vpx?,-x264]
			media-video/ffmpeg:0/58.60.60[encode,mp3?,opus?,-patent_status_nonfree,svt-av1?,theora?,vorbis?,vpx?,-x264]
		)
	)
	patent_status_nonfree? (
		|| (
			media-video/ffmpeg:58.60.60[encode,mp3?,opus?,patent_status_nonfree,svt-av1?,theora?,vorbis?,vpx?,x264?]
			media-video/ffmpeg:0/58.60.60[encode,mp3?,opus?,patent_status_nonfree,svt-av1?,theora?,vorbis?,vpx?,x264?]
		)
	)
"
RDEPEND+="
	${PATENT_STATUS_RDEPEND}
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	sys-apps/yarn:${YARN_SLOT}
	virtual/pkgconfig
"
DOCS=( "README.md" )

pkg_setup() {
# Sharp is used for icon conversions.
ewarn "Part of the sharp fix requires the use of the media-libs/vips ebuilds from the oiledmachine-overlay."
	yarn_pkg_setup
	node-sharp_pkg_setup
}

yarn_unpack_post() {
#	die
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
# We remove patch temporarily so we can bump version and audit the lockfile
einfo "Temporarily disabling file-type patch"
		sed -i -e "s|\"file-type\": \"patch:file-type@npm%3A19.4.1#~/.yarn/patches/file-type-npm-19.4.1-d18086444c.patch\"|\"file-type\": \"19.4.1\"|g" "package.json" || die
	fi
	eapply "${FILESDIR}/${PN}-3.64.0-sweetalert2-scss.patch"
	eapply "${FILESDIR}/${PN}-3.64.0-sharp-type.patch"
}

yarn_update_lock_install_post() {
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
		:
	fi
}

yarn_update_lock_yarn_import_post() {
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
# Doesn't break build
#ewarn "QA:  Manually modify lockfile to remove typescript@5.7.x and move associated version ranges from typescript 5.7.x to typescript@5.5.4"
#ewarn "QA:  Manually modify lockfile to associate @types/node:* with @types/node 20 in lockfile and drop @types/node 22"
ewarn "QA:  Change prismjs ~x.xx to ^1.30.0 in lockfile"							# CVE-2024-53382; DT, ID; Medium

		eyarn add "typescript@5.5.4" -D
		#eyarn add "@types/node@20.14.14" -D
		eyarn add "@types/node@20.19.4" -D
		eyarn add "@types/node@18.19.21" -D

		eyarn add "electron@${ELECTRON_APP_ELECTRON_PV}" -D						# Enable for offline cache speed up

		NODE_GYP_INSTALL_ARGS=( "-D" )
		node-sharp_yarn_lockfile_add_sharp

		sed -i -e "s|node-fetch: \"npm:^1.0.1\"|node-fetch: \"npm:^2.6.7\"|g" "yarn.lock" || die	# CVE-2022-0235, GHSA-r683-j2x4-v87g; DoS, DT, ID; High
		eyarn add "node-fetch@2.6.7" -D

		sed -i -e "s|esbuild: \"npm:^0.21.5\"|esbuild: \"npm:^0.25.0\"|g" "yarn.lock" || die		# GHSA-67mh-4wv8-2f99; ID
		sed -i -e "s|esbuild: \"npm:^0.24.0\"|esbuild: \"npm:^0.25.0\"|g" "yarn.lock" || die		# GHSA-67mh-4wv8-2f99; ID
		sed -i -e "s|esbuild: \"npm:~0.23.0\"|esbuild: \"npm:^0.25.0\"|g" "yarn.lock" || die		# GHSA-67mh-4wv8-2f99; ID
		sed -i -e "s|esbuild: \"npm:^0.21.3\"|esbuild: \"npm:^0.25.0\"|g" "yarn.lock" || die		# GHSA-67mh-4wv8-2f99; ID
		eyarn add "esbuild@0.25.0" -D

		eyarn add "sweetalert2@11.4.8" -D								# GHSA-mrr8-v49w-3333; Low

		# Breaks during runtime
#		sed -i -e "s|\"@octokit/core\": \"5\"|\"@octokit/core\": \"6\"|g" "package.json" || die
#		eyarn add "@octokit/core@6"									# CVE-2025-25290, CVE-2025-25289, CVE-2025-25285; DoS

		if [[ "${ICON_TYPE}" == "png" ]] ; then
			eyarn add "icon-gen@3.0.1" -D # Must go before node-sharp_yarn_rebuild_sharp
		else
			eyarn remove "icon-gen"
			eyarn remove "sharp"
		fi

einfo "Adding file-type patch"
		sed -i -e "s|\"file-type\": \"19.4.1\"|\"file-type\": \"patch:file-type@npm%3A19.4.1#~/.yarn/patches/file-type-npm-19.4.1-d18086444c.patch\"|g" "package.json" || die
	fi
}

gen_icon() {
	# Broken
	#edo tsx "script/icon-gen.mts"
	# See https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping
	# fail: module=node16, target=es2017, moduleResolution=node16; segfault
	# fail: module=node16, target=es2019, moduleResolution=node16; segfault
	# fail: module=node16, target=es2020, moduleResolution=node16; segfault
	# fail: module=node16, target=es2021, moduleResolution=node16; segfault
	# fail: module=node16, target=es2022, moduleResolution=node16; segfault
	# fail: module=node16, target=es2023, moduleResolution=node16; segfault
	edo tsc "script/icon-gen.mts" \
		--module "node16" \
		--target "es2017" \
		--moduleResolution "node16" \
		--typeRoots "./src/types" \
		--lib "es2017"

	cat "script/icon-gen.mjs" >> "script/icon-gen.mjs.t" || die
	mv "script/icon-gen.mjs"{".t",""} || die

	edo node "script/icon-gen.mjs"
	ls "icon-build/app-512.png" || die "Missing generated icon"
}

src_unpack() {
	append-cppflags -I"/usr/include/glib-2.0"
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
	export ELECTRON_CACHE="${HOME}/.cache/electron"
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		yarn_src_unpack
	fi

	export NODE_ENV="development"
einfo "NODE_ENV:  ${NODE_ENV}"

	if [[ "${ICON_TYPE}" == "png" ]] ; then
	        # Clear yarn and npm caches first
	        yarn cache clean || die "Failed to clear yarn cache"
	        npm cache clean --force || die "Failed to clear npm cache"

		if ver_test ${SHARP_PV%.*} -le "0.32" ; then
			eyarn add "@types/sharp" -D # Must go before node-sharp_yarn_rebuild_sharp
		fi
		eyarn add "sharp@${SHARP_PV}" -D
		eyarn add "@types/icon-gen" -D

		jq ".dependencies.sharp = \"^${SHARP_PV}\"" \
			"node_modules/icon-gen/package.json" \
				> \
			"temp.json" \
				&& \
			mv "temp.json" "node_modules/icon-gen/package.json" \
			|| die "Failed to update icon-gen package.json"

		eyarn add "icon-gen@3.0.1" -D --no-optional # Must go before node-sharp_yarn_rebuild_sharp

		# Remove nested sharp and prebuilt sharp
		rm -rf "node_modules/icon-gen/node_modules/sharp" || die "Failed to remove nested sharp"
		rm -rf "node_modules/@img" || die "Failed to remove @img/sharp-linux-x64"

		SHARP_INSTALL_ARGS=( "-D" )

		# Remove nested sharp to avoid conflicts
		rm -rf "node_modules/icon-gen/node_modules/sharp" || true

		local configuration="Debug"
		local nconfiguration="Release"
		if [[ "${NODE_SHARP_DEBUG}" != "1" ]] ; then
			configuration="Release"
			nconfiguration="Debug"
		fi
		local sharp_platform=$(node-sharp_get_platform)

	        # Rebuild sharp
	        einfo "Rebuilding sharp in ${S}"
	        pushd "${S}" || die
	            node-sharp_yarn_rebuild_sharp
	            local configuration="Debug"
	            local sharp_arch=$(get_sharp_arch)
	            # Copy sharp binary to expected location
	            mkdir -p "node_modules/sharp/build/${configuration}" || die "Failed to create node_modules/sharp/build/${configuration}"
	            cp "node_modules/sharp/src/build/${configuration}/sharp-${sharp_platform}.node" \
	               "node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" \
	               || die "Failed to copy sharp-${sharp_platform}.node"
	            ls -l "node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" || die "sharp-${sharp_platform}.node not found"
	        popd

	        # Copy sharp binary to icon-gen if needed
	        if [[ -d "node_modules/icon-gen/node_modules/sharp" ]]; then
	            einfo "Copying sharp binary to node_modules/icon-gen/node_modules/sharp"
	            mkdir -p "node_modules/icon-gen/node_modules/sharp/build/${configuration}" || die "Failed to create icon-gen sharp build directory"
	            cp "node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" \
	               "node_modules/icon-gen/node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" \
	               || die "Failed to copy sharp-${sharp_platform}.node to icon-gen"
	            ls -l "node_modules/icon-gen/node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" || die "Copied sharp-${sharp_platform}.node not found"
	        fi

		ewarn "Removing nested sharp or @img/sharp-linux-x64"
		rm -rfv "node_modules/@img"
		rm -rfv "node_modules/@types/icon-gen/node_modules/sharp"
		rm -rfv "node_modules/icon-gen/node_modules/sharp"
		rm -rfv "node_modules/sharp/node_modules/@img"

		node-sharp_verify_dedupe
	fi

	if [[ "${YARN_UPDATE_LOCK}" != "1" ]] ; then
		edo mkdirp "icon-build" "build-resources/appx"
		edo tsx --version
		if [[ "${ICON_TYPE}" == "png" ]] ; then
			gen_icon
		fi
	fi

	grep -q -e "Something went wrong" "${T}/build.log" && die "Detected error"

	cat \
		"${FILESDIR}/icon-gen.mjs" \
		> \
		"${S}/script/icon-gen.mjs" \
		|| die

}

src_compile() {
einfo "Running src_compile"
	yarn_hydrate
	yarn --version || die
	electron-app_cp_electron

	edo electron-vite build
	edo electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir
	grep -q -e "failedTask" "${T}/build.log" && die "Detected error"
	grep -q -e "Error:" "${T}/build.log" && die "Detected error"
	grep -q -e "Failed with errors" "${T}/build.log" && die "Detected error"
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"


	electron-app_gen_wrapper \
		"${MY_PN}" \
		"${YARN_INSTALL_PATH}/${MY_PN}"
	if [[ "${ICON_TYPE}" == "svg" ]] ; then
		newicon "src/renderer/src/icon.svg" "no.mifi.losslesscut.svg"
	else
		newicon "icon-build/app-512.png" "no.mifi.losslesscut.png"
	fi
	insinto "/usr/share/applications"
	doins "no.mifi.losslesscut.desktop"
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${YARN_INSTALL_PATH}/${MY_PN}"

	EXE_FILES=(
		"libffmpeg.so"
		"losslesscut"
		"libGLESv2.so"
		"libvk_swiftshader.so"
		"libEGL.so"
		"chrome-sandbox"
		"libvulkan.so.1"
		"chrome_crashpad_handler"
	)

	local x
	for x in ${EXE_FILES[@]} ; do
		fperms 0755 "${YARN_INSTALL_PATH}/${x}"
	done

	sed -i \
		-e "s|/app/bin/run.sh|/usr/bin/${MY_PN}|g" \
		"${ED}/usr/share/applications/no.mifi.losslesscut.desktop" \
		|| die

	lcnr_install_files
	electron-app_set_sandbox_suid "/opt/${MY_PN}/chrome-sandbox"

	if has_version "media-video/ffmpeg:58.60.60" ; then
		dosym "/usr/lib/ffmpeg/58.60.60/bin/ffmpeg" "/opt/losslesscut/resources/ffmpeg"
		dosym "/usr/lib/ffmpeg/58.60.60/bin/ffprobe" "/opt/losslesscut/resources/ffprobe"
	else
		dosym "/usr/bin/ffmpeg" "/opt/losslesscut/resources/ffmpeg"
		dosym "/usr/bin/ffprobe" "/opt/losslesscut/resources/ffprobe"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.64.0, 20241222)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.64.0, 20250117 with electron 34.0.0)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.64.0, 20250214 with electron 34.1.1)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.64.0, 20250312 with electron 34.3.2)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.64.0, 20250630 with electron 37.1.0)
# UI load:  pass
# Load video:  pass
# Export by segment:  pass
