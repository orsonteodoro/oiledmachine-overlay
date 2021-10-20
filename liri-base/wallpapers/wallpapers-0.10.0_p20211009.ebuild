# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="Wallpapers for the Liri desktop"
HOMEPAGE="https://github.com/lirios/wallpapers"
LICENSE="CC-BY-SA-4.0 CC-BY-4.0"

# Live/snapshots do not get keyworded

SLOT="0/${PV}"
IUSE+=" test"
QT_MIN_PV=5.12
BDEPEND+=" >=dev-util/cmake-3.10.0
	>=liri-base/cmake-shared-2.0.0:0/2.0.0"
EGIT_COMMIT="0087dca3273dac17a71eefa122e0ecf7a4dfba02"
SRC_URI="
https://github.com/lirios/wallpapers/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	einfo
	einfo "To pick these wallpapers in Liri, you can..."
	einfo
	einfo "  Right click the desktop > Change Background > Background > Background"
	einfo
	einfo "or"
	einfo
	einfo "  Go to Launcher > Settings > Background > Background"
	einfo
}
