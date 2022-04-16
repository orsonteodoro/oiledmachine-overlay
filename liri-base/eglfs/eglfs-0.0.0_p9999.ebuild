# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="EGL fullscreen platform plugin"
HOMEPAGE="https://github.com/lirios/eglfs"
LICENSE="LGPL-3+ GPL-3+"

# live ebuilds do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
QT_MIN_PV=5.9
DEPEND+=" dev-libs/libinput
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5[egl,udev]
	 ~liri-base/libliri-0.9.0_p9999
	 ~liri-base/qtudev-1.1.0_p9999
	  media-libs/fontconfig
	  media-libs/mesa[egl,gbm]
	  x11-libs/libdrm
	  x11-libs/libxkbcommon"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	 ~liri-base/cmake-shared-2.0.0_p9999
	  sys-kernel/linux-headers
	  virtual/pkgconfig"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
