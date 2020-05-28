# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Wallpapers for the Liri desktop"
HOMEPAGE="https://github.com/lirios/wallpapers"
LICENSE="CC-BY-SA-4.0 CC-BY-4.0"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="test"
QT_MIN_PV=5.12
RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=liri-base/cmake-shared-1.1.0_p20200511"
inherit cmake-utils eutils
EGIT_COMMIT="3176436fba542e8add2a7815c6629562703e09ed"
SRC_URI=\
"https://github.com/lirios/wallpapers/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
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
