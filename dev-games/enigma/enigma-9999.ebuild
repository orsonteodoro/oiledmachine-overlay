# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CXX_STANDARD="-std=c++17"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"

inherit desktop flag-o-matic git-r3 multilib-minimal \
toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
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

# a*-pipelines.yml
H3_EXPECTED="\
aba553d213834071ba6722e33d2ae67e94c874b5ef4d26be3697c839a6c5f98e\
b435adef06cecfb14e9066356d76c0266dbcfe676d74d86e2b63f8932aab80b6\
"

ABI_FINGERPRINT="30a62b91f551c71d9e46c839fb3b422acb9d5cd5e58926270e3ab6ff1ae3a177"
DEPENDS_FINGERPRINT="bd224de79af12838b99539c15491e3300b034c7a53101de3d55f10e939e3a8f9"
SLOT="0/${ABI_FINGERPRINT}"
IUSE+="
android box2d bullet clang d3d ds doc externalfuncs +freetype gles2 gles3 gme
gnome gtk2 gtest headless joystick kde macos mingw32 mingw64 network +openal
+opengl +png sdl2 sound test threads vulkan widgets wine +X xrandr xtest

fallback-commit
"
REQUIRED_USE_PLATFORMS="
	|| (
		android
		headless
		macos
		sdl2
		X
	)
"

# Required to build but sometimes not required as an extension
REQUIRED_BUILD="
	freetype
	png
"

REQUIRED_USE+="
	${REQUIRED_BUILD}
	${REQUIRED_USE_PLATFORMS}
	android? (
		|| (
			gles2
			gles3
		)
		sdl2
	)
	ds? (
		wine
	)
	gles2? (
		sdl2
	)
	gles3? (
		sdl2
	)
	gnome? (
		widgets
	)
	gtk2? (
		widgets
	)
	kde? (
		widgets
	)
	macos? (
		sdl2
		opengl
	)
	mingw32? (
		wine
	)
	mingw64? (
		wine
	)
	opengl? (
		|| (
			sdl2
			X
		)
	)
	sdl2? (
		|| (
			d3d
			gles2
			gles3
			opengl
		)
	)
	sound? (
		android? (
			sdl2
		)
		macos? (
			openal
		)
		|| (
			ds
			openal
			sdl2
		)
	)
	vulkan? (
		sdl2
	)
	widgets? (
		|| (
			gnome
			gtk2
			kde
		)
	)
	wine? (
		|| (
			d3d
			opengl
		)
	)
	X? (
		opengl
		widgets? (
			|| (
				gnome
				kde
			)
		)
		xrandr
	)
	xrandr? (
		X
	)
	xtest? (
		X
	)
"
#
# For some list of dependencies, see
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/install_emake_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/solve_engine_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/build_sdl.sh
# grep -r -F -e "find_library(" -e "find_package("
#
# See CI for *DEPENDs
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
CDEPEND="
	>=dev-libs/protobuf-3.21.1[${MULTILIB_USEDEP}]
	>=sys-devel/gcc-${GCC_PV}
	>=net-libs/grpc-1.47.0[${MULTILIB_USEDEP}]
"
GLES_DEPEND="
	>=media-libs/glm-${GLM_PV}
	>=media-libs/libepoxy-1.5.4[${MULTILIB_USEDEP}]
	>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
"
OPENGL_DEPEND="
	>=media-libs/glew-${GLEW_PV}[${MULTILIB_USEDEP}]
	>=media-libs/glm-${GLM_PV}
	>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
"

LLVM_SLOTS=( 16 15 14 13 12 11 10 )
gen_clang_deps() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			>=sys-libs/libcxx-${s}[${MULTILIB_USEDEP}]
			>=sys-libs/libcxxabi-${s}[${MULTILIB_USEDEP}]
			sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			sys-devel/lld:${s}
			sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			test? (
				>=dev-util/lldb-${s}
			)
		)
		"
	done
}

DEPEND+="
	${CDEPEND}
	>=dev-cpp/abseil-cpp-20211102.0:=[${MULTILIB_USEDEP}]
	>=dev-cpp/yaml-cpp-0.7.0[${MULTILIB_USEDEP}]
	>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
	>=dev-libs/double-conversion-3.2.0[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre2-10.40[${MULTILIB_USEDEP},pcre16]
	>=dev-libs/openssl-1.1.1p[${MULTILIB_USEDEP}]
	>=dev-libs/pugixml-1.12.1[${MULTILIB_USEDEP}]
	>=dev-libs/rapidjson-1.1.0
	>=media-libs/glm-${GLM_PV}
	>=media-libs/harfbuzz-4.4.1[${MULTILIB_USEDEP}]
	>=net-dns/c-ares-1.18.1[${MULTILIB_USEDEP}]
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
	bullet? (
		>=sci-physics/bullet-${BULLET_PV}[${MULTILIB_USEDEP}]
	)
	externalfuncs? (
		>=dev-libs/libffi-${LIBFFI_PV}[${MULTILIB_USEDEP}]
	)
	freetype? (
		>=media-libs/freetype-${FREETYPE_PV}[${MULTILIB_USEDEP},static-libs]
	)
	gles2? (
		${GLES_DEPEND}
		${OPENGL_DEPEND}
	)
	gles3? (
		${GLES_DEPEND}
		${OPENGL_DEPEND}
	)
	gme? (
		>=media-libs/game-music-emu-${GME_PV}[${MULTILIB_USEDEP}]
	)
	gnome? (
		>=gnome-extra/zenity-3.43.0
	)
	gtk2? (
		>=x11-libs/gtk+-2.24.33:2[${MULTILIB_USEDEP}]
	)
	gtest? (
		>=dev-cpp/gtest-${GTEST_PV}[${MULTILIB_USEDEP}]
	)
	kde? (
		>=kde-apps/kdialog-19.12.3
	)
	network? (
		>=net-misc/curl-${CURL_PV}[${MULTILIB_USEDEP}]
	)
	openal? (
		>=media-libs/alure-${ALURE_PV}[${MULTILIB_USEDEP},dumb,vorbis]
		>=media-libs/dumb-2.0.3[${MULTILIB_USEDEP}]
		>=media-libs/libvorbis-${LIBVORBIS_PV}[${MULTILIB_USEDEP}]
		>=media-libs/openal-${OPENAL_PV}[${MULTILIB_USEDEP}]
	)
	opengl? (
		${OPENGL_DEPEND}
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[${MULTILIB_USEDEP},joystick?,sound?,threads?,vulkan?]
		sound? (
			>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[${MULTILIB_USEDEP},flac,mod,mp3,vorbis]
		)
		X? (
			>=media-libs/libsdl2-${LIBSDL2_PV}[${MULTILIB_USEDEP},opengl?]
		)
	)
	wine? (
		sys-devel/crossdev
		mingw32? (
			virtual/wine[abi_x86_32]
		)
		mingw64? (
			virtual/wine[abi_x86_64]
		)
	)
	X? (
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
		>=sys-process/procps-3.3.17[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/libXinerama-1.1.4[${MULTILIB_USEDEP}]
		xrandr? (
			>=x11-libs/libXrandr-1.5.2[${MULTILIB_USEDEP}]
		)
		xtest? (
			>=x11-libs/libXtst-1.2.3[${MULTILIB_USEDEP}]
		)
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	>=dev-util/cmake-3.23.2
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	dev-util/patchelf
	clang? (
		|| (
			$(gen_clang_deps)
		)
	)
	test? (
		>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
	)
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( "Readme.md" )
PATCHES=(
	"${FILESDIR}/enigma-9999-change-sdl2-audio-linking.patch"
	"${FILESDIR}/enigma-9999-fix-missing-workdir-references.patch"
)

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
eerror "Use \`${CROSSDEV_CTARGET}-emerge \">=${p}-${pv}[${u}]\"\` to build it."
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
eerror "Use \`${CROSSDEV_CTARGET}-emerge \">=${p}-${pv}\"\` to build it"
eerror "See ebuild for full list in ${FUNC}."
eerror
}

# Non-fatal test
crossdev_has_pkg_nf() {
	local p="${1}"
	local pv="${2}"
	local op="${3}"
	local path=$(realpath "${CROSSDEV_SYSROOT}/var/db/pkg/${p}"*)
	if [[ -e "${path}" ]] ; then
		local x_pv=$(basename "${path}" | sed -e "s|${p}-||g")
		ver_test ${x_pv} ${op} ${pv} && return 0
	fi
	return 1
}

check_mingw64() {
ewarn
ewarn "MINGW64 support is incomplete/untested"
ewarn
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
	crossdev_has_pkg "dev-games/enigma-mingw64" "0"
	use box2d && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "box2d"
	use bullet && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "bullet"
	use freetype && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "freetype"
	use gme && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "gme"
	use gtest && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "gtest"
	use gtk2 && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "gtk2"
	use joystick && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "joystick"
	use network && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "network"
	use openal && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "openal"
	use opengl && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "opengl"
	use png && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "png"
	use sdl2 && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "sdl2"
	use sound && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "sound"
	use threads && crossdev_has_pkg_use "dev-games/enigma-mingw64" "0" "threads"
}

check_mingw32() {
ewarn
ewarn "MINGW32 support is incomplete/untested"
ewarn
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
	crossdev_has_pkg "dev-games/enigma-mingw32" "0"
	crossdev_has_pkg_use "dev-games/enigma-mingw32" "${SDL2_MIXER_PV}" ""

	use box2d && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "box2d"
	use bullet && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "bullet"
	use freetype && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "freetype"
	use gles1 && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "gles1"
	use gles2 && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "gles2"
	use gme && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "gme"
	use gtk2 && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "gtk2"
	use gtest && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "gtest"
	use joystick && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "joystick"
	use network && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "network"
	use openal && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "openal"
	use opengl && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "opengl"
	use png && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "png"
	use sdl2 && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "sdl2"
	use sound && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "sound"
	use threads && crossdev_has_pkg_use "dev-games/enigma-mingw32" "0" "threads"
}

check_cross_android() {
ewarn
ewarn "Android support is incomplete/untested"
ewarn
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
	crossdev_has_pkg "dev-games/enigma-android" "0"
	use box2d && crossdev_has_pkg_use "dev-games/enigma-android" "0" "box2d"
	use bullet && crossdev_has_pkg_use "dev-games/enigma-android" "0" "bullet"
	use freetype && crossdev_has_pkg_use "dev-games/enigma-android" "0" "freetype"
	use gles1 && crossdev_has_pkg_use "dev-games/enigma-android" "0" "gles1"
	use gles2 && crossdev_has_pkg_use "dev-games/enigma-android" "0" "gles2"
	use gme && crossdev_has_pkg_use "dev-games/enigma-android" "0" "gme"
	use gtest && crossdev_has_pkg_use "dev-games/enigma-android" "0" "gtest"
	use joystick && crossdev_has_pkg_use "dev-games/enigma-android" "0" "joystick"
	use network && crossdev_has_pkg_use "dev-games/enigma-android" "0" "network"
	use opengl && crossdev_has_pkg_use "dev-games/enigma-android" "0" "opengl"
	use png && crossdev_has_pkg_use "dev-games/enigma-android" "0" "png"
	use sdl2 && crossdev_has_pkg_use "dev-games/enigma-android" "0" "sdl2"
	use sound && crossdev_has_pkg_use "dev-games/enigma-android" "0" "sound"
	use threads && crossdev_has_pkg_use "dev-games/enigma-android" "0" "threads"
}

MACOS_SDK_PV_MIN="10.4"
MACOS_SDK_PV_MAX="13.0"
check_cross_macos() {
ewarn
ewarn "macOS support is incomplete/untested"
ewarn
	if [[ -z "${MACOS_SYSROOT}" ]] ; then
eerror
eerror "MACOS_SYSROOT needs to point to the crossdev image."
eerror
		die
	fi
	if [[ -z "${MACOS_CTARGET}" ]] ; then
eerror
eerror "MACOS_CTARGET needs to be defined used to build this target"
eerror "(eg. x86_64-apple-darwin13)."
eerror
		die
	fi
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
	export CROSSDEV_CTARGET="${MACOS_CTARGET}"
	export CROSSDEV_SYSROOT="${MACOS_SYSROOT}"
	export FUNC="check_cross_macos()"
	[[ -n "${CROSSDEV_SYSROOT}" ]] || return
	# We ALWAYS do this because emerge is orders of magnitude slow.
	crossdev_has_pkg "dev-games/enigma-macos" "0"
	use box2d && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "box2d"
	use bullet && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "bullet"
	use freetype && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "freetype"
	use gles1 && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "gles1"
	use gles2 && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "gles2"
	use gme && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "gme"
	use gtest && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "gtest"
	use gtk2 && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "gtk2"
	use joystick && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "joystick"
	use network && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "network"
	use openal && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "openal"
	use opengl && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "opengl"
	use png && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "png"
	use sdl2 && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "sdl2"
	use sound && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "sound"
	use threads && crossdev_has_pkg_use "dev-games/enigma-macos" "0" "threads"
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
	use android && check_cross_android
	use macos && check_cross_macos
	use mingw32 && check_cross_mingw32
	use mingw64 && check_cross_mingw64
}

src_prepare() {
	default
	_calculate_abi_fingerprint
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
	#H+=( ${DEPENDS_FINGERPRINT} )

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
	use fallback-commit && export EGIT_COMMIT="826b84c599aa3289b4d17533a17de1d14c625335" # Jul 8, 2023
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
	if [[ -n "${MACOS_CTARGET}" ]] ; then
		sed -i -e "s|x86_64-apple-darwin13|${MACOS_CTARGET}|g" \
			"Compilers/Linux/AppleCross64.ey" || die
	fi
}

src_compile() {
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
}

src_install() {
	export STRIP="true"
	local install_dir="/usr/$(get_libdir)/enigma"
#	find "${S}" \
#		-name '*.o' \
#		| xargs rm -vrf '{}' \; || die
	insinto "${install_dir}"
	exeinto "${install_dir}"
	echo "${ABI_FINGERPRINT}" > "${T}/abi_fingerprint" || die
	doins "${T}/abi_fingerprint"
	BINS=(
		"libcompileEGMf.so"
		"libEGM.so"
		"libENIGMAShared.so"
		"libProtocols.so"
		"emake"
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
	insinto "/usr/$(get_libdir)/${PN}/CommandLine"
	doins -r "CommandLine/libEGM"
	exeinto "/usr/bin"
	newicon "Resources/logo.png" "enigma.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^^}" \
		"/usr/share/pixmaps/${PN}.png" \
		"Development;IDE"

	local f
	for f in "${BINS[@]}" ; do
		local p="${ED}${install_dir}/${f}"
		patchelf --remove-rpath "${p}" || die
		patchelf --set-rpath "\$ORIGIN" "${p}" || die
	done
}

pkg_postinst()
{
	if use android ; then
einfo
einfo "See https://github.com/enigma-dev/enigma-android which parts of the"
einfo "build system uses.  The android projects require a gradle wrapper"
einfo "when porting to android, or the build system requires modding."
einfo

einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/Android.ey manually"
einfo "for SYSROOT, -I, -L changes.  They should point/reference CTARGET not"
einfo "CBUILD."
einfo
	fi
	if use macos ; then
einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/AppleCross64.ey manually"
einfo "for SYSROOT, -I, -L changes.  They should point/reference CTARGET not"
einfo "CBUILD."
einfo
	fi
	if use mingw32 ; then
einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/MinGW32.ey manually"
einfo "for SYSROOT, -I, -L changes.  They should point/reference CTARGET not"
einfo "CBUILD."
einfo
	fi
	if use mingw64 ; then
einfo
einfo "You need to modify /usr/$(get_libdir)/Compilers/MinGW64.ey manually"
einfo "for SYSROOT, -I, -L changes.  They should point/reference CTARGET not"
einfo "CBUILD."
einfo
	fi
einfo
einfo "A build failure may happen in a simple hello world test if the"
einfo "appropriate subsystem USE flag was disabled with building this package"
einfo "or dependency is not available, but the game settings are the opposite."
einfo "Both the USE flag and the game setting and/or extensions must match."
einfo
einfo "You must carefully enable/disable the Game Settings > ENIGMA > API"
einfo "section and extensions in Settings > ENIGMA > Extensions in LateralGM."
einfo
einfo "or"
einfo
einfo "You must carefully enable/disable the Resources > Create Settings >"
einfo "(double click) setting 0 > API and extensions in (double click)"
einfo "setting 0 > Extensions in RadialGM."
einfo
einfo "These extra checks and matching settings are to fix inconsistencies to"
einfo "prevent game build failures."
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD FORCE_EAPI7
