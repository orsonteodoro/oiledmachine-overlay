# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="efae48d7de2a94cccdd26e6a2eea8fbe315d7a6d" # Jan 11, 2026

inherit xorg-3

KEYWORDS="~alpha amd64 ~loong ppc ppc64 ~sparc x86"

DESCRIPTION="Matrox video driver"
IUSE+=" ebuild_revision_3"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--disable-dri
	)
	xorg-3_src_configure
}
