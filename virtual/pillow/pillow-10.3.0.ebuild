# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )

inherit python-r1

DESCRIPTION="Virtual for Python Pillow packages"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="
examples imagequant +jpeg jpeg2k lcms pillow-simd test tiff tk truetype webp xcb
zlib
"

RDEPEND="
	!pillow-simd? (
		!dev-python/pillow-simd
		>=dev-python/pillow-${PV}[${PYTHON_USEDEP},examples?,imagequant?,jpeg?,jpeg2k?,lcms?,test?,tiff?,tk?,truetype?,webp?,xcb?,zlib?]
		dev-python/pillow:=
	)
	pillow-simd? (
		!dev-python/pillow
		>=dev-python/pillow-simd-${PV}[${PYTHON_USEDEP},imagequant?,jpeg?,jpeg2k?,lcms?,test?,tiff?,tk?,truetype?,webp?,xcb?,zlib?]
		dev-python/pillow-simd:=
	)
"
