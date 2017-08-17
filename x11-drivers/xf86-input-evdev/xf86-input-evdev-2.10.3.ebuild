# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Originally written by tclover, distributed at:
# https://github.com/tokiclover/bar-overlay/tree/master/x11-drivers/xf86-input-evdev

EAPI=5

XORG_EAUTORECONF=yes
inherit xorg-2

DESCRIPTION="Generic Linux input driver with at-home-modifier hack"
HOMEPAGE="https://gitlab.com/at-home-modifier/at-home-modifier-evdev"
SRC_URI="https://gitlab.com/at-home-modifier/download/raw/master/source/ahm-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="sys-libs/mtdev
	>=x11-base/xorg-server-1.12[udev]"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6
	>=x11-proto/inputproto-2.1.99.3"

DOCS="README"

S="${WORKDIR}/at-home-modifer"
