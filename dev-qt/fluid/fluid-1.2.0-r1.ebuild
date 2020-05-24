# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Library for QtQuick apps with Material Design"
HOMEPAGE="https://liri.io/docs/sdk/fluid/develop/"
LICENSE="MPL-2.0 FDL-1.3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.10
RDEPEND="${RDEPEND}
	>=dev-libs/wayland-1.15
	>=dev-qt/qdoc-${QT_MIN_PV}:5
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgraphicaleffects-${QT_MIN_PV}:5
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5
	>=dev-qt/qtsvg-${QT_MIN_PV}:5
	>=dev-qt/qtwayland-${QT_MIN_PV}:5"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=dev-util/cmake-shared-1.0.0
"
inherit eutils cmake-utils
SRC_URI=\
"https://github.com/lirios/fluid/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
