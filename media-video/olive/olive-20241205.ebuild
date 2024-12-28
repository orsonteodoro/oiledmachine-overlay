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
alsa doc jack +jpeg2k +mp3 +opus oss +png qt5 qt6 test +svt-av1 +theora
+truetype +vorbis wayland +webp X +xvid x264 x265
"
REQUIRED_USE="
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
		>=dev-qt/qt5compat-${QT6_PV}:6
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,gui,opengl,wayland?,widgets,X?]
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
PATCHES=(
)

check_cxxabi() {
	local qt_slot
	local qtcore_package=""
	if use qt6 ; then
		qtcore_package="dev-qt/qtbase"
		qt_slot="6"
	else
		qtcore_package="dev-qt/core"
		qt_slot="5"
	fi

	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local libstdcxx_cxxabi_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local libstdcxx_glibcxx_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qtcore_cxxabi_ver=$(strings "/usr/$(get_libdir)/libQt${qt_slot}Core.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qtcore_glibcxx_ver=$(strings "/usr/$(get_libdir)/libQt${qt_slot}Core.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")

	local ocio_cxxabi_ver=$(strings "/usr/$(get_libdir)/libOpenColorIO.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local ocio_glibcxx_ver=$(strings "/usr/$(get_libdir)/libOpenColorIO.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")


	if ver_test ${libstdcxx_cxxabi_ver} -lt ${qtcore_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol or CXXABI inconsistency."
eerror
eerror "Ensure that the qt${qt_slot}core and the currently selected compiler"
eerror "are built with the same compiler slot."
eerror
eerror "You must decide to pick the GCC slot to rebuild for these 2 packages."
eerror
printf "%-20s %-30s %-10s %-s\n" "Library" "Package" "API/ABI" "API/ABI Version"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "sys-devel/gcc" "CXXABI" "${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "sys-devel/gcc" "GLIBCXX" "${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "${qtcore_package}" "CXXABI" "${qtcore_cxxabi_ver}"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "${qtcore_package}" "GLIBCXX" "${qtcore_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi

	if ver_test ${libstdcxx_cxxabi_ver} -lt ${ocio_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol or CXXABI inconsistency between GCC's libstdc++ and ocio."
eerror
eerror "Ensure that the ocio, qt${qt_slot}core, and the currently selected compiler"
eerror "are built with the same compiler slot."
eerror
eerror "You must decide to pick the GCC slot to rebuild for all 3 packages."
eerror
printf "%-20s %-30s %-10s %-s\n" "Library" "Package" "API/ABI" "API/ABI Version"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "sys-devel/gcc" "CXXABI" "${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "sys-devel/gcc" "GLIBCXX" "${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "ocio" "media-libs/opencolorio" "CXXABI" "${ocio_cxxabi_ver}"
printf "%-20s %-30s %-10s %-s\n" "ocio" "media-libs/opencolorio" "GLIBCXX" "${ocio_glibcxx_ver}"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "${qtcore_package}" "CXXABI" "${qtcore_cxxabi_ver}"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "${qtcore_package}" "GLIBCXX" "${qtcore_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi

	if ver_test ${qt6core_cxxabi_ver} -ne ${ocio_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol or CXXABI inconsistency between qt${qt_slot}core and ocio."
eerror
eerror "Ensure that the ocio, qt${qt_slot}core, and the currently selected compiler"
eerror "are built with the same compiler slot."
eerror
eerror "You must decide to pick the GCC slot to rebuild for all 3 packages."
eerror
printf "%-20s %-30s %-10s %-s\n" "Library" "Package" "API/ABI" "API/ABI Version"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "CXXABI" "${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "libstdcxx" "GLIBCXX" "${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
printf "%-20s %-30s %-10s %-s\n" "ocio" "media-libs/opencolorio" "CXXABI" "${ocio_cxxabi_ver}"
printf "%-20s %-30s %-10s %-s\n" "ocio" "media-libs/opencolorio" "GLIBCXX" "${ocio_glibcxx_ver}"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "CXXABI" "${qtcore_package}" "${qtcore_cxxabi_ver}"
printf "%-20s %-30s %-10s %-s\n" "qt${qt_slot}core" "GLIBCXX" "${qtcore_package}" "${qtcore_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi


}

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
	cmake_src_prepare
	if use qt6 ; then
		eapply "${FILESDIR}/${PN}-7e0e94a-stringref-header.patch"
	fi
}

src_configure() {
	verify_qt_consistency
	check_cxxabi
	local mycmakeargs=(
		-DBUILD_DOXYGEN=$(usex doc)
		-DBUILD_QT6=$(usex qt6)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use doc ; then
		docinto "html"
		dodoc -r "${BUILD_DIR}/docs/html/"*
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}
