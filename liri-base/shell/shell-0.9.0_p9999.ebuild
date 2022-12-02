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
+jpeg -qtquick-compiler systemd
+layer-shell-integration +lockscreen-integration

r2
"
# systemd is enabled by default upstream, but distro defaults to OpenRC.
QT_MIN_PV=5.15
DEPEND+="
	>=dev-qt/qtconcurrent-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[jpeg?,wayland]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsql-${QT_MIN_PV}:5=[sqlite]
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	>=dev-qt/qtwidgets-${QT_MIN_PV}:5=
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	kde-frameworks/solid
	media-fonts/droid
	media-fonts/noto
	sys-auth/polkit-qt
	sys-libs/pam
	systemd? ( sys-apps/systemd )
	~liri-base/aurora-client-0.0.0_p9999
	~liri-base/aurora-compositor-0.0.0_p9999
	~liri-base/fluid-1.2.0_p9999
	~liri-base/libliri-0.9.0_p9999
	~liri-base/qtaccountsservice-1.3.0_p9999
	~liri-base/qtgsettings-1.3.0_p9999
	~liri-base/qtintegration-1.0.0_p9999[layer-shell-integration?,lockscreen-integration?]
" # TODO: check liri-base/qtintegration USE flags for always required.
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	|| (
		sys-devel/clang
		>=sys-devel/gcc-4.8
	)
	~liri-base/aurora-scanner-0.0.0_p9999
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/shell-0.9.0_p9999-systemd-libs-optional.patch"
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

pkg_postinst() {
	# https://github.com/lirios/shell/issues/63
	glib-compile-schemas /usr/share/glib-2.0/schemas
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
einfo "  liri-session -- -platform eglfs"
einfo
einfo
einfo "To run a Liri session in Wayland with Weston:"
einfo
einfo "  emerge -1vuDN weston[desktop,drm,fullscreen,gles2,seatd]"
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  weston --shell=fullscreen-shell.so"
einfo "  open terminal program"
einfo "  QT_WAYLAND_SHELL_INTEGRATION=fullscreen-shell liri-session -- -platform wayland"
einfo
einfo
einfo "To run a Liri session in Wayland with wlroots + dwl:"
einfo
einfo "  dwl -s \"liri-session -- -platform wayland\""
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
