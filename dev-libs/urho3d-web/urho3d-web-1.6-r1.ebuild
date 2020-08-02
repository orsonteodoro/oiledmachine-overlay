# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils multilib

DESCRIPTION="Urho3D game engine emscripten build"
HOMEPAGE="http://urho3d.github.io/"
SRC_URI="https://github.com/urho3d/Urho3D/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~arm"
IUSE="abi_mips_n64 boost sound alsa pulseaudio debug automated-testing javascript static static-libs +pch -docs pulseaudio -angelscript +lua -lua-jit -network -odbc sqlite +recastnavigation +box2d +bullet +opengl +samples -extras +tools -clang-tools -debug-raw-script-loader +filewatcher -c++11 -bindings logging profiling threads debug"
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
#dev-libs/recastnavigation has Recast, DetourCrowd, DetourTileCache, Detour
DEPEND="${RDEPEND}
	dev-util/cmake"
#REQUIRED_USE="network? ( boost )"

S="${WORKDIR}/Urho3D-${PV}"

src_prepare() {
	eapply "${FILESDIR}"/Urho3D-1.6-web-renaming.patch
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

	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
	mylibs="-L/usr/$(get_libdir)"

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

	myemscriptpath=$(find  /usr/share/emscripten-* -type d | head -n 1)
	mycmakeargs+=( -DEMSCRIPTEN=$(usex javascript) )
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
	einfo "Use dev-libs/urho3d to install include headers"
}
