# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REVISION=0

DESCRIPTION="A package for cross building with the MinGW-w64 (32-bit) toolchain \
and Wine32 for the Enigma game engine"
#KEYWORDS="" # Ebuild not finished
SLOT="0/${REVISION}"
IUSE="
box2d bullet freetype gme gtest gtk2 joystick network openal opengl png sdl2
sound threads
"
REQUIRED_USE="
	freetype
	png
"

ALURE_PV="1.2"
BOX2D_PV_EMAX="2.4"
CLANG_PV="10.0.0"
BOOST_PV="1.79"
BULLET_PV="3.24"
CURL_PV="7.68"
FLAC_PV="1.3.4"
FREETYPE_PV="2.12.1"
GCC_PV="10.3.0" # Upstream uses 12.1.0 for Linux.  This has been relaxed in this ebuild.
GLEW_PV="2.2.0"
GLM_PV="0.9.9.7"
GME_PV="0.6.3"
GTEST_PV="1.10.0"
GTK2_PV="2.24.33"
LIBFFI_PV="3.4.2"
LIBMODPLUG_PV="0.8.9.0"
LIBOGG_PV="1.3.5"
LIBPNG_PV="1.6.37"
LIBSDL2_PV="2.0.22"
LIBSNDFILE_PV="1.1.0"
LIBVORBIS_PV="1.3.7"
LIBX11_PV="1.8.1"
MESA_PV="22.1.2"
MPG123_PV="1.25.13"
OPENAL_PV="1.22.2"
OPUS_PV="1.3.1"
PULSEAUDIO_PV="16.1"
SDL2_MIXER_PV="2.6.1"
VIRTUAL_WINE_PV="0"
WINE_PV="7.13"
WINE_STAGING_PV="${WINE_PV}"
WINE_VANILLA_PV="${WINE_PV}"
ZLIB_PV="1.2.12"

# FIXME: alures[modplug] is missing
RDEPEND="
	>=dev-libs/libffi-${LIBFFI_PV}
	>=dev-util/mingw64-runtime-10
	>=media-libs/glm-${GLM_PV}
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/zlib-${ZLIB_PV}
	box2d? (
		|| (
			<dev-games/box2d-${BOX2D_PV_EMAX}:2.3
			<games-engines/box2d-${BOX2D_PV_EMAX}:2.3.0
		)
	)
	bullet? (
		>=sci-physics/bullet-${BULLET_PV}
	)
	freetype? (
		>=media-libs/freetype-${FREETYPE_PV}[static-libs]
	)
	gme? (
		>=media-libs/game-music-emu-${GME_PV}
	)
	gtest? (
		>=dev-cpp/gtest-${GTEST_PV}
	)
	gtk2? (
		>=x11-libs/gtk+-${GTK2_PV}
	)
	network? (
		>=net-misc/curl-${CURL_PV}
	)
	openal? (
		>=media-libs/alure-${ALURE_PV}[dumb,flac,mp3,sndfile,static-libs,vorbis]
		>=media-libs/flac-${FLAC_PV}
		>=media-libs/libmodplug-${LIBMODPLUG_PV}
		>=media-libs/libogg-${LIBOGG_PV}
		>=media-libs/libsndfile-${LIBSNDFILE_PV}
		>=media-libs/libvorbis-${LIBVORBIS_PV}
		>=media-libs/openal-${OPENAL_PV}
		>=media-sound/mpg123-${MPG123_PV}
		>=media-sound/pulseaudio-${PULSEAUDIO_PV}
	)
	opengl? (
		>=media-libs/glew-${GLEW_PV}
		>=media-libs/glm-${GLM_PV}
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}
		>=sys-libs/zlib-${ZLIB_PV}
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[joystick?,opengl?,sound?,threads?]
		sound? (
			>=media-libs/flac-${FLAC_PV}
			>=media-libs/libmodplug-${LIBMODPLUG_PV}
			>=media-libs/libogg-${LIBOGG_PV}
			>=media-libs/libsndfile-${LIBSNDFILE_PV}
			>=media-libs/libvorbis-${LIBVORBIS_PV}
			>=media-libs/opus-${OPUS_PV}
			>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[flac,mod,mp3,vorbis]
			>=media-sound/mpg123-${MPG123_PV}
			>=sys-devel/gcc-${GCC_PV}
		)
	)
"

# Check all packages for CHOST compatibility
verify_libs_abi() {
	local arch=${CHOST}
	arch="${arch%%-*}"
	local packages=(
		"dev-cpp/gtest"
		"dev-games/box2d"
		"dev-libs/libffi"
		"games-engines/box2d"
		"media-libs/alure"
		"media-libs/flac"
		"media-libs/freetype"
		"media-libs/game-music-emu"
		"media-libs/glew"
		"media-libs/glm"
		"media-libs/libmodplug"
		"media-libs/libogg"
		"media-libs/libpng"
		"media-libs/libsdl2"
		"media-libs/libsndfile"
		"media-libs/libvorbis"
		"media-libs/openal"
		"media-libs/opus"
		"media-libs/sdl2-mixer"
		"media-sound/mpg123"
		"media-sound/pulseaudio"
		"net-misc/curl"
		"sci-physics/bullet"

		# Problems?
		"sys-devel/gcc"
		"sys-libs/zlib"
	)

	for package in ${packages[@]} ; do
		has_version "${package}" || continue
		local lib
		for lib in $(grep -r -e "(.dylib|.so|.dll)" "${ESYSROOT}/var/db/pkg/${p}-"*"/CONTENTS" | cut -f 2 -d " ") ; do
			if file "${lib}" | grep -q -e "PE32 " ; then
				:;
			else
ewarn "${lib} needs to be rebuild with either ${CHOST}-gcc or ${CHOST}-clang."
			fi
		done
	done
}

src_configure() {
	[[ "${CHOST}" != "i686-w64-mingw32" ]] \
		&& die "Wrong CHOST.  It must be i686-w64-mingw32"
	${CHOST}-gcc --version 2>/dev/null 1>/dev/null \
		|| die "Compiler is missing."

	verify_libs_abi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
