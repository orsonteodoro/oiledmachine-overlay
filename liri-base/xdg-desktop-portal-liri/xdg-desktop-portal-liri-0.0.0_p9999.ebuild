# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="A backend implementation of xdg-desktop-portal for Liri"
HOMEPAGE="https://github.com/lirios/xdg-desktop-portal-liri"
LICENSE="GPL-3+"

# Live/snapshots do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+=" flatpak pipewire systemd"
QT_MIN_PV=5.10
DEPEND+=" dev-libs/glib
	>=dev-libs/wayland-1.15
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtprintsupport-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	 ~liri-base/libliri-0.9.0_p9999
	 ~liri-base/qtaccountsservice-1.3.0_p9999
	 ~liri-base/qtgsettings-1.3.0_p9999
	 ~liri-base/wayland-0.0.0_p9999
	flatpak? ( sys-apps/flatpak )
	pipewire? ( media-video/pipewire
		    x11-libs/libdrm )
	sys-apps/xdg-desktop-portal
	systemd? ( sys-apps/systemd )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	 ~liri-base/cmake-shared-2.0.0_p9999
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
	QTPRINTSUPPORT_PV=$(pkg-config --modversion Qt5PrintSupport)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTPRINTSUPPORT_PV} ; then
		die "Qt5Core is not the same version as Qt5PrintSupport"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
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
		-DCMAKE_EXE_LINKER_FLAGS="-lrt"
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
		-DLIRI_ENABLE_SYSTEMD=$(usex systemd)
	)
	cmake-utils_src_configure
}
