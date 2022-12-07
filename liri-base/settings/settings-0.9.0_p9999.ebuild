# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Settings application and modules for Liri OS"
HOMEPAGE="https://github.com/lirios/settings"
LICENSE="GPL-3+"

# Live/snapshots do not get KEYWORDs.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
+gif +jpeg +png

r5
"
QT_MIN_PV=5.10
# The documentation on the readme is lagging.  See \
# https://github.com/lirios/lirios/blob/develop/config/_dependencies.cmake
DEPEND+="
	>=dev-qt/qtconcurrent-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[jpeg?,png?]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=[widgets]
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	sys-auth/polkit
	virtual/libcrypt:=
	x11-misc/xkeyboard-config
	gif? (
		>=dev-qt/qtgui-${QT_MIN_PV}:5=[gif(+),jpeg?,png?]
	)
	~liri-base/aurora-client-0.0.0_p9999
	~liri-base/fluid-1.2.0_p9999
	~liri-base/libliri-0.9.0_p9999
	~liri-base/qtaccountsservice-1.3.0_p9999
	~liri-base/qtgsettings-1.3.0_p9999
"
# gif dropped in qtgui-5.15.7 ebuild but picked up in qtbase
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.0_p9999-disable-appearance.patch"
)

pkg_setup() {
	QTCONCURRENT_PV=$(pkg-config --modversion Qt5Concurrent)
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWIDGETS_PV=$(pkg-config --modversion Qt5Widgets)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTCONCURRENT_PV} ; then
		die "Qt5Core is not the same version as Qt5Concurrent"
	fi
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
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
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

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

# UserPage.qml
# The qstring.clear() does not fill the memory array with random/null data.
# See qstring.h implementation at https://github.com/qt/qtbase/blob/5.15/src/corelib/text/qstring.h#L1092
# See CWE-256
security_notice() {
ewarn
ewarn "Security notice"
ewarn
ewarn "The passwords in the \"Your account\" section may not properly get"
ewarn "sanitized when changing passwords."
ewarn
ewarn
ewarn "Mitigation"
ewarn
ewarn "Do not use the facilities used by this program but the ones"
ewarn "provided by the operating system."
ewarn
}

pkg_postinst() {
	xdg_pkg_postinst
	security_notice
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
