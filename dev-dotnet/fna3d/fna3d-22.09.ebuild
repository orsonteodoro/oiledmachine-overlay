# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FRAMEWORK="4.0"
inherit cmake

DESCRIPTION="FNA3D - 3D Graphics Library for FNA"
HOMEPAGE="http://fna-xna.github.io/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
IUSE+=" hlsl"
REQUIRED_USE="
	hlsl? ( || ( elibc_mingw ) )
"
RDEPEND="
	~media-libs/mojoshader-9999:=[depth-clipping,effect-support,flip-viewport,profile_glsl,profile_spirv,sdl2-stdlib,xna-vertextexture]
	>=dev-util/vulkan-headers-1.2.165:=
	hlsl? (
		media-libs/mojoshader:=[profile_hlsl]
	)
"
DEPEND="${RDEPEND}"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI="
https://github.com/FNA-XNA/FNA3D/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/FNA3D-${PV}"
RESTRICT="mirror"
EGIT_COMMIT="${PV}" # the head of this tag
EGIT_REPO_URI="https://github.com/FNA-XNA/FNA.git"
PATCHES=(
	"${FILESDIR}/${PN}-22.09-mojoshader-external.patch"
)

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

src_configure() {
	local mycmakeargs=(
		-DEXTERNAL_MOJOSHADER=ON
	)
	cmake_src_configure
}

src_install() {
	pushd "${S}" || die
		insinto /usr/include
	        doins include/FNA3D.h
		doins include/FNA3D_Image.h
		dodoc LICENSE README
	popd
	pushd "${BUILD_DIR}" || die
		dolib.so libFNA3D.so
		dolib.so libFNA3D.so.0
		dolib.so libFNA3D.so.0.${PV}
	popd
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP: FNA
