# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/}"

# See https://releases.electronjs.org/releases.json
ELECTRON_APP_ELECTRON_PV="31.3.1" # Cr 126.0.6478.185, node 20.15.1
#ELECTRON_APP_ELECTRON_PV="32.0.0-beta.2" # Cr 128.0.6611.0, node 20.15.1
ELECTRON_APP_SHARP_PV="0.32.6"
NPM_AUDIT_FIX=0
NODE_GYP_PV="9.3.0"
NODE_VERSION="20"
YARN_INSTALL_PATH="/opt/${MY_PN}"
YARN_LOCKFILE_SOURCE="ebuild"
YARN_SLOT=8

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
	electron-31.3.1-chromium.html
	CC0-1.0
	GPL-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
mp3 opus svt-av1 theora vorbis vpx x264
ebuild_revision_2
"
RDEPEND+="
	|| (
		media-video/ffmpeg:58.60.60[encode,mp3?,opus?,svt-av1?,theora?,vorbis?,vpx?,x264?]
		media-video/ffmpeg:0/58.60.60[encode,mp3?,opus?,svt-av1?,theora?,vorbis?,vpx?,x264?]
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=media-libs/vips-${ELECTRON_APP_VIPS_PV}[cxx,png,svg]
	>=sys-apps/yarn-4:${YARN_SLOT}
"
DOCS=( "README.md" )

pkg_setup() {
	yarn_pkg_setup
}

src_unpack() {
	append-cppflags -I"/usr/include/glib-2.0"
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
# UI load:  pass
# Load video:  pass
# Export by segment:  pass
