# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-removed-in
# pyroma

MY_PV="${PV/_p/.post}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} "pypy3" )
CPU_X86_FLAGS=(
	cpu_flags_x86_sse4
	cpu_flags_x86_avx2
)

inherit distutils-r1 pypi toolchain-funcs

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/uploadcare/pillow-simd/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The friendly PIL fork"
HOMEPAGE="
	https://github.com/uploadcare/pillow-simd
	https://pypi.org/project/Pillow-SIMD
"
LICENSE="
	HPND
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_X86_FLAGS[@]}
doc imagequant jpeg jpeg2k lcms test tiff truetype webp xcb zlib
"
REQUIRED_USE="
	|| (
		${CPU_X86_FLAGS[@]}
	)
"
RDEPEND+="
	imagequant? (
		>=media-gfx/libimagequant-4.1.1
		media-gfx/libimagequant:=
	)
	jpeg? (
		media-libs/libjpeg-turbo:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2
		media-libs/openjpeg:=
	)
	lcms? (
		media-libs/lcms:2=
	)
	tiff? (
		media-libs/tiff[jpeg,zlib]
		media-libs/tiff:=
	)
	truetype? (
		media-libs/freetype:2
		media-libs/freetype:=
	)
	webp? (
		>=media-libs/libwebp-1.3.2
		media-libs/libwebp:=
	)
	xcb? (
		x11-libs/libxcb
	)
	zlib? (
		sys-libs/zlib:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/olefile[${PYTHON_USEDEP}]
		>=dev-python/sphinx-2.4[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
		dev-python/sphinx-removed-in[${PYTHON_USEDEP}]
		dev-python/sphinxext-opengraph[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/check-manifest[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/markdown2[${PYTHON_USEDEP}]
		dev-python/olefile[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyroma[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGES.rst" "README.md" )

python_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	strip-flags
	filter-flags '-m*'
	local cpu_flags=()
	if use cpu_flags_x86_avx2 ; then
		append-flags -mavx2
	fi
	einfo "CFLAGS:  ${CFLAGS}"
	einfo "CXXFLAGS:  ${CXXFLAGS}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
