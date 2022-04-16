# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils git-r3

DESCRIPTION="Qt-style wrapper around udev"
HOMEPAGE="https://github.com/lirios/qtudev"
LICENSE="LGPL-3+"

# Live/snapshots do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
QT_MIN_PV=5.8
IUSE+=" test"
DEPEND+=" >=dev-qt/qtcore-${QT_MIN_PV}:5=
	    virtual/libudev"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	  dev-util/umockdev
	 ~liri-base/cmake-shared-2.0.0_p9999
	  virtual/pkgconfig
	  test? ( >=dev-qt/qttest-${QT_MIN_PV}:5= )"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	if use test ; then
		QTTEST_PV=$(pkg-config --modversion Qt5Test)
		if ver_test ${QTCORE_PV} -ne ${QTTEST_PV} ; then
			die "Qt5Core is not the same version as Qt5Test"
		fi
	fi
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
		-DBUILD_TESTING=$(usex test)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}
