# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="b792a1d0bfd8123f5ff26f8da5992ae5c6777887" # Aug 31, 2025

inherit xorg-3

KEYWORDS="amd64 ~mips x86"

DESCRIPTION="Silicon Motion video driver"
IUSE+=" ebuild_revision_2"
