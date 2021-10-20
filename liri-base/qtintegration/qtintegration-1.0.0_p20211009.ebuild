# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="Client-side decoration for all Qt-based Wayland clients"
HOMEPAGE="https://github.com/lirios/materialdecoration"
LICENSE="GPL-3+ LGPL-3+"

# Live/snapshot ebuild do not get KEYWORDed

SLOT="0/${PV}"
QT_MIN_PV=5.15
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	 >=dev-qt/qtgui-${QT_MIN_PV}:5=
	 >=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	 >=dev-qt/qtwayland-${QT_MIN_PV}:5=
	 >=liri-base/qtgsettings-1.1.0
	   liri-base/wayland
	   x11-libs/libxkbcommon"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	   virtual/pkgconfig
	 >=liri-base/cmake-shared-2.0.0:0/2.0.0"
EGIT_COMMIT="afb973e2f106d49f1746f614b021cf9f4c913c70"
SRC_URI="
https://github.com/lirios/qtintegration/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient (qtwayland)"
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

pkg_postinst() {
	xdg_pkg_postinst
	einfo "The environmental variable QT_WAYLAND_DISABLE_WINDOWDECORATION must be unset"
	einfo "Set QT_WAYLAND_DECORATION=material before loading liri-session"
}
