# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="QtQuick and Wayland shell for convergence"
HOMEPAGE="https://github.com/lirios/shell"
LICENSE="GPL-3+ LGPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.7
UNPACKAGED="liri-base/greenisland
	    liri-base/vibe" # https://github.com/lirios/vibe
RDEPEND="${RDEPEND}
	  dev-libs/libqtxdg
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5
	>=dev-qt/qtsql-${QT_MIN_PV}:5
	>=dev-qt/qtsvg-${QT_MIN_PV}:5
	>=dev-qt/qttools-${QT_MIN_PV}:5
	>=dev-qt/qtwayland-${QT_MIN_PV}:5
	>=liri-base/fluid-1.0.0
	>=liri-base/qtaccountsservice-1.3.0
	kde-frameworks/solid
	sys-libs/pam
	${UNPACKAGED}"
DEPEND="${RDEPEND}
	|| (
		  sys-devel/clang
		>=sys-devel/gcc-4.8
	)
	>=dev-util/cmake-3.10.0
	>=kde-frameworks/extra-cmake-modules-1.7.0
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils
SRC_URI=\
"https://github.com/lirios/shell/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	ewarn "This ebuild is on hold because of deprecated dependencies.  Use the ${PN}-${PV}_pYYYYMMDD ebuilds instead."
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
