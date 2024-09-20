# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_PV="5.2.0"
QT6_PV="6.6.1"
VIRTUALX_REQUIRED="manual"

inherit cmake flag-o-matic toolchain-funcs virtualx xdg

# Time to convert to Qt6
# patch start time:  1705819601 (Sat Jan 20 10:46:41 PM PST 2024)
# patch end time:  1706069824 (Tue Jan 23 08:17:04 PM PST 2024)
# patch end time (w/o tests):  1706069824 (Tue Jan 23 08:17:04 PM PST 2024)
# patch end time w/tests:  1706076238 (Tue Jan 23 10:03:58 PM PST 2024)

# Progress:  313/313 (w/o tests) with makeopts -j1
# Progress:  459/459 (w/ tests) with makeopts -j1

# Status (for qt6 support):  Unfinished / In-development


if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
	inherit git-r3
else
	#KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86" # Test failure for 1 test
	if [[ "${PV}" == *_beta* ]] ; then
		S="${WORKDIR}/${P/_/-}"
		SRC_URI="
https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz
	-> ${P}.tar.gz
		"
	else
		SRC_URI="
https://github.com/keepassxreboot/${PN}/releases/download/${PV}/${P}-src.tar.xz
		"
	fi
fi

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="
	https://keepassxc.org/
	https://github.com/keepassxreboot/keepassxc/
"
LICENSE="
	LGPL-2.1
	GPL-2
	GPL-3
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="
X autotype browser doc keeshare +network qt5 qt5compat qt6 test wayland yubikey
"
REQUIRED_USE="
	^^ (
		qt5
		qt6
	)
	autotype? (
		X
	)
	qt5compat? (
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
	sys-kernel/mitigate-id
	sys-libs/readline:0=
	sys-libs/zlib:=[minizip]
	autotype? (
		x11-libs/libX11
		x11-libs/libXtst
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
	test? (
		wayland? (
			>=gui-libs/wlroots-0.15.1-r1[tinywl]
			x11-misc/xkeyboard-config
		)
		X? (
			${VIRTUALX_DEPEND}
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.7.9-tests.patch"
	"${FILESDIR}/${PN}-2.7.9-qt6-support-v2.patch"
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
		"Qt${QT_SLOT}Concurrent"
		"Qt${QT_SLOT}DBus"
		"Qt${QT_SLOT}Gui"
		"Qt${QT_SLOT}Network"
		"Qt${QT_SLOT}Svg"
		"Qt${QT_SLOT}Widgets"
	)
	if [[ "${QT_SLOT}" == "6" ]] ; then
		L+=(
			"Qt6Core5Compat"
		)
		if use test ; then
			L+=(
				"Qt6Test"
			)
		fi
	elif [[ "${QT_SLOT}" == "5" ]] ; then
		if use test ; then
			L+=(
				"Qt5Test"
			)
		fi
		if use X ; then
			L+=(
				"Qt5X11Extras"
			)
		fi
	fi
	local QTPKG_PV
	local pkg_name
	for pkg_name in ${L[@]} ; do
		QTPKG_PV=$(pkg-config --modversion ${pkg_name})
		if ver_test "${QTCORE_PV}" -ne "${QTPKG_PV}" ; then
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
	export CC="$(tc-getCC)"
	export CXX="$(tc-getCXX)"
	if ver_test $(gcc-major-version) -lt "13" ; then
ewarn "You must switch your gcc to 13 to avoid build time error(s)."
	fi
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

	local -a mycmakeargs=(
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
		-DWITH_XC_BROWSER_PASSKEYS="$(usex browser)"
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
		mycmakeargs+=(
			-DCMAKE_CXX_COMPILER="clazy"
		)
	fi
	if [[ "${PV}" == *_beta* ]] ; then
		mycmakeargs+=(
			-DOVERRIDE_VERSION="${PV/_/-}"
		)
	fi
	cmake_src_configure
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

        [[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"
        [[ -n $XDG_RUNTIME_DIR ]] || die "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
        tinywl -h >/dev/null || die 'tinywl -h failed'

        # TODO: don't run addpredict in utility function. WLR_RENDERER=pixman doesn't work
        addpredict /dev/dri
        local VIRTWL VIRTWL_PID
        coproc VIRTWL { WLR_BACKENDS=headless exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; }
        local -x WAYLAND_DISPLAY
        read WAYLAND_DISPLAY <&${VIRTWL[0]}

        debug-print "${FUNCNAME}: $@"
        "$@"
        local r=$?

        [[ -n $VIRTWL_PID ]] || die "tinywl exited unexpectedly"
        exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
        return $r
}

src_test() {
	cd "${BUILD_DIR}" || die
	if use X ; then
		virtx ctest -j 1 --test-load 4
	fi
	if use wayland ; then
		virtwl ctest -j 1 --test-load 4
	fi
}

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO autotype timer and topLevelDomains() are unfinished
# OILEDMACHINE-OVERLAY-TEST:  pass with qt6 only, pass with qt6 and qt5compat (20240127)
# qt6 - pass
#   gui - pass
#   unlock/load db - pass
#   wayland - pass (with non-root user), fail (with root)
# qt5 - untested

# Test results for USE="X* autotype* browser* keeshare* network* qt5compat qt6 test* yubikey* -doc (-qt5) -wayland*"
# Note the TestKeePass1Reader::testCP1252Password() was disabled since cp-1252 is not supported on pure qt6 build on linux.


# FIXME:

#FAIL!  : TestPasskeys::testCreatingAttestationObjectWithEC() Compared values are not the same
#   Actual   (result)                                                                                                                                                                                                                                                                                                          : "\xA3""cfmtdnonegattStmt\xA0hauthDataX\xA4t\xA6\xEA\x92\x13\xC9\x9C/t\xB2$\x92\xB3 \xCF@&*\x94\xC1\xA9P\xA0""9\x7F)%\x0B`\x84\x1E\xF0""E\x00\x00\x00\x00\xFD\xB1""A\xB2]\x84""D>\x8A""5F\x98\xC2\x05\xA5\x02\x00 \xCA\xBC\xC5'\x99pr\x94\xF0`\xC3\x9D])"...
#   Expected (QString("\xA3" "cfmtdnonegattStmt\xA0hauthDataX\xA4t\xA6\xEA\x92\x13\xC9\x9C/t\xB2$\x92\xB3 \xCF@&*\x94\xC1\xA9P\xA0" "9\x7F)%\x0B`\x84\x1E\xF0" "E\x00\x00\x00\x01\x01\x02\x03\x04\x05\x06\x07\b\x01\x02\x03\x04\x05\x06\x07\b\x00 \x8B\xB0\xCA" "6\x17\xD6\xDE\x01\x11|\xEA\x94\r\xA0R\xC0\x80_\xF3r\xFBr\xB5\x02\x03:" "\xBAr\x0Fi\x81\xFE\xA5\x01\x02\x03& \x01!X " "e\xE2\xF2\x1F:cq\xD3G\xEA\xE0\xF7\x1F\xCF\xFA\\\xABO\xF6\x86\x88\x80\t\xAE\x81\x8BT\xB2\x9B\x15\x85~" "\"X \\\x8E\x1E@\xDB\x97T-\xF8\x9B\xB0\xAD" "5\xDC\x12^\xC3\x95\x05\xC6\xDF^\x03\xCB\xB4Q\x91\xFF|\xDB\x94\xB7")): "\uFFFDcfmtdnonegattStmt\uFFFDhauthDataX\uFFFDt\uFFFD\uFFFD\uFFFD\u0013\u025C/t\uFFFD$\uFFFD\uFFFD \uFFFD@&*\uFFFD\uFFFD\uFFFDP\uFFFD9\u007F)%\u000B`\uFFFD\u001E\uFFFDE"
#   Loc: [/var/tmp/portage/app-admin/keepassxc-2.7.9/work/keepassxc-2.7.9/tests/TestPasskeys.cpp(285)]

__TEST_RESULTS="
Test project /var/tmp/portage/app-admin/keepassxc-2.7.9/work/keepassxc-2.7.9_build
      Start  1: testgroup
 1/41 Test  #1: testgroup ........................   Passed    1.77 sec
      Start  2: testkdbx2
 2/41 Test  #2: testkdbx2 ........................   Passed    0.35 sec
      Start  3: testkdbx3
 3/41 Test  #3: testkdbx3 ........................   Passed   58.37 sec
      Start  4: testkdbx4
 4/41 Test  #4: testkdbx4 ........................   Passed  138.68 sec
      Start  5: testkeys
 5/41 Test  #5: testkeys .........................   Passed   93.84 sec
      Start  6: testgroupmodel
 6/41 Test  #6: testgroupmodel ...................   Passed    0.58 sec
      Start  7: testentrymodel
 7/41 Test  #7: testentrymodel ...................   Passed    0.21 sec
      Start  8: testcryptohash
 8/41 Test  #8: testcryptohash ...................   Passed    0.02 sec
      Start  9: testsymmetriccipher
 9/41 Test  #9: testsymmetriccipher ..............   Passed    0.37 sec
      Start 10: testhashedblockstream
10/41 Test #10: testhashedblockstream ............   Passed    0.03 sec
      Start 11: testkeepass2randomstream
11/41 Test #11: testkeepass2randomstream .........   Passed    0.02 sec
      Start 12: testmodified
12/41 Test #12: testmodified .....................   Passed   16.95 sec
      Start 13: testdeletedobjects
13/41 Test #13: testdeletedobjects ...............   Passed    0.06 sec
      Start 14: testkeepass1reader
14/41 Test #14: testkeepass1reader ...............   Passed    5.19 sec
      Start 15: testimports
15/41 Test #15: testimports ......................   Passed    5.12 sec
      Start 16: testupdatecheck
16/41 Test #16: testupdatecheck ..................   Passed    0.03 sec
      Start 17: testicondownloader
17/41 Test #17: testicondownloader ...............   Passed    0.20 sec
      Start 18: testautotype
18/41 Test #18: testautotype .....................   Passed   14.56 sec
      Start 19: testopensshkey
19/41 Test #19: testopensshkey ...................   Passed    9.16 sec
      Start 20: testsshagent
20/41 Test #20: testsshagent .....................   Passed    1.65 sec
      Start 21: testentry
21/41 Test #21: testentry ........................   Passed    0.04 sec
      Start 22: testmerge
22/41 Test #22: testmerge ........................   Passed    0.30 sec
      Start 23: testpasswordgenerator
23/41 Test #23: testpasswordgenerator ............   Passed    0.06 sec
      Start 24: testpasswordhealth
24/41 Test #24: testpasswordhealth ...............   Passed    0.03 sec
      Start 25: testpassphrasegenerator
25/41 Test #25: testpassphrasegenerator ..........   Passed    0.11 sec
      Start 26: testhibp
26/41 Test #26: testhibp .........................   Passed    0.03 sec
      Start 27: testtotp
27/41 Test #27: testtotp .........................   Passed    0.03 sec
      Start 28: testbase32
28/41 Test #28: testbase32 .......................   Passed    0.02 sec
      Start 29: testcsvparser
29/41 Test #29: testcsvparser ....................   Passed    0.02 sec
      Start 30: testrandomgenerator
30/41 Test #30: testrandomgenerator ..............   Passed    0.02 sec
      Start 31: testentrysearcher
31/41 Test #31: testentrysearcher ................   Passed    0.03 sec
      Start 32: testcsvexporter
32/41 Test #32: testcsvexporter ..................   Passed    0.04 sec
      Start 33: testykchallengeresponsekey
33/41 Test #33: testykchallengeresponsekey .......   Passed    0.10 sec
      Start 34: testsharing
34/41 Test #34: testsharing ......................   Passed    1.02 sec
      Start 35: testdatabase
35/41 Test #35: testdatabase .....................   Passed    5.19 sec
      Start 36: testtools
36/41 Test #36: testtools ........................   Passed    0.05 sec
      Start 37: testconfig
37/41 Test #37: testconfig .......................   Passed    0.15 sec
      Start 38: testfdosecrets
38/41 Test #38: testfdosecrets ...................   Passed    0.06 sec
      Start 39: testbrowser
39/41 Test #39: testbrowser ......................   Passed    0.18 sec
      Start 40: testpasskeys
40/41 Test #40: testpasskeys .....................***Failed    0.20 sec
      Start 41: testurltools
41/41 Test #41: testurltools .....................   Passed    0.03 sec

98% tests passed, 1 tests failed out of 41

Total Test time (real) = 354.96 sec

The following tests FAILED:
	 40 - testpasskeys (Failed)
Errors while running CTest
Output from these tests are in: /var/tmp/portage/app-admin/keepassxc-2.7.9/work/keepassxc-2.7.9_build/Testing/Temporary/LastTest.log
Use \"--rerun-failed --output-on-failure\" to re-run the failed cases verbosely.
"
