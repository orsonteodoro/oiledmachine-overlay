# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3 xdg

DESCRIPTION="PulseAudio support for Liri"
HOMEPAGE="https://github.com/lirios/pulseaudio"
LICENSE="GPL-3+ LGPL-2.1+"

# Live/snapshot ebuilds do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	 ~liri-base/fluid-1.2.0_p9999
	>=media-sound/pulseaudio-5.0"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	 ~liri-base/cmake-shared-2.0.0_p9999
	  virtual/pkgconfig"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
}

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}

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
