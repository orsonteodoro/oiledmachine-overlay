# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Qt-style API for freedesktop.org's AccountsService DBus service"
HOMEPAGE="https://github.com/lirios/qtaccountsservice"
LICENSE="LGPL-2.1+ FDL-1.3"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="examples"
QT_MIN_PV=5.8
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils
SRC_URI=\
"https://github.com/lirios/qtaccountsservice/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DQTACCOUNTSSERVICE_WITH_EXAMPLES:BOOL=$(usex examples)
	)
	cmake-utils_src_configure
}
