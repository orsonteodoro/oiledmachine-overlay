# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..13} "pypy3" )

inherit python-r1

DESCRIPTION="Virtual for Python Pillow packages"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="
avif examples imagequant +jpeg jpeg2k lcms pillow-simd raqm test tiff tk
truetype webp xcb zlib
"
REQUIRED_USE="
	!pillow-simd
"

RDEPEND="
	!pillow-simd? (
		!dev-python/pillow-simd
		>=dev-python/pillow-${PV}[${PYTHON_USEDEP},avif?,examples?,imagequant?,jpeg?,jpeg2k?,lcms?,raqm?,test?,tiff?,tk?,truetype?,webp?,xcb?,zlib?]
	)
	pillow-simd? (
		!dev-python/pillow
		>=dev-python/pillow-simd-${PV}[${PYTHON_USEDEP},avif?,imagequant?,jpeg?,jpeg2k?,lcms?,raqm?,test?,tiff?,tk?,truetype?,webp?,xcb?,zlib?]
	)
"
