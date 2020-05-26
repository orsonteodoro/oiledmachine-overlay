# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="XWayland support for QtQuick Wayland compositors like Liri Shell"
HOMEPAGE="https://github.com/lirios/qml-xwayland"
LICENSE="LGPL-3+ MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.9
IUSE=""
RDEPEND="${RDEPEND}
	  dev-libs/wayland
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5[egl,udev]
	>=dev-qt/qtwayland-${QT_MIN_PV}:5
	  x11-libs/libXcursor
	  x11-libs/xcb-util-cursor"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils
EGIT_COMMIT="3d6335b5d3efbb8e381f65a08b92da3e6c89aeab"
SRC_URI=\
"https://github.com/lirios/qml-xwayland/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient (qtwayland)"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
