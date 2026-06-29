# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17

FALLBACK_COMMIT="8e4b867f7f4100341f0199579118bdaa5d43d9bf"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_8[@]}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-qt/qtbase-6.9999"
	"media-libs/libpulse-9999"
	"media-libs/libva-9999"
	"media-video/ffmpeg-9999"
	"media-video/ffmpeg-9999m"
	"x11-libs/libX11-9999"
)

QT6_HAS_STATIC_LIBS=1
inherit cflags-hardened chkl flag-o-matic ffmpeg libcxx-slot libstdcxx-slot secure-version qt6-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~x86"
fi

IUSE+="
	+X alsa +dbus eglfs +ffmpeg gstreamer opengl pipewire pulseaudio
	qml +v4l vaapi vulkan wayland
	ebuild_revision_1
"
REQUIRED_USE="
	|| ( ffmpeg gstreamer )
	eglfs? ( ffmpeg opengl qml )
	vaapi? ( ffmpeg opengl )
"

# dlopen/dbus: pipewire
RDEPEND="
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},concurrent,gui,network,opengl=,vulkan=,widgets]
	alsa? (
		!pulseaudio? ( >=media-libs/alsa-lib-${ALSA_LIB_PV}:= )
	)
	ffmpeg? (
		~dev-qt/qtbase-${PV}:6=[X=,concurrent,eglfs=]
		$(secure-version_gen_ffmpeg_depends '' '[vaapi?]')
		X? (
			>=x11-libs/libX11-${LIBX11_PV}:=
			>=x11-libs/libXext-${LIBXEXT_PV}:=
			>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
		)
	)
	gstreamer? (
		>=dev-libs/glib-${GLIB_PV}:=
		>=media-libs/gst-plugins-bad-${GSTREAMER_PV}:=
		>=media-libs/gst-plugins-base-${GSTREAMER_PV}:=
		>=media-libs/gstreamer-${GSTREAMER_PV}:=
		opengl? (
			~dev-qt/qtbase-${PV}:6=[X?,wayland?]
			>=media-libs/gst-plugins-base-${GSTREAMER_PV}:=[X?,egl,opengl,wayland?]
		)
	)
	opengl? ( media-libs/libglvnd:= )
	pipewire? (
		~dev-qt/qtbase-${PV}:6=[dbus?]
		>=media-video/pipewire-${PIPEWIRE_PV}:=
	)
	pulseaudio? ( >=media-libs/libpulse-${LIBPULSE_PV}:= )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		~dev-qt/qtquick3d-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	vaapi? ( >=media-libs/libva-${LIBVA_PV}:= )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto:= )
	v4l? ( sys-kernel/linux-headers:= )
	vulkan? ( dev-util/vulkan-headers:= )
"
BDEPEND="
	~dev-qt/qtshadertools-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"

CMAKE_SKIP_TESTS=(
	# unimportant and expects all backends to be available (bug #928420)
	tst_backends
	# tries to use real alsa or pulseaudio and fails in sandbox
	tst_qaudiosink
	tst_qaudiosource
	tst_qmediacapture_gstreamer
	tst_qmediacapturesession
	tst_qmediaframeinputsbackend
	tst_qmediaplayer_gstreamer
	tst_qmediaplayerbackend
	tst_qsoundeffect
	# may try to use v4l2 or hardware acceleration depending on availability
	tst_qcamerabackend #972689
	tst_qmediarecorderbackend
	tst_qscreencapture_integration
	tst_qscreencapturebackend
	tst_qvideoframebackend
	# seems flaky depending on what codecs system libraries support or not
	tst_qmediaformatbackend
	# fails with offscreen rendering
	tst_qvideoframecolormanagement
	tst_qwindowcapturebackend
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	qt6-build_src_prepare

	# test expects GStreamer to report an exact bitrate value, but
	# this varies depending on version and Qt updates it only now
	# and then (disabling permanently with a sed to avoid rebases)
	sed -e '/bool validateBitRates = GST_CHECK_VERSION/s/= .*/= false;/' \
		-i tests/auto/unit/plugins/multimedia/gstreamer/gstreamer_backend/tst_gstreamer_backend.cpp || die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	use ffmpeg && ffmpeg_src_configure
	# normally passed by the build system, but needed for 32-on-64 chroots
	use x86 && append-cppflags -DDISABLE_SIMD -DPFFFT_SIMD_DISABLE

	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		$(qt_feature ffmpeg)
		$(qt_feature gstreamer)
		$(usev gstreamer "
			$(qt_feature opengl gstreamer_gl)
			$(usev opengl "
				$(qt_feature X gstreamer_gl_x11)
				$(qt_feature wayland gstreamer_gl_wayland)
			")
		")
		$(qt_feature pipewire)
		$(usev pipewire $(qt_feature dbus pipewire_screencapture))
		$(qt_feature pulseaudio)
		$(qt_feature v4l linux_v4l)
		$(qt_feature vaapi)
	)

	# ALSA backend is experimental off-by-default and can take priority
	# causing problems (bug #935146), disable if USE=pulseaudio is set
	# (also do not want unnecessary usage of ALSA plugins -> pulse)
	if use alsa && use pulseaudio; then
		# einfo should be enough given pure-ALSA users tend to disable pulse
		einfo "Warning: USE=alsa is ignored when USE=pulseaudio is set"
		mycmakeargs+=( -DQT_FEATURE_alsa=OFF )
	else
		mycmakeargs+=( $(qt_feature alsa) )
	fi

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	if use test; then
		local delete=( # sigh
			"${D}${QT6_LIBDIR}"/cmake/Qt6Multimedia/Qt6MockMultimediaPlugin*.cmake
			"${D}${QT6_MKSPECSDIR}"/modules/qt_plugin_mockmultimediaplugin.pri
			"${D}${QT6_PLUGINDIR}"/multimedia/libmockmultimediaplugin.*
			"${D}${QT6_PLUGINDIR}"/multimedia/objects-*
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}
