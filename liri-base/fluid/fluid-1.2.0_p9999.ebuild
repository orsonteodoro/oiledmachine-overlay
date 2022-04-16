# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="Library for QtQuick apps with Material Design"
HOMEPAGE="https://liri.io/docs/sdk/fluid/develop/"
LICENSE="BSD MPL-2.0 FDL-1.3+"

# live ebuilds do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+=" doc test"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-libs/wayland-1.15
	>=dev-qt/qdoc-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	 ~liri-base/qtaccountsservice-1.3.0_p9999"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	>=kde-frameworks/extra-cmake-modules-1.7.0
	 ~liri-base/cmake-shared-2.0.0_p9999
	  virtual/pkgconfig
	  test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
EGIT_OVERRIDE_REPO_LIRIOS_QBS_SHARED="https://github.com/lirios/qbs-shared.git"
EGIT_OVERRIDE_REPO_LIRIOS_CMAKE_SHARED="https://github.com/lirios/cmake-shared.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt5Core is not the same version as Qt5Svg"
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
		-DBUILD_TESTING=$(usex test)
		-DFLUID_WITH_DOCUMENTATION=$(usex doc)
		-DFLUID_WITH_DEMO=OFF
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
