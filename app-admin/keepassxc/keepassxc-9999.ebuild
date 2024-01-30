# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

QT6_PV="6.6.1"
QT5_PV="5.2.0"

if [[ "${PV}" != *9999 ]] ; then
	if [[ "${PV}" == *_beta* ]] ; then
		SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${P/_/-}"
	else
		SRC_URI="https://github.com/keepassxreboot/${PN}/releases/download/${PV}/${P}-src.tar.xz"
		KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
	fi
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
	[[ "${PV}" != 9999 ]] && EGIT_BRANCH="master"
	IUSE+=" fallback-commit"
fi

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="
	https://keepassxc.org/
	https://github.com/keepassxreboot/keepassxc/
"
LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE+=" X autotype browser doc keeshare +network qt5 qt5compat qt6 test wayland yubikey"
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
	|| (
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
	"${FILESDIR}/${PN}-442d65a-qt6-support.patch"
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
	if use qt6 ; then
eerror "Patch conversion needs to be done.  Use 2.7.x ebuild instead."
#		die
	fi
	if [[ "${PV}" != *_beta* ]] && [[ "${PV}" != *9999 ]] && [[ ! -f .version ]] ; then
		printf '%s' "${PV}" > .version || die
	fi

	cmake_src_prepare
}

unpack_live() {
	if use fallback-commit ; then
		EGIT_COMMIT="442d65a497161d9a6e3dd4bec5ac1fb62de04f46"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
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
# OILEDMACHINE-OVERLAY-TEST:  pass with qt6 only, pass with qt6 and qt5compat (20240127)
# qt6 - pass
#   gui - pass
#   unlock/load db - pass
#   wayland - untested
# qt5 - untested

# Results for USE="X autotype browser keeshare network qt5compat qt6 test yubikey -doc (-qt5) -wayland"
__TEST_RESULTS="
ctest -j 1 --test-load 4
Test project /var/tmp/portage/app-admin/keepassxc-9999/work/keepassxc-9999_build
      Start  1: testgroup
 1/41 Test  #1: testgroup ........................   Passed    0.04 sec
      Start  2: testkdbx2
 2/41 Test  #2: testkdbx2 ........................   Passed    0.29 sec
      Start  3: testkdbx3
 3/41 Test  #3: testkdbx3 ........................   Passed   65.49 sec
      Start  4: testkdbx4
 4/41 Test  #4: testkdbx4 ........................   Passed  170.58 sec
      Start  5: testkeys
 5/41 Test  #5: testkeys .........................   Passed  104.26 sec
      Start  6: testgroupmodel
 6/41 Test  #6: testgroupmodel ...................   Passed    0.03 sec
      Start  7: testentrymodel
 7/41 Test  #7: testentrymodel ...................   Passed    0.07 sec
      Start  8: testcryptohash
 8/41 Test  #8: testcryptohash ...................   Passed    0.02 sec
      Start  9: testsymmetriccipher
 9/41 Test  #9: testsymmetriccipher ..............   Passed    0.26 sec
      Start 10: testhashedblockstream
10/41 Test #10: testhashedblockstream ............   Passed    0.03 sec
      Start 11: testkeepass2randomstream
11/41 Test #11: testkeepass2randomstream .........   Passed    0.03 sec
      Start 12: testmodified
12/41 Test #12: testmodified .....................   Passed   17.89 sec
      Start 13: testdeletedobjects
13/41 Test #13: testdeletedobjects ...............   Passed    0.05 sec
      Start 14: testkeepass1reader
14/41 Test #14: testkeepass1reader ...............   Passed    5.08 sec
      Start 15: testopvaultreader
15/41 Test #15: testopvaultreader ................   Passed    5.22 sec
      Start 16: testupdatecheck
16/41 Test #16: testupdatecheck ..................   Passed    0.04 sec
      Start 17: testicondownloader
17/41 Test #17: testicondownloader ...............   Passed    0.04 sec
      Start 18: testautotype
18/41 Test #18: testautotype .....................   Passed   12.89 sec
      Start 19: testopensshkey
19/41 Test #19: testopensshkey ...................***Failed   10.21 sec
      Start 20: testsshagent
20/41 Test #20: testsshagent .....................   Passed    2.37 sec
      Start 21: testentry
21/41 Test #21: testentry ........................   Passed    0.04 sec
      Start 22: testmerge
22/41 Test #22: testmerge ........................   Passed    0.25 sec
      Start 23: testpasswordgenerator
23/41 Test #23: testpasswordgenerator ............   Passed    0.06 sec
      Start 24: testpasswordhealth
24/41 Test #24: testpasswordhealth ...............   Passed    0.03 sec
      Start 25: testpassphrasegenerator
25/41 Test #25: testpassphrasegenerator ..........   Passed    0.05 sec
      Start 26: testhibp
26/41 Test #26: testhibp .........................   Passed    0.03 sec
      Start 27: testtotp
27/41 Test #27: testtotp .........................   Passed    0.03 sec
      Start 28: testbase32
28/41 Test #28: testbase32 .......................   Passed    0.01 sec
      Start 29: testcsvparser
29/41 Test #29: testcsvparser ....................   Passed    0.02 sec
      Start 30: testrandomgenerator
30/41 Test #30: testrandomgenerator ..............   Passed    0.02 sec
      Start 31: testentrysearcher
31/41 Test #31: testentrysearcher ................   Passed    0.03 sec
      Start 32: testcsvexporter
32/41 Test #32: testcsvexporter ..................   Passed    0.03 sec
      Start 33: testykchallengeresponsekey
33/41 Test #33: testykchallengeresponsekey .......   Passed    0.08 sec
      Start 34: testsharing
34/41 Test #34: testsharing ......................   Passed    0.60 sec
      Start 35: testdatabase
35/41 Test #35: testdatabase .....................   Passed    5.58 sec
      Start 36: testtools
36/41 Test #36: testtools ........................   Passed    0.02 sec
      Start 37: testconfig
37/41 Test #37: testconfig .......................   Passed    0.05 sec
      Start 38: testfdosecrets
38/41 Test #38: testfdosecrets ...................   Passed    0.06 sec
      Start 39: testbrowser
39/41 Test #39: testbrowser ......................   Passed    0.13 sec
      Start 40: testurltools
40/41 Test #40: testurltools .....................***Failed    0.03 sec
      Start 41: testcli
41/41 Test #41: testcli ..........................Subprocess aborted***Exception:   0.04 sec

93% tests passed, 3 tests failed out of 41

Total Test time (real) = 402.13 sec

The following tests FAILED:
	 19 - testopensshkey (Failed)
	 40 - testurltools (Failed)
	 41 - testcli (Subprocess aborted)
Errors while running CTest
Output from these tests are in: /var/tmp/portage/app-admin/keepassxc-9999/work/keepassxc-9999_build/Testing/Temporary/LastTest.log
Use \"--rerun-failed --output-on-failure\" to re-run the failed cases verbosely.
"
