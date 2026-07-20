# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# This ebuild contains patches with AI generated code.

# The cef in obs is verified working even with the message below.
# libcef_dll_wrapper.so: undefined symbol: cef_get_min_log_level

# 32.0.4 -> 32.1.2

# TODO package:
# nvafx
# nvvfx

#
# To find differences between release use:
#
# S1="/var/tmp/portage/media-video/obs-studio-31.0.0/work/obs-studio-30.1.2" \
# S2="/var/tmp/portage/media-video/obs-studio-32.0.2/work/obs-studio-30.2.3" ; \
# for x in $(find ${S2} -name "CMakeLists.txt" -o -name "*.cmake" | cut -f 9- -d "/" | sort) ; do \
#   diff -urp "${S1}/${x}" "${S2}/${x}" ; \
# done
#

# 95 is EOL.  The current Cr version is 122.
# See also
# https://github.com/obsproject/obs-studio/blob/30.1.0/build-aux/modules/99-cef.json
# https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding
# https://bitbucket.org/chromiumembedded/cef/src/5060/CHROMIUM_BUILD_COMPATIBILITY.txt?at=5060
CMAKE_REMOVE_MODULES_LIST=( "FindFreetype" )
CXX_STANDARD=17 # 17 without browser, 20 with browser
LUA_COMPAT=( "luajit" )
MAKEOPTS="-j1"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit secure-version

# For CEF version, See https://github.com/obsproject/obs-browser/blob/a776dd6a1a0ded4a8a723f2f572f3f8a9707f5a8/CMakeLists.txt#L12
QT6_PV="${QTBASE6_PV}"
QT6_SLOT=$(ver_cut "1" "${QT6_PV}")
SWIG_PV="4.2.0"

LIBDSHOWCAPTURE_COMMIT="8878638324393815512f802640b0d5ce940161f1"
CAPTURE_DEVICE_SUPPORT="fe9630974d47f51bf54826e72fb8b654e620aa93"
OBS_BROWSER_COMMIT="ea04212e4bbadd077f9e6038758c4e4779c24fa3"
OBS_WEBSOCKET_COMMIT="1fcb95b15aa88b1b7e9bda3f9c8650e314377169"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)
LIBCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_6[@]}"
)

PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)

CHKL_TIMESTAMPS=(
	"dev-cpp/nlohmann_json-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/jansson-9999"
	"dev-libs/wayland-9999"
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtsvg-6.9999"
	"media-libs/alsa-lib-9999"
	"media-libs/libva-9999"
	"media-libs/rnnoise-9999"
	"media-libs/x264-9999"
	"media-sound/sndio-9999"
	"media-video/pipewire-9999"
	"net-misc/curl-9999"
	"net-libs/cef-9999"
	"net-libs/cef-bin-9999"
	"net-libs/librist-9999"
	"net-libs/srt-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit chkl cmake dep-prepare flag-o-matic git-r3 lcnr libcxx-slot libstdcxx-slot lua-single multilib python-single-r1 xdg-utils

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_COMMIT="${PV}"
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	FALLBACK_COMMIT="fb4d98bf88fae5fc85cb11fc57f7c5e309282194" # Apr 21, 2026
	IUSE+=" fallback-commit"
	inherit git
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/obsproject/libdshowcapture/archive/${LIBDSHOWCAPTURE_COMMIT}.tar.gz
	-> libdshowcapture-${LIBDSHOWCAPTURE_COMMIT:0:7}.tar.gz
https://github.com/elgatosf/capture-device-support/archive/${CAPTURE_DEVICE_SUPPORT}.tar.gz
	-> capture-device-support-${CAPTURE_DEVICE_SUPPORT:0:7}.tar.gz
	browser? (
https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz
	-> obs-browser-${OBS_BROWSER_COMMIT:0:7}.tar.gz
	)
https://github.com/obsproject/obs-studio/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/obsproject/obs-websocket/archive/${OBS_WEBSOCKET_COMMIT}.tar.gz
	-> obs-websocket-${OBS_WEBSOCKET_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Software for live streaming and screen recording"
HOMEPAGE="https://obsproject.com"
LICENSE="
	CC0-1.0
	GPL-2+
	amf? (
		custom
		LGPL-2.1+
		GPL-2+
		MIT
	)
	browser? (
		BSD
		ZLIB
	)
	decklink? (
		Boost-1.0
	)
	mac-syphon? (
		BSD
		BSD-2
	)
	qsv? (
		BSD
		GPL-2
	)
	vst? (
		GPL-2+
	)
	websocket? (
		Boost-1.0
		BSD
		MIT
		ZLIB
	)
	win-dshow? (
		GPL-2+
		LGPL-2.1
	)
"
# custom - plugins/enc-amf/AMF/LICENSE.txt
RESTRICT="binchecks mirror strip" # Speed up download of the latest release.
SLOT="0"
# aja is enabled by default upstream
# amf is enabled by default upstream
# coreaudio is enabled by default upstream
# nvafx is enabled by default upstream
# nvvfx is enabled by default upstream
# oss is enabled by default upstream
# qsv is enabled by default upstream
# vlc is enabled by default upstream
IUSE+="
${PATENT_STATUS_IUSE[@]}
aac +alsa aja amf +browser +browser-panels coreaudio -decklink -fdk firejail
+flac +freetype +hevc +ipv6 jack libaom +lua mac-syphon +mpegts nvafx
nvenc nvvfx opus oss +pipewire +pulseaudio +python qsv +qt6 +rnnoise +rtmps
+service-updates -sndio +speexdsp svt-av1 -test +v4l2 vaapi +vlc +virtualcam
+vst +wayland +webrtc win-dshow +websocket -win-mf +whatsnew x264

ebuild_revision_26
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!aac
		!amf
		!coreaudio
		!fdk
		!hevc
		!nvenc
		!qsv
		!vaapi
		!x264
	)
	!patent_status_nonfree? (
		opus
		|| (
			libaom
			svt-av1
		)
	)
	aac? (
		patent_status_nonfree
	)
	amf? (
		patent_status_nonfree
	)
	coreaudio? (
		patent_status_nonfree
	)
	fdk? (
		patent_status_nonfree
	)
	hevc? (
		patent_status_nonfree
	)
	nvenc? (
		patent_status_nonfree
	)
	patent_status_nonfree? (
		aac
		x264
	)
	qsv? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
"
REQUIRED_USE+="
	${PATENT_STATUS_REQUIRED_USE}
	!win-dshow
	!win-mf
	qt6
	!kernel_Darwin? (
		!coreaudio
		!mac-syphon
		!kernel_linux? (
			!decklink
			!jack
			!vlc
		)
	)
	!kernel_linux? (
		!alsa
		!pulseaudio
		!sndio
		!v4l2
		!vaapi
		!wayland
	)
	lua? (
		${LUA_REQUIRED_USE}
	)
	hevc? (
		|| (
			amf
			nvenc
		)
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	qsv? (
		vaapi
	)
"

gen_ffmpeg_depend() {
	local use_deps="${1}"
	echo "
		media-video/ffmpeg:=
		|| (
			media-video/ffmpeg:58.60.60[${use_deps}]
			media-video/ffmpeg:0/58.60.60[${use_deps}]
		)
	"
}

RDEPEND_FFMPEG="
	$(gen_ffmpeg_depend 'libaom?,opus?,svt-av1?')
"

RDEPEND_LIBX11="
	kernel_linux? (
	        >=x11-libs/libX11-${LIBX11_PV}:=
	)
"

RDEPEND_LIBXCB="
        >=x11-libs/libxcb-${LIBXCB_PV}:=
"

RDEPEND_JANSSON="
	>=dev-libs/jansson-${JANSSON_PV}:=
"

RDEPEND_WAYLAND="
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=
		>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	)
"

RDEPEND_ZLIB="
	>=virtual/zlib-${ZLIB_PV}:=
"

RDEPEND_PLUGINS_AJA="
	aja? (
		${RDEPEND_LIBX11}
		media-libs/ntv2:=
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,widgets,X]
		)
	)
"

RDEPEND_PLUGINS_RNNOISE="
	rnnoise? (
		>=media-libs/rnnoise-${RNNOISE_PV}:=
	)
"

# See plugins/sndio/CMakeLists.txt
RDEPEND_PLUGINS_SNDIO="
	sndio? (
		${RDEPEND_LIBOBS}
		>=media-sound/sndio-${SNDIO_PV}:=
	)
"

# See UI/frontend-plugins/decklink-captions/CMakeLists.txt
RDEPEND_PLUGINS_DECKLINK_CAPTIONS="
	decklink? (
		${RDEPEND_LIBX11}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},widgets,X]
		)
	)
"

# See UI/frontend-plugins/decklink-output-ui/CMakeLists.txt
RDEPEND_PLUGINS_DECKLINK_OUTPUT_UI="
	decklink? (
		${RDEPEND_LIBX11}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,widgets,X]
		)
	)
"

# See plugins/decklink/linux/CMakeLists.txt
RDEPEND_PLUGINS_DECKLINK="
	decklink? (
		${RDEPEND_LIBOBS}
		${RDEPEND_PLUGINS_DECKLINK_CAPTIONS}
	)
"

# See UI/frontend-plugins/frontend-tools/CMakeLists.txt
RDEPEND_PLUGINS_FRONTEND_TOOLS="
	${RDEPEND_LIBX11}
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,widgets,X]
	)
"

# See plugins/linux-capture/CMakeLists.txt
RDEPEND_PLUGINS_LINUX_CAPTURE="
	${RDEPEND_GLAD}
	${RDEPEND_LIBOBS}
	${RDEPEND_LIBX11}
	${RDEPEND_LIBXCB}
        >=x11-libs/libXcomposite-0.4.5:=
        >=x11-libs/libXfixes-${LIBXFIXES_PV}:=
        >=x11-libs/libXinerama-${LIBXINERAMA_PV}:=
        >=x11-libs/libXrandr-${LIBXRANDR_PV}:=
	pipewire? (
		>=dev-libs/glib-${GLIB_PV}:=
		>=media-video/pipewire-${PIPEWIRE_PV}:=
		>=x11-libs/libdrm-${LIBDRM_PV}:=
	)
"

# For vaapi support, see source code at
# https://github.com/obsproject/obs-studio/pull/1482/commits/2dc67f140d8156d9000db57786e53a4c1597c097
# From inspection, the video_cards_nouveau supports h264 decode but not h264
# encode.  This is why it is omitted below in the vaapi driver section.

PATENT_STATUS_FFMPEG_DEPEND="
	!patent_status_nonfree? (
		!media-libs/fdk-aac
		!media-libs/libva
		!media-libs/x264
		!virtual/vaapi
		$(gen_ffmpeg_depend '-nvenc,-patent_status_nonfree,-vaapi,-x264')
	)
	patent_status_nonfree? (
		fdk? (
			>=media-libs/fdk-aac-${FDK_AAC_PV}:=
		)
		mpegts? (
			>=net-libs/librist-${LIBRIST_PV}:=
			>=net-libs/srt-${SRT_PV}:=
		)
		nvenc? (
			$(gen_ffmpeg_depend 'nvenc,patent_status_nonfree')
			>=media-libs/nv-codec-headers-12:=
		)
		vaapi? (
			$(gen_ffmpeg_depend 'patent_status_nonfree,vaapi')
			>=media-libs/libva-${LIBVA_PV}:=[X,wayland?]
			virtual/vaapi:*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},patent_status_nonfree]
		)
		x264? (
			$(gen_ffmpeg_depend 'patent_status_nonfree,x264')
			>=media-libs/x264-${X264_PV}:=
		)
	)

"
RDEPEND_PLUGINS_OBS_FFMPEG="
	${PATENT_STATUS_FFMPEG_DEPEND}
	>=sys-apps/pciutils-3.10.0:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
"

RDEPEND_CURL="
	>=net-misc/curl-${CURL_PV}:=
"

RDEPEND_PLUGINS_OBS_OUTPUTS="
	${RDEPEND_LIBOBS}
	${RDEPEND_ZLIB}
	>=net-libs/mbedtls-${MBEDTLS_3_PV}:3=
"

RDEPEND_PLUGINS_OBS_BROWSER="
	browser? (
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},widgets,X]
		)
		|| (
			>=net-libs/cef-bin-${CEF_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			>=net-libs/cef-${CEF_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
"

# TODO:  bump libvpl and section to 2023.3.0
RDEPEND_PLUGINS_QSV="
	qsv? (
		elibc_glibc? (
			>=media-libs/libvpl-2.9:=
			|| (
				media-libs/oneVPL-cpu
				>=media-libs/intel-mediasdk-23.2.2
				>=media-libs/vpl-gpu-rt-23.3.1
			)
		)
		elibc_mingw? (
			dev-util/mingw64-runtime:=
		)
	)
"

# Includes rtmp-services
RDEPEND_PLUGINS_RTMP="
	${RDEPEND_DEPS_FILE_UPDATER}
	${RDEPEND_JANSSON}
	${RDEPEND_LIBOBS}
"

RDEPEND_PLUGINS_VST="
	vst? (
		${RDEPEND_LIBOBS}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},widgets,X]
		)
	)
"

RDEPEND_PLUGINS_WEBSOCKET="
	websocket? (
		>=dev-cpp/asio-1.28.1:=
		>=dev-cpp/websocketpp-0.8.2:=
		>=dev-libs/qr-code-generator-1.8.0:=
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},network,widgets]
			>=dev-qt/qtsvg-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
"
DEPEND_PLUGINS_WEBSOCKET="
	websocket? (
		>=dev-cpp/nlohmann_json-${NLOHMANN_JSON_PV}:=
	)
"

# TODO verify libdatachannel
RDEPEND_PLUGINS_WEBRTC="
	webrtc? (
		${RDEPEND_CURL}
		${RDEPEND_LIBOBS}
		>=dev-libs/libdatachannel-${LIBDATACHANNEL_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},nice,media-transport,websocket]
	)
"

# See
# plugins/linux-alsa/CMakeLists.txt
# plugins/linux-jack/CMakeLists.txt
# plugins/linux-v4l2/CMakeLists.txt
# plugins/obs-ffmpeg/CMakeLists.txt
# plugins/obs-ffmpeg/ffmpeg-mux/CMakeLists.txt
# plugins/obs-filters/CMakeLists.txt
# plugins/obs-libfdk/CMakeLists.txt
# plugins/rtmp-services/CMakeLists.txt
# plugins/text-freetype2/CMakeLists.txt
# plugins/vlc-video/CMakeLists.txt
# >=media-sound/jack2-1.9.12
# >=sys-fs/udev-237
# fdk section moved into PATENT_STATUS_FFMPEG_DEPEND section
# x264 section moved into PATENT_STATUS_FFMPEG_DEPEND section
RDEPEND_PLUGINS="
	${RDEPEND_CURL}
	${RDEPEND_DEPS_FILE_UPDATER}
	${RDEPEND_DEPS_MEDIA_PLAYBACK}
	${RDEPEND_LIBOBS}
	${RDEPEND_PLUGINS_AJA}
	${RDEPEND_PLUGINS_DECKLINK}
	${RDEPEND_PLUGINS_DECKLINK_OUTPUT_UI}
	${RDEPEND_PLUGINS_FRONTEND_TOOLS}
	${RDEPEND_PLUGINS_LINUX_CAPTURE}
	${RDEPEND_PLUGINS_OBS_BROWSER}
	${RDEPEND_PLUGINS_OBS_FFMPEG}
	${RDEPEND_PLUGINS_OBS_OUTPUTS}
	${RDEPEND_PLUGINS_SNDIO}
	${RDEPEND_PLUGINS_QSV}
	${RDEPEND_PLUGINS_RTMP}
	${RDEPEND_PLUGINS_RNNOISE}
	${RDEPEND_PLUGINS_VST}
	${RDEPEND_PLUGINS_WEBRTC}
	${RDEPEND_PLUGINS_X264}
	alsa? (
		>=media-libs/alsa-lib-1.2.11:=
	)
	freetype? (
		>=media-libs/fontconfig-2.15.0:=
		>=media-libs/freetype-2.13.2:=
	)
	jack? (
		virtual/jack:*
	)
	speexdsp? (
		>=media-libs/speexdsp-1.2.1:=
	)
	v4l2? (
		${RDEPEND_FFMPEG}
		>=media-libs/libv4l-1.26.1:=[utils]
		virtual/udev:*
	)
	vlc? (
		>=media-video/vlc-3.0.20:=
	)
"
DEPEND_PLUGINS="
	${DEPEND_LIBOBS}
"

# These are not mentioned in .github/workflows/main.yml
# but could not find headers in obs source for these packages.
# They were mentioned in the original ebuild.
RDEPEND_UNSOURCED="
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},sql]
		>=dev-qt/qtdeclarative-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		>=dev-qt/qtmultimedia-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

# See libobs/CMakeLists.txt
RDEPEND_LIBOBS="
	${RDEPEND_FFMPEG}
	${RDEPEND_JANSSON}
	${RDEPEND_LIBX11}
	${RDEPEND_LIBXCB}
	${RDEPEND_ZLIB}
	>=sys-apps/dbus-1.14.10:=
	sys-apps/util-linux:=
	pulseaudio? (
		>=media-libs/libpulse-16.1:=
	)
"
DEPEND_LIBOBS="
	dev-libs/simde:=
	dev-libs/uthash:=
"

RDEPEND_WHATSNEW="
	whatsnew? (
		>=net-libs/mbedtls-${MBEDTLS_3_PV}:3=
	)
"
DEPEND_WHATSNEW="
	whatsnew? (
		>=dev-cpp/nlohmann_json-${NLOHMANN_JSON_PV}:=
	)
"

# See UI/CMakeLists.txt
# qtcore, qtgui is in UI folder but not in *.cmake or CMakeLists.txt
RDEPEND_UI="
	${RDEPEND_CURL}
	${RDEPEND_FFMPEG}
	${RDEPEND_LIBOBS}
	${RDEPEND_WHATSNEW}
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},dbus,gui,network,wayland?,widgets,X,xml]
		>=dev-qt/qtsvg-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		wayland? (
			>=dev-qt/qtdeclarative-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opengl]
			>=dev-qt/qtwayland-${QT6_PV}:${QT6_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
"
DEPEND_UI="
	${DEPEND_LIBOBS}
	${DEPEND_WHATSNEW}
"

# See deps/libff/CMakeLists.txt
RDEPEND_DEPS_LIBFF="
	${RDEPEND_FFMPEG}
"

# Found in multiple CMakeLists.txt
RDEPEND_MESA="
	>=media-libs/mesa-${MESA_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"

# See deps/glad/CMakeLists.txt
RDEPEND_GLAD="
	${RDEPEND_MESA}
	${RDEPEND_LIBX11}
	>=media-libs/libglvnd-1.7.0:=
	>=media-libs/mesa-${MESA_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},egl(+)]
"

# See libobs-opengl/CMakeLists.txt
RDEPEND_LIBOBS_OPENGL="
	${RDEPEND_GLAD}
	${RDEPEND_LIBOBS}
	${RDEPEND_LIBX11}
	${RDEPEND_LIBXCB}
	${RDEPEND_MESA}
	${RDEPEND_WAYLAND}
"

# See deps/obs-scripting/CMakeLists.txt
RDEPEND_DEPS_OBS_SCRIPTING="
	${RDEPEND_LIBOBS}
	lua? (
		>=dev-lang/luajit-2.1.0:2=
	)
	python? (
		${PYTHON_DEPS}
	)
"

# See deps/media-playback/CMakeLists.txt
RDEPEND_DEPS_MEDIA_PLAYBACK="
	${RDEPEND_FFMPEG}
"

# See deps/file-updater/CMakeLists.txt
RDEPEND_DEPS_FILE_UPDATER="
	${RDEPEND_CURL}
"

# See deps/CMakeLists.txt
RDEPEND_DEPS="
	${RDEPEND_DEPS_FILE_UPDATER}
	${RDEPEND_DEPS_LIBFF}
	${RDEPEND_DEPS_MEDIA_PLAYBACK}
	${RDEPEND_DEPS_OBS_SCRIPTING}
	${RDEPEND_JANSSON}
"

# See CMakeLists.txt
#	${RDEPEND_UNSOURCED} # testing as disabled
RDEPEND+="
	${RDEPEND_DEPS}
	${RDEPEND_PLUGINS}
	${RDEPEND_UI}
	test? (
		${RDEPEND_LIBOBS}
	)
"

DEPEND+="
	${RDEPEND}
	${DEPEND_PLUGINS}
	${DEPEND_UI}
"

# Based on 20.04 See
# azure-pipelines.yml
# .github/workflows/main.yml
# deps/obs-scripting/obslua/CMakeLists.txt
# deps/obs-scripting/obspython/CMakeLists.txt
BDEPEND+="
	>=app-misc/jq-1.7.1
	>=dev-build/cmake-3.28.3
	>=dev-util/pkgconf-1.8.0[pkg-config(+)]
	lua? (
		>=dev-lang/swig-${SWIG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-${SWIG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	test? (
		>=dev-util/cmocka-1.1.7
		websocket? (
			>=dev-libs/boost-1.83.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[X]
	)
"

# The obs-amd-encoder submodule currently doesn't support Linux
# https://github.com/obsproject/obs-amd-encoder/archive/${OBS_AMD_ENCODER_COMMIT}.tar.gz \
#	-> obs-amd-encoder-${OBS_AMD_ENCODER_COMMIT}.tar.gz

PATCHES=(
	"${FILESDIR}/${PN}-30.2.3-hevc-preprocessor-cond.patch"
	"${FILESDIR}/${PN}-32.0.2-browser-checks.patch"
	"${FILESDIR}/${PN}-32.0.2-optionalize-plugins.patch"
	"${FILESDIR}/${PN}-32.1.2-symbolize-default-codecs.patch"
)

CEF_PATCHES=(
	"${FILESDIR}/${PN}-32.1.2-use-cxx20.patch"
	"${FILESDIR}/${PN}-32.1.2-obs-browser-use-cxx20.patch"
	"${FILESDIR}/${PN}-32.1.2-obs-browser-relax-version.patch"
	"${FILESDIR}/${PN}-32.1.2-obs-browser-shared-wrapper-suffix.patch"
)

qt_check() {
	local slot="${1}"
	local QTCORE_PV=$(pkg-config --modversion Qt${slot}Core)
	local QTGUI_PV=$(pkg-config --modversion Qt${slot}Gui)
#	local QTMULTIMEDIA_PV=$(pkg-config --modversion Qt${slot}Multimedia)
	local QTNETWORK_PV=$(pkg-config --modversion Qt${slot}Network)
#	local QTSQL_PV=$(pkg-config --modversion Qt${slot}Sql)
	local QTSVG_PV=$(pkg-config --modversion Qt${slot}Svg)
#	local QTQML_PV=$(pkg-config --modversion Qt${slot}Qml)
#	local QTQUICKCONTROLS_PV=$(pkg-config --modversion Qt${slot}QuickControls)
	local QTWIDGETS_PV=$(pkg-config --modversion Qt${slot}Widgets)
	local QTXML_PV=$(pkg-config --modversion Qt${slot}Xml)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt${slot}Core is not the same version as Qt${slot}Gui"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTMULTIMEDIA_PV} ; then
#		die "Qt${slot}Core is not the same version as Qt${slot}Multimedia"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTNETWORK_PV} ; then
		die "Qt${slot}Core is not the same version as Qt${slot}Network"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTSQL_PV} ; then
#		die "Qt${slot}Core is not the same version as Qt${slot}Sql"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt${slot}Core is not the same version as Qt${slot}Svg"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
#		die "Qt${slot}Core is not the same version as Qt${slot}Qml (qtdeclarative)"
#	fi
#	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS_PV} ; then
#		die "Qt${slot}Core is not the same version as Qt${slot}QuickControls"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt${slot}Core is not the same version as Qt${slot}Widgets"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt${slot}Core is not the same version as Qt${slot}Xml"
	fi
}

#
# This should be preformed when the die hook is called also, but the ebuild
# system doesn't support this!
#
# Before compile finishes (or specifically before sanitize_login_tokens gets
# called), this info will be in plaintext or *unsanitized* because the die hook
# cannot be called.
#
# So the package manager is flawed and needs a special API or hooks to clean
# up sensitive information when emerge crashes.
#
sanitize_login_tokens() {
	export RESTREAM_CLIENTID=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export RESTREAM_HASH=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export TWITCH_CLIENTID=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export TWITCH_HASH=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export YOUTUBE_CLIENTID=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export YOUTUBE_CLIENTID_HASH=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export YOUTUBE_SECRET=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	export YOUTUBE_SECRET_HASH=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	unset RESTREAM_CLIENTID
	unset RESTREAM_HASH
	unset TWITCH_CLIENTID
	unset TWITCH_HASH
	unset YOUTUBE_CLIENTID
	unset YOUTUBE_CLIENTID_HASH
	unset YOUTUBE_SECRET
	unset YOUTUBE_SECRET_HASH
}

pkg_setup() {
	use qt6 && qt_check 6
	use lua && lua-single_pkg_setup
	python-single-r1_pkg_setup

	if use browser ; then
		if [[ "${ABI}" =~ "ppc" ]] ; then
			if ! has_version "net-libs/cef" ; then
eerror "There is no CEF for this platform.  Disable the browser USE flag."
				die
			fi
		fi
	fi

	if ! use v4l2 ; then
		ewarn "WebCam capture is possibly disabled.  Enable with the v4l2 USE flag."
	fi

#
# Doing something like...
#
# SN_CLIENT="xxx" SN_HASH="yyy" emerge -1vuDN obs-studio
#
# can save data in environment.bz2 in plaintext in multiple prior packages.
# This information should only be passed via package.env or via prompt
# with immediate sanitation.
#
ewarn
ewarn "Do not provide or pass *_CLIENTID or *_HASH environment variables"
ewarn "from command line or when multiple packages are being emerged"
ewarn "prior to ${PN}.  This package alone should be emerged alone"
ewarn "when this information is provided."
ewarn
ewarn "After being built, this information provided via package.env or"
ewarn "by patch should be sanitized with shred from forensics attacks."
ewarn
	sleep 1

	if ! use browser || \
		[[ -z "${RESTREAM_CLIENTID}" || -z "${RESTREAM_HASH}" ]] ; then
ewarn
ewarn "Restream integration is disabled.  For details on how to enable it, see"
ewarn "the metadata.xml or \`epkginfo -x obs-studio::oiledmachine-overlay\`."
ewarn "The browser USE flag must be enabled."
ewarn
	fi

	if ! use browser \
		|| [[ -z "${TWITCH_CLIENTID}" || -z "${TWITCH_HASH}" ]] ; then
ewarn
ewarn "Twitch integration is disabled.  For details on how to enable it, see"
ewarn "the metadata.xml or \`epkginfo -x obs-studio::oiledmachine-overlay\`."
ewarn "The browser USE flag must be enabled."
ewarn
	fi

	if [[ \
		   -z "${YOUTUBE_CLIENTID}" \
		|| -z "${YOUTUBE_CLIENTID_HASH}" \
		|| -z "${YOUTUBE_SECRET}" \
		|| -z "${YOUTUBE_SECRET_HASH}" \
	]] ; then
ewarn
ewarn "YT integration is disabled.  For details on how to enable it, see the"
ewarn "metadata.xml or \`epkginfo -x obs-studio::oiledmachine-overlay\`."
ewarn
	fi
ewarn
ewarn "SECURITY:  When building with streaming services integration, read the"
ewarn "metadata.xml or do \`epkginfo -x obs-studio::oiledmachine-overlay\`"
ewarn "for information of securely wiping with the shred command or minimizing"
ewarn "recovery of possibly sensitive data."
ewarn

einfo
einfo "All services are unlisted by default in this ebuild.  To setup streaming"
einfo "service whitelists, see metadata.xml or"
einfo "\`epkginfo -x ${CATEGORY}/${PN}::oiledmachine-overlay\`"
einfo

	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/libdshowcapture-${LIBDSHOWCAPTURE_COMMIT}" "${S}/deps/libdshowcapture/src"
		dep_prepare_mv "${WORKDIR}/capture-device-support-${CAPTURE_DEVICE_SUPPORT}" "${S}/deps/libdshowcapture/src/external/capture-device-support"
		if use browser ; then
			dep_prepare_mv "${WORKDIR}/obs-browser-${OBS_BROWSER_COMMIT}" "${S}/plugins/obs-browser"
		fi
		dep_prepare_mv "${WORKDIR}/obs-websocket-${OBS_WEBSOCKET_COMMIT}" "${S}/plugins/obs-websocket"
	fi
}

src_prepare() {
	cmake_src_prepare

	# typos
	sed -i -e "s|LIBVA_LBRARIES|LIBVA_LIBRARIES|g" \
		"${S}/plugins/obs-ffmpeg/CMakeLists.txt" \
		|| die

#	if use browser ; then
#		sed -i -e "s|libcef_dll_wrapper.a|libcef_dll_wrapper.so|g" \
#			"${S}/cmake/finders/FindCEF.cmake" \
#			|| die
#	fi

	if use patent_status_nonfree ; then
	# Upstream defaults
		sed -i \
			-e "s|@DEFAULT_AUDIO_CODEC_CLASS@|aac|g" \
			-e "s|@DEFAULT_AUDIO_CODEC_IMPL@|ffmpeg_aac|g" \
			-e "s|@DEFAULT_SIMPLE_ENCODER_VIDEO@|SIMPLE_ENCODER_X264|g" \
			-e "s|@DEFAULT_VIDEO_CODEC_IMPL@|obs_x264|g" \
			-e "s|@DEFAULT_STREAMING_ENCODER@|x264|g" \
			-e "s|@DEFAULT_CODEC_VIDEO_TEST1@|obs_x264|g" \
			-e "s|@DEFAULT_CODEC_VIDEO_TEST2@|test_x264|g" \
			-e "s|@DEFAULT_CODEC_AUDIO_TEST1@|ffmpeg_aac|g" \
			-e "s|@DEFAULT_CODEC_AUDIO_TEST2@|test_aac|g" \
			"frontend/widgets/OBSBasic.cpp" \
			"frontend/wizards/AutoConfig.hpp" \
			"frontend/wizards/AutoConfigTestPage.cpp" \
			|| die
	else
		local default_simple_encoder_video=""
		local default_audio_codec_class=""
		local default_audio_codec_impl=""
		local default_simple_video_impl=""
		local default_video_codec_impl=""
		local default_streaming_encoder=""
		if use opus ; then
			default_audio_codec_class="opus"
			default_audio_codec_impl="ffmpeg_opus"
			default_codec_audio_test1="ffmpeg_opus"
			default_codec_audio_test2="test_opus"
		fi
		if use svt-av1 ; then
			default_simple_encoder_video="SIMPLE_ENCODER_SVT_AV1"
			default_video_codec_impl="ffmpeg_svt_av1"
			default_streaming_encoder="SVT_AV1"
			default_codec_video_test1="ffmpeg_svt_av1"
			default_codec_video_test2="test_av1"
		elif use libaom ; then
			default_simple_encoder_video="SIMPLE_ENCODER_AOM"
			default_video_codec_impl="ffmpeg_aom_av1"
			default_streaming_encoder="AOM"
			default_codec_video_test1="ffmpeg_aom_av1"
			default_codec_video_test2="test_av1"
		fi
		sed -i \
			-e "s|@DEFAULT_AUDIO_CODEC_CLASS@|${default_audio_codec_class}|g" \
			-e "s|@DEFAULT_AUDIO_CODEC_IMPL@|${default_audio_codec_impl}|g" \
			-e "s|@DEFAULT_SIMPLE_ENCODER_VIDEO@|${default_simple_encoder_video}|g" \
			-e "s|@DEFAULT_VIDEO_CODEC_IMPL@|${default_video_codec_impl}|g" \
			-e "s|@DEFAULT_STREAMING_ENCODER@|${default_streaming_encoder}|g" \
			-e "s|@DEFAULT_CODEC_VIDEO_TEST1@|${default_codec_video_test1}|g" \
			-e "s|@DEFAULT_CODEC_VIDEO_TEST2@|${default_codec_video_test2}|g" \
			-e "s|@DEFAULT_CODEC_AUDIO_TEST1@|${default_codec_audio_test1}|g" \
			-e "s|@DEFAULT_CODEC_AUDIO_TEST2@|${default_codec_audio_test2}|g" \
			"frontend/widgets/OBSBasic.cpp" \
			"frontend/wizards/AutoConfig.hpp" \
			"frontend/wizards/AutoConfigTestPage.cpp" \
			|| die
	fi
	if use browser ; then
		eapply "${CEF_PATCHES[@]}"
	fi
}

gen_rtmp_services() {
	if [[ -z "${OBS_STUDIO_STREAMING_SERVICES_WHITELIST}" ]] ; then
		einfo "Removing streaming services from services whitelist"
		jq '{"$schema","format_version","services": [.services[] | select(null)]}' \
			"${S}/plugins/rtmp-services/data/services.json" \
			> "${S}/plugins/rtmp-services/data/services.json.t" \
			|| die
		mv "${S}/plugins/rtmp-services/data/services.json"{.t,} || die
		return
	fi

	export IFS=";"
	local services=""
	local s
	for s in ${OBS_STUDIO_STREAMING_SERVICES_WHITELIST} ; do
		einfo "Added ${s} streaming service to services whitelist"
		services+=" or .name==\"${s}\""
	done
	export IFS=$' \t\n'

	jq '{"$schema","format_version","services": [.services[] | select(null '"${services}"')]}' \
		"${S}/plugins/rtmp-services/data/services.json" \
		> "${S}/plugins/rtmp-services/data/services.json.t" \
		|| die
	mv "${S}/plugins/rtmp-services/data/services.json"{.t,} || die
}

src_configure() {
	chkl_check_many_timestamps
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"


	if use browser ; then
		if has_version "=net-libs/cef-bin-9999" ; then
			local merged_timestamp=$(cat "${ESYSROOT}/var/db/pkg/net-libs/cef-bin-9999/BUILD_TIME")
			local current_timestamp=$(date "+%s")
			local insecure_timestamp=$(( ${current_timestamp} - $(( 60 * 60 * 24 * 15 )) )) # -15 days or ~2 weeks
			if (( ${merged_timestamp} < ${insecure_timestamp} )) ; then
eerror
eerror "SECURITY:  The current prebuilt CEF has passed its security expiration"
eerror "date."
eerror
eerror "Please re-emerge the =net-libs/cef-bin-9999 ebuild or"
eerror "disable the browser USE flag to continue."
eerror
eerror "Current date:  "$(date --date="@${current_timestamp}")
eerror "CEF last update:  "$(date --date="@${merged_timestamp}")
eerror "Security expiration date:  "$(date --date="@${insecure_timestamp}")
eerror
				die
			fi
		fi
	fi

	# For obs-browser
	# obs-browser-source.cpp:25:10: fatal error: QApplication: No such file or directory
	# browser-client.cpp:27:10: fatal error: QThread: No such file or directory
	if use qt6 ; then
		append-cppflags "-I${ESYSROOT}/usr/include/qt6"
		append-cppflags "-I${ESYSROOT}/usr/include/qt6/QtWidgets"
		append-cppflags "-I${ESYSROOT}/usr/include/qt6/QtCore"
	fi

	ffmpeg_src_configure

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DENABLE_AAC=$(usex aac)
		-DENABLE_AJA=$(usex aja)
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AOM=$(usex libaom)
		-DENABLE_BROWSER=$(usex browser)
		-DENABLE_BROWSER_PANELS=$(usex browser-panels)
		-DENABLE_COREAUDIO=$(usex coreaudio)
		-DENABLE_COREAUDIO_ENCODER=$(usex coreaudio)
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FDK=$(usex fdk)
		-DENABLE_FLAC=$(usex flac)
		-DENABLE_FREETYPE=$(usex freetype)
		-DENABLE_HEVC=$(usex hevc)
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_NEW_MPEGTS_OUTPUT=$(usex mpegts)
		-DENABLE_NATIVE_NVENC=$(usex nvenc)
		-DENABLE_NVENC=$(usex nvenc)
		-DENABLE_OSS=$(usex oss)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PLUGINS=ON
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_QSV11=$(usex qsv)
		-DENABLE_RNNOISE=$(usex rnnoise)
		-DENABLE_RTMPS=$(usex rtmps)
		-DENABLE_SNDIO=$(usex sndio)
		-DENABLE_SERVICE_UPDATES=$(usex service-updates)
		-DENABLE_SPEEXDSP=$(usex speexdsp)
		-DENABLE_SVT_AV1=$(usex svt-av1)
		-DENABLE_UPDATER=OFF
		-DENABLE_V4L2=$(usex v4l2)
		-DENABLE_VLC=$(usex vlc)
		-DENABLE_VST=$(usex vst)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_WEBRTC=$(usex webrtc)
		-DENABLE_WEBSOCKET=$(usex websocket)
		-DENABLE_WINMF=$(usex win-mf)
		-DENABLE_WHATSNEW=$(usex whatsnew)
		-DENABLE_X264=$(usex x264)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DUNIX_STRUCTURE=1
	)

	local clang_slot=$(clang-major-version)
	if tc-is-clang && has_version "=llvm-runtimes/clang-runtime-${clang_slot}*[libcxx]" ; then
		mycmakeargs+=(
			-DUSE_LIBCXX=ON
		)
	fi

	if use kernel_Darwin ; then
		mycmakeargs+=(
			-DBUILD_VIRTUALCAM=$(usex virtualcam)
		)
	fi

	if [ "${PV}" != "9999" ]; then
		mycmakeargs+=(
			-DOBS_VERSION_OVERRIDE=${PV}
		)
	fi

	if use browser ; then
		local cef_suffix=""
		has_version 'net-libs/cef-bin' && cef_suffix="-bin"
		mycmakeargs+=(
			-DCEF_ROOT_DIR="${ESYSROOT}/opt/cef${cef_suffix}"
		)
	fi

	if use lua || use python; then
		mycmakeargs+=(
			-DENABLE_SCRIPTING_LUA=$(usex lua)
			-DENABLE_SCRIPTING_PYTHON=$(usex python)
			-DENABLE_SCRIPTING=yes
		)
	else
		mycmakeargs+=(
			-DENABLE_SCRIPTING=no
		)
	fi

	if use vaapi ; then
		VA_LIBS=$($(get_abi_CHOST ${ABI})-pkg-config --libs libva)
		mycmakeargs+=(
			-DLIBVA_LIBRARIES="${VA_LIBS}"
		)
	fi

	gen_rtmp_services

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	# External plugins may need some things not installed by default"
	# Install them here.
	insinto "/usr/include/obs/obs-frontend-api"
	doins "frontend/api/obs-frontend-api.h"

	docinto "licenses"
	dodoc "COMMITMENT"

	if use browser ; then
		local cef_prefix="/opt/cef-bin"
		[[ -e "${EROOT}/opt/cef" ]] && cef_prefix="/opt/cef"
		exeinto "/usr/$(get_libdir)/obs-plugins/"
		if [[ -e "${EROOT}${cef_prefix}/libcef_dll_wrapper/libcef_dll_wrapper.so" ]] ; then
			doexe "${EROOT}${cef_prefix}/libcef_dll_wrapper/libcef_dll_wrapper.so"
		fi
	fi

	# The about dialog doesn't show all the copyright notices.
	LCNR_SOURCE="${S}"
	lcnr_install_files
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! use alsa && ! use pulseaudio; then
elog
elog "For the audio capture features to be available, either the 'alsa' or the"
elog "'pulseaudio' USE-flag needs to be enabled."
elog
	fi

	if ! has_version "sys-apps/dbus"; then
elog
elog "The 'sys-apps/dbus' package is not installed, but could be used for"
elog "disabling hibernating, screensaving, and sleeping.  Where it is not"
elog "installed, 'xdg-screensaver reset' is used instead (if"
elog "'x11-misc/xdg-utils' is installed)."
elog
	fi

	if use browser ; then
ewarn
ewarn "Security notice:"
ewarn
ewarn "Since the browser feature uses the Chromium source code as a base,"
ewarn "you need to update/re-emerge cef-bin and obs-studio the same time"
ewarn "Chromium updates to avoid critical vulerabilities."
ewarn
ewarn "Currently the net-libs/cef-bin is not CFI protected against code"
ewarn "execution.  Consider using Window Capture of a CFI protected -bin"
ewarn "browser package instead for full protection using Window Capture as a"
ewarn "source."
ewarn
	fi

	if use vaapi ; then
einfo
einfo "VAAPI support is found at File > Settings > Output > Output Mode:"
einfo "Advanced > Streaming > Encoder > FFMPEG VAAPI"
einfo
	fi

ewarn
ewarn "SECURITY NOTICE:"
ewarn
ewarn "When building with streaming services integration, read the metadata.xml"
ewarn "or do \`epkginfo -x obs-studio::oiledmachine-overlay\` for information"
ewarn "of securely wiping with the shred command or minimizing recovery of"
ewarn "possibly sensitive data."
ewarn

einfo
einfo "The ~/.config/obs-studio/plugin_config/rtmp-services folder may need to"
einfo "be removed in order for services to be listed."
einfo

einfo
einfo "The ~/.config/obs-studio folder may need to be completely removed in"
einfo "order to unbreak access to the Settings menu."
einfo
}

pkg_postrm() {
	xdg_icon_cache_update
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  proper-hardware-accelerated-h264-support, build-with-social-media-info
# OILEDMACHINE-OVERLAY-META-TAGS:  link-to-unvulnerable-blink-derivative
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 29.1.2 (20230608) with qt5 only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 29.1.3 (20230625) with qt6 only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 32.1.2 (20230625) with qt6, cef-bin 147.0.10+gd58e84d+chromium-147.0.7727.118_linux64, v4l2
# USE="browser qt6 v4l2 vaapi -aja -alsa -amf -browser-panels -coreaudio
# -decklink -fdk -freetype -ftl -hevc -ipv6 -jack -libaom -lua -mac-syphon
# -mpegts -nvafx -nvenc -nvvfx -oss -pipewire -pulseaudio -python
# -qsv (-qt5) -r3 -rnnoise -rtmps -service-updates -sndio -speexdsp -svt-av1
# -test -virtualcam -vlc -vst -wayland -websocket -whatsnew -win-dshow -win-mf
# -x264"
# LUA_SINGLE_TARGET="-luajit"
# PYTHON_SINGLE_TARGET="python3_10"
# browser test:  passed with 114.2.10+g398e3c3+chromium-114.0.5735.110_linux64_minimal
# v4l2 test:  passed
