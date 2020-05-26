# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Session manager"
HOMEPAGE="https://github.com/lirios/session"
LICENSE="GPL-3+ LGPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="systemd"
QT_MIN_PV=5.10
RDEPEND="${RDEPEND}
	>=dev-qt/qtcore-${QT_MIN_PV}:5
	>=dev-qt/qtdbus-${QT_MIN_PV}:5
	>=dev-qt/qtgui-${QT_MIN_PV}:5
	  liri-base/libliri
	>=liri-base/qtgsettings-1.1.0
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0
	>=dev-qt/linguist-tools-${QT_MIN_PV}:5
	>=liri-base/cmake-shared-1.0.0"
inherit eutils cmake-utils
EGIT_COMMIT="1bd025961c2e368d1abe734fc3bc44cbdb01a39b"
SRC_URI=\
"https://github.com/lirios/session/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

PATCHES=( "${FILESDIR}/${PN}-0.1.0_p20200524-missing-variable.patch" )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_SYSCONFDIR=/etc
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DLIRI_ENABLE_SYSTEMD=$(usex systemd "ON" "OFF")
	)
	if use systemd ; then
		mycmakeargs+=(
			-DINSTALL_SYSTEMDUSERUNITDIR=/usr/lib/systemd/user
			-DINSTALL_SYSTEMDUSERGENERATORSDIR=/usr/lib/systemd/user-generators
		)
	fi
	cmake-utils_src_configure
}
