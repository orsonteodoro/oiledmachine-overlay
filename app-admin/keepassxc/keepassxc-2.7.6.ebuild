# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

QT6_PV="6.6.1"
QT5_PV="5.2.0"

# Time to convert to Qt6
# start time: 1705819601
# end time:

# Progress: 139/313

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
		>=dev-qt/qtgui-${QT5_PV}:5
		>=dev-qt/qtnetwork-${QT5_PV}:5
		>=dev-qt/qtsvg-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qt5compat-${QT6_PV}:6
		>=dev-qt/qtbase-${QT6_PV}:6[concurrent,dbus,gui,network,wayland?,X?]
		>=dev-qt/qtsvg-${QT6_PV}:6
	)
	X? (
		qt5? (
			>=dev-qt/qtx11extras-${QT5_PV}:5
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
BDEPEND="
	doc? (
		dev-ruby/asciidoctor
	)
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
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
	elif [[ "${QT_SLOT}" == "5" ]] ; then
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

pkg_setup() {
	use qt5 && verify_qt_consistency 5
	use qt5 && verify_qt_consistency 6
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
	replace-flags -O* -O2

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
