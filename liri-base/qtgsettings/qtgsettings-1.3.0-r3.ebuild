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
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-libs/glib-2.31.0"
DEPEND="${RDEPEND}
	>=kde-frameworks/extra-cmake-modules-1.7.0
	>=dev-util/cmake-3.10.0
	>=dev-util/cmake-shared-1.0.0"
inherit eutils cmake-utils
SRC_URI=\
"https://github.com/lirios/qtgsettings/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

PATCHES=( "${FILESDIR}/${PN}-1.3.0-change-QMapIterator-to-stl-style.patch" )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
