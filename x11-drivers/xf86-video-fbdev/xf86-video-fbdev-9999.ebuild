# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="7648873250ce3843f89541a9716448f6707c60ba" # Aug 12, 2025

inherit xorg-3

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"

DESCRIPTION="video driver for framebuffer device"
IUSE+=" ebuild_revision_2"
