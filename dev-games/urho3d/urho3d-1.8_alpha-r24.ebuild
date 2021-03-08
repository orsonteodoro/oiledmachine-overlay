# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

STATIC_LIBS_CUSTOM_LIB_TYPE_IMPL="module"
STATIC_LIBS_CUSTOM_LIB_TYPE_IUSE="+module"
CMAKE_MAKEFILE_GENERATOR=emake
LLVM_MAX_SLOT=9
inherit cmake-utils eutils flag-o-matic linux-info llvm multilib-minimal static-libs urho3d

DESCRIPTION="Cross-platform 2D and 3D game engine."
HOMEPAGE="http://urho3d.github.io/"
LICENSE="MIT" # Applies to this project, and internal civetweb, ik, lua, luajit,
# nanodbc, pugixml, rapidjson, slikenet, tolua.  Some of the third party
# modules listed in the Source/ThirdParty folder use a different license
# and are listed below.

# The ZLIB license applies to internal angelscript, box2d, bullet, detour,
# mojoshader, sdl
LICENSE+=" ZLIB"

# Applies to internal freetype
LICENSE+=" FTL"

# Applies to internal boost, mustache
LICENSE+=" Boost-1.0"

# Applies to internal assimp, GLEW, rapidjson, stanhull, webp
LICENSE+=" BSD"

# Applies to internal LZ4, libcupid
LICENSE+=" BSD-2"

# Applies to the bin/Data/Fonts folder
LICENSE+=" OFL-1.1"

# Applies to internal sqlite, stb.  Commented out to avoid confusion that the
# entire package is changed to public domain.
#LICENSE+=" public-domain"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~arm ~arm64"
SLOT="0/${PV}"
X86_CPU_FEATURES_RAW=( 3dnow mmx sse sse2 )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
IUSE+=" ${X86_CPU_FEATURES[@]%:*}
	 X
	 abi_mips_n64
	 alsa
	 altivec
	 android
	+angelscript
	 bindings
	+box2d
	+box2d_2_3
	 box2d_2_4
	+bullet
	-check-pedantic-requirements
	-clang-tools
	 dbus
	 debug
	-debug-raw-script-loader
	-doc
	 esd
	-extras
	+filewatcher
	 gles2
	 haptic
	+hidapi
	 ibus
	 libusb
	 libsamplerate
	+ik
	 jack
	+joystick
	 kms
	+logging
	+lua
	-luajit
	 nas
	 native
	+network
	-odbc
	+opengl
	 oss
	 pch
	+profiling
	 pulseaudio
	+recastnavigation
	+samples
	+sdl_audio_dummy
	+sdl_cpuinfo
	+sdl_audio_disk
	+sdl_dlopen
	+sdl_power
	-sdl_render
	+sdl_sensor
	+sdl_file
	+sdl_filesystem
	+sdl_video_dummy
	 sndio
	 sqlite
	 sound
	 static-libs
	 system-angelscript
	 system-assimp
	 system-boost
	 system-box2d
	 system-bullet
	 system-civetweb
	 system-freetype
	 system-glew
	 system-slikenet
	 system-libcpuid
	 system-lua
	 system-luajit
	 system-lz4
	 system-mojoshader
	 system-nanodbc
	 system-pugixml
	 system-rapidjson
	 system-recastnavigation
	 system-sdl
	 system-sqlite
	 system-webp
	 test
	+threads
	+tools
	 tslib
	 udev
	 video_cards_vc4
	 video_cards_vivante
	 vulkan
	 wayland
	+webp
	 xinerama
	 xscreensaver"

# Partly from the libsdl2-2.0.12-r2.ebuild
SDL2_REQUIRED_USE="
	android? ( sound? ( threads alsa ) )
	ibus? ( dbus )
	native? ( sound? ( threads alsa ) )
	rpi? ( sound? ( threads alsa ) )
	wayland? ( gles2 )
	xinerama? ( X )
	xscreensaver? ( X )"

#	native
REQUIRED_USE+="
	${SDL2_REQUIRED_USE}
	alsa? ( sound threads )
	bindings? ( !pch )
	box2d? ( ^^ ( box2d_2_3 box2d_2_4 ) )
        clang-tools? ( !pch
		angelscript bullet filewatcher ik logging lua profiling network recastnavigation sqlite
		!test !luajit !odbc
	)
	cpu_flags_x86_3dnow? ( !cpu_flags_x86_sse !cpu_flags_x86_mmx )
	cpu_flags_x86_mmx? ( !cpu_flags_x86_3dnow !cpu_flags_x86_sse )
	cpu_flags_x86_sse? ( !cpu_flags_x86_3dnow !cpu_flags_x86_mmx )
	!haptic? ( libusb )
	haptic? ( joystick )
	joystick
	joystick? (
		android? ( hidapi )
		native? ( || ( libusb hidapi ) )
	)
	luajit? ( lua )

	network? ( threads )
	odbc? ( !sqlite )
	opengl
	sqlite? ( !odbc )
	!system-slikenet
	 system-box2d? ( ^^ ( box2d_2_3 box2d_2_4 ) )
	!system-box2d? ( box2d_2_3 !box2d_2_4 )
	web? ( module )"

BOOST_VER="1.64"
CIVETWEB_VER="1.7"
LLVM_SLOT="9"
LUA_VER="5.1"
LUAJIT_VER="2.1"
SDL_VER="2.0.10"

# This lists the internal SDL requirements.
# Copied from the libsdl2-2.0.12-r2.ebuild with changes
# Removed fcitx4 row
SDL2_CDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},gles2] )
	ibus? ( app-i18n/ibus )
	joystick? (
		hidapi? ( dev-libs/hidapi )
		libusb? ( dev-libs/libusb )
	)
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	kms? (
		>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.0.0[${MULTILIB_USEDEP},gbm]
	)
	libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	)
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio[${MULTILIB_USEDEP}] )
	tslib? ( >=x11-libs/tslib-1.0-r3[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},egl,gles2,wayland]
		>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
		xscreensaver? ( >=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}] )
	)"
SDL2_RDEPEND="${SDL2_CDEPEND}
	vulkan? ( media-libs/vulkan-loader )"
SDL2_DEPEND="${SDL2_CDEPEND}
	vulkan? ( dev-util/vulkan-headers )
	X? ( x11-base/xorg-proto )"
DEPEND_COMMON="
	angelscript? (
		system-angelscript? (
			>=dev-libs/angelscript-2.33:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
	box2d? ( system-box2d? (
		box2d_2_4? (
			|| ( >=dev-games/box2d-2.4.1:2.4=[${MULTILIB_USEDEP},static-libs?]
			     >=games-engines/box2d-2.4.1:2.4.0[${MULTILIB_USEDEP}] )
		)
		box2d_2_3? (
			|| ( >=dev-games/box2d-2.3.1:2.3=[${MULTILIB_USEDEP},static-libs?]
			     >=games-engines/box2d-2.3.1:2.3.0[${MULTILIB_USEDEP}] )
		)
	) )
	bullet? ( system-bullet? ( >=sci-physics/bullet-2.86.1[${MULTILIB_USEDEP}] ) )
	lua? (
		 system-lua? ( >=dev-lang/lua-5.1:${LUA_VER}=[${MULTILIB_USEDEP},urho3d] )
	)
	recastnavigation? (
		system-recastnavigation? (
			dev-games/recastnavigation:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
	sqlite? (
		system-sqlite? (
			>=dev-db/sqlite-3.20.1:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
	system-freetype? ( >=media-libs/freetype-2.8:=[${MULTILIB_USEDEP},static-libs?] )
	system-lz4? ( >=app-arch/lz4-1.7.5[${MULTILIB_USEDEP}] )
	system-pugixml? ( >=dev-libs/pugixml-1.7:=[${MULTILIB_USEDEP},static-libs?] )
	system-rapidjson? ( >=dev-libs/rapidjson-1.1 )
	system-sdl? ( >=media-libs/libsdl2-${SDL_VER}:=[${MULTILIB_USEDEP},X?,\
alsa?,cpu_flags_x86_3dnow?,cpu_flags_x86_mmx?,cpu_flags_x86_sse?,\
cpu_flags_x86_sse2?,dbus?,gles2?,haptic?,ibus?,joystick?,kms?,libsamplerate?,nas?,\
opengl?,oss?,pulseaudio?,sound?,threads?,tslib?,static-libs?,video,vulkan?,\
wayland?,xinerama?,xscreensaver?] )
	!system-sdl? ( ${SDL2_DEPEND} )
	system-webp? ( >=media-libs/libwebp-0.6:=[static-libs?] )"
DEPEND_ANDROID="
	android? (
		dev-java/gradle-bin
		dev-util/android-ndk
		lua? (
			 system-luajit? ( luajit? ( >=dev-lang/luajit-2.1:2[static-libs,urho3d] ) )
		)
		network? (
			system-civetweb? ( >=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1] )
			system-slikenet? (   net-libs/slikenet[${MULTILIB_USEDEP}] )
		)
		system-boost? ( >=dev-libs/boost-${BOOST_VER} )
	)"
DEPEND_WEB="
	web? (
	      >=dev-util/emscripten-1.36.10[wasm(+)]
	      >=sys-devel/llvm-3.9.0:${LLVM_SLOT}[${MULTILIB_USEDEP}]
		system-boost? ( >=dev-libs/boost-${BOOST_VER} )
	)"
DEPEND_NATIVE="
	native? (
		lua? (
			 system-luajit? ( luajit? ( >=dev-lang/luajit-2.1:2[static-libs,urho3d] ) )
		)
		network? (
			system-civetweb? ( >=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1] )
			system-slikenet? (   net-libs/slikenet[${MULTILIB_USEDEP}] )
		)
		odbc? (
			system-nanodbc? (
				>=dev-db/nanodbc-2.12.4:=[${MULTILIB_USEDEP},\
-libcxx,boost_convert,static-libs?,-unicode]
				  dev-db/unixODBC[${MULTILIB_USEDEP}]
			)
		)
		opengl? (
			system-glew? ( >=media-libs/glew-1.13:=[${MULTILIB_USEDEP},static-libs?] )
			system-libcpuid? ( >=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}] )
		)
		!opengl? (
			system-mojoshader? ( media-libs/mojoshader:=[static-libs?] )
			system-libcpuid? ( >=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}] )
		)
		tools? (
			system-assimp? (
				>=media-libs/assimp-4.1:=[${MULTILIB_USEDEP},static-libs?]
			)
		)
	)"
DEPEND_RPI="
	rpi? (  lua? (
			 system-luajit? ( luajit? ( >=dev-lang/luajit-2.1:2[static-libs,urho3d] ) )
		)
		network? (
			system-civetweb? ( >=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1] )
			system-slikenet? (   net-libs/slikenet[${MULTILIB_USEDEP}] )
		)
		opengl? (
			system-glew? ( >=media-libs/glew-1.13:=[${MULTILIB_USEDEP},static-libs?] )
			system-libcpuid? ( >=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}] )
		)
		!opengl? (
			system-mojoshader? ( media-libs/mojoshader:=[static-libs?] )
			system-libcpuid? ( >=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}] )
		)
		system-boost? ( >=dev-libs/boost-${BOOST_VER} )
		tools? (
			system-assimp? (
				>=media-libs/assimp-4.1:=[${MULTILIB_USEDEP},static-libs?]
			)
		)
	)"
DEPEND+=" ${DEPEND_COMMON}
	${DEPEND_RPI}
	${DEPEND_ANDROID}
	${DEPEND_NATIVE}
	${DEPEND_WEB}
	bindings? ( sys-devel/llvm:${LLVM_SLOT}[${MULTILIB_USEDEP}] )
	clang-tools? ( sys-devel/llvm:${LLVM_SLOT}[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND_COMMON}
	${DEPEND_RPI}
	${DEPEND_ANDROID}
	${DEPEND_NATIVE}
	${DEPEND_WEB}
	!system-sdl? ( ${SDL2_RDEPEND} )
	bindings? ( sys-devel/llvm:${LLVM_SLOT}[${MULTILIB_USEDEP}] )
	clang-tools? ( sys-devel/llvm:${LLVM_SLOT}[${MULTILIB_USEDEP}] )"
BDEPEND+=" >=dev-util/cmake-3.2.3"
RESTRICT="mirror"
EGIT_COMMIT="d34dda158ecd7694fcfd55684caade7e131b8a45"
SRC_URI=\
"https://github.com/urho3d/Urho3D/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/Urho3D-${EGIT_COMMIT}"
EPATCH_OPTS="--binary -p1"

pkg_setup() {
	if use clang-tools || use bindings ; then
		llvm_pkg_setup
	fi

	if use hidapi ; then
		linux-info_pkg_setup
		if ! linux_config_src_exists ; then
			ewarn "Missing kernel .config file.  Do \`make menuconfig\` and save it to fix this."
		fi
		if ! linux_chkconfig_present HIDRAW ; then
			ewarn "You must have CONFIG_HIDRAW enabled in the kernel for hidraw joystick/controller support."
		fi
	fi

	if use android ; then
		if [[ -z "${URHO3D_TARGET_ANDROID_SDK_VERSION}" ]] ; then
			ewarn "URHO3D_TARGET_ANDROID_SDK_VERSION needs to be set as a per-package environmental variable"
		fi
		if [[ -z "${URHO3D_ANDROID_CONFIG[@]}" ]] ; then
			die "URHO3D_ANDROID_CONFIG needs to be set as a per-package environmental variable"
		fi
		ewarn "This feature has not been tested."
	fi
	if use rpi ; then
		if [[ -z "${URHO3D_RPI_CONFIG[@]}" ]] ; then
			die "URHO3D_RPI_CONFIG needs to be set as a per-package environmental variable"
		fi
		ewarn "This feature has not been tested."
	fi
	if use native ; then
	        if use debug; then
	                if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
	                        die \
"Emerge again with FEATURES=\"nostrip\" or remove the debug use flag"
	                fi
	        fi

		if use native; then
			if use check-pedantic-requirements ; then
				glxinfo | grep  EXT_framebuffer_object &>/dev/null
				if [[ "$?" != "0" ]]; then
					die \
"Video card not supported.  Your machine does not meet the minimum requirements."
				fi
				glxinfo | grep EXT_packed_depth_stencil &>/dev/null
				if [[ "$?" != "0" ]]; then
					die \
"Video card not supported.  Your machine does not meet the minimum requirements."
				fi
				cat /proc/cpuinfo | grep sse &>/dev/null
				if [[ "$?" != "0" ]]; then
					die \
"CPU not supported.  Your machine does not meet the minimum requirements."
				fi
			fi
		fi
	fi
	if use web ; then
		if [[ -n "${EMCC_WASM_BACKEND}" && "${EMCC_WASM_BACKEND}" == "1" ]] ; then
			:;
		else
			die \
"You must switch your emscripten to wasm.  See \`eselect emscripten\` for \
details."
		fi

		if eselect emscripten 2>/dev/null 1>/dev/null ; then
			if eselect emscripten list | grep -F -e "*" \
				| grep -q -F -e "llvm" ; then
				:;
			else
				die \
"You must switch your emscripten to wasm.  See \`eselect emscripten\` for \
details."
			fi
		fi
		if [[ -z "${EMSCRIPTEN}" ]] ; then
			die "EMSCRIPTEN environmental variable must be set"
		fi

		local emcc_v=$(emcc --version | head -n 1 | grep -E -o -e "[0-9.]+")
		local emscripten_v=$(echo "${EMSCRIPTEN}" | cut -f 2 -d "-")
		if [[ "${emcc_v}" != "${emscripten_v}" ]] ; then
			die "EMCC_V=${emcc_v} != EMSCRIPTEN_V=${emscripten_v}.  A \`eselect emscripten set <#>\` followed by \`source . /etc/profile\` are required."
		fi
	fi
}

_prepare_common() {
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-testing-preprocessor.patch"
	#die "See ${FILESDIR}/urho3d-1.8_alpha-cmake-fixes.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-cmake-fixes.patch"

	# See https://github.com/orsonteodoro/oiledmachine-overlay/blob/47e071977b37023c07f612ecaebf235982a457c9/dev-libs/urho3d/urho3d-1.7.ebuild
	# for original code if results from conversion breaks

	# what a line ending mess, it uses both unix (\n) and dos (\r\n).
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-angelscript.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-box2d.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-bullet-crlf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-bullet-lf.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_remove_isVisible_for_system_bullet.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-detour.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-glew.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-libcpuid.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-lz4-crlf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-lz4-lf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-nanodbc.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-pugixml-crlf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-pugixml-lf.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-sdl-crlf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-sdl-lf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-not-sdl.patch"  # testing
	eapply "${FILESDIR}/urho3d-1.8_alpha-system-sqlite.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-civetweb.patch"
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-stanhull-visibility-default-crlf.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-lua-fix-export.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-autobinder-llvm-9-compat.patch"

	local files_box2d_lines=(
		bin/Data/LuaScripts/28_Urho2DPhysicsRope.lua
		bin/Data/LuaScripts/32_Urho2DConstraints.lua
		bin/Data/Scripts/28_Urho2DPhysicsRope.as
		bin/Data/Scripts/32_Urho2DConstraints.as
		bin/Data/UI/EditorIcons.xml
		Docs/AngelScriptAPI.h
		Docs/LuaScriptAPI.dox
		Docs/Reference.dox
		Docs/ScriptAPI.dox
		Source/Urho3D/LuaScript/pkgs/Urho2D/Constraint2D.pkg
		Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintDistance2D.pkg
		Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintMouse2D.pkg
		Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintWeld2D.pkg
		Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintWheel2D.pkg
		Source/Urho3D/LuaScript/pkgs/Urho2DLuaAPI.pkg
	)

	if use box2d_2_4 && [[ "${EURHO3D}" != "web" ]] ; then
		rm Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintRope2D.pkg \
			Source/Urho3D/Urho2D/ConstraintRope2D.cpp \
			|| die

		for f in ${files_box2d_lines[@]} ; do
				sed -i -e "/BOX2D_2_3/d" \
					-e "s| //BOX2D_2_4||g" \
					${f} || die
			done
	else
		for f in ${files_box2d_lines[@]} ; do
				sed -i -e "/BOX2D_2_4/d" \
					-e "s| //BOX2D_2_3||g" \
					${f} || die
			done
	fi

	local files_system_box2d_lines=(
		Docs/LuaScriptAPI.dox
		Docs/ScriptAPI.dox
	)

	if use system-box2d && [[ "${EURHO3D}" != "web" ]] ; then
		rm -rf Source/ThirdParty/Box2D || die
		for f in ${files_system_box2d_lines[@]} ; do
				sed -i -e "/URHO3D_SYSTEM_BOX2D/d" \
					${f} || die
			done
	else
		for f in ${files_system_box2d_lines[@]} ; do
				sed -i -e "s| //\!URHO3D_SYSTEM_BOX2D||" \
					${f} || die
			done
	fi
}

src_prepare() {
	default

	prepare_common() {
		_prepare_common

		SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
		cmake-utils_src_prepare
	}

	prepare_platform() {
		cd "${BUILD_DIR}" || die
		prepare_abi() {
			cd "${BUILD_DIR}" || die
			static-libs_prepare() {
				einfo "In static-libs_prepare"
				cd "${BUILD_DIR}" || die
				if [[ "${EURHO3D}" == "android" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					prepare_common
				elif [[ "${EURHO3D}" == "native" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					prepare_common
				elif [[ "${EURHO3D}" == "rpi" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					prepare_common
				elif [[ "${EURHO3D}" == "web" && "${ESTSH_LIB_TYPE}" == "module" ]] ; then
					prepare_common
				fi
			}
			einfo "Called static-libs_copy_sources"
			static-libs_copy_sources
			static-libs_foreach_impl \
				static-libs_prepare
		}
		einfo "Called multilib_copy_sources"
		multilib_copy_sources
		multilib_foreach_abi prepare_abi
	}
	einfo "Called urho3d_copy_sources"
	urho3d_copy_sources
	urho3d_foreach_impl \
		prepare_platform
}

# From cmake-utils.eclass originally as cmake-utils_src_configure
# Modified to use urho3d Toolchain .cmake files
# @FUNCTION: _cmake-utils_src_configure
# @DESCRIPTION:
# General function for configuring with cmake. Default behaviour is to start an
# out-of-source build.
_cmake-utils_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ! ${_CMAKE_UTILS_SRC_PREPARE_HAS_RUN} ]]; then
		if [[ ${EAPI} != [56] ]]; then
			die "FATAL: cmake-utils_src_prepare has not been run"
		else
			eqawarn "cmake-utils_src_prepare has not been run, please open a bug on https://bugs.gentoo.org/"
		fi
	fi

	[[ ${EAPI} == 5 ]] && _cmake_cleanup_cmake

	_cmake_check_build_dir

	# Fix xdg collision with sandbox
	xdg_environment_reset

	# @SEE CMAKE_BUILD_TYPE
	if [[ ${CMAKE_BUILD_TYPE} = Gentoo ]]; then
		# Handle release builds
		if ! has debug ${IUSE//+} || ! use debug; then
			local CPPFLAGS=${CPPFLAGS}
			append-cppflags -DNDEBUG
		fi
	fi

	# Prepare Gentoo override rules (set valid compiler, append CPPFLAGS etc.)
	local build_rules=${BUILD_DIR}/gentoo_rules.cmake

	cat > "${build_rules}" <<- _EOF_ || die
		SET (CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "ASM compile command" FORCE)
		SET (CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c -x assembler <SOURCE>" CACHE STRING "ASM-ATT compile command" FORCE)
		SET (CMAKE_ASM-ATT_LINK_FLAGS "-nostdlib" CACHE STRING "ASM-ATT link flags" FORCE)
		SET (CMAKE_C_COMPILE_OBJECT "<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C compile command" FORCE)
		SET (CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C++ compile command" FORCE)
		SET (CMAKE_Fortran_COMPILE_OBJECT "<CMAKE_Fortran_COMPILER> <DEFINES> <INCLUDES> ${FCFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "Fortran compile command" FORCE)
	_EOF_

	local myCC=$(tc-getCC) myCXX=$(tc-getCXX) myFC=$(tc-getFC)

	# !!! IMPORTANT NOTE !!!
	# Single slash below is intentional. CMake is weird and wants the
	# CMAKE_*_VARIABLES split into two elements: the first one with
	# compiler path, and the second one with all command-line options,
	# space separated.
	local toolchain_file=${BUILD_DIR}/gentoo_toolchain.cmake
	cat > ${toolchain_file} <<- _EOF_ || die
		SET (CMAKE_ASM_COMPILER "${myCC/ /;}")
		SET (CMAKE_ASM-ATT_COMPILER "${myCC/ /;}")
		SET (CMAKE_C_COMPILER "${myCC/ /;}")
		SET (CMAKE_CXX_COMPILER "${myCXX/ /;}")
		SET (CMAKE_Fortran_COMPILER "${myFC/ /;}")
		SET (CMAKE_AR $(type -P $(tc-getAR)) CACHE FILEPATH "Archive manager" FORCE)
		SET (CMAKE_RANLIB $(type -P $(tc-getRANLIB)) CACHE FILEPATH "Archive index generator" FORCE)
		SET (CMAKE_SYSTEM_PROCESSOR "${CHOST%%-*}")
	_EOF_

	# We are using the C compiler for assembly by default.
	local -x ASMFLAGS=${CFLAGS}
	local -x PKG_CONFIG=$(tc-getPKG_CONFIG)

	if tc-is-cross-compiler; then
		local sysname
		case "${KERNEL:-linux}" in
			Cygwin) sysname="CYGWIN_NT-5.1" ;;
			HPUX) sysname="HP-UX" ;;
			linux) sysname="Linux" ;;
			Winnt)
				sysname="Windows"
				cat >> "${toolchain_file}" <<- _EOF_ || die
					SET (CMAKE_RC_COMPILER $(tc-getRC))
				_EOF_
				;;
			*) sysname="${KERNEL}" ;;
		esac

		cat >> "${toolchain_file}" <<- _EOF_ || die
			SET (CMAKE_SYSTEM_NAME "${sysname}")
		_EOF_

		if [ "${SYSROOT:-/}" != "/" ] ; then
			# When cross-compiling with a sysroot (e.g. with crossdev's emerge wrappers)
			# we need to tell cmake to use libs/headers from the sysroot but programs from / only.
			cat >> "${toolchain_file}" <<- _EOF_ || die
				SET (CMAKE_FIND_ROOT_PATH "${SYSROOT}")
				SET (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
				SET (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
				SET (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
			_EOF_
		fi
	fi

	if use prefix-guest; then
		cat >> "${build_rules}" <<- _EOF_ || die
			# in Prefix we need rpath and must ensure cmake gets our default linker path
			# right ... except for Darwin hosts
			IF (NOT APPLE)
			SET (CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
			SET (CMAKE_PLATFORM_REQUIRED_RUNTIME_PATH "${EPREFIX}/usr/${CHOST}/lib/gcc;${EPREFIX}/usr/${CHOST}/lib;${EPREFIX}/usr/$(get_libdir);${EPREFIX}/$(get_libdir)"
			CACHE STRING "" FORCE)

			ELSE ()

			SET (CMAKE_PREFIX_PATH "${EPREFIX}/usr" CACHE STRING "" FORCE)
			SET (CMAKE_MACOSX_RPATH ON CACHE BOOL "" FORCE)
			SET (CMAKE_SKIP_BUILD_RPATH OFF CACHE BOOL "" FORCE)
			SET (CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
			SET (CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)

			ENDIF (NOT APPLE)
		_EOF_
	fi

	# Common configure parameters (invariants)
	local common_config=${BUILD_DIR}/gentoo_common_config.cmake
	local libdir=$(get_libdir)
	cat > "${common_config}" <<- _EOF_ || die
		SET (CMAKE_GENTOO_BUILD ON CACHE BOOL "Indicate Gentoo package build")
		SET (LIB_SUFFIX ${libdir/lib} CACHE STRING "library path suffix" FORCE)
		SET (CMAKE_INSTALL_LIBDIR ${libdir} CACHE PATH "Output directory for libraries")
		SET (CMAKE_INSTALL_INFODIR "${EPREFIX}/usr/share/info" CACHE PATH "")
		SET (CMAKE_INSTALL_MANDIR "${EPREFIX}/usr/share/man" CACHE PATH "")
		SET (CMAKE_USER_MAKE_RULES_OVERRIDE "${build_rules}" CACHE FILEPATH "Gentoo override rules")
	_EOF_

	# See bug 689410
	if [[ "${ARCH}" == riscv ]]; then
		echo 'SET (CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX '"${libdir#lib}"' CACHE STRING "library search suffix" FORCE)' >> "${common_config}" || die
	fi

	[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && echo 'SET (CMAKE_COLOR_MAKEFILE OFF CACHE BOOL "pretty colors during make" FORCE)' >> "${common_config}"

	if [[ ${EAPI} != [56] ]]; then
		cat >> "${common_config}" <<- _EOF_ || die
			SET (CMAKE_INSTALL_DOCDIR "${EPREFIX}/usr/share/doc/${PF}" CACHE PATH "")
			SET (BUILD_SHARED_LIBS ON CACHE BOOL "")
		_EOF_
	fi

	# Wipe the default optimization flags out of CMake
	if [[ ${CMAKE_BUILD_TYPE} != Gentoo && ${EAPI} != 5 ]]; then
		cat >> ${common_config} <<- _EOF_ || die
			SET (CMAKE_ASM_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_ASM-ATT_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_EXE_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_MODULE_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_SHARED_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			SET (CMAKE_STATIC_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
		_EOF_
	fi

	# Convert mycmakeargs to an array, for backwards compatibility
	# Make the array a local variable since <=portage-2.1.6.x does not
	# support global arrays (see bug #297255).
	local mycmakeargstype=$(declare -p mycmakeargs 2>&-)
	if [[ "${mycmakeargstype}" != "declare -a mycmakeargs="* ]]; then
		if [[ -n "${mycmakeargstype}" ]] ; then
			if [[ ${EAPI} == 5 ]]; then
				eqawarn "Declaring mycmakeargs as a variable is deprecated. Please use an array instead."
			else
				die "Declaring mycmakeargs as a variable is banned in EAPI=${EAPI}. Please use an array instead."
			fi
		fi
		local mycmakeargs_local=(${mycmakeargs})
	else
		local mycmakeargs_local=("${mycmakeargs[@]}")
	fi

	if [[ ${CMAKE_WARN_UNUSED_CLI} == no ]] ; then
		local warn_unused_cli="--no-warn-unused-cli"
	else
		local warn_unused_cli=""
	fi

	# Common configure parameters (overridable)
	# NOTE CMAKE_BUILD_TYPE can be only overridden via CMAKE_BUILD_TYPE eclass variable
	# No -DCMAKE_BUILD_TYPE=xxx definitions will be in effect.
	local cmakeargs=(
		${warn_unused_cli}
		-C "${common_config}"
		-G "$(_cmake_generator_to_use)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		"${mycmakeargs_local[@]}"
		-DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
		$([[ ${EAPI} == 5 ]] && echo -DCMAKE_INSTALL_DO_STRIP=OFF)
		-DCMAKE_TOOLCHAIN_FILE="${URHO3D_TOOLCHAIN_FILE}"
		"${MYCMAKEARGS}"
	)

	if [[ -n "${CMAKE_EXTRA_CACHE_FILE}" ]] ; then
		cmakeargs+=( -C "${CMAKE_EXTRA_CACHE_FILE}" )
	fi

	pushd "${BUILD_DIR}" > /dev/null || die
	debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: mycmakeargs is ${mycmakeargs_local[*]}"
	echo "${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}"
	"${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}" || die "cmake failed"
	popd > /dev/null || die
}

configure_sdl() {
	mycmakeargs+=(
		-DDISKAUDIO=$(usex sdl_audio_disk)
		-DDUMMYAUDIO=$(usex sdl_audio_dummy)
		-DSDL_CPUINFO=$(usex sdl_cpuinfo)
		-DSDL_DLOPEN=$(usex sdl_dlopen)
		-DSDL_JOYSTICK=$(usex joystick)
		-DSDL_FILE=$(usex sdl_file)
		-DSDL_FILESYSTEM=$(usex sdl_filesystem)
		-DSDL_HAPTIC=$(usex haptic)
		-DSDL_POWER=$(usex sdl_power)
		-DSDL_RENDER=$(usex sdl_render)
		-DSDL_SENSOR=$(usex sdl_sensor)
		-DVIDEO_DUMMY=$(usex sdl_video_dummy)
		-DVIDEO_OPENGLES=$(usex gles2)

		-DARTS=OFF
		-DFUSIONSOUND=OFF
		-DVIDEO_DIRECTFB=OFF
	)

	if [[ "${EURHO3D}" == "web" ]] ; then
		mycmakeargs+=(
			-DSDL_SHARED=OFF
			-DSDL_STATIC=ON
		)
	else
		mycmakeargs+=(
			-DSDL_SHARED=ON
			-DSDL_STATIC=OFF
		)
	fi

	if [[ "${EURHO3D}" == "android" ]] ; then
		mycmakeargs+=(
			-DHIDAPI=$(usex joystick ON OFF)
		)
	elif [[ "${EURHO3D}" == "web" ]] ; then
		mycmakeargs+=(
			-DHIDAPI=OFF
		)
	else
		mycmakeargs+=(
			-DHIDAPI=$(usex joystick $(usex hidapi ON OFF) OFF)
		)
	fi

	if [[ "${EURHO3D}" == "web" ]] ; then
		mycmakeargs+=(
			-DVIDEO_RPI=OFF
			-DVIDEO_VIVANTE=OFF
		)
	else
		mycmakeargs+=(
			-DVIDEO_RPI=$(usex video_cards_vc4)
			-DVIDEO_VIVANTE=$(usex video_cards_vivante)
		)
	fi

	if [[ "${EURHO3D}" == "android" \
		|| "${EURHO3D}" == "rpi" \
		|| "${EURHO3D}" == "web" ]] ; then
		# These uses it's own audio/video driver
		mycmakeargs+=(
			-DALSA=OFF
			-DALSA_SHARED=OFF
			-DESD=OFF
			-DESD_SHARED=OFF
			-DINPUT_TSLIB=OFF
			-DJACK=OFF
			-DJACK_SHARED=OFF
			-DKMSDRM_SHARED=OFF
			-DNAS=OFF
			-DOSS=OFF
			-DPTHREADS=OFF
			-DPTHREADS_SEM=OFF
			-DPULSEAUDIO=OFF
			-DPULSEAUDIO_SHARED=OFF
			-DSDL_AUDIO=ON
			-DSDL_THREADS=OFF
			-DSDL_VIDEO=ON
			-DSNDIO=OFF
			-DVIDEO_KMSDRM=OFF
			-DVIDEO_OPENGL=OFF
			-DVIDEO_VULKAN=OFF
			-DVIDEO_WAYLAND=OFF
			-DVIDEO_X11=OFF
			-DVIDEO_X11=OFF
			-DWAYLAND_SHARED=OFF
			-DX11_SHARED=OFF
		)
	else
		mycmakeargs+=(
			-DALSA=$(usex alsa)
			-DALSA_SHARED=$(usex alsa)
			-DINPUT_TSLIB=$(usex tslib)
			-DJACK=$(usex jack)
			-DESD=$(usex esd)
			-DESD_SHARED=$(usex esd)
			-DJACK_SHARED=$(usex jack)
			-DKMSDRM_SHARED=$(usex kms)
			-DLIBSAMPLERATE=$(usex libsamplerate)
			-DNAS=$(usex nas)
			-DOSS=$(usex oss)
			-DPTHREADS=$(usex threads)
			-DPTHREADS_SEM=$(usex threads)
			-DPULSEAUDIO=$(usex pulseaudio)
			-DPULSEAUDIO_SHARED=$(usex pulseaudio)
			-DSDL_AUDIO=$(usex alsa ON $(usex esd ON $(usex jack ON $(usex nas ON $(usex oss ON $(usex pulseaudio ON $(usex sndio ON $(usex sdl_audio_disk ON OFF))))))))
			-DSDL_THREADS=$(usex threads)
			-DSDL_VIDEO=$(usex kms ON $(usex opengl ON $(usex gles2 ON $(usex video_cards_vivante ON $(usex vulkan ON $(usex wayland ON $(usex X ON OFF)))))))
			-DSNDIO=$(usex sndio)
			-DVIDEO_KMSDRM=$(usex kms)
			-DVIDEO_OPENGL=$(usex opengl)
			-DVIDEO_RPI=OFF
			-DVIDEO_VULKAN=$(usex vulkan)
			-DVIDEO_WAYLAND=$(usex wayland)
			-DVIDEO_X11=$(usex X)
			-DVIDEO_X11_XCURSOR=$(usex X)
			-DVIDEO_X11_XINERAMA=$(usex xinerama)
			-DVIDEO_X11_XINPUT=$(usex X)
			-DVIDEO_X11_XRANDR=$(usex X)
			-DVIDEO_X11_XSCRNSAVER=$(usex xscreensaver)
			-DVIDEO_X11_XSHAPE=$(usex X)
			-DVIDEO_X11_XVM=$(usex X)
			-DWAYLAND_SHARED=$(usex wayland)
			-DX11_SHARED=$(usex X)
		)
	fi
}

configure_android() {
        local mycmakeargs=(
		${URHO3D_ANDROID_CONFIG[@]}
		-DCMAKE_INSTALL_PREFIX=/usr/share/${P}/android
		-DANDROID=ON
		-DARM=OFF
		-DRPI=OFF
		-DWEB=OFF
		-DGET_LIBDIR=$(get_libdir)
		-DURHO3D_ANGELSCRIPT=$(usex angelscript)
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_DATABASE_ODBC=OFF
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex doc)
		-DURHO3D_EXTRAS=OFF
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
		-DURHO3D_LIB_TYPE=$(usex static-libs STATIC SHARED)
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=$(usex lua)
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_LUAJIT=$(usex luajit)
		-DURHO3D_LUASCRIPT=$(usex lua ON $(usex luajit ON OFF))
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=$(usex network)
		-DURHO3D_PACKAGING=OFF
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=$(usex system-angelscript)
		-DURHO3D_SYSTEM_ASSIMP=$(usex system-assimp)
		-DURHO3D_SYSTEM_BOOST=$(usex system-boost)
		-DURHO3D_SYSTEM_BOX2D=$(usex system-box2d)
		-DURHO3D_SYSTEM_BULLET=$(usex system-bullet)
		-DURHO3D_SYSTEM_CIVETWEB=$(usex system-civetweb)
		-DURHO3D_SYSTEM_FREETYPE=$(usex system-freetype)
		-DURHO3D_SYSTEM_GLEW=$(usex system-glew)
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=$(usex system-libcpuid)
		-DURHO3D_SYSTEM_LUA=$(usex system-lua)
		-DURHO3D_SYSTEM_LUAJIT=$(usex system-luajit)
		-DURHO3D_SYSTEM_LZ4=$(usex system-lz4)
		-DURHO3D_SYSTEM_MOJOSHADER=$(usex system-mojoshader)
		-DURHO3D_SYSTEM_NANODBC=$(usex system-nanodbc)
		-DURHO3D_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DURHO3D_SYSTEM_RAPIDJSON=$(usex system-rapidjson)
		-DURHO3D_SYSTEM_RECASTNAVIGATION=$(usex system-recastnavigation)
		-DURHO3D_SYSTEM_SDL=$(usex system-sdl)
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=$(usex system-sqlite)
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=OFF
		-DURHO3D_SYSTEM_WEBP=$(usex system-webp)
		-DURHO3D_TESTING=$(usex test)
		-DURHO3D_THREADING=$(usex threads)
		-DURHO3D_TOOLS=OFF
		-DURHO3D_URHO2D=$(usex box2d)
		-DURHO3D_WEBP=$(usex webp)
	)

	if use system-box2d ; then
		if use box2d_2_4 ; then
			ewarn "Box2D 2.4+ breaks ABI compatibility and scripts.  Use Box2D 2.3 to maximize compatibility."
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
			einfo "Using Box2D 2.3"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
			einfo "Using Box2D 2.3 (default) for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
	S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	cmake-utils_src_configure
}

configure_arm() {
	ewarn "configure_arm is incomplete"
        local mycmakeargs=(
		${URHO3D_ANDROID_CONFIG[@]}
		-DCMAKE_INSTALL_PREFIX=/usr/share/${P}/arm
		-DANDROID=OFF
		-DARM=ON
		-DRPI=OFF
		-DWEB=OFF
		-DGET_LIBDIR=$(get_libdir)
		-DURHO3D_ANGELSCRIPT=$(usex angelscript)
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_DATABASE_ODBC=OFF
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex doc)
		-DURHO3D_EXTRAS=OFF
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
		-DURHO3D_LIB_TYPE=$(usex static-libs STATIC SHARED)
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=$(usex lua)
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_LUAJIT=$(usex luajit)
		-DURHO3D_LUASCRIPT=$(usex lua ON $(usex luajit ON OFF))
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=$(usex network)
		-DURHO3D_PACKAGING=OFF
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=$(usex system-angelscript)
		-DURHO3D_SYSTEM_ASSIMP=$(usex system-assimp)
		-DURHO3D_SYSTEM_BOOST=$(usex system-boost)
		-DURHO3D_SYSTEM_BOX2D=$(usex system-box2d)
		-DURHO3D_SYSTEM_BULLET=$(usex system-bullet)
		-DURHO3D_SYSTEM_CIVETWEB=$(usex system-civetweb)
		-DURHO3D_SYSTEM_FREETYPE=$(usex system-freetype)
		-DURHO3D_SYSTEM_GLEW=$(usex system-glew)
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=$(usex system-libcpuid)
		-DURHO3D_SYSTEM_LUA=$(usex system-lua)
		-DURHO3D_SYSTEM_LUAJIT=$(usex system-luajit)
		-DURHO3D_SYSTEM_LZ4=$(usex system-lz4)
		-DURHO3D_SYSTEM_MOJOSHADER=$(usex system-mojoshader)
		-DURHO3D_SYSTEM_NANODBC=$(usex system-nanodbc)
		-DURHO3D_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DURHO3D_SYSTEM_RAPIDJSON=$(usex system-rapidjson)
		-DURHO3D_SYSTEM_RECASTNAVIGATION=$(usex system-recastnavigation)
		-DURHO3D_SYSTEM_SDL=$(usex system-sdl)
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=$(usex system-sqlite)
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=OFF
		-DURHO3D_SYSTEM_WEBP=$(usex system-webp)
		-DURHO3D_TESTING=$(usex test)
		-DURHO3D_THREADING=$(usex threads)
		-DURHO3D_TOOLS=OFF
		-DURHO3D_URHO2D=$(usex box2d)
		-DURHO3D_WEBP=$(usex webp)
	)

	if use system-box2d ; then
		if use box2d_2_4 ; then
			ewarn "Box2D 2.4+ breaks ABI compatibility and scripts.  Use Box2D 2.3 to maximize compatibility."
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
			einfo "Using Box2D 2.3"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
			einfo "Using Box2D 2.3 (default) for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/Arm.cmake"
	SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
	S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	_cmake-utils_src_configure
}

configure_native() {
	if [[ "${EURHO3D}" == "native" ]] ; then
		if use debug; then
			append-cxxflags -g -O0
			append-cflags -g -O0
		fi
	fi

	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")

        local mycmakeargs=(
		-DANDROID=OFF
		-DARM=OFF
		-DRPI=OFF
		-DWEB=OFF
		-DGET_LIBDIR=$(get_libdir)
		-DURHO3D_ANGELSCRIPT=$(usex angelscript)
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_DATABASE_ODBC=$(usex odbc)
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex doc)
		-DURHO3D_EXTRAS=$(usex extras)
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
		-DURHO3D_LIB_TYPE=$(usex static-libs STATIC SHARED)
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=$(usex lua)
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_LUAJIT=$(usex luajit)
		-DURHO3D_LUASCRIPT=$(usex lua ON $(usex luajit ON OFF))
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=$(usex network)
		-DURHO3D_PACKAGING=OFF
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=$(usex system-angelscript)
		-DURHO3D_SYSTEM_ASSIMP=$(usex system-assimp)
		-DURHO3D_SYSTEM_BOOST=$(usex system-boost)
		-DURHO3D_SYSTEM_BOX2D=$(usex system-box2d)
		-DURHO3D_SYSTEM_BULLET=$(usex system-bullet)
		-DURHO3D_SYSTEM_CIVETWEB=$(usex system-civetweb)
		-DURHO3D_SYSTEM_FREETYPE=$(usex system-freetype)
		-DURHO3D_SYSTEM_GLEW=$(usex system-glew)
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=$(usex system-libcpuid)
		-DURHO3D_SYSTEM_LUA=$(usex system-lua)
		-DURHO3D_SYSTEM_LUAJIT=$(usex system-luajit)
		-DURHO3D_SYSTEM_LZ4=$(usex system-lz4)
		-DURHO3D_SYSTEM_MOJOSHADER=$(usex system-mojoshader)
		-DURHO3D_SYSTEM_NANODBC=$(usex system-nanodbc)
		-DURHO3D_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DURHO3D_SYSTEM_RAPIDJSON=$(usex system-rapidjson)
		-DURHO3D_SYSTEM_RECASTNAVIGATION=$(usex system-recastnavigation)
		-DURHO3D_SYSTEM_SDL=$(usex system-sdl)
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=$(usex system-sqlite)
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=OFF
		-DURHO3D_SYSTEM_WEBP=$(usex system-webp)
		-DURHO3D_TESTING=$(usex test)
		-DURHO3D_THREADING=$(usex threads)
		-DURHO3D_TOOLS=$(usex tools)
		-DURHO3D_URHO2D=$(usex box2d)
		-DURHO3D_WEBP=$(usex webp)
        )

	if use system-box2d ; then
		if use box2d_2_4 ; then
			ewarn "Using Box2D 2.4 for ${EURHO3D} while breaking ABI compatibility and scripts.  Use Box2D 2.3 to maximize compatibility."
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
			einfo "Using Box2D 2.3 for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
			einfo "Using Box2D 2.3 (default) for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	if use opengl ; then
		mycmakeargs+=( -DURHO3D_OPENGL=TRUE )
	fi

	if [[ "${ABI}" == "amd64" ]] ; then
		mycmakeargs+=( -DURHO3D_64BIT=1 )
		if use cpu_flags_x86_sse || use cpu_flags_x86_sse2 ; then
			mycmakeargs+=( -DURHO3D_SSE=1 )
		fi
	elif [[ "${ABI}" == "x86" ]] ; then
		if use cpu_flags_x86_mmx ; then
			mycmakeargs+=( -DURHO3D_MMX=1 )
		elif use cpu_flags_x86_3dnow ; then
			mycmakeargs+=( -DURHO3D_3DNOW=1 )
		fi
	elif [[ "${ABI}" == "ppc" || "${ABI}" == "ppc64" ]] ; then
		if use altivec ; then
			mycmakeargs+=( -DURHO3D_ALTIVEC=1 )
		fi
	fi

	configure_sdl

	SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
	S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	cmake-utils_src_configure
}

configure_rpi() {
        local mycmakeargs=(
		${URHO3D_RPI_CONFIG[@]}
		-DCMAKE_INSTALL_PREFIX=/usr/share/${P}/rpi
		-DANDROID=OFF
		-DARM=OFF
		-DRPI=ON
		-DWEB=OFF
		-DGET_LIBDIR=$(get_libdir)
		-DURHO3D_ANGELSCRIPT=$(usex angelscript)
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_DATABASE_ODBC=$(usex odbc)
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex doc)
		-DURHO3D_EXTRAS=$(usex extras)
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
		-DURHO3D_LIB_TYPE=$(usex static-libs STATIC SHARED)
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=$(usex lua)
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_LUAJIT=$(usex luajit)
		-DURHO3D_LUASCRIPT=$(usex lua ON $(usex luajit ON OFF))
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=$(usex network)
		-DURHO3D_PACKAGING=OFF
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=$(usex system-angelscript)
		-DURHO3D_SYSTEM_ASSIMP=$(usex system-assimp)
		-DURHO3D_SYSTEM_BOOST=$(usex system-boost)
		-DURHO3D_SYSTEM_BOX2D=$(usex system-box2d)
		-DURHO3D_SYSTEM_BULLET=$(usex system-bullet)
		-DURHO3D_SYSTEM_CIVETWEB=$(usex system-civetweb)
		-DURHO3D_SYSTEM_FREETYPE=$(usex system-freetype)
		-DURHO3D_SYSTEM_GLEW=$(usex system-glew)
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=$(usex system-libcpuid)
		-DURHO3D_SYSTEM_LUA=$(usex system-lua)
		-DURHO3D_SYSTEM_LUAJIT=$(usex system-luajit)
		-DURHO3D_SYSTEM_LZ4=$(usex system-lz4)
		-DURHO3D_SYSTEM_MOJOSHADER=$(usex system-mojoshader)
		-DURHO3D_SYSTEM_NANODBC=$(usex system-nanodbc)
		-DURHO3D_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DURHO3D_SYSTEM_RAPIDJSON=$(usex system-rapidjson)
		-DURHO3D_SYSTEM_RECASTNAVIGATION=$(usex system-recastnavigation)
		-DURHO3D_SYSTEM_SDL=$(usex system-sdl)
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=$(usex system-sqlite)
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=OFF
		-DURHO3D_SYSTEM_WEBP=$(usex system-webp)
		-DURHO3D_TESTING=$(usex test)
		-DURHO3D_THREADING=$(usex threads)
		-DURHO3D_TOOLS=$(usex tools)
		-DURHO3D_URHO2D=$(usex box2d)
		-DURHO3D_WEBP=$(usex webp)
	)

	if use system-box2d ; then
		if use box2d_2_4 ; then
			ewarn "Using Box2D 2.4 for ${EURHO3D} while breaking ABI compatibility and scripts.  Use Box2D 2.3 to maximize compatibility."
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
			einfo "Using Box2D 2.3 for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
			einfo "Using Box2D 2.3 (default) for ${EURHO3D}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/RaspberryPi.cmake"
	SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
	S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	_cmake-utils_src_configure
}

configure_web() {
	myemscriptpath="${EMSCRIPTEN}"

	filter-flags -march=*
	filter-ldflags -Wl,--as-needed
	strip-flags
	einfo "LDFLAGS=${LDFLAGS}"
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	A=$(cat ${EM_CONFIG})
	BINARYEN_LIB_PATH=$(echo -e "${A}\nprint (BINARYEN_ROOT)" | python3)"/lib"
	einfo "BINARYEN_LIB_PATH=${BINARYEN_LIB_PATH}"
	export LD_LIBRARY_PATH="${BINARYEN_LIB_PATH}:${LD_LIBRARY_PATH}"

#		-DEMSCRIPTEN=1
	# Setting EMSCRIPTEN_SYSROOT is not necessary
	# URHO3D_PACKAGING depends on URHO3D_TOOLS
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/share/${P}/web
		-DANDROID=OFF
		-DARM=OFF
		-DRPI=OFF
		-DWEB=ON
		${mydebug}
		-DEMSCRIPTEN_ROOT_PATH="${myemscriptpath}"
		-DEMSCRIPTEN_WASM=TRUE
		-DURHO3D_ANGELSCRIPT=OFF
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_CLANG_TOOLS=OFF
		-DURHO3D_DATABASE_ODBC=OFF
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex doc)
		-DURHO3D_EXTRAS=OFF
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
		-DURHO3D_JAVASCRIPT=$(usex bindings)
		-DURHO3D_LIB_TYPE=MODULE
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=OFF
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_LUAJIT=OFF
		-DURHO3D_LUASCRIPT=$(usex lua)
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=OFF
		-DURHO3D_PACKAGING=ON
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=OFF
		-DURHO3D_SYSTEM_ASSIMP=OFF
		-DURHO3D_SYSTEM_BOOST=OFF
		-DURHO3D_SYSTEM_BOX2D=OFF
		-DURHO3D_SYSTEM_BULLET=OFF
		-DURHO3D_SYSTEM_CIVETWEB=OFF
		-DURHO3D_SYSTEM_FREETYPE=OFF
		-DURHO3D_SYSTEM_GLEW=OFF
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=OFF
		-DURHO3D_SYSTEM_LUA=OFF
		-DURHO3D_SYSTEM_LUAJIT=OFF
		-DURHO3D_SYSTEM_LZ4=OFF
		-DURHO3D_SYSTEM_MOJOSHADER=OFF
		-DURHO3D_SYSTEM_NANODBC=OFF
		-DURHO3D_SYSTEM_PUGIXML=OFF
		-DURHO3D_SYSTEM_RAPIDJSON=OFF
		-DURHO3D_SYSTEM_RECASTNAVIGATION=OFF
		-DURHO3D_SYSTEM_SDL=OFF
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=OFF
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=OFF
		-DURHO3D_SYSTEM_WEBP=OFF
		-DURHO3D_TESTING=$(usex test)
		-DURHO3D_THREADING=OFF
		-DURHO3D_TOOLS=ON
		-DURHO3D_URHO2D=$(usex box2d)
		-DURHO3D_WEBP=$(usex webp)
	)

	configure_sdl

	einfo "Using Box2D 2.3 for ${EURHO3D}"

	URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/Emscripten.cmake"
	SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
	S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
	_cmake-utils_src_configure
}

src_configure() {
	configure_platform() {
		cd "${BUILD_DIR}" || die
		configure_abi() {
			cd "${BUILD_DIR}" || die
			static-libs_configure() {
				cd "${BUILD_DIR}" || die

				if ( use bindings || use clang-tools ) && [[ "${EURHO3D}" != "web" ]] ; then
					local chost=$(get_abi_CHOST ${ABI})
					export CC=/usr/lib/llvm/${LLVM_SLOT}/bin/${chost}-clang
					export CXX=/usr/lib/llvm/${LLVM_SLOT}/bin/${chost}-clang++
				fi

				if [[ "${EURHO3D}" == "android" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					configure_android
				elif [[ "${EURHO3D}" == "arm" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					configure_arm
				elif [[ "${EURHO3D}" == "native" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					configure_native
				elif [[ "${EURHO3D}" == "rpi" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					configure_rpi
				elif [[ "${EURHO3D}" == "web" && "${ESTSH_LIB_TYPE}" == "module" ]] ; then
					configure_web
				fi
			}
			static-libs_foreach_impl \
				static-libs_configure
		}
		multilib_foreach_abi configure_abi
	}
	urho3d_foreach_impl \
		configure_platform
}

src_compile() {
	compile_common() {
		SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
		cmake-utils_src_compile
	}

	compile_platform() {
		cd "${BUILD_DIR}" || die
		compile_abi() {
			cd "${BUILD_DIR}" || die
			static-libs_compile() {
				cd "${BUILD_DIR}" || die
				if [[ "${EURHO3D}" == "android" ]] ; then
					ewarn "src_compile for android has not been tested.  Send back fixes to ebuild maintainer."
					if [[ -n "${URHO3D_TARGET_ANDROID_SDK_VERSION}" ]] ; then
						android update project -p . -t ${URHO3D_TARGET_ANDROID_SDK_VERSION}
					else
						android update project -p .
					fi
					make -j 1
					ant debug
				elif [[ "${EURHO3D}" == "arm" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					compile_common
				elif [[ "${EURHO3D}" == "native" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					compile_common
				elif [[ "${EURHO3D}" == "rpi" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					ewarn "src_compile for rpi has not been tested.  Send back fixes to ebuild maintainer."
					compile_common
				elif [[ "${EURHO3D}" == "web" && "${ESTSH_LIB_TYPE}" == "module" ]] ; then
					compile_common
				fi
			}
			static-libs_foreach_impl \
				static-libs_compile
		}
		multilib_foreach_abi compile_abi
	}
	urho3d_foreach_impl \
		compile_platform
}

src_install() {
	install_common() {
		SUFFIX="_${EURHO3D}_${ABI}_${ESTSH_LIB_TYPE}"
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}${SUFFIX}" \
		cmake-utils_src_install
	}

	install_platform() {
		cd "${BUILD_DIR}" || die
		install_abi() {
			cd "${BUILD_DIR}" || die
			static-libs_install() {
				cd "${BUILD_DIR}" || die
				if [[ "${EURHO3D}" == "android" ]] ; then
					ewarn "src_install for android has not been tested.  Send back fixes to ebuild maintainer."
					install_common
				elif [[ "${EURHO3D}" == "arm" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					install_common
				elif [[ "${EURHO3D}" == "native" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					install_common
				elif [[ "${EURHO3D}" == "rpi" && "${ESTSH_LIB_TYPE}" != "module" ]] ; then
					ewarn "src_install for rpi has not been tested.  Send back fixes to ebuild maintainer."
					install_common
				elif [[ "${EURHO3D}" == "web" && "${ESTSH_LIB_TYPE}" == "module" ]] ; then
					install_common
				fi
			}
			static-libs_foreach_impl \
				static-libs_install
		}
		multilib_foreach_abi install_abi
	}
	urho3d_foreach_impl \
		install_platform

	cd "${S}" || die

	if use tools ; then
		docinto licenses/ThirdParty/Assimp
		dodoc Source/ThirdParty/Assimp/LICENSE
	fi

	docinto licenses/ThirdParty/boost
	dodoc Source/ThirdParty/boost/LICENSE_1_0.txt

	if use bullet ; then
		docinto licenses/ThirdParty/Bullet
		dodoc Source/ThirdParty/Bullet/LICENSE.txt
	fi


	if use recastnavigation ; then
		docinto licenses/ThirdParty/Detour
		dodoc Source/ThirdParty/Detour/License.txt

		docinto licenses/ThirdParty/DetourCrowd
		dodoc Source/ThirdParty/DetourCrowd/License.txt

		docinto licenses/ThirdParty/DetourTileCache
		dodoc Source/ThirdParty/DetourTileCache/License.txt

		docinto licenses/ThirdParty/Recast
		dodoc Source/ThirdParty/Recast/License.txt
	fi

	docinto licenses/ThirdParty/FreeType
	dodoc Source/ThirdParty/FreeType/docs/FTL.TXT

	if use opengl ; then
		docinto licenses/ThirdParty/GLEW
		dodoc Source/ThirdParty/GLEW/LICENSE.txt
	fi

	docinto licenses/ThirdParty/LibCpuId
	dodoc Source/ThirdParty/LibCpuId/COPYING

	if use lua ; then
		docinto licenses/ThirdParty/Lua
		dodoc Source/ThirdParty/Lua/COPYRIGHT
	fi

	if use luajit ; then
		docinto licenses/ThirdParty/LuaJIT
		dodoc Source/ThirdParty/LuaJIT/COPYRIGHT
	fi

	docinto licenses/ThirdParty/LZ4
	dodoc Source/ThirdParty/LZ4/LICENSE

	if ! use opengl ; then
		docinto licenses/ThirdParty/MojoShader
		dodoc Source/ThirdParty/MojoShader/LICENSE.txt
	fi

	docinto licenses/ThirdParty/Mustache
	head -n 27 \
		Source/ThirdParty/Mustache/mustache.hpp \
		> "${T}/LICENSE"
	dodoc "${T}/LICENSE"

	if use odbc ; then
		docinto licenses/ThirdParty/nanodbc
		dodoc Source/ThirdParty/nanodbc/LICENSE
	fi

	docinto licenses/ThirdParty/PugiXml
	dodoc Source/ThirdParty/PugiXml/readme.txt

	docinto licenses/ThirdParty/rapidjson
	dodoc Source/ThirdParty/rapidjson/license.txt

	docinto licenses/ThirdParty/SDL
	dodoc Source/ThirdParty/SDL/COPYING.txt

	if use network ; then
		docinto licenses/ThirdParty/Civetweb
		dodoc Source/ThirdParty/Civetweb/LICENSE.md

		docinto licenses/ThirdParty/SLikeNet
		dodoc Source/ThirdParty/SLikeNet/license.txt
	fi

	if use sqlite ; then
		docinto licenses/ThirdParty/SQLite
		head -n 11 \
			Source/ThirdParty/SQLite/src/sqlite3.h \
			> "${T}/LICENSE"
		dodoc "${T}/LICENSE"
	fi

	docinto licenses/ThirdParty/StanHull
	dodoc Source/ThirdParty/StanHull/readme.txt

	docinto licenses/ThirdParty/STB
	tail -n 41 \
		Source/ThirdParty/STB/stb_image.h \
		> "${T}/LICENSE"
	dodoc "${T}/LICENSE"

	if use lua || use luajit ; then
		docinto licenses/ThirdParty/toluapp
		dodoc Source/ThirdParty/toluapp/COPYRIGHT
	fi

	if use webp ; then
		docinto licenses/ThirdParty/WebP
		dodoc Source/ThirdParty/WebP/{COPYING,PATENTS}
	fi

	if use hidapi ; then
		docinto licenses/Source/ThirdParty/SDL/src/hidapi
		dodoc \
Source/ThirdParty/SDL/src/hidapi/{LICENSE.txt,LICENSE-bsd.txt,LICENSE-orig.txt}
	fi

	docinto licenses/bin/Data/Fonts
	dodoc bin/Data/Fonts/OFL.txt

	docinto licenses/bin/Data/Urho2D/Orc
	dodoc bin/Data/Urho2D/Orc/License.txt

	docinto licenses/bin/Data/Urho2D/Tilesets
	dodoc bin/Data/Urho2D/Tilesets/Licenses.txt

	docinto licenses/bin/Data/Models/Mutant
	dodoc bin/Data/Models/Mutant/License.txt

	docinto licenses/bin/Data/Urho2D/imp
	dodoc bin/Data/Urho2D/imp/imp.txt

	docinto licenses/SourceAssets
	dodoc SourceAssets/TeaPot_copyright.txt

	docinto licenses
	dodoc LICENSE
}

pkg_postinst() {
	if use native ; then
		einfo \
"If it segfaults, try run to the program with -gl2.  glVertexAttribDivisorARB \
may be bugged for gl3."
	fi
}
