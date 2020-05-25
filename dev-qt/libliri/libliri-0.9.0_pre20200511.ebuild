# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Library for Liri apps"
HOMEPAGE="https://github.com/lirios/libliri"
LICENSE="LGPL-3+ FDL-1.3"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.8
IUSE="test"
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5
	>=dev-qt/qtxml-${QT_MIN_PV}:5"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=dev-util/cmake-shared-1.0.0"
inherit eutils cmake-utils
EGIT_COMMIT="0943d3be299f3c6d172d95c2e8ad358d2b3a1113"
SRC_URI=\
"https://github.com/lirios/libliri/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=$(get_libdir)
		-DLIRI_BUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
