# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils xdg

DESCRIPTION="Utility to capture the screen of a Liri desktop"
HOMEPAGE="https://github.com/lirios/screenshot"
LICENSE="GPL-3+"

# Live/snapshots do not get KEYWORDS.

SLOT="0/${PV}"
QT_MIN_PV=5.10
DEPEND+=" >=dev-db/sqlite-3.7.15
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	>=liri-base/fluid-1.0.0
	  liri-base/wayland"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=liri-base/cmake-shared-1.0.0"
EGIT_COMMIT="0b137881751d618d618895c8d9a0600b738056c0"
SRC_URI="
https://github.com/lirios/screenshot/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient"
	fi
}

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_EXE_LINKER_FLAGS="-lrt"
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
