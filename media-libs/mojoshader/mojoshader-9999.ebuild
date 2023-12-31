# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Use Direct3D shaders with other 3D rendering APIs."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"

# No KEYWORDS for LIVE ebuilds (or LIVE snapshots)

# profile_metal support is default ON upstream
PROFILES="
+profile_arb1 +profile_arb1_nv +profile_bytecode +profile_d3d +profile_glsl120
+profile_glsl +profile_glsles +profile_hlsl -profile_metal +profile_spirv
+profile_glspirv
"
_PROFILES="${PROFILES//-/}"
_PROFILES="${_PROFILES//+/}"
IUSE+=" ${PROFILES}"
IUSE+=" +compiler-support debug -depth-clipping +profile-glspirv"
IUSE+=" +effect-support -flip-viewport static-libs sdl2-stdlib"
IUSE+=" -xna-vertextexture"
REQUIRED_USE=" || ( ${_PROFILES} )
	profile_hlsl? ( || ( elibc_mingw ) )
	profile_metal? ( kernel_Darwin )
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=dev-util/re2c-1.2.1
	media-libs/libsdl2
	elibc_mingw? (
		dev-util/mingw64-runtime
	)
	profile_metal? (
		sys-devel/gcc[objc]
	)
"
BDEPEND+="
	>=dev-util/cmake-2.6
"
SRC_URI=""
RESTRICT="mirror"
S="${WORKDIR}/${P}"
EGIT_REPO_URI="https://github.com/icculus/mojoshader.git"
EGIT_COMMIT="HEAD"
PATCHES=(
	"${FILESDIR}/${PN}-1310-cmake-fixes.patch"
	"${FILESDIR}/${PN}-1240-cmake-build-both-static-and-shared.patch"
	"${FILESDIR}/${PN}-9999-sdl2-multilib.patch"
	"${FILESDIR}/${PN}-9999-sdl2-link.patch"
)
EXPECTED_BUILD_FILES="\
cd8b409ec4913dc36be25ea2313f0c1457f1441e0ecd896e836a8368554a07c7\
d70460d65b1eb3bd7da3d8b7e25203e19014a9bc64831c61b46982db705d2ccd\
"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local actual_build_files=$(cat \
		$(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake" | sort) \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "Change in build files detected"
eerror
eerror "Actual:  ${actual_build_files}"
eerror "Expected:  ${EXPECTED_BUILD_FILES}"
eerror
		die
	fi
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	PREFIX="${D}"

	if use sdl2-stdlib ; then
		append-cppflags -DMOJOSHADER_USE_SDL_STDLIB=1
	fi

        local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
                -DCOMPILER_SUPPORT=$(usex compiler-support)
                -DDEPTH_CLIPPING=$(usex depth-clipping)
                -DEFFECT_SUPPORT=$(usex effect-support)
                -DFLIP_VIEWPORT=$(usex flip-viewport)
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
                -DXNA4_VERTEXTEXTURE=$(usex xna-vertextexture)
		-DBUILD_SHARED_LIBS="ON"
		-DBUILD_STATIC_LIBS=$(usex static-libs "ON" "OFF")
		-DCMAKE_SKIP_RPATH=ON
        )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc LICENSE.txt
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
