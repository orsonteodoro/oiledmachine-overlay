# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Session manager"
HOMEPAGE="https://github.com/lirios/session"
LICENSE="GPL-3+ LGPL-3+"

# Live/snapshots do not get KEYWORDed.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
eglfs systemd X

r1
"
REQUIRED_USE="
|| ( eglfs X )
"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[eglfs?,X?]
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	systemd? (
		sys-apps/systemd
	)
	~liri-base/libliri-0.9.0_p9999
	~liri-base/qtgsettings-1.3.0_p9999
"
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
DESKTOP_DATABASE_DIR="/usr/share/wayland-sessions"
PATCHES=( "${FILESDIR}/${PN}-0.1.0_p20200524-missing-variable.patch" )

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
	fi
einfo
einfo "If you emerged ${PN} directly, please start from the liri-meta package"
einfo "instead."
einfo
}

src_prepare() {
	cmake_src_prepare # patching deferred
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
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
ewarn
ewarn "Please switch to the Mesa GL driver.  Do not use the proprietary driver."
ewarn
ewarn "Failure to do so can cause the following:"
ewarn
ewarn "  -The cursor and wallpaper will not show properly if you ran"
ewarn "   \`liri-session -- -platform xcb\`"
ewarn "  -The -platform eglfs mode may not work at all."
ewarn
	if use X ; then
einfo
einfo "To run a Liri session in X do:"
einfo "  startx"
einfo "  open terminal program"
einfo "  liri-session"
einfo
ewarn "liri-session will not work with .xinitrc."
einfo
	fi
	if use eglfs ; then
einfo
einfo "To run a Liri session in EGL fullscreen do:"
einfo
einfo "  liri-session -- -platform eglfs"
einfo
	fi
einfo
einfo "To run a Liri session in Wayland with Weston do:"
einfo
einfo "  emerge -1vuDN weston[desktop,drm,fullscreen,gles2,seatd]"
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  weston --shell=fullscreen-shell.so"
einfo "  open terminal program"
einfo "  QT_WAYLAND_SHELL_INTEGRATION=fullscreen-shell liri-session -- -platform wayland"
einfo
einfo
einfo "To run a Liri session in Wayland with wlroots + dwl do:"
einfo
einfo "  dwl -s \"liri-session -- -platform wayland\""
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
