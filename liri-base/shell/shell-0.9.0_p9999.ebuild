# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="QtQuick and Wayland shell for convergence"
HOMEPAGE="https://github.com/lirios/shell"
LICENSE="GPL-3+ LGPL-3+ BSD"
# BSD - cmake/3rdparty/FindPAM.cmake

# Live/snapshot do not get KEYWORDs.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
aurora eglfs +jpeg -qtquick-compiler -lockscreen +png systemd

r4
"
# systemd is enabled by default upstream, but distro defaults to OpenRC.
QT_MIN_PV=5.15
QT_INTEGRATION_PV="1.0.0_p9999"
DEPEND+="
	!aurora? (
		~liri-base/qtudev-1.1.0_p9999
		~liri-base/wayland-0.0.0_p9999
		eglfs? (
			~liri-base/eglfs-0.0.0_p9999
		)
	)
	>=dev-qt/qtconcurrent-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[jpeg?,png?,wayland]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsql-${QT_MIN_PV}:5=[sqlite]
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=[png?]
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	kde-frameworks/solid
	media-fonts/droid
	media-fonts/noto
	sys-auth/polkit-qt
	sys-libs/pam
	x11-misc/xdg-utils
	aurora? (
		~liri-base/aurora-client-0.0.0_p9999
		~liri-base/aurora-compositor-0.0.0_p9999
	)
	systemd? ( sys-apps/systemd )
	|| (
		virtual/freedesktop-icon-theme
		x11-themes/paper-icon-theme
		x11-themes/papirus-icon-theme
	)
	~liri-base/fluid-1.2.0_p9999
	~liri-base/libliri-0.9.0_p9999
	~liri-base/qtaccountsservice-1.3.0_p9999
	~liri-base/qtgsettings-1.3.0_p9999
	~liri-base/qtintegration-${QT_INTEGRATION_PV}[aurora=,shell,lockscreen?]
" # TODO: check liri-base/qtintegration USE flags for always required.
# x11-misc/xdg-utils - for xdg-open
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	aurora? (
		~liri-base/aurora-scanner-0.0.0_p9999
	)
	|| (
		sys-devel/clang
		>=sys-devel/gcc-4.8
	)
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
AURORA_PATCHES=(
	"${FILESDIR}/${PN}-0.9.0_p9999-systemd-libs-optional.patch"
	"${FILESDIR}/${PN}-0.9.0_p9999-decorations.patch"
)
PATCHES=(
	"${FILESDIR}/${PN}-0.9.0_p9999-customize-date-time.patch"
	"${FILESDIR}/${PN}-0.9.0_p9999-fix-background-window-launch-settings.patch"
)

pkg_setup() {
	QTCONCURRENT_PV=$(pkg-config --modversion Qt5Concurrent)
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTSQL_PV=$(pkg-config --modversion Qt5Sql)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTWAYLANDCLIENT_PV=$(pkg-config --modversion Qt5WaylandClient)
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
	if ver_test ${QTCORE_PV} -ne ${QTSQL_PV} ; then
		die "Qt5Core is not the same version as Qt5Sql"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt5Core is not the same version as Qt5Svg"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
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
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
	fi
	einfo \
"If you emerged ${PN} directly, please start from the liri-meta package instead."
}

src_unpack() {
	if ! use aurora ; then
		EGIT_COMMIT="abc4e1a09862fb95990c7123dd4130bf5301a027"
	fi

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
	use aurora && eapply ${AURORA_PATCHES[@]}
}

change_default_icon_theme() {
einfo
einfo "Set LIRI_SHELL_DEFAULT_ICON_THEME to change the icon theme.  See"
einfo "metadata.xml or \`epkginfo -x ${CATEGORY}/${PN}\` for details."
einfo
	if [[ -n "${LIRI_SHELL_DEFAULT_ICON_THEME}" ]] ; then
einfo
einfo "Using the ${LIRI_SHELL_DEFAULT_ICON_THEME} icon theme as the default"
einfo
		sed -i -e "s|'Paper'|'${LIRI_SHELL_DEFAULT_ICON_THEME}'|g" \
			data/settings/io.liri.desktop.interface.gschema.xml \
			|| die
	elif has_version "x11-themes/paper-icon-theme" ; then
einfo
einfo "Using the Paper icon theme as the default" # Upstream default but EOL
einfo
	elif has_version "x11-themes/papirus-icon-theme" ; then
einfo
einfo "Using the Papirus icon theme as the default" # Similar look
einfo
		sed -i -e "s|'Paper'|'Papirus'|g" \
			data/settings/io.liri.desktop.interface.gschema.xml \
			|| die
	else
		local icon_theme=$(ls -1 "${ESYSROOT}/usr/share/icons" \
			| head -n 1)
		sed -i -e "s|'Paper'|'${icon_theme}'|g" \
			data/settings/io.liri.desktop.interface.gschema.xml \
			|| die
		einfo "Using the ${icon_theme} icon theme as the default"
	fi
}

change_pinned_launchers() {
einfo
einfo "Set LIRI_SHELL_PINNED_LAUNCHERS to set pinned launchers.  See"
einfo "metadata.xml or \`epkginfo -x ${CATEGORY}/${PN}\` for details."
einfo
	[[ -z "${LIRI_SHELL_PINNED_LAUNCHERS}" ]] && return
	if [[ "${LIRI_SHELL_PINNED_LAUNCHERS}" =~ "REMOVE_ALL" ]] ; then
einfo
einfo "Removing all pinned launchers"
einfo
		sed -i -e "s|'io.liri.Terminal', 'io.liri.Settings'||g" \
			data/settings/io.liri.desktop.panel.gschema.xml || die
	fi
	local L=($(echo ${LIRI_SHELL_PINNED_LAUNCHERS}))
	local L2=""
	local l
	for l in ${L[@]} ; do
		L2+=", '${l}'"
	done
	L3=$(echo -n "${L2}" | sed -e "s|^, ||g")
	sed -i -e "s|'io.liri.Terminal', 'io.liri.Settings'|${L3}|g" \
		data/settings/io.liri.desktop.panel.gschema.xml || die
einfo
einfo "Pinned launchers:  ${L3}"
einfo
}

change_date_time() {
einfo
einfo "See metadata.xml or \`epkginfo -x ${CATEGORY}/${PN}\` to change the date"
einfo "time format"
einfo
	if [[ -n "${LIRI_SHELL_DATE_TIME_FORMAT}" ]] ; then
		sed -i -e "s|__DATE_TIME_FORMAT__|, \"${LIRI_SHELL_DATE_TIME_FORMAT}\"|g" \
			src/plugins/statusarea/datetime/contents/main.qml || die
	else
		sed -i -e "s|__DATE_TIME_FORMAT__|, \"HH:mm:ss\"|g" \
			src/plugins/statusarea/datetime/contents/main.qml || die
	fi
}

src_configure() {
	change_default_icon_theme
	change_pinned_launchers
	change_date_time
	local mycmakeargs=(
		-DFEATURE_enable_systemd=$(usex systemd)
		-DFEATURE_shell_enable_qtquick_compiler=$(usex qtquick-compiler)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	if use systemd ; then
		mycmakeargs+=(
			-DINSTALL_SYSTEMDUSERUNITDIR=/usr/lib/systemd/user
		)
	fi
	cmake_src_configure
}

lock_screen_notice() {
# Found in the qmls (AuthDialog.qml, LockScreenWindow.qml),
# possibly in cpp files with password variable too ...
# The fluid library lacks a secure type for strings.
# 475b8ea commit also
ewarn
ewarn "Security notice"
ewarn
ewarn "Using password session locker may not properly sanitize the same memory"
ewarn "area containing a password with random data or between copies."
ewarn
ewarn "Mitigation"
ewarn
ewarn "Do no use facilities."
ewarn "Complete logoff or shutdown instead of lock screen."
ewarn
}

driver_notice() {
ewarn
ewarn "Please switch to the Mesa GL driver.  Do not use the proprietary driver."
ewarn
ewarn "Failure to do so can cause the following:"
ewarn
ewarn "  -The cursor and wallpaper will not show properly if you ran"
ewarn "   \`liri-session -- -platform xcb\`"
ewarn "  -The -platform eglfs mode may not work at all."
ewarn
}

session_start_notice() {
einfo
einfo "To run a Liri session in X do:"
einfo
einfo "  startx"
einfo "  open terminal program"
einfo "  liri-session"
einfo
ewarn "liri-session will not work with .xinitrc."
einfo
einfo
einfo "To run a Liri session in EGL fullscreen do:"
einfo
einfo "  sudo gpasswd -a <user> input"
einfo "  logoff and login"
einfo "  liri-session -- -platform eglfs"
einfo
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
}

customized_settings_notice() {
einfo
einfo "Per user customization"
einfo
einfo "To reset pinned launchers:"
einfo
einfo "  gsettings reset io.liri.desktop.panel pinned-launchers"
einfo
einfo "To add/remove pinned launchers:"
einfo
einfo "  gsettings set io.liri.desktop.panel pinned-launchers ['app1', 'app2', 'app3']"
einfo "  gsettings set io.liri.desktop.panel pinned-launchers ['app1']"
einfo "  (The same as /usr/share/applications but without the .desktop suffix.)"
einfo
einfo "To remove all pinned launchers:"
einfo
einfo "  gsettings set io.liri.desktop.panel pinned-launchers []"
einfo
einfo "To set icon theme:"
einfo
einfo "  gsettings set io.liri.desktop.interface icon-theme 'Paper'"
einfo "  (The same as /usr/share/icons.)"
einfo
}

pkg_postinst() {
	# https://github.com/lirios/shell/issues/63
	glib-compile-schemas /usr/share/glib-2.0/schemas

	driver_notice
	session_start_notice
	customized_settings_notice

	use lockscreen && lock_screen_notice
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
