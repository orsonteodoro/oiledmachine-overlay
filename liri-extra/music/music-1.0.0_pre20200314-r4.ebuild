# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils xdg

DESCRIPTION="A modern music app for modern people."
HOMEPAGE="https://github.com/lirios/music"
LICENSE="GPL-3+ BSD FDL-1.3+ MPL-2.0"
# FindTaglib.cmake is BSD
# fluid contains files with MPL-2.0 FDL-1.3+

# Live/snapshots do not get KEYWORDS.

SLOT="0/${PV}"
QT_MIN_PV=5.14
IUSE+=" doc +system-fluid test"

FLUID_DEPEND=" >=dev-libs/wayland-1.15
	>=dev-qt/qdoc-${QT_MIN_PV}:5=
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtwayland-${QT_MIN_PV}:5=
	  liri-base/qtaccountsservice"
FLUID_BDEPEND=" >=dev-util/cmake-3.10.0
	  virtual/pkgconfig
	>=kde-frameworks/extra-cmake-modules-1.7.0
	>=liri-base/cmake-shared-1.0.0:0/1.1.0
	test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtmultimedia-${QT_MIN_PV}:5=[qml]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtsql-${QT_MIN_PV}:5=
	media-libs/taglib:taglib2-preview
	 system-fluid? ( >=liri-base/fluid-1.2.0 )
	!system-fluid? ( ${FLUID_DEPEND} )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  virtual/pkgconfig
	  system-fluid? ( >=liri-base/cmake-shared-1.0.0:0/1.1.0 )
	 !system-fluid? ( ${FLUID_BDEPEND} )"
EGIT_COMMIT="626206c4b9f3cbd85dd5c5dc27dffb3d4098fb5d"
FLUID_COMMIT="a99dc04a067abeb9110664f5427e9a701e6744d4"
CMAKE_SHARED_COMMIT="4fdf2cb6edd23aaa467cfdbc758ee8ed15cbfc81"
QBS_SHARED_COMMIT="ebee5a8798ab0a063b56cf7c73be2a28ec353a2e"
SRC_URI="
https://github.com/lirios/music/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz
https://github.com/lirios/fluid/archive/${FLUID_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-fluid-${FLUID_COMMIT}.tar.gz
https://github.com/lirios/cmake-shared/archive/${CMAKE_SHARED_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-cmake-shared-${CMAKE_SHARED_COMMIT}.tar.gz
https://github.com/lirios/qbs-shared/archive/${QBS_SHARED_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-qbs-shared-${QBS_SHARED_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
_PATCHES=(
	"${FILESDIR}/music-1.0.0_pre20200314-reference-taglib2.patch"
	"${FILESDIR}/music-1.0.0_pre20200314-allow-system-fluid.patch"
	"${FILESDIR}/music-1.0.0_pre20200314-add-qtmultimedia-to-cmakelists.patch"
)

fluid_pkg_setup() {
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

qbs_check() {
	"${EROOT}/usr/bin/qbs" list-products 2>&1 \
		| grep -q -F -e "Cannot mix incompatible"
	if [[ "$?" == "0" ]] ; then
		die "Re-emerge dev-util/qbs"
	fi
}

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTMULTIMEDIA_PV=$(pkg-config --modversion Qt5Multimedia)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	QTSQL_PV=$(pkg-config --modversion Qt5Sql)
	QTSVG_PV=$(pkg-config --modversion Qt5Svg)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTMULTIMEDIA_PV} ; then
		die "Qt5Core is not the same version as Qt5Multimedia"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSQL_PV} ; then
		die "Qt5Core is not the same version as Qt5Sql"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTSVG_PV} ; then
		die "Qt5Core is not the same version as Qt5Svg"
	fi
	if ! use system-fluid ; then
		fluid_pkg_setup
	fi

	qbs_check
}

src_unpack() {
	unpack ${A}
	if ! use system-fluid ; then
		rm -rf "${S}/fluid" || die
		ln -s "${WORKDIR}/fluid-${FLUID_COMMIT}" "${S}/fluid" || die
		rm -rf "${S}/fluid/qbs/shared" || die
		rm -rf "${S}/fluid/cmake/shared" || die
		ln -s "${WORKDIR}/cmake-shared-${CMAKE_SHARED_COMMIT}" \
			"${S}/fluid/cmake/shared" || die
		ln -s "${WORKDIR}/qbs-shared-${QBS_SHARED_COMMIT}" \
			"${S}/fluid/qbs/shared" || die
	fi
}

src_prepare() {
	xdg_src_prepare
	export PATCHES=${_PATCHES[@]}
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)

	# from fluid ebuild
	mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DFLUID_WITH_DOCUMENTATION=$(usex doc)
		-DFLUID_WITH_DEMO=OFF
		-DLIRI_LOCAL_ECM=$(usex system-fluid "OFF" "ON")
	)
	cmake-utils_src_configure
}
