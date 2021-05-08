# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="Themes for a uniform look and feel throughout Liri OS"
HOMEPAGE="https://github.com/lirios/themes"
LICENSE="GPL-3+ grub? ( GPL-3-with-font-exception OFL-1.1 )"
# Noto fonts is OFL-1.1
# The KDE Oxygen font is || ( OFL-1.1 GPL-3-with-font-exception )

# Live/snapshot do not get KEYWORDS.

SLOT="0/${PV}"
IUSE+=" grub plymouth sddm"
QT_MIN_PV=5.10
DEPEND+=" grub? ( sys-boot/grub )
	plymouth? ( sys-boot/plymouth )
	sddm? ( liri-base/fluid
		liri-base/shell
		x11-misc/sddm )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.10.0
	  dev-util/pkgconfig
	>=liri-base/cmake-shared-1.0.0"
EGIT_COMMIT="ab914ebb01c9720eb4f43e9d05d9cf965c0589d3"
SRC_URI="
https://github.com/lirios/themes/archive/${EGIT_COMMIT}.tar.gz
	-> ${CATEGORY}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if ! use grub ; then
		rm -rf "${ED}/usr/boot" || die
	fi
	if ! use plymouth ; then
		rm -rf "${ED}/usr/share/plymouth" || die
	fi
	if ! use sddm ; then
		rm -rf "${ED}//usr/share/sddm" || die
	fi
}
