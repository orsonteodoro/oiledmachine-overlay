# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

MY_PV="$(ver_cut 1-3 ${PV})"

CXX_STANDARD=17
EGIT_COMMIT="7e0e94abf6610026aebb9ddce8564c39522fac6e" # Dec 5, 2024
KDDOCWIDGETS_COMMIT="8d2d0a5764f8393cc148a2296d511276a8ffe559"
OLIVE_EDITOR_CORE_COMMIT="277792824801495e868580ca86f6e7a1b53e4779"
QT5_PV="5.6.0"
QT6_PV="6.0.0"

PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cmake dep-prepare libcxx-slot libstdcxx-slot xdg

if [[ "${PV}" == *"9999" ]]; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/olive-editor/olive.git"
	FALLBACK_COMMIT="${EGIT_COMMIT}"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/olive-editor/olive/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/olive-editor/KDDockWidgets/archive/${KDDOCWIDGETS_COMMIT}.tar.gz
	-> KDDockWidgets-${KDDOCWIDGETS_COMMIT:0:7}.tar.gz
https://github.com/olive-editor/core/archive/${OLIVE_EDITOR_CORE_COMMIT}.tar.gz
	-> olive-editor-core-${OLIVE_EDITOR_CORE_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Professional open-source non-linear video editor"
HOMEPAGE="
	https://www.olivevideoeditor.org/
	https://github.com/olive-editor/olive
"
LICENSE="GPL-3"
SLOT="0/${MY_PV}"
# For default ON status see docker/scripts/build_ffmpeg.sh
# Only expired patents or non taxed patents will be enabled default ON in this ebuild.
#
# glslang from ffmpeg, pystring from opencolorio, imath from opencolorio,
# openimageio, opentimelineio are indirect depends but added for GLIBCXX_ symbol
# consistency for linking.
#
IUSE+="
${PATENT_STATUS_IUSE[@]}
alsa doc glslang jack +jpeg2k +mp3 +opus oss +png qt5 qt6 test srt +svt-av1 +theora
+truetype +vorbis wayland +webp X +xvid x264 x265
ebuild_revision_3
"
PATENT_STATUS_REQUIRED_USE="
	patent_status_nonfree? (
		!x264
		!x265
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	^^ (
		qt5
		qt6
	)
	|| (
		mp3
		opus
		vorbis
	)
	|| (
		svt-av1
		theora
		x264
		x265
		xvid
	)
	|| (
		wayland
		X
	)
"
RESTRICT="
	!test? (
		test
	)
"
#	media-libs/olivecore
PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		|| (
			(
				>=media-video/ffmpeg-3.0.0:0[glslang=,jpeg2k?,mp3?,opus?,-patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,-x264,-x265]
				<media-video/ffmpeg-7:0
			)
			(
				>=media-video/ffmpeg-3.0.0:56.58.58[glslang=,jpeg2k?,mp3?,opus?,-patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,-x264,-x265]
				<media-video/ffmpeg-7:56.58.58
			)
			(
				>=media-video/ffmpeg-3.0.0:57.59.59[glslang=,jpeg2k?,mp3?,opus?,-patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,-x264,-x265]
				<media-video/ffmpeg-7:57.59.59
			)
			(
				>=media-video/ffmpeg-3.0.0:58.60.60[glslang=,jpeg2k?,mp3?,opus?,-patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,-x264,-x265]
				<media-video/ffmpeg-7:58.60.60
			)
		)
	)
	patent_status_nonfree? (
		|| (
			(
				>=media-video/ffmpeg-3.0.0:0[glslang=,jpeg2k?,mp3?,opus?,patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,x264?,x265?]
				<media-video/ffmpeg-7:0
			)
			(
				>=media-video/ffmpeg-3.0.0:56.58.58[glslang=,jpeg2k?,mp3?,opus?,patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,x264?,x265?]
				<media-video/ffmpeg-7:56.58.58
			)
			(
				>=media-video/ffmpeg-3.0.0:57.59.59[glslang=,jpeg2k?,mp3?,opus?,patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,x264?,x265?]
				<media-video/ffmpeg-7:57.59.59
			)
			(
				>=media-video/ffmpeg-3.0.0:58.60.60[glslang=,jpeg2k?,mp3?,opus?,patent_status_nonfree,srt?,svt-av1?,theora?,truetype?,vorbis?,webp?,x264?,x265?]
				<media-video/ffmpeg-7:58.60.60
			)
		)
		x264? (
			media-video/ffmpeg[gpl]
		)
		x265? (
			media-video/ffmpeg[gpl]
		)
		media-video/ffmpeg:=
	)
"
RDEPEND="
	${PATENT_STATUS_RDEPEND}
	>=media-libs/opencolorio-2.1.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-libs/opencolorio:=
	>=media-libs/openimageio-2.1.12[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},png?]
	media-libs/openimageio:=
	>=media-libs/portaudio-19.06.0[alsa?,jack?,oss?]
	>=media-libs/openexr-2.3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/pystring[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/pystring:=
	dev-libs/imath[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/imath:=
	media-libs/openexr:=
	media-libs/opentimelineio[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-libs/opentimelineio:=
	virtual/opengl
	glslang? (
		dev-util/glslang[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-util/glslang:=
	)
	qt5? (
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		dev-qt/qtconcurrent:=
		>=dev-qt/qtcore-${QT5_PV}:5
		dev-qt/qtcore:=
		>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		dev-qt/qtgui:=
		>=dev-qt/qtopengl-${QT5_PV}:5
		dev-qt/qtopengl:=
		>=dev-qt/qtsvg-${QT5_PV}:5
		dev-qt/qtsvg:=
		>=dev-qt/qtwidgets-${QT5_PV}:5[X?]
		dev-qt/qtwidgets:=
	)
	qt6? (
		>=dev-qt/qt5compat-${QT6_PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qt5compat:=
		>=dev-qt/qtbase-${QT6_PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},concurrent,gui,opengl,wayland?,widgets,X?]
		dev-qt/qtbase:=
		>=dev-qt/qtsvg-${QT6_PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qtsvg:=
	)
	xvid? (
		media-video/ffmpeg[gpl,xvid]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.13
	dev-util/patchelf
	doc? (
		>=app-text/doxygen-1.8.17[dot]
	)
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
		dev-qt/linguist-tools:=
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},linguist]
		dev-qt/qttools:=
	)
"
PATCHES=(
)

verify_qt_consistency() {
	local QT_SLOT
	if use qt6 ; then
		QT_SLOT="6"
	elif use qt5 ; then
		QT_SLOT="5"
	else
eerror
eerror "You need to enable qt5 or qt6 USE flag."
eerror
		die
	fi
	local QTCORE_PV=$(pkg-config --modversion Qt${QT_SLOT}Core)

	local qt_pv_major=$(ver_cut 1 "${QTCORE_PV}")
	if use qt6 && [[ "${qt_pv_major}" != "6" ]] ; then
eerror
eerror "QtCore is not 6.x"
eerror
		die
	elif use qt5 && [[ "${qt_pv_major}" != "5" ]] ; then
eerror
eerror "QtCore is not 5.x"
eerror
		die
	fi

	local L=(
		Qt${QT_SLOT}Concurrent
		Qt${QT_SLOT}Gui
		Qt${QT_SLOT}Linguist
		Qt${QT_SLOT}OpenGL
		Qt${QT_SLOT}Svg
		Qt${QT_SLOT}Widgets
	)
	if use qt6 ; then
		L+=(
			Qt${QT_SLOT}Core5Compat
		)
	fi
	local QTPKG_PV
	local pkg_name
	for pkg_name in ${L[@]} ; do
		QTPKG_PV=$(pkg-config --modversion ${pkg_name})
		if ver_test ${QTCORE_PV} -ne ${QTPKG_PV} ; then
eerror
eerror "Qt${QT_SLOT}Core is not the same version as ${pkg_name}."
eerror "Make them the same to continue."
eerror
eerror "Expected version (QtCore):\t\t${QTCORE_PV}"
eerror "Actual version (${pkg_name}):\t${QTPKG_PV}"
eerror
			die
		fi
	done
}

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/KDDockWidgets-${KDDOCWIDGETS_COMMIT}" "${S}/ext/KDDockWidgets"
		dep_prepare_mv "${WORKDIR}/core-${OLIVE_EDITOR_CORE_COMMIT}" "${S}/ext/core"
	fi
}

src_prepare() {
	local PATCHES=(
		$(usex qt6 "${FILESDIR}/${PN}-7e0e94a-stringref-header.patch" '')
		"${FILESDIR}/${PN}-7e0e94a-ffmpeg-paths.patch"
		"${FILESDIR}/${PN}-7e0e94a-oiio-3.0-compat-read-image.patch"
		"${FILESDIR}/${PN}-7e0e94a-ocio-2.3-compat.patch"
		"${FILESDIR}/${PN}-7e0e94a-link-opencolorio.patch"
	)
	cmake_src_prepare
	local pv=$(grep -o -E -e "olive-editor VERSION [0-9.]+" "CMakeLists.txt" \
		| cut -f 3 -d " ")
	if [[ "${pv}" != "${MY_PV}" ]] ; then
eerror
eerror "QA:  Bump MY_PV"
eerror
eerror "Actual:  ${pv}"
eerror "Expected:  ${MY_PV}"
eerror
		die
	fi
}

src_configure() {
	verify_qt_consistency
	local mycmakeargs=(
		-DBUILD_DOXYGEN=$(usex doc)
		-DBUILD_QT6=$(usex qt6)
		-DBUILD_TESTS=$(usex test)
	)

	if has_version "media-video/ffmpeg:58.60.60" ; then
einfo "Using FFMPEG 6.x"
		export FFMPEG_LIBDIR="/usr/lib/ffmpeg/58.60.60/$(get_libdir)"
		mycmakeargs+=(
			-DFFMPEG_INCLUDES="/usr/lib/ffmpeg/58.60.60/include"
			-DFFMPEG_LIBS="${FFMPEG_LIBDIR}"
		)
	elif has_version "media-video/ffmpeg:57.59.59" ; then
einfo "Using FFMPEG 5.x"
		export FFMPEG_LIBDIR="/usr/lib/ffmpeg/57.59.59/$(get_libdir)"
		mycmakeargs+=(
			-DFFMPEG_INCLUDES="/usr/lib/ffmpeg/57.59.59/include"
			-DFFMPEG_LIBS="${FFMPEG_LIBDIR}"
		)
	elif has_version "media-video/ffmpeg:56.58.58" ; then
einfo "Using FFMPEG 4.x"
		export FFMPEG_LIBDIR="/usr/lib/ffmpeg/56.58.58/$(get_libdir)"
		mycmakeargs+=(
			-DFFMPEG_INCLUDES="/usr/lib/ffmpeg/56.58.58/include"
			-DFFMPEG_LIBS="${FFMPEG_LIBDIR}"
		)
	elif has_version "media-video/ffmpeg:0" ; then
einfo "Using FFMPEG:0"
		export FFMPEG_LIBDIR="/usr/$(get_libdir)"
		mycmakeargs+=(
			-DFFMPEG_INCLUDES="/usr/include"
			-DFFMPEG_LIBS="${FFMPEG_LIBDIR}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	exeinto "/usr/$(get_libdir)"
	doexe "${S}_build/ext/core/libolivecore.so"
	if use doc ; then
		docinto "html"
		dodoc -r "${BUILD_DIR}/docs/html/"*
	fi
ewarn
ewarn "You are using an unstable live snapshot.  No guarantees for project files"
ewarn "compatibility with later stable versions."
ewarn

	local L=(
		"${ED}/usr/bin/olive-editor"
		"${ED}/usr/lib64/libolivecore.so"
	)
	local path
	for path in "${L[@]}" ; do
		patchelf --add-rpath "${FFMPEG_LIBDIR}" "${path}" || die
	done
}

pkg_postinst() {
	xdg_pkg_postinst
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (7e0e94a, 20241228)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (7e0e94a, 20251112)
# ALSA sound output - passed
# Import videos - passed
# Qt6 GUI - passed
# Video playback in widget - passed
# Video export - pass
