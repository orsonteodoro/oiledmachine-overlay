# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="533b5313d658422039716f97d59a3eff281401fc" # Aug 12, 2025

inherit xorg-3

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

DESCRIPTION="X.Org driver for dummy cards"
IUSE+=" ebuild_revision_2"
