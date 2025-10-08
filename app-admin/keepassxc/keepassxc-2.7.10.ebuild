# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_CASES="copy-paste-password credentials security-critical sensitive-data"
CFLAGS_HARDENED_VTABLE_VERIFY=0 # Retest
GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++17
	"gcc_slot_12_5" # Support -std=c++17
	"gcc_slot_13_4" # Support -std=c++17
	"gcc_slot_14_3" # Support -std=c++17
)
PSL_COMMIT="c38a2f8e8862ad65d91af25dee90002c61329953" # Jul 9, 2025
QT5_PV="5.2.0"
QT6_PV="6.6.1"
VIRTUALX_REQUIRED="manual"

inherit cflags-hardened cmake flag-o-matic libstdcxx-slot toolchain-funcs virtualx xdg

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
	#KEYWORDS="~amd64" # Test failure for 1 test
	if [[ "${PV}" == *"_beta"* ]] ; then
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
SRC_URI+="
	network? (
https://raw.githubusercontent.com/publicsuffix/list/${PSL_COMMIT}/public_suffix_list.dat -> public_suffix_list-${PSL_COMMIT:0:7}.dat
	)
"

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="
	https://keepassxc.org/
	https://github.com/keepassxreboot/keepassxc/
"
LICENSE="
	LGPL-2.1
	GPL-2
	GPL-3
	network? (
		MPL-2.0
	)
"
# MPL-2.0 - PSL
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="
autotype browser doc keeshare +network qt5 qt5compat qt6 test wayland X yubikey
ebuild_revision_31
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
	dev-libs/botan:3[${LIBSTDCXX_USEDEP}]
	dev-libs/botan:=
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
		>=dev-qt/qt5compat-${QT6_PV}:6[${LIBSTDCXX_USEDEP},gui]
		dev-qt/qt5compat:=
		>=dev-qt/qtbase-${QT6_PV}:6[${LIBSTDCXX_USEDEP},concurrent,dbus,gui,network,wayland?,X?]
		dev-qt/qtbase:=
		>=dev-qt/qtsvg-${QT6_PV}:6[${LIBSTDCXX_USEDEP}]
		dev-qt/qtsvg:=
		wayland? (
			>=dev-qt/qtwayland-${QT6_PV}:6[${LIBSTDCXX_USEDEP}]
			dev-qt/qtwayland:=
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
		>=dev-qt/qttools-${QT6_PV}:6[${LIBSTDCXX_USEDEP},linguist]
		dev-qt/qttools:=
		X? (
			virtual/pkgconfig
		)
	)
	test? (
		wayland? (
			x11-misc/xkeyboard-config
			|| (
				>=gui-libs/wlroots-0.15.1-r1[tinywl(-)]
				gui-wm/tinywl
			)
		)
		X? (
			${VIRTUALX_DEPEND}
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.7.9-tests.patch"
	"${FILESDIR}/${PN}-2.7.10-qt6-support-v2.patch"
	"${FILESDIR}/${PN}-2.7.10-entryattributesmodel.patch"
	"${FILESDIR}/${PN}-2.7.10-fix-testentrymodel-test.patch"
	"${FILESDIR}/${PN}-2.7.10-fix-testpasskeys.patch"
	"${FILESDIR}/${PN}-2.7.10-fix-getTopLevelDomainFromUrl.patch"
	"${FILESDIR}/${PN}-2.7.10-testsshagent-workaround.patch"
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
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	if ver_test $(gcc-major-version) -lt "13" ; then
ewarn "You must switch your gcc to 13 to avoid build time error(s)."
	fi
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
	if use network ; then
		cat "${DISTDIR}/public_suffix_list-${PSL_COMMIT:0:7}.dat" > "${T}/public_suffix_list.dat" || die
	fi
}

src_prepare() {
	if [[ "${PV}" != *"_beta"* ]] && [[ "${PV}" != *"9999" ]] && [[ ! -f ".version" ]] ; then
		printf '%s' "${PV}" > ".version" || die
	fi

	if use network ; then
		# For testing
		echo "blogspot.com.ar" >> "${T}/public_suffix_list.dat" || die "Failed to append blogspot.com.ar"
		echo "s3.amazonaws.com" >> "${T}/public_suffix_list.dat" || die "Failed to append s3.amazonaws.com"
		echo "org.ws" >> "${T}/public_suffix_list.dat" || die "Failed to append org.ws"
		echo "example.compute.amazonaws.com" >> "${T}/public_suffix_list.dat" || die "Failed to append example.compute.amazonaws.com"
	fi

	cmake_src_prepare
	chmod +x "tests/run_testsshagent.sh" || die
}

src_configure() {
	if use test ; then
		if eselect locale show | grep "en_US.utf8" ; then
			:
		else
eerror "Use \`eselect locale\` to change locale to en_US.utf8"
			die
		fi
	fi

	# https://github.com/keepassxreboot/keepassxc/issues/5801
	filter-lto
	replace-flags '-O*' '-O2'
	export MAKEOPTS="-j1"
	cflags-hardened_append

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
	if [[ "${PV}" == *"_beta"* ]] ; then
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
	export TEMP_DIR="${T}"
einfo "TEMP_DIR:  ${TEMP_DIR}"
	cd "${BUILD_DIR}" || die
	# To exclude a test:  ctest -E "<test name>"
	# To exclude multiple tests:  ctest -j 1 --test-load 4 -E "testkdbx3|testkdbx4"
	# To test one test:  ctest -R <test name>
	DISABLE_SLOW_TESTS=0

	if has_version "net-misc/openssh" ; then
		DISABLE_SSH_AGENT_TEST=0
	else
		DISABLE_SSH_AGENT_TEST=1
	fi
	if [[ -z "${SSH_AUTH_SOCK}" ]] ; then
		DISABLE_SSH_AGENT_TEST=1
	fi

	local excluded_tests
	if [[ "${DISABLE_SSH_AGENT_TEST}" == "1" ]] ; then
		excluded_tests="|testsshagent"
	fi
	if [[ "${DISABLE_SLOW_TESTS}" == "1" ]] ; then
		excluded_tests+="|testkdbx3|testkdbx4|testkeys"
	fi
	local extra_args=()
	if [[ -n "${excluded_tests}" ]] ; then
		extra_args+=(
			-E "${excluded_tests:1}"
		)
	fi
	if use X ; then
einfo "Running tests under X"
		virtx ctest -j 1 --test-load 4 ${extra_args[@]}
	fi
	if use wayland ; then
einfo "Running tests under Wayland"
		virtwl ctest -j 1 --test-load 4 ${extra_args[@]}
	fi
}

src_install() {
	cmake_src_install

	if use network ; then
		# The AI thinks that Qt6 PSL could be outdated.
		insinto "/usr/share/${PN}"
		doins "${T}/public_suffix_list.dat"

		# Allow for custom TLD for international users.
		echo "# Add your custom TLD domains with as a new line delimited list below" > "${T}/tld"
		echo -e "# Custom TLDs for KeePassXC\nblogspot.com.ar\ns3.amazonaws.com\norg.ws\nexample.compute.amazonaws.com" >> "${T}/tld"
		insinto "/etc/${PN}"
		doins "${T}/tld"
		fperms 0644 "/etc/${PN}/tld"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use network ; then
einfo
einfo "For custom Top Level Domains (TLDs), it is acceptable to place them in"
einfo "~/.config/${PN}/tld, but the permission needs to be 0600."
einfo
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

__TEST_RESULTS="
Test project /var/tmp/portage/app-admin/keepassxc-2.7.10/work/keepassxc-2.7.10_build
      Start  1: testgroup
 1/40 Test  #1: testgroup ........................   Passed    0.05 sec
      Start  2: testkdbx2
 2/40 Test  #2: testkdbx2 ........................   Passed    0.38 sec
      Start  3: testkdbx3
 3/40 Test  #3: testkdbx3 ........................   Passed  108.30 sec
      Start  4: testkdbx4
 4/40 Test  #4: testkdbx4 ........................   Passed  160.76 sec
      Start  5: testkeys
 5/40 Test  #5: testkeys .........................   Passed  173.52 sec
      Start  6: testgroupmodel
 6/40 Test  #6: testgroupmodel ...................   Passed    0.04 sec
      Start  7: testentrymodel
 7/40 Test  #7: testentrymodel ...................   Passed    0.13 sec
      Start  8: testcryptohash
 8/40 Test  #8: testcryptohash ...................   Passed    0.02 sec
      Start  9: testsymmetriccipher
 9/40 Test  #9: testsymmetriccipher ..............   Passed    0.79 sec
      Start 10: testhashedblockstream
10/40 Test #10: testhashedblockstream ............   Passed    0.04 sec
      Start 11: testkeepass2randomstream
11/40 Test #11: testkeepass2randomstream .........   Passed    0.04 sec
      Start 12: testmodified
12/40 Test #12: testmodified .....................   Passed   22.89 sec
      Start 13: testdeletedobjects
13/40 Test #13: testdeletedobjects ...............   Passed    0.05 sec
      Start 14: testkeepass1reader
14/40 Test #14: testkeepass1reader ...............   Passed    8.34 sec
      Start 15: testimports
15/40 Test #15: testimports ......................   Passed   16.27 sec
      Start 16: testupdatecheck
16/40 Test #16: testupdatecheck ..................   Passed    0.04 sec
      Start 17: testicondownloader
17/40 Test #17: testicondownloader ...............   Passed    0.04 sec
      Start 18: testautotype
18/40 Test #18: testautotype .....................   Passed   12.21 sec
      Start 19: testopensshkey
19/40 Test #19: testopensshkey ...................   Passed   17.15 sec
      Start 20: testentry
20/40 Test #20: testentry ........................   Passed    0.05 sec
      Start 21: testmerge
21/40 Test #21: testmerge ........................   Passed    0.24 sec
      Start 22: testpasswordgenerator
22/40 Test #22: testpasswordgenerator ............   Passed    0.07 sec
      Start 23: testpasswordhealth
23/40 Test #23: testpasswordhealth ...............   Passed    0.04 sec
      Start 24: testpassphrasegenerator
24/40 Test #24: testpassphrasegenerator ..........   Passed    0.10 sec
      Start 25: testhibp
25/40 Test #25: testhibp .........................   Passed    0.04 sec
      Start 26: testtotp
26/40 Test #26: testtotp .........................   Passed    0.04 sec
      Start 27: testbase32
27/40 Test #27: testbase32 .......................   Passed    0.02 sec
      Start 28: testcsvparser
28/40 Test #28: testcsvparser ....................   Passed    0.02 sec
      Start 29: testrandomgenerator
29/40 Test #29: testrandomgenerator ..............   Passed    0.02 sec
      Start 30: testentrysearcher
30/40 Test #30: testentrysearcher ................   Passed    0.04 sec
      Start 31: testcsvexporter
31/40 Test #31: testcsvexporter ..................   Passed    0.04 sec
      Start 32: testykchallengeresponsekey
32/40 Test #32: testykchallengeresponsekey .......   Passed    0.05 sec
      Start 33: testsharing
33/40 Test #33: testsharing ......................   Passed    2.48 sec
      Start 34: testdatabase
34/40 Test #34: testdatabase .....................   Passed    8.85 sec
      Start 35: testtools
35/40 Test #35: testtools ........................   Passed    0.02 sec
      Start 36: testconfig
36/40 Test #36: testconfig .......................   Passed    0.06 sec
      Start 37: testfdosecrets
37/40 Test #37: testfdosecrets ...................   Passed    0.12 sec
      Start 38: testbrowser
38/40 Test #38: testbrowser ......................   Passed    0.15 sec
      Start 39: testpasskeys
39/40 Test #39: testpasskeys .....................   Passed    0.27 sec
      Start 40: testurltools
40/40 Test #40: testurltools .....................   Passed    0.04 sec

100% tests passed, 0 tests failed out of 40

Total Test time (real) = 574.93 sec
"
