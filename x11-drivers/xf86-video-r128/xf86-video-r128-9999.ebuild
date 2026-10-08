# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="524f48c4f7c89564d9d041cf49cafcd07b657868" # Aug 31, 2025

inherit flag-o-matic xorg-3

KEYWORDS="~alpha amd64 ~loong ppc ppc64 ~sparc x86"

DESCRIPTION="ATI Rage128 video driver"
IUSE+=" ebuild_revision_2"

src_configure() {
	# always use C11 semantics
	append-cflags -std=gnu11

	local XORG_CONFIGURE_OPTIONS=(
		--disable-dri
	)
	xorg-3_src_configure
}
