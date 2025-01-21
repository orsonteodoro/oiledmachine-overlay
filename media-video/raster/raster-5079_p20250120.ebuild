# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Versioning based on include/build_number.h and latest commit.

# Package about:
# Video editor

# TODO:
# Finish or drop ebuild

FALLBACK_COMMIT="27eb31c3d4e899b1836de02003171ab0a97aacf5" # Jan 20, 2024
DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/corgifist/raster.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/corgifist/raster/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="GPU-Based Node Video Editor"
HOMEPAGE="
	https://github.com/corgifist/raster
"
LICENSE="
	GPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=media-libs/glfw-3.0
	media-libs/freetype:2
	media-libs/openimageio
	media-libs/rubberband
	media-video/ffmpeg
	sys-libs/binutils-libs
	x11-libs/gtk+:3
"
DEPEND+="
	${RDEPEND}
	media-libs/glm
	sys-libs/libunwind
	dev-python/colorama[${PYTHON_USEDEP}]
"
BDEPEND+="
	${PYHTON_DEPS}
	sys-devel/binutils
	sys-devel/gcc
	virtual/pkgconfig
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_compile() {
	"${EPYTHON}" "build/build.py" || die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
