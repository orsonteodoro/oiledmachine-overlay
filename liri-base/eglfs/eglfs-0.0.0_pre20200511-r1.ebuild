# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="EGL fullscreen platform plugin"
HOMEPAGE="https://github.com/lirios/eglfs"
LICENSE="LGPL-3+ GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
QT_MIN_PV=5.9
IUSE=""
RDEPEND="${RDEPEND}
	  dev-libs/libinput
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5[egl,udev]
	  liri-base/libliri
	  liri-base/qtudev
	  media-libs/fontconfig
	  media-libs/mesa[egl,gbm]
	  x11-libs/libdrm
	  x11-libs/libxkbcommon"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=liri-base/cmake-shared-1.0.0"
inherit cmake-utils eutils
EGIT_COMMIT="54534b5f544dde7726ecffbf800cf8fc7e6e66d7"
SRC_URI=\
"https://github.com/lirios/eglfs/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/eglfs-${EGIT_COMMIT}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
