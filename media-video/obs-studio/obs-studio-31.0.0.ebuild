# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# TODO package:
# nvafx
# nvvfx

#
# To find differences between release use:
#
# S1="/var/tmp/portage/media-video/obs-studio-30.1.2/work/obs-studio-30.1.2" \
# S2="/var/tmp/portage/media-video/obs-studio-30.2.3/work/obs-studio-30.2.3" ; \
# for x in $(find ${S2} -name "CMakeLists.txt" -o -name "*.cmake" | cut -f 9- -d "/" | sort) ; do \
#   diff -urp "${S1}/${x}" "${S2}/${x}" ; \
# done
#

# 95 is EOL.  The current Cr version is 122.
# See also
# https://github.com/obsproject/obs-studio/blob/30.1.0/build-aux/modules/99-cef.json
# https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding
# https://bitbucket.org/chromiumembedded/cef/src/5060/CHROMIUM_BUILD_COMPATIBILITY.txt?at=5060
CAPTURE_DEVICE_SUPPORT_COMMIT="81c94fb13dfddb412fcb17f1ba031917ec24be64"
CEF_PV="95" # See https://github.com/obsproject/obs-browser/blob/a76b4d8810a0a33e91ac5b76a0b1af2f22bf8efd/CMakeLists.txt#L12
CMAKE_REMOVE_MODULES_LIST=( "FindFreetype" )
FFMPEG_COMPAT=(
	"0/58.60.60" # 6.1
)
LIBDSHOWCAPTURE_COMMIT="ef8c1d2e19c93e664100dd41e1a0df4f8ad45430"
LIBVA_PV="2.20.0"
LIBX11_PV="1.8.7"
LUA_COMPAT=( "luajit" )
MAKEOPTS="-j1"
MESA_PV="24.0.5"
OBS_BROWSER_COMMIT="a76b4d8810a0a33e91ac5b76a0b1af2f22bf8efd"
OBS_WEBSOCKET_COMMIT="eed8a49933786383d11f4868a4e5604a9ee303c6"
PATENT_STATUS_IUSE=(
	patent_status_nonfree
)
PYTHON_COMPAT=( "python3_"{8..11} )
QT6_PV="6.4.2"
QT6_SLOT="$(ver_cut 1 ${QT6_PV})"
SWIG_PV="4.2.0"

inherit cmake dep-prepare flag-o-matic git-r3 lcnr lua-single python-single-r1 xdg-utils

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_COMMIT="${PV}"
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	FALLBACK_COMMIT="144599fbff18e348652ccadfc3ca08794a03d970"
	IUSE+=" fallback-commit"
	inherit git
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/elgatosf/capture-device-support/archive/${CAPTURE_DEVICE_SUPPORT_COMMIT}.tar.gz
	-> capture-device-support-${CAPTURE_DEVICE_SUPPORT_COMMIT:0:7}.tar.gz
https://github.com/obsproject/libdshowcapture/archive/${LIBDSHOWCAPTURE_COMMIT}.tar.gz
	-> libdshowcapture-${LIBDSHOWCAPTURE_COMMIT:0:7}.tar.gz
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
+freetype +hevc +ipv6 jack libaom +lua mac-syphon +mpegts nvafx
nvenc nvvfx opus oss +pipewire +pulseaudio +python qsv +qt6 +rnnoise +rtmps
+service-updates -sndio +speexdsp svt-av1 -test +v4l2 vaapi +vlc +virtualcam
+vst +wayland +webrtc win-dshow +websocket -win-mf +whatsnew x264

ebuild_revision_14
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
		>=dev-lang/swig-${SWIG_PV}
	)
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-${SWIG_PV}
	)
	test? (
		>=dev-util/cmocka-1.1.7
		websocket? (
			>=dev-libs/boost-1.83.0
		)
	)
"
PDEPEND+="
	firejail? (
		sys-apps/firejail[firejail_profiles_obs,X]
	)
"

gen_ffmpeg_depend() {
	local use_deps="${1}"
	echo "
		|| (
	"
	local s
	for s in ${FFMPEG_COMPAT[@]} ; do
		echo "
			media-video/ffmpeg:${s}${use_deps}
		"
	done
	echo "
		)
		media-video/ffmpeg:=
	"
}

DEPEND_FFMPEG="
	$(gen_ffmpeg_depend '[libaom?,opus?,svt-av1?]')
"

DEPEND_LIBX11="
	kernel_linux? (
	        >=x11-libs/libX11-${LIBX11_PV}
	)
"

DEPEND_LIBXCB="
        >=x11-libs/libxcb-1.14
"

DEPEND_JANSSON="
	>=dev-libs/jansson-2.13.1
"

DEPEND_WAYLAND="
	wayland? (
		>=dev-libs/wayland-1.34
		>=x11-libs/libxkbcommon-1.6.0
	)
"

DEPEND_ZLIB="
	>=sys-libs/zlib-1.3
"

DEPEND_PLUGINS_AJA="
	aja? (
		${DEPEND_LIBX11}
		media-libs/ntv2
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[gui,widgets,X]
			dev-qt/qtbase:=
		)
	)
"

DEPEND_PLUGINS_RNNOISE="
	rnnoise? (
		media-libs/rnnoise
	)
"

# See plugins/sndio/CMakeLists.txt
DEPEND_PLUGINS_SNDIO="
	sndio? (
		${DEPEND_LIBOBS}
		>=media-sound/sndio-1.9.0
	)
"

# See UI/frontend-plugins/decklink-captions/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_CAPTIONS="
	decklink? (
		${DEPEND_LIBX11}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[widgets,X]
			dev-qt/qtbase:=
		)
	)
"

# See UI/frontend-plugins/decklink-output-ui/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_OUTPUT_UI="
	decklink? (
		${DEPEND_LIBX11}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[gui,widgets,X]
			dev-qt/qtbase:=
		)
	)
"

# See plugins/decklink/linux/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK="
	decklink? (
		${DEPEND_LIBOBS}
		${DEPEND_PLUGINS_DECKLINK_CAPTIONS}
	)
"

# See UI/frontend-plugins/frontend-tools/CMakeLists.txt
DEPEND_PLUGINS_FRONTEND_TOOLS="
	${DEPEND_LIBX11}
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[gui,widgets,X]
		dev-qt/qtbase:=
	)
"

# See plugins/linux-capture/CMakeLists.txt
DEPEND_PLUGINS_LINUX_CAPTURE="
	${DEPEND_GLAD}
	${DEPEND_LIBOBS}
	${DEPEND_LIBX11}
	${DEPEND_LIBXCB}
        >=x11-libs/libXcomposite-0.4.5
        >=x11-libs/libXfixes-6.0.0
        >=x11-libs/libXinerama-1.1.4
        >=x11-libs/libXrandr-1.5.2
	pipewire? (
		>=dev-libs/glib-2.80.0:2
		>=media-video/pipewire-1.0.5
		>=x11-libs/libdrm-2.4.120
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
		!media-libs/vaapi-drivers
		!media-libs/x264
		$(gen_ffmpeg_depend '[-nvenc,-patent_status_nonfree,-vaapi,-x264]')
	)
	patent_status_nonfree? (
		fdk? (
			>=media-libs/fdk-aac-2.0.2
			media-libs/fdk-aac:=
		)
		mpegts? (
			>=net-libs/librist-0.2.10
			>=net-libs/srt-1.5.3
		)
		nvenc? (
			$(gen_ffmpeg_depend '[nvenc,patent_status_nonfree]')
			>=media-libs/nv-codec-headers-12
			media-libs/nv-codec-headers:=
		)
		vaapi? (
			$(gen_ffmpeg_depend '[patent_status_nonfree,vaapi]')
			>=media-libs/libva-${LIBVA_PV}[X,wayland?]
			media-libs/vaapi-drivers[patent_status_nonfree]
		)
		x264? (
			$(gen_ffmpeg_depend '[patent_status_nonfree,x264]')
			>=media-libs/x264-0.0.20210613
		)
	)

"
DEPEND_PLUGINS_OBS_FFMPEG="
	${PATENT_STATUS_FFMPEG_DEPEND}
	>=sys-apps/pciutils-3.10.0
	x11-libs/libdrm
"

DEPEND_CURL="
	>=net-misc/curl-8.5.0
"

DEPEND_PLUGINS_OBS_OUTPUTS="
	${DEPEND_LIBOBS}
	${DEPEND_ZLIB}
	>=net-libs/mbedtls-2.28.8
	net-libs/mbedtls:=
"

DEPEND_PLUGINS_OBS_BROWSER="
	browser? (
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[widgets,X]
			dev-qt/qtbase:=
		)
		|| (
			(
				>=net-libs/cef-bin-${CEF_PV}
				net-libs/cef-bin:=
			)
			(
				>=net-libs/cef-${CEF_PV}
				net-libs/cef:=
			)
		)
	)
"

# TODO:  bump libvpl and section to 2023.3.0
DEPEND_PLUGINS_QSV="
	qsv? (
		elibc_glibc? (
			>=media-libs/libvpl-2.9
			|| (
				media-libs/oneVPL-cpu
				>=media-libs/intel-mediasdk-23.2.2
				>=media-libs/vpl-gpu-rt-23.3.1
			)
		)
		elibc_mingw? (
			dev-util/mingw64-runtime
		)
	)
"

# Includes rtmp-services
DEPEND_PLUGINS_RTMP="
	${DEPEND_DEPS_FILE_UPDATER}
	${DEPEND_JANSSON}
	${DEPEND_LIBOBS}
"

DEPEND_PLUGINS_VST="
	vst? (
		${DEPEND_LIBOBS}
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[widgets,X]
			dev-qt/qtbase:=
		)
	)
"

DEPEND_PLUGINS_WEBSOCKET="
	websocket? (
		>=dev-cpp/asio-1.28.1
		>=dev-cpp/nlohmann_json-3.11.3
		>=dev-cpp/websocketpp-0.8.2
		>=dev-libs/qr-code-generator-1.8.0
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[network,widgets]
			dev-qt/qtbase:=
			>=dev-qt/qtsvg-${QT6_PV}:${QT6_SLOT}
			dev-qt/qtsvg:=
		)
	)
"

# TODO verify libdatachannel
DEPEND_PLUGINS_WEBRTC="
	webrtc? (
		${DEPEND_CURL}
		${DEPEND_LIBOBS}
		>=dev-libs/libdatachannel-0.20.1[nice,media-transport,websocket]
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
DEPEND_PLUGINS="
	${DEPEND_CURL}
	${DEPEND_DEPS_FILE_UPDATER}
	${DEPEND_DEPS_MEDIA_PLAYBACK}
	${DEPEND_LIBOBS}
	${DEPEND_PLUGINS_AJA}
	${DEPEND_PLUGINS_DECKLINK}
	${DEPEND_PLUGINS_DECKLINK_OUTPUT_UI}
	${DEPEND_PLUGINS_FRONTEND_TOOLS}
	${DEPEND_PLUGINS_LINUX_CAPTURE}
	${DEPEND_PLUGINS_OBS_BROWSER}
	${DEPEND_PLUGINS_OBS_FFMPEG}
	${DEPEND_PLUGINS_OBS_OUTPUTS}
	${DEPEND_PLUGINS_SNDIO}
	${DEPEND_PLUGINS_QSV}
	${DEPEND_PLUGINS_RTMP}
	${DEPEND_PLUGINS_RNNOISE}
	${DEPEND_PLUGINS_VST}
	${DEPEND_PLUGINS_WEBRTC}
	${DEPEND_PLUGINS_X264}
	alsa? (
		>=media-libs/alsa-lib-1.2.11
	)
	freetype? (
		>=media-libs/fontconfig-2.15.0
		>=media-libs/freetype-2.13.2
	)
	jack? (
		virtual/jack
	)
	speexdsp? (
		>=media-libs/speexdsp-1.2.1
	)
	v4l2? (
		${DEPEND_FFMPEG}
		>=media-libs/libv4l-1.26.1[utils]
		virtual/udev
	)
	vlc? (
		>=media-video/vlc-3.0.20
		media-video/vlc:=
	)
"

# These are not mentioned in .github/workflows/main.yml
# but could not find headers in obs source for these packages.
# They were mentioned in the original ebuild.
DEPEND_UNSOURCED="
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[sql]
		dev-qt/qtbase:=
		>=dev-qt/qtdeclarative-${QT6_PV}:${QT6_SLOT}
		dev-qt/qtdeclarative:=
		>=dev-qt/qtmultimedia-${QT6_PV}:${QT6_SLOT}
		dev-qt/qtmultimedia:=
	)
"

# See libobs/CMakeLists.txt
DEPEND_LIBOBS="
	${DEPEND_FFMPEG}
	${DEPEND_JANSSON}
	${DEPEND_LIBX11}
	${DEPEND_LIBXCB}
	${DEPEND_ZLIB}
	>=sys-apps/dbus-1.14.10
	dev-libs/uthash
	sys-apps/util-linux
	pulseaudio? (
		>=media-sound/pulseaudio-16.1
	)
"

DEPEND_WHATSNEW="
	whatsnew? (
		>=dev-cpp/nlohmann_json-3.11.3
		net-libs/mbedtls
	)
"

# See UI/CMakeLists.txt
# qtcore, qtgui is in UI folder but not in *.cmake or CMakeLists.txt
DEPEND_UI="
	${DEPEND_CURL}
	${DEPEND_FFMPEG}
	${DEPEND_LIBOBS}
	${DEPEND_WHATSNEW}
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:${QT6_SLOT}[dbus,gui,network,wayland?,widgets,X,xml]
		dev-qt/qtbase:=
		>=dev-qt/qtsvg-${QT6_PV}:${QT6_SLOT}
		dev-qt/qtsvg:=
		wayland? (
			>=dev-qt/qtdeclarative-${QT6_PV}:${QT6_SLOT}[opengl]
			dev-qt/qtdeclarative:=
			>=dev-qt/qtwayland-${QT6_PV}:${QT6_SLOT}
			dev-qt/qtwayland:=
		)
	)
"

# See deps/libff/CMakeLists.txt
DEPEND_DEPS_LIBFF="
	${DEPEND_FFMPEG}
"

# Found in multiple CMakeLists.txt
DEPEND_MESA="
	>=media-libs/mesa-${MESA_PV}
"

# See deps/glad/CMakeLists.txt
DEPEND_GLAD="
	${DEPEND_MESA}
	${DEPEND_LIBX11}
	>=media-libs/libglvnd-1.7.0
	>=media-libs/mesa-${MESA_PV}[egl(+)]
"

# See libobs-opengl/CMakeLists.txt
DEPEND_LIBOBS_OPENGL="
	${DEPEND_GLAD}
	${DEPEND_LIBOBS}
	${DEPEND_LIBX11}
	${DEPEND_LIBXCB}
	${DEPEND_MESA}
	${DEPEND_WAYLAND}
"

# See deps/obs-scripting/CMakeLists.txt
DEPEND_DEPS_OBS_SCRIPTING="
	${DEPEND_LIBOBS}
	lua? (
		>=dev-lang/luajit-2.1.0:2
	)
	python? (
		${PYTHON_DEPS}
	)
"

# See deps/media-playback/CMakeLists.txt
DEPEND_DEPS_MEDIA_PLAYBACK="
	${DEPEND_FFMPEG}
"

# See deps/file-updater/CMakeLists.txt
DEPEND_DEPS_FILE_UPDATER="
	${DEPEND_CURL}
"

# See deps/CMakeLists.txt
DEPEND_DEPS="
	${DEPEND_DEPS_FILE_UPDATER}
	${DEPEND_DEPS_LIBFF}
	${DEPEND_DEPS_MEDIA_PLAYBACK}
	${DEPEND_DEPS_OBS_SCRIPTING}
	${DEPEND_JANSSON}
"

# See CMakeLists.txt
#	${DEPEND_UNSOURCED} # testing as disabled
RDEPEND+="
	${DEPEND_DEPS}
	${DEPEND_PLUGINS}
	${DEPEND_UI}
	test? (
		${DEPEND_LIBOBS}
	)
"

DEPEND+="
	${RDEPEND}
"

# The obs-amd-encoder submodule currently doesn't support Linux
# https://github.com/obsproject/obs-amd-encoder/archive/${OBS_AMD_ENCODER_COMMIT}.tar.gz \
#	-> obs-amd-encoder-${OBS_AMD_ENCODER_COMMIT}.tar.gz

RESTRICT="mirror" # Speed up download of the latest release.
PATCHES=(
	# https://github.com/obsproject/obs-studio/pull/3335
	"${FILESDIR}/${PN}-26.1.2-python-3.8.patch"
	"${FILESDIR}/${PN}-30.2.3-hevc-preprocessor-cond.patch"
	"${FILESDIR}/${PN}-31.0.0-browser-checks.patch"
	"${FILESDIR}/${PN}-31.0.0-optionalize-plugins.patch"
	"${FILESDIR}/${PN}-31.0.0-symbolize-default-codecs.patch"
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
eerror
eerror "There is no CEF for this platform.  Disable the browser USE flag."
eerror
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
	sleep 10

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
ewarn "SECURITY:  When building with streaming services integration, please"
ewarn "read the metadata.xml or do"
ewarn
ewarn "  \`epkginfo -x obs-studio::oiledmachine-overlay\`"
ewarn
ewarn "for information of securely wiping with the shred command or minimizing"
ewarn "recovery of possibly sensitive data."
ewarn

einfo
einfo "All services are unlisted by default in this ebuild."
einfo
einfo "See"
einfo
einfo "  metadata.xml"
einfo
einfo "or"
einfo
einfo "  \`epkginfo -x ${CATEGORY}/${PN}::oiledmachine-overlay\`"
einfo
einfo "to setup streaming service whitelists."
einfo
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/libdshowcapture-${LIBDSHOWCAPTURE_COMMIT}" "${S}/deps/libdshowcapture/src"
		dep_prepare_mv "${WORKDIR}/capture-device-support-${CAPTURE_DEVICE_SUPPORT_COMMIT}" "${S}/deps/libdshowcapture/src/external/capture-device-support"
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

	if use browser ; then
		sed -i -e "s|libcef_dll_wrapper.a|libcef_dll_wrapper.so|g" \
			"${S}/cmake/finders/FindCEF.cmake" \
			|| die
	fi

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
			"UI/window-basic-main.cpp" \
			"UI/window-basic-auto-config.hpp" \
			"UI/window-basic-auto-config-test.cpp" \
			"UI/window-basic-settings-stream.cpp" \
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
			"UI/window-basic-main.cpp" \
			"UI/window-basic-auto-config.hpp" \
			"UI/window-basic-auto-config-test.cpp" \
			"UI/window-basic-settings-stream.cpp" \
			|| die
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
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo

	# For obs-browser
	# obs-browser-source.cpp:25:10: fatal error: QApplication: No such file or directory
	# browser-client.cpp:27:10: fatal error: QThread: No such file or directory
	if use qt6 ; then
		append-cppflags -I"${ESYSROOT}/usr/include/qt6"
		append-cppflags -I"${ESYSROOT}/usr/include/qt6/QtWidgets"
		append-cppflags -I"${ESYSROOT}/usr/include/qt6/QtCore"
	fi

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
	insinto /usr/include/obs/UI/obs-frontend-api
	doins UI/obs-frontend-api/obs-frontend-api.h

	if use browser ; then
		exeinto "/usr/lib64/obs-plugins"
		local cef_suffix=""
		has_version 'net-libs/cef-bin' && cef_suffix="-bin"
		doexe "${EROOT}/opt/cef${cef_suffix}/libcef_dll_wrapper/libcef_dll_wrapper.so"
	fi

	docinto licenses
	dodoc COMMITMENT

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
ewarn "you need to update obs-studio the same time Chromium updates"
ewarn "to avoid critical vulerabilities."
ewarn
ewarn "Currently the net-libs/cef-bin is not CFI protected."
ewarn "Consider using a CFI protected -bin browser package instead for full"
ewarn "protection using Window Capture as a source."
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
ewarn "When building with streaming services integration, please"
ewarn "read the metadata.xml or do"
ewarn
ewarn "  \`epkginfo -x obs-studio::oiledmachine-overlay\`"
ewarn
ewarn "for information of securely wiping with the shred command or minimizing"
ewarn "recovery of possibly sensitive data."
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
