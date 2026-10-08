# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="5a5caacce14c8b683fef58c65f8dc7e60771596f" # Sep 13, 2026

inherit xorg-3

KEYWORDS="amd64 ~loong ~ppc ppc64 x86"

DESCRIPTION="X.Org driver for ASpeedTech cards"
IUSE+=" ebuild_revision_3"
