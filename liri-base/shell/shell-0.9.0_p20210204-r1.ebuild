# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="QtQuick and Wayland shell for convergence"
HOMEPAGE="https://github.com/lirios/shell"
LICENSE="GPL-3+ LGPL-3+"

# Live/snapshot do not get KEYWORDs.

SLOT="0/${PV}"
IUSE+=" systemd"
QT_MIN_PV=5.15
DEPEND+=" >=dev-qt/qtconcurrent-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsql-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	  kde-frameworks/solid
	  liri-base/eglfs
	>=liri-base/fluid-1.0.0
	  liri-base/libliri
	>=liri-base/qtaccountsservice-1.3.0
	>=liri-base/qtgsettings-1.1.0
	  liri-base/wayland
	  media-fonts/droid
	  media-fonts/noto
	  sys-auth/polkit-qt
	  sys-libs/pam
	systemd? ( sys-apps/systemd )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" || (
		  sys-devel/clang
		>=sys-devel/gcc-4.8
	)
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	  virtual/pkgconfig
	>=liri-base/cmake-shared-1.0.0"
EGIT_COMMIT="ded359509328211e74346cdbfc6d67470b0fd872"
SRC_URI="
https://github.com/lirios/shell/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCONCURRENT_PV=$(pkg-config --modversion Qt5Concurrent)
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTSQL_PV=$(pkg-config --modversion Qt5Sql)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTCONCURRENT_PV} ; then
		die "Qt5Core is not the same version as Qt5Concurrent"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSQL_PV} ; then
		die "Qt5Core is not the same version as Qt5Sql"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt5Core is not the same version as Qt5Svg"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient (qtwayland)"
	fi
	einfo \
"If you emerged ${PN} directly, please start from the liri-meta package instead."
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
		-DLIRI_ENABLE_SYSTEMD=$(usex systemd)
	)
	if use systemd ; then
		mycmakeargs+=( -DINSTALL_SYSTEMDUSERUNITDIR=/usr/lib/systemd/user )
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	# https://github.com/lirios/shell/issues/63
	glib-compile-schemas /usr/share/glib-2.0/schemas
	xdg_pkg_postinst
	ewarn \
"\n"\
"If you have installed the Pro OpenGL drivers from the AMDGPU-PRO package, \n"\
"please switch to the Mesa GL driver instead.\n"\
"\n"\
"Failure to do so can cause the following:\n"\
"  -The cursor and wallpaper will not show properly if you ran\n"\
"   \`liri-session -- -platform xcb\`.\n"\
"  -The -platform eglfs mode may not work at all.\n"\
"\n"
	ewarn
	einfo \
"To run Liri in X run:\n"\
"  liri-session -- -platform xcb\n"\
"\n"\
"To run Liri in KMS from a VT run:\n"\
"  liri-session -- -platform eglfs\n"\
"\n"
}
