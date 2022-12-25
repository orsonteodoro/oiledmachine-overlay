# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Converts Wayland protocol definition to C++ code"
HOMEPAGE="https://github.com/lirios/aurora-scanner"
LICENSE="CC0-1.0"

# Live/snapshots ebuilds do not get KEYWORDS

SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
test

r5
"
QT_MIN_PV=5.15
DEPEND+="
	!liri-base/wayland
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
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
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dosym aurora-wayland-scanner \
		/usr/bin/qtwaylandscanner
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
