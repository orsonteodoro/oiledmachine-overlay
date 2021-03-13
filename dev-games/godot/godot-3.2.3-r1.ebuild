# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

STATUS="stable"

VIRTUALX_REQUIRED=manual
PYTHON_COMPAT=( python3_{6..9} )
inherit check-reqs desktop eutils godot multilib-build python-r1 scons-utils \
virtualx

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="all-rights-reserved Apache-2.0 BitstreamVera Boost-1.0 BSD BSD-2 \
CC-BY-3.0 FTL ISC LGPL-2.1 MIT MPL-2.0 OFL-1.1 openssl Unlicense ZLIB"

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
PND="${PN}-demo-projects"

# tag 3 deterministic / static snapshot / master / 20210303
EGIT_COMMIT_3_DEMOS_SNAPSHOT="35687c3eadcfb77028bb04935428daa55fdbbf98"

# latest release
EGIT_COMMIT_3_DEMOS_STABLE="5bd2bbfda9422270d5e5838920cfa55b4b1293ea"

# Commit dated 20210301
EGIT_COMMIT_GODOT_CPP_SNAPSHOT="55c0a2ea03369efefa0f795bdc7f81fbd4568a47"

FN_SRC="${PV}-stable.tar.gz"
FN_DEST="${P}.tar.gz"
FN_SRC_ESN="${EGIT_COMMIT_3_DEMOS_SNAPSHOT}.zip" # examples snapshot
FN_DEST_ESN="${PND}-${EGIT_COMMIT_3_DEMOS_SNAPSHOT}.zip"
FN_SRC_EST="${EGIT_COMMIT_3_DEMOS_STABLE}.zip" # examples stable
FN_DEST_EST="${PND}-${EGIT_COMMIT_3_DEMOS_STABLE}.zip" # gdnative
FN_SRC_CPP="${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}.zip"
FN_DEST_CPP="godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}.zip"
URI_ORG="https://github.com/godotengine"
URI_PROJECT="${URI_ORG}/godot"
URI_PROJECT_DEMO="${URI_ORG}/godot-demo-projects"
URI_DL="${URI_PROJECT}/releases"
URI_A="${URI_PROJECT}/archive/${PV}-stable.tar.gz"
SRC_URI="${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST} 
examples-snapshot? (
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_ESN} \
	-> ${FN_DEST_ESN}
)
examples-stable? (
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_EST} \
		-> ${FN_DEST_EST}
)
gdnative? (
  ${URI_ORG}/godot-cpp/archive/${FN_SRC_CPP} \
		-> ${FN_DEST_CPP}
)"
SLOT_MAJ="3"
SLOT="${SLOT_MAJ}/${PV}"
IUSE+=" +3d +advanced-gui clang debug docs examples-snapshot examples-stable \
examples-live jit lto +optimize-speed +opensimplex optimize-size portable \
sanitizer server +X"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +ogg +pvrtc +svg +s3tc +theora \
+tga +vorbis +webm +webp" # formats formats

#FIXME gdnative

IUSE+=" -closure-compiler +cpp +gdnative +gdscript gdscript_lsp javascript \
+javascript_eval -javascript_threads -mono +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +mbedtls +upnp +webrtc +websocket" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
IUSE+=" system-bullet system-enet system-freetype system-libogg system-libpng \
system-libtheora system-libvorbis system-libvpx system-libwebp \
system-libwebsockets system-mbedtls system-miniupnpc system-opus system-pcre2 \
system-recast system-squish system-wslay system-xatlas \
system-zlib system-zstd"
IUSE+=" android"
IUSE+=" doxygen rst"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.2.3-stable/thirdparty for versioning
# See https://docs.godotengine.org/en/3.2/development/compiling/compiling_for_android.html
# See https://docs.godotengine.org/en/3.2/development/compiling/compiling_for_web.html
# Some are repeated because they were shown to be in the ldd list
FREETYPE_V="2.10.1"
LIBOGG_V="1.3.4"
LIBVORBIS_V="1.3.6"
ZLIB_V="1.2.11"
DEPEND+=" ${PYTHON_DEPS}
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
        >=media-libs/freetype-${FREETYPE_V}[${MULTILIB_USEDEP}]
	>=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}]
        media-sound/pulseaudio[${MULTILIB_USEDEP}]
	net-libs/libasyncns[${MULTILIB_USEDEP}]
	sys-apps/tcp-wrappers[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_V}[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXdmcp[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
        x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	!portable? ( >=app-misc/ca-certificates-20180226 )
	android? (
		dev-util/android-sdk-update-manager
		>=dev-util/android-ndk-17
		dev-java/gradle-bin
		dev-java/openjdk:8
	)
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	gdnative? ( dev-util/scons
		     || ( sys-devel/clang[${MULTILIB_USEDEP}]
	                  sys-devel/gcc ) )
	javascript? (
		!closure-compiler? ( >=dev-util/emscripten-1.39.0[wasm(+)] )
		closure-compiler? ( 
>=dev-util/emscripten-1.39.0[closure-compiler,closure_compiler_nodejs,wasm(+)] ) )
	mono? ( dev-dotnet/nuget
		 dev-util/msbuild
		 >=dev-lang/mono-5.2[${MULTILIB_USEDEP}] )
	system-bullet? ( >=sci-physics/bullet-2.89[${MULTILIB_USEDEP}] )
	system-enet? ( >=net-libs/enet-1.3.15[${MULTILIB_USEDEP}] )
	system-freetype? ( >=media-libs/freetype-${FREETYPE_V}[${MULTILIB_USEDEP}] )
	system-libogg? ( >=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}] )
	system-libpng? ( >=media-libs/libpng-1.6.37[${MULTILIB_USEDEP}] )
	system-libtheora? ( >=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP}] )
	system-libvorbis? ( >=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}] )
	system-libvpx? ( >=media-libs/libvpx-1.6.0[${MULTILIB_USEDEP}] )
	system-libwebp? ( >=media-libs/libwebp-1.1.0[${MULTILIB_USEDEP}] )
	system-mbedtls? ( >=net-libs/mbedtls-2.16.8[${MULTILIB_USEDEP}] )
	system-miniupnpc? ( >=net-libs/miniupnpc-2.1[${MULTILIB_USEDEP}] )
	system-opus? (
		>=media-libs/opus-1.1.5[${MULTILIB_USEDEP}]
		>=media-libs/opusfile-0.8[${MULTILIB_USEDEP}]
	)
	system-pcre2? ( >=dev-libs/libpcre2-10.34[${MULTILIB_USEDEP},jit?] )
	system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	system-squish? ( >=media-libs/libsquish-1.15[${MULTILIB_USEDEP}] )
	system-wslay? ( >=net-libs/wslay-1.1.1[${MULTILIB_USEDEP}] )
	system-xatlas? ( media-libs/xatlas[${MULTILIB_USEDEP}] )
	system-zlib? ( >=sys-libs/zlib-${ZLIB_V}[${MULTILIB_USEDEP}] )
	system-zstd? ( >=app-arch/zstd-1.4.4[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" dev-util/scons
        virtual/pkgconfig[${MULTILIB_USEDEP}]
	clang? ( sys-devel/clang[${MULTILIB_USEDEP}] )
	doxygen? ( app-doc/doxygen )
	gdnative? ( X? ( ${VIRTUALX_DEPEND} ) )"
S="${WORKDIR}/godot-${PV}-stable"
RESTRICT="fetch mirror"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	|| ( server X )
	docs? ( || ( doxygen rst ) )
	examples-live? ( !examples-snapshot !examples-stable )
	examples-snapshot? ( !examples-live !examples-stable )
	examples-stable? ( !examples-live !examples-snapshot )
	gdnative? ( !clang )
	gdscript_lsp? ( jsonrpc websocket )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!system-bullet
		!system-enet
		!system-freetype
		!system-libogg
		!system-libpng
		!system-libtheora
		!system-libvorbis
		!system-libvpx
		!system-libwebp
		!system-libwebsockets
		!system-mbedtls
		!system-miniupnpc
		!system-opus
		!system-pcre2
		!system-recast
		!system-squish
		!system-xatlas
		!system-zlib
		!system-zstd
	)
	rst? ( || ( $(python_gen_useflags 'python3*') ) )"

_set_check_req() {
	if use X && use server ; then
		CHECKREQS_DISK_BUILD="2762M"
		CHECKREQS_DISK_USR="445M"
	elif use server ; then
		CHECKREQS_DISK_BUILD="1431M"
		CHECKREQS_DISK_USR="229M"
	elif use X ; then
		CHECKREQS_DISK_BUILD="1460M"
		CHECKREQS_DISK_USR="241M"
	fi
}

pkg_pretend() {
	if use mono ; then
		if has network-sandbox $FEATURES \
			|| has sandbox $FEATURES \
			|| has usersandbox $FEATURES ; then
			die \
"mono support requires network-sandbox, sandbox, usersandbox to be disabled\n\
in FEATURES on a per-package level."
		fi
		if [[ -z "${XAUTHORITY}" ]] ; then
			ewarn "The build may require you emerge in a X session."
		fi
	fi

	_set_check_req
	check-reqs_pkg_pretend
}

_check_emscripten()
{
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
		die \
"EMCC_V=${emcc_v} != EMSCRIPTEN_V=${emscripten_v}.  A \
\`eselect emscripten set <#>\` followed by \`source . /etc/profile\` \
are required."
	fi
}

pkg_setup() {
	ewarn "This ebuild is still a Work In Progress (WIP) as of 2021"
	ewarn "Do not build with gdnative USE flag until fixed by ebuild maintainer."
	if use android ; then
		ewarn \
"The android USE flag is untested and incomplete in the ebuild level."
		if [[ -z "${ANDROID_NDK_ROOT}" ]] ; then
			ewarn "ANDROID_NDK_ROOT must be set"
		fi
		if [[ -z "${EGODOT_ANDROID_ARCHES[@]}" ]] ; then
			ewarn \
"EGODOT_ANDROID_ARCHES should be added as a per-package environmental variable"
		fi

		# For gradle wrapper
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES for gradle wrapper\n\
and the android USE flag."
		fi
	fi
	if use cpp ; then
		ewarn "The cpp USE flag is untested."
	fi
	if use gdnative ; then
		ewarn "The gdnative USE flag is untested."
	fi
	if use gdscript ; then
		ewarn "The gdscript USE flag is untested."
	fi
	if use javascript ; then
		ewarn \
"The javascript USE flag is untested and possibly unfinished on the ebuild level."
		_check_emscripten
	fi
	if use mono ; then
		ewarn \
"The mono USE flag is untested and unfinished on the ebuild level."
	fi

	_set_check_req
	check-reqs_pkg_setup
	python_setup
}

pkg_nofetch() {
	# fetch restriction is on third party packages with all-rights-reserved in code
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"\n\
This package contains an all-rights-reserved for several third-party packages\n\
and fetch restricted because the font doesn't come from the\n\
originator's site.  Please read:\n\
https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/all-rights-reserved\n\
\n\
If you agree, you may download\n\
  - ${FN_SRC}\n\
from ${PN}'s GitHub page which the URL should be\n\
\n\
${URI_DL}\n\
\n\
at the green download button and rename it to ${FN_DEST} and place them in\n\
${distdir} or you can \`wget -O ${distdir}/${FN_DEST} ${URI_A}\`\n\
\n"
	if use examples-snapshot ; then
		einfo \
"\n\
You also need to obtain the godot-demo-projects snapshot tarball from\n\
${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_3_DEMOS_SNAPSHOT}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_ESN} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_ESN} \
${URI_PROJECT_DEMO}/archive/${FN_SRC_ESN}\`\n\
\n"
	fi
	if use examples-stable ; then
		einfo \
"\n\
You also need to obtain the godot-demo-projects stable tarball from\n\
${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_3_DEMOS_STABLE}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_EST} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_EST} \
${URI_PROJECT_DEMO}/archive/${FN_SRC_EST}\`\n\
\n"
	fi

	if use gdnative ; then
		einfo \
"You also need to obtain the godot-cpp tarball from\n\
https://github.com/godotengine/godot-cpp/tree/${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_CPP} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_CPP} \
https://github.com/godotengine/godot-cpp/archive/${FN_SRC_CPP}\`"
	fi
}

src_unpack() {
	unpack ${A}
	if use examples-stable ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_3_DEMOS_STABLE}"
	elif use examples-snapshot ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_3_DEMOS_SNAPSHOT}"
	elif use examples-live ; then
		wget -O "${T}/demos.tar.gz" \
			${URI_PROJECT_DEMO}/archive/master.tar.gz
		unpack "${T}/demos.tar.gz"
		export S_DEMOS="${WORKDIR}/${PND}-master"
	fi
	if use gdnative ; then
		mv "${WORKDIR}/godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}" godot-cpp || die
		mv godot-cpp "${S}" || die
	fi
}

src_prepare() {
	default

	multilib_copy_sources

	multilib_prepare_impl1() {
		cd "${BUILD_DIR}" || die
		S="${BUILD_DIR}" \
		godot_copy_sources
	}

	multilib_foreach_abi multilib_prepare_impl1

	if use gdnative ; then
		multilib_prepare_impl2() {
			cd "${BUILD_DIR}" || die
			godot_prepare_impl2() {
				pushd godot-cpp || die
					rm -rf godot-headers || die
					ln -s "${BUILD_DIR}/modules/gdnative/include" \
						godot-headers || die
				popd
			}

			godot_foreach_impl godot_prepare_impl2
		}

		multilib_foreach_abi multilib_prepare_impl2
	fi
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
}

_build() {
	local type1="${1}" # only x11 and server allowed
	local type2 # only godot and godot_server allowed

	if [[ "${type1}" == "x11" ]] ; then
		type2="godot"
	elif [[ "${type1}" == "server" ]] ; then
		type2="godot_server"
	fi

	local target=$(usex debug "" ".opt")
	local sanitizer=$(usex sanitizer "s" "")
	local tools=".tools" # can only be .tools or .debug only based
				# on the tools option
	local selected_platform=".x11"
	local bitness=$(_get_bitness)
	local llvm=$(usex clang ".llvm" "")
	local mono=$(usex mono ".mono" "")
	local fs=\
"${type2}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"

	if use android \
		&& [[ "${EGODOT}" == "X" ]] ; then
		einfo "Creating export templates for Android"
		export TERM=linux # pretend to be outside of X
		for aa in ${EGODOT_ANDROID_ARCHES[@]} ; do
			scons platform=android target=release android_arch=${aa} || die
			scons platform=android target=release_debug android_arch=${aa} || die
		done
		pushd platform/android/java || die
			gradle_cmd=$(find /usr/bin/ -regextype posix-extended \
					-regex '.*/gradle-[0-9]+.[0-9]+')
			"${gradle_cmd}" wrapper || die
			./gradlew generateGodotTemplates || die
		popd
	fi

	if use javascript \
		&& [[ "${EGODOT}" == "X" ]] ; then
		einfo "Creating export templates for Web (JavaScript)"
		filter-flags -march=*
		filter-ldflags -Wl,--as-needed
		strip-flags
		einfo "LDFLAGS=${LDFLAGS}"
		export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
		export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
		local CFG=$(cat "${EM_CONFIG}")
		BINARYEN_LIB_PATH=$(echo -e "${CFG}\nprint (BINARYEN_ROOT)" | python3)"/lib"
		einfo "BINARYEN_LIB_PATH=${BINARYEN_LIB_PATH}"
		export LD_LIBRARY_PATH="${BINARYEN_LIB_PATH}:${LD_LIBRARY_PATH}"

		scons platform=javascript \
			javascript_eval=$(usex javascript_eval) \
			threads_enabled=$(usex javascript_threads) \
			${myoptions[@]} \
			tools=no \
			target=release
		scons platform=javascript \
			javascript_eval=$(usex javascript_eval) \
			threads_enabled=$(usex javascript_threads) \
			${myoptions[@]} \
			tools=no \
			target=release_debug
	fi

	if use mono ; then
		# Prevent crash
		# ERROR: generate_cs_core_project:
		#   Condition ' !file ' is true. returned: ERR_FILE_CANT_WRITE
		# halts at
#	build_GodotSharp/GodotSharp/Core/Attributes/ExportAttribute.cs
#	build_GodotSharp/GodotSharp/Core/Extensions/NodeExtensions.cs
		# Script doesn't check if those paths are created first.
		mkdir -p build_GodotSharp/GodotSharp/Core/\
{Attributes,Extensions,Interfaces} \
			|| die

		# Glue to enable the Mono module.
		einfo "Generating glue source code for the ${type1}'s mono"
		scons platform=${type1} \
			${myoptions[@]} \
			tools=yes \
			mono_glue=no \
			"CFLAGS=${CFLAGS}" \
			"CCFLAGS=${CXXFLAGS}" \
			"LINKFLAGS=${LDFLAGS}" || die
		einfo "Making modules/mono/glue/mono_glue.gen.cpp"
		bin/${fs} --audio-driver Dummy \
			--generate-mono-glue \
			modules/mono/glue || die
		if ! ( find bin -name "data.*" ) ; then
			die \
"Missing export templates directory (data.mono.*.*.*).  Likely caused by\n\
crash while generating mono_glue.gen.cpp."
		fi
		if [[ "${type1}" == "x11" ]] ; then
			einfo "Building mono export templates for ${type1}"
			scons platform=${type1} \
				${myoptions[@]} \
				tools=no \
				"CFLAGS=${CFLAGS}" \
				"CCFLAGS=${CXXFLAGS}" \
				"LINKFLAGS=${LDFLAGS}" || die
		fi
	fi

	# Building gdnative (c++) bindings for server doesn't work but should work.
	if use gdnative && [[ "${type1}" == "x11" ]] ; then
		if ! use mono ; then
			scons platform=${type1} \
				${myoptions[@]} \
				"CFLAGS=${CFLAGS}" \
				"CCFLAGS=${CXXFLAGS}" \
				"LINKFLAGS=${LDFLAGS}" || die
		fi

		# has do be done before C# API bindings to prevent crash
		einfo "Building GDNative C++ bindings for ${type1}"

		for x in $(find /dev/input -name "event*") ; do
			einfo "Adding \`addpredict ${x}\` sandbox rule"
			addpredict "${x}"
		done



		# Build for server fails here with
		# pure virtual method called
		local api_path="${BUILD_DIR}/godot-cpp/godot-headers/api.json"
		# virtx is always success
		virtx \
		bin/${fs} --audio-driver Dummy \
			--gdnative-generate-json-api \
			"${api_path}"



		if [[ ! -f "${api_path}" ]] ; then
			die "Missing expected ${api_path}"
		fi

		einfo "Generating GDNative C++ bindings for ${type1}"
		pushd godot-cpp || die
			local bitness=$(_get_bitness)
			bitness="${bitness//./}"
			scons platform=linux \
				${myoptions[@]//release_debug/release} \
				generate_bindings=yes \
				bits=${bitness} \
				"CFLAGS=${CFLAGS}" \
				"CCFLAGS=${CXXFLAGS}" \
				"LINKFLAGS=${LDFLAGS}" || die
		popd
	fi

	if false ; then
#	if use mono ; then
		# Generate the Godot C# API assemblies.
		local data_api_folder="bin/GodotSharp/Api"
		local sln_folder="build_GodotSharp"
		local release=$(usex debug "Debug" "Release")
		mkdir -p build_GodotSharp || die
		einfo \
"Generating bindings source code and sln file for the ${type1}'s mono"
		bin/${fs} --audio-driver Dummy \
			--generate-cs-api ${sln_folder} || die
		einfo "Building Godot dlls for ${type1}'s mono"
		msbuild ${sln_folder}/GodotSharp.sln \
			/p:Configuration=${release} || die
		mkdir -p ${data_api_folder}
		cp -a build_GodotSharp/GodotSharp/bin/${release}/\
{GodotSharp.dll,GodotSharp.pdb,GodotSharp.xml} \
			${data_api_folder} || die
		cp -a build_GodotSharp/GodotSharpEditor/bin/${release}/\
{GodotSharpEditor.dll,GodotSharpEditor.pdb,GodotSharpEditor.xml} \
			${data_api_folder} || die
	fi

	einfo "Building final ${type1} with or without mono"
	scons platform=${type1} \
		${myoptions[@]} \
		"CFLAGS=${CFLAGS}" \
		"CCFLAGS=${CXXFLAGS}" \
		"LINKFLAGS=${LDFLAGS}" || die

	if use docs ; then
		einfo "Building docs"
		cd "${S}/docs" || die
		if use doxygen ; then
			emake doxygen
		fi
		if use rst ; then
			emake rst
		fi
	fi
}

_use_flag_to_platform() {
	case ${1} in
		X) echo "x11" ;;
		javascript) echo "javascript" ;;
		server) echo "server" ;;
	esac
}

src_compile() {
	multilib_compile_impl() {
		cd "${BUILD_DIR}" || die
		godot_compile_impl() {
			local myoptions=()

			if [[ "$(get_libdir)" =~ 64 ]] ; then
				myoptions+=( bits=64 )
			else
				myoptions+=( bits=32 )
			fi

			if use optimize-size ; then
				myoptions+=( optimize=size )
			else
				myoptions+=( optimize=speed )
			fi

			if use portable ; then
				myoptions+=( builtin_certs=yes )
			else
				myoptions+=( builtin_certs=no
		system_certs_path="/etc/ssl/certs/ca-certificates.crt" )
			fi

			myoptions+=(
				debug_symbols=$(usex debug)
				disable_3d=$(usex !3d)
				disable_advanced_gui=$(usex !advanced-gui)
				builtin_enet=$(usex !system-enet)
				builtin_freetype=$(usex !system-freetype)
				builtin_libpng=$(usex !system-libpng)
				builtin_libtheora=$(usex !system-libtheora)
				builtin_libvorbis=$(usex !system-libvorbis)
				builtin_libvpx=$(usex !system-libvpx)
				builtin_libwebp=$(usex !system-libwebp)
				builtin_libwebsockets=$(usex !system-libwebsockets)
				builtin_mbedtls=$(usex !system-mbedtls)
				builtin_miniupnpc=$(usex !system-miniupnpc)
				builtin_pcre2=$(usex !system-pcre2)
				builtin_pcre2_with_jit=$(usex jit)
				builtin_opus=$(usex !system-opus)
				builtin_recast=$(usex !system-recast)
				builtin_squish=$(usex !system-squish)
				builtin_wslay=$(usex !system-wslay)
				builtin_xatlas=$(usex !system-xatlas)
				builtin_zlib=$(usex !system-zlib)
				builtin_zstd=$(usex !system-zstd)
				minizip=$(usex minizip)
				module_bmp_enabled=$(usex bmp)
				module_bullet_enabled=$(usex bullet)
				module_csg_enabled=$(usex csg)
				module_cvtt_enabled=$(usex cvtt)
				module_etc_enabled=$(usex etc1)
				module_enet_enabled=$(usex enet)
				module_freetype_enabled=$(usex freetype)
				module_gdnative_enabled=$(usex gdnative)
				module_gdscript_enabled=$(usex gdscript)
				module_gridmap_enabled=$(usex gridmap)
				module_hdr_enabled=$(usex hdr)
				module_jpg_enabled=$(usex jpeg)
				module_jsonrpc_enabled=$(usex jsonrpc)
				module_mbedtls_enabled=$(usex mbedtls)
				module_mono_enabled=$(usex mono)
				module_ogg_enabled=$(usex ogg)
				module_opensimplex_enabled=$(usex opensimplex)
				module_pvr_enabled=$(usex pvrtc)
				module_regex_enabled=$(usex pcre2)
				module_recast_enabled=$(usex recast)
				module_squish_enabled=$(usex s3tc)
				module_stb_vorbis_enabled=$(usex vorbis)
				module_svg_enabled=$(usex svg)
				module_theora_enabled=$(usex theora)
				module_tinyexr_enabled=$(usex exr)
				module_tga_enabled=$(usex tga)
				module_upnp_enabled=$(usex upnp)
				module_visual_script_enabled=$(usex visual-script)
				module_vhacd_enabled=$(usex vhacd)
				module_vorbis_enabled=$(usex vorbis)
				module_webm_enabled=$(usex webm)
				module_websocket_enabled=$(usex websocket)
				module_webp_enabled=$(usex webp)
				module_webrtc_enabled=$(usex webrtc)
				module_xatlas_enabled=$(usex xatlas)
				pulseaudio=$(usex pulseaudio)
				target=$(usex debug "debug" "release_debug")
				touch=$(usex touch)
				udev=$(usex gamepad)
				use_asan=$(usex sanitizer)
				use_closure_compiler=$(usex closure-compiler)
				use_lsan=$(usex sanitizer)
				use_lto=$(usex lto)
				use_static_cpp=$(usex portable)
				use_ubsan=$(usex sanitizer) )

			if use clang ; then
				myoptions+=( use_llvm=yes )
			fi

			_build $(_use_flag_to_platform "${EGODOT}")
		}

		godot_foreach_impl godot_compile_impl
	}

	multilib_foreach_abi multilib_compile_impl
}

_get_bitness() {
	[[ $(get_libdir) =~ 64 ]] && echo ".64" || echo ".32"
}

_copy_impl() {
	local type1="${1}" # can only be x11 or server
	local type2
	if [[ "${type1}" == "server" ]] ; then
		type2="godot_server"
	else
		type2="godot"
	fi
	local d_base="/usr/$(get_libdir)/${PN}${SLOT_MAJ}/${type1}"
	exeinto "${d_base}/bin"
	local fs=\
"${type2}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"
	local fd=\
"${type2}${SLOT_MAJ}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"
	mv bin/${fs} bin/${fd} || die
	doexe bin/${fd}
	dosym "${d_base}/bin/${fd}" /usr/bin/${type2}${SLOT_MAJ}-${ABI}
	if use mono ; then
		into "${d_base}/bin"
		dolib.so bin/libmonosgen-2.0.so
		insinto "${d_base}/bin"
		local release=$(usex debug ".debug" ".release_debug")
		[ -d bin/data.mono.${type1}${bitness}${release} ] \
			&& doins -r bin/data.mono.${type1}${bitness}${release}
		doins -r bin/GodotSharp
	fi
	if use gdnative && [[ "${type1}" == "x11" ]] ; then
		insinto /usr/include/gdnative-${type1}
		doins -r modules/gdnative/include/*
		insinto /usr/$(get_libdir)/pkgconfig
		local release=$(usex debug ".debug" ".release")
		cat "${FILESDIR}/godot${SLOT_MAJ}-gdnative-${type1}.pc.in" | \
			sed -e "s|@prefix@|/usr|g" \
			-e "s|@exec_prefix@|\${prefix}|g" \
			-e "s|@libdir@|/usr/$(get_libdir)|g" \
		-e "s|@includedir@|\${prefix}/include/gdnative-${type1}|g" \
			-e "s|@version@|${PV}|g" \
			-e "s|@bitness@|${bitness}|g" \
			-e "s|@release@|${release}|g" \
			> "${T}/godot${SLOT_MAJ}-gdnative-${type1}.pc" || die
		doins "${T}/godot${SLOT_MAJ}-gdnative-${type1}.pc"
		local release=$(usex debug ".debug" ".release")
		einfo "lib=godot-cpp/bin/libgodot-cpp.linux${release}${bitness}.a"
		dolib.a godot-cpp/bin/libgodot-cpp.linux${release}${bitness}.a
	fi
}

src_install() {
	multilib_install_impl() {
		cd "${BUILD_DIR}" || die
		godot_install_impl() {
			local bitness=$(_get_bitness)
			local target=$(usex debug "" ".opt")
			local sanitizer=$(usex sanitizer "s" "")
			local tools=".tools" # can be .tools or .debug only.
						# based on the tools option
			local selected_platform=".x11"
			local llvm=$(usex clang ".llvm" "")
			local mono=$(usex mono ".mono" "")

			_copy_impl $(_use_flag_to_platform "${EGODOT}")

			if use cpp ; then
				insinto /usr/$(get_libdir)/pkgconfig
				cat \
				"${FILESDIR}/godot${SLOT_MAJ}-custom-module.pc.in" \
					| sed -e "s|@prefix@|/usr|g" \
					-e "s|@exec_prefix@|\${prefix}|g" \
					-e "s|@libdir@|/usr/$(get_libdir)|g" \
					-e "s|@version@|${PV}|g" \
					> "${T}/godot${SLOT_MAJ}-custom-module.pc" \
					|| die
				doins "${T}/godot${SLOT_MAJ}-custom-module.pc"

				insinto /usr/include/${PN}${SLOT_MAJ}-cpp
				doins -r "${S}"/core "${S}"/drivers
				insinto /usr/include/${PN}${SLOT_MAJ}-cpp/platform
				if use X && [[ "${EGODOT}" == "X" ]] ; then
					doins -r "${S}"/platform/x11
				fi
				if use server \
					&& [[ "${EGODOT}" == "server" ]] ; then
					doins -r "${S}"/platform/server
				fi
			fi
			if [[ "${EGODOT}" == "X" ]] ; then
				make_desktop_entry \
					"/usr/bin/godot${SLOT_MAJ}-${ABI}" \
					"Godot${SLOT_MAJ} (${ABI})" \
					"/usr/share/pixmaps/godot${SLOT_MAJ}.png" \
					"Development;IDE"
			fi
			if use android \
				&& [[ "${EGODOT}" == "X" ]] ; then
				insinto /usr/share/godot/${SLOT_MAJ}/android/templates
				doins bin/android_{release,debug}.apk
			fi
			if use javascript \
				&& [[ "${EGODOT}" == "X" ]] ; then
				insinto /usr/share/godot/${SLOT_MAJ}/javascript/templates
				doins bin/javascript_{release,debug}.zip
			fi
		}

		godot_foreach_impl godot_install_impl
	}

	multilib_foreach_abi multilib_install_impl

	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	if use examples-live || use examples-snapshot \
		|| use examples-stable ; then
		doins -r "${S_DEMOS}"/*
	fi

	newicon icon.png godot${SLOT_MAJ}.png
}

pkg_postinst() {
	if use android ; then
		einfo \
"You need to copy the Android templates to ~/.local/share/godot/templates/${PV}.${STATUS} \
or \${XDG_DATA_HOME}/godot/templates/${PV}.${STATUS}"
		einfo "from /usr/share/godot/${SLOT_MAJ}/android/templates"
	fi

	if use javascript ; then
		einfo \
"You need to copy the JavaScript templates to ~/.local/share/godot/templates/${PV}.${STATUS} \
or \${XDG_DATA_HOME}/godot/templates/${PV}.${STATUS}"
		einfo "from /usr/share/godot/${SLOT_MAJ}/javascript/templates"
	fi
}
