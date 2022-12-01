# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="A modern music app for modern people."
HOMEPAGE="https://github.com/lirios/music"
LICENSE="GPL-3+ BSD"
# FindTaglib.cmake is BSD

# Live/snapshots do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
QT_MIN_PV=5.14
IUSE+="
doc test

r5
"

DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtmultimedia-${QT_MIN_PV}:5=[qml]
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=dev-qt/qtsvg-${QT_MIN_PV}:5=
	>=dev-qt/qtsql-${QT_MIN_PV}:5=[sqlite]
	media-libs/taglib:taglib2-preview
	~liri-base/fluid-1.2.0_p9999
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	dev-libs/stb
	virtual/pkgconfig
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
EGIT_OVERRIDE_REPO_LIRIOS_QBS_SHARED="https://github.com/lirios/qbs-shared.git"
EGIT_OVERRIDE_REPO_LIRIOS_CMAKE_SHARED="https://github.com/lirios/cmake-shared.git"
EGIT_SUBMODULES=( '*' '-*fluid*' )
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/music-1.0.0_pre20200314-reference-taglib2.patch"
	"${FILESDIR}/music-1.0.0_pre20200314-allow-system-fluid.patch"
	"${FILESDIR}/music-1.0.0_pre20200314-add-qtmultimedia-to-cmakelists.patch"
)

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

	qbs_check
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
