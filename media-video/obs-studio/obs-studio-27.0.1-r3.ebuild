# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{8..10} ) # 18.04 is only 3.6
inherit cmake flag-o-matic lua-single python-single-r1 xdg-utils

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"
LICENSE="GPL-2
	 browser? ( BSD )"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0"
IUSE+=" +alsa +browser -decklink fdk ftl imagemagick jack +lua nvenc oss
+pipewire pulseaudio +python +speexdsp +ssl -test freetype sndio v4l2 vaapi
video_cards_amdgpu video_cards_amdgpu-pro video_cards_amdgpu-pro-lts
video_cards_intel video_cards_iris video_cards_i965 video_cards_r600
video_cards_radeonsi vlc +vst +wayland"
REQUIRED_USE+="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	video_cards_amdgpu? (
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_amdgpu-pro? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_amdgpu-pro-lts? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_r600? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_radeonsi
	)
	video_cards_radeonsi? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_r600
	)
"
# Based on 18.04 See
# azure-pipelines.yml
# .github/workflows/main.yml
# deps/obs-scripting/obslua/CMakeLists.txt
# deps/obs-scripting/obspython/CMakeLists.txt
BDEPEND+="
	>=dev-util/cmake-3.10.2
	>=dev-util/pkgconfig-0.29.1
	lua? ( >=dev-lang/swig-3.0.12 )
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-3.0.12
	)
	test? ( >=dev-util/cmocka-1.1.1 )
"

CEF_V="87" # See https://github.com/obsproject/obs-studio/blob/27.0.0/.github/workflows/main.yml#L20
FFMPEG_V="3.4.2"
LIBVA_V="2.1.0"
LIBX11_V="1.6.4"
MESA_V="18"
QT_V="5.15.2"

#OBS_AMD_ENCODER_COMMIT="9ceb1254c379bce6124912671afee67c9a07d1a4"
OBS_BROWSER_COMMIT="f1a61c5a2579e5673765c31a47c2053d4b502d4b"
OBS_VST_COMMIT="aaa7b7fa32c40b37f59e7d3d194672115451f198"
OBS_FTL_SDK_COMMIT="d0c8469f66806b5ea738d607f7d2b000af8b1129"

DEPEND_FFMPEG="
	>=media-video/ffmpeg-${FFMPEG_V}:=
"

DEPEND_QT11EXTRAS="
	>=dev-qt/qtx11extras-${QT_V}:5=
"

DEPEND_LIBX11="
        >=x11-libs/libX11-${LIBX11_V}
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
	dev-libs/wayland
"

DEPEND_ZLIB="
	>=sys-libs/zlib-1.2.11
"

# See plugins/sndio/CMakeLists.txt
DEPEND_PLUGINS_SNDIO="
	${DEPEND_LIBOBS}
	media-sound/sndio
"

# See UI/frontend-plugins/decklink-captions/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_CAPTIONS="
	${DEPEND_LIBX11}
	>=dev-qt/qtwidgets-${QT_V}:5=
"

# See UI/frontend-plugins/decklink-output-ui/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK_OUTPUT_UI="
	${DEPEND_LIBX11}
"

# See plugins/decklink/linux/CMakeLists.txt
DEPEND_PLUGINS_DECKLINK="
	${DEPEND_LIBOBS}
	${DEPEND_PLUGINS_DECKLINK_CAPTIONS}
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
		>=media-video/pipewire-0.3
	)
"

# For vaapi support, see source code at
# https://github.com/obsproject/obs-studio/pull/1482/commits/2dc67f140d8156d9000db57786e53a4c1597c097
# No video_cards_nouveau x264 encode from inspection of the Mesa driver, but for decode yes.
DEPEND_PLUGINS_OBS_FFMPEG="
	nvenc? (
		|| (
			<media-video/ffmpeg-4[nvenc]
			>=media-video/ffmpeg-4[video_cards_nvidia]
		)
	)
	vaapi? (
		|| (
			video_cards_amdgpu? (
				>=media-libs/mesa-${MESA_V}[gallium,vaapi,video_cards_radeonsi]
			)
			video_cards_amdgpu-pro? (
				x11-drivers/amdgpu-pro[open-stack,vaapi]
			)
			video_cards_amdgpu-pro-lts? (
				x11-drivers/amdgpu-pro-lts[open-stack,vaapi]
			)
			video_cards_i965? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver
					x11-drivers/xf86-video-intel
				)
			)
			video_cards_intel? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver
					x11-drivers/xf86-video-intel
				)
			)
			video_cards_iris? (
				x11-libs/libva-intel-media-driver
			)
			video_cards_r600? (
				>=media-libs/mesa-${MESA_V}[gallium,vaapi,video_cards_r600]
			)
			video_cards_radeonsi? (
				>=media-libs/mesa-${MESA_V}[gallium,vaapi,video_cards_radeonsi]
			)
		)
		>=x11-libs/libva-${LIBVA_V}
		>=media-video/ffmpeg-${FFMPEG_V}[vaapi]
	)"

DEPEND_CURL="
	>=net-misc/curl-7.58
"

DEPEND_PLUGINS_OBS_OUTPUTS="
	${DEPEND_CURL}
	${DEPEND_JANSSON}
	${DEPEND_LIBOBS}
	${DEPEND_ZLIB}
	ftl? (
		>=dev-libs/jansson-2.8
		>=net-misc/curl-7.52.1
		media-video/ffmpeg[opus]
		!vaapi? ( ${DEPEND_LIBX264} )
		 vaapi? ( media-video/ffmpeg[x264] )
	)
	ssl? (
		>=net-libs/mbedtls-2.8:=
	)
"

DEPEND_PLUGINS_OBS_VST="
	${DEPEND_LIBOBS}
	>=dev-qt/qtwidgets-${QT_V}:5=
"

DEPEND_PLUGINS_OBS_BROWSER="
	browser? (
		|| (
			>=net-libs/cef-bin-${CEF_V}:=
			>=net-libs/cef-${CEF_V}:=
		)
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
	${DEPEND_PLUGINS_DECKLINK}
	${DEPEND_PLUGINS_DECKLINK_OUTPUT_UI}
	${DEPEND_PLUGINS_FRONTEND_TOOLS}
	${DEPEND_PLUGINS_LINUX_CAPTURE}
	${DEPEND_PLUGINS_OBS_BROWSER}
	${DEPEND_PLUGINS_OBS_FFMPEG}
	${DEPEND_PLUGINS_OBS_OUTPUTS}
	${DEPEND_PLUGINS_SNDIO}
	${DEPEND_CURL}
	${DEPEND_LIBOBS}
	${DEPEND_LIBX264}
	>=media-video/ffmpeg-${FFMPEG_V}:=[x264]
	alsa? ( >=media-libs/alsa-lib-1.1.3 )
	fdk? ( >=media-libs/fdk-aac-1.5:= )
	jack? ( virtual/jack )
	speexdsp? ( >=media-libs/speexdsp-1.2 )
	freetype? (
		>=media-libs/fontconfig-2.12.6
		>=media-libs/freetype-2.8.1
	)
	v4l2? (
		>=media-libs/libv4l-1.14.2
		virtual/udev
	)
	vlc? ( >=media-video/vlc-3.0.1:= )
"

# These are not mentioned in .github/workflows/main.yml
# but could not find headers in obs source for these packages.
# They were mentioned in the original ebuild.
DEPEND_UNSOURCED="
	>=dev-qt/qtdeclarative-${QT_V}:5=
	>=dev-qt/qtmultimedia-${QT_V}:5=
	>=dev-qt/qtnetwork-${QT_V}:5=
	>=dev-qt/qtquickcontrols-${QT_V}:5=
	>=dev-qt/qtsql-${QT_V}:5=
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
	imagemagick? ( >=media-gfx/imagemagick-6.9.7.4:= )
"

# See UI/CMakeLists.txt
# qtcore, qtgui is in UI folder but not in *.cmake or CMakeLists.txt
DEPEND_UI="
	${DEPEND_CURL}
	${DEPEND_FFMPEG}
	${DEPEND_LIBOBS}
	>=dev-qt/qtcore-5.9.5:5=
	>=dev-qt/qtsvg-${QT_V}:5=
	>=dev-qt/qtgui-${QT_V}:5=
	>=dev-qt/qtwidgets-${QT_V}:5=
	>=dev-qt/qtxml-${QT_V}:5=
"

# See deps/libff/CMakeLists.txt
DEPEND_DEPS_LIBFF="
	${DEPEND_FFMPEG}
"

# Found in multiple CMakeLists.txt
DEPEND_MESA="
	>=media-libs/mesa-${MESA_V}
"

# See deps/glad/CMakeLists.txt
DEPEND_GLAD="
	>=media-libs/mesa-${MESA_V}[egl]
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
DEPEND+="
	${DEPEND_DEPS}
	${DEPEND_PLUGINS}
	${DEPEND_UI}
	>=dev-qt/qtwidgets-${QT_V}:5=
	test? ( ${DEPEND_LIBOBS} )
"
RDEPEND+=" ${DEPEND}"

# The obs-amd-encoder submodule currently doesn't support Linux
#https://github.com/obsproject/obs-amd-encoder/archive/${OBS_AMD_ENCODER_COMMIT}.tar.gz \
#	-> obs-amd-encoder-${OBS_AMD_ENCODER_COMMIT}.tar.gz
# For some details on FTL support and possible deprecation see:
#  https://github.com/obsproject/obs-studio/discussions/4021
#  The module is licensed as MIT.

SRC_URI="
https://github.com/obsproject/${PN}/archive/${PV}.tar.gz \
	-> ${P}.tar.gz
https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz \
	-> obs-browser-${OBS_BROWSER_COMMIT}.tar.gz
https://github.com/obsproject/obs-vst/archive/${OBS_VST_COMMIT}.tar.gz \
	-> obs-vst-${OBS_VST_COMMIT}.tar.gz
ftl? (
https://github.com/mixer/ftl-sdk/archive/${OBS_FTL_SDK_COMMIT}.tar.gz \
	-> ftl-sdk-${OBS_FTL_SDK_COMMIT}.tar.gz
)
"

MAKEOPTS="-j1"
PATCHES=(
	"${FILESDIR}/${PN}-26.1.2-python-3.8.patch" # https://github.com/obsproject/obs-studio/pull/3335
)

qt_check() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
#	QTMULTIMEDIA_PV=$(pkg-config --modversion Qt5Multimedia)
#	QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
#	QTSQL_PV=$(pkg-config --modversion Qt5Sql)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
#	QTQML_PV=$(pkg-config --modversion Qt5Qml)
#	QTQUICKCONTROLS_PV=$(pkg-config --modversion Qt5QuickControls)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	QTX11EXTRAS_PV=$(pkg-config --modversion Qt5X11Extras)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
#	if ver_test ${QTCORE_PV} -ne ${QTMULTIMEDIA_PV} ; then
#		die "Qt5Core is not the same version as Qt5Multimedia"
#	fi
#	if ver_test ${QTCORE_PV} -ne ${QTNETWORK_PV} ; then
#		die "Qt5Core is not the same version as Qt5Network"
#	fi
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
	if ver_test ${QTCORE_PV} -ne ${QTX11EXTRAS_PV} ; then
		die "Qt5Core is not the same version as Qt5X11Extras"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
	fi
}

pkg_setup() {
	qt_check
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup

	if use browser ; then
		if [[ "${ABI}" =~ "ppc" ]] ; then
			if ! has_version "net-libs/cef" ; then
				die \
"There is no (Chromium Embedded Framework) for this platform.  Disable the \
browser USE flag."
			fi
		fi
	fi

	if ! use v4l2 ; then
		ewarn "WebCam capture is possibly disabled.  Enable with the v4l2 USE flag."
	fi

	if has_version "x11-libs/libva-intel-driver" ; then
ewarn
ewarn "x11-libs/libva-intel-driver is the older vaapi driver but intended for"
ewarn "select hardware.  See also x11-libs/libva-intel-media-driver package"
ewarn "to access more vaapi accelerated encoders if driver support overlaps."
ewarn
	fi
}

src_unpack() {
	unpack ${A}
	rm -rf \
		"${S}/plugins/enc-amf" \
		"${S}/plugins/obs-browser" \
		"${S}/plugins/obs-outputs/ftl-sdk" \
		"${S}/plugins/obs-vst"
#	ln -s "${WORKDIR}/obs-amd-encoder-${OBS_AMD_ENCODER_COMMIT}" \
#		"${S}/plugins/enc-amf" || die
	ln -s "${WORKDIR}/obs-browser-${OBS_BROWSER_COMMIT}" \
		"${S}/plugins/obs-browser" || die
	if use ftl ; then
		ln -s "${WORKDIR}/ftl-sdk-${OBS_FTL_SDK_COMMIT}" \
			"${S}/plugins/obs-outputs/ftl-sdk" || die
	fi
	ln -s "${WORKDIR}/obs-vst-${OBS_VST_COMMIT}" \
		"${S}/plugins/obs-vst" || die
}

src_prepare() {
	cmake_src_prepare
	pushd "${WORKDIR}/obs-browser-${OBS_BROWSER_COMMIT}" || die
		eapply -p1 "${FILESDIR}/obs-studio-25.0.8-install-libcef_dll_wrapper.patch"
		eapply -p1 "${FILESDIR}/obs-studio-27.0.0-obs-browser-web-security-limit-to-le-4389.patch"
		eapply -p1 "${FILESDIR}/obs-studio-27.0.0-product_version-ge-4430.patch"
	popd
	if use ftl ; then
	pushd "${WORKDIR}/ftl-sdk-${OBS_FTL_SDK_COMMIT}" || die
		eapply -p1 "${FILESDIR}/obs-studio-27.0.0-ftl-use-system-deps.patch"
	popd
	fi
	# typos
	sed -i -e "s|LIBVA_LBRARIES|LIBVA_LIBRARIES|g" \
		plugins/obs-ffmpeg/CMakeLists.txt || die
	sed -i -e "s|libcef_dll_wrapper.a|libcef_dll_wrapper.so|g" \
		plugins/obs-browser/FindCEF.cmake || die
}

src_configure() {
	if use browser ; then
		strip-flags
		filter-flags -march=* -O*
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DBUILD_BROWSER=$(usex browser)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_VIRTUALCAM=OFF
		-DBUILD_VST=$(usex vst)
		-DDISABLE_ALSA=$(usex !alsa)
		-DDISABLE_DECKLINK=$(usex !decklink)
		-DDISABLE_FREETYPE=$(usex !freetype)
		-DDISABLE_JACK=$(usex !jack)
		-DDISABLE_LIBFDK=$(usex !fdk)
		-DDISABLE_OSS=$(usex kernel_FreeBSD $(usex !oss) ON)
		-DDISABLE_PLUGINS=OFF
		-DDISABLE_PULSEAUDIO=$(usex !pulseaudio)
		-DDISABLE_SNDIO=$(usex !sndio)
		-DDISABLE_SPEEXDSP=$(usex !speexdsp)
		-DDISABLE_V4L2=$(usex !v4l2)
		-DDISABLE_VLC=$(usex !vlc)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_V4L2=$(usex v4l2)
		-DENABLE_WAYLAND=$(usex wayland)
		-DLIBOBS_PREFER_IMAGEMAGICK=$(usex imagemagick)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DUNIX_STRUCTURE=1
		-DWITH_RTMPS=$(usex ssl)
	)

	if [ "${PV}" != "9999" ]; then
		mycmakeargs+=(
			-DOBS_VERSION_OVERRIDE=${PV}
		)
	fi

	if use browser ; then
		local cef_suffix=""
		if has_version 'net-libs/cef-bin' ; then
			cef_suffix="-bin"
		fi
		mycmakeargs+=(
			-DCEF_ROOT_DIR="${EROOT}/opt/cef${cef_suffix}/${ABI}"
		)
	fi

	if use lua || use python; then
		mycmakeargs+=(
			-DDISABLE_LUA=$(usex !lua)
			-DDISABLE_PYTHON=$(usex !python)
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

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	# external plugins may need some things not installed by default, install them here
	insinto /usr/include/obs/UI/obs-frontend-api
	doins UI/obs-frontend-api/obs-frontend-api.h
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! use alsa && ! use pulseaudio; then
		elog
		elog "For the audio capture features to be available,"
		elog "either the 'alsa' or the 'pulseaudio' USE-flag needs to"
		elog "be enabled."
		elog
	fi

	if ! has_version "sys-apps/dbus"; then
		elog
		elog "The 'sys-apps/dbus' package is not installed, but"
		elog "could be used for disabling hibernating, screensaving,"
		elog "and sleeping.  Where it is not installed,"
		elog "'xdg-screensaver reset' is used instead"
		elog "(if 'x11-misc/xdg-utils' is installed)."
		elog
	fi

	if use browser ; then
		ewarn
		ewarn "Security notice:"
		ewarn "Since the browser feature uses the Chromium source code as a base,"
		ewarn "you need to update obs-studio the same time Chromium updates"
		ewarn "to avoid critical vulerabilities."
		ewarn
	fi

	if use vaapi ; then
		einfo
		einfo "VAAPI support is found at File > Settings > Output > Output Mode:"
		einfo "Advanced > Streaming > Encoder > FFMPEG VAAPI"
		if use video_cards_intel || use video_cards_i965 || use video_cards_iris \
			|| has_version "x11-drivers/xf86-video-intel" ; then
			einfo
			einfo "Intel Quick Sync Video is required for hardware accelerated H.264 VA-API"
			einfo "encode."
			einfo
			einfo "For hardware support, see the AVC row at"
			einfo "https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video#Hardware_decoding_and_encoding"
			einfo
			einfo "Driver ebuild packages for their corresponding hardware can be found at:"
			einfo
			einfo "x11-libs/libva-intel-driver:"
			einfo "https://github.com/intel/intel-vaapi-driver/blob/master/NEWS"
			einfo
			einfo "x11-libs/libva-intel-media-driver:"
			einfo "https://github.com/intel/media-driver#decodingencoding-features"
			einfo
			einfo "x11-drivers/xf86-video-intel:"
			einfo "https://www.x.org/wiki/IntelGraphicsDriver/"
			einfo
			einfo "The x11-drivers/xf86-video-intel vaapi status:"
			einfo
			ewarn "H.264 support is DONE for Gen6 but marked MOSTLY for both G4x"
			ewarn "and Gen5.  Take precautions using them."
			einfo
		fi
		if use video_cards_amdgpu || use video_cards_amdgpu-pro \
			|| use video_cards_amdgpu-pro-lts || use video_cards_r600 \
			|| use video_cards_radeonsi  ; then
			einfo
			einfo "You need VCE (Video Code Engine) or VCN (Video Core Next) for"
			einfo "hardware accelerated H.264 VA-API encode."
			einfo "For details see https://en.wikipedia.org/wiki/Video_Coding_Engine#Feature_overview"
			einfo "or https://www.x.org/wiki/RadeonFeature/"
			einfo
		fi
		if use video_cards_r600 ; then
			einfo
			einfo "ARUBA is only supported in the free r600 driver."
			einfo "For newer hardware, try a newer free driver like"
			einfo "the radeonsi driver or closed drivers."
			einfo
		fi
		einfo
		einfo "The user must be part of the video group to use VAAPI support."
		einfo
	fi

	if use ftl ; then
		einfo "FTL is currently being planned for removal (or deprecated).  It requires x264 video, opus audio, and for lowest latency bframes=0."
		einfo "Edit plugins/rtmp-services/data/services.json and add a per-package patch for adding custom FTL servers."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
