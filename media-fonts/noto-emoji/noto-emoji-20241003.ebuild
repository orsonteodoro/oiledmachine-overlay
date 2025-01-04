# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The noto-emoji is supposed to be for the source based build, but the distro is
# breaking the rules.

DESCRIPTION="A redirect or compatibility package to noto-color-emoji-bin"
LICENSE="metapackage"
SLOT="0"
RDEPEND="
	~media-fonts/noto-color-emoji-bin-2.047_p20240827_p20241003
	media-fonts/noto-color-emoji-bin:=
"
DEPEND="
	${RDEPEND}
"
