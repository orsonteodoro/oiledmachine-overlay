# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="2b6538940bcc2f7f109ddf020873f1aaa16c4704" # Aug 12, 2025

inherit xorg-3

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~sparc x86"

DESCRIPTION="Elographics input driver"
IUSE+=" ebuild_revision_2"
