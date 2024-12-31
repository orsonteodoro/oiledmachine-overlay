# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20, U22

# For deps, see
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/.CI/CreateUbuntuDeb.sh
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/.github/workflows/build.yml#L204
# https://github.com/Chatterino/chatterino2/blob/v2.4.6/BUILDING_ON_LINUX.md
# Deps based on U 20.04 + CI override

CHECKREQS_DISK_BUILD="483M"
CHECKREQS_DISK_USR="33M"
CXXSTD="20"
GOOGLETEST_COMMIT_1="8d51dc50eb7e7698427fed81b85edad0e032112e"
GOOGLETEST_COMMIT_2="ba96d0b1161f540656efdaed035b3c062b60e006"
GOOGLETEST_COMMIT_3="9dce5e5d878176dc0054ef381f5c6e705f43ef99"
GOOGLETEST_COMMIT_4="ffc477e705589a697b062c366480d80fe6124e9b"
GOOGLETEST_COMMIT_5="e8512bc38c4c0060858c3306b0660a3f126aee30"
MAGIC_ENUM_COMMIT="e55b9b54d5cf61f8e117cafb17846d7d742dd3b4"
MINIAUDIO_COMMIT="4a5b74bef029b3592c54b6048650ee5f972c1a48"
LIBCOMMUNI_COMMIT="030710ad53dda1541601ccabbad36a12a9e90c78"
QT5_PV="5.12.12" # Based on CI
QT6_PV="6.2.4" # Based on CI
QTKEYCHAIN_COMMIT="e5b070831cf1ea3cb98c95f97fcb7439f8d79bd6"
RAPIDJSON_COMMIT="d87b698d0fcc10a5f632ecbc80a9cb2a8fa094a5"
SERIALIZE_COMMIT_1="17946d65a41a72b447da37df6e314cded9650c32"
SETTINGS_COMMIT="70fbc7236aa8bcf5db4748e7f56dad132d6fd402"
SIGNALS_COMMIT="d06770649a7e83db780865d09c313a876bf0f4eb"
WEBSOCKETPP_COMMIT="b9aeec6eaf3d5610503439b4fae3581d9aff08e8"
WINTOAST_COMMIT="821c4818ade1aa4da56ac753285c159ce26fd597"

inherit check-reqs cmake dep-prepare toolchain-funcs xdg-utils

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Chatterino/chatterino2.git"
	FALLBACK_COMMIT="eafcb941f57011358d63c76de6bee38ca1ba97ec"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/Chatterino/chatterino2/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/Chatterino/libcommuni/archive/${LIBCOMMUNI_COMMIT}.tar.gz
	-> Chatterino-libcommuni-${LIBCOMMUNI_COMMIT:0:7}.tar.gz
https://github.com/Chatterino/qtkeychain/archive/${QTKEYCHAIN_COMMIT}.tar.gz
	-> Chatterino-qtkeychain-${QTKEYCHAIN_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_4}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_4:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_5}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_5:0:7}.tar.gz
https://github.com/mackron/miniaudio/archive/${MINIAUDIO_COMMIT}.tar.gz
	-> miniaudio-${MINIAUDIO_COMMIT:0:7}.tar.gz
https://github.com/mohabouje/WinToast/archive/${WINTOAST_COMMIT}.tar.gz
	-> WinToast-${WINTOAST_COMMIT:0:7}.tar.gz
https://github.com/Neargye/magic_enum/archive/${MAGIC_ENUM_COMMIT}.tar.gz
	-> magic_enum-${MAGIC_ENUM_COMMIT:0:7}.tar.gz
https://github.com/pajlada/serialize/archive/${SERIALIZE_COMMIT_1}.tar.gz
	-> pajlada-serialize-${SERIALIZE_COMMIT_1:0:7}.tar.gz
https://github.com/pajlada/settings/archive/${SETTINGS_COMMIT}.tar.gz
	-> pajlada-settings-${SETTINGS_COMMIT:0:7}.tar.gz
https://github.com/pajlada/signals/archive/${SIGNALS_COMMIT}.tar.gz
	-> pajlada-signals-${SIGNALS_COMMIT:0:7}.tar.gz
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
https://github.com/zaphoyd/websocketpp/archive/${WEBSOCKETPP_COMMIT}.tar.gz
	-> websocketpp-${WEBSOCKETPP_COMMIT:0:7}.tar.gz
	"
fi

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
-benchmarks -coverage -crashpad firejail -lto -plugins -system-libcommuni
-system-miniaudio -system-qtkeychain -test +qt5 -qt6 +qtkeychain +update-check
wayland X

ebuild_revision_4
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
# Upstream uses a live version for qtkeychain but downgraded in this ebuild with
# the system-qtkeychain USE flag to test if it works.
# qtwayland needs opengl
RDEPEND="
	>=dev-libs/openssl-1.1.1f:=
	benchmarks? (
		>=dev-cpp/benchmark-1.5.0
	)
	system-miniaudio? (
		>=dev-libs/miniaudio-0.11.21
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
		>=dev-qt/qtmultimedia-${QT6_PV}:6[X?]
		>=dev-qt/qtsvg-${QT6_PV}:6
		wayland? (
			>=dev-qt/qtbase-${QT6_PV}:6[opengl]
			>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
			>=dev-qt/qtmultimedia-${QT6_PV}:6[opengl]
			>=dev-qt/qtquick3d-${QT6_PV}:6[opengl]
			>=dev-qt/qtwayland-${QT6_PV}:6
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
	>=dev-build/cmake-3.16.3
	>=sys-devel/gcc-9.4.0
	virtual/pkgconfig
"
PDEPEND="
	firejail? (
		sys-apps/firejail[firejail_profiles_chatterino,X?]
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
	QTPKG_PV=$(best_version "dev-qt/qtimageformats:${QT_SLOT}" \
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
	export CPP=$(tc-getCPP)
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
	if [[ "${PV}" =~ "9999" ]] ; then
		# The repos have nested dependencies.  Using tarballs on GH doesn't
	        # usually pick them up.
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
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/lib/googletest"
		dep_prepare_mv "${WORKDIR}/libcommuni-${LIBCOMMUNI_COMMIT}" "${S}/lib/libcommuni"
		dep_prepare_mv "${WORKDIR}/magic_enum-${MAGIC_ENUM_COMMIT}" "${S}/lib/magic_enum"
		dep_prepare_mv "${WORKDIR}/miniaudio-${MINIAUDIO_COMMIT}" "${S}/lib/miniaudio"
		dep_prepare_mv "${WORKDIR}/qtkeychain-${QTKEYCHAIN_COMMIT}" "${S}/lib/qtkeychain"
		dep_prepare_mv "${WORKDIR}/WinToast-${WINTOAST_COMMIT}" "${S}/lib/WinToast"

		dep_prepare_mv "${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}" "${S}/rapidjson"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_2}" "${S}/lib/rapidjson/thirdparty/gtest"

		dep_prepare_cp "${WORKDIR}/serialize-${SERIALIZE_COMMIT_1}" "${S}/lib/serialize"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/lib/serialize/external/googletest"

		dep_prepare_mv "${WORKDIR}/pajlada-settings-${SETTINGS_COMMIT}" "${S}/lib/settings"
		dep_prepare_cp "${WORKDIR}/signals-${SIGNALS_COMMIT}" "${S}/lib/settings/external/signals"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_5}" "${S}/lib/settings/external/signals/external/googletest"
		dep_prepare_cp "${WORKDIR}/serialize-${SERIALIZE_COMMIT_1}" "${S}/lib/settings/external/serialize"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}" "${S}/lib/settings/external/googletest"

		dep_prepare_cp "${WORKDIR}/signals-${SIGNALS_COMMIT}" "${S}/lib/signals"
		dep_prepare_mv "${WORKDIR}/websocketpp-${WEBSOCKETPP_COMMIT}" "${S}/lib/websocketpp"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCHATTERINO_LTO=$(usex lto "ON" "OFF")
		-DCHATTERINO_GENERATE_COVERAGE=$(usex coverage "ON" "OFF")
		-DCHATTERINO_PLUGINS=$(usex plugins "ON" "OFF")
		-DCHATTERINO_UPDATER=$(usex update-check "ON" "OFF")
		-DBUILD_BENCHMARKS=$(usex benchmarks "ON" "OFF")
		-DBUILD_TESTS=$(usex test "ON" "OFF")
		-DBUILD_TRANSLATIONS=OFF # A design choice by project to always turn it off for qtkeychain.
		-DBUILD_WITH_CRASHPAD=$(usex crashpad "ON" "OFF")
		-DBUILD_WITH_QT6=$(usex qt6 "ON" "OFF")
		-DBUILD_WITH_QTKEYCHAIN=$(usex qtkeychain "ON" "OFF")
		-DUSE_SYSTEM_LIBCOMMUNI=$(usex system-libcommuni "ON" "OFF")
		-DUSE_SYSTEM_MINIAUDIO=$(usex system-miniaudio "ON" "OFF")
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
