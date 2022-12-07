# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Library for QtQuick apps with Material Design"
HOMEPAGE="https://liri.io/docs/sdk/fluid/develop/"
LICENSE="
	BSD MPL-2.0 FDL-1.3+
	Apache-2.0
"
# Apache-2.0 - src/imports/controls/icons

# live ebuilds do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
-embed-icons doc -qtquick-compiler test +update-icons

r3
"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[wayland]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	doc? ( >=dev-qt/qdoc-${QT_MIN_PV}:5= )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	test? (
		>=dev-qt/qttest-${QT_MIN_PV}:5=
	)
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
EGIT_OVERRIDE_REPO_LIRIOS_CMAKE_SHARED="https://github.com/lirios/cmake-shared.git"
EGIT_OVERRIDE_REPO_LIRIOS_QBS_SHARED="https://github.com/lirios/qbs-shared.git"
EGIT_OVERRIDE_COMMIT_LIRIOS_CMAKE_SHARED="HEAD"
EGIT_OVERRIDE_COMMIT_LIRIOS_QBS_SHARED="HEAD"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/fluid-1.2.0_p9999-aurora.patch"
	"${FILESDIR}/fluid-1.2.0_p9999-fetch-icons-disable-git.patch"
	"${FILESDIR}/fluid-1.2.0_p9999-fix-wifi-protected-bars.patch"
)

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
	if use update-icons ; then
		EGIT_REPO_URI="https://github.com/google/material-design-icons.git"
		EGIT_CHECKOUT_DIR="${S}/material-design-icons"
		EGIT_BRANCH="master"
		git-r3_fetch
		git-r3_checkout
	fi
}

src_prepare() {
	cmake_src_prepare
	if use update-icons ; then
		[[ -e material-design-icons/src/action/123/materialicons/20px.svg ]] \
			|| die "Directory layout changed."
		scripts/fetch_icons.sh || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DFLUID_WITH_DOCUMENTATION=$(usex doc)
		-DFLUID_WITH_DEMO=OFF
		-DFLUID_ENABLE_QTQUICK_COMPILER=$(usex qtquick-compiler)
		-DFLUID_INSTALL_ICONS=$(usex embed-icons OFF ON)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

pkg_postinst() {
	if ! use update-icons ; then
ewarn
ewarn "To fix the missing WIFI protected bars, use the update-icons USE flag."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
