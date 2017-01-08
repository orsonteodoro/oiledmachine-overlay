# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils

DESCRIPTION="MojoShader"
HOMEPAGE="https://icculus.org/mojoshader/"
SRC_URI="https://hg.icculus.org/icculus/${PN}/archive/5e0ebc5366f3.tar.bz2"

LICENSE="ZLIB"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug static +profile_bytecode +profile_d3d +profile_glsl120 +profile_glsl +profile_arb1 +profile_arb1_nv -effect_support -flip_viewport -depth_clipping -xna_vertextexture"
REQUIRED_USE=""

RDEPEND="dev-util/re2c
	 media-libs/libsdl2"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"

S="${WORKDIR}/${PN}-5e0ebc5366f3"

src_prepare() {
	eapply_user

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
                $(cmake-utils_use profile_d3d PROFILE_D3D)
                $(cmake-utils_use profile_bytecode PROFILE_BYTECODE)
                $(cmake-utils_use profile_glsl120 PROFILE_GLSL120)
                $(cmake-utils_use profile_glsl PROFILE_GLSL)
                $(cmake-utils_use profile_arb1 PROFILE_ARB1)
                $(cmake-utils_use profile_arb1_nv PROFILE_ARB1_NV)
                $(cmake-utils_use effect_support EFFECT_SUPPORT)
                $(cmake-utils_use flip_viewport FLIP_VIEWPORT)
                $(cmake-utils_use depth_clipping DEPTH_CLIPPING)
                $(cmake-utils_use xna_vertextexture XNA4_VERTEXTEXTURE)
        )
	if use static; then
		mycmakeargs+=( -DBUILD_SHARED=OFF )
	else
		mycmakeargs+=( -DBUILD_SHARED=ON )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	#cmake-utils_src_install
	true
	cd "${WORKDIR}/mojoshader-20160101_build"
	mkdir -p "${D}/usr/$(get_libdir)/mojoshader"
	cp libmojoshader.so "${D}/usr/$(get_libdir)"
	cp $(find . -maxdepth 1 -type f -executable | grep -v "\.so") "${D}/usr/$(get_libdir)/mojoshader"

	cd "${S}"
	mkdir -p "${D}/usr/include/MojoShader"
	cp mojoshader_internal.h "${D}/usr/include/MojoShader"
	cp mojoshader.h "${D}/usr/include/MojoShader"
	cp mojoshader_effects.h "${D}/usr/include/MojoShader"
	dodoc README.txt
}
