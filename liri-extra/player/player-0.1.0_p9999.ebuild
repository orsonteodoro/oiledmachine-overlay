# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Liri Player is a cross-platform, Material Design video player"
HOMEPAGE="https://github.com/lirios/player"
LICENSE="GPL-3+ CC0-1.0"

# Live/snapshot do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
GSTREAMER_META_CODECS=(
a52
aac
dv
ffmpeg
flac
fluidsynth
jpeg
modplug
mp3
mpeg
ogg
opus
theora
vaapi
vorbis
wavpack
)
# Based on mime listed in io.liri.Player.desktop
ALL_CODECS="
${GSTREAMER_META_CODECS[@]}
aiff amr amrwb dvd musepack sbc speex
"
IUSE+="
${ALL_CODECS}
alsa http mms pulseaudio rtmp

r5
"

ACODECS=(
	a52
	aac
	aiff
	amr
	amrwb
	flac
	ffmpeg
	modplug
	mp3
	musepack
	opus
	sbc
	vorbis
	wavpack
)

AUDIO_SYSTEMS_IUSE="
	|| (
		alsa
		pulseaudio
	)
"

gen_audio_ruse() {
	for codec in ${ACODECS[@]} ; do
		echo  "
			${codec}? (
				${AUDIO_SYSTEMS_IUSE}
			)
		"
	done
}

REQUIRED_USE="
	$(gen_audio_ruse)
	|| (
		${ALL_CODECS}
	)
"

GSTREAMER_META_CODECS_DEPENDS=("${GSTREAMER_META_CODECS[@]/#/,}")
GSTREAMER_META_CODECS_DEPENDS=("${GSTREAMER_META_CODECS_DEPENDS[@]/%/?}")
GSTREAMER_META_CODECS_DEPENDS="${GSTREAMER_META_CODECS_DEPENDS}"
GSTREAMER_META_CODECS_DEPENDS="${GSTREAMER_META_CODECS_DEPENDS:1}"
GSTREAMER_META_CODECS_DEPENDS="${GSTREAMER_META_CODECS_DEPENDS// }"

QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtmultimedia-${QT_MIN_PV}:5=[alsa?,gstreamer,pulseaudio?,qml]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=[widgets]
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	media-plugins/gst-plugins-meta:1.0[${GSTREAMER_META_CODECS_DEPENDS},http?]
	aiff? (
		media-libs/gst-plugins-bad:1.0
	)
	amr? (
		media-plugins/gst-plugins-amr:1.0
	)
	amrwb? (
		media-plugins/gst-plugins-amr:1.0[amrwbdec]
	)
	fluidsynth? (
		media-plugins/gst-plugins-bad:1.0
		media-plugins/gst-plugins-fluidsynth:1.0
	)
	mms? (
		media-plugins/gst-plugins-libmms:1.0
	)
	musepack? (
		media-plugins/gst-plugins-musepack:1.0
	)
	rtmp? (
		media-plugins/gst-plugins-rtmp:1.0
	)
	sbc? (
		media-plugins/gst-plugins-sbc:1.0
	)
	speex? (
		media-plugins/gst-plugins-speex:1.0
	)
	vaapi? (
		media-libs/vaapi-drivers
	)
	~liri-base/fluid-1.2.0_p9999
"
# Extra codec coverage for gst-plugins-good:
#   video/3gp
# Extra codec coverage for gst-plugins-av:
#   audio/x-ape
#   audio/x-shorten
#   audio/x-tta
#   video/x-nsv
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	virtual/pkgconfig
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTMULTIMEDIA_PV=$(pkg-config --modversion Qt5Multimedia)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTMULTIMEDIA_PV} ; then
		die "Qt5Core is not the same version as Qt5Multimedia"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
