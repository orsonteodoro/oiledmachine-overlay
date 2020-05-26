# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Qt-style wrapper around udev"
HOMEPAGE="https://github.com/lirios/qtudev"
LICENSE="LGPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.9
IUSE=""
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	  virtual/libudev"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=dev-util/cmake-shared-1.0.0
	  dev-util/umockdev"
inherit eutils cmake-utils
SRC_URI=\
"https://github.com/lirios/qtudev/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
