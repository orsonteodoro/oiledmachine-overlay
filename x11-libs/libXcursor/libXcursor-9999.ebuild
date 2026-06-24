# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="15efad7ccd035f5d1ddc8d437e047569d1775fa7"
fi

inherit secure-version xorg-3

DESCRIPTION="X.Org Xcursor library"
LICENSE="HPND"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc"

RDEPEND=">=x11-libs/libXrender-${LIBXRENDER_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-${LIBXFIXES_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-base/xorg-proto:="

XORG_CONFIGURE_OPTIONS=(
	--with-icondir="${EPREFIX}"/usr/share/cursors/xorg-x11
	--with-cursorpath='~/.cursors:~/.icons:/usr/local/share/cursors/xorg-x11:/usr/local/share/cursors:/usr/local/share/icons:/usr/local/share/pixmaps:/usr/share/cursors/xorg-x11:/usr/share/cursors:/usr/share/pixmaps/xorg-x11:/usr/share/icons:/usr/share/pixmaps'
)
