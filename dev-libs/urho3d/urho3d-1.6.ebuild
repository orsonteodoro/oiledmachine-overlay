# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils multilib

DESCRIPTION="Urho3D game engine"
HOMEPAGE="http://urho3d.github.io/"
SRC_URI="https://github.com/urho3d/Urho3D/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.6"
KEYWORDS="~amd64 ~ppc ~x86 ~arm"
X86_CPU_FEATURES_RAW=( 3dnow mmx sse )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
IUSE="${X86_CPU_FEATURES[@]%:*} abi_mips_n64 system-angelscript system-assimp system-box2d system-bullet system-recastnavigation system-freetype system-glew system-libcpuid system-lua system-lua-jit system-lz4 system-mojoshader system-nanodbc system-pugixml system-rapidjson system-sdl system-sqlite system-tolua++ system-civetweb system-knet boost sound alsa pulseaudio debug automated-testing javascript static static-libs +pch -docs pulseaudio -angelscript +lua -lua-jit -network -odbc sqlite +recastnavigation +box2d +bullet +opengl +samples -extras +tools -clang-tools -debug-raw-script-loader +filewatcher -c++11 -bindings logging profiling threads debug native raspberry-pi android multitarget"
REQUIRED_USE="
	native
	odbc? ( !sqlite )
	sqlite? ( !odbc )
        clang-tools? ( c++11 !pch !static )
        abi_mips_n64? ( angelscript? ( c++11 ) )
	cpu_flags_x86_mmx? ( !cpu_flags_x86_sse )
	cpu_flags_x86_3dnow? ( !cpu_flags_x86_3dnow !cpu_flags_x86_mmx )
	opengl
	static? ( static-libs )
	static-libs? ( static )
	!raspberry-pi
	!android
	lua-jit? ( lua )
	raspberry-pi? ( multitarget? ( !system-angelscript !system-assimp !system-box2d !system-bullet !system-recastnavigation !system-freetype !system-glew !system-libcpuid !system-lua !system-lua-jit !system-lz4 !system-mojoshader !system-nanodbc !system-pugixml !system-rapidjson !system-sdl !system-sqlite !system-tolua++ !system-civetweb !system-knet ) )
	android? ( !system-angelscript !system-assimp !system-box2d !system-bullet !system-recastnavigation !system-freetype !system-glew !system-libcpuid !system-lua !system-lua-jit !system-lz4 !system-mojoshader !system-nanodbc !system-pugixml !system-rapidjson !system-sdl !system-sqlite !system-tolua++ !system-civetweb !system-knet )
	alsa? ( sound threads )
	sound? ( threads alsa )
"
#	^^ ( native multitarget )
#	^^ ( native javascript raspberry-pi android )
#	javascript? ( !angelscript !bindings )
#javascript? ( threads? ( !network !sqlite )  )
#the following are untested so masked
#javascript/emscripten/html5
#raspberry-pi
#android
#	javascript? ( !angelscript !lua !lua-jit )

#multitarget !angelscript !network !bindings 

LUA_VER="5.2"
RDEPEND="javascript? ( games-engines/urho3d-web )
         javascript? ( sys-devel/llvm )
         clang-tools? ( sys-devel/llvm )
         bindings? ( sys-devel/llvm )
	 native? ( x11-libs/libX11
                   x11-apps/xrandr
	           media-libs/alsa-lib
	           alsa? ( media-libs/libsdl2[alsa,sound?,threads?,static-libs=] )
	           media-libs/libsdl2[X,opengl?]
		   angelscript? ( system-angelscript? ( dev-libs/angelscript[static-libs=] ) )
		   lua? ( system-lua? ( dev-lang/lua:${LUA_VER}[static=] )
			system-tolua++? ( dev-lua/tolua++[static=,urho3d,debug?] )
			system-lua-jit? ( lua-jit? ( dev-lang/luajit[lua52compat] ) )
			!system-lua-jit? ( lua-jit? ( !dev-lang/luajit ) )
	           )
	           network? (
			 system-civetweb? (  www-servers/civetweb[static=] )
			 system-knet? ( net-misc/knet[boost,static=] )
		   )
		   odbc? ( system-nanodbc? ( >=dev-db/nanodbc-2.12.4[-libcxx,boost_convert,static=,-unicode]
                                             dev-db/unixODBC ) )
                   !odbc? ( sqlite? ( !dev-db/unixODBC ) )
		   sqlite? ( system-sqlite? ( dev-db/sqlite[static-libs=] ) )
		   recastnavigation? ( system-recastnavigation? ( games-misc/recastnavigation[static=] ) )
		   box2d? ( system-box2d? ( sci-physics/box2d[static=] ) )
		   bullet? ( system-bullet? ( sci-physics/bullet ) )
		   opengl? ( system-glew? ( media-libs/glew[static-libs=] )
	                   system-libcpuid? ( sys-libs/libcpuid )
	           )
		   !opengl? ( system-mojoshader? ( media-gfx/mojoshader[static=] )
	                    system-libcpuid? ( sys-libs/libcpuid )
	           )
		   system-freetype? ( media-libs/freetype[static-libs=] )
		   system-lz4? ( app-arch/lz4 )
		   system-pugixml? ( dev-libs/pugixml[static=] )
		   system-rapidjson? ( dev-cpp/rapidjson )
		   tools? ( system-assimp? ( media-libs/assimp[static=] ) )
         )
	 raspberry-pi? ( x11-libs/libX11
                   	 x11-apps/xrandr
	           	 media-libs/alsa-lib
	           	 alsa? ( media-libs/libsdl2[alsa,sound?,threads?,static-libs=] )
			 || ( sys-fs/udev sys-apps/systemd )
	                 media-libs/libsdl2[X]
	                 media-libs/libsdl2[X,opengl?]
	 )
   	 javascript? ( >=dev-util/emscripten-1.36.10
		       >=sys-devel/llvm-3.9.0
	 )
	 android? ( dev-util/android-ndk )
	 "
#assimp is assetimporter dependency
#mustache is clang tools dependency from https://github.com/kainjow/Mustache
#todo jo, stanhull, stb #these may have been slightly modified
#spine didn't exist
#games-misc/recastnavigation has Recast, DetourCrowd, DetourTileCache, Detour
DEPEND="${RDEPEND}
	dev-util/cmake"
#REQUIRED_USE="network? ( boost )"

S="${WORKDIR}/Urho3D-${PV}"

pkg_setup() {
	if use android ; then
		ewarn "This feature has not been completely implemented on the ebuild level."
	fi
	if use raspberry-pi ; then
		ewarn "This feature has not been tested.  In theory, it should work with Gentoo's cross toolchain."
	fi
	if use native ; then
	        if use debug; then
	                if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
	                        die Emerge again with FEATURES="nostrip" or remove the debug use flag
	                fi
	        fi

		if use native; then
			glxinfo | grep  EXT_framebuffer_object &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "Video card not supported.  Your machine does not meet the minimum requirements."
			fi
			glxinfo | grep EXT_packed_depth_stencil &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "Video card not supported.  Your machine does not meet the minimum requirements."
			fi
			cat /proc/cpuinfo | grep sse &>/dev/null
			if [[ "$?" != "0" ]]; then
				die "CPU not supported.  Your machine does not meet the minimum requirements."
			fi
		fi
	fi
}

src_prepare() {
	if use native ; then
		if use system-angelscript ; then
			rm -rf "${S}/Source/ThirdParty"/AngelScript
			sed -i -e 's|add_subdirectory (ThirdParty/AngelScript)||' Source/CMakeLists.txt || die p2
			for FILE in $(grep -l -r -e "#include <AngelScript" .)
			do
				sed -i -e 's|#include <AngelScript/|#include <|' "${FILE}" || die p25
			done
		fi
		if use system-assimp ; then
			rm -rf "${S}/Source/ThirdParty"/Assimp

			sed -i -e 's|add_subdirectory (../../ThirdParty/Assimp ../../ThirdParty/Assimp)||' Source/Tools/AssetImporter/CMakeLists.txt || die p43
			sed -i -e 's|set (INCLUDE_DIRS ../../ThirdParty/Assimp/include)|set (INCLUDE_DIRS /usr/include/assimp)|' Source/Tools/AssetImporter/CMakeLists.txt || die p44

			sed -i -e 's|set (LIBS Assimp)|set (LIBS assimp)|' Source/Tools/AssetImporter/CMakeLists.txt || die p84
		fi
		if use system-box2d ; then
			rm -rf "${S}/Source/ThirdParty"/Box2D
			sed -i -e 's|add_subdirectory (ThirdParty/Box2D)||' Source/CMakeLists.txt || die p13

			sed -i -e 's|b2Body\* body_;|b2Body* body_;bool m_useFixtureMass = true;|' Source/Urho3D/Urho2D/RigidBody2D.h || die p59
			sed -i -e 's|body_->m_useFixtureMass|m_useFixtureMass|' Source/Urho3D/Urho2D/RigidBody2D.cpp || die p60
		fi
		if use system-bullet ; then
			rm -rf "${S}/Source/ThirdParty"/Bullet
			sed -i -e 's|add_subdirectory (ThirdParty/Bullet)||' Source/CMakeLists.txt || die p15
			for FILE in $(grep -l -r -e "#include <Bullet" .)
			do
				sed -i -e 's|#include <Bullet|#include <bullet|' "${FILE}" || die p24
			done

			sed -i -e 's|list (APPEND INCLUDE_DIRS ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty/Bullet)|list (APPEND INCLUDE_DIRS /usr/include/bullet)|' Source/Urho3D/CMakeLists.txt || die p50
			sed -i -e 's|set (ENGINE_INCLUDE_DIRS "${ENGINE_INCLUDE_DIRS} ${DASH}I\"\${includedir}/${PATH_SUFFIX}/ThirdParty/Bullet\"")|set (ENGINE_INCLUDE_DIRS /usr/include/bullet")|' ./Source/Urho3D/CMakeLists.txt || die p49
		fi
		if use system-recastnavigation ; then
			rm -rf "${S}/Source/ThirdParty"/Detour
			rm -rf "${S}/Source/ThirdParty"/DetourCrowd
			rm -rf "${S}/Source/ThirdParty"/DetourTileCache
			rm -rf "${S}/Source/ThirdParty"/Recast
			sed -i -e 's|add_subdirectory (ThirdParty/Detour)||' Source/CMakeLists.txt || die p9
			sed -i -e 's|add_subdirectory (ThirdParty/DetourCrowd)||' Source/CMakeLists.txt || die p10
			sed -i -e 's|add_subdirectory (ThirdParty/DetourTileCache)||' Source/CMakeLists.txt || die p11
			sed -i -e 's|add_subdirectory (ThirdParty/Recast)||' Source/CMakeLists.txt || die p12

			sed -i -e 's|list (APPEND INCLUDE_DIRS ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty/Detour)|list (APPEND INCLUDE_DIRS /usr/include/Detour)|' Source/Urho3D/CMakeLists.txt || die p51

			sed -i -e 's|\|\| crowd_->getMaxAgentRadius() != maxAgentRadius_||' Source/Urho3D/Navigation/CrowdManager.cpp || die p56
			sed -i -e 's|crowd_->init(maxAgents_, maxAgentRadius_, navigationMesh_->navMesh_, CrowdAgentUpdateCallback)|crowd_->init(maxAgents_, maxAgentRadius_, navigationMesh_->navMesh_)|' Source/Urho3D/Navigation/CrowdManager.cpp || die p57
			eapply "${FILESDIR}"/urho-1.5-crowdmanager.patch || die p58z

			for FILE in $(grep -l -r -e "while (tileCache_->isObstacleQueueFull())" .)
			do
				sed -i -e 's|while (tileCache_->isObstacleQueueFull())|for(int i=0;i<128;i++)|' "${FILE}" || die p31
			done
		fi
		if use system-freetype ; then
			rm -rf "${S}/Source/ThirdParty"/FreeType
			sed -i -e 's|set (INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty)|set (INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty /usr/include /usr/include/freetype2)|' Source/Urho3D/CMakeLists.txt || die p34
			sed -i -e 's|FreeType ||' Source/CMakeLists.txt || die p1
		fi
		if use system-glew ; then
			rm -rf "${S}/Source/ThirdParty"/GLEW
			sed -i -e 's|add_subdirectory (ThirdParty/GLEW)||' Source/CMakeLists.txt || die p16
			for FILE in $(grep -l -r -e "#include <GLEW" .)
			do
				sed -i -e 's|#include <GLEW|#include <GL|' "${FILE}" || die p23
			done
		fi
		if use system-libcpuid ; then
			rm -rf "${S}/Source/ThirdParty"/LibCpuId
			sed -i -e 's|add_subdirectory (ThirdParty/LibCpuId)||' Source/CMakeLists.txt || die p18
			sed -i -e 's|LibCpuId/libcpuid.h|libcpuid/libcpuid.h|' Source/Urho3D/Core/ProcessUtils.cpp || die p19
		fi
		if use system-lua ; then
			rm -rf "${S}/Source/ThirdParty"/Lua
		fi
		if use system-lua-jit ; then
			rm -rf "${S}/Source/ThirdParty"/LuaJIT
		fi
		if use system-lz4 ; then
			rm -rf "${S}/Source/ThirdParty"/LZ4
			for FILE in $(grep -l -r -e "#include <LZ4" .)
			do
				sed -i -e 's|#include <LZ4/|#include <|' "${FILE}" || die p22
			done

			sed -i -e 's|list (APPEND LIBS LZ4)|list (APPEND LIBS lz4)|' Source/Tools/PackageTool/CMakeLists.txt || die p85
			sed -i -e 's|LZ4 ||' Source/CMakeLists.txt || die p1
		fi
		if use system-mojoshader ; then
			rm -rf "${S}/Source/ThirdParty"/MojoShader
			sed -i -e 's|add_subdirectory (ThirdParty/MojoShader)||' Source/CMakeLists.txt || die p17
		fi
		if use system-nanodbc ; then
			rm -rf "${S}/Source/ThirdParty"/nanodbc
			sed -i -e 's|add_subdirectory (ThirdParty/nanodbc)||' Source/CMakeLists.txt || die p7
			for FILE in $(grep -l -r -e "#include <nanodbc" .)
			do
				sed -i -e 's|#include <nanodbc/|#include <|' "${FILE}" || die p26
			done

			sed -i -e 's|#include <sqlext.h>|#include <sqlext.h>\n#include <nanodbc.h>|' Source/Urho3D/Database/ODBC/ODBCConnection.cpp || die p83
		else
			if use odbc ; then
				sed -i -e 's|-pthread|-pthread -DNANODBC_USE_BOOST_CONVERT|g' CMake/Modules/Urho3D-CMake-common.cmake || die v1b
			fi
		fi
		if use system-pugixml ; then
			rm -rf "${S}/Source/ThirdParty"/PugiXml
			for FILE in $(grep -l -r -e "#include <PugiXml" .)
			do
				sed -i -e 's|#include <PugiXml/|#include <|' "${FILE}" || die p21
			done
			sed -i -e 's|PugiXml ||' Source/CMakeLists.txt || die p1
		fi
		if use system-rapidjson ; then
			rm -rf "${S}/Source/ThirdParty"/rapidjson
			eapply "${FILESDIR}"/urho3d-1.5-rapidjson-1.patch || die p36
			eapply "${FILESDIR}"/urho3d-rapidjson-2.patch || die p37
			eapply "${FILESDIR}"/urho3d-1.5-rapidjson3.patch || die p40
			sed -i -e 's|rapidjson ||' Source/CMakeLists.txt || die p1
		fi
		if use system-sdl ; then
			rm -rf "${S}/Source/ThirdParty"/SDL
			for FILE in $(grep -l -r -e "#include <SDL" .)
			do
				sed -i -e 's|#include <SDL|#include <SDL2|' "${FILE}" || die p20
			done

			eapply "${FILESDIR}"/urho3d-9999-r20161119-conditional-sdl-extensions.patch || die p38   #omit
			eapply "${FILESDIR}"/urho3d-9999-r20161119-conditional-sdl-extensions-2.patch || die p39 #omit

			sed -i -e 's|SDL_AUDIO_ALLOW_ANY_CHANGE);|SDL_AUDIO_ALLOW_ANY_CHANGE);URHO3D_LOGWARNING(SDL_GetError());|' Source/Urho3D/Audio/Audio.cpp || die p92
			sed -i -e 's|SDL ||' Source/CMakeLists.txt || die p1
		else
			sed -i -e 's|_m_prefetch|__builtin_prefetch|g' Source/ThirdParty/SDL/src/video/SDL_blit_A.c || die v2
		fi
		if use system-sqlite ; then
			rm -rf "${S}/Source/ThirdParty"/SQLite
			sed -i -e 's|add_subdirectory (ThirdParty/SQLite)||' Source/CMakeLists.txt || die p8

			sed -i -e 's|#include <SQLite/sqlite3.h>|#include <sqlite3.h>|' Source/Urho3D/Database/SQLite/SQLiteResult.h || die p88
			sed -i -e 's|#include <SQLite/sqlite3.h>|#include <sqlite3.h>|' Source/Urho3D/Database/SQLite/SQLiteConnection.h || die p89
		fi
		if use system-tolua++ ; then
			rm -rf "${S}/Source/ThirdParty"/toluapp
			sed -i -e 's|add_subdirectory (ThirdParty/toluapp/src/lib)||' Source/CMakeLists.txt || die p4 #106
			for FILE in $(grep -l -r -e "#include <toluapp/tolua++.h>" .)
			do
				sed -i -e 's|#include <toluapp/tolua++.h>|#include <tolua++.h>|' "${FILE}" || die p28 #176
			done

			for FILE in $(grep -l -r -e "#include \"../LuaScript/ToluaUtils.h\"" .)
			do
				echo '#ifndef Mtolua_new' > "${FILE}.t" || die 31.1a #201
				echo '#define Mtolua_new(EXP) new EXP' >> "${FILE}.t" || die 31.1b
				echo '#endif' >> "${FILE}.t" || die 31.1c
				cat "${FILE}" >> "${FILE}.t" || die 31.1d
				mv "${FILE}.t" "${FILE}" || die 31.1e
			done

			sed -i -e 's|SOURCE_DIR ${CMAKE_SOURCE_DIR}/Source/ThirdParty/toluapp/src/bin|SOURCE_DIR /usr/bin|' Source/Urho3D/CMakeLists.txt || die p41 #229
			sed -i -e 's|add_subdirectory (../ThirdParty/toluapp/src/bin ../ThirdParty/toluapp/src/bin)||' Source/Urho3D/CMakeLists.txt || die p42 #230
			sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/tolua++ -E ${CMAKE_PROJECT_NAME} -L ToCppHook.lua -o ${CMAKE_CURRENT_BINARY_DIR}/${GEN_CPP_FILE} ${NAME}|COMMAND /usr/bin/tolua++ -E ${CMAKE_PROJECT_NAME} -L ToCppHook.lua -o ${CMAKE_CURRENT_BINARY_DIR}/${GEN_CPP_FILE} ${NAME}|' Source/Urho3D/CMakeLists.txt || die 43z #231

			sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ExternalProject_Add \(tolua\+\+\r\n            SOURCE_DIR /usr/bin\r\n            CMAKE_ARGS -DURHO3D_LUAJIT=\$\{URHO3D_LUAJIT\} -DDEST_RUNTIME_DIR=\$\{CMAKE_BINARY_DIR\}/bin/tool -DBAKED_CMAKE_SOURCE_DIR=\$\{CMAKE_SOURCE_DIR\} \$\{IOS_FIX\}\)||' Source/Urho3D/CMakeLists.txt  || die p64 #272
			sed -i -e "s|DEPENDS tolua++ \${API_PKG_FILE} \${PKG_FILES} LuaScript/pkgs/ToCppHook.lua|DEPENDS ${API_PKG_FILE} ${PKG_FILES} LuaScript/pkgs/ToCppHook.lua|" Source/Urho3D/CMakeLists.txt  || die p65 #273
		fi
		if use system-civetweb ; then
			rm -rf "${S}/Source/ThirdParty"/Civetweb
			sed -i -e 's|add_subdirectory (ThirdParty/Civetweb)||' Source/CMakeLists.txt || die p5
			for FILE in $(grep -l -r -e "#include <Civetweb" .)
			do
				sed -i -e 's|#include <Civetweb|#include <civetweb|' "${FILE}" || die p29
			done
		fi
		if use system-knet ; then
			rm -rf "${S}/Source/ThirdParty"/kNet
			sed -i -e 's|add_subdirectory (ThirdParty/kNet)||' Source/CMakeLists.txt || die p6
			for FILE in $(grep -l -r -e "#include <kNet/SharedPtr.h>" .)
			do
				sed -i -e 's|#include <kNet/SharedPtr.h>|#include <kNet/kNet/SharedPtr.h>|' "${FILE}" || die p27
			done

			if use boost; then
				sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES}|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES} -extra-arg -I/usr/include/kNet -extra-arg -I/usr/include -extra-arg -DUNIX=1 -extra-arg -DKNET_USE_BOOST=1|' Source/Urho3D/CMakeLists.txt || die p55 #249
				sed -i -e 's|add_definitions (-DKNET_UNIX)|add_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nadd_definitions (-DKNET_USE_BOOST=1)\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66 #277
				sed -i -e 's|set (TARGET_NAME 16_Chat)|set (TARGET_NAME 16_Chat)\nadd_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nadd_definitions (-DKNET_USE_BOOST=1)\n|' Source/Samples/16_Chat/CMakeLists.txt || die p86 #405
			else
				sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES}|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES} -extra-arg -I/usr/include/kNet -extra-arg -I/usr/include -extra-arg -DUNIX=1|' Source/Urho3D/CMakeLists.txt || die p55 #249
				sed -i -e 's|add_definitions (-DKNET_UNIX)|add_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66 #279
				sed -i -e 's|set (TARGET_NAME 16_Chat)|set (TARGET_NAME 16_Chat)\nadd_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\n|' Source/Samples/16_Chat/CMakeLists.txt || die p86 #407
			fi

			sed -i -e "s|#include <kNet/kNet.h>|#include <sys/socket.h>\n#include <kNet/kNet.h>|" Source/Urho3D/Network/Network.cpp || die p63 #269
			sed -i -e 's|add_definitions (-DURHO3D_NETWORK)|add_definitions (-DURHO3D_NETWORK)\nadd_definitions (-DUNIX)|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66a #281
			sed -i -e 's|if (URHO3D_PHYSICS)|set (INCLUDE_DIRS ${INCLUDE_DIRS} /usr/include/kNet)\nif (URHO3D_PHYSICS)|' Source/Urho3D/CMakeLists.txt || die p66 #282

			sed -i -e 's|set (INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})|set (INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|'  Source/Samples/CMakeLists.txt || die p87 #409

			eapply "${FILESDIR}"/urho3d-9999-networkh-messageconnection.patch || die p101z #433
		fi

		#tolua++ uses lua5.2 and external lua requires 5.2
		#lua 5.2 migration
		if use system-tolua++ && use lua || use system-lua && use lua ; then
			sed -i -e 's|add_subdirectory (ThirdParty/Lua${JIT})||' Source/CMakeLists.txt || die p3 #105

			for FILE in $(grep -l -r -e "lua_objlen" .) #179
			do
				sed -i -e 's|lua_objlen|lua_rawlen|' "${FILE}" || die p30
			done

			for FILE in $(grep -l -r -e "struct luaL_reg" .) #184
			do
				sed -i -e 's|struct luaL_reg|struct luaL_Reg|' "${FILE}" || die p31
			done

			sed -i -e "s|lua_State\* L1 = lua_getmainthread(L);|lua_State* L1 = L->l_G->mainthread;|" Source/Urho3D/LuaScript/ToluaUtils.cpp || die p31.4 #208
			sed -i -e 's|list (APPEND EXCLUDED_SOURCE_DIRS LuaScript)|add_definitions (-DLUA_COMPAT_MODULE=1)\n\tlist (APPEND EXCLUDED_SOURCE_DIRS LuaScript)|' Source/Urho3D/CMakeLists.txt || die p52 #245
			sed -i -e 's|luaL_register(luaState_, NULL, reg);|luaL_setfuncs(luaState_, reg, 0);|' Source/Urho3D/LuaScript/LuaScript.cpp || die p61 #265
			sed -i -e 's|#include <lualib.h>|#include <lua.h>\n#include <lualib.h>|g' Source/Urho3D/LuaScript/LuaScript.cpp || die p612 #266
			sed -i -r -e 's|table.getn[(]([^)]+)[)]|#\1|g' "${FILE}" Source/Urho3D/LuaScript/pkgs/ToCppHook.lua || die p68 #285
			sed -i -e 's|#include <tolua++.h>|extern "C" {\n#include <lua5.2/lstate.h>\n#include <lua.h>\n}\n#include <tolua++.h>\n\n|' Source/Urho3D/LuaScript/ToluaUtils.cpp || die p78 #393
			sed -i -e 's|add_definitions (-DURHO3D_LUA)|list (APPEND INCLUDE_DIRS /usr/include/lua5.2)\nadd_definitions (-DLUA_COMPAT_MODULE=1)\nadd_definitions (-DURHO3D_LUA)|' CMake/Modules/Urho3D-CMake-common.cmake || die p79 #394
			sed -i -e 's|#include <tolua++.h>|extern "C" {\n#include <lua5.2/lstate.h>\n#include <lua.h>\n}\n#include <tolua++.h>\n\n|' Source/Urho3D/LuaScript/LuaScriptInstance.cpp || die p80 #395
			sed -i -e 's|#include <lua.h>|#include <lua5.2/lstate.h>\n#include <lua.h>|' Source/Urho3D/LuaScript/LuaFile.cpp || die p81 #396
			sed -i -e 's|#include <lua.h>|#include <lua5.2/lstate.h>\n#include <lua.h>|' Source/Urho3D/LuaScript/LuaScript.cpp || die p82 #397

			eapply "${FILESDIR}"/urho3d-1.6-tolua-disable-add-external.patch || die p83z
		fi

		sed -i -e 's|set (URHO3D_INCLUDE_DIRS ${URHO3D_HOME}/include ${URHO3D_HOME}/include/${PATH_SUFFIX}/ThirdParty)|set (URHO3D_INCLUDE_DIRS ${URHO3D_HOME}/include ${URHO3D_HOME}/include/${PATH_SUFFIX}/ThirdParty /usr/include)|' CMakeLists.txt || die 100 #124

		if use clang-tools ; then
			#sed -i -e 's|add_subdirectory (\${CMAKE_CURRENT_SOURCE_DIR}/../../ThirdParty/Mustache Mustache)||' Source/Clang-Tools/AutoBinder/CMakeLists.txt || die p45 #236
			sed -i -r -e ':a' -e 'N' -e '$!ba' -e  's|set \(TARGET_NAME AutoBinder\)|set (TARGET_NAME AutoBinder)\nadd_definitions (-D__STDC_LIMIT_MACROS=1 -D__STDC_CONSTANT_MACROS=1)\n|' Source/Clang-Tools/AutoBinder/CMakeLists.txt || die p46 #237
		fi

		if use static; then
			sed -i -e "s|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_STATIC_LINKER_FLAGS \"\${CMAKE_STATIC_LINKER_FLAGS}\")|" Source/Urho3D/CMakeLists.txt || die p100
		else
			sed -i -e "s|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_SHARED_LINKER_FLAGS \"\${CMAKE_SHARED_LINKER_FLAGS}\")|" Source/Urho3D/CMakeLists.txt || die p101
		fi

		#URHO3D_TESTING was defined as false by default
		sed -i -e 's|#ifdef URHO3D_TESTING|#if URHO3D_TESTING|' Source/Urho3D/Core/ProcessUtils.cpp || die p90 #418
		sed -i -e 's|#ifdef URHO3D_TESTING|#if URHO3D_TESTING|g' Source/Urho3D/Engine/Engine.cpp || die p91 #419
	fi

	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
	mylibs="-L/usr/$(get_libdir)"
	if use native ; then
		if use system-sdl ; then
			mylibs+=" $(pkg-config --libs sdl2)"
			append-cxxflags $(pkg-config --cflags sdl2)
			append-cflags $(pkg-config --cflags sdl2)
		fi
		if use system-glew && use opengl ; then
			mylibs+=" $(pkg-config --libs glew)"
		fi
		if use system-freetype ; then
			mylibs+=" -lfreetype"
		fi

		if use system-pugixml ; then
			mylibs+=" -lpugixml"
		fi
		if use system-lz4 ; then
			mylibs+=" -llz4"
		fi
		if use system-libcpuid && use opengl ; then
			mylibs+=" -lcpuid"
		fi

		if use system-lua && use lua ; then
			mylibs+=" $(pkg-config --libs lua5.2) -ldl"
		fi

		if use system-tolua++ && use lua ; then
			mylibs+=" $(pkg-config --libs lua5.2) -ldl -ltolua++"
		fi

		if use system-angelscript && use angelscript ; then
			mylibs+=" -langelscript_s"
		fi

		if use system-recastnavigation && use recastnavigation ; then
			mylibs+=" -lDetour -lDetourCrowd -lDetourTileCache -lRecast"
		fi
		#the documentation mentions that odbc has priority
		if use system-nanodbc && use odbc ; then
			mylibs+=" -lnanodbc -lc++"
		elif use odbc ; then
			mylibs+=" -L${WORKDIR}/${PN}-${PV}_build/Source/ThirdParty/nanodbc -lnanodbc"
		fi
		if use system-sqlite && use sqlite ; then
			mylibs+=" -lsqlite3"
		fi

		if use system-civetweb && use network ; then
			mylibs+=" -lcivetweb"
		fi
		if use system-knet && use network ; then
			mylibs+=" -lkNet"
		fi
		if use network; then
			if use boost; then
				mylibs+=" -lboost_system -lboost_thread -pthread"
			else
				mylibs+=" -lboost_system"
			fi
		fi

		if use system-box2d && use box2d ; then
			mylibs+=" -lBox2D"
		fi

		if use system-bullet && use bullet ; then
			mylibs+=" $(pkg-config --libs bullet)"
		fi

		mydebug="-DCMAKE_BUILD_TYPE=Release"
		if use debug; then
			mydebug="-DCMAKE_BUILD_TYPE=Debug"
			append-cxxflags -g -O0
			append-cflags -g -O0
		else
			mydebug="-DCMAKE_BUILD_TYPE=Release"
		fi
	fi

        local mycmakeargs=(
		${mydebug}
                -DURHO3D_LUA=$(usex lua)
                -DURHO3D_LUAJIT=$(usex lua-jit)
                -DURHO3D_NETWORK=$(usex network)
                -DURHO3D_DATABASE_ODBC=$(usex odbc)
                -DURHO3D_PHYSICS=$(usex bullet)
                -DURHO3D_URHO2D=$(usex box2d)
                -DURHO3D_ANGELSCRIPT=$(usex angelscript)
                -DURHO3D_NAVIGATION=$(usex recastnavigation)
                -DURHO3D_SAFE_LUA=$(usex debug)
                -DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
                -DURHO3D_SAMPLES=$(usex samples)
                -DURHO3D_TOOLS=$(usex tools)
                -DURHO3D_EXTRAS=$(usex extras)
                -DURHO3D_DOCS=$(usex docs)
                -DURHO3D_DATABASE_SQLITE=$(usex sqlite)
                -DURHO3D_PCH=$(usex pch)
                -DURHO3D_FILEWATCHER=$(usex filewatcher)
                -DURHO3D_C++11=$(usex c++11)
                -DURHO3D_BINDINGS=$(usex bindings)
                -DURHO3D_LOGGING=$(usex logging)
                -DURHO3D_PROFILING=$(usex profiling)
                -DURHO3D_TESTING=$(usex automated-testing)
                -DURHO3D_THREADING=$(usex threads)
        )
#                -DCMAKE_CROSSCOMPILING=$(usex multitarget)

	if use system-nanodbc && use odbc ; then
		mycmakeargs+=( -DURHO3D_NANODBC_EXTERNAL=1 )
	fi

	if use native ; then
		if use opengl ; then
			mycmakeargs+=( -DURHO3D_OPENGL=TRUE )
		fi

		#if use c++11 ; then
		#	mycmakeargs+=( -DRAPIDJSON_HAS_CXX11_RVALUE_REFS=1 )
		#fi

		if use abi_x86_64 ; then
			mycmakeargs+=( -DURHO3D_64BIT=1 )
		elif use cpu_flags_x86_sse ; then
			mycmakeargs+=( -DURHO3D_SSE=1 )
		elif use cpu_flags_x86_mmx ; then
			mycmakeargs+=( -DURHO3D_MMX=1 )
		elif use cpu_flags_x86_3dnow ; then
			mycmakeargs+=( -DURHO3D_3DNOW=1 )
		fi

		if use system-sdl || \
		   ( use system-glew && use opengl ) || \
		   use system-freetype || \
		   use system-pugixml || \
                   use system-lz4 || \
                   ( use system-libcpuid && use opengl ) || \
		   ( use system-lua && use lua ) || \
		   ( use system-tolua++ && use lua ) || \
                   ( use system-angelscript && use angelscript ) || \
                   ( use system-recastnavigation && use recastnavigation ) || \
		   ( use system-nanodbc && use odbc ) || \
		   ( use system-sqlite && use sqlite ) || \
		   ( use system-civetweb && use network ) || \
	           ( use system-knet && use network ) || \
		   ( use system-box2d && use box2d ) || \
		   ( use system-bullet && use bullet ) ; then
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
	MAKEOPTS="-j1" \
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	if use native ; then
		einfo "If it segfaults, try run to the program with -gl2.  glVertexAttribDivisorARB may be bugged for gl3."
	fi
}
