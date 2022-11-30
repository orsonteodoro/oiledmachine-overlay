# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Qt platform theme plugin for apps integration with Liri"
HOMEPAGE="https://github.com/lirios/qtintegration"
LICENSE="GPL-3+ LGPL-3+ ISC"

# Live/snapshot ebuild do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE="
+layer-shell-integration +lockscreen-integration +material-decoration
+platform-theme

r2
"
QT_MIN_PV=5.15
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[wayland]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	x11-libs/libxkbcommon
	platform-theme? (
		~liri-base/qtgsettings-1.3.0_p9999
	)
	layer-shell-integration? (
		~liri-base/aurora-client-0.0.0_p9999
	)
	lockscreen-integration? (
		~liri-base/aurora-client-0.0.0_p9999
	)
	~liri-base/libliri-0.9.0_p9999
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	~liri-base/aurora-scanner-0.0.0_p9999
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWAYLANDCLIENT_PV} ; then
		die "Qt5Core is not the same version as Qt5WaylandClient (qtwayland)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTWIDGETS_PV} ; then
		die "Qt5Core is not the same version as Qt5Widgets"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| cut -f 2 -d "\"")
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
		-DLIRI_QTINTEGRATION_ENABLE_LAYER_SHELL_INTEGRATION=$(usex shell-integration)
		-DLIRI_QTINTEGRATION_ENABLE_LOCKSCREEN_INTEGRATION=$(usex lockscreen-integration)
		-DLIRI_QTINTEGRATION_ENABLE_MATERIAL_DECORATION=$(usex material-decoration)
		-DLIRI_QTINTEGRATION_ENABLE_PLATFORMTHEME=$(usex platform-theme)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "The environmental variable QT_WAYLAND_DISABLE_WINDOWDECORATION must be unset"
	einfo "Set QT_WAYLAND_DECORATION=material before loading liri-session"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
