# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Library for QtQuick apps with Material Design"
HOMEPAGE="https://liri.io/docs/sdk/fluid/develop/"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="test"
QT_MIN_PV=5.8
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-libs/glib-2.31.0"
DEPEND="${RDEPEND}
	>=kde-frameworks/extra-cmake-modules-1.7.0
	>=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0
	test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
inherit cmake-utils eutils
EGIT_COMMIT="fdaa06f1005f1dbaf561ef4a1c714d48b8cbe23b"
SRC_URI=\
"https://github.com/lirios/qtgsettings/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if use test ; then
		QTTEST_PV=$(pkg-config --modversion Qt5Test)
		if ver_test ${QTCORE_PV} -ne ${QTTEST_PV} ; then
			die "Qt5Core is not the same version as Qt5Test"
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
