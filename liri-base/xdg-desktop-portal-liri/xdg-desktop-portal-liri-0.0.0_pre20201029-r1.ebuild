# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="A backend implementation of xdg-desktop-portal for Liri"
HOMEPAGE="https://github.com/lirios/xdg-desktop-portal-liri"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
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
	flatpak? ( sys-apps/flatpak )
	pipewire? ( media-video/pipewire
		    x11-libs/libdrm )
	sys-apps/xdg-desktop-portal
	systemd? ( sys-apps/systemd )
	  liri-base/libliri
	>=liri-base/qtaccountsservice-1.2.0
	>=liri-base/qtgsettings-1.3.0_p20200312
	  liri-base/wayland"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.1.0_p20200511"
EGIT_COMMIT="22ebac8f7f760071d7e1c4f39cf0707d5ab48929"
SRC_URI=\
"https://github.com/lirios/xdg-desktop-portal-liri/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

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
