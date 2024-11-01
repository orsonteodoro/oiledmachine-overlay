# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_1
	cpu_flags_x86_avx2
)
PYTHON_COMPAT=( "python3_"{10..11} "pypy3" )

inherit python-r1

DESCRIPTION="Virtual for python pillow packages"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="
${CPU_FLAGS_X86[@]}
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
		>=dev-python/pillow-simd-${PV}[${PYTHON_USEDEP},imagequant?,jpeg?,jpeg2k?,lcms?,test?,tiff?,truetype?,webp?,xcb?,zlib?,cpu_flags_x86_sse4_1=,cpu_flags_x86_avx2=]
		dev-python/pillow-simd:=
	)
"
