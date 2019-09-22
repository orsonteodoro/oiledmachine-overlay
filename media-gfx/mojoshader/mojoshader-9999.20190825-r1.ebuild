# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils eutils

DESCRIPTION="MojoShader is a library to work with Direct3D shaders on alternate 3D APIs and non-Windows platforms."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
COMMIT="5887634ea695"
SRC_URI="https://hg.icculus.org/icculus/${PN}/archive/${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
IUSE="-compiler_support debug -depth_clipping +profile_arb1 +profile_arb1_nv +profile_bytecode +profile_d3d +profile_glsl120 +profile_glsl +profile_metal +effect_support -flip_viewport static -xna_vertextexture"
REQUIRED_USE=""
SLOT="9999"
RDEPEND="dev-util/re2c
	 media-libs/libsdl2"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"
S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	cmake-utils_src_prepare
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	PREFIX="${D}"

        local mycmakeargs=(
                -DCOMPILER_SUPPORT=$(usex compiler_support)
                -DDEPTH_CLIPPING=$(usex depth_clipping)
                -DEFFECT_SUPPORT=$(usex effect_support)
                -DFLIP_VIEWPORT=$(usex flip_viewport)
                -DPROFILE_ARB1=$(usex profile_arb1)
                -DPROFILE_ARB1_NV=$(usex profile_arb1_nv)
                -DPROFILE_BYTECODE=$(usex profile_bytecode)
                -DPROFILE_D3D=$(usex profile_d3d)
                -DPROFILE_GLSL120=$(usex profile_glsl120)
                -DPROFILE_GLSL=$(usex profile_glsl)
                -DPROFILE_METAL=$(usex profile_metal)
                -DXNA4_VERTEXTEXTURE=$(usex xna_vertextexture)
		-DBUILD_SHARED=$(usex static "OFF" "ON")
		-DCMAKE_SKIP_RPATH=ON
        )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cd "${WORKDIR}/${PN}-${PV}_build" || die
	into /usr/$(get_libdir)/${PN}
	dolib.so libmojoshader.so $(find . -maxdepth 1 -type f -executable | grep -v "\.so" | sed -e "s|${D}||")

	cd "${S}" || die
	insinto /usr/include/MojoShader
	doins mojoshader_internal.h mojoshader.h mojoshader_effects.h
	dodoc README.txt
}
