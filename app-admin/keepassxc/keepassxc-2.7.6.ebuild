# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

QT6_PV="6.6.1"
QT5_PV="5.2.0"

# Time to convert to Qt6
# patch start time:  1705819601 (Sat Jan 20 10:46:41 PM PST 2024)
# patch end time:  1706069824 (Tue Jan 23 08:17:04 PM PST 2024)
# patch end time (w/o tests):  1706069824 (Tue Jan 23 08:17:04 PM PST 2024)
# patch end time w/tests:  1706076238 (Tue Jan 23 10:03:58 PM PST 2024)

# Progress:  313/313 (w/o tests) with makeopts -j1
# Progress:  459/459 (w/ tests) with makeopts -j1

# Status (for qt6 support):  Unfinished / In-development

if [[ "${PV}" != *9999 ]] ; then
	if [[ "${PV}" == *_beta* ]] ; then
		SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${P/_/-}"
	else
		SRC_URI="https://github.com/keepassxreboot/${PN}/releases/download/${PV}/${P}-src.tar.xz"
#		KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
	fi
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
	[[ "${PV}" != 9999 ]] && EGIT_BRANCH="master"
fi

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="
	https://keepassxc.org/
	https://github.com/keepassxreboot/keepassxc/
"
LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="X autotype browser doc keeshare +network qt5 qt5compat qt6 test wayland yubikey"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	autotype? (
		X
	)
	qt5compat? (
		qt6
	)
	^^ (
		qt5
		qt6
	)
	^^ (
		X
		wayland
	)
"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	media-gfx/qrencode:=
	sys-libs/readline:0=
	sys-libs/zlib:=
	autotype? (
		x11-libs/libX11
		x11-libs/libXtst
	)
	keeshare? (
		sys-libs/zlib:=[minizip]
	)
	qt5? (
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtdbus-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		>=dev-qt/qtnetwork-${QT5_PV}:5
		>=dev-qt/qtsvg-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5
		wayland? (
			>=dev-qt/qtwayland-${QT5_PV}:5
		)
	)
	qt6? (
		>=dev-qt/qt5compat-${QT6_PV}:6
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,dbus,gui,network,wayland?,X?]
		>=dev-qt/qtsvg-${QT6_PV}:6
		wayland? (
			>=dev-qt/qtwayland-${QT6_PV}:6
		)
	)
	X? (
		qt5? (
			>=dev-qt/qtx11extras-${QT5_PV}:5
			x11-libs/libX11
			x11-libs/libxcb
		)
		qt6? (
			x11-libs/libX11
			x11-libs/libxcb
		)
	)
	yubikey? (
		dev-libs/libusb:1
		sys-apps/pcsc-lite
	)
"
DEPEND="
	${RDEPEND}
	qt5? (
		>=dev-qt/qttest-${QT5_PV}:5
	)
"
# dev-qt/qtbase contains qttest
BDEPEND="
	doc? (
		dev-ruby/asciidoctor
	)
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
		X? (
			virtual/pkgconfig
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.7.4-tests.patch"
	"${FILESDIR}/${PN}-2.7.6-qt6-support.patch"
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
		Qt${QT_SLOT}DBus
		Qt${QT_SLOT}Gui
		Qt${QT_SLOT}Network
		Qt${QT_SLOT}Svg
		Qt${QT_SLOT}Widgets
	)
	if [[ "${QT_SLOT}" == "6" ]] ; then
		L+=(
			Qt6Core5Compat
		)
		if use test ; then
			L+=(
				Qt6Test
			)
		fi
	elif [[ "${QT_SLOT}" == "5" ]] ; then
		if use test ; then
			L+=(
				Qt5Test
			)
		fi
		if use X ; then
			L+=(
				Qt5X11Extras
			)
		fi
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
	use qt5 && verify_qt_consistency 5
	use qt6 && verify_qt_consistency 6
}

src_prepare() {
ewarn "This ebuild is in development.  Use the distro ebuild instead."
	if [[ "${PV}" != *_beta* ]] && [[ "${PV}" != *9999 ]] && [[ ! -f .version ]] ; then
		printf '%s' "${PV}" > .version || die
	fi

	cmake_src_prepare
}

src_configure() {
	# https://github.com/keepassxreboot/keepassxc/issues/5801
	filter-lto
	replace-flags '-O*' '-O2'
	export MAKEOPTS="-j1"

	local mycmakeargs=(
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
		# other means. We don't want the build system to enable it for us.
		-DWITH_CCACHE=OFF
		-DWITH_GUI_TESTS=OFF
		-DWITH_QT5="$(usex qt5)"
		-DWITH_QT5COMPAT="$(usex qt5compat)"
		-DWITH_QT6="$(usex qt6)"
		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_DOCS="$(usex doc)"
		-DWITH_XC_BROWSER="$(usex browser)"
		-DWITH_XC_BOTAN3=ON
		-DWITH_XC_FDOSECRETS=ON
		-DWITH_XC_KEESHARE="$(usex keeshare)"
		-DWITH_XC_NETWORKING="$(usex network)"
		-DWITH_XC_SSHAGENT=ON
		-DWITH_XC_UPDATECHECK=OFF
		-DWITH_XC_YUBIKEY="$(usex yubikey)"
		-DWITH_XC_X11="$(usex X)"
	)
	if use qt6 ; then
		mycmakeargs+=( -DCMAKE_CXX_COMPILER=clazy  )
	fi
	if [[ "${PV}" == *_beta* ]] ; then
		mycmakeargs+=( -DOVERRIDE_VERSION="${PV/_/-}" )
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# OILEDMACHINE-OVERLAY-TEST:  fail with qt6 only, fail with qt6 and qt5compat
# qt6 - pass
#   gui - pass
#   unlock/load db - fail
#   wayland - pass (with non-root user), fail (with root)
# qt5 - untested

# Test results for USE="X -qt5compat qt6 test -autotype -browser -doc -keeshare -network (-qt5) -wayland -yubikey"
# Note the TestKeePass1Reader::testCP1252Password() was disabled since cp-1252 is not supported on pure qt6 build on linux.
__TEST_RESULTS="
ctest -j 1 --test-load 4
Test project /var/tmp/portage/app-admin/keepassxc-2.7.6/work/keepassxc-2.7.6_build
      Start  1: testgroup
 1/33 Test  #1: testgroup ........................   Passed    0.04 sec
      Start  2: testkdbx2
 2/33 Test  #2: testkdbx2 ........................   Passed    0.28 sec
      Start  3: testkdbx3
 3/33 Test  #3: testkdbx3 ........................   Passed   68.96 sec
      Start  4: testkdbx4
 4/33 Test  #4: testkdbx4 ........................   Passed  210.08 sec
      Start  5: testkeys
 5/33 Test  #5: testkeys .........................   Passed  101.79 sec
      Start  6: testgroupmodel
 6/33 Test  #6: testgroupmodel ...................   Passed    0.03 sec
      Start  7: testentrymodel
 7/33 Test  #7: testentrymodel ...................   Passed    0.09 sec
      Start  8: testcryptohash
 8/33 Test  #8: testcryptohash ...................   Passed    0.02 sec
      Start  9: testsymmetriccipher
 9/33 Test  #9: testsymmetriccipher ..............   Passed    0.26 sec
      Start 10: testhashedblockstream
10/33 Test #10: testhashedblockstream ............   Passed    0.03 sec
      Start 11: testkeepass2randomstream
11/33 Test #11: testkeepass2randomstream .........   Passed    0.03 sec
      Start 12: testmodified
12/33 Test #12: testmodified .....................   Passed   17.72 sec
      Start 13: testdeletedobjects
13/33 Test #13: testdeletedobjects ...............   Passed    0.04 sec
      Start 14: testkeepass1reader
14/33 Test #14: testkeepass1reader ...............   Passed    5.04 sec
      Start 15: testopvaultreader
15/33 Test #15: testopvaultreader ................   Passed    6.39 sec
      Start 16: testopensshkey
16/33 Test #16: testopensshkey ...................   Passed   10.15 sec
      Start 17: testsshagent
17/33 Test #17: testsshagent .....................   Passed    1.98 sec
      Start 18: testentry
18/33 Test #18: testentry ........................   Passed    0.04 sec
      Start 19: testmerge
19/33 Test #19: testmerge ........................   Passed    0.31 sec
      Start 20: testpasswordgenerator
20/33 Test #20: testpasswordgenerator ............   Passed    0.07 sec
      Start 21: testpasswordhealth
21/33 Test #21: testpasswordhealth ...............   Passed    0.03 sec
      Start 22: testpassphrasegenerator
22/33 Test #22: testpassphrasegenerator ..........   Passed    0.05 sec
      Start 23: testhibp
23/33 Test #23: testhibp .........................   Passed    0.03 sec
      Start 24: testtotp
24/33 Test #24: testtotp .........................   Passed    0.03 sec
      Start 25: testbase32
25/33 Test #25: testbase32 .......................   Passed    0.01 sec
      Start 26: testcsvparser
26/33 Test #26: testcsvparser ....................   Passed    0.02 sec
      Start 27: testrandomgenerator
27/33 Test #27: testrandomgenerator ..............   Passed    0.01 sec
      Start 28: testentrysearcher
28/33 Test #28: testentrysearcher ................   Passed    0.03 sec
      Start 29: testcsvexporter
29/33 Test #29: testcsvexporter ..................   Passed    0.03 sec
      Start 30: testdatabase
30/33 Test #30: testdatabase .....................   Passed    5.56 sec
      Start 31: testtools
31/33 Test #31: testtools ........................   Passed    0.02 sec
      Start 32: testconfig
32/33 Test #32: testconfig .......................   Passed    0.06 sec
      Start 33: testfdosecrets
33/33 Test #33: testfdosecrets ...................   Passed    0.04 sec

100% tests passed, 0 tests failed out of 33

Total Test time (real) = 680.55 sec
"
