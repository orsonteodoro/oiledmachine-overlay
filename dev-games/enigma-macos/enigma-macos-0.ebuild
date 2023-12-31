# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REVISION=0

DESCRIPTION="A package for cross building for macOS with the Enigma game engine"
#KEYWORDS="" # Ebuild not finished
SLOT="0/${REVISION}"
IUSE="
box2d bullet freetype gles1 gles2 gme gtk2 gtest joystick network openal opengl
png sdl2 sound threads
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

MACOS_SDK_PV_MIN="10.4"
MACOS_SDK_PV_MAX="13.0"

RDEPEND="
	>=dev-cpp/gtest-${GTEST_PV}
	>=media-libs/glm-${GLM_PV}
	>=sys-libs/zlib-${ZLIB_PV}
	>=sys-devel/clang-13.0.0
	sys-devel/osxcross
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
	gtk2? (
		>=x11-libs/gtk+-${GTK2_PV}
	)
	gtest? (
		>=dev-cpp/gtest-${GTEST_PV}
	)
	network? (
		>=net-misc/curl-${CURL_PV}
	)
	openal? (
		>=media-libs/openal-${OPENAL_PV}
	)
	opengl? (
		>=media-libs/glm-${GLM_PV}
		>=media-libs/glew-${GLEW_PV}
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}
		>=sys-libs/zlib-${ZLIB_PV}
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[aqua,joystick?,opengl?,threads?]
	)
"

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ; then
eerror
eerror "${p} is not reachable"
eerror
	fi
}

src_configure() {
ewarn
ewarn "This ebuild should only be used in a crossdev context."
ewarn "Do not use it in your native build."
ewarn
ewarn
ewarn "macOS support is incomplete/untested"
ewarn
	if [[ -z "${MACOS_SDK_PV}" ]] ; then
eerror
eerror "MACOS_SDK_PV needs to be defined"
eerror
		die
	fi
	if ver_test ${MACOS_SDK_PV} < ${MACOS_SDK_PV_MIN} ; then
		# CI uses 12.1 but it is relaxed in this ebuild for
		# compatibility reasons.
eerror
eerror "Detected ${MACOS_SDK_PV}."
eerror "Requires >= ${MACOS_SDK_PV_MIN}."
eerror
eerror "You will need to download a newer version of the SDK."
eerror
		die
	fi
	if ver_test ${MACOS_SDK_PV} -lt 10.5 \
		&& has_version "<sys-devel/osxcross-1.2" ; then
		:;
	elif ver_test ${MACOS_SDK_PV} -ge 10.5 \
		&& has_version ">=sys-devel/osxcross-1.4" ; then
		:;
	else
		# There is only 1 ebuild in the distro and too outdated.
eerror
eerror "You need =sys-devel/osxcross-1.1 for 10.4, 10.5."
eerror "You need =sys-devel/osxcross-1.4 for >= 10.6."
eerror
		die
	fi
	if ver_test ${MACOS_SDK_PV} -gt ${MACOS_SDK_PV_MAX} ; then
eerror
eerror "${MACOS_SDK_PV} is not supported."
eerror "Requires ${MACOS_SDK_PV_MIN} to ${MACOS_SDK_PV_MAX}"
eerror
	fi

	test_path "${OSXCROSS_ROOT}/target/bin/${OSXCROSS_CHOST}-clang"
	test_path "${OSXCROSS_ROOT}/target/bin/${OSXCROSS_CHOST}-clang++"
	test_path "${OSXCROSS_ROOT}/target/bin/${OSXCORSS_CHOST}-cpp"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
