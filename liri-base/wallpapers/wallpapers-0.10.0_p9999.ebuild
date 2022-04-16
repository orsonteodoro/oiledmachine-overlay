# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="Wallpapers for the Liri desktop"
HOMEPAGE="https://github.com/lirios/wallpapers"
LICENSE="CC-BY-SA-4.0 CC-BY-4.0"

# Live/snapshots do not get keyworded

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+=" test"
QT_MIN_PV=5.12
BDEPEND+="
	>=dev-util/cmake-3.10.0
	 ~liri-base/cmake-shared-2.0.0_p9999"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d "\"")
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
