# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="Qt-style wrapper around udev"
HOMEPAGE="https://github.com/lirios/qtudev"
LICENSE="LGPL-3+"

# Live/snapshots do not get KEYWORDed

SLOT="0/${PV}"
QT_MIN_PV=5.8
IUSE+=" test"
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	  virtual/libudev"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	  dev-util/umockdev
	>=liri-base/cmake-shared-1.0.0
	test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
EGIT_COMMIT="f80ba68becac258004c7e331a6bdbb001b4e5a4f"
SRC_URI="
https://github.com/lirios/qtudev/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
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
