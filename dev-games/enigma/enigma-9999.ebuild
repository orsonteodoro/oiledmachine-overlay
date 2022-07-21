# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CXX_STANDARD="-std=c++17"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"

inherit desktop eutils flag-o-matic git-r3 multilib-minimal \
toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation,
is an open source cross-platform game development environment."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"

# Live ebuilds don't get KEYWORDS

# CI/install_emake_deps.sh
H1_EXPECTED="\
6aa51272355b17e5deb0a45fb273da7c89cb04310effe1b8af2c7157c97f9fd6\
1134396a323c77de3199f5842792afdf8bd8fb537c7592f237f154891b6ade42\
"
# CI/solve_engine_deps.sh
H2_EXPECTED="\
7280ba40ef064b63a626626a35082d216e2cb705637ed87e9e707cdd28f1fa2d\
7bdb2256a0c54413313eabf7b44d0ad2e7ed39f1a663a755bdbe28e202494193\
"

H3_EXPECTED="\
aba553d213834071ba6722e33d2ae67e94c874b5ef4d26be3697c839a6c5f98e\
b435adef06cecfb14e9066356d76c0266dbcfe676d74d86e2b63f8932aab80b6\
"

ABI_FINGERPRINT="eb4b9f49adbb454e86c10d9d1526ea6cdce3dd2f4b5f951f776024e0d460fbb1"
DEPENDS_FINGERPRINT="75d6a02780083805ac667a20bb187720b9f54391f28d0ae14d4368979234eabd"
SLOT="0/${ABI_FINGERPRINT}"
IUSE+=" android box2d bullet clang doc externalfuncs freetype gles gles2
gles3 gme gnome gtk2 gtest kde linux minimal network +openal +opengl opengl1
+opengl3 osx png radialgm sdl2 test wine wine32 wine64 +X"
REQUIRED_USE+="
	gles? ( sdl2 )
	gles2? ( gles opengl )
	gles3? ( gles opengl )
	opengl? ( || ( sdl2 X ) )
	opengl1? ( opengl )
	opengl3? ( opengl )
	sdl2? ( wine )
	wine32? ( wine )
	wine64? ( wine )
"
#
# For some list of dependencies, see
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/install_emake_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/solve_engine_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/build_sdl.sh
# grep -r -F -e "find_library(" -e "find_package("
#
# No code references but only on build files: libvorbis3, vorbisfile,
# pulseaudio, libpulse
# media-libs/libvorbis[${MULTILIB_USEDEP}] # line to be placed in openal RDEPEND
#
# See CI for *DEPENDs
ALURE_PV="1.2"
CLANG_PV="10.0.0"
CURL_PV="7.68"
BOOST_PV="1.79"
BULLET_PV="3.24"
FLAC_PV="1.3.4"
FREETYPE_PV="2.12.1"
GCC_PV="10.3.0" # Upstream uses 12.1.0 for Linux.  This has been relaxed in this ebuild.
GLM_PV="0.9.9.7"
GLEW_PV="2.2.0"
GME_PV="0.6.3"
GTEST_PV="1.10.0"
LIBFFI_PV="3.4.2"
LIBOGG_PV="1.3.5"
LIBPNG_PV="1.6.37"
LIBSDL2_PV="2.0.22"
LIBSNDFILE_PV="1.1.0"
LIBVORBIS_PV="1.3.7"
LIBX11_PV="1.8.1"
MESA_PV="22.1.2"
MODPLUG_PV="0.8.9.0"
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
CDEPEND="
	>=dev-libs/protobuf-3.21.1[${MULTILIB_USEDEP}]
	>=sys-devel/gcc-${GCC_PV}
	radialgm? ( >=net-libs/grpc-1.47.0[${MULTILIB_USEDEP}] )
"
DEPEND+="
	${CDEPEND}
	>=dev-cpp/abseil-cpp-20211102.0[${MULTILIB_USEDEP}]
	>=dev-cpp/yaml-cpp-0.7.0[${MULTILIB_USEDEP}]
	>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
	>=dev-libs/double-conversion-3.2.0[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre2-10.40[${MULTILIB_USEDEP},pcre16]
	>=dev-libs/openssl-1.1.1p[${MULTILIB_USEDEP}]
	>=dev-libs/pugixml-1.12.1[${MULTILIB_USEDEP}]
	>=dev-libs/rapidjson-1.1.0
	>=media-libs/harfbuzz-4.4.1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	virtual/libc
	android? (
		>=dev-util/android-ndk-23
		dev-util/android-sdk-update-manager
		sys-devel/crossdev
	)
	box2d? (
		|| (
			<dev-games/box2d-2.4:2.3[${MULTILIB_USEDEP}]
			<games-engines/box2d-2.4:2.3.0[${MULTILIB_USEDEP}]
		)
	)
	bullet? ( >=sci-physics/bullet-${BULLET_PV}[${MULTILIB_USEDEP}] )
	externalfuncs? (
		>=dev-libs/libffi-${LIBFFI_PV}[${MULTILIB_USEDEP}]
	)
	freetype? ( >=media-libs/freetype-${FREETYPE_PV}[${MULTILIB_USEDEP},static-libs] )
	gles? (
		>=media-libs/glm-${GLM_PV}
		>=media-libs/libepoxy-1.5.4[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
	)
	gme? ( >=media-libs/game-music-emu-${GME_PV}[${MULTILIB_USEDEP}] )
	gnome? ( >=gnome-extra/zenity-3.43.0 )
	gtk2? ( >=x11-libs/gtk+-2.24.33:2[${MULTILIB_USEDEP}] )
	gtest? (
		>=dev-cpp/gtest-${GTEST_PV}[${MULTILIB_USEDEP}]
	)
	kde? ( >=kde-apps/kdialog-19.12.3 )
	network? ( >=net-misc/curl-${CURL_PV}[${MULTILIB_USEDEP}] )
	openal? (
		>=media-libs/alure-${ALURE_PV}[${MULTILIB_USEDEP}]
		>=media-libs/dumb-2.0.3[${MULTILIB_USEDEP}]
		>=media-libs/openal-${OPENAL_PV}[${MULTILIB_USEDEP}]

		>=media-libs/libvorbis-${LIBVORBIS_PV}[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=media-libs/glew-${GLEW_PV}[${MULTILIB_USEDEP}]
		>=media-libs/glm-${GLM_PV}
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	)
	radialgm? ( >=net-dns/c-ares-1.18.1[${MULTILIB_USEDEP}] )
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[${MULTILIB_USEDEP},gles2?]
		>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[${MULTILIB_USEDEP}]

	)
	wine? (
		sys-devel/crossdev
		wine32? ( virtual/wine[abi_x86_32] )
		wine64? ( virtual/wine[abi_x86_64] )
	)
	X? (
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
		>=sys-process/procps-3.3.17[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/libXinerama-1.1.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXtst-1.2.3[${MULTILIB_USEDEP}]
	)
"

RDEPEND+=" ${DEPEND}"
LLVM_SLOTS=(10 11 12 13 14 15)

gen_clang_deps() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			>=sys-libs/libcxx-${s}[${MULTILIB_USEDEP}]
			>=sys-libs/libcxxabi-${s}[${MULTILIB_USEDEP}]
			>=sys-devel/lld-${s}
			test? ( >=dev-util/lldb-${s} )
		)
		"
	done
}

BDEPEND+="
	${CDEPEND}
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-util/cmake-3.23.2
	clang? ( || ( $(gen_clang_deps) ) )
	test? (
		>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
	)
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( "" "Readme.md" )

_calculate_depends_fingerprint() {
	local dfp=$(echo "${RDEPEND}:${DEPEND}:${BDEPEND}" \
		| tr "\n" " " \
		| sed -E -e "s|[[:space:]]+| |g" \
		| sha256sum \
		| cut -f 1 -d " ")
	if [[ "${dfp}" != "${DEPENDS_FINGERPRINT}" ]] ; then
		# No versioning.
eerror
eerror "CURRENT_DEPENDS_FINGERPRINT:   ${dfp}"
eerror "EXPECTED_DEPENDS_FINGERPRINT:  ${DEPENDS_FINGERPRINT}"
eerror
eerror "Update the DEPENDS_FINGERPRINT."
eerror
		die
	fi
}

crossdev_has_pkg_use() {
	local p="${1}"
	local pv="${2}"
	local u="${3}"
	local path=$(realpath "${CROSSDEV_SYSROOT}/var/db/pkg/${p}"*)

	crossdev_has_pkg "${p}" "${pv}"

	if grep -q "${u}" "${CROSSDEV_SYSROOT}/var/db/pkg/${p}"*"/USE" ]] ; then
		return 0
	fi
eerror
eerror "Missing ${p} with USE=${u}"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge ${p}[${u}]\` to build it."
eerror "See ebuild for full list in ${FUNC}."
eerror
}

crossdev_has_pkg() {
	local p="${1}"
	local pv="${2}"
	local path=$(realpath "${CROSSDEV_SYSROOT}/var/db/pkg/${p}"*)
	if [[ -e "${path}" ]] ; then
		local x_pv=$(basename "${path}" | sed -e "s|${p}-||g")
		ver_test ${x_pv} -ge ${pv} && return 0
	fi
eerror
eerror "Missing or out of date ${p}"
eerror "Requires:  >=${p}-${pv}"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge ${p}\` to build it"
eerror "See ebuild for full list in ${FUNC}."
eerror
}

# Non-fatal test
crossdev_has_pkg_nf() {
	local p="${1}"
	local pv="${2}"
	local path=$(realpath "${CROSSDEV_SYSROOT}/var/db/pkg/${p}"*)
	if [[ -e "${path}" ]] ; then
		local x_pv=$(basename "${path}" | sed -e "s|${p}-||g")
		ver_test ${x_pv} -ge ${pv} && return 0
	fi
	return 1
}

check_mingw64() {
	ewarn "MINGW64 support is incomplete/untested"
	if [[ -z "${MINGW64_SYSROOT}" ]] ; then
eerror
eerror "MINGW64_SYSROOT needs to point to the crossdev image."
eerror
		die
	fi
	if [[ -z "${MINGW64_CTARGET}" ]] ; then
eerror
eerror "MINGW64_CTARGET needs to be defined used to build this target"
eerror "(eg. x86_64-w64-mingw32)."
eerror
		die
	fi
	export CROSSDEV_CTARGET="${MINGW64_CTARGET}"
	export CROSSDEV_SYSROOT="${MINGW64_SYSROOT}"
	export FUNC="check_mingw64()"
	[[ -n "${CROSSDEV_SYSROOT}" ]] || return

	# We ALWAYS do this because emerge is orders of magnitude slow.
	crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	if use box2d ; then
		crossdev_has_pkg "dev-games/box2d" "${BOX2D_PV}"
	fi
	if use bullet ; then
		crossdev_has_pkg "sci-physics/bullet" "${BULLET_PV}"
	fi
	if use freetype ; then
		crossdev_has_pkg_use "media-libs/freetype" "${FREETYPE_PV}" "static-libs"
	fi
	if use gme ; then
		crossdev_has_pkg "media-libs/game-music-emu" "${GME_PV}"
	fi
	if use gtest ; then
		crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	fi
	if use openal ; then
		crossdev_has_pkg "media-libs/openal" "${OPENAL_PV}"
		crossdev_has_pkg "media-libs/alure" "${ALURE_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/flac" "${FLAC_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "media-sound/pulseaudio" "${PULSEAUDIO_PV}"
	fi
	if use opengl ; then
		crossdev_has_pkg "media-libs/glew" "${GLEW_PV}"
		crossdev_has_pkg "media-libs/glm" "${GLM_PV}"
	fi
	if use png ; then
		crossdev_has_pkg "media-libs/libpng" "${LIBPNG_PV}"
		crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	fi
	if use sdl2 ; then
		crossdev_has_pkg "media-libs/opus" "${OPUS_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/flac" "${LIBFLAC_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg "media-libs/libsdl2" "${LIBSDL2_PV}"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/sdl2-mixer" "${SDL2_MIXER_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "sys-devel/gcc" "${GCC_PV}" # for -lssp
	fi
	if use wine ; then
		crossdev_has_pkg "virtual/wine" "${VIRTUAL_WINE_PV}"
		if crossdev_has_pkg_nf "app-emulation/wine-staging" "${WINE_STAGING_PV}" \
			|| crossdev_has_pkg_nf "app-emulation/wine-vanilla" "${WINE_VANILLA_PV}" ; then
			:;
		else
eerror
eerror "Missing wine package"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-staging\`"
eerror
eerror "  or"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-vanilla\`"
eerror

			die
		fi
	fi
}

check_mingw32() {
	ewarn "MINGW32 support is incomplete/untested"
	if [[ -z "${MINGW32_SYSROOT}" ]] ; then
eerror
eerror "MINGW32_SYSROOT needs to point to the crossdev image."
eerror
		die
	fi
	if [[ -z "${MINGW64_CTARGET}" ]] ; then
eerror
eerror "MINGW32_CTARGET needs to be defined used to build this target"
eerror "(eg. i686-w64-mingw32)."
eerror
		die
	fi
	export CROSSDEV_CTARGET="${MINGW32_CTARGET}"
	export CROSSDEV_SYSROOT="${MINGW32_SYSROOT}"
	export FUNC="check_mingw32()"
	[[ -n "${CROSSDEV_SYSROOT}" ]] || return

	# We ALWAYS do this because emerge is orders of magnitude slow.
	crossdev_has_pkg "dev-libs/libffi" "${LIBFFI_PV}"
	crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	if use box2d ; then
		crossdev_has_pkg "dev-games/box2d" "${BOX2D_PV}"
	fi
	if use bullet ; then
		crossdev_has_pkg "sci-physics/bullet" "${BULLET_PV}"
	fi
	if use freetype ; then
		crossdev_has_pkg_use "media-libs/freetype" "${FREETYPE_PV}" "static-libs"
	fi
	if use gme ; then
		crossdev_has_pkg "media-libs/game-music-emu" "${GME_PV}"
	fi
	if use gtest ; then
		crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	fi
	if use gtk2 ; then
		crossdev_has_pkg "x11-libs/gtk+" "${GTK2_PV}"
	fi
	if use network ; then
		crossdev_has_pkg "net-misc/curl" "${CURL_PV}"
	fi
	if use openal ; then
		crossdev_has_pkg "media-libs/openal" "${OPENAL_PV}"
		crossdev_has_pkg "media-libs/alure" "${ALURE_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/flac" "${FLAC_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "media-sound/pulseaudio" "${PULSEAUDIO_PV}"
	fi
	if use opengl ; then
		crossdev_has_pkg "media-libs/glew" "${GLEW_PV}"
		crossdev_has_pkg "media-libs/glm" "${GLM_PV}"
	fi
	if use png ; then
		crossdev_has_pkg "media-libs/libpng" "${LIBPNG_PV}"
		crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	fi
	if use sdl2 ; then
		crossdev_has_pkg "media-libs/opus" "${OPUS_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/flac" "${LIBFLAC_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg "media-libs/libsdl2" "${LIBSDL2_PV}"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/sdl2-mixer" "${SDL2_MIXER_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "sys-devel/gcc" "${GCC_PV}" # for -lssp
	fi
	if use wine ; then
		crossdev_has_pkg "virtual/wine" "${VIRTUAL_WINE_PV}"
		if crossdev_has_pkg_nf "app-emulation/wine-staging" "${WINE_STAGING_PV}" \
			|| crossdev_has_pkg_nf "app-emulation/wine-vanilla" "${WINE_VANILLA_PV}" ; then
			:;
		else
eerror
eerror "Missing wine package"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-staging\`"
eerror
eerror "  or"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-vanilla\`"
eerror

			die
		fi
	fi
}

check_cross_android() {
	ewarn "Android support is incomplete/untested"
	if [[ -z "${ANDROID_SYSROOT}" ]] ; then
eerror
eerror "ANDROID_SYSROOT needs to point to the crossdev image."
eerror
		die
	fi
	if [[ -z "${ANDROID_CTARGET}" ]] ; then
eerror
eerror "ANDROID_CTARGET needs to be defined used to build this target"
eerror "(eg. armv7a-hardfloat-linux-gnueabi)."
eerror
		die
	fi
	export CROSSDEV_CTARGET="${ANDROID_CTARGET}"
	export CROSSDEV_SYSROOT="${ANDROID_SYSROOT}"
	export FUNC="check_cross_android()"
	[[ -n "${CROSSDEV_SYSROOT}" ]] || return
	# We ALWAYS do this because emerge is orders of magnitude slow.
	crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	if use box2d ; then
		crossdev_has_pkg "dev-games/box2d" "${BOX2D_PV}"
	fi
	if use bullet ; then
		crossdev_has_pkg "sci-physics/bullet" "${BULLET_PV}"
	fi
	if use freetype ; then
		crossdev_has_pkg_use "media-libs/freetype" "${FREETYPE_PV}" "static-libs"
	fi
	if use gme ; then
		crossdev_has_pkg "media-libs/game-music-emu" "${GME_PV}"
	fi
	if use gtest ; then
		crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	fi
	if use network ; then
		crossdev_has_pkg "net-misc/curl" "${CURL_PV}"
	fi
	if use opengl ; then
		crossdev_has_pkg "media-libs/glew" "${GLEW_PV}"
		crossdev_has_pkg "media-libs/glm" "${GLM_PV}"
	fi
	if use png ; then
		crossdev_has_pkg "media-libs/libpng" "${LIBPNG_PV}"
		crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	fi
	if use sdl2 ; then
		crossdev_has_pkg "media-libs/opus" "${OPUS_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/flac" "${LIBFLAC_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg_use "media-libs/libsdl2" "${LIBSDL2_PV}" "static-libs"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/sdl2-mixer" "${SDL2_MIXER_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "sys-devel/gcc" "${GCC_PV}" # for -lssp
	fi
	if use wine ; then
		crossdev_has_pkg "virtual/wine" "${VIRTUAL_WINE_PV}"
		if crossdev_has_pkg_nf "app-emulation/wine-staging" "${WINE_STAGING_PV}" \
			|| crossdev_has_pkg_nf "app-emulation/wine-vanilla" "${WINE_VANILLA_PV}" ; then
			:;
		else
eerror
eerror "Missing wine package"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-staging\`"
eerror
eerror "  or"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-vanilla\`"
eerror

			die
		fi
	fi
}

check_cross_osx() {
	ewarn "OSX support is incomplete/untested"
	if [[ -z "${ANDROID_SYSROOT}" ]] ; then
eerror
eerror "OSX_SYSROOT needs to point to the crossdev image."
eerror
		die
	fi
	if [[ -z "${ANDROID_CTARGET}" ]] ; then
eerror
eerror "OSX_CTARGET needs to be defined used to build this target"
eerror "(eg. x86_64-apple-darwin13)."
eerror
		die
	fi
	export CROSSDEV_CTARGET="${OSX_CTARGET}"
	export CROSSDEV_SYSROOT="${OSX_SYSROOT}"
	export FUNC="check_cross_osx()"
	[[ -n "${CROSSDEV_SYSROOT}" ]] || return
	# We ALWAYS do this because emerge is orders of magnitude slow.
	crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	if use box2d ; then
		crossdev_has_pkg "dev-games/box2d" "${BOX2D_PV}"
	fi
	if use bullet ; then
		crossdev_has_pkg "sci-physics/bullet" "${BULLET_PV}"
	fi
	if use freetype ; then
		crossdev_has_pkg_use "media-libs/freetype" "${FREETYPE_PV}" "static-libs"
	fi
	if use gme ; then
		crossdev_has_pkg "media-libs/game-music-emu" "${GME_PV}"
	fi
	if use gtk2 ; then
		crossdev_has_pkg "x11-libs/gtk+" "${GTK2_PV}"
	fi
	if use gtest ; then
		crossdev_has_pkg "dev-cpp/gtest" "${GTEST_PV}"
	fi
	if use network ; then
		crossdev_has_pkg "net-misc/curl" "${CURL_PV}"
	fi
	if use openal ; then
		crossdev_has_pkg "media-libs/openal" "${OPENAL_PV}"
	fi
	if use opengl ; then
		crossdev_has_pkg "media-libs/glm" "${GLM_PV}"
		crossdev_has_pkg "media-libs/glew" "${GLEW_PV}"
	fi
	if use png ; then
		crossdev_has_pkg "media-libs/libpng" "${LIBPNG_PV}"
		crossdev_has_pkg "sys-libs/zlib" "${ZLIB_PV}"
	fi
	if use sdl2 ; then
		crossdev_has_pkg "media-libs/opus" "${OPUS_PV}"
		crossdev_has_pkg "media-libs/libvorbis" "${LIBVORBIS_PV}"
		crossdev_has_pkg "media-libs/libogg" "${LIBOGG_PV}"
		crossdev_has_pkg "media-libs/flac" "${LIBFLAC_PV}"
		crossdev_has_pkg "media-libs/libmodplug" "${LIBMODPLUG_PV}"
		crossdev_has_pkg "media-libs/libsdl2" "${LIBSDL2_PV}"
		crossdev_has_pkg "media-libs/libsndfile" "${LIBSNDFILE_PV}"
		crossdev_has_pkg "media-libs/sdl2-mixer" "${SDL2_MIXER_PV}"
		crossdev_has_pkg "media-sound/mpg123" "${MPG123_PV}"
		crossdev_has_pkg "sys-devel/gcc" "${GCC_PV}" # for -lssp
	fi
	if use wine ; then
		crossdev_has_pkg "virtual/wine" "${VIRTUAL_WINE_PV}"
		if crossdev_has_pkg_nf "app-emulation/wine-staging" "${WINE_STAGING_PV}" \
			|| crossdev_has_pkg_nf "app-emulation/wine-vanilla" "${WINE_VANILLA_PV}" ; then
			:;
		else
eerror
eerror "Missing wine package"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-staging\`"
eerror
eerror "  or"
eerror
eerror "Use \`${CROSSDEV_CTARGET}-emerge app-emulation/wine-vanilla\`"
eerror

			die
		fi
	fi
}

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	if tc-is-gcc ; then
		if ver_test $(gcc-version) -lt ${GCC_PV} ; then
eerror
eerror "You need to update your GCC to >= ${GCC_PV} via eselect or switch to"
eerror "Clang/LLVM to >= ${CLANG_PV} in your per-package environmental variable"
eerror "settings."
eerror
			die
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_PV} ; then
eerror
eerror "You need to update your Clang/LLVM to >= ${CLANG_PV} or switch to"
eerror "GCC >= ${GCC_PV} via eselect in your per-package environmental variable"
eerror "settings."
eerror
			die
		fi
	else
		die "Compiler CC=${CC} CXX=${CXX} is not supported"
	fi
	if test-flags ${CXX_STANDARD} ; then
eerror
eerror "The compiler doesn't support ${CXX_STANDARD} flag."
eerror "Switch the compiler."
eerror
		die
	fi
	_calculate_depends_fingerprint
	use wine32 && check_cross_mingw32
	use wine64 && check_cross_mingw64
	use android && check_cross_android
	use osx && check_cross_osx
}

src_prepare() {
	default
	_calculate_abi_fingerprint
	F=( Makefile CommandLine/emake/Makefile CompilerSource/Makefile )
	for f in ${F[@]} ; do
		einfo "Editing $f"
		sed -i -e "s|-Wl,-rpath,./||g" "${f}" || die
	done
	if use android ; then
ewarn
ewarn "Android support is experimental."
ewarn
	fi
	if use wine ; then
ewarn
ewarn "WINE support is experimental and may not work and be feature complete."
ewarn
		if [[ -z "${MINGW64_SYSROOT}" ]] ; then
			check_mingw64
		fi
		if [[ -z "${MINGW32_SYSROOT}" ]] ; then
			check_mingw32
		fi
	fi

	# Typo?
	sed -i -e "s|ANDROIS_LDLIBS|ANDROID_LDLIBS|g" \
		ENIGMAsystem/SHELL/Makefile || die
}

_calculate_abi_fingerprint() {
	#
	# Generate fingerprint for ABI compatibility checks and subslot.
	#
	# libEGM -> EGM
	# shared -> ENIGMAShared
	# shared/protos -> Protocols
	#
	# The calculation for the ABI may change depending on the dependencies.
	#
	local H=()
	local x

	# Library ABI compatibility
	for x in $(find \
		"${S}/CommandLine/libEGM" \
		"${S}/shared" \
		-name "*.h" | sort) ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done
	for x in $(find "${S}/shared/protos/" -name "*.proto" | sort) ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# Drag and drop actions
	for x in $(find "${S}" -name "*.ey") ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# File formats
	local FFP=($(grep -E -l -r -e  "(Write|Load)Project\(" "${S}" \
		| grep -e ".cpp" \
		| grep -e "libEGM" \
		| grep -v -e "file-format.cpp"))
	for x in ${FFP} ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# Command line option changes
	H+=( $(sha256sum "${S}/CommandLine/emake/OptionsParser.cpp" | cut -f 1 -d " ") )

	# Sometimes the minor versions of dependencies bump the project minor version.
	H+=( ${DEPENDS_FINGERPRINT} )

	# No SOVER, no semver
	local abi_fingerprint=$(echo "${H[@]}" \
		| tr " " "\n" \
		| sort \
		| uniq \
		| sha256sum \
		| cut -f 1 -d " ")
	if [[ "${abi_fingerprint}" != "${ABI_FINGERPRINT}" ]] ; then
eerror
eerror "CURRENT_ABI_FINGERPRINT:   ${abi_fingerprint}"
eerror "EXPECTED_ABI_FINGERPRINT:  ${ABI_FINGERPRINT}"
eerror
eerror "Notify the ebuild maintainer to update the ABI_FINGERPRINT."
eerror
		die
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	h1=$(sha512sum "CI/install_emake_deps.sh" | cut -f 1 -d " ")
	h2=$(sha512sum "CI/solve_engine_deps.sh" | cut -f 1 -d " ")
	h3=$(sha512sum "azure-pipelines.yml" | cut -f 1 -d " ") # NDK
	if [[ "${h1}" != "${H1_EXPECTED}" \
		&& "${h2}" != "${H2_EXPECTED}" \
		&& "${h3}" != "${H3_EXPECTED}" ]] ; then
eerror
eerror "The dependencies have changed.  Notify ebuild maintainer."
eerror
		die
	fi
}

src_configure() {
	cd "${BUILD_DIR}" || die
	if [[ -n "${ANDROID_CTARGET}" ]] ; then
		sed -i -e "s|gcc|${ANDROID_CTARGET}-gcc|g" \
			-e "s|g\+\+|${ANDROID_CTARGET}-g++|g"
			"Compilers/Linux/Android.ey" || die
	fi
	if [[ -n "${MINGW32_CTARGET}" ]] ; then
		sed -i -e "s|i686-w64-mingw32|${MINGW32_CTARGET}|g" \
			"Compilers/Linux/MinGW32.ey" || die
	fi
	if [[ -n "${MINGW64_CTARGET}" ]] ; then
		sed -i -e "s|x86_64-w64-mingw32|${MINGW64_CTARGET}|g" \
			"Compilers/Linux/MinGW64.ey" || die
	fi
	if [[ -n "${OSX_CTARGET}" ]] ; then
		sed -i -e "s|x86_64-apple-darwin13|${OSX_CTARGET}|g" \
			"Compilers/Linux/AppleCross64.ey" || die
	fi
}

src_compile() {
	cd "${BUILD_DIR}" || die
	use radialgm && export CLI_ENABLE_SERVER=TRUE
	local targets=(
		"ENIGMA"
		"emake"
		"gm2egm"
		"libProtocols"
		"libEGM"
		"gm2egm"
	)
	use test && targets+=( "emake-tests" "test-runner" )
	targets+=( ".FORCE" )
	emake ${targets[@]}
	use radialgm && unset CLI_ENABLE_SERVER
}

src_install() {
	cd "${BUILD_DIR}" || die
	insinto "/usr/$(get_libdir)/enigma"
	exeinto "/usr/$(get_libdir)/enigma"
	if use radialgm ; then
		doexe emake
	fi
	BINS=(
		"libcompileEGMf.so"
		"libEGM.so"
		"libENIGMAShared.so"
		"libProtocols.so"
		"gm2egm"
	)
	doexe ${BINS[@]}
	REGULARS=(
		"CommandLine"
		"CompilerSource"
		"Compilers"
		"Config.mk"
		"Default.mk"
		"ENIGMAsystem"
		"events.ey"
		"Makefile"
		"shared"
		"settings.ey"
	)
	doins -r "${REGULARS[@]}"
	if use radialgm ; then
		insinto "/usr/$(get_libdir)/${PN}/CommandLine"
		doins -r "CommandLine/libEGM"
	fi
	exeinto "/usr/bin"
	local x
	for x in "${PN}" "${PN}-cli" ; do
		cat "${FILESDIR}/${x}" > "${T}/${x}" || die
		sed -i -e "s|LIBDIR|$(get_libdir)|g" \
			"${T}/${PN}" || die
		doexe "${T}/${x}"
	done
	newicon "Resources/logo.png" "enigma.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^^}" \
		"/usr/share/pixmaps/${PN}.png" \
		"Development;IDE"
}

pkg_postinst()
{
	if use android ; then
einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/Android.ey manually"
einfo
	fi
}
