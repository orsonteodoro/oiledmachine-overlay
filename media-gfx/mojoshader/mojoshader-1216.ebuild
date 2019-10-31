# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="MojoShader is a library to work with Direct3D shaders on alternate\
 3D APIs and non-Windows platforms."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
inherit cmake-utils eutils mercurial
EHG_REVISION_C="9d725de6c61c"
EHG_REVISION="1216"
EHG_REPO_URI="https://hg.icculus.org/icculus/mojoshader/"
# Wrong CMakeLists.txt ; use mercurial
#SRC_URI=\
#"https://hg.icculus.org/icculus/${PN}/archive/${EGH_REVISION}.tar.bz2 -> ${P}.tar.bz2"
IUSE="-compiler_support debug -depth_clipping +profile_arb1 +profile_arb1_nv \
+profile_bytecode +profile_d3d +profile_glsl120 +profile_glsl +profile_metal \
+effect_support -flip_viewport static -xna_vertextexture"
REQUIRED_USE=""
SLOT="0/${PV}"
RDEPEND="dev-util/re2c
	 media-libs/libsdl2"
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
	dolib.so libmojoshader.so
	exeinto /usr/$(get_libdir)/${PN}
	doexe availableprofiles bestprofile glcaps testoutput testparse

	cd "${S}" || die
	insinto /usr/include/MojoShader
	doins mojoshader_internal.h mojoshader.h mojoshader_effects.h
	dodoc README.txt
}
