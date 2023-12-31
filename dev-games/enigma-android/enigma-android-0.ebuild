# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REVISION=0

DESCRIPTION="A package for cross building for Android with the Enigma game \
engine"
#KEYWORDS="" # Ebuild not finished
SLOT="0/${REVISION}"
IUSE="
box2d bullet freetype gles1 gles2 gme gtest joystick network opengl png sdl2
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

RDEPEND="
	>=dev-cpp/gtest-${GTEST_PV}
	>=media-libs/glm-${GLM_PV}
	dev-util/android-ndk
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
	network? (
		>=net-misc/curl-${CURL_PV}
	)
	opengl? (
		>=media-libs/glew-${GLEW_PV}
		>=media-libs/glm-${GLM_PV}
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[gles1?,gles2?,joystick?,static-libs,threads?,sound?]
		sound? (
			>=media-libs/flac-${FLAC_PV}
			>=media-libs/libmodplug-${LIBMODPLUG_PV}
			>=media-libs/libogg-${LIBOGG_PV}
			>=media-libs/libsndfile-${LIBSNDFILE_PV}
			>=media-libs/libvorbis-${LIBVORBIS_PV}
			>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[flac,mod,mp3,vorbis]
			>=media-libs/opus-${OPUS_PV}
			>=media-sound/mpg123-${MPG123_PV}
			>=sys-devel/gcc-${GCC_PV}
		)
	)
"
#	>=sys-libs/zlib-${ZLIB_PV}
#	png? (	>=sys-libs/zlib-${ZLIB_PV}) # already in android-ndk

# Check all packages for CHOST compatibility
verify_libs_abi() {
	local arch=${CHOST}
	arch="${arch%%-*}"
	local tag=""
	if [[ "${arch}" == "aarch64" ]] ; then
		tag="aarch64"
	elif [[ "${arch}" == "arch" ]] ; then
		tag="EABI5"
	elif [[ "${arch}" == "i686" ]] ; then
		tag="80386"
	elif [[ "${arch}" == "x86_64" ]] ; then
		tag="x86-64"
	fi

	local packages=(
		"dev-cpp/gtest"
		"dev-games/box2d"
		"games-engines/box2d"
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
		"media-libs/opus"
		"media-libs/sdl2-mixer"
		"media-sound/mpg123"
		"net-misc/curl"
		"sci-physics/bullet"

		# Problems?
#		"sys-devel/gcc"
#		"sys-libs/zlib"
	)

	for package in ${packages[@]} ; do
		has_version "${package}" || continue
		local lib
		for lib in $(grep -r -e "(.dylib|.so|.dll)" "${ESYSROOT}/var/db/pkg/${p}-"*"/CONTENTS" | cut -f 2 -d " ") ; do
			if file "${lib}" | grep "${tag}" ; then
				:;
			else
ewarn "${lib} needs to be rebuild with either ${CHOST}-gcc or ${CHOST}-clang."
			fi
		done
	done
}

src_configure() {
	local arch=${CHOST}
	arch="${arch%%-*}"
einfo
einfo "CHOST=${CHOST}"
einfo "arch=${arch}"
einfo
	case ${arch} in
		aarch64|arm|armv7a|i686|x86_64)
			;;
		*)
eerror
eerror "${arch} is not supported."
eerror
eerror "NDK18 arches:  aarch64, arm, i686, x86_64"
eerror "NDK25 arches:  aarch64, armv7a, i686, x86_64"
eerror "aarch64 and x86_64 require NDK 25 or later"
eerror
			die
			;;
	esac

	if [[ "${arch}" =~ (aarch64|x86_64) ]] \
		&& ! has_version ">=dev-util/android-ndk-25" ; then
eerror
eerror "${arch} requires >=dev-util/android-ndk-25"
eerror
		die
	fi

	# 18 uses gcc
	# 25 uses clang
	export CC=$(find "${EPREFIX}/opt/android-ndk/toolchains/" \
		-path "*/bin/${arch}*android-gcc" \
		-o -path "*/bin/${arch}*android*-clang")
	[[ -e "${CC}" ]] || die "Could not find compiler"
	"${CC}" --version \
		2>/dev/null 1>/dev/null \
		|| die "Compiler is missing.  Fix CHOST."

	verify_libs_abi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
