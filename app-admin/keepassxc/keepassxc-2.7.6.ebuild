# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

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
IUSE="X autotype browser doc keeshare +network qt5 qt6 test wayland yubikey"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	autotype? (
		X
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
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[concurrent,dbus,gui,network,wayland?,X?]
		dev-qt/qtsvg:6
	)
	X? (
		qt5? (
			dev-qt/qtx11extras:5
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
		dev-qt/qttest:5
	)
"
BDEPEND="
	doc? (
		dev-ruby/asciidoctor
	)
	qt5? (
		dev-qt/linguist-tools:5
	)
	qt6? (
		dev-qt/qttools:6[linguist]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.7.4-tests.patch"
	"${FILESDIR}/${PN}-2.7.6-qt6-support.patch"
)

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
