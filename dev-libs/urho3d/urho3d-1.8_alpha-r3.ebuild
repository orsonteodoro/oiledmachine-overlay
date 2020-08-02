# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cross-platform 2D and 3D game engine."
HOMEPAGE="http://urho3d.github.io/"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~arm ~arm64"
SLOT="0/${PV}"
X86_CPU_FEATURES_RAW=( 3dnow mmx sse )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
IUSE="${X86_CPU_FEATURES[@]%:*} \
	abi_mips_n64 \
	boost \
	-alsa \
	altivec \
	android \
	+angelscript \
	bindings \
	+box2d \
	+bullet \
	-check-pedantic-requirements \
	-clang-tools \
	debug \
	-debug-raw-script-loader \
	-docs \
	-extras \
	+filewatcher \
	+ik \
	javascript \
	multitarget \
	+logging \
	+lua \
	-luajit \
	native \
	-network \
	-odbc \
	+opengl \
	+pch \
	+profiling \
	-pulseaudio \
	raspberry-pi \
	+recastnavigation \
	+samples \
	sqlite \
	sound \
	static \
	static-libs \
	system-angelscript \
	system-assimp \
	system-box2d \
	system-bullet \
	system-civetweb \
	system-freetype \
	system-glew \
	system-slikenet \
	system-libcpuid \
	system-lua \
	system-luajit \
	system-lz4 \
	system-mojoshader \
	system-nanodbc \
	system-pugixml \
	system-rapidjson \
	system-recastnavigation \
	system-sdl \
	system-sqlite \
	system-tolua++ \
	system-webp \
	test \
	threads \
	+tools
	+webp"
REQUIRED_USE="
	alsa? ( sound threads )
	!android
	android? ( !system-angelscript
		!system-assimp
		!system-box2d
		!system-bullet
		!system-civetweb
		!system-freetype
		!system-glew
		!system-slikenet
		!system-libcpuid
		!system-lua
		!system-luajit
		!system-lz4
		!system-mojoshader
		!system-nanodbc
		!system-pugixml
		!system-rapidjson
		!system-recastnavigation
		!system-sdl
		!system-sqlite
		!system-tolua++ )
        clang-tools? ( !pch !static )
	cpu_flags_x86_3dnow? ( !cpu_flags_x86_sse !cpu_flags_x86_mmx )
	cpu_flags_x86_mmx? ( !cpu_flags_x86_3dnow !cpu_flags_x86_sse )
	cpu_flags_x86_sse? ( !cpu_flags_x86_3dnow !cpu_flags_x86_mmx )
	luajit? ( lua )
	native
	odbc? ( !sqlite )
	opengl
	!raspberry-pi
	raspberry-pi? (
		multitarget? (
			!system-angelscript
			!system-assimp
			!system-box2d
			!system-bullet
			!system-recastnavigation
			!system-freetype
			!system-glew
			!system-libcpuid
			!system-lua
			!system-luajit
			!system-lz4
			!system-mojoshader
			!system-nanodbc
			!system-pugixml
			!system-rapidjson
			!system-sdl
			!system-sqlite
			!system-tolua++
			!system-civetweb
			!system-slikenet ) )
	sound? ( threads alsa )
	sqlite? ( !odbc )
	static? ( static-libs )
	static-libs? ( static )
	!system-slikenet
	system-lua? ( system-tolua++ )
	system-tolua++? ( system-lua )
"
LUA_VER="5.2"
inherit multilib-minimal
# todo check multilib/32 bit, every linked lib should have ${MULTILIB_USEDEP}
RDEPEND="
android? ( dev-util/android-ndk )
bindings? ( sys-devel/llvm )
clang-tools? ( sys-devel/llvm )
javascript? ( dev-libs/urho3d-web
	      >=dev-util/emscripten-1.36.10
	      >=sys-devel/llvm-3.9.0 )
native? (
	alsa? ( media-libs/libsdl2:=[${MULTILIB_USEDEP},alsa,sound?,threads?,static-libs=] )
	angelscript? (
		system-angelscript? (
			dev-libs/angelscript:=[${MULTILIB_USEDEP},static-libs=]
		)
	)
	box2d? ( system-box2d? ( sci-physics/box2d:=[${MULTILIB_USEDEP},static=] ) )
	bullet? ( system-bullet? ( sci-physics/bullet ) )
	lua? (   system-lua? ( dev-lang/lua:${LUA_VER}=[static=] )
		 system-luajit? ( luajit? ( dev-lang/luajit[lua52compat] ) )
		!system-luajit? ( luajit? ( !dev-lang/luajit ) )
		 system-tolua++? ( dev-lua/tolua++:=[static=,urho3d,debug?] )
	)
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/libsdl2[${MULTILIB_USEDEP},X,opengl?]
	!odbc? ( sqlite? ( !dev-db/unixODBC[${MULTILIB_USEDEP}] ) )
	odbc? (
		system-nanodbc? (
			>=dev-db/nanodbc-2.12.4:=[${MULTILIB_USEDEP},-libcxx,boost_convert,static=,-unicode]
			dev-db/unixODBC
		)
	)
	network? (
		system-civetweb? ( www-servers/civetweb:=[static-libs=] )
		system-slikenet? ( net-misc/slikenet[${MULTILIB_USEDEP}] )
	)
	opengl? (
		system-glew? ( media-libs/glew:=[${MULTILIB_USEDEP},static-libs=] )
		system-libcpuid? ( sys-libs/libcpuid[${MULTILIB_USEDEP}] )
	)
	!opengl? (
		system-mojoshader? ( media-libs/mojoshader:=[static-libs=] )
		system-libcpuid? ( sys-libs/libcpuid[${MULTILIB_USEDEP}] )
	)
	recastnavigation? (
		system-recastnavigation? (
			dev-libs/recastnavigation:=[${MULTILIB_USEDEP},static=]
		)
	)
	sqlite? (
		system-sqlite? ( dev-db/sqlite:=[${MULTILIB_USEDEP},static-libs=] )
	)
	system-freetype? ( media-libs/freetype:=[${MULTILIB_USEDEP},static-libs=] )
	system-lz4? ( app-arch/lz4[${MULTILIB_USEDEP}] )
	system-pugixml? ( dev-libs/pugixml:=[${MULTILIB_USEDEP},static=] )
	system-rapidjson? ( dev-cpp/rapidjson )
	tools? ( system-assimp? ( media-libs/assimp:=[${MULTILIB_USEDEP},static=] ) )
	x11-apps/xrandr
	x11-libs/libX11[${MULTILIB_USEDEP}] )
raspberry-pi? ( alsa? ( media-libs/libsdl2:=[alsa,sound?,threads?,static-libs=] )
		media-libs/alsa-lib
                media-libs/libsdl2[X,opengl?]
		|| ( sys-fs/udev sys-apps/systemd )
		x11-apps/xrandr
		x11-libs/libX11 )"
DEPEND="${RDEPEND}
	dev-util/cmake"
RESTRICT="mirror"
EGIT_COMMIT="d34dda158ecd7694fcfd55684caade7e131b8a45"
SRC_URI=\
"https://github.com/urho3d/Urho3D/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils cmake-utils
S="${WORKDIR}/Urho3D-${EGIT_COMMIT}"
EPATCH_OPTS="--binary -p1"

pkg_setup() {
	if use android ; then
		ewarn \
"This feature has not been completely implemented on the ebuild level."
	fi
	if use raspberry-pi ; then
		ewarn \
"This feature has not been tested.  In theory, it should work with Gentoo's cross toolchain."
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
}

src_prepare() {
	default
	eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-testing-preprocessor.patch"
	eapply "${FILESDIR}/urho3d-1.8_alpha-use-system-libs-for-cmake-scripts.patch"

	# See https://github.com/orsonteodoro/oiledmachine-overlay/blob/47e071977b37023c07f612ecaebf235982a457c9/dev-libs/urho3d/urho3d-1.7.ebuild
	# for original code if results from conversion breaks

	# what a line ending mess, it uses both unix (\n) and dos (\r\n).
	if use native ; then
		use system-angelscript \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-angelscript.patch"
		use system-box2d \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-box2d.patch"
		use system-bullet \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-bullet-cflf.patch" \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-bullet-lf.patch"
		use system-recastnavigation \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-detour.patch"
		use system-glew \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-glew.patch"
		use system-libcpuid \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-libcpuid.patch"
		use system-lz4 \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-lz4-crlf.patch" \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-lz4-lf.patch"
		use system-nanodbc \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-nanodbc.patch"
		use system-pugixml \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-pugixml-crlf.patch" \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-pugixml-lf.patch"
		use system-rapidjson \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-rapidjson.patch"
		use system-sdl \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-sdl-crlf.patch" \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-sdl-lf.patch"
		use system-sdl \
			|| eapply "${FILESDIR}/urho3d-1.8_alpha-system-not-sdl.patch" \
		use system-sqlite \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-sqlite.patch"
		use system-tolua++ || use system-lua \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-toluapp-crlf.patch" \
			&& eapply "${FILESDIR}/urho3d-1.8_alpha-system-toluapp-lf.patch" \
		use system-civetweb \
			&& eapply --binary "${FILESDIR}/urho3d-1.8_alpha-system-civetweb.patch"
	fi

	cmake-utils_src_prepare
}

src_configure() {
	mylibs="-L/usr/$(get_libdir)"
	if use native ; then
		mydebug="-DCMAKE_BUILD_TYPE=Release"
		if use debug; then
			mydebug="-DCMAKE_BUILD_TYPE=Debug"
			append-cxxflags -g -O0
			append-cflags -g -O0
		else
			mydebug="-DCMAKE_BUILD_TYPE=Release"
		fi

		if use network; then
			if use boost; then
				mylibs+=" -lboost_system -lboost_thread -pthread"
			else
				mylibs+=" -lboost_system"
			fi
		fi
		use system-angelscript && use angelscript \
			&& mylibs+=" -langelscript_s"
		use system-box2d && use box2d \
			&& mylibs+=" -lBox2D"
		use system-bullet && use bullet \
			&& mylibs+=" $(pkg-config --libs bullet)"
		use system-civetweb && use network \
			&& mylibs+=" -lcivetweb"
		use system-glew && use opengl \
			&& mylibs+=" $(pkg-config --libs glew)"
		use system-freetype \
			&& mylibs+=" -lfreetype"
		use system-pugixml \
			&& mylibs+=" -lpugixml"
		use system-libcpuid && use opengl \
			&& mylibs+=" -lcpuid"
		use system-lua && use lua \
			&& mylibs+=" $(pkg-config --libs lua5.2) -ldl"
		use system-lz4 \
			&& mylibs+=" -llz4"
		#the documentation mentions that odbc has priority
		if use system-nanodbc && use odbc ; then
			mylibs+=" -lnanodbc -lc++"
		elif use odbc ; then
			mylibs+=\
" -L${WORKDIR}/${PN}-${PV}_build/Source/ThirdParty/nanodbc -lnanodbc"
		fi
		use system-recastnavigation && use recastnavigation \
			&& mylibs+=" -lDetour -lDetourCrowd -lDetourTileCache -lRecast"
		if use system-sdl ; then
			mylibs+=" $(pkg-config --libs sdl2)"
			append-cxxflags $(pkg-config --cflags sdl2)
			append-cflags $(pkg-config --cflags sdl2)
		fi
		use system-slikenet && use network \
			&& mylibs+=" -lSLikeNet"
		use system-sqlite && use sqlite \
			&& mylibs+=" -lsqlite3"
		use system-tolua++ && use lua \
			&& mylibs+=" $(pkg-config --libs lua5.2) -ldl -ltolua++"
	fi

        local mycmakeargs=(
		${mydebug}
		-DSYSTEM_LUA_VERSION="${LUA_VER}"
                -DURHO3D_ANGELSCRIPT=$(usex angelscript)
                -DURHO3D_BINDINGS=$(usex bindings)
                -DURHO3D_DATABASE_ODBC=$(usex odbc)
                -DURHO3D_DATABASE_SQLITE=$(usex sqlite)
                -DURHO3D_DOCS=$(usex docs)
                -DURHO3D_EXTRAS=$(usex extras)
                -DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_IK=$(usex ik)
                -DURHO3D_LOGGING=$(usex logging)
                -DURHO3D_LUA=$(usex lua)
                -DURHO3D_LUAJIT=$(usex luajit)
                -DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
                -DURHO3D_NAVIGATION=$(usex recastnavigation)
                -DURHO3D_NETWORK=$(usex network)
                -DURHO3D_PCH=$(usex pch)
                -DURHO3D_PHYSICS=$(usex bullet)
                -DURHO3D_PROFILING=$(usex profiling)
                -DURHO3D_SAFE_LUA=$(usex debug)
                -DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_SYSTEM_ANGELSCRIPT=$(usex system-angelscript)
		-DURHO3D_SYSTEM_ASSIMP=$(usex system-assimp)
		-DURHO3D_SYSTEM_BOOST=OFF
		-DURHO3D_SYSTEM_BOX2D=$(use system-box2d)
		-DURHO3D_SYSTEM_BULLET=$(use system-bullet)
		-DURHO3D_SYSTEM_CIVETWEB=$(use system-civetweb)
		-DURHO3D_SYSTEM_FREETYPE=$(use system-freetype)
		-DURHO3D_SYSTEM_GLEW=$(use system-glew)
		-DURHO3D_SYSTEM_IK=OFF
		-DURHO3D_SYSTEM_LIBCPUID=$(use system-libcpuid)
		-DURHO3D_SYSTEM_LUA=$(use system-lua)
		-DURHO3D_SYSTEM_LUAJIT=$(use system-luajit)
		-DURHO3D_SYSTEM_LZ4=$(use system-lz4)
		-DURHO3D_SYSTEM_MOJOSHADER=$(use system-mojoshader)
		-DURHO3D_SYSTEM_NANODBC=$(use system-nanodbc)
		-DURHO3D_SYSTEM_PUGIXML=$(use system-pugixml)
		-DURHO3D_SYSTEM_RAPIDJSON=$(use system-rapidjson)
		-DURHO3D_SYSTEM_RECASTNAVIGATION=$(use system-recastnavigation)
		-DURHO3D_SYSTEM_SDL=$(use system-sdl)
		-DURHO3D_SYSTEM_SLIKENET=OFF
		-DURHO3D_SYSTEM_SPINE=OFF
		-DURHO3D_SYSTEM_SQLITE=$(use system-sqlite)
		-DURHO3D_SYSTEM_STANHULL=OFF
		-DURHO3D_SYSTEM_STB=OFF
		-DURHO3D_SYSTEM_TOLUAPP=$(use system-tolua++)
		-DURHO3D_SYSTEM_WEBP=$(use system-webp)
                -DURHO3D_TESTING=$(usex test)
                -DURHO3D_THREADING=$(usex threads)
                -DURHO3D_TOOLS=$(usex tools)
                -DURHO3D_URHO2D=$(usex box2d)
                -DURHO3D_WEBP=$(usex webp)
        )
#                -DCMAKE_CROSSCOMPILING=$(usex multitarget)

	if use system-nanodbc && use odbc ; then
		mycmakeargs+=( -DURHO3D_NANODBC_EXTERNAL=1 )
	fi

	if use native ; then
		if use opengl ; then
			mycmakeargs+=( -DURHO3D_OPENGL=TRUE )
		fi

		if use abi_x86_64 ; then
			mycmakeargs+=( -DURHO3D_64BIT=1 )
		elif use cpu_flags_x86_sse ; then
			mycmakeargs+=( -DURHO3D_SSE=1 )
		elif use cpu_flags_x86_mmx ; then
			mycmakeargs+=( -DURHO3D_MMX=1 )
		elif use cpu_flags_x86_3dnow ; then
			mycmakeargs+=( -DURHO3D_3DNOW=1 )
		fi

		if use altivec ; then
			mycmakeargs+=( -DURHO3D_ALTIVEC=1 )
		fi

		if \
		   ( use system-glew && use opengl ) || \
                   ( use system-angelscript && use angelscript ) || \
		   ( use system-box2d && use box2d ) || \
		   ( use system-bullet && use bullet ) || \
		   ( use system-civetweb && use network ) || \
		     use system-freetype || \
                   ( use system-libcpuid && use opengl ) || \
		   ( use system-lua && use lua ) || \
                     use system-lz4 || \
		   ( use system-nanodbc && use odbc ) || \
		     use system-pugixml || \
		   ( use system-tolua++ && use lua ) || \
                   ( use system-recastnavigation && use recastnavigation ) || \
		     use system-sdl || \
	           ( use system-slikenet && use network ) || \
		   ( use system-sqlite && use sqlite ) ; then
			mycmakeargs+=( -DLIBS="${mylibs}" )
		fi

		if use static; then
			mycmakeargs+=( -DURHO3D_LIB_TYPE=STATIC )
		else
			mycmakeargs+=( -DURHO3D_LIB_TYPE=SHARED )
		fi
	elif use raspberry-pi ; then
		mycmakeargs+=( -DRPI=$(usex raspberry-pi) )
	elif use android ; then
		mycmakeargs+=( -DANDROID=$(usex android) )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	if use native ; then
		einfo \
"If it segfaults, try run to the program with -gl2.  glVertexAttribDivisorARB \
may be bugged for gl3."
	fi
}
