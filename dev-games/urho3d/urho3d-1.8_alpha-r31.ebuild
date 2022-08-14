# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATIC_LIBS_CUSTOM_LIB_TYPE_IMPL="module"
STATIC_LIBS_CUSTOM_LIB_TYPE_IUSE="+module"
CMAKE_MAKEFILE_GENERATOR=emake
LLVM_SLOTS=(15 14 13) # Previously tested with 9
LLVM_MAX_SLOT=15 # It needs testing.  It can break with different LLVM.

inherit cmake flag-o-matic linux-info llvm multilib-minimal

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

# Applies to the internal SDL
LICENSE_HIDAPI="|| ( BSD HIDAPI )"
LICENSE+="
	!system-sdl? (
		ZLIB
		BSD
		BrownUn_UnCalifornia_ErikCorry
		MIT all-rights-reserved
		SunPro
		hidapi-hidraw? ( ${LICENSE_HIDAPI} )
		hidapi-libusb? ( ${LICENSE_HIDAPI} )
		native? (
			X? ( MIT all-rights-reserved )
		)
	)
"
# project default license is ZLIB
# yuv2rgb is BSD
# Some assets are public domain but not mentioned in the LICENSE variable
#   to not to give the impression the whole entire package is public domain.
# In Source/ThirdParty/SDL/src/video/x11/imKStoUCS.c,
#   Source/ThirdParty/SDL/include/SDL_opengl.h,
#   The standard MIT license* does not have all-rights-reserved.
#     *https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/MIT
# In src/hidapi/ios/hid.m,
#   src/hidapi/android/hid.cpp,
#   src/hidapi/linux/hid.cpp,
#   src/hidapi/windows/ddk_build/makefile
#   contain all rights reserved without mentioned terms or corresponding license
#   and are transported with the tarball.

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~arm ~arm64"
SLOT="0/${PV}"
X86_CPU_FEATURES_RAW=( 3dnow mmx sse sse2 )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
PLATFORMS="android arm native rpi web"
IUSE+="
	${PLATFORMS}
	${X86_CPU_FEATURES[@]%:*}
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
	-clang-tools
	 dbus
	 debug
	-debug-raw-script-loader
	-doc
	 esd
	-extras
	+filewatcher
	+gles2
	 haptic
	+hidapi-hidraw
	 hidapi-libusb
	 ibus
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
	-strict-requirements
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
	 xscreensaver
"

# Partly from the libsdl2-2.0.12-r2.ebuild
SDL2_REQUIRED_USE="
	android? ( sound? ( threads alsa ) )
	ibus? ( dbus )
	native? ( sound? ( threads alsa ) )
	rpi? ( sound? ( threads alsa ) )
	wayland? ( gles2 )
	xinerama? ( X )
	xscreensaver? ( X )
"

#	native
REQUIRED_USE+="
	${SDL2_REQUIRED_USE}
	^^ ( android arm native )
	web? ( native )
	alsa? ( sound threads )
	bindings? ( !pch )
	box2d? ( ^^ ( box2d_2_3 box2d_2_4 ) )
        clang-tools? (
		!luajit
		!odbc
		!pch
		!test
		angelscript
		bullet
		filewatcher
		ik
		logging
		lua
		profiling
		network
		recastnavigation
		sqlite
	)
	cpu_flags_x86_3dnow? ( !cpu_flags_x86_sse !cpu_flags_x86_mmx )
	cpu_flags_x86_mmx? ( !cpu_flags_x86_3dnow !cpu_flags_x86_sse )
	cpu_flags_x86_sse? ( !cpu_flags_x86_3dnow !cpu_flags_x86_mmx )
	haptic? ( joystick )
	joystick
	joystick? (
		!system-sdl? ( hidapi-libusb? ( sdl_dlopen ) )
		android? ( hidapi-hidraw )
		native? ( || ( hidapi-libusb hidapi-hidraw ) )
	)
	luajit? ( lua )

	network? ( threads )
	odbc? ( !sqlite )
	opengl
	samples? (
		android? ( gles2 )
		rpi? ( gles2 )
		web? ( gles2 static-libs )
	)
	sqlite? ( !odbc )
	!system-slikenet
	 system-box2d? ( ^^ ( box2d_2_3 box2d_2_4 ) )
	!system-box2d? ( box2d_2_3 !box2d_2_4 )
"

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
	alsa? (
		>=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
	)
	dbus? (
		>=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}]
	)
	gles2? (
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},gles2]
	)
	ibus? (
		app-i18n/ibus
	)
	joystick? (
		hidapi-libusb? ( dev-libs/libusb )
	)
	jack? (
		virtual/jack[${MULTILIB_USEDEP}]
	)
	kms? (
		>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.0.0[${MULTILIB_USEDEP},gbm]
	)
	libsamplerate? (
		media-libs/libsamplerate[${MULTILIB_USEDEP}]
	)
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	)
	pulseaudio? (
		>=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}]
	)
	sndio? (
		media-sound/sndio[${MULTILIB_USEDEP}]
	)
	tslib? (
		>=x11-libs/tslib-1.0-r3[${MULTILIB_USEDEP}]
	)
	udev? (
		>=virtual/libudev-208:=[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},egl(+),gles2,wayland]
		>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		xinerama? (
			>=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}]
		)
		xscreensaver? (
			>=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}]
		)
	)
"
SDL2_RDEPEND="
	${SDL2_CDEPEND}
	vulkan? ( media-libs/vulkan-loader )
"
SDL2_DEPEND="
	${SDL2_CDEPEND}
	vulkan? ( dev-util/vulkan-headers )
	X? ( x11-base/xorg-proto )
"
DEPEND_COMMON="
	angelscript? (
		system-angelscript? (
			>=dev-libs/angelscript-2.33:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
	box2d? (
		system-box2d? (
			box2d_2_4? (
				|| (
		>=dev-games/box2d-2.4.1:2.4=[${MULTILIB_USEDEP},static-libs?]
		>=games-engines/box2d-2.4.1:2.4.0[${MULTILIB_USEDEP}]
				)
			)
			box2d_2_3? (
				|| (
		>=dev-games/box2d-2.3.1:2.3=[${MULTILIB_USEDEP},static-libs?]
		>=games-engines/box2d-2.3.1:2.3.0[${MULTILIB_USEDEP}]
				)
			)
		)
	)
	bullet? (
		system-bullet? (
			>=sci-physics/bullet-2.86.1[${MULTILIB_USEDEP}]
		)
	)
	lua? (
		system-lua? (
			>=dev-lang/lua-5.1:${LUA_VER}=[${MULTILIB_USEDEP},urho3d]
		)
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
	system-freetype? (
		>=media-libs/freetype-2.8:=[${MULTILIB_USEDEP},static-libs?]
	)
	system-lz4? (
		>=app-arch/lz4-1.7.5[${MULTILIB_USEDEP}]
	)
	system-pugixml? (
		>=dev-libs/pugixml-1.7:=[${MULTILIB_USEDEP},static-libs?]
	)
	system-rapidjson? (
		>=dev-libs/rapidjson-1.1
	)
	system-sdl? (
>=media-libs/libsdl2-${SDL_VER}:=[\
${MULTILIB_USEDEP},X?,alsa?,cpu_flags_x86_3dnow?,cpu_flags_x86_mmx?,\
cpu_flags_x86_sse?,cpu_flags_x86_sse2?,dbus?,gles2?,haptic?,hidapi-hidraw?,\
hidapi-libusb?,ibus?,joystick?,kms?,libsamplerate?,nas?,opengl?,oss?,\
pulseaudio?,sound?,threads?,tslib?,static-libs?,video,vulkan?,wayland?,\
xinerama?,xscreensaver?\
]
	)
	!system-sdl? ( ${SDL2_DEPEND} )
	system-webp? (
		>=media-libs/libwebp-0.6:=[static-libs?]
	)
"
DEPEND_ANDROID="
	dev-java/gradle-bin
	dev-util/android-ndk
	lua? (
		system-luajit? (
			luajit? (
				>=dev-lang/luajit-2.1:2[static-libs,urho3d]
			)
		)
	)
	network? (
		system-civetweb? (
>=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1]
		)
		system-slikenet? (
			net-libs/slikenet[${MULTILIB_USEDEP}]
		)
	)
	system-boost? ( >=dev-libs/boost-${BOOST_VER} )
"
gen_clang_web_depend() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
	(
	      >=sys-devel/llvm-3.9.0:${s}[${MULTILIB_USEDEP}]
	      >=sys-devel/clang-3.9.0:${s}[${MULTILIB_USEDEP}]
	)
		"
	done
}
DEPEND_WEB="
	$(gen_clang_web_depend)
      >=dev-util/emscripten-1.36.10[wasm(+)]
	system-boost? ( >=dev-libs/boost-${BOOST_VER} )
"
DEPEND_NATIVE="
	lua? (
		system-luajit? (
			luajit? (
				>=dev-lang/luajit-2.1:2[static-libs,urho3d]
			)
		)
	)
	network? (
		system-civetweb? (
>=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1]
		)
		system-slikenet? (
			net-libs/slikenet[${MULTILIB_USEDEP}]
		)
	)
	odbc? (
		system-nanodbc? (
>=dev-db/nanodbc-2.12.4:=[${MULTILIB_USEDEP},-libcxx,boost,static-libs?,-unicode]
			  dev-db/unixODBC[${MULTILIB_USEDEP}]
		)
	)
	opengl? (
		system-glew? (
			>=media-libs/glew-1.13:=[${MULTILIB_USEDEP},static-libs?]
		)
		system-libcpuid? (
			>=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}]
		)
	)
	!opengl? (
		system-mojoshader? (
			media-libs/mojoshader:=[static-libs?]
		)
		system-libcpuid? (
			>=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}]
		)
	)
	tools? (
		system-assimp? (
			>=media-libs/assimp-4.1:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
"
DEPEND_RPI="
	lua? (
		system-luajit? (
			luajit? (
				>=dev-lang/luajit-2.1:2[static-libs,urho3d]
			)
		)
	)
	network? (
		system-civetweb? (
>=www-servers/civetweb-${CIVETWEB_VER}:=[static-libs?,lua,lua_targets_lua5-1]
		)
		system-slikenet? (
			net-libs/slikenet[${MULTILIB_USEDEP}]
		)
	)
	opengl? (
		system-glew? (
			>=media-libs/glew-1.13:=[${MULTILIB_USEDEP},static-libs?]
		)
		system-libcpuid? (
			>=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}]
		)
	)
	!opengl? (
		system-mojoshader? (
			media-libs/mojoshader:=[static-libs?]
		)
		system-libcpuid? (
			>=sys-libs/libcpuid-0.4[${MULTILIB_USEDEP}]
		)
	)
	system-boost? ( >=dev-libs/boost-${BOOST_VER} )
	tools? (
		system-assimp? (
			>=media-libs/assimp-4.1:=[${MULTILIB_USEDEP},static-libs?]
		)
	)
"

gen_clang_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
	bindings? (
		sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
	)
	clang-tools? (
		sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
	)

		"
	done
}

DEPEND+="
	$(gen_clang_depends)
	${DEPEND_COMMON}
	android? ( ${DEPEND_ANDROID} )
	native? ( ${DEPEND_NATIVE} )
	rpi? ( ${DEPEND_RPI} )
	web? ( ${DEPEND_WEB} )
	!system-sdl? ( ${SDL2_RDEPEND} )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-3.2.3"
RESTRICT="mirror"
EGIT_COMMIT="d34dda158ecd7694fcfd55684caade7e131b8a45"
SRC_URI="
https://github.com/urho3d/Urho3D/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/Urho3D-${EGIT_COMMIT}"
EPATCH_OPTS="--binary -p1"

_check_native() {
        if use debug; then
                if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
eerror
eerror "Emerge again with FEATURES=\"nostrip\" or remove the debug use flag"
eerror
			die
                fi
        fi

	if use strict-requirements ; then
		glxinfo | grep  EXT_framebuffer_object &>/dev/null
		if [[ "$?" != "0" ]]; then
eerror
eerror "Video card not supported.  Your machine does not meet the minimum"
eerror "requirements."
eerror
			die
		fi
		glxinfo | grep EXT_packed_depth_stencil &>/dev/null
		if [[ "$?" != "0" ]]; then
eerror
eerror "Video card not supported.  Your machine does not meet the minimum"
eerror "requirements."
eerror
			die
		fi
		cat /proc/cpuinfo | grep sse &>/dev/null
		if [[ "$?" != "0" ]]; then
eerror
eerror "CPU not supported.  Your machine does not meet the minimum requirements."
eerror
			die
		fi
	fi
}

_check_android() {
	if [[ -z "${URHO3D_TARGET_ANDROID_SDK_VERSION}" ]] ; then
ewarn
ewarn "URHO3D_TARGET_ANDROID_SDK_VERSION needs to be set as a per-package"
ewarn "environmental variable"
ewarn
	fi
	if [[ -z "${URHO3D_ANDROID_CONFIG}" ]] ; then
ewarn
ewarn "URHO3D_ANDROID_CONFIG needs to be set as a per-package environmental"
ewarn "variable"
ewarn
	fi
ewarn
ewarn "The android USE flag has not been tested."
ewarn
	[[ -z "${CTARGET}" ]] || export CTARGET="${CHOST}"
	einfo "CTARGET=${CTARGET}"
	which ${CTARGET}-gcc || die "Did not detect ${CTARGET}-gcc.  Fix CTARGET"
}

_check_arm() {
	[[ -z "${CTARGET}" ]] || export CTARGET="${CHOST}"
	einfo "CTARGET=${CTARGET}"
	which ${CTARGET}-gcc || die "Did not detect ${CTARGET}-gcc.  Fix CTARGET"
}

_check_rpi() {
	if [[ -z "${URHO3D_RPI_CONFIG}" ]] ; then
ewarn
ewarn "URHO3D_RPI_CONFIG needs to be set as a per-package environmental variable"
ewarn
	fi
ewarn
ewarn "The rpi USE flag has not been tested."
ewarn
	[[ -z "${CTARGET}" ]] || export CTARGET="${CHOST}"
	einfo "CTARGET=${CTARGET}"
	which ${CTARGET}-gcc || die "Did not detect ${CTARGET}-gcc.  Fix CTARGET"
}

_check_web() {
	if [[ -n "${EMCC_WASM_BACKEND}" && "${EMCC_WASM_BACKEND}" == "1" ]] ; then
		:;
	else
eerror
eerror "You must switch your emscripten to wasm then do \`source /etc/profile\`."
eerror "See \`eselect emscripten\` for details."
eerror
		die
	fi

	if eselect emscripten 2>/dev/null 1>/dev/null ; then
		if eselect emscripten list | grep -F -e "*" \
			| grep -q -F -e "llvm" ; then
			:;
		else
eerror
eerror "You must switch your emscripten to wasm then do \`source /etc/profile\`."
eerror "See \`eselect emscripten\` for details."
eerror
			die
		fi
	fi
	if [[ -z "${EMSCRIPTEN}" ]] ; then
		die "EMSCRIPTEN environmental variable must be set"
	fi

	local emcc_v=$(emcc --version | head -n 1 | grep -E -o -e "[0-9.]+")
	local emscripten_v=$(echo "${EMSCRIPTEN}" | cut -f 2 -d "-")
	if [[ "${emcc_v}" != "${emscripten_v}" ]] ; then
eerror
eerror "EMCC_V=${emcc_v} != EMSCRIPTEN_V=${emscripten_v}."
eerror "A \`eselect emscripten set <#>\` followed by \`source /etc/profile\` are required."
eerror
		die
	fi
}

pkg_setup() {
	if use clang-tools || use bindings || use web ; then
		llvm_pkg_setup
einfo
einfo "LLVM_SLOT=${LLVM_SLOT}"
einfo
	fi

	if use hidapi-hidraw ; then
		linux-info_pkg_setup
		if ! linux_config_src_exists ; then
ewarn
ewarn "Missing kernel .config file.  Do \`make menuconfig\` and save it to fix"
ewarn "this."
ewarn
		fi
		if ! linux_chkconfig_present HIDRAW ; then
ewarn
ewarn "You must have CONFIG_HIDRAW enabled in the kernel for hidraw"
ewarn "joystick/controller support."
ewarn
		fi
	fi

	use android && _check_android
	use arm && _check_arm
	use rpi && _check_rpi
	use native && _check_native
	use web && _check_web
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

	if use box2d_2_4 && [[ "${platform}" != "web" ]] ; then
		rm Source/Urho3D/LuaScript/pkgs/Urho2D/ConstraintRope2D.pkg \
			Source/Urho3D/Urho2D/ConstraintRope2D.cpp \
			|| die

		for f in ${files_box2d_lines[@]} ; do
			sed -i -e "/BOX2D_2_3/d" \
				-e "s| //BOX2D_2_4||g" \
				"${f}" || die
		done
	else
		for f in ${files_box2d_lines[@]} ; do
			sed -i -e "/BOX2D_2_4/d" \
				-e "s| //BOX2D_2_3||g" \
				"${f}" || die
		done
	fi

	local files_system_box2d_lines=(
		Docs/LuaScriptAPI.dox
		Docs/ScriptAPI.dox
	)

	if use system-box2d && [[ "${platform}" != "web" ]] ; then
		rm -rf Source/ThirdParty/Box2D || die
		for f in ${files_system_box2d_lines[@]} ; do
			sed -i -e "/URHO3D_SYSTEM_BOX2D/d" "${f}" || die
		done
	else
		for f in ${files_system_box2d_lines[@]} ; do
			sed -i -e "s| //\!URHO3D_SYSTEM_BOX2D||" "${f}" || die
		done
	fi
}

get_platforms() {
	use android && echo "android"
	use arm && echo "arm"
	use native && echo "native"
	use rpi && echo "rpi"
	use web && echo "web"
}

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${S}" || die
	cmake_src_prepare

	local platform
	for platform in $(get_platforms) ; do
		prepare_abi() {
			local lib_type
			for lib_type in $(get_lib_types) ; do
				cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}" || die
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}_build"
				cd "${CMAKE_USE_DIR}" || die
				_prepare_common
			done
		}
		multilib_foreach_abi prepare_abi
	done
}

# From cmake.eclass originally as cmake_src_configure
# Modified to use urho3d Toolchain .cmake files
# @FUNCTION: _cmake_src_configure
# @DESCRIPTION:
# General function for configuring with cmake. Default behaviour is to start an
# out-of-source build.
_cmake_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ! ${_CMAKE_UTILS_SRC_PREPARE_HAS_RUN} ]]; then
		if [[ ${EAPI} != [56] ]]; then
			die "FATAL: cmake_src_prepare has not been run"
		else
eqawarn
eqawarn "cmake_src_prepare has not been run, please open a bug on"
eqawarn "https://bugs.gentoo.org/"
eqawarn
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

	[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] \
		&& echo 'SET (CMAKE_COLOR_MAKEFILE OFF CACHE BOOL "pretty colors during make" FORCE)' >> "${common_config}"

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
eqawarn
eqawarn "Declaring mycmakeargs as a variable is deprecated. Please use an array"
eqawarn "instead."
eqawarn
			else
eerror
eerror "Declaring mycmakeargs as a variable is banned in EAPI=${EAPI}. Please"
eerror "use an array instead."
eerror
				die
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
	# NOTE CMAKE_BUILD_TYPE can be only overridden via CMAKE_BUILD_TYPE \
	#   eclass variable
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
		einfo "${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}"
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

	if [[ "${platform}" == "web" ]] ; then
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

	if [[ "${platform}" == "android" ]] ; then
		mycmakeargs+=(
			-DHIDAPI=$(usex joystick \
					$(usex hidapi-hidraw ON OFF) \
					OFF)
		)
	elif [[ "${platform}" == "web" ]] ; then
		mycmakeargs+=(
			-DHIDAPI=OFF
		)
	else
		mycmakeargs+=(
			-DHIDAPI=$(usex joystick \
					$(usex hidapi-hidraw ON \
						$(usex hidapi-libusb ON OFF) ) \
					OFF)
		)
	fi

	if [[ "${platform}" == "web" ]] ; then
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

	if [[ "${platform}" == "android" \
		|| "${platform}" == "rpi" \
		|| "${platform}" == "web" ]] ; then
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
			-DSDL_AUDIO=$(usex alsa ON \
					$(usex esd ON \
						$(usex jack ON \
							$(usex nas ON \
								$(usex oss ON \
									$(usex pulseaudio ON \
										$(usex sndio ON \
											$(usex sdl_audio_disk ON OFF) \
										)\
									)\
								)\
							)\
						)\
					)\
				)
			-DSDL_THREADS=$(usex threads)
			-DSDL_VIDEO=$(usex kms ON \
					$(usex opengl ON \
						$(usex gles2 ON \
							$(usex video_cards_vivante ON \
								$(usex vulkan ON \
									$(usex wayland ON \
										$(usex X ON OFF) \
									)\
								)\
							)\
						)\
					)\
				)
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
		${URHO3D_ANDROID_CONFIG[@]}
	)

	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=SHARED
			-DURHO3D_SAMPLES=$(usex samples)
		)
	elif [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=STATIC
			-DURHO3D_SAMPLES=OFF
		)
	fi

	if use system-box2d ; then
		if use box2d_2_4 ; then
ewarn
ewarn "Box2D 2.4+ breaks ABI compatibility and scripts.  Use Box2D 2.3 to"
ewarn "maximize compatibility."
ewarn
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
einfo
einfo "Using Box2D 2.3"
einfo
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
einfo
einfo "Using Box2D 2.3 (default) for ${platform}"
einfo
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	cmake_src_configure
}

configure_arm() {
	ewarn "configure_arm is incomplete"
	URHO3D_ANDROID_CONFIG=(${URHO3D_ANDROID_CONFIG})
	local mycmakeargs=(
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
		${URHO3D_ANDROID_CONFIG[@]}
	)

	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=SHARED
			-DURHO3D_SAMPLES=$(usex samples)
		)
	elif [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=STATIC
			-DURHO3D_SAMPLES=OFF
		)
	fi

	if use system-box2d ; then
		if use box2d_2_4 ; then
ewarn
ewarn "Box2D 2.4+ breaks ABI compatibility and scripts.  Use Box2D 2.3 to"
ewarn "maximize compatibility."
ewarn
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
einfo
einfo "Using Box2D 2.3"
einfo
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
einfo
einfo "Using Box2D 2.3 (default) for ${platform}"
einfo
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	export URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/Arm.cmake"
	_cmake_src_configure
}

configure_native() {
	if [[ "${platform}" == "native" ]] ; then
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

	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=SHARED
			-DURHO3D_SAMPLES=$(usex samples)
		)
	elif [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=STATIC
			-DURHO3D_SAMPLES=OFF
		)
	fi

	if use system-box2d ; then
		if use box2d_2_4 ; then
ewarn
ewarn "Using Box2D 2.4 for ${platform} while breaking ABI compatibility and"
ewarn "scripts.  Use Box2D 2.3 to maximize compatibility."
ewarn
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
einfo
einfo "Using Box2D 2.3 for ${platform}"
einfo
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
einfo
einfo "Using Box2D 2.3 (default) for ${platform}"
einfo
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

	cmake_src_configure
}

configure_rpi() {
	URHO3D_RPI_CONFIG=(${URHO3D_RPI_CONFIG})
	local mycmakeargs=(
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
		${URHO3D_RPI_CONFIG[@]}
	)

	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=SHARED
			-DURHO3D_SAMPLES=$(usex samples)
		)
	elif [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=STATIC
			-DURHO3D_SAMPLES=OFF
		)
	fi

	if use system-box2d ; then
		if use box2d_2_4 ; then
ewarn
ewarn "Using Box2D 2.4 for ${platform} while breaking ABI compatibility and"
ewarn "scripts.  Use Box2D 2.3 to maximize compatibility."
ewarn
			mycmakeargs+=( -DBOX2D_2_4=1 )
		elif use box2d_2_3 ; then
			einfo "Using Box2D 2.3 for ${platform}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		else
			einfo "Using Box2D 2.3 (default) for ${platform}"
			mycmakeargs+=( -DBOX2D_2_3=1 )
		fi
	fi

	configure_sdl

	export URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/RaspberryPi.cmake"
	_cmake_src_configure
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
	export EM_CACHE="${T}/emscripten/cache"

#		-DEMSCRIPTEN=1
	# Setting EMSCRIPTEN_SYSROOT is not necessary
	# URHO3D_PACKAGING depends on URHO3D_TOOLS
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/share/${P}/web"
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

	if [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=STATIC
			-DURHO3D_SAMPLES=$(usex samples)
		)
	elif [[ "${lib_type}" == "module" ]] ; then
		mycmakeargs+=(
			-DURHO3D_LIB_TYPE=MODULE
			-DURHO3D_SAMPLES=OFF
		)
	fi

	configure_sdl

	einfo "Using Box2D 2.3 for ${platform}"

	export URHO3D_TOOLCHAIN_FILE="${BUILD_DIR}/CMake/Toolchains/Emscripten.cmake"
	_cmake_src_configure
}

src_configure() {
	local platform
	for platform in $(get_platforms) ; do
		configure_abi() {
			local lib_type
			for lib_type in $(get_lib_types) ; do
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}_build"
				cd "${CMAKE_USE_DIR}" || die
				local ctarget
				if [[ -n "${CTARGET}" ]] ; then
					ctarget="${CTARGET:-${CHOST}}"
				elif has_multilib_profile ; then
					ctarget=$(get_abi_HOST ${ABI})
				else
					ctarget="${CHOST}"
				fi
				if use bindings || use clang-tools ; then
					export CC=${ctarget}-clang-${LLVM_SLOT}
					export CXX=${ctarget}-clang++-${LLVM_SLOT}
				elif tc-is-clang ; then
					export CC=${ctarget}-clang-${LLVM_SLOT}
					export CXX=${ctarget}-clang-${LLVM_SLOT}
				elif tc-is-gcc ; then
					export CC=${ctarget}-gcc
					export CXX=${ctarget}-g++
				fi

				if [[	"${platform}" == "android" && \
					"${lib_type}" != "module" ]] ; then
					configure_android
				elif [[ "${platform}" == "arm" && \
					"${lib_type}" != "module" ]] ; then
					configure_arm
				elif [[ "${platform}" == "native" && \
					"${lib_type}" != "module" ]] ; then
					configure_native
				elif [[ "${platform}" == "rpi" && \
					"${lib_type}" != "module" ]] ; then
					configure_rpi
				elif [[ "${platform}" == "web" && ( \
					"${lib_type}" == "module" || \
					"${lib_type}" == "static" ) ]] ; then
					export CC=clang-${LLVM_SLOT}
					export CXX=clang++-${LLVM_SLOT}
					configure_web
				fi
			done
		}
		multilib_foreach_abi configure_abi
	done
}

src_compile() {
	compile_common() {
		cmake_src_compile
	}

	local platform
	for platform in $(get_platforms) ; do
		compile_abi() {
			local lib_type
			for lib_type in $(get_lib_types) ; do
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}_build"
				cd "${BUILD_DIR}" || die
				if [[ "${platform}" == "android" ]] ; then
ewarn
ewarn "src_compile for android has not been tested.  Send back fixes to ebuild"
ewarn "maintainer."
ewarn
					if [[ -n "${URHO3D_TARGET_ANDROID_SDK_VERSION}" ]] ; then
						android update project -p . -t ${URHO3D_TARGET_ANDROID_SDK_VERSION} || die
					else
						android update project -p . || die
					fi
					make -j 1 || die
					ant debug || due
				elif [[ "${platform}" == "arm" && \
					"${lib_type}" != "module" ]] ; then
					compile_common
				elif [[ "${platform}" == "native" && \
					"${lib_type}" != "module" ]] ; then
					compile_common
				elif [[ "${platform}" == "rpi" && \
					"${lib_type}" != "module" ]] ; then
ewarn
ewarn "src_compile for rpi has not been tested.  Send back fixes to ebuild"
ewarn "maintainer."
ewarn
					compile_common
				elif [[ "${platform}" == "web" && ( \
					"${lib_type}" == "module" || \
					"${lib_type}" == "static" ) ]] ; then
					compile_common
				fi
			done
		}
		multilib_foreach_abi compile_abi
	done
}

src_install() {
	install_common() {
		cmake_src_install
	}

	local platform
	for platform in $(get_platforms) ; do
		install_abi() {
			local lib_type
			for lib_type in $(get_lib_types) ; do
				export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}"
				export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_${platform}_build"
				if [[ "${platform}" == "android" ]] ; then
ewarn
ewarn "src_install for android has not been tested.  Send back fixes to ebuild"
ewarn "maintainer."
ewarn
					install_common
				elif [[ "${platform}" == "arm" && \
					"${lib_type}" != "module" ]] ; then
					install_common
				elif [[ "${platform}" == "native" && \
					"${lib_type}" != "module" ]] ; then
					install_common
				elif [[ "${platform}" == "rpi" && \
					"${lib_type}" != "module" ]] ; then
ewarn
ewarn "src_install for rpi has not been tested.  Send back fixes to ebuild"
ewarn "maintainer."
ewarn
					install_common
				elif [[ "${platform}" == "web" && ( \
					"${lib_type}" == "module" || \
					"${lib_type}" == "static" ) ]] ; then
					install_common
				fi
			done
		}
		multilib_foreach_abi install_abi
	done

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

	if ! use system-sdl ; then
		head -n 10 Source/ThirdParty/SDL/src/libm/e_atan2.c > \
			"${T}/libm.LICENSE" || die
		docinto licenses/ThirdParty/SDL/src/libm
		dodoc "${T}/libm.LICENSE"

		if use kms || use opengl || use gles2 \
			|| use video_cards_vivante || use vulkan \
			|| use wayland || use X ; then
			docinto licenses/ThirdParty/SDL/src/video/yuv2rgb
			dodoc Source/ThirdParty/SDL/src/video/yuv2rgb/LICENSE

			# This is mentioned in
			# https://github.com/libsdl-org/SDL/blob/release-2.0.0/debian/copyright
			# for Source/ThirdParty/SDL/src/render/SDL_yuv_sw.c
			docinto licenses/ThirdParty/SDL/src/render
			dodoc "${FILESDIR}/BrownUn_UnCalifornia_ErikCorry"

			if use X ; then
				docinto licenses/ThirdParty/SDL/src/video/x11
				head -n 25 Source/ThirdParty/SDL/src/video/x11/imKStoUCS.c > \
					"${T}/imKStoUCS.c.LICENSE" || die
				dodoc "${T}/imKStoUCS.c.LICENSE"
				head -n 28 Source/ThirdParty/SDL/src/video/x11/imKStoUCS.h > \
					"${T}/imKStoUCS.h.LICENSE" || die
				dodoc "${T}/imKStoUCS.h.LICENSE"
			fi

			# Additional copyright, The first already covered in the
			# default for this module.
			docinto licenses/ThirdParty/SDL/include
			head -n 65 Source/ThirdParty/SDL/include/SDL_opengl.h \
				| tail -n 24 > \
				"${T}/SDL_opengl.h.LICENSE" || die
			dodoc "${T}/SDL_opengl.h.LICENSE"
		fi

		if use hidapi-hidraw || use hidapi-libusb ; then
			docinto licenses/ThirdParty/SDL/src/hidapi
			dodoc Source/ThirdParty/SDL/src/hidapi/LICENSE.txt
			dodoc Source/ThirdParty/SDL/src/hidapi/LICENSE-orig.txt
			dodoc Source/ThirdParty/SDL/src/hidapi/LICENSE-bsd.txt
		fi
	fi

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
			> "${T}/LICENSE" || die
		dodoc "${T}/LICENSE"
	fi

	docinto licenses/ThirdParty/StanHull
	dodoc Source/ThirdParty/StanHull/readme.txt

	docinto licenses/ThirdParty/STB
	tail -n 41 \
		Source/ThirdParty/STB/stb_image.h \
		> "${T}/LICENSE" || die
	dodoc "${T}/LICENSE"

	if use lua || use luajit ; then
		docinto licenses/ThirdParty/toluapp
		dodoc Source/ThirdParty/toluapp/COPYRIGHT
	fi

	if use webp ; then
		docinto licenses/ThirdParty/WebP
		dodoc Source/ThirdParty/WebP/{COPYING,PATENTS}
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
einfo
einfo "If it segfaults, try run to the program with -gl2."
einfo "glVertexAttribDivisorARB may be bugged for gl3."
einfo
	fi
	if use web ; then
einfo
einfo "You need to use emrun if testing samples.  For details see"
einfo "https://emscripten.org/docs/compiling/Running-html-files-with-emrun.html"
einfo
einfo "The message:"
einfo
einfo "  localhost:xxxx has control of your pointer.  Press Esc to take back control."
einfo
einfo "can be avoided using \`emrun --browser chrome <path>\`"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
