# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Wayland client and server extensions "
HOMEPAGE="https://github.com/lirios/wayland"
LICENSE="LGPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="test"
QT_MIN_PV=5.12
RDEPEND="${RDEPEND}
	>=dev-libs/wayland-1.15
	>=dev-libs/wayland-protocols-1.15
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5="
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.1.0_p20200511
	test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
inherit cmake-utils eutils
EGIT_COMMIT="d29a5e0b6cb47c0e60475f8d05e9e02a16ddd3f2"
SRC_URI=\
"https://github.com/lirios/wayland/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if use test ; then
		QTTEST_PV=$(pkg-config --modversion Qt5Test)
		if ver_test ${QTCORE_PV} -ne ${QTTEST_PV} ; then
			die "Qt5Core is not the same version as Qt5Test"
		fi
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient (qtwayland)"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
		-DLIB_INSTALL_DIR=$(get_libdir)
	)
	cmake-utils_src_configure
}
