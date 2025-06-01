# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EXPECTED_FINGERPRINT="\
5f8072cbe37f8e80d1f49942d984537caf369734bd97f307f98f25842ef1e1ee\
234e75cee7e731ef2ab9433f190fa732d74b45aef12e7d1c499d0e981a7644aa\
"
# profile_metal support is default ON upstream
PROFILES_IUSE="
+profile_arb1 +profile_arb1_nv +profile_bytecode +profile_d3d +profile_glsl120
+profile_glsl +profile_glsles +profile_hlsl -profile_metal +profile_spirv
+profile_glspirv
"
PROFILES_REQUIRED_USE="${PROFILES_IUSE//-/}"
PROFILES_REQUIRED_USE="${PROFILES_REQUIRED_USE//+/}"

inherit check-compiler-switch cmake flag-o-matic git-r3

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/icculus/mojoshader.git"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="72895d05c9219e04960ebc7862aae2b017aed954" # May 21, 2024
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${P}"
	SRC_URI="FIXME"
fi

DESCRIPTION="Use Direct3D shaders with other 3D rendering APIs."
HOMEPAGE="https://icculus.org/mojoshader/"
LICENSE="ZLIB"
RESTRICT="
	mirror
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${PROFILES_IUSE}
+compiler-support debug -depth-clipping +profile-glspirv +effect-support
-flip-viewport static-libs sdl2-stdlib -xna-vertextexture
"
REQUIRED_USE="
	profile_hlsl? (
		elibc_mingw
	)
	profile_metal? (
		kernel_Darwin
	)
	|| (
		${PROFILES_REQUIRED_USE}
	)
"
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
	>=dev-build/cmake-2.6
"
PATCHES=(
	"${FILESDIR}/${PN}-dbc721c-1310-cmake-fixes.patch"
	"${FILESDIR}/${PN}-1240-cmake-build-both-static-and-shared.patch"
	"${FILESDIR}/${PN}-dbc721c-sdl2-link.patch"
)

pkg_setup() {
	check-compiler-switch_start
}

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	local build_files=(
		$(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake" \
			| sort)
	)
	local actual_fingerprint=$(cat \
		${build_files[@]} \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${EXPECTED_FINGERPRINT}" == "disable" ]] ; then
		:
	elif [[ "${actual_fingerprint}" != "${EXPECTED_FINGERPRINT}" ]] ; then
eerror
eerror "Change in build files detected"
eerror
eerror "Actual build files fingerprint:  ${actual_fingerprint}"
eerror "Expected build files fingerprint:  ${EXPECTED_FINGERPRINT}"
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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
		-DBUILD_SHARED_LIBS="ON"
		-DBUILD_STATIC_LIBS=$(usex static-libs "ON" "OFF")
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_SKIP_RPATH="ON"
                -DCOMPILER_SUPPORT=$(usex compiler-support)
                -DDEPTH_CLIPPING=$(usex depth-clipping)
                -DEFFECT_SUPPORT=$(usex effect-support)
                -DFLIP_VIEWPORT=$(usex flip-viewport)
                -DPROFILE_ARB1=$(usex profile_arb1)
                -DPROFILE_ARB1_NV=$(usex profile_arb1_nv)
                -DPROFILE_BYTECODE=$(usex profile_bytecode)
                -DPROFILE_D3D=$(usex profile_d3d)
                -DPROFILE_GLSL=$(usex profile_glsl)
                -DPROFILE_GLSL120=$(usex profile_glsl120)
                -DPROFILE_GLSLES=$(usex profile_glsles)
                -DPROFILE_GLSPIRV=$(usex profile_glspirv)
                -DPROFILE_HLSL=$(usex profile_hlsl)
                -DPROFILE_METAL=$(usex profile_metal)
                -DPROFILE_SPIRV=$(usex profile_spirv)
                -DXNA4_VERTEXTEXTURE=$(usex xna-vertextexture)
        )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
