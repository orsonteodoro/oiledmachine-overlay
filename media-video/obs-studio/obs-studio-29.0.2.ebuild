# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="${PV}"
EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
EGIT_SUBMODULES=(
	'*'
	'-plugins/win-dshow'
	'-plugins/mac-syphon'
	'-plugins/enc-amf'
)

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{8..10} ) # 18.04 is only 3.6
inherit cmake flag-o-matic git-r3 lcnr lua-single python-single-r1 xdg-utils

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"
LICENSE="
	GPL-CC-1.0
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
	ftl? (
		curl
		MIT
	)
	mac-syphon? (
		BSD
		BSD-2
	)
	qsv11? (
		GPL-2
		BSD
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
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0"
# aja is enabled by default upstream
# amf is enabled by default upstream
# coreaudio-encoder is enabled by default upstream
# nvafx is enabled by default upstream
# nvvfx is enabled by default upstream
# oss is enabled by default upstream
# qsv11 is enabled by default upstream
# vlc is enabled by default upstream
IUSE+="
+alsa aja amf +browser +browser-panels browser-qt-loop coreaudio-encoder
-decklink -fdk +freetype ftl +ipv6 jack libaom +lua +new-mpegts-output nvafx
nvenc nvvfx oss +pipewire +pulseaudio +python +rtmps +speexdsp -test +hevc
mac-syphon qsv11 +rnnoise -service-updates -sndio +speexdsp svt-av1 +v4l2 vaapi
vlc +virtualcam +vst +wayland win-dshow +websocket -win-mf +whatsnew x264

kernel_FreeBSD
kernel_OpenBSD

r1
"
REQUIRED_USE+="
	ftl? (
		|| ( amf nvenc vaapi win-mf x264 )
	)
	kernel_Winnt? (
		kernel_Darwin? (
			!virtualcam
		)
	)
	lua? ( ${LUA_REQUIRED_USE} )
	hevc? (
		|| (
			amf
			nvenc
		)
	)
	python? ( ${PYTHON_REQUIRED_USE} )
	!kernel_Darwin? (
		!mac-syphon
		!kernel_linux? (
			!kernel_FreeBSD? (
				!jack
			)
		)
		!kernel_Winnt? (
			!coreaudio-encoder
		)
	)
	!kernel_linux? (
		!kernel_FreeBSD? (
			!kernel_OpenBSD? (
				!sndio
				!wayland
			)
			!alsa
			!pulseaudio
			!v4l2
			!vaapi
		)
	)
	!kernel_FreeBSD? (
		!oss
	)
	kernel_FreeBSD? (
		!vst
	)
	kernel_OpenBSD? (
		!vst
	)
	!kernel_Winnt? (
		!nvafx
		!nvvfx
		!qsv11
		!win-dshow
		!win-mf
		!kernel_Darwin? (
			!kernel_linux? (
				!decklink
				!kernel_FreeBSD? (
					!vlc
				)
			)
		)
	)
"

# Based on 18.04 See
# azure-pipelines.yml
# .github/workflows/main.yml
# deps/obs-scripting/obslua/CMakeLists.txt
# deps/obs-scripting/obspython/CMakeLists.txt
BDEPEND+="
	app-misc/jq
	>=dev-util/cmake-3.10.2
	>=dev-util/pkgconf-1.3.7[pkg-config(+)]
	lua? (
		kernel_Darwin? (
			>=dev-lang/swig-4
		)
		!kernel_Darwin? (
			>=dev-lang/swig-3.0.12
		)
	)
	python? (
		${PYTHON_DEPS}
		kernel_Darwin? (
			>=dev-lang/swig-4
		)
		!kernel_Darwin? (
			>=dev-lang/swig-3.0.12
		)
	)
	test? (
		>=dev-util/cmocka-1.1.1
		websocket? (
			>=dev-libs/boost-1.39
		)
	)
"

# CI uses U 18.04

# 103 is EOL.  The current Cr version is 109.
CEF_PV="103"
# See also
# https://github.com/obsproject/obs-studio/blob/29.0.0/.github/workflows/main.yml#L20
# https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding
# https://bitbucket.org/chromiumembedded/cef/src/5060/CHROMIUM_BUILD_COMPATIBILITY.txt?at=5060

#
# To find differences between release use:
#
# S1="/var/tmp/portage/media-video/obs-studio-28.1.2/work/obs-studio-28.1.2" \
# S2="/var/tmp/portage/media-video/obs-studio-29.0.0/work/obs-studio-29.0.0" ; \
# for x in $(find ${S2} -name "CMakeLists.txt" -o -name "*.cmake" | cut -f 9- -d "/" | sort) ; do \
#   diff -urp "${S1}/${x}" "${S2}/${x}" ; \
# done
#

FFMPEG_PV="3.4.2"
LIBVA_PV="2.1.0"
LIBX11_PV="1.6.4"
MESA_PV="18"
QT_PV="5.15.2"

DEPEND_FFMPEG="
	>=media-video/ffmpeg-${FFMPEG_PV}:=[libaom?,opus,svt-av1?]
"

DEPEND_LIBX11="
	kernel_FreeBSD? (
	        >=x11-libs/libX11-${LIBX11_PV}
	)
	kernel_linux? (
	        >=x11-libs/libX11-${LIBX11_PV}
	)
	kernel_OpenBSD? (
	        >=x11-libs/libX11-${LIBX11_PV}
	)
"

DEPEND_LIBX264="
	>=media-libs/x264-0.0.20171224
"

DEPEND_LIBXCB="
        >=x11-libs/libxcb-1.13
"

# >=dev-libs/jansson-2.5 # in cmake
DEPEND_JANSSON="
	>=dev-libs/jansson-2.11
"

DEPEND_WAYLAND="
	wayland? (
		>=dev-libs/wayland-1.14.0
		>=x11-libs/libxkbcommon-0.8.0
	)
"

DEPEND_ZLIB="
	>=sys-libs/zlib-1.2.11
"

DEPEND_PLUGINS_AJA="
	aja? (
		${DEPEND_LIBX11}
		media-libs/ntv2
		>=dev-qt/qtwidgets-${QT_PV}:5=
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
		media-sound/sndio
	)
"

# See UI/frontend-plugins/decklink-captions/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_CAPTIONS="
	decklink? (
		${DEPEND_LIBX11}
		>=dev-qt/qtwidgets-${QT_PV}:5=
	)
"

# See UI/frontend-plugins/decklink-output-ui/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_OUTPUT_UI="
	decklink? (
		${DEPEND_LIBX11}
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
"

# See plugins/linux-capture/CMakeLists.txt
DEPEND_PLUGINS_LINUX_CAPTURE="
	${DEPEND_GLAD}
	${DEPEND_LIBOBS}
	${DEPEND_LIBX11}
	${DEPEND_LIBXCB}
        >=x11-libs/libXcomposite-0.4.4
        >=x11-libs/libXfixes-5.0.3
        >=x11-libs/libXinerama-1.1.3
        >=x11-libs/libXrandr-1.5.1
	pipewire? (
		dev-libs/glib:2
		>=media-video/pipewire-0.3.33
		x11-libs/libdrm
	)
"

# For vaapi support, see source code at
# https://github.com/obsproject/obs-studio/pull/1482/commits/2dc67f140d8156d9000db57786e53a4c1597c097
# From inspection, the video_cards_nouveau supports h264 decode but not h264
# encode.  This is why it is omitted below in the vaapi driver section.
DEPEND_PLUGINS_OBS_FFMPEG="
	>=sys-apps/pciutils-3.5.2
	new-mpegts-output? (
		net-libs/rist
		net-libs/srt
	)
	nvenc? (
		|| (
			>=media-video/ffmpeg-4[nvenc]
			>=media-video/ffmpeg-4[video_cards_nvidia]
		)
	)
	vaapi? (
		media-libs/vaapi-drivers
		>=media-libs/libva-${LIBVA_PV}
		>=media-video/ffmpeg-${FFMPEG_PV}[vaapi]
	)
"

DEPEND_CURL="
	>=net-misc/curl-7.58
"

DEPEND_PLUGINS_OBS_OUTPUTS="
	${DEPEND_JANSSON}
	${DEPEND_LIBOBS}
	ftl? (
		${DEPEND_CURL}
		>=dev-libs/jansson-2.8
	)
	rtmps? (
		${DEPEND_ZLIB}
		>=net-libs/mbedtls-2.8:=
	)
"

DEPEND_PLUGINS_OBS_BROWSER="
	browser? (
		|| (
			>=net-libs/cef-bin-${CEF_PV}:=
			>=net-libs/cef-${CEF_PV}:=
		)
		>=dev-qt/qtwidgets-${QT_PV}:5=
	)
"

DEPEND_PLUGINS_QSV11="
	qsv11? (
		>=media-libs/intel-mediasdk-21.1
		elibc_mingw? ( dev-util/mingw64-runtime )
	)
"

DEPEND_PLUGINS_VST="
	vst? (
		${DEPEND_LIBOBS}
		>=dev-qt/qtwidgets-${QT_PV}:5=
	)
"

DEPEND_PLUGINS_WEBSOCKET="
	websocket? (
		>=dev-qt/qtcore-5.9.5:5=
		>=dev-qt/qtwidgets-${QT_PV}:5=
		>=dev-qt/qtnetwork-${QT_PV}:5=
		>=dev-qt/qtsvg-${QT_PV}:5=
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
DEPEND_PLUGINS="
	${DEPEND_DEPS_FILE_UPDATER}
	${DEPEND_DEPS_MEDIA_PLAYBACK}
	${DEPEND_PLUGINS_AJA}
	${DEPEND_PLUGINS_DECKLINK}
	${DEPEND_PLUGINS_DECKLINK_OUTPUT_UI}
	${DEPEND_PLUGINS_FRONTEND_TOOLS}
	${DEPEND_PLUGINS_LINUX_CAPTURE}
	${DEPEND_PLUGINS_OBS_BROWSER}
	${DEPEND_PLUGINS_OBS_FFMPEG}
	${DEPEND_PLUGINS_OBS_OUTPUTS}
	${DEPEND_PLUGINS_SNDIO}
	${DEPEND_PLUGINS_QSV11}
	${DEPEND_PLUGINS_RNNOISE}
	${DEPEND_PLUGINS_VST}
	${DEPEND_CURL}
	${DEPEND_LIBOBS}
	${DEPEND_LIBX264}
	>=media-video/ffmpeg-${FFMPEG_PV}:=[x264]
	alsa? ( >=media-libs/alsa-lib-1.1.3 )
	fdk? ( >=media-libs/fdk-aac-1.5:= )
	jack? ( virtual/jack )
	speexdsp? ( >=media-libs/speexdsp-1.2 )
	freetype? (
		>=media-libs/fontconfig-2.12.6
		>=media-libs/freetype-2.8.1
	)
	v4l2? (
		${DEPEND_FFMPEG}
		>=media-libs/libv4l-1.14.2
		media-tv/v4l-utils
		virtual/udev
	)
	vlc? ( >=media-video/vlc-3.0.1:= )
"

# These are not mentioned in .github/workflows/main.yml
# but could not find headers in obs source for these packages.
# They were mentioned in the original ebuild.
DEPEND_UNSOURCED="
	>=dev-qt/qtdeclarative-${QT_PV}:5=
	>=dev-qt/qtmultimedia-${QT_PV}:5=
	>=dev-qt/qtquickcontrols-${QT_PV}:5=
	>=dev-qt/qtsql-${QT_PV}:5=
"

# See libobs/CMakeLists.txt
DEPEND_LIBOBS="
	${DEPEND_FFMPEG}
	${DEPEND_JANSSON}
	${DEPEND_LIBX11}
	${DEPEND_LIBXCB}
	${DEPEND_ZLIB}
	>=sys-apps/dbus-1.12.2
	pulseaudio? ( >=media-sound/pulseaudio-11.1 )
"

# See UI/CMakeLists.txt
# qtcore, qtgui is in UI folder but not in *.cmake or CMakeLists.txt
DEPEND_UI="
	${DEPEND_CURL}
	${DEPEND_FFMPEG}
	${DEPEND_LIBOBS}
	>=dev-qt/qtcore-5.9.5:5=
	>=dev-qt/qtnetwork-${QT_PV}:5=
	>=dev-qt/qtsvg-${QT_PV}:5=
	>=dev-qt/qtgui-${QT_PV}:5=[wayland?]
	>=dev-qt/qtwidgets-${QT_PV}:5=
	>=dev-qt/qtxml-${QT_PV}:5=
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
	media-libs/libglvnd
	>=media-libs/mesa-${MESA_PV}[egl(+)]
	${DEPEND_MESA}
	${DEPEND_LIBX11}
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
	lua? ( >=dev-lang/luajit-2.1:2 )
	python? ( ${PYTHON_DEPS} )
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
	>=dev-qt/qtwidgets-${QT_PV}:5=
	test? ( ${DEPEND_LIBOBS} )
"

DEPEND+=" ${RDEPEND}"

# The obs-amd-encoder submodule currently doesn't support Linux
# https://github.com/obsproject/obs-amd-encoder/archive/${OBS_AMD_ENCODER_COMMIT}.tar.gz \
#	-> obs-amd-encoder-${OBS_AMD_ENCODER_COMMIT}.tar.gz
# For some details on FTL support and possible deprecation see:
#  https://github.com/obsproject/obs-studio/discussions/4021
#  The module is licensed as MIT.


SRC_URI=""

RESTRICT="mirror" # Speed up download of the latest release.
MAKEOPTS="-j1"
PATCHES=(
	# https://github.com/obsproject/obs-studio/pull/3335
	"${FILESDIR}/${PN}-26.1.2-python-3.8.patch"
)

qt_check() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
#	QTMULTIMEDIA_PV=$(pkg-config --modversion Qt5Multimedia)
	QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
#	QTSQL_PV=$(pkg-config --modversion Qt5Sql)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
#	QTQML_PV=$(pkg-config --modversion Qt5Qml)
#	QTQUICKCONTROLS_PV=$(pkg-config --modversion Qt5QuickControls)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTMULTIMEDIA_PV} ; then
#		die "Qt5Core is not the same version as Qt5Multimedia"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTNETWORK_PV} ; then
		die "Qt5Core is not the same version as Qt5Network"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTSQL_PV} ; then
#		die "Qt5Core is not the same version as Qt5Sql"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt5Core is not the same version as Qt5Svg"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
#		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
#	fi
#	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS_PV} ; then
#		die "Qt5Core is not the same version as Qt5QuickControls"
#	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
	fi
}

#
# Should be preformed when the die hook is called also, but
# the ebuild system doesn't support this!
#
# Before compile finishes (or specifically before sanitize_login_tokens gets
# called), these info will be in plaintext or *unsanitized* because the die hook
# cannot be called.
#
# So the package manager is flawed and needs a special API or hooks to clean.
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
	qt_check
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup

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
	sleep 30

	if ! use browser || [[ -z "${RESTREAM_CLIENTID}" \
		|| -z "${RESTREAM_HASH}" ]] ; then
ewarn
ewarn "Restream integration is disabled.  For details on how to enable it, see"
ewarn "the metadata.xml or \`epkginfo -x obs-studio::oiledmachine-overlay\`."
ewarn "The browser USE flag must be enabled."
ewarn
	fi

	if ! use browser || [[ -z "${TWITCH_CLIENTID}" \
		|| -z "${TWITCH_HASH}" ]] ; then
ewarn
ewarn "Twitch integration is disabled.  For details on how to enable it, see"
ewarn "the metadata.xml or \`epkginfo -x obs-studio::oiledmachine-overlay\`."
ewarn "The browser USE flag must be enabled."
ewarn
	fi

	if [[ -z "${YOUTUBE_CLIENTID}" \
		|| -z "${YOUTUBE_CLIENTID_HASH}" \
		|| -z "${YOUTUBE_SECRET}" \
		|| -z "${YOUTUBE_SECRET_HASH}" ]] ; then
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
	git-r3_fetch
	git-r3_checkout
	if use kernel_Winnt ; then
		if use amf ; then
			EGIT_SUBMODULES=( '*' )
			EGIT_CHECKOUT_DIR="${S}/plugins/enc-amf"
			EGIT_COMMIT="5a1dafeddb4b37ca2ba2415cf88b40bff8aee428"
			git-r3_fetch
			git-r3_checkout
		fi

		if use win-dshow ; then
			EGIT_SUBMODULES=( '*' )
			EGIT_CHECKOUT_DIR="${S}/plugins/win-dshow/libdshowcapture"
			EGIT_COMMIT="a93f1a34c14e91b5c540f264fb965f32caf77336"
			git-r3_fetch
			git-r3_checkout
		fi
	fi

	if use kernel_Darwin ; then
		if use mac-syphon ; then
			EGIT_SUBMODULES=( '*' )
			EGIT_CHECKOUT_DIR="${S}/plugins/mac-syphon/syphon-framework"
			EGIT_COMMIT="01b144811f6f7080b70b2d7cc729da071f86f9d7"
			git-r3_fetch
			git-r3_checkout
		fi
	fi
}

src_prepare() {
	cmake_src_prepare
	if use ftl ; then
		pushd "${S}/plugins/obs-outputs/ftl-sdk" || die
			eapply -p1 "${FILESDIR}/obs-studio-27.0.0-ftl-use-system-deps.patch"
		popd
	fi

	# typos
	sed -i -e "s|LIBVA_LBRARIES|LIBVA_LIBRARIES|g" \
		plugins/obs-ffmpeg/CMakeLists.txt || die

	sed -i -e "s|libcef_dll_wrapper.a|libcef_dll_wrapper.so|g" \
		plugins/obs-browser/FindCEF.cmake || die
	sed -i -e "s|libcef_dll_wrapper.a|libcef_dll_wrapper.so|g" \
		cmake/Modules/FindCEF.cmake || die
}

gen_rtmp_services() {
	if [[ -z "${OBS_STUDIO_STREAMING_SERVICES_WHITELIST}" ]] ; then
		einfo "Removing streaming services"
		jq '{"$schema","format_version","services": [.services[] | select(null)]}' \
			"${S}/plugins/rtmp-services/data/services.json" \
			> "${S}/plugins/rtmp-services/data/services.json.t" || die
		mv "${S}/plugins/rtmp-services/data/services.json"{.t,} || die
		return
	fi

	export IFS=";"
	local services=""
	local s
	for s in ${OBS_STUDIO_STREAMING_SERVICES_WHITELIST} ; do
		einfo "Added ${s} streaming service"
		services+=" or .name==\"${s}\""
	done
	export IFS=$' \t\n'

	jq '{"$schema","format_version","services": [.services[] | select(null '"${services}"')]}' \
		"${S}/plugins/rtmp-services/data/services.json" \
		> "${S}/plugins/rtmp-services/data/services.json.t" || die
	mv "${S}/plugins/rtmp-services/data/services.json"{.t,} || die
}

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
einfo
einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo

	# For obs-browser
	# obs-browser-source.cpp:25:10: fatal error: QApplication: No such file or directory
	# browser-client.cpp:27:10: fatal error: QThread: No such file or directory
	if use browser ; then
		append-cppflags -I"${ESYSROOT}"/usr/include/qt5
		append-cppflags -I"${ESYSROOT}"/usr/include/qt5/QtWidgets
		append-cppflags -I"${ESYSROOT}"/usr/include/qt5/QtCore
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DENABLE_AJA=$(usex aja)
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_BROWSER=$(usex browser)
		-DENABLE_BROWSER_PANELS=$(usex browser-panels)
		-DENABLE_BROWSER_QT_LOOP=$(usex browser-qt-loop)
		-DENABLE_COREAUDIO_ENCODER=$(usex coreaudio-encoder)
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FREETYPE=$(usex freetype)
		-DENABLE_HEVC=$(usex hevc)
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_NEW_MPEGTS_OUTPUT=$(usex new-mpegts-output)
		-DENABLE_OSS=$(usex oss)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PLUGINS=ON
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_RNNOISE=$(usex rnnoise)
		-DENABLE_RTMPS=$(usex rtmps)
		-DENABLE_SNDIO=$(usex sndio)
		-DENABLE_SERVICE_UPDATES=$(usex service-updates)
		-DENABLE_SPEEXDSP=$(usex speexdsp)
		-DENABLE_UPDATER=OFF
		-DENABLE_V4L2=$(usex v4l2)
		-DENABLE_VLC=$(usex vlc)
		-DENABLE_VST=$(usex vst)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_WEBSOCKET=$(usex websocket)
		-DENABLE_WINMF=$(usex win-mf)
		-DENABLE_WHATSNEW=$(usex whatsnew)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DUNIX_STRUCTURE=1
	)

	local clang_slot=$(clang-major-version)
	if tc-is-clang && has_version "=sys-devel/clang-runtime-${clang_slot}*[libcxx]" ; then
		mycmakeargs+=(
			-DUSE_LIBCXX=ON
		)
	fi

	if use kernel_Winnt || use kernel_Darwin ; then
		mycmakeargs+=(
			-DBUILD_VIRTUALCAM=$(usex virtualcam)
		)
	fi

	if use kernel_Winnt ; then
		mycmakeargs+=(
			-DBUILD_AMD_ENCODER=$(usex amf)
			-DENABLE_NVAFX=$(usex nvafx)
			-DENABLE_NVVFX=$(usex nvvfx)
			-DENABLE_QSV11=$(usex qsv11)
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
		mycmakeargs+=( -DENABLE_SCRIPTING=no )
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
	sanitize_login_tokens
}

src_install() {
	cmake_src_install
	# External plugins may need some things not installed by default,"
	# install them here
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

	if use ftl ; then
einfo
einfo "FTL is currently being planned for removal (or deprecated).  It requires"
einfo "x264 video, opus audio, and for lowest latency bframes=0."
einfo
einfo "Edit plugins/rtmp-services/data/services.json and add a per-package"
einfo "patch for adding custom FTL servers."
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
