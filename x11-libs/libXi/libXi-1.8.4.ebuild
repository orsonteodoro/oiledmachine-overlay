# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes
inherit secure-version xorg-3

DESCRIPTION="X.Org Xi library"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-${LIBXFIXES_PV}:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=x11-base/xorg-proto-2021.4.99.2:="

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc specs)
		$(use_with doc xmlto)
		$(use_with doc asciidoc)
		--without-fop
	)
	xorg-3_src_configure
}
