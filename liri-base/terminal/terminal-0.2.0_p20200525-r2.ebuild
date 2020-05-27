# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Terminal - A Material Design terminal"
HOMEPAGE="https://github.com/lirios/terminal"
LICENSE="LGPL-3+ MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.10
IUSE=""
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5
	>=dev-qt/qtnetwork-${QT_MIN_PV}:5
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5
	>=liri-base/fluid-1.1.0
	>=liri-base/qtgsettings-1.1.0"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils xdg
EGIT_COMMIT="e1cfcc35585acb322d7f0a5c0c2cbb107f0690aa"
SRC_URI=\
"https://github.com/lirios/terminal/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTNETWORK_PV} ; then
		die "Qt5Core is not the same version as Qt5Network"
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
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
