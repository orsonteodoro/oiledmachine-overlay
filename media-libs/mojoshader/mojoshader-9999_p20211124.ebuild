# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="MojoShader is a library to work with Direct3D shaders on alternate\
 3D APIs and non-Windows platforms."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"

# No KEYWORDS for LIVE ebuilds (or LIVE snapshots)

# Wrong CMakeLists.txt ; use mercurial
#SRC_URI=\
#"https://hg.icculus.org/icculus/${PN}/archive/${EGH_REVISION}.tar.bz2 -> ${P}.tar.bz2"
DATE="20211124"
EGIT_COMMIT="76293ed6d5c4bb33875abb92979309e2797cc6ed"
SRC_URI="
https://github.com/icculus/mojoshader/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-9999_p${DATE}-${EGIT_COMMIT:0:7}.tar.gz
"
# profile_metal support is default ON upstream
IUSE="+compiler_support debug -depth_clipping +profile_arb1 +profile_arb1_nv
+profile_bytecode +profile_d3d +profile_glsl120 +profile_glsl +profile_glsles
+profile_hlsl -profile_metal +profile_spirv +profile_glspirv +effect_support
-flip_viewport static-libs -xna_vertextexture"
REQUIRED_USE=""
SLOT="0/${PV}"
RDEPEND+=" >=dev-util/re2c-1.2.1
	 media-libs/libsdl2
	 profile_metal? ( sys-devel/gcc[objc] )"
DEPEND+=" ${RDEPEND}
	>=dev-util/cmake-2.6"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-1310-cmake-fixes.patch"
	eapply "${FILESDIR}/${PN}-1240-cmake-build-both-static-and-shared.patch"
	eapply "${FILESDIR}/${PN}-9999_p20211124-remove-mercurial.patch"
	eapply "${FILESDIR}/${PN}-9999_p20211124-hash_remove-ctx-fixes.patch"
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
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
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
                -DPROFILE_GLSLES=$(usex profile_glsles)
                -DPROFILE_HLSL=$(usex profile_hlsl)
                -DPROFILE_METAL=$(usex profile_metal)
                -DPROFILE_SPIRV=$(usex profile_spirv)
                -DPROFILE_GLSPIRV=$(usex profile_glspirv)
                -DXNA4_VERTEXTEXTURE=$(usex xna_vertextexture)
		-DBUILD_SHARED_LIBS="ON"
		-DBUILD_STATIC_LIBS=$(usex static-libs "ON" "OFF")
		-DCMAKE_SKIP_RPATH=ON
        )

	MAKEOPTS="-j1" \
	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1" \
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc LICENSE.txt
}
