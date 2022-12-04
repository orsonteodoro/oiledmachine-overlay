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
eglfs systemd wayland X

r1
"
REQUIRED_USE="
|| ( eglfs wayland X )
"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[eglfs?,wayland?,X?]
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	eglfs? (
		~liri-base/aurora-compositor-0.0.0_p9999[qpa]
	)
	systemd? (
		sys-apps/systemd
	)
	|| (
		x11-themes/paper-icon-theme
		x11-themes/xcursor-themes
		x11-themes/adwaita-icon-theme
		x11-themes/blueglass-xcursors
		x11-themes/chameleon-xcursors
		x11-themes/comix-xcursors
		x11-themes/gentoo-xcursors
		x11-themes/golden-xcursors
		x11-themes/haematite-xcursors
		x11-themes/neutral-xcursors
		x11-themes/obsidian-xcursors
		x11-themes/pearlgrey-xcursors
		x11-themes/silver-xcursors
		x11-themes/vanilla-dmz-aa-xcursors
		x11-themes/vanilla-dmz-xcursors
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

# For eglfs, xwayland
change_cursor_theme() {
einfo
einfo "LIRI_SESSION_CURSOR_THEME can be set to change the cursor theme."
einfo "See metadata.xml or \`epkginfo ${CATEGORY}/${PN}\` for details."
einfo
	if [[ -n "${LIRI_SESSION_CURSOR_THEME}" ]] ; then
einfo
einfo "Switching to the ${LIRI_SESSION_CURSOR_THEME} cursor theme"
einfo
		sed -i -e "s|Paper|${LIRI_SESSION_CURSOR_THEME}|g" \
			src/manager/main.cpp || die
	elif has_version "x11-themes/paper-icon-theme" ; then
einfo
einfo "Switching to the Paper cursor theme" # Upstream default
einfo
	else
		local cursor_theme
		cursor_theme=$(\
			ls -1 "${ESYSROOT}/usr/share/cursors/" \
			| head -n 1)
		[[ -z "${cursor_theme}" ]] && \
		cursor_theme=$(\
			find "${ESYSROOT}/usr/share/icons/"*"/cursors" \
				-type d \
			| head -n 1 \
			| sed -e "s|/cursors$||g" \
			      -e "s|${ESYSROOT}/usr/share/icons/||g")
		if [[ -n "${cursor_theme}" ]] ; then
			sed -i -e "s|Paper|${cursor_theme}|g" \
				src/manager/main.cpp || die
einfo
einfo "Switching to the ${cursor_theme} cursor theme"
einfo
		fi
	fi
}

src_configure() {
	change_cursor_theme
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
einfo
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
einfo "  sudo gpasswd -a <user> input"
einfo "  logoff and login"
einfo "  liri-session -- -platform eglfs"
einfo
	fi
	if use wayland ; then
einfo
einfo "To run a Liri session in Wayland with Weston do:"
einfo
einfo "  sudo emerge -1vuDN weston[desktop,drm,fullscreen,gles2,seatd]"
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  weston --shell=fullscreen-shell.so"
einfo "  open terminal program"
einfo "  QT_WAYLAND_SHELL_INTEGRATION=fullscreen-shell liri-session -- -platform wayland"
einfo
einfo
einfo "To run a Liri session in Wayland with dwl do:"
einfo
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  dwl -s \"liri-session -- -platform wayland\""
einfo
	fi
einfo
einfo "To change the default cursor theme do:"
einfo
einfo " ln -sf gentoo /usr/share/cursors/xorg-x11/default"
einfo " ln -sf /usr/share/icons/Paper /usr/share/cursors/xorg-x11/default"
einfo
einfo "(Cursor themes only work with X [via xcb] or with eglfs.)"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
