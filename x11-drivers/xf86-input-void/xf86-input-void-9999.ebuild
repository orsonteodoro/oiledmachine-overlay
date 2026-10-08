# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="913f9e88b68041ebe171ebbf5ae350a805839ca8" # Aug 12, 2025

inherit xorg-3

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ppc ppc64 ~s390 ~sparc x86"

DESCRIPTION="null input driver"
IUSE+=" ebuild_revision_2"
