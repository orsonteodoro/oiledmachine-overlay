# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils multilib

DESCRIPTION="Urho3D game engine emscripten build"
HOMEPAGE="http://urho3d.github.io/"
SRC_URI="https://github.com/urho3d/Urho3D/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="1.6"
KEYWORDS="~amd64 ~ppc ~x86 ~arm"
IUSE="abi_mips_n64 boost sound alsa pulseaudio debug automated-testing javascript static static-libs +pch -docs pulseaudio -angelscript +lua -lua-jit -network -odbc sqlite +recast +box2d +bullet +opengl +samples -extras +tools -clang-tools -debug-raw-script-loader +filewatcher -c++11 -bindings logging profiling threads debug"
REQUIRED_USE="
	javascript
	odbc? ( !sqlite )
	sqlite? ( !odbc )
        clang-tools? ( c++11 !pch !static )
        javascript? ( angelscript? ( c++11 )  )
        abi_mips_n64? ( angelscript? ( c++11 ) )
	opengl
	static? ( static-libs )
	static-libs? ( static )
	javascript? ( static )
	javascript? ( !angelscript !bindings !network )
	lua-jit? ( lua )
	alsa? ( sound threads )
	sound? ( threads alsa )
	!threads
"
#javascript? ( threads? ( !network !sqlite )  )
#the following are untested so masked
#javascript/emscripten/html5
#raspberry-pi
#android
#	javascript? ( !angelscript !lua !lua-jit )

#multitarget !angelscript !network !bindings 

LUA_VER="5.2"
RDEPEND="javascript? ( sys-devel/llvm )
         clang-tools? ( sys-devel/llvm )
         bindings? ( sys-devel/llvm )
   	 javascript? ( >=dev-util/emscripten-1.36.10
		       >=sys-devel/llvm-3.9.0
	 )
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

src_prepare() {
	epatch "${FILESDIR}"/Urho3D-1.6-web-renaming.patch
	sed -i -e 's|-pthread|-pthread -DNANODBC_USE_BOOST_CONVERT|g' CMake/Modules/Urho3D-CMake-common.cmake || die j5
	sed -i -e 's|_strrev||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_ltoa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_ultoa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_i64toa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_ui64toa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_uitoa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_strlwr||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|_strupr||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6
	sed -i -e 's|itoa||g' ./Source/ThirdParty/SDL/CMakeLists.txt || die j6

	cmake-utils_src_prepare
}

src_configure() {
	mylibs="-L/usr/$(get_libdir)"

        local mycmakeargs=(
		${mydebug}
                $(cmake-utils_use lua URHO3D_LUA)
                $(cmake-utils_use lua-jit URHO3D_LUAJIT)
                $(cmake-utils_use network URHO3D_NETWORK)
                $(cmake-utils_use odbc URHO3D_DATABASE_ODBC)
                $(cmake-utils_use bullet URHO3D_PHYSICS)
                $(cmake-utils_use box2d URHO3D_URHO2D)
                $(cmake-utils_use angelscript URHO3D_ANGELSCRIPT)
                $(cmake-utils_use recast URHO3D_NAVIGATION)
                $(cmake-utils_use debug URHO3D_SAFE_LUA)
                $(cmake-utils_use debug-raw-script-loader URHO3D_LUA_RAW_SCRIPT_LOADER)
                $(cmake-utils_use samples URHO3D_SAMPLES)
                $(cmake-utils_use tools URHO3D_TOOLS)
                $(cmake-utils_use extras URHO3D_EXTRAS)
                $(cmake-utils_use docs URHO3D_DOCS)
                $(cmake-utils_use sqlite URHO3D_DATABASE_SQLITE)
                $(cmake-utils_use pch URHO3D_PCH)
                $(cmake-utils_use filewatcher URHO3D_FILEWATCHER)
                $(cmake-utils_use c++11 URHO3D_C++11)
                $(cmake-utils_use bindings URHO3D_BINDINGS)
                $(cmake-utils_use logging URHO3D_LOGGING)
                $(cmake-utils_use profiling URHO3D_PROFILING)
                $(cmake-utils_use automated-testing URHO3D_TESTING)
                $(cmake-utils_use threads URHO3D_THREADING)
        )

	myemscriptpath=$(find  /usr/share/emscripten-* -type d | head -n 1)
	mycmakeargs+=( $(cmake-utils_use javascript EMSCRIPTEN) )
	mycmakeargs+=( -DEMSCRIPTEN_ROOT_PATH="${myemscriptpath}" )
	mycmakeargs+=( -DWEB=1 )

	#cannot use -DCMAKE_TOOLCHAIN_FILE=${S}/CMake/Toolchains/emscripten.toolchain.cmake
	#emscripten.toolchain.cmake is explicitly stated here
	mycmakeargs+=( -DEMCC_VERSION=$(emcc --version | head -n1 | grep -o "[1-9.]" | tr '\n' '\0') )
	mycmakeargs+=( -DCMAKE_SYSTEM_NAME=Linux )
	mycmakeargs+=( -DCMAKE_SYSTEM_VERSION=1 )

	mycmakeargs+=( -DCMAKE_C_COMPILER="${myemscriptpath}/emcc" )
	mycmakeargs+=( -DCMAKE_CXX_COMPILER="${myemscriptpath}/em++" )
	mycmakeargs+=( -DCMAKE_AR="${myemscriptpath}/emar" )
	mycmakeargs+=( -DCMAKE_RANLIB="${myemscriptpath}/emranlib" )
	mycmakeargs+=( -DCMAKE_LINKER="${myemscriptpath}/emlink.py" )

	mycmakeargs+=( -DEMRUN="${myemscriptpath}/emrun" )
	mycmakeargs+=( -DEMPACKAGER="${myemscriptpath}/tools/file_packager.py" )
	mycmakeargs+=( -DEMBUILDER="${myemscriptpath}/embuilder.py" )

	mycmakeargs+=( -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER )
	mycmakeargs+=( -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY )
	mycmakeargs+=( -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY )

	mycmakeargs+=( -DCMAKE_C_COMPILER_ID_RUN=TRUE )
	mycmakeargs+=( -DCMAKE_C_COMPILER_ID=Clang )
	mycmakeargs+=( -DCMAKE_C_ABI_COMPILED=TRUE )
	mycmakeargs+=( -DCMAKE_C_SIZEOF_DATA_PTR=4 )

	mycmakeargs+=( -DCMAKE_CXX_COMPILER_ID_RUN=TRUE )
	mycmakeargs+=( -DCMAKE_CXX_COMPILER_ID=Clang )
	mycmakeargs+=( -DCMAKE_CXX_ABI_COMPILED=TRUE )
	mycmakeargs+=( -DCMAKE_CXX_SIZEOF_DATA_PTR=4 )

	mycmakeargs+=( -DCMAKE_REQUIRED_FLAGS="-s ERROR_ON_UNDEFINED_SYMBOLS=1" )

	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1" \
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	#deleting everything except the lib and the examples
	rm -rf "${D}"/usr/include/Urho3D
	rm -rf "${D}"/usr/share/Urho3D/{CMake,Docs,Resources,Scripts}
	rm -rf "${D}"/usr/share/doc/${P}
	rm -rf "${D}"/usr/bin/
}

pkg_postinst() {
	einfo "Use games-engines/urho3d to install include headers"
}
