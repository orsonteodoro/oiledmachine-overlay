# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake-utils xdg

DESCRIPTION="Session manager"
HOMEPAGE="https://github.com/lirios/session"
LICENSE="GPL-3+ LGPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" systemd"
QT_MIN_PV=5.10
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	  liri-base/libliri
	>=liri-base/qtgsettings-1.1.0
	systemd? ( sys-apps/systemd )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0"
EGIT_COMMIT="bfae9be74ba57dc3e9c8467799e3b94a1ed3ae0d"
SRC_URI=\
"https://github.com/lirios/session/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DESKTOP_DATABASE_DIR="/usr/share/wayland-sessions"

_PATCHES=( "${FILESDIR}/${PN}-0.1.0_p20200524-missing-variable.patch" )

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	einfo \
"If you emerged ${PN} directly, please start from the liri-meta package instead."
}

src_prepare() {
	xdg_src_prepare # patching deferred
	cmake-utils_src_prepare # patching deferred
	eapply ${_PATCHES[@]}
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_SYSCONFDIR=/etc
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
		-DLIRI_ENABLE_SYSTEMD=$(usex systemd "ON" "OFF")
	)
	if use systemd ; then
		mycmakeargs+=(
			-DINSTALL_SYSTEMDUSERUNITDIR=/usr/lib/systemd/user
			-DINSTALL_SYSTEMDUSERGENERATORSDIR=/usr/lib/systemd/user-generators
		)
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	ewarn
	ewarn \
"If you have installed the Pro OpenGL drivers from the AMDGPU-PRO package, \n"\
"please switch to the Mesa GL driver instead.\n"\
"\n"\
"Failure to do so can cause the following:\n"\
"  -The cursor and wallpaper will not show properly if you ran\n"\
"   \`liri-session -- -platform xcb\`.\n"\
"  -The -platform eglfs mode may not work at all."
	ewarn
	einfo \
"To run Liri in X run:\n"\
"  liri-session -- -platform xcb\n"\
"\n"\
"To run Liri in KMS from a VT run:\n"\
"  liri-session -- -platform eglfs\n"\
"\n"
}
