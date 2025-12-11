# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild corresponds to master tip.

# U 20.04

#
# For some list of dependencies, see
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/install_emake_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/solve_engine_deps.sh
# https://github.com/enigma-dev/enigma-dev/blob/master/CI/build_sdl.sh
# grep -r -F -e "find_library(" -e "find_package("
#
# See CI for *DEPENDs
# Fallback U 22.04.3
ALURE_PV="1.2" # missing in CI
BOX2D_PV_EMAX="2.4" # missing in CI
BOOST_PV="1.83.0"
BULLET_PV="3.06" # missing in CI
CLANG_PV="16.0.6"
CURL_PV="8.3.0"
CXX_STANDARD=17
FLAC_PV="1.4.3"
FREETYPE_PV="2.13.2"
GCC_PV="13.2.1" # Upstream uses 12.1.0 for Linux.  This has been relaxed in this ebuild.
GLEW_PV="2.2.0" # missing in CI
GLM_PV="0.9.9.8" # missing in CI
GME_PV="0.6.3" # missing in CI
GTEST_PV="1.10.0" # missing in CI
GTK2_PV="2.24.33" # missing in CI
LIBFFI_PV="3.4.2" # missing in CI
LIBMODPLUG_PV="0.8.9.0"
LIBOGG_PV="1.3.5"
LIBPNG_PV="1.6.40"
LIBSDL2_PV="2.28.4"
LIBSNDFILE_PV="1.2.2"
LIBVORBIS_PV="1.3.7"
LIBX11_PV="1.8.7"
MESA_PV="23.2.1"
MPG123_PV="1.32.2"
OPENAL_PV="1.23.1"
OPUS_PV="1.4"
PULSEAUDIO_PV="16.1"
SDL2_MIXER_PV="2.0.4" # missing in CI
VIRTUAL_WINE_PV="0"
WINE_PV="6.0.3" # missing in CI
WINE_STAGING_PV="${WINE_PV}"
WINE_VANILLA_PV="${WINE_PV}"
ZLIB_PV="1.3"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)
LLVM_MAX_SLOT="19"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit abseil-cpp check-compiler-switch desktop flag-o-matic git-r3 grpc
inherit libcxx-slot libstdcxx-slot protobuf re2 toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"
	if [[ "${PV}" =~ "9999" ]] ; then
		FALLBACK_COMMIT="57d6edbdcf2bfade3a8dbb4ee75a721a468d8069" # Jul 14, 2025
		IUSE+=" fallback-commit"
	else
		EGIT_COMMIT=""
	fi
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, \
is an open source cross-platform game development environment."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
RESTRICT="mirror"
SLOT="0"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
box2d bullet clang d3d ds doc externalfuncs +freetype gles2 gles3 gme
gnome gtk2 headless joystick kde network +openal
+opengl +png sdl2 sound test threads vulkan widgets +X xrandr xtest
ebuild_revision_11
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
DEPEND="
"
# libepoxy missing in CI
GLES_DEPEND="
	>=media-libs/libepoxy-1.5.4
	>=media-libs/mesa-${MESA_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-libs/mesa:=
"
OPENGL_DEPEND="
	>=media-libs/glew-${GLEW_PV}
	>=media-libs/mesa-${MESA_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-libs/mesa:=
"

gen_clang_deps() {
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				>=llvm-runtimes/libcxx-${s}
				>=llvm-runtimes/libcxxabi-${s}
				llvm-core/clang:${s}
				llvm-core/clang:=
				llvm-core/lld:${s}
				llvm-core/lld:=
				llvm-core/llvm:${s}
				llvm-core/llvm:=
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
RDEPEND+="
	>=dev-cpp/yaml-cpp-0.8.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-${BOOST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/double-conversion-3.3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/double-conversion:=
	>=dev-libs/libpcre2-10.39[pcre16]
	>=dev-libs/openssl-3.1.3
	>=dev-libs/pugixml-1.14[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/pugixml:=
	>=media-libs/harfbuzz-8.2.1
	>=net-dns/c-ares-1.20.1
	>=sys-libs/zlib-${ZLIB_PV}
	virtual/jpeg
	virtual/libc
	|| (
		(
			dev-cpp/abseil-cpp:20200225[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			net-libs/grpc:3/1.30[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
		(
			dev-cpp/abseil-cpp:20250512[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			net-libs/grpc:6/1.75[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
	dev-cpp/abseil-cpp:=
	net-libs/grpc:=
	box2d? (
		|| (
			<games-engines/box2d-2.4:2.3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			<games-engines/box2d-2.4:2.3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
	games-engines/box2d:=
	bullet? (
		>=sci-physics/bullet-${BULLET_PV}
	)
	externalfuncs? (
		>=dev-libs/libffi-${LIBFFI_PV}
	)
	freetype? (
		>=media-libs/freetype-${FREETYPE_PV}[static-libs]
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
		>=media-libs/game-music-emu-${GME_PV}
	)
	gnome? (
		>=gnome-extra/zenity-3.42.0
	)
	gtk2? (
		>=x11-libs/gtk+-2.24.33:2
		x11-libs/gtk+:=
	)
	kde? (
		>=kde-apps/kdialog-21.12.3
	)
	network? (
		>=net-misc/curl-${CURL_PV}
	)
	openal? (
		>=media-libs/alure-${ALURE_PV}[dumb,vorbis]
		>=media-libs/dumb-0.9.3
		>=media-libs/libvorbis-${LIBVORBIS_PV}
		>=media-libs/openal-${OPENAL_PV}
	)
	opengl? (
		${OPENGL_DEPEND}
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}
		>=sys-libs/zlib-${ZLIB_PV}
	)
	sdl2? (
		>=media-libs/libsdl2-${LIBSDL2_PV}[joystick?,sound?,threads(+)?,vulkan?]
		sound? (
			>=media-libs/sdl2-mixer-${SDL2_MIXER_PV}[flac,mod,mp3,vorbis]
		)
		X? (
			>=media-libs/libsdl2-${LIBSDL2_PV}[opengl?]
		)
	)
	X? (
		>=sys-libs/zlib-${ZLIB_PV}
		>=sys-process/procps-4.0.4
		>=x11-libs/libX11-${LIBX11_PV}
		>=x11-libs/libXinerama-1.1.4
		xrandr? (
			>=x11-libs/libXrandr-1.5.4
		)
		xtest? (
			>=x11-libs/libXtst-1.2.4
		)
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-libs/rapidjson-1.1.0
	dev-libs/rapidjson:=
	gles2? (
		>=media-libs/glm-${GLM_PV}
		media-libs/glm:=
	)
	gles3? (
		>=media-libs/glm-${GLM_PV}
		media-libs/glm:=
	)
"
BDEPEND+="
	>=dev-build/cmake-3.27.7
	>=dev-util/pkgconf-1.8.1[pkg-config(+)]
	dev-util/patchelf
	|| (
		(
			dev-cpp/abseil-cpp:20200225[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			dev-go/protoc-gen-go-grpc:3
			net-libs/grpc:3/1.30[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
		(
			dev-cpp/abseil-cpp:20250512[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			dev-go/protoc-gen-go-grpc:6
			net-libs/grpc:6/1.75[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
	dev-cpp/abseil-cpp:=
	dev-go/protoc-gen-go-grpc:=
	net-libs/grpc:=
	clang? (
		$(gen_clang_deps)
	)
	test? (
		>=dev-libs/boost-${BOOST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
		>=dev-cpp/gtest-${GTEST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-cpp/gtest:=
		>=x11-libs/libX11-${LIBX11_PV}
	)
"
DOCS=( "Readme.md" )
PATCHES=(
	"${FILESDIR}/${PN}-9999-change-sdl2-audio-linking.patch"
	"${FILESDIR}/${PN}-9999-fix-missing-workdir-references.patch"
	"${FILESDIR}/${PN}-9999-57d6edb-enigma-multislot-flags.patch"
)

pkg_setup() {
	check-compiler-switch_start
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	default
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if has fallback-commit $IUSE_EFFECTIVE && use fallback-commit ; then
			export EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	if tc-is-clang ; then
ewarn "Clang support is broken.  Switching to GCC"
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CC} -E"
	fi

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if has_version "dev-libs/protobuf:3/3.12" ; then
	# Enigma slot equivalent being CI tested
		ABSEIL_CPP_SLOT="20200225"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
		RE2_SLOT="20220623"
	elif has_version "dev-libs/protobuf:6/6.33" ; then
	# Enigma slot equivalent being CI tested
		ABSEIL_CPP_SLOT="20250512"
		GRPC_SLOT="6"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
		RE2_SLOT="20250512"
	fi
	pushd "${ENIGMA_INSTALL_DIR}" >/dev/null 2>&1 || die
		LD_LIBRARY_PATH="$(pwd):${LD_LIBRARY_PATH}" ./emake --help \
			| grep -q -F -e "--server"
		if [[ "$?" != "0" ]] ; then
eerror
eerror "Your enigma is not built with --server.  Re-emerge with the radialgm"
eerror "USE flag.  Enigma must be built against the same abseil-cpp version"
eerror "installed."
eerror
			die
		fi
	popd >/dev/null 2>&1 || die
	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure

	export PROTOBUF_CXXFLAGS=$(PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)/pkgconfig:${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}" pkg-config --cflags protobuf)
	export GRPC_CXXFLAGS=$(PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/$(get_libdir)/pkgconfig:${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}:${PKG_CONFIG_PATH}" pkg-config --cflags grpc)
	export PROTOBUF_LDFLAGS=$(PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)/pkgconfig:${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}:${PKG_CONFIG_PATH}" pkg-config --libs-only-L protobuf)\
" -Wl,-rpath=/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)"
	export GRPC_LDFLAGS=$(PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/$(get_libdir)/pkgconfig:${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}:${PKG_CONFIG_PATH}" pkg-config --libs-only-L grpc)\
" -Wl,-rpath=/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/$(get_libdir) -Wl,-rpath=/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)"
	export PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
einfo "PROTOBUF_CXXFLAGS:  ${PROTOBUF_CXXFLAGS}"
einfo "GRPC_CXXFLAGS:  ${GRPC_CXXFLAGS}"
einfo "PROTOBUF_LDFLAGS:  ${PROTOBUF_LDFLAGS}"
einfo "GRPC_LDFLAGS:  ${GRPC_LDFLAGS}"
einfo "PATH:  ${PATH}"
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
	local install_dir="/usr/lib/enigma"
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
	insinto "/usr/lib/${PN}/CommandLine"
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
		patchelf --add-rpath "/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/re2/${RE2_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/$(get_libdir)" "${p}" || die
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
