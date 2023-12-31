# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net40"
inherit dotnet git-r3 multilib-build

DESCRIPTION="SDL2# - C# Wrapper for SDL2"
HOMEPAGE="https://github.com/flibitijibibo/SDL2-CS"
LICENSE="ZLIB"
#KEYWORDS="~amd64 ~x86" # live ebuilds do not get KEYWORDed
IUSE="${USE_DOTNET}"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
SDL2_PV="2.0.22"
SDL2_GFX_PV="1.0.1"
SDL2_IMAGE_PV="2.0.6"
SDL2_MIXER_PV="2.0.5"
SDL2_TTF_PV="2.0.16"
RDEPEND="
	dev-lang/mono[${MULTILIB_USEDEP}]
	>=media-libs/libsdl2-${SDL2_PV}[${MULTILIB_USEDEP}]
	>=media-libs/sdl2-gfx-${SDL2_GFX_PV}[${MULTILIB_USEDEP}]
	>=media-libs/sdl2-image-${SDL2_IMAGE_PV}[${MULTILIB_USEDEP}]
	>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[${MULTILIB_USEDEP}]
	>=media-libs/sdl2-ttf-${SDL2_TTF_PV}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
EGIT_COMMIT="HEAD"
EGIT_REPO_URI="https://github.com/flibitijibibo/SDL2-CS.git"
PATCHES=(
	"${FILESDIR}/${PN}-9999-public-functions.patch"
)

check_sdl2_pv() {
	local sdl2_pv=""
	[[ -e "src/SDL2.cs" ]] || die
	sdl2_pv+=$(grep "SDL_MAJOR_VERSION =" src/SDL2.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_pv+="."$(grep "SDL_MINOR_VERSION =" src/SDL2.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_pv+="."$(grep "SDL_PATCHLEVEL =" src/SDL2.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	if ver_test ${sdl2_pv} -ne ${SDL2_PV} ; then
eerror
eerror "Bump SDL2_PV"
eerror
eerror "Actual:  ${sdl2_pv}"
eerror "Expected:  ${SDL2_PV}"
eerror
		die
	fi
}

check_sdl2_gfx_pv() {
	local sdl2_gfx_pv=""
	[[ -e "src/SDL2_gfx.cs" ]] || die
	sdl2_gfx_pv+=$(grep "SDL2_GFXPRIMITIVES_MAJOR =" src/SDL2_gfx.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_gfx_pv+="."$(grep "SDL2_GFXPRIMITIVES_MINOR =" src/SDL2_gfx.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_gfx_pv+="."$(grep "SDL2_GFXPRIMITIVES_MICRO =" src/SDL2_gfx.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	if ver_test ${sdl2_gfx_pv} -ne ${SDL2_GFX_PV} ; then
eerror
eerror "Bump SDL2_GFX_PV"
eerror
eerror "Actual:  ${sdl2_gfx_pv}"
eerror "Expected:  ${SDL2_GFX_PV}"
eerror
		die
	fi
}

check_sdl2_image_pv() {
	local sdl2_image_pv=""
	[[ -e "src/SDL2_image.cs" ]] || die
	sdl2_image_pv+=$(grep "SDL_IMAGE_MAJOR_VERSION =" src/SDL2_image.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_image_pv+="."$(grep "SDL_IMAGE_MINOR_VERSION =" src/SDL2_image.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_image_pv+="."$(grep "SDL_IMAGE_PATCHLEVEL =" src/SDL2_image.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	if ver_test ${sdl2_image_pv} -ne ${SDL2_IMAGE_PV} ; then
eerror
eerror "Bump SDL2_IMAGE_PV"
eerror
eerror "Actual:  ${sdl2_image_pv}"
eerror "Expected:  ${SDL2_IMAGE_PV}"
eerror
		die
	fi
}

check_sdl2_mixer_pv() {
	local sdl2_mixer_pv=""
	[[ -e "src/SDL2_mixer.cs" ]] || die
	sdl2_mixer_pv+=$(grep "SDL_MIXER_MAJOR_VERSION =" src/SDL2_mixer.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_mixer_pv+="."$(grep "SDL_MIXER_MINOR_VERSION =" src/SDL2_mixer.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	sdl2_mixer_pv+="."$(grep "SDL_MIXER_PATCHLEVEL =" src/SDL2_mixer.cs \
		| cut -f 2 -d "=" \
		| grep -E -o -e "[0-9]+")
	if ver_test ${sdl2_mixer_pv} -ne ${SDL2_MIXER_PV} ; then
eerror
eerror "Bump SDL2_MIXER_PV"
eerror
eerror "Actual:  ${sdl2_mixer_pv}"
eerror "Expected:  ${SDL2_MIXER_PV}"
eerror
		die
	fi
}

check_sdl2_ttf_pv() {
	local sdl2_ttf_pv=""
	[[ -e "src/SDL2_ttf.cs" ]] || die
	sdl2_ttf_pv+=$(grep "SDL_TTF_MAJOR_VERSION =" src/SDL2_ttf.cs \
		| cut -f 2 -d "=" \
		| grep -o -E -e "[0-9]+")
	sdl2_ttf_pv+="."$(grep "SDL_TTF_MINOR_VERSION =" src/SDL2_ttf.cs \
		| cut -f 2 -d "=" \
		| grep -o -E -e "[0-9]+")
	sdl2_ttf_pv+="."$(grep "SDL_TTF_PATCHLEVEL =" src/SDL2_ttf.cs \
		| cut -f 2 -d "=" \
		| grep -o -E -e "[0-9]+")
	if ver_test ${sdl2_ttf_pv} -ne ${SDL2_TTF_PV} ; then
eerror
eerror "Bump SDL2_TTF_PV"
eerror
eerror "Actual:  ${sdl2_ttf_pv}"
eerror "Expected:  ${SDL2_ttf_PV}"
eerror
		die
	fi
}

src_configure() {
	check_sdl2_pv
	check_sdl2_gfx_pv
	check_sdl2_image_pv
	check_sdl2_mixer_pv
	check_sdl2_ttf_pv
}

src_compile() {
	exbuild /t:Build SDL2-CS.csproj || die
}

src_install() {
	local configuration="Release"
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	doexe bin/${configuration}/SDL2-CS.dll
	doins bin/${configuration}/SDL2-CS.dll.config
	dodoc LICENSE README
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP: FNA
