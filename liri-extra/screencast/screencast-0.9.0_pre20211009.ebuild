# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils xdg

DESCRIPTION="Utility to record a video of the screen of a Liri desktop"
HOMEPAGE="https://github.com/lirios/screencast"
LICENSE="GPL-3+"

# Live/snapshots do not get KEYWORDS.

SLOT="0/${PV}"
QT_MIN_PV=5.10
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	  media-libs/gstreamer:1.0
	  media-plugins/gst-plugins-meta:1.0"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  virtual/pkgconfig
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5=
	>=liri-base/cmake-shared-2.0.0:0/2.0.0"
EGIT_COMMIT="9a0348d5fd05a373cbf724b620e03615c3170215"
SRC_URI="
https://github.com/lirios/screencast/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
}

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
