# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="MojoShader is a library to work with Direct3D shaders on alternate\
 3D APIs and non-Windows platforms."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~x64-macos"
inherit cmake-utils eutils mercurial
EHG_REVISION_C="ff4eb6d9c9c2"
EHG_REVISION="${PV}"
EHG_REPO_URI="https://hg.icculus.org/icculus/mojoshader/"
# Wrong CMakeLists.txt ; use mercurial
#SRC_URI=\
#"https://hg.icculus.org/icculus/${PN}/archive/${EGH_REVISION}.tar.bz2 -> ${P}.tar.bz2"
IUSE="+compiler_support debug -depth_clipping +profile_arb1 +profile_arb1_nv \
+profile_bytecode +profile_d3d +profile_glsl120 +profile_glsl +profile_glsles \
+profile_hlsl +profile_metal +profile_spirv +profile_glspirv +effect_support \
-flip_viewport static-libs -xna_vertextexture"
REQUIRED_USE=""
SLOT="0/${PV}"
RDEPEND=">=dev-util/re2c-1.2.1
	 media-libs/libsdl2
	 profile_metal? ( sys-devel/gcc[objc] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	dev-vcs/mercurial"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-"

src_unpack() {
	mercurial_src_unpack
}

src_prepare() {
	default
	eapply "${FILESDIR}/mojoshader-1310-cmake-fixes.patch"
	eapply "${FILESDIR}/mojoshader-1240-cmake-build-both-static-and-shared.patch"
	# Bugged CMakeLists.txt always points to tip but not static values as
	# expected.
	sed -i -e "s|\
MOJOSHADER_VERSION -1|\
MOJOSHADER_VERSION ${EHG_REVISION}|" \
		CMakeLists.txt || die
	sed -i -e "s|\
MOJOSHADER_CHANGESET \"[?][?][?]\"|\
MOJOSHADER_CHANGESET \"hg-${EHG_REVISION}:${EHG_REVISION_C}\"|" \
		CMakeLists.txt || die
	sed -i -e "s|\
hg tip --template {rev}|\
hg tip --template ${EHG_REVISION}|" \
		CMakeLists.txt || die
	sed -i -e "s;\
hg tip --template hg-{rev}:{node|short};\
hg tip --template hg-${EHG_REVISION}:{node|short};" \
		CMakeLists.txt || die
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
}
