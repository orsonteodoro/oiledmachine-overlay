# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Qt-style API for freedesktop.org's AccountsService DBus service"
HOMEPAGE="https://github.com/hawaii-desktop/qtaccountsservice"
LICENSE="LGPL-2.1+ GPL-2+ FDL-1.3"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.0
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5"
DEPEND="${RDEPEND}
	>=kde-frameworks/extra-cmake-modules-5.48.0"
inherit eutils cmake-utils
SRC_URI=\
"https://github.com/hawaii-desktop/qtaccountsservice/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
