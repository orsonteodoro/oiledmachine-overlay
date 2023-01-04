# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="This is the App Center for Liri OS for installing, updating, and \
managing applications built using Flatpak"
HOMEPAGE="https://github.com/lirios/appcenter"
LICENSE="GPL-3+"

# Live/snapshots do not get KEYWORDS.

SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
wayland X

r2
"
REQUIRED_USE+="
	|| (
		wayland
		X
	)
"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtconcurrent-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[wayland?,X?]
	>=dev-qt/qtnetwork-${QT_MIN_PV}:5=[ssl]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	acct-group/flatpak
	dev-libs/appstream[qt5]
	sys-apps/flatpak
	~liri-base/fluid-1.2.0_p9999
	~liri-base/libliri-0.9.0_p9999
	~liri-base/qtaccountsservice-1.3.0_p9999
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

pkg_setup() {
	QTCONCURRENT_PV=$(pkg-config --modversion Qt5Concurrent)
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTNETWORK_PV=$(pkg-config --modversion Qt5Network)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
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
	if ver_test ${QTCORE_PV} -ne ${QTNETWORK_PV} ; then
		die "Qt5Core is not the same version as Qt5Network"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
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
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	# Prevent startup exit
	mkdir -p "${EROOT}/var/lib/flatpak"
	chmod 0770 "${EROOT}/var/lib/flatpak"
	chown root:flatpak "${EROOT}/var/lib/flatpak"
	ewarn "The user must be in the flatpak group to use ${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
