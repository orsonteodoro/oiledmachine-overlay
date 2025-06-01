# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild corresponds to RadialGM.

# U 20.04

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
BOOST_PV="1.76.0"
BULLET_PV="2.88" # missing in CI
CLANG_PV="12.0.1"
CURL_PV="7.79.0"
CXX_STANDARD="-std=c++17"
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
LLVM_COMPAT=( {16..12} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
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

inherit check-compiler-switch desktop flag-o-matic git-r3 grpc-ver multilib-minimal toolchain-funcs

if [[ "${PV}" =~ "r" ]] ; then
	# From radialgm/submodules in master/head
	EGIT_BRANCH="master"
	EGIT_COMMIT="f30646facfea176aa3ce63e205a7eceebcbfa048" # May 22, 2023
	EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"
else
	SRC_URI=""
	die "FIXME"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
is an open source cross-platform game development environment."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
RESTRICT="mirror"
SLOT="0/radialgm-${EGIT_COMMIT:0:7}" # Required because of grpc/protobuf.
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
box2d bullet clang d3d ds doc externalfuncs +freetype gles2 gles3 gme
gnome gtk2 gtest headless joystick kde network +openal
+opengl +png sdl2 sound test threads vulkan widgets +X xrandr xtest
"
REQUIRED_USE_PLATFORMS="
	|| (
		headless
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
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
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
# The gRPC requirement has been relaxed.
gen_grpc_cdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2=$(grpc_get_protobuf_slot "${s1}")
		echo "
			(
				dev-libs/protobuf:0/${s2}[${MULTILIB_USEDEP}]
				=net-libs/grpc-${s1}*[${MULTILIB_USEDEP}]
			)
		"
	done
}
CDEPEND="
	>=sys-devel/gcc-${GCC_PV}
	|| (
		$(gen_grpc_cdepend)
	)
	dev-libs/protobuf:=
	net-libs/grpc:=
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

gen_clang_deps() {
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				>=llvm-runtimes/libcxx-${s}[${MULTILIB_USEDEP}]
				>=llvm-runtimes/libcxxabi-${s}[${MULTILIB_USEDEP}]
				llvm-core/clang:${s}[${MULTILIB_USEDEP}]
				llvm-core/lld:${s}
				llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
				test? (
					>=dev-debug/lldb-${s}
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
	box2d? (
		|| (
			=games-engines/box2d-2.3*:2.3[${MULTILIB_USEDEP}]
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
		>=media-libs/libsdl2-${LIBSDL2_PV}[${MULTILIB_USEDEP},joystick?,sound?,threads(+)?,vulkan?]
		sound? (
			>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[${MULTILIB_USEDEP},flac,mod,mp3,vorbis]
		)
		X? (
			>=media-libs/libsdl2-${LIBSDL2_PV}[${MULTILIB_USEDEP},opengl?]
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
	>=dev-build/cmake-3.21.2
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	dev-util/patchelf
	clang? (
		$(gen_clang_deps)
	)
	test? (
		>=dev-libs/boost-${BOOST_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
	)
"
DOCS=( "Readme.md" )
PATCHES=(
	"${FILESDIR}/enigma-9999-change-sdl2-audio-linking.patch"
	"${FILESDIR}/enigma-9999-fix-missing-workdir-references.patch"
)

pkg_setup() {
	check-compiler-switch_start
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
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
}

src_prepare() {
	default
}

src_unpack() {
	if [[ "${PV}" =~ "r" ]] ; then
		git-r3_fetch
		git-r3_checkout
		#verify_depends_is_the_same
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
