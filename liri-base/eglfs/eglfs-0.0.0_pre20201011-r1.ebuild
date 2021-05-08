# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="EGL fullscreen platform plugin"
HOMEPAGE="https://github.com/lirios/eglfs"
LICENSE="LGPL-3+ GPL-3+"

# live ebuilds do not get KEYWORDed

SLOT="0/${PV}"
QT_MIN_PV=5.9
DEPEND+=" dev-libs/libinput
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5[egl,udev]
	  liri-base/libliri
	  liri-base/qtudev
	  media-libs/fontconfig
	  media-libs/mesa[egl,gbm]
	  x11-libs/libdrm
	  x11-libs/libxkbcommon"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0
	sys-kernel/linux-headers"
EGIT_COMMIT="d55225b4edcfebabef3b2f2ff0f338ab31bad68a"
SRC_URI="
https://github.com/lirios/eglfs/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

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

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
