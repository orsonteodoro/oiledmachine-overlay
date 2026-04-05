# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The noto-emoji is supposed to be for the source based build, but the distro is
# breaking the rules.

# This redirect ebuild is for ebuilds that explicitly require this emoji font,
# so it cannot be simply dropped.

# Distro versioning uses the commit date of noto color emoji.
# oiledmachine-overlay uses the tagged locale date.

# Equivalent to the distro ebuild but without the unsanctioned font.

DESCRIPTION="A redirect or compatibility package to noto-color-emoji-bin"
LICENSE="metapackage"
SLOT="0"
RDEPEND="
	~media-fonts/noto-color-emoji-bin-2.051_p20250818_p20250915
	media-fonts/noto-color-emoji-bin:=
"
DEPEND="
	${RDEPEND}
"
