# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Urho3D game engine emscripten build"
HOMEPAGE="http://urho3d.github.io/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
SLOT="0/${PV}"
IUSE="   abi_mips_n64
	 alsa
	-angelscript
	 automated-testing
	-bindings
	 boost
	+box2d
	+bullet
	-clang-tools
	+c++11
	 debug
	-debug-raw-script-loader
	-docs
	-extras
	+filewatcher
	+javascript
	 logging
	+lua
	-lua-jit
	-network
	+pch
	-odbc
	+opengl
	 profiling
	 pulseaudio
	+recastnavigation
	+samples
	 sound
	 sqlite
	+static
	+static-libs
	+tools
	 threads"
REQUIRED_USE="
	!threads
	 abi_mips_n64? ( angelscript? ( c++11 ) )
	 alsa? ( sound threads )
	 c++11
	 clang-tools? ( c++11 !pch !static )
	 javascript
	 javascript? ( !angelscript !bindings !network angelscript? ( c++11 ) \
			static )
	 lua-jit? ( lua )
	 odbc? ( !sqlite )
	 opengl
	 sound? ( threads alsa )
	 sqlite? ( !odbc )
	 static? ( static-libs )
	 static-libs? ( static )"
LUA_VER="5.2"
RDEPEND="bindings? ( sys-devel/llvm )
	 clang-tools? ( sys-devel/llvm )
	 javascript? ( >=dev-util/emscripten-1.36.10[wasm(+)] )"
DEPEND="${RDEPEND}
	dev-util/cmake"
inherit eutils cmake-utils multilib
MY_PV="1.8-ALPHA"
SRC_URI="https://github.com/urho3d/Urho3D/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Urho3D-${MY_PV}"
RESTRICT="mirror"

pkg_setup() {
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
}

src_prepare() {
	eapply "${FILESDIR}"/Urho3D-1.8-web-renaming.patch
	sed -i -e 's|-pthread|-pthread -DNANODBC_USE_BOOST_CONVERT|g' \
		CMake/Modules/UrhoCommon.cmake || die
	sed -i -e 's|_i64toa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_ltoa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_strlwr||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_strupr||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_ui64toa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_uitoa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_ultoa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|_strrev||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	sed -i -e 's|itoa||g' Source/ThirdParty/SDL/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	# We cannot use -DCMAKE_TOOLCHAIN_FILE=${S}/CMake/Toolchains/emscripten.toolchain.cmake
	myemscriptpath=$(find  /usr/share/emscripten-* -type d | head -n 1)
	local mycmakeargs=(
		${mydebug}
		-DCMAKE_AR="${myemscriptpath}/emar"
		-DCMAKE_C_ABI_COMPILED=TRUE
		-DCMAKE_C_COMPILER="${myemscriptpath}/emcc"
		-DCMAKE_C_COMPILER_ID_RUN=TRUE
		-DCMAKE_C_COMPILER_ID=Clang
		-DCMAKE_C_SIZEOF_DATA_PTR=4
		-DCMAKE_CXX_ABI_COMPILED=TRUE
		-DCMAKE_CXX_COMPILER="${myemscriptpath}/em++"
		-DCMAKE_CXX_COMPILER_ID_RUN=TRUE
		-DCMAKE_CXX_COMPILER_ID=Clang
		-DCMAKE_CXX_SIZEOF_DATA_PTR=4
		-DCMAKE_SYSTEM_NAME=Linux
		-DCMAKE_SYSTEM_VERSION=1
		-DCMAKE_RANLIB="${myemscriptpath}/emranlib"
		-DCMAKE_REQUIRED_FLAGS="-s ERROR_ON_UNDEFINED_SYMBOLS=1"
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
		-DCMAKE_LINKER="${myemscriptpath}/emlink.py"
		-DEMBUILDER="${myemscriptpath}/embuilder.py"
		-DEMCC_VERSION=$(emcc --version | head -n1 | grep -o "[1-9.]" \
					| tr '\n' '\0')
		-DEMPACKAGER="${myemscriptpath}/tools/file_packager.py"
		-DEMRUN="${myemscriptpath}/emrun"
		-DEMSCRIPTEN=$(usex javascript)
		-DEMSCRIPTEN_ROOT_PATH="${myemscriptpath}"
		-DURHO3D_ANGELSCRIPT=$(usex angelscript)
		-DURHO3D_BINDINGS=$(usex bindings)
		-DURHO3D_C++11=$(usex c++11)
		-DURHO3D_DATABASE_ODBC=$(usex odbc)
		-DURHO3D_DATABASE_SQLITE=$(usex sqlite)
		-DURHO3D_DOCS=$(usex docs)
		-DURHO3D_EXTRAS=$(usex extras)
		-DURHO3D_FILEWATCHER=$(usex filewatcher)
		-DURHO3D_LOGGING=$(usex logging)
		-DURHO3D_LUA=$(usex lua)
		-DURHO3D_LUAJIT=$(usex lua-jit)
		-DURHO3D_LUA_RAW_SCRIPT_LOADER=$(usex debug-raw-script-loader)
		-DURHO3D_NAVIGATION=$(usex recastnavigation)
		-DURHO3D_NETWORK=$(usex network)
		-DURHO3D_PCH=$(usex pch)
		-DURHO3D_PHYSICS=$(usex bullet)
		-DURHO3D_PROFILING=$(usex profiling)
		-DURHO3D_SAFE_LUA=$(usex debug)
		-DURHO3D_SAMPLES=$(usex samples)
		-DURHO3D_TESTING=$(usex automated-testing)
		-DURHO3D_THREADING=$(usex threads)
		-DURHO3D_TOOLS=$(usex tools)
		-DURHO3D_URHO2D=$(usex box2d)
		-DWEB=1
	)
	cmake-utils_src_configure
}

src_compile() {
	MAKEOPTS="-j1" \
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	# Deleting everything except the lib and the examples...
	rm -rf \
		"${ED}"/usr/bin/ \
		"${ED}"/usr/include/Urho3D \
		"${ED}"/usr/share/Urho3D/{CMake,Docs,Resources,Scripts} \
		"${ED}"/usr/share/doc/${P}
}

pkg_postinst() {
	einfo "Use dev-libs/urho3d to install include headers"
}
