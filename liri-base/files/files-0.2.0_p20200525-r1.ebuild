# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Files - File manager"
HOMEPAGE="https://github.com/lirios/files"
LICENSE="LGPL-3+ GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.10
IUSE="taglib"
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5
	>=dev-qt/qttest-${QT_MIN_PV}:5
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5
	>=liri-base/fluid-1.1.0
	taglib? ( media-libs/taglib )"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils
EGIT_COMMIT="48a76e7e5165c9958b5b649d4fb3da28026006f6"
SRC_URI=\
"https://github.com/lirios/files/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTTEST_PV=$(pkg-config --modversion Qt5Test)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTTEST_PV} ; then
		die "Qt5Core is not the same version as Qt5Test"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DFILES_ENABLE_TAGLIB:BOOL=$(usex taglib "TRUE" "FALSE")
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
