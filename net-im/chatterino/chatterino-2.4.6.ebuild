# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="483M"
CHECKREQS_DISK_USR="33M"

CXXSTD="20"
inherit check-reqs cmake git-r3 toolchain-funcs xdg-utils

DESCRIPTION="Chat client for https://twitch.tv"
HOMEPAGE="
	https://chatterino.com/
	https://github.com/Chatterino/chatterino2
"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		BSD
		MIT
		JSON
	)
	(
		BSD
		MIT
		ZLIB
	)
	Apache-2.0
	BSD
	Boost-1.0
	MIT
	|| (
		MIT-0
		Unlicense
	)
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	MIT
"
# all-rights-reserved MIT BSD JSON - lib/rapidjson/license.txt
# Apache-2.0 - lib/rapidjson/thirdparty/gtest/googlemock/scripts/generator/LICENSE
# BSD - lib/lrucache/LICENSE
# BSD ZLIB MIT - lib/websocketpp/COPYING
# Boost-1.0 - lib/magic_enum/test/3rdparty/Catch2/LICENSE
# MIT - lib/signals/LICENSE
# || ( Unlicense MIT-0 ) - lib/miniaudio/LICENSE
SLOT="0"
KEYWORDS="~amd64 ~x86"
# -system-pajlada-settings is not packaged on this distro
IUSE+="
-benchmarks -coverage -crashpad -lto -plugins -system-libcommuni
-system-qtkeychain -test +qt5 -qt6 +qtkeychain wayland X

r4
"
# Building benchmarks is broken
REQUIRED_USE="
	!benchmarks
	^^ (
		qt5
		qt6
	)
	qt6? (
		!system-libcommuni
		!system-qtkeychain
	)
	system-qtkeychain? (
		qtkeychain
	)
	|| (
		X
		wayland
	)
"
# For deps, see
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/.CI/CreateUbuntuDeb.sh
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/.github/workflows/build.yml#L204
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/BUILDING_ON_LINUX.md
# Deps based on U 20.04 + CI override
SRC_URI=""
QT5_PV="5.12.12" # Based on CI
QT6_PV="6.2.4" # Based on CI
# Upstream uses a live version for qtkeychain but downgraded in this ebuild with
# the system-qtkeychain USE flag to test if it works.
RDEPEND="
	>=dev-libs/openssl-1.1.1f:=
	benchmarks? (
		dev-cpp/benchmark
	)
	qt5? (
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtdbus-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		>=dev-qt/qtimageformats-${QT5_PV}:5
		>=dev-qt/qtmultimedia-${QT5_PV}:5
		>=dev-qt/qtnetwork-${QT5_PV}:5
		>=dev-qt/qtsvg-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5[X?]
		system-libcommuni? (
			>=net-im/libcommuni-3.7
		)
		system-qtkeychain? (
			>=dev-libs/qtkeychain-13
		)
	)
	qt6? (
		>=dev-qt/qt5compat-${QT6_PV}:6
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,dbus,gui,network,wayland?,widgets,X?]
		>=dev-qt/qtimageformats-${QT6_PV}:6
		>=dev-qt/qtmultimedia-${QT6_PV}:6
		>=dev-qt/qtsvg-${QT6_PV}:6
		wayland? (
			>=dev-qt/qtwayland-${QT6_PV}:6
			>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
	)
	>=dev-libs/boost-1.71.0
	>=dev-libs/rapidjson-1.1.0
	>=dev-util/cmake-3.16.3
	>=sys-devel/gcc-9.4.0
	virtual/pkgconfig
"
S="${WORKDIR}/${P}"

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
		Qt${QT_SLOT}DBus
		Qt${QT_SLOT}Gui
		Qt${QT_SLOT}Multimedia
		Qt${QT_SLOT}Network
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
	pkg_name="qtimageformats"
	QTPKG_PV=$(best_version "dev-qt/qtimageformats:5" \
		| sed -e "s|dev-qt/qtimageformats-||g")
	QTPKG_PV=$(ver_cut 1-3 ${QTPKG_PV})
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
}

verify_cxx20() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo
	test-flags-CXX "-std=c++${CXXSTD}" 2>/dev/null 1>/dev/null \
		|| die "Switch to a c++${CXXSTD} compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-major-version) -lt 11 ; then
			die "${PN} requires GCC >=11 for c++${CXXSTD} support"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt 11 ; then
			die "${PN} requires Clang >=11 for c++${CXXSTD} support"
		fi
	else
		die "Compiler is not supported"
	fi
}

pkg_setup() {
	check-reqs_pkg_setup
	use qt5 && verify_qt_consistency 5
	use qt6 && verify_qt_consistency 6
	verify_cxx20
}

src_unpack() {
	# The repos have nested dependencies.  Using tarballs on GH doesn't
        # usually pick them up.
	EGIT_REPO_URI="https://github.com/Chatterino/chatterino2.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="v${PV}"
	EGIT_SUBMODULES=( '*' )
	EGIT_SUBMODULES+=( '-*WinToast*' )
	if ! use crashpad ; then
		EGIT_SUBMODULES+=( '-*crashpad*' )
	fi
	if ! use test ; then
		EGIT_SUBMODULES+=(
			'-*googletest*'
		)
	fi
	if use system-qtkeychain ; then
		EGIT_SUBMODULES+=( '-*qtkeychain*' )
	fi
	if use system-libcommuni ; then
		EGIT_SUBMODULES+=( '-*libcommuni*' )
	fi
	git-r3_fetch
	git-r3_checkout
}

src_configure() {
	local mycmakeargs=(
		-DCHATTERINO_LTO=$(usex lto "ON" "OFF")
		-DCHATTERINO_GENERATE_COVERAGE=$(usex coverage "ON" "OFF")
		-DCHATTERINO_PLUGINS=$(usex plugins "ON" "OFF")
		-DBUILD_BENCHMARKS=$(usex benchmarks "ON" "OFF")
		-DBUILD_TESTS=$(usex test "ON" "OFF")
		-DBUILD_TRANSLATIONS=OFF # A design choice by project to always turn it off for qtkeychain.
		-DBUILD_WITH_CRASHPAD=$(usex crashpad "ON" "OFF")
		-DBUILD_WITH_QT6=$(usex qt6 "ON" "OFF")
		-DBUILD_WITH_QTKEYCHAIN=$(usex qtkeychain "ON" "OFF")
		-DUSE_SYSTEM_LIBCOMMUNI=$(usex system-libcommuni "ON" "OFF")
		-DUSE_SYSTEM_PAJLADA_SETTINGS=OFF
		-DUSE_SYSTEM_QTKEYCHAIN=$(usex system-qtkeychain "ON" "OFF")
	)
	cmake_src_configure
}

src_prepare() {
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	mv "${D}/usr/share/icons/hicolor/256x256/apps/"{com.chatterino.,}"chatterino.png" || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) (20230529)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) (20230625)
# USE="X qt6 wayland -benchmarks -coverage (-crashpad) -lto -plugins (-qt5)
# -qtkeychain -r3 -system-libcommuni -system-qtkeychain -test"
# X tests:
#   view about screen:  passed
# wayland tests:
#   view about screen:  passed
