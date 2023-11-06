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

SLOT="0/lateralgm-f30646f" # Required because of the grpc/protobuf.
IUSE+="
android box2d bullet clang d3d ds doc externalfuncs +freetype gles2 gles3 gme
gnome gtk2 gtest headless joystick kde macos mingw32 mingw64 network +openal
+opengl +png sdl2 sound test threads vulkan widgets wine +X xrandr xtest
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
# Fallback U 20.04.3
ALURE_PV="1.2" # missing in CI
BOX2D_PV_EMAX="2.4" # missing in CI
CLANG_PV="12.0.1"
BOOST_PV="1.76.0"
BULLET_PV="2.88" # missing in CI
CURL_PV="7.79.0"
FLAC_PV="1.3.3"
FREETYPE_PV="2.11.0"
GCC_PV="11.1.0"
GLEW_PV="2.1.0" # missing in CI
GLM_PV="0.9.9.7" # missing in CI
GME_PV="0.6.2" # missing in CI
GTEST_PV="1.10.0" # missing in CI
GTK2_PV="2.24.32" # missing in CI
LIBFFI_PV="3.3" # missing in CI
LIBMODPLUG_PV="0.8.9.0"
LIBOGG_PV="1.3.5"
LIBPNG_PV="1.6.37"
LIBSDL2_PV="2.0.16"
LIBSNDFILE_PV="1.0.31"
LIBVORBIS_PV="1.3.7"
LIBX11_PV="1.7.2"
MESA_PV="21.2.1"
MPG123_PV="1.25.13" # missing in CI
OPENAL_PV="1.21.1"
OPUS_PV="1.3.1"
PULSEAUDIO_PV="15.0"
SDL2_MIXER_PV="2.0.4" # missing in CI
VIRTUAL_WINE_PV="0"
WINE_PV="5.0" # missing in CI
WINE_STAGING_PV="${WINE_PV}"
WINE_VANILLA_PV="${WINE_PV}"
ZLIB_PV="1.2.11"
CDEPEND="
	>=sys-devel/gcc-${GCC_PV}
	>=net-libs/grpc-1.39.1[${MULTILIB_USEDEP}]
	>=dev-libs/protobuf-3.17.3:0/3.21[${MULTILIB_USEDEP}]
"
# libepoxy missing in CI
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

LLVM_SLOTS=( 16 15 14 13 12 )
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

# box2d missing in CI ; DEPENDs not updated in ebuild
# dumb missing in CI
# pcre missing in CI
# gtk2 missing in CI
# kdialog missing in CI
# xinerama missing in CI
# zenity missing in CI
# procps missing in CI
DEPEND+="
	${CDEPEND}
	>=dev-cpp/abseil-cpp-20210324.2:=[${MULTILIB_USEDEP}]
	>=dev-cpp/yaml-cpp-0.6.3[${MULTILIB_USEDEP}]
	>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
	>=dev-libs/double-conversion-3.1.5[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre2-10.39[${MULTILIB_USEDEP},pcre16]
	>=dev-libs/openssl-1.1.1l[${MULTILIB_USEDEP}]
	>=dev-libs/pugixml-1.11.4[${MULTILIB_USEDEP}]
	>=dev-libs/rapidjson-1.1.0
	>=media-libs/glm-${GLM_PV}
	>=media-libs/harfbuzz-2.9.1[${MULTILIB_USEDEP}]
	>=net-dns/c-ares-1.17.2[${MULTILIB_USEDEP}]
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
			=dev-games/box2d-2.3*:2.3[${MULTILIB_USEDEP}]
			=games-engines/box2d-2.3*:2.3.0[${MULTILIB_USEDEP}]
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
		>=gnome-extra/zenity-3.32.0
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
		>=media-libs/dumb-1.2.2[${MULTILIB_USEDEP}]
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
		>=sys-process/procps-3.3.16[${MULTILIB_USEDEP}]
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
	>=dev-util/cmake-3.21.2
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
	use android && check_cross_android
	use macos && check_cross_macos
	use mingw32 && check_cross_mingw32
	use mingw64 && check_cross_mingw64
}

src_prepare() {
	default
	# Typo?
	sed -i -e "s|ANDROIS_LDLIBS|ANDROID_LDLIBS|g" \
		ENIGMAsystem/SHELL/Makefile || die
}

src_unpack() {
	# From https://github.com/enigma-dev/enigma-dev/commits/master@{2023-05-23}
	export EGIT_COMMIT="f30646facfea176aa3ce63e205a7eceebcbfa048" # May 22, 2023
	git-r3_fetch
	git-r3_checkout
	#verify_depends_is_the_same
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
