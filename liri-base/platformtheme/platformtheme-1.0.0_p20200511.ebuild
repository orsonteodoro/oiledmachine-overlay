# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Qt platform theme plugin for apps integration with Liri"
HOMEPAGE="https://github.com/lirios/platformtheme"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE=""
QT_MIN_PV=5.8
RDEPEND="${RDEPEND}
	  dev-libs/glib
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	>=liri-base/qtgsettings-1.3.0_p20200312"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.1.0"
inherit cmake-utils eutils
EGIT_COMMIT="c95b9b16db022c00e2a650df285d43a0e088e401"
SRC_URI=\
"https://github.com/lirios/platformtheme/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
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
