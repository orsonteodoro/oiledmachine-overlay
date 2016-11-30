# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils

DESCRIPTION="Urho3D"
HOMEPAGE="http://urho3d.github.io/"
SRC_URI="https://github.com/urho3d/Urho3D/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="1.6"
KEYWORDS="~amd64 ~ppc ~x86 ~arm"
IUSE="vanilla system-network boost sound alsa pulseaudio sse debug automated-testing javascript static static-libs +pch -docs pulseaudio -angelscript +lua -lua-cxx-wrapper-safety-checks -lua-jit -network -odbc sqlite +navigation +2d-physics +3d-physics +opengl +samples -extras +tools -clang-tools -raw-script-loader +filewatcher -cxx11 -bindings logging profiling threads debug native raspberry-pi android multitarget"
REQUIRED_USE="sound? ( threads alsa ) alsa? ( sound threads ) opengl static? ( static-libs ) static-libs? ( static ) javascript? ( static multitarget ) ^^ ( native javascript raspberry-pi android ) lua-jit? ( lua ) javascript? ( !sse )"
#mask -network

LUA_VER="5.2"
RDEPEND="javascript? ( sys-devel/llvm )
         clang-tools? ( sys-devel/llvm )
         bindings? ( sys-devel/llvm )
	 native? ( x11-libs/libX11
                   x11-apps/xrandr
	           media-libs/alsa-lib
	           alsa? ( media-libs/libsdl2[alsa,sound?,threads?,static-libs=] )
	           media-libs/libsdl2[X,opengl?]
         )
	 raspberry-pi? ( x11-libs/libX11
                   	 x11-apps/xrandr
	           	 media-libs/alsa-lib
	           	 alsa? ( media-libs/libsdl2[alsa,sound?,threads?,static-libs=] )
			 || ( sys-fs/udev sys-apps/systemd )
	                 media-libs/libsdl2[X]
	                 media-libs/libsdl2[X,opengl?]
	 )
	 android? ( dev-util/android-ndk )
	 javascript? ( dev-util/emscripten 
		       sound? ( media-libs/libsdl2[sound?,threads?,static-libs] )
		     )
	 angelscript? ( dev-libs/angelscript[static-libs=] )
	 lua? ( dev-lang/lua:${LUA_VER}[static=]
		dev-lua/tolua++[static=]
                !vanilla? (
			lua-jit? ( dev-lang/luajit )
		)
	 )
	 system-network? (
		 network? ( www-servers/civetweb[static=] net-misc/knet[boost,static=] )
	 )
	 !system-network? (
		network? ( dev-libs/boost )
         )
	 odbc? ( dev-db/nanodbc[static=] )
	 sqlite? ( dev-db/sqlite[static-libs=] )
	 navigation? ( games-misc/recast[static=] )
	 2d-physics? ( sci-physics/box2d[static=] )
	 3d-physics? ( sci-physics/bullet )

	 opengl? ( media-libs/glew[static-libs=] sys-libs/libcpuid  )
	 !opengl? ( media-gfx/mojoshader[static=] sys-libs/libcpuid  )

	 media-libs/freetype[static-libs=]
	 app-arch/lz4
	 dev-libs/pugixml[static=]
	 dev-cpp/rapidjson

	 tools? ( media-libs/assimp[static=] )
	 "
#assimp is assetimporter dependency
#mustache is clang tools dependency from https://github.com/kainjow/Mustache
#todo jo, stanhull, stb #these may have been slightly modified
#spine didn't exist
#games-misc/recast has Recast, DetourCrowd, DetourTileCache, Detour
DEPEND="${RDEPEND}
	dev-util/cmake"
#REQUIRED_USE="network? ( boost )"

S="${WORKDIR}/Urho3D-${PV}"

pkg_setup() {
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
}

src_prepare() {
if ! use vanilla ; then
	sed -i -e 's|FreeType JO LZ4 PugiXml rapidjson SDL StanHull STB|JO StanHull STB|' Source/CMakeLists.txt || die p1
	sed -i -e 's|add_subdirectory (ThirdParty/AngelScript)||' Source/CMakeLists.txt || die p2
	sed -i -e 's|add_subdirectory (ThirdParty/Lua${JIT})||' Source/CMakeLists.txt || die p3
	sed -i -e 's|add_subdirectory (ThirdParty/toluapp/src/lib)||' Source/CMakeLists.txt || die p4
	if use system-network ; then
		sed -i -e 's|add_subdirectory (ThirdParty/Civetweb)||' Source/CMakeLists.txt || die p5
		sed -i -e 's|add_subdirectory (ThirdParty/kNet)||' Source/CMakeLists.txt || die p6
	fi
	sed -i -e 's|add_subdirectory (ThirdParty/nanodbc)||' Source/CMakeLists.txt || die p7
	sed -i -e 's|add_subdirectory (ThirdParty/SQLite)||' Source/CMakeLists.txt || die p8
	sed -i -e 's|add_subdirectory (ThirdParty/Detour)||' Source/CMakeLists.txt || die p9
	sed -i -e 's|add_subdirectory (ThirdParty/DetourCrowd)||' Source/CMakeLists.txt || die p10
	sed -i -e 's|add_subdirectory (ThirdParty/DetourTileCache)||' Source/CMakeLists.txt || die p11
	sed -i -e 's|add_subdirectory (ThirdParty/Recast)||' Source/CMakeLists.txt || die p12
	sed -i -e 's|add_subdirectory (ThirdParty/Box2D)||' Source/CMakeLists.txt || die p13
	sed -i -e 's|add_subdirectory (ThirdParty/spine)||' Source/CMakeLists.txt || die p14
	sed -i -e 's|add_subdirectory (ThirdParty/Bullet)||' Source/CMakeLists.txt || die p15
	sed -i -e 's|add_subdirectory (ThirdParty/GLEW)||' Source/CMakeLists.txt || die p16
	sed -i -e 's|add_subdirectory (ThirdParty/MojoShader)||' Source/CMakeLists.txt || die p17
	sed -i -e 's|add_subdirectory (ThirdParty/LibCpuId)||' Source/CMakeLists.txt || die p18

	sed -i -e 's|set (URHO3D_INCLUDE_DIRS ${URHO3D_HOME}/include ${URHO3D_HOME}/include/${PATH_SUFFIX}/ThirdParty)|set (URHO3D_INCLUDE_DIRS ${URHO3D_HOME}/include /usr/include)|' CMakeLists.txt || die

	sed -i -e 's|LibCpuId/libcpuid.h|libcpuid/libcpuid.h|' Source/Urho3D/Core/ProcessUtils.cpp || die p19

	for FILE in $(grep -l -r -e "#include <SDL" .)
	do
		sed -i -e 's|#include <SDL|#include <SDL2|' "${FILE}" || die p20
	done

	for FILE in $(grep -l -r -e "#include <PugiXml" .)
	do
		sed -i -e 's|#include <PugiXml/|#include <|' "${FILE}" || die p21
	done

	for FILE in $(grep -l -r -e "#include <LZ4" .)
	do
		sed -i -e 's|#include <LZ4/|#include <|' "${FILE}" || die p22
	done

	for FILE in $(grep -l -r -e "#include <GLEW" .)
	do
		sed -i -e 's|#include <GLEW|#include <GL|' "${FILE}" || die p23
	done

	for FILE in $(grep -l -r -e "#include <Bullet" .)
	do
		sed -i -e 's|#include <Bullet|#include <bullet|' "${FILE}" || die p24
	done

	for FILE in $(grep -l -r -e "#include <AngelScript" .)
	do
		sed -i -e 's|#include <AngelScript/|#include <|' "${FILE}" || die p25
	done

	for FILE in $(grep -l -r -e "#include <nanodbc" .)
	do
		sed -i -e 's|#include <nanodbc/|#include <|' "${FILE}" || die p26
	done

	if use system-network ; then
		for FILE in $(grep -l -r -e "#include <kNet/SharedPtr.h>" .)
		do
			sed -i -e 's|#include <kNet/SharedPtr.h>|#include <kNet/kNet/SharedPtr.h>|' "${FILE}" || die p27
		done

		for FILE in $(grep -l -r -e "#include <Civetweb" .)
		do
			sed -i -e 's|#include <Civetweb|#include <civetweb|' "${FILE}" || die p29
		done
	fi
	for FILE in $(grep -l -r -e "#include <toluapp/tolua++.h>" .)
	do
		sed -i -e 's|#include <toluapp/tolua++.h>|#include <tolua++.h>|' "${FILE}" || die p28
	done

	for FILE in $(grep -l -r -e "lua_objlen" .)
	do
		sed -i -e 's|lua_objlen|lua_rawlen|' "${FILE}" || die p30
	done

	for FILE in $(grep -l -r -e "struct luaL_reg" .)
	do
		sed -i -e 's|struct luaL_reg|struct luaL_Reg|' "${FILE}" || die p31
	done

	for FILE in $(grep -l -r -e "tolua_register_gc" .)
	do
		sed -i -e 's|tolua_register_gc|;//tolua_register_gc|' "${FILE}" || die p31
	done

	for FILE in $(grep -l -r -e "while (tileCache_->isObstacleQueueFull())" .)
	do
		sed -i -e 's|while (tileCache_->isObstacleQueueFull())|for(int i=0;i<128;i++)|' "${FILE}" || die p31
	done

	for FILE in $(grep -l -r -e "#include \"../LuaScript/ToluaUtils.h\"" .)
	do
		echo '#ifndef Mtolua_new' > "${FILE}.t" || die 31.1a
		echo '#define Mtolua_new(EXP) new EXP' >> "${FILE}.t" || die 31.1b
		echo '#endif' >> "${FILE}.t" || die 31.1c
		cat "${FILE}" >> "${FILE}.t" || die 31.1d
		mv "${FILE}.t" "${FILE}" || die 31.1e
	done

	sed -i -e "s|lua_State\* L1 = lua_getmainthread(L);|lua_State* L1 = L->l_G->mainthread;|" "Source/Urho3D/LuaScript/ToluaUtils.cpp" || die p31.4

	sed -i -e 's|set (INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty)|set (INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty /usr/include /usr/include/freetype2)|' Source/Urho3D/CMakeLists.txt || die p34

	if use system-network ; then
		mydellst="AngelScript,Assimp,Box2D,Bullet,Civetweb,Detour,DetourCrowd,DetourTileCache,FreeType,GLEW,kNet,LibCpuId,Lua,LuaJIT,LZ4,MojoShader,nanodbc,PugiXml,rapidjson,Recast,SDL,SQLite"
		rm -rf "${S}/Source/ThirdParty"/{AngelScript,Assimp,Box2D,Bullet,Civetweb,Detour,DetourCrowd,DetourTileCache,FreeType,GLEW,kNet,LibCpuId,Lua,LuaJIT,LZ4,MojoShader,nanodbc,PugiXml,rapidjson,Recast,SDL,SQLite,toluapp} || die p35
	else
		mydellst="AngelScript,Assimp,Box2D,Bullet,Detour,DetourCrowd,DetourTileCache,FreeType,GLEW,LibCpuId,Lua,LuaJIT,LZ4,MojoShader,nanodbc,PugiXml,rapidjson,Recast,SDL,SQLite"
		rm -rf "${S}/Source/ThirdParty"/{AngelScript,Assimp,Box2D,Bullet,Detour,DetourCrowd,DetourTileCache,FreeType,GLEW,LibCpuId,Lua,LuaJIT,LZ4,MojoShader,nanodbc,PugiXml,rapidjson,Recast,SDL,SQLite,toluapp} || die p35
	fi

	epatch "${FILESDIR}"/urho3d-1.5-rapidjson-1.patch || die p36
	epatch "${FILESDIR}"/urho3d-rapidjson-2.patch || die p37

	#use vanilla sdl instead of dollar enhancements
	#need to test
	epatch "${FILESDIR}"/urho3d-9999-r20161119-conditional-sdl-extensions.patch || die p38   #omit
	epatch "${FILESDIR}"/urho3d-9999-r20161119-conditional-sdl-extensions-2.patch || die p39 #omit
	epatch "${FILESDIR}"/urho3d-1.5-rapidjson3.patch || die p40

	sed -i -e 's|SOURCE_DIR ${CMAKE_SOURCE_DIR}/Source/ThirdParty/toluapp/src/bin|SOURCE_DIR /usr/bin|' Source/Urho3D/CMakeLists.txt || die p41
	sed -i -e 's|add_subdirectory (../ThirdParty/toluapp/src/bin ../ThirdParty/toluapp/src/bin)||' Source/Urho3D/CMakeLists.txt || die p42
	sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/tolua++ -E ${CMAKE_PROJECT_NAME} -L ToCppHook.lua -o ${CMAKE_CURRENT_BINARY_DIR}/${GEN_CPP_FILE} ${NAME}|COMMAND /usr/bin/tolua++ -E ${CMAKE_PROJECT_NAME} -L ToCppHook.lua -o ${CMAKE_CURRENT_BINARY_DIR}/${GEN_CPP_FILE} ${NAME}|' Source/Urho3D/CMakeLists.txt || die

	sed -i -e 's|add_subdirectory (../../ThirdParty/Assimp ../../ThirdParty/Assimp)||' Source/Tools/AssetImporter/CMakeLists.txt || die p43
	sed -i -e 's|set (INCLUDE_DIRS ../../ThirdParty/Assimp/include)|set (INCLUDE_DIRS /usr/include/assimp)|' Source/Tools/AssetImporter/CMakeLists.txt || die p44

	#sed -i -e 's|add_subdirectory (\${CMAKE_CURRENT_SOURCE_DIR}/../../ThirdParty/Mustache Mustache)||' Source/Clang-Tools/AutoBinder/CMakeLists.txt || die p45
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e  's|set \(TARGET_NAME AutoBinder\)|set (TARGET_NAME AutoBinder)\nadd_definitions (-D__STDC_LIMIT_MACROS=1 -D__STDC_CONSTANT_MACROS=1)\n|' Source/Clang-Tools/AutoBinder/CMakeLists.txt || die p46
	sed -i -e 's|set (TARGET_NAME StanHull)|set (TARGET_NAME StanHull)\nadd_definitions (-Wno-c++11-narrowing)\n|' Source/ThirdParty/StanHull/CMakeLists.txt || die p47
	sed -i -e 's|set (TARGET_NAME JO)|set (TARGET_NAME JO)\nadd_definitions (-Wno-c++11-narrowing)\n|' Source/ThirdParty/JO/CMakeLists.txt || die p48
	sed -i -e 's|set (ENGINE_INCLUDE_DIRS "${ENGINE_INCLUDE_DIRS} ${DASH}I\"\${includedir}/${PATH_SUFFIX}/ThirdParty/Bullet\"")|set (ENGINE_INCLUDE_DIRS /usr/include/bullet")|' ./Source/Urho3D/CMakeLists.txt || die p49

	sed -i -e 's|list (APPEND INCLUDE_DIRS ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty/Bullet)|list (APPEND INCLUDE_DIRS /usr/include/bullet)|' Source/Urho3D/CMakeLists.txt || die p50
	sed -i -e 's|list (APPEND INCLUDE_DIRS ${CMAKE_BINARY_DIR}/${DEST_INCLUDE_DIR}/ThirdParty/Detour)|list (APPEND INCLUDE_DIRS /usr/include/Detour)|' Source/Urho3D/CMakeLists.txt || die p51

	sed -i -e 's|list (APPEND EXCLUDED_SOURCE_DIRS LuaScript)|add_definitions (-DLUA_COMPAT_MODULE=1)\n\tlist (APPEND EXCLUDED_SOURCE_DIRS LuaScript)|' Source/Urho3D/CMakeLists.txt || die p52

	if use system-network ; then
		if use boost; then
			sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES}|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES} -extra-arg -I/usr/include/kNet -extra-arg -I/usr/include -extra-arg -DUNIX=1 -extra-arg -DKNET_USE_BOOST=1|' Source/Urho3D/CMakeLists.txt || die p55
		else
			sed -i -e 's|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES}|COMMAND ${CMAKE_BINARY_DIR}/bin/tool/clang/AutoBinder -p ${CMAKE_BINARY_DIR} -t ${CMAKE_BINARY_DIR}/bin/tool/clang/Templates -o ${CMAKE_CURRENT_BINARY_DIR}/generated ${SCRIPT_SUBSYSTEMS} ${ANNOTATED_SOURCES} -extra-arg -I/usr/include/kNet -extra-arg -I/usr/include -extra-arg -DUNIX=1|' Source/Urho3D/CMakeLists.txt || die p55
		fi
	fi
	sed -i -e 's|\|\| crowd_->getMaxAgentRadius() != maxAgentRadius_||' Source/Urho3D/Navigation/CrowdManager.cpp || die p56
	sed -i -e 's|crowd_->init(maxAgents_, maxAgentRadius_, navigationMesh_->navMesh_, CrowdAgentUpdateCallback)|crowd_->init(maxAgents_, maxAgentRadius_, navigationMesh_->navMesh_)|' Source/Urho3D/Navigation/CrowdManager.cpp || die p57
	epatch "${FILESDIR}"/urho-1.5-crowdmanager.patch

	#use vanilla box2d behavior 
	#need to test
if $(true); then #box2d fixes
	sed -i -e 's|b2Body\* body_;|b2Body* body_;bool m_useFixtureMass = true;|' Source/Urho3D/Urho2D/RigidBody2D.h || die p59
	sed -i -e 's|body_->m_useFixtureMass|m_useFixtureMass|' Source/Urho3D/Urho2D/RigidBody2D.cpp || die p60
fi

	sed -i -e 's|luaL_register(luaState_, NULL, reg);|luaL_setfuncs(luaState_, reg, 0);|' Source/Urho3D/LuaScript/LuaScript.cpp || die p61
	sed -i -e 's|#include <lualib.h>|#include <lua.h>\n#include <lualib.h>|g' Source/Urho3D/LuaScript/LuaScript.cpp || die p612

	if use system-network ; then
		sed -i -e "s|#include <kNet/kNet.h>|#include <sys/socket.h>\n#include <kNet/kNet.h>|" Source/Urho3D/Network/Network.cpp || die p63
	fi

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ExternalProject_Add \(tolua\+\+\r\n            SOURCE_DIR /usr/bin\r\n            CMAKE_ARGS -DURHO3D_LUAJIT=\$\{URHO3D_LUAJIT\} -DDEST_RUNTIME_DIR=\$\{CMAKE_BINARY_DIR\}/bin/tool -DBAKED_CMAKE_SOURCE_DIR=\$\{CMAKE_SOURCE_DIR\} \$\{IOS_FIX\}\)||' Source/Urho3D/CMakeLists.txt  || die p64
	sed -i -e "s|DEPENDS tolua++ \${API_PKG_FILE} \${PKG_FILES} LuaScript/pkgs/ToCppHook.lua|DEPENDS ${API_PKG_FILE} ${PKG_FILES} LuaScript/pkgs/ToCppHook.lua|" Source/Urho3D/CMakeLists.txt  || die p65

	if use system-network ; then
		if use boost; then
			sed -i -e 's|add_definitions (-DKNET_UNIX)|add_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nadd_definitions (-DKNET_USE_BOOST=1)\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66
		else
			sed -i -e 's|add_definitions (-DKNET_UNIX)|add_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66
		fi
		sed -i -e 's|add_definitions (-DURHO3D_NETWORK)|add_definitions (-DURHO3D_NETWORK)\nadd_definitions (-DUNIX)|g' CMake/Modules/Urho3D-CMake-common.cmake || die p66a
		sed -i -e 's|if (URHO3D_PHYSICS)|set (INCLUDE_DIRS ${INCLUDE_DIRS} /usr/include/kNet)\nif (URHO3D_PHYSICS)|' Source/Urho3D/CMakeLists.txt || die p66
	fi

	sed -i -r -e 's|table.getn[(]([^)]+)[)]|#\1|g' "${FILE}" Source/Urho3D/LuaScript/pkgs/ToCppHook.lua || die p68

	sed -i -e 's|add_definitions (-DURHO3D_LUA)|add_definitions (-DURHO3D_LUA)\nadd_definitions (-Wno-address-of-temporary)\n|g' CMake/Modules/Urho3D-CMake-common.cmake || die p69

	##START OF SCRIPTING EDITS

if $(true); then #scripting engine fixes

	for FILE in $(grep -l -r -e "tolua_property__get_set Vector2& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && ( "${FILE}" =~ "/Urho2D/" || "${FILE}" =~ "/Physics/" || "${FILE}" =~ "/Scene/" || "${FILE}" =~ "/UI/"  )   ]]; then
			sed -i -r -e 's|tolua_property__get_set Vector2& ([a-zA-Z0-9]+);|tolua_property__get_set Vector2 \1;|' "${FILE}" || die p72a
		fi
	done

	for FILE in $(grep -l -r -e "tolua_property__get_set Vector3& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && ( "${FILE}" =~ "/Physics/" || "${FILE}" =~ "/Scene/"  ) ]]; then
			sed -i -r -e 's|tolua_property__get_set Vector3& ([a-zA-Z0-9]+);|tolua_property__get_set Vector3 \1;|' "${FILE}" || die p72b
		fi
	done

	for FILE in $(grep -l -r -e "tolua_property__get_set Quaternion& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && ( "${FILE}" =~ "/Physics/" || "${FILE}" =~ "/Scene/"  ) ]]; then
			sed -i -r -e 's|tolua_property__get_set Quaternion& ([a-zA-Z0-9]+);|tolua_property__get_set Quaternion \1;|' "${FILE}" || die p72c
		fi
	done

	sed -i -e 's|bool GetDisableCollision() const;|bool GetDisableCollision() const;\n    Vector3 GetAxis() const;\n    Vector3 GetOtherAxis() const;\n|' Source/Urho3D/LuaScript/pkgs/Physics/Constraint.pkg || die p73

	sed -i -e 's|tolua_property__get_set Color& color;|tolua_property__get_set Color color;|' Source/Urho3D/LuaScript/pkgs/Urho2D/StaticSprite2D.pkg || die p74

	#need to test this block
	sed -i -e 's|engine->RegisterObjectMethod\("Constraint", "void set_axis\(const Vector3&in\)", asMETHOD\(Constraint, SetAxis\), asCALL_THISCALL\);|engine->RegisterObjectMethod("Constraint", "void set_axis(const Vector3&in)", asMETHOD(Constraint, SetAxis), asCALL_THISCALL);\n     engine->RegisterObjectMethod("Constraint", "void get_axis() const", asMETHOD(Constraint, GetAxis), asCALL_THISCALL);\n|' Source/Urho3D/AngelScript/PhysicsAPI.cpp || die p75
	sed -i -e 's|engine->RegisterObjectMethod\("Constraint", "void set_otherAxis\(const Vector3&in\)", asMETHOD\(Constraint, SetOtherAxis\), asCALL_THISCALL\);|engine->RegisterObjectMethod("Constraint", "void set_otherAxis(const Vector3&in)", asMETHOD(Constraint, SetOtherAxis), asCALL_THISCALL);\n     engine->RegisterObjectMethod("Constraint", "void get_otherAxis() const", asMETHOD(Constraint, GetOtherAxis), asCALL_THISCALL);\n|' Source/Urho3D/AngelScript/PhysicsAPI.cpp || die p76

	#need to test this block
	sed -i -e 's|#define TOLUA_DISABLE_tolua_get_Constraint_axis_ref||' Source/Urho3D/LuaScript/pkgs/Physics/Constraint.pkg || die p77
	sed -i -e 's|#define TOLUA_DISABLE_tolua_get_Constraint_otherAxis_ref||' Source/Urho3D/LuaScript/pkgs/Physics/Constraint.pkg || die p78
	sed -i -e 's|#define tolua_get_Constraint_axis_ref NULL||' Source/Urho3D/LuaScript/pkgs/Physics/Constraint.pkg || die p79
	sed -i -e 's|#define tolua_get_Constraint_otherAxis_ref NULL||' Source/Urho3D/LuaScript/pkgs/Physics/Constraint.pkg || die p80
	epatch "${FILESDIR}"/urho3d-1.5-constraintcpp.patch || die p81

	sed -i -e 's|tolua_property__get_set VariantMap& identity;|tolua_property__get_set VariantMap identity;|' Source/Urho3D/LuaScript/pkgs/Network/Connection.pkg || die p82
	sed -i -e 's|tolua_property__get_set Controls& controls;|tolua_property__get_set Controls controls;|' Source/Urho3D/LuaScript/pkgs/Network/Connection.pkg || die p83
	sed -i -e 's|tolua_property__get_set Vector3& position;|tolua_property__get_set Vector3 position;|' Source/Urho3D/LuaScript/pkgs/Network/Connection.pkg || die p84
	sed -i -e 's|tolua_property__get_set Quaternion& rotation;|tolua_property__get_set Quaternion rotation;|' Source/Urho3D/LuaScript/pkgs/Network/Connection.pkg || die p85

	sed -i -e 's|tolua_property__get_set Vector3& padding;|tolua_property__get_set Vector3 padding;|' Source/Urho3D/LuaScript/pkgs/Navigation/NavigationMesh.pkg

	for FILE in $(grep -l -r -e "tolua_property__get_set Color& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && ( "${FILE}" =~ "/Graphics/" || "${FILE}" =~ "/UI/"  ) ]]; then
			sed -i -r -e 's|tolua_property__get_set Color& ([a-zA-Z0-9]+);|tolua_property__get_set Color \1;|' "${FILE}" || die p72c
		fi
	done

	for FILE in $(grep -l -r -e "tolua_property__get_set BoundingBox& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && "${FILE}" =~ "/Graphics/" ]]; then
			sed -i -r -e 's|tolua_property__get_set BoundingBox& ([a-zA-Z0-9]+);|tolua_property__get_set BoundingBox \1;|' "${FILE}" || die p72c
		fi
	done

	for FILE in $(grep -l -r -e "tolua_property__get_set Plane& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && "${FILE}" =~ "/Graphics/" ]]; then
			sed -i -r -e 's|tolua_property__get_set Plane& ([a-zA-Z0-9]+);|tolua_property__get_set Plane \1;|' "${FILE}" || die p72c
		fi
	done

	sed -i -e 's|tolua_property__get_set IntRect& rect;|tolua_property__get_set IntRect rect;|' Source/Urho3D/LuaScript/pkgs/Graphics/Viewport.pkg || die p73
	sed -i -e 's|tolua_property__get_set BiasParameters& shadowBias;|tolua_property__get_set BiasParameters shadowBias;|' Source/Urho3D/LuaScript/pkgs/Graphics/Light.pkg  || die p74
	sed -i -e 's|tolua_property__get_set CascadeParameters& shadowCascade;|tolua_property__get_set CascadeParameters shadowCascade;|' Source/Urho3D/LuaScript/pkgs/Graphics/Light.pkg  || die p75
	sed -i -e 's|tolua_property__get_set FocusParameters& shadowFocus;|tolua_property__get_set FocusParameters shadowFocus;|' Source/Urho3D/LuaScript/pkgs/Graphics/Light.pkg  || die p76

	sed -i -e 's|tolua_property__get_set Vector2& projectionOffset;|tolua_property__get_set Vector2 projectionOffset;|' Source/Urho3D/LuaScript/pkgs/Graphics/Camera.pkg || die p77
	sed -i -e 's|tolua_property__get_set IntVector2& coordinates;|tolua_property__get_set IntVector2 coordinates;|'  Source/Urho3D/LuaScript/pkgs/Graphics/TerrainPatch.pkg  || die p78
	sed -i -e 's|tolua_property__get_set Vector3& spacing;|tolua_property__get_set Vector3 spacing;|' Source/Urho3D/LuaScript/pkgs/Graphics/Terrain.pkg || die p79

	epatch "${FILESDIR}"/urho-1.5-splinepath-valueanimation.patch


	for FILE in $(grep -l -r -e "tolua_property__get_set IntVector2& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && "${FILE}" =~ "/UI/" ]]; then
			sed -i -r -e 's|tolua_property__get_set IntVector2& ([a-zA-Z0-9]+);|tolua_property__get_set IntVector2 \1;|' "${FILE}" || die p72c
		fi
	done

	for FILE in $(grep -l -r -e "tolua_property__get_set IntRect& [a-zA-Z0-9]*;" .)
	do
		if [[ "${FILE}" =~ ".pkg" && "${FILE}" =~ "/UI/" ]]; then
			sed -i -r -e 's|tolua_property__get_set IntRect& ([a-zA-Z0-9]+);|tolua_property__get_set IntRect \1;|' "${FILE}" || die p72c
		fi
	done

	sed -i -e 's|tolua_property__get_set Color color; // Write only property.|tolua_property__get_set Color color; // Write only property.\n    tolua_property__get_set Corner corner;\n|' Source/Urho3D/LuaScript/pkgs/UI/Text3D.pkg || die p73

	epatch "${FILESDIR}"/urho3d-1.5-uielement.patch || die p74
	epatch "${FILESDIR}"/urho3d-1.6-corner.patch || die p75
	epatch "${FILESDIR}"/urho3d-1.5-corner2.patch || die p76
	epatch "${FILESDIR}"/urho3d-1.5-color-corner.patch || die p77

	#END OF SCRIPTING EDITS
fi

	sed -i -e 's|#include <tolua++.h>|extern "C" {\n#include <lua5.2/lstate.h>\n#include <lua.h>\n}\n#include <tolua++.h>\n\n|' Source/Urho3D/LuaScript/ToluaUtils.cpp || die p78
	sed -i -e 's|add_definitions (-DURHO3D_LUA)|list (APPEND INCLUDE_DIRS /usr/include/lua5.2)\nadd_definitions (-DLUA_COMPAT_MODULE=1)\nadd_definitions (-DURHO3D_LUA)|' CMake/Modules/Urho3D-CMake-common.cmake || die p79
	sed -i -e 's|#include <tolua++.h>|extern "C" {\n#include <lua5.2/lstate.h>\n#include <lua.h>\n}\n#include <tolua++.h>\n\n|' Source/Urho3D/LuaScript/LuaScriptInstance.cpp || die p80
	sed -i -e 's|#include <lua.h>|#include <lua5.2/lstate.h>\n#include <lua.h>|' Source/Urho3D/LuaScript/LuaFile.cpp || die p81
	sed -i -e 's|#include <lua.h>|#include <lua5.2/lstate.h>\n#include <lua.h>|' Source/Urho3D/LuaScript/LuaScript.cpp || die p82
	sed -i -e 's|#include <sqlext.h>|#include <sqlext.h>\n#include <nanodbc.h>|' Source/Urho3D/Database/ODBC/ODBCConnection.cpp || die p83

	sed -i -e 's|set (LIBS Assimp)|set (LIBS assimp)|' Source/Tools/AssetImporter/CMakeLists.txt || die p84
	sed -i -e 's|list (APPEND LIBS LZ4)|list (APPEND LIBS lz4)|' Source/Tools/PackageTool/CMakeLists.txt || die p85

	if use system-network ; then
		if use boost; then
			sed -i -e 's|set (TARGET_NAME 16_Chat)|set (TARGET_NAME 16_Chat)\nadd_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\nadd_definitions (-DKNET_USE_BOOST=1)\n|' Source/Samples/16_Chat/CMakeLists.txt || die p86
		else
			sed -i -e 's|set (TARGET_NAME 16_Chat)|set (TARGET_NAME 16_Chat)\nadd_definitions (-DKNET_UNIX)\nadd_definitions (-DUNIX=1)\n|' Source/Samples/16_Chat/CMakeLists.txt || die p86
		fi
		sed -i -e 's|set (INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})|set (INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})\nlist (APPEND INCLUDE_DIRS /usr/include/kNet)\n|'  Source/Samples/CMakeLists.txt || die p87
	fi

	#sed -i -e 's|if (instancingSupport_)|if (0)|' Source/Urho3D/Graphics/OpenGL/OGLGraphics.cpp #crashes

	sed -i -e 's|#include <SQLite/sqlite3.h>|#include <sqlite3.h>|' Source/Urho3D/Database/SQLite/SQLiteResult.h || die p88
	sed -i -e 's|#include <SQLite/sqlite3.h>|#include <sqlite3.h>|' Source/Urho3D/Database/SQLite/SQLiteConnection.h || die p89

	#URHO3D_TESTING was defined as false by default
	sed -i -e 's|#ifdef URHO3D_TESTING|#if URHO3D_TESTING|' Source/Urho3D/Core/ProcessUtils.cpp || die p90
	sed -i -e 's|#ifdef URHO3D_TESTING|#if URHO3D_TESTING|g' Source/Urho3D/Engine/Engine.cpp || die p91
	sed -i -e 's|SDL_AUDIO_ALLOW_ANY_CHANGE);|SDL_AUDIO_ALLOW_ANY_CHANGE);URHO3D_LOGWARNING(SDL_GetError());|' Source/Urho3D/Audio/Audio.cpp || die p92

if $(true); then #knet fixes
	#testing
	sed -i -e 's|network_ = new kNet::Network();|started = false;\nnetwork_ = new kNet::Network();|' Source/Urho3D/Network/Network.cpp || die p95
	sed -i -e 's|KNET_LOG(LogInfo, "Server up|started = true;\nKNET_LOG(LogInfo, "Server up|' Source/Urho3D/Network/Network.cpp || die p96
	sed -i -e 's|URHO3D_LOGINFO("Stopped server|started = false;\nURHO3D_LOGINFO("Stopped server|' Source/Urho3D/Network/Network.cpp || die p97
	sed -i -e 's|String packageCacheDir_;|String packageCacheDir_;\nbool started;|' ./Source/Urho3D/Network/Network.h || die p98
	sed -i -e 's|// Process the network server if started|if (!started) return;\n// Process the network server if started|' Source/Urho3D/Network/Network.cpp || die p99
	sed -i -e 's|return network_->GetServer();|return started;|' Source/Urho3D/Network/Network.cpp || die p99a
	sed -i -e 's|URHO3D_LOGINFO("Started server on port "|started = true;\nURHO3D_LOGINFO("Started server on port "|' Source/Urho3D/Network/Network.cpp || die p99b
	epatch "${FILESDIR}"/urho3d-9999-messageconnectionh.patch
else
	epatch "${FILESDIR}"/urho3d-9999-networkh-messageconnection.patch
fi

	#epatch "${FILESDIR}"/urho3d-9999-sprite-opassign.patch
if use odbc; then
	if use static; then
		sed -i -e "s|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_STATIC_LINKER_FLAGS \"\${CMAKE_STATIC_LINKER_FLAGS} -Qunused-arguments -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK\")|" Source/Urho3D/CMakeLists.txt || die p100
	else
		sed -i -e "s|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_SHARED_LINKER_FLAGS \"\${CMAKE_SHARED_LINKER_FLAGS} -Qunused-arguments -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK\")|" Source/Urho3D/CMakeLists.txt || die p101
	fi
	sed -i -e 's|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Qunused-arguments -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK")|' Source/Urho3D/CMakeLists.txt || die p102
	sed -i -e 's|set (TARGET_NAME Urho3D)|set (TARGET_NAME Urho3D)\nset (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Qunused-arguments -I/usr/include/c++/v1 -DBOOST_TEST_DYN_LINK")|' Source/Urho3D/CMakeLists.txt || die p103
fi

	sed -i -e 's|void SetDefaultStyle(XMLFile\* style);|void SetDefaultStyle(XMLFile\& style);|' Source/Urho3D/LuaScript/pkgs/Engine/DebugHud.pkg || die p104
	sed -i -e 's|tolua_property__get_set XMLFile\* defaultStyle;|tolua_property__get_set XMLFile defaultStyle;|' Source/Urho3D/LuaScript/pkgs/Engine/DebugHud.pkg || die p105
	sed -i -e 's|XMLFile\* GetDefaultStyle() const;|XMLFile\& GetDefaultStyle() const;|' Source/Urho3D/LuaScript/pkgs/Engine/DebugHud.pkg || die p106
	epatch "${FILESDIR}"/urho-9999-xmlfile-opassign.patch
	epatch "${FILESDIR}"/urho3d-9999-refcounted-opassign.patch
	epatch "${FILESDIR}"/urho3d-9999-opassign-texture2d-image-sprite.patch
	epatch "${FILESDIR}"/urho3d-9999-apitemplatesh-objectanimation.patch
	#epatch "${FILESDIR}"/urho3d-1.6-opassign-27edits.patch
	epatch "${FILESDIR}"/urho3d-9999-apitemplatesh-borderimage.patch
	epatch "${FILESDIR}"/urho3d-sprite2d.patch
	#epatch "${FILESDIR}"/urho3d-batchh.patch
	epatch "${FILESDIR}"/urho-viewh.patch
	epatch "${FILESDIR}"/urho3d-1.6-scriptcpp-propaccessormode.patch
	epatch "${FILESDIR}"/urho3d-graphics-windowicon.patch
	epatch "${FILESDIR}"/urho3d-graphics-getwindowicon.patch

	#epatch "${FILESDIR}"/urho3d-1.6-networkapi-sockaddr_in-header.patch
	epatch "${FILESDIR}"/urho3d-1.6-debug-hud-getdefaultstyle.patch
	#epatch "${FILESDIR}"/urho3d-1.6-resource-no-xmlfile-constructor.patch
	epatch "${FILESDIR}"/urho3d-1.6-xmlfile-constructor-1.patch
	epatch "${FILESDIR}"/urho3d-1.6-tolua-disable-add-external.patch
	#epatch "${FILESDIR}"/urho3d-1.6-getresource.patch
else
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e  's|set \(TARGET_NAME AutoBinder\)|set (TARGET_NAME AutoBinder)\nadd_definitions (-D__STDC_LIMIT_MACROS=1 -D__STDC_CONSTANT_MACROS=1)\n|' Source/Clang-Tools/AutoBinder/CMakeLists.txt || die v0
	sed -i -e 's|-pthread|-pthread -DNANODBC_USE_BOOST_CONVERT|g' CMake/Modules/Urho3D-CMake-common.cmake || die v1
	sed -i -e 's|_m_prefetch|__builtin_prefetch|g' Source/ThirdParty/SDL/src/video/SDL_blit_A.c || die v2
	#sed -i -e 's|PTHREAD_MUTEX_RECURSIVE|PTHREAD_MUTEX_RECURSIVE_NP|g' ./Source/Urho3D/Core/Mutex.cpp || die v3
fi

	cmake-utils_src_prepare
}

src_configure() {
if ! use vanilla ; then
	mylibs="-L/usr/$(get_libdir) $(pkg-config --libs sdl2) $(pkg-config --libs glew) -lfreetype -lpugixml -llz4 -lcpuid"
	append-cxxflags $(pkg-config --cflags sdl2)
	append-cflags $(pkg-config --cflags sdl2)

	if use lua; then
		mylibs+=" $(pkg-config --libs lua5.2) -ldl -ltolua++"
	fi

	if use angelscript; then
		mylibs+=" -langelscript_s"
	fi

	if use navigation; then
		mylibs+=" -lDetour -lDetourCrowd -lDetourTileCache -lRecast"
	fi

	#the documentation mentions that odbc has priority
	if use odbc; then
		if [[ "$(tc-getCC)" == "clang" || "$(tc-getCXX)" == "clang++" ]]; then
			mylibs+=" -lc++"
		fi
		mylibs+=" -lnanodbc"
	elif use sqlite; then
		mylibs+=" -lsqlite3"
	fi

	if use system-network ; then
		if use network; then
			mylibs+=" -lcivetweb -lkNet"
			if use boost; then
				mylibs+=" -lboost_system -lboost_thread -pthread"
			else
				mylibs+=" -lboost_system"
			fi
		fi
	else
		mylibs+=" -pthread"
	fi

	if use 2d-physics; then
		mylibs+=" -lBox2D"
	fi

	if use 3d-physics; then
		mylibs+=" $(pkg-config --libs bullet)"
	fi
fi

	mydebug="-DCMAKE_BUILD_TYPE=Release"
	if use debug; then
		mydebug="-DCMAKE_BUILD_TYPE=Debug"
		append-cxxflags -g -O0
		append-cflags -g -O0
	else
		mydebug="-DCMAKE_BUILD_TYPE=Release"
	fi

        local mycmakeargs=(
		${mydebug}
                $(cmake-utils_use lua URHO3D_LUA)
                $(cmake-utils_use lua-jit URHO3D_LUAJIT)
                $(cmake-utils_use network URHO3D_NETWORK)
                $(cmake-utils_use odbc URHO3D_DATABASE_ODBC)
                $(cmake-utils_use 3d-physics URHO3D_PHYSICS)
                $(cmake-utils_use 2d-physics URHO3D_URHO2D)
                $(cmake-utils_use angelscript URHO3D_ANGELSCRIPT)
                $(cmake-utils_use navigation URHO3D_NAVIGATION)
                $(cmake-utils_use lua-cxx-wrapper-safety-checks URHO3D_SAFE_LUA)
                $(cmake-utils_use raw-script-loader URHO3D_LUA_RAW_SCRIPT_LOADER)
                $(cmake-utils_use samples URHO3D_SAMPLES)
                $(cmake-utils_use tools URHO3D_TOOLS)
                $(cmake-utils_use extras URHO3D_EXTRAS)
                $(cmake-utils_use docs URHO3D_DOCS)
                $(cmake-utils_use sqlite URHO3D_DATABASE_SQLITE)
                $(cmake-utils_use pch URHO3D_PCH)
                $(cmake-utils_use filewatcher URHO3D_FILEWATCHER)
                $(cmake-utils_use cxx11 URHO3D_C++11)
                $(cmake-utils_use bindings URHO3D_BINDINGS)
                $(cmake-utils_use logging URHO3D_LOGGING)
                $(cmake-utils_use profiling URHO3D_PROFILING)
                $(cmake-utils_use automated-testing URHO3D_TESTING)
                $(cmake-utils_use threads URHO3D_THREADING)
                $(cmake-utils_use javascript EMSCRIPTEN)
                $(cmake-utils_use raspberry-pi RPI)
                $(cmake-utils_use android ANDROID)
                $(cmake-utils_use multitarget CMAKE_CROSSCOMPILING)
		$(cmake-utils_use sse URHO3D_SSE)
		-DURHO3D_OPENGL=TRUE
		-DRAPIDJSON_HAS_CXX11_RVALUE_REFS=1
        )

	if ! use vanilla; then
		mycmakeargs+=( -DLIBS="${mylibs}" )
	fi

	if use static; then
		mycmakeargs+=( -DURHO3D_LIB_TYPE=STATIC )
	else
		mycmakeargs+=( -DURHO3D_LIB_TYPE=SHARED )
	fi

	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1" \
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	#cp "${S}/godot_icon.png" "${D}/usr/share/godot"
	#make_desktop_entry "/usr/bin/godot" "Godot" "${ROOT}/usr/share/godot/godot_icon.png" "Development;IDE"
}

pkg_postinst() {
	einfo "If it segfaults, try run to the program with -gl2.  glVertexAttribDivisorARB may be bugged for gl3."
}
