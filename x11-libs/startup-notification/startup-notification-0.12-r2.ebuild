# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Based on startup-notification-0.12-r1.  Revisions may change on the oiledmachine-overlay.

CFLAGS_HARDENED_LANGS="c-lang"
XORG_MULTILIB="yes"

inherit multilib-minimal xorg-3

KEYWORDS="~arm64"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

DESCRIPTION="Application startup notification and feedback library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/startup-notification"
LICENSE="LGPL-2 MIT"
SLOT="0"
RDEPEND="
	>=x11-libs/libX11-1.4.3[${MULTILIB_USEDEP}]
	>x11-libs/libxcb-1.6[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-0.3.8[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "doc/${PN}.txt" )
PATCHES=(
	"${FILESDIR}/${P}-sys-select_h.patch"
	"${FILESDIR}/${P}-time_t-crash-with-32bit.patch"
)

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild-changes
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  inherit, multilib
