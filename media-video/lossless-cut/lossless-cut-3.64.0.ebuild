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
	ELECTRON_APP_ELECTRON_PV="34.1.1" # Cr 132.0.6834.194, node 20.18.1
	#ELECTRON_APP_ELECTRON_PV="35.0.0-beta.2" # Cr 134.0.6968.0, node 22.9.0 ; breaks
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="31.3.1" # Cr 126.0.6478.185, node 20.15.1
fi
ELECTRON_APP_SHARP_PV="0.32.6"
NPM_AUDIT_FIX=1
YARN_AUDIT_FIX=1
NODE_GYP_PV="9.3.0"
NODE_VERSION="20"
PATENT_STATUS=(
	patent_status_nonfree
)
YARN_INSTALL_PATH="/opt/${MY_PN}"
YARN_LOCKFILE_SOURCE="ebuild"
YARN_SLOT=8
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
)

inherit edo electron-app flag-o-matic lcnr optfeature xdg yarn

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
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	LICENSE+="
		electron-34.0.0-beta.7-chromium.html
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
ebuild_revision_4
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
	>=media-libs/vips-${ELECTRON_APP_VIPS_PV}[cxx,png,svg]
	sys-apps/yarn:${YARN_SLOT}
"
DOCS=( "README.md" )

pkg_setup() {
	yarn_pkg_setup
}

yarn_unpack_post() {
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
einfo "Removing file-type patch"
		sed -i -e "s|\"file-type\": \"patch:file-type@npm%3A19.4.1#~/.yarn/patches/file-type-npm-19.4.1-d18086444c.patch\"|\"file-type\": \"19.4.1\"|g" "package.json" || die

		enpm install "electron@${ELECTRON_APP_ELECTRON_PV}" -D --prefer-offline ${NPM_INSTALL_ARGS}
	fi
}

yarn_update_lock_yarn_import_post() {
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
	# Unbreak build
		eyarn add "sweetalert2@11.11.0" -D

einfo "Adding file-type patch"
		sed -i -e "s|\"file-type\": \"19.4.1\"|\"file-type\": \"patch:file-type@npm%3A19.4.1#~/.yarn/patches/file-type-npm-19.4.1-d18086444c.patch\"|g" "package.json" || die
	fi
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
	eyarn add "node-gyp@${NODE_GYP_PV}"
	export SHARP_IGNORE_GLOBAL_LIBVIPS=1 # First download prebuilt vips lib
	eyarn add "sharp@${ELECTRON_APP_SHARP_PV}"
	electron-app_set_sharp_env # Disabled vips lib
	if grep -q -E -e "sharp: Installation error: aborted" "${T}/xfs-"*"/build.log" 2>/dev/null ; then
		eyarn rebuild sharp
	fi

	edo mkdirp "icon-build" "build-resources/appx"
	edo tsx --version

	# Broken
	edo tsx "script/icon-gen.mts"
	ls "icon-build/app-512.png" || ewarn "Missing generated icon"

	grep -q -e "Something went wrong" "${T}/build.log" && die "Detected error"
}

src_compile() {
	yarn_hydrate
	yarn --version || die
	electron-app_cp_electron

	electron-vite build || die
        electron-builder \
                $(electron-app_get_electron_platarch_args) \
                -l dir \
                || die
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
	newicon "src/renderer/src/icon.svg" "no.mifi.losslesscut.svg"
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
# UI load:  pass
# Load video:  pass
# Export by segment:  pass
