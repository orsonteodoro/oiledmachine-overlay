# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

EGIT_COMMIT="7e0e94abf6610026aebb9ddce8564c39522fac6e"
KDDOCWIDGETS_COMMIT="8d2d0a5764f8393cc148a2296d511276a8ffe559"
OLIVE_EDITOR_CORE_COMMIT="277792824801495e868580ca86f6e7a1b53e4779"
QT5_PV="5.6.0"
QT6_PV="6.0.0"

inherit cmake dep-prepare xdg

if [[ "${PV}" == *"9999" ]]; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/olive-editor/olive.git"
	FALLBACK_COMMIT="7e0e94abf6610026aebb9ddce8564c39522fac6e" # Dec 5, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/olive-editor/olive/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
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
SLOT="0"
# For default ON status see docker/scripts/build_ffmpeg.sh
# Only expired patents or non taxed patents will be enabled default ON in this ebuild.
IUSE+="
alsa doc jack +jpeg2k +mp3 +opus oss +png qt5 qt6 test +svt-av1 +theora +truetype +vorbis +webp +xvid x264 x265
"
REQUIRED_USE="
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
	^^ (
		qt5
		qt6
	)
"
RESTRICT="
	!test? (
		test
	)
"
#	media-libs/olivecore
DEPEND="
	>=media-libs/opencolorio-2.1.1:=
	>=media-libs/openimageio-2.1.12:=[png?]
	>=media-video/ffmpeg-3.0.0[jpeg2k?,mp3?,opus?,svt-av1?,theora?,truetype?,vorbis?,webp?]
	>=media-libs/portaudio-19.06.0[alsa?,jack?,oss?]
	>=media-libs/openexr-2.3.0:=
	media-libs/opentimelineio:=
	virtual/opengl
	qt5? (
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		dev-qt/qtconcurrent:=
		>=dev-qt/qtcore-${QT5_PV}:5
		dev-qt/qtcore:=
		>=dev-qt/qtgui-${QT5_PV}:5
		dev-qt/qtgui:=
		>=dev-qt/qtopengl-${QT5_PV}:5
		dev-qt/qtopengl:=
		>=dev-qt/qtsvg-${QT5_PV}:5
		dev-qt/qtsvg:=
		>=dev-qt/qtwidgets-${QT5_PV}:5
		dev-qt/qtwidgets:=
	)
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,gui,opengl,widgets]
		dev-qt/qtbase:=
		>=dev-qt/qtsvg-${QT6_PV}:6
		dev-qt/qtsvg:=
	)
	xvid? (
		media-video/ffmpeg[gpl,xvid]
	)
	x264? (
		media-video/ffmpeg[gpl,x264]
	)
	x265? (
		media-video/ffmpeg[gpl,x265]
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.13
	doc? (
		>=app-text/doxygen-1.8.17[dot]
	)
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
	)
"

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

src_configure() {
	verify_qt_consistency
	local mycmakeargs=(
		-DBUILD_DOXYGEN="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use doc; then
		docinto "html"
		dodoc -r "${BUILD_DIR}/docs/html/"*
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}
