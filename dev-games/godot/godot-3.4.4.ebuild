# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

STATUS="stable"

VIRTUALX_REQUIRED=manual
PYTHON_COMPAT=( python3_{8..10} )
GODOT_PLATFORMS_=(android ios linux mono osx web windows)
EPLATFORMS="server_dedicated server_headless ${GODOT_PLATFORMS_[@]/#/godot_platforms_}"
inherit check-reqs desktop eutils flag-o-matic llvm multilib-build platforms \
python-any-r1 scons-utils virtualx

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="all-rights-reserved Apache-2.0 BitstreamVera Boost-1.0 BSD BSD-2
CC-BY-3.0 FTL ISC LGPL-2.1 MIT MPL-2.0 OFL-1.1 openssl Unlicense ZLIB"

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

KEYWORDS="~amd64 ~x86"
PND="${PN}-demo-projects"

# tag 3 deterministic / static snapshot / master / 20220326
EGIT_COMMIT_DEMOS_SNAPSHOT="2e40f67b1bf8876d460d7c333d335d502ca5cc96"

# latest release
EGIT_COMMIT_DEMOS_STABLE="b0d4a7cb8ad6c592c94606fdf968b6614b162808"

# Commit dated 20220404
EGIT_COMMIT_GODOT_CPP_SNAPSHOT="f4f6fac4c784da8c973ade0dbc64a9d8400ee247"

# Commit date is GMB_V
EGIT_COMMIT_GMB_STABLE="c3a9d311bcb49ccb498a722f451ac6845b52c97e"

GMB_MONO_V="6.12.0.174"
GMB_V="9999_p20220331"

FN_SRC="${PV}-stable.tar.gz"
FN_DEST="${P}.tar.gz"
FN_SRC_ESN="${EGIT_COMMIT_DEMOS_SNAPSHOT}.zip" # examples snapshot
FN_DEST_ESN="${PND}-${EGIT_COMMIT_DEMOS_SNAPSHOT:0:7}.zip"
FN_SRC_EST="${EGIT_COMMIT_DEMOS_STABLE}.zip" # examples stable
FN_DEST_EST="${PND}-${EGIT_COMMIT_DEMOS_STABLE:0:7}.zip" # gdnative
FN_SRC_GMB="release-${EGIT_COMMIT_GMB_STABLE:0:7}.tar.gz"
FN_DEST_GMB="godot-mono-builds-${GMB_V}_${EGIT_COMMIT_GMB_STABLE:0:7}.tar.gz"
FN_SRC_CPP="${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}.zip"
FN_DEST_CPP="godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT:0:7}.zip"
FN_SRC_MONO="mono-${GMB_MONO_V}.tar.gz"
FN_DEST_MONO="mono-${GMB_MONO_V}.tar.gz"
URI_MONO_PRJ="https://github.com/mono/mono"
URI_ORG="https://github.com/godotengine"
URI_PROJECT="${URI_ORG}/godot"
URI_PROJECT_DEMO="${URI_ORG}/godot-demo-projects"
URI_DL="${URI_PROJECT}/releases"
URI_A="${URI_PROJECT}/archive/${PV}-stable.tar.gz"
if [[ "0" == "1" ]] ; then
# Used to generate hashes and download all assets.
SRC_URI="${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST}
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_ESN} \
	-> ${FN_DEST_ESN}
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_EST} \
		-> ${FN_DEST_EST}
  ${URI_ORG}/godot-cpp/archive/${FN_SRC_CPP} \
		-> ${FN_DEST_CPP}
  ${URI_ORG}/godot-mono-builds/archive/${FN_SRC_GMB} \
		-> ${FN_DEST_GMB}
  ${URI_MONO_PRJ}/archive/${FN_SRC_MONO} \
		-> ${FN_DEST_MONO}
"
else
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
)
mono? (
  ${URI_ORG}/godot-mono-builds/archive/${FN_SRC_GMB} \
		-> ${FN_DEST_GMB}
  ${URI_MONO_PRJ}/archive/${FN_SRC_MONO} \
		-> ${FN_DEST_MONO}
)"
RESTRICT="fetch mirror"
fi
SLOT_MAJ="3"
SLOT="${SLOT_MAJ}/${PV}"

# webxr, camera is enabled upstream by default
IUSE+=" +3d +advanced-gui camera clang +dds debug +denoise docs
examples-snapshot examples-stable examples-live jit +lightmapper_cpu +linux lld
lto +neon +optimize-speed +opensimplex optimize-size portable +raycast server
server_dedicated server_headless webxr"
IUSE+=" ca-certs-relax"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm webm-simd +webp" # encoding/container formats

GODOT_ANDROID_=(arm7 arm64v8 x86 x86_64)
GODOT_IOS_=(arm armv7 armv64 x86 x86_64)
GODOT_LINUX_=(x86 x86_64)
GODOT_OSX_=(arm64 x86_64)
GODOT_WEB_=(wasm32)
GODOT_WINDOWS_=(i686 x86_64)
GODOT_MONO_ANDROID_=(armabi-v7a arm64-v8a cross-arm cross-arm64 cross-x86 cross-x86_64 x86 x86_64)
GODOT_MONO_IOS_=(arm7 armv64 i386 cross-armv7 cross-arm64 x86_64)
GODOT_MONO_LINUX_=(x86 x86_64)
GODOT_MONO_OSX_=(x86_64)
GODOT_MONO_WEB_=(wasm32)
GODOT_MONO_WINDOWS_=(x86 x86_64)

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_ANDROID="${GODOT_ANDROID_[@]/#/godot_android_}"
IUSE+=" ${GODOT_ANDROID}"
GODOT_IOS="${GODOT_IOS_[@]/#/godot_ios_}"
IUSE+=" ${GODOT_IOS}"
GODOT_LINUX="${GODOT_LINUX_[@]/#/godot_linux_}"
IUSE+=" ${GODOT_LINUX}"
GODOT_OSX="${GODOT_OSX_[@]/#/godot_osx_}"
IUSE+=" ${GODOT_OSX}"
GODOT_WEB="${GODOT_WEB_[@]/#/godot_web_}"
IUSE+=" ${GODOT_WEB}"
GODOT_WINDOWS="${GODOT_WINDOWS_[@]/#/godot_windows_}"
IUSE+=" ${GODOT_WINDOWS}"
GODOT_MONO_ANDROID="${GODOT_MONO_ANDROID_[@]/#/godot_mono_android_}"
IUSE+=" ${GODOT_MONO_ANDROID}"
GODOT_MONO_IOS="${GODOT_MONO_IOS_[@]/#/godot_mono_ios_}"
IUSE+=" ${GODOT_MONO_IOS}"
GODOT_MONO_LINUX="${GODOT_MONO_LINUX_[@]/#/godot_mono_linux_}"
IUSE+=" ${GODOT_MONO_LINUX}"
GODOT_MONO_OSX="${GODOT_MONO_OSX_[@]/#/godot_mono_osx_}"
IUSE+=" ${GODOT_MONO_OSX}"
GODOT_MONO_WEB="${GODOT_MONO_WEB_[@]/#/godot_mono_web_}"
IUSE+=" ${GODOT_MONO_WEB}"
GODOT_MONO_WINDOWS="${GODOT_MONO_WINDOWS_[@]/#/godot_mono_windows_}"
IUSE+=" ${GODOT_MONO_WINDOWS}"
#GODOT_MONO_PLATFORMS="${GODOT_PLATFORMS_[@]/#/godot_mono_}"
#IUSE+=" ${GODOT_MONO_PLATFORMS}"
GODOT_PLATFORMS="${GODOT_PLATFORMS_[@]/#/godot_platforms_}"
IUSE+=" +godot_platforms_linux"
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_ANDROID}" godot_platforms_android)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_IOS}" godot_platforms_ios)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_LINUX}" godot_platforms_linux)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_OSX}" godot_platforms_osx)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_WEB}" godot_platforms_web)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_WINDOWS}" godot_platforms_windows)

REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_ANDROID}" godot_platforms_mono)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_IOS}" godot_platforms_mono)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_LINUX}" godot_platforms_mono)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_OSX}" godot_platforms_mono)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_WEB}" godot_platforms_mono)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_MONO_WINDOWS}" godot_platforms_mono)

# gdnative is default on upstream.  temporarily disabled.
IUSE+=" -closure-compiler gdnative -gdscript gdscript_lsp
+javascript_eval -javascript_threads -mono
-mono_pregen_assemblies +visual-script web" # for scripting languages
IUSE+=" +bullet +csg +gridmap +gltf +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +mbedtls +upnp +webrtc +websocket" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
IUSE+=" system-bullet system-embree system-enet system-freetype system-libogg
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp
system-libwebsockets system-mbedtls system-miniupnpc system-opus system-pcre2
system-recast system-squish system-wslay system-xatlas
system-zlib system-zstd"
IUSE+=" android"
IUSE+=" doxygen rst"
# in master, sanitizers also applies to javascript
IUSE+=" asan_server lsan_server msan_server tsan_server ubsan_server"
IUSE+=" asan_client lsan_client msan_client tsan_client ubsan_client"
IUSE+=" -ios-sim +icloud +game-center +store-kit" # ios
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://docs.godotengine.org/en/3.4/development/compiling/compiling_for_android.html
# See https://docs.godotengine.org/en/3.4/development/compiling/compiling_for_web.html
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# See https://developer.apple.com/ios/submit/ for app store requirement
# Some are repeated because they were shown to be in the ldd list
#	gdnative? ( !clang )
# The mutual exclusion for lto and godot_web_wasm32 may be removed once the bug for building llvm-13 with lto for godot is fixed.
REQUIRED_USE+="
	lto? ( !godot_web_wasm32 )
	godot_web_wasm32? ( !lto )
	abi_x86_32? ( godot_linux_x86 godot_platforms_linux )
	abi_x86_64? ( godot_linux_x86_64 godot_platforms_linux )
	camera? ( godot_platforms_osx )
	denoise? ( lightmapper_cpu )
	docs? ( || ( doxygen rst ) )
	examples-live? ( !examples-snapshot !examples-stable )
	examples-snapshot? ( !examples-live !examples-stable )
	examples-stable? ( !examples-live !examples-snapshot )
	gdscript_lsp? ( jsonrpc websocket )
	godot_linux_x86? ( abi_x86_32 godot_platforms_linux )
	godot_linux_x86_64? ( abi_x86_64 godot_platforms_linux )
	godot_platforms_android? ( || ( ${GODOT_ANDROID} ) )
	godot_platforms_ios? ( || ( ${GODOT_IOS} ) )
	godot_platforms_linux
	godot_platforms_linux? ( || ( ${GODOT_LINUX} ) )
	godot_platforms_mono? ( || (
		${GODOT_MONO_ANDROID}
		${GODOT_MONO_LINUX}
		${GODOT_MONO_IOS}
		${GODOT_MONO_OSX}
		${GODOT_MONO_WEB}
		${GODOT_MONO_WINDOWS}
	) )
	godot_platforms_osx? ( || ( ${GODOT_OSX} ) )
	godot_platforms_web? ( || ( ${GODOT_WEB} ) )
	godot_platforms_windows? ( || ( ${GODOT_WINDOWS} ) )
	lld? ( clang )
	lsan_client? ( asan_client )
	lsan_server? ( asan_server )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!asan_client
		!asan_server
		!system-bullet
		!system-embree
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
		!tsan_client
		!tsan_server
	)
	server? ( || ( server_dedicated
		server_headless ) )
	server_dedicated? ( server )
	server_headless? ( server )
	webxr? ( godot_platforms_web )"
# See https://developer.apple.com/ios/submit/ for app store requirement
APST_REQ_STORE_DATE="April 2021"
IOS_SDK_MIN_STORE="14"
XCODE_SDK_MIN_STORE="12"
EMSCRIPTEN_V="2.0.10"
EXPECTED_XCODE_SDK_MIN_VERSION_IOS="10"
EXPECTED_IOS_SDK_MIN_VERSION="10"
EXPECTED_XCODE_SDK_MIN_VERSION_ARM64="10.15" # See https://github.com/godotengine/godot/blob/3.4-stable/platform/osx/detect.py#L80
EXPECTED_XCODE_SDK_MIN_VERSION_X86_64="10.12"
EXPECTED_MIN_ANDROID_API_LEVEL="29"
FREETYPE_V="2.10.4"
JAVA_V="11" # See https://github.com/godotengine/godot/blob/3.4-stable/.github/workflows/android_builds.yml#L32
LIBOGG_V="1.3.5"
LIBVORBIS_V="1.3.7"
NDK_V="21"
ZLIB_V="1.2.11"

gen_cdepend_mono() {
	local arches="${1}"
	local cdepends="${2}"

	local o=""
	for a in ${arches} ; do
		o+=" ${a}? ( ${cdepends} )"
	done
	echo "${o}"
}

LLVM_SLOTS=(12 13) # See https://github.com/godotengine/godot/blob/3.4-stable/misc/hooks/pre-commit-clang-format#L79
gen_cdepend_lto_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
				(
					sys-devel/clang:${s}[${MULTILIB_USEDEP}]
					sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
					>=sys-devel/lld-${s}
				)
		"
	done
	echo -e "${o}"
}

JDK_DEPEND="
|| (
	dev-java/openjdk-bin:${JAVA_V}
	dev-java/openjdk:${JAVA_V}
)"
JRE_DEPEND="
|| (
	${JDK_DEPEND}
	dev-java/openjdk-jre-bin:${JAVA_V}
)"
#JDK_DEPEND=" virtual/jdk:${JAVA_V}"
#JRE_DEPEND=" virtual/jre:${JAVA_V}"

CDEPEND_GMB="	>=dev-lang/mono-${GMB_MONO_V}
		>=dev-lang/python-3.7"

CDEPEND_MONO_ANDROID="
	${CDEPEND_GMB}
	>=dev-lang/mono-${GMB_MONO_V}
	dev-util/android-ndk:=
	dev-util/android-sdk-update-manager
"

CDEPEND_MONO_APL="
	${CDEPEND_GMB}
	sys-devel/osxcross
"

CDEPEND_MONO_WEB="
	${CDEPEND_GMB}
	>=dev-util/emscripten-1.39.9[wasm(+)]
	|| ( dev-dotnet/dotnetcore-runtime-bin
		dev-util/msbuild )
"

CDEPEND_MONO_WINDOWS="
	${CDEPEND_GMB}
	sys-devel/crossdev
"

CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_ANDROID}" "${CDEPEND_MONO_ANDROID}")
CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_IOS}" "${CDEPEND_MONO_APL}")
CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_LINUX}" "${CDEPEND_GMB}")
CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_OSX}" "${CDEPEND_MONO_APL}")
CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_WEB}" "${CDEPEND_MONO_WEB}")
CDEPEND+=" "$(gen_cdepend_mono "${GODOT_MONO_WINDOWS}" "${CDEPEND_MONO_WINDOWS}")

CDEPEND_GCC_SANITIZER="
	!clang? ( sys-devel/gcc[sanitize] )
"
gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				 sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-${s}[${MULTILIB_USEDEP},compiler-rt,sanitize]
				 sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				=sys-libs/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},${san_type}]
			)
		"
	done
	echo "${o}"
}
CDEPEND_SANITIZER="
	asan_client? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer asan) ) )
		)
	)
	asan_server? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer asan) ) )
		)
	)
	lsan_client? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer lsan) ) )
		)
	)
	lsan_server? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer lsan) ) )
		)
	)
	msan_client? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer msan) ) )
		)
	)
	msan_server? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer msan) ) )
		)
	)
	tsan_client? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer tsan) ) )
		)
	)
	tsan_server? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer tsan) ) )
		)
	)
	ubsan_client? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer ubsan) ) )
		)
	)
	ubsan_server? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer ubsan) ) )
		)
	)
"
CDEPEND+="
	${CDEPEND_SANITIZER}
	godot_android_arm64v8? ( >=dev-util/android-ndk-${NDK_V} )
	godot_android_x86? ( >=dev-util/android-ndk-${NDK_V} )
	godot_android_x86_64? ( >=dev-util/android-ndk-${NDK_V} )
	godot_mono_android_arm64-v8a? ( >=dev-util/android-ndk-${NDK_V} )
	godot_mono_android_x86? ( >=dev-util/android-ndk-${NDK_V} )
	godot_mono_android_x86_64? ( >=dev-util/android-ndk-${NDK_V} )

	godot_platforms_android? (
		${JDK_DEPEND}
		dev-util/android-sdk-update-manager
		>=dev-util/android-ndk-17:=
		dev-java/gradle-bin
	)
	godot_platforms_ios? ( sys-devel/osxcross )
	godot_platforms_mono? ( dev-dotnet/nuget
		 dev-util/msbuild
		 >=dev-lang/mono-5.2[${MULTILIB_USEDEP}] )
	godot_platforms_web? (
		!closure-compiler? ( >=dev-util/emscripten-${EMSCRIPTEN_V}[wasm(+)] )
		closure-compiler? (
>=dev-util/emscripten-${EMSCRIPTEN_V}[closure-compiler,closure_compiler_nodejs,wasm(+)] ) )
	godot_platforms_osx? ( sys-devel/osxcross )
	godot_platforms_windows? ( sys-devel/crossdev )"
CDEPEND_CLANG="
	clang? (
		!lto? ( sys-devel/clang[${MULTILIB_USEDEP}] )
		lto? ( || ( $(gen_cdepend_lto_llvm) ) )
	)"
CDEPEND_GCC="
	!clang? ( sys-devel/gcc[${MULTILIB_USEDEP}] )"
DEPEND+=" ${PYTHON_DEPS}
	${CDEPEND}
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
	!portable? (
		ca-certs-relax? (
			app-misc/ca-certificates
		)
		!ca-certs-relax? (
			>=app-misc/ca-certificates-20211101
		)
	)
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	gdnative? ( dev-util/scons
		     || ( ${CDEPEND_CLANG}
	                  ${CDEPEND_GCC} ) )
	system-bullet? ( >=sci-physics/bullet-3.17[${MULTILIB_USEDEP}] )
	system-enet? ( >=net-libs/enet-1.3.17[${MULTILIB_USEDEP}] )
	system-embree? ( >=media-libs/embree-3.13.0[${MULTILIB_USEDEP}] )
	system-freetype? ( >=media-libs/freetype-${FREETYPE_V}[${MULTILIB_USEDEP}] )
	system-libogg? ( >=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}] )
	system-libpng? ( >=media-libs/libpng-1.6.37[${MULTILIB_USEDEP}] )
	system-libtheora? ( >=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP}] )
	system-libvorbis? ( >=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}] )
	system-libvpx? ( >=media-libs/libvpx-1.6.0[${MULTILIB_USEDEP}] )
	system-libwebp? ( >=media-libs/libwebp-1.1.0[${MULTILIB_USEDEP}] )
	system-mbedtls? ( >=net-libs/mbedtls-2.16.12[${MULTILIB_USEDEP}] )
	system-miniupnpc? ( >=net-libs/miniupnpc-2.2.2[${MULTILIB_USEDEP}] )
	system-opus? (
		>=media-libs/opus-1.1.5[${MULTILIB_USEDEP}]
		>=media-libs/opusfile-0.8[${MULTILIB_USEDEP}]
	)
	system-pcre2? ( >=dev-libs/libpcre2-10.36[${MULTILIB_USEDEP},jit?] )
	system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	system-squish? ( >=media-libs/libsquish-1.15[${MULTILIB_USEDEP}] )
	system-wslay? ( >=net-libs/wslay-1.1.1[${MULTILIB_USEDEP}] )
	system-xatlas? ( media-libs/xatlas[${MULTILIB_USEDEP}] )
	system-zlib? ( >=sys-libs/zlib-${ZLIB_V}[${MULTILIB_USEDEP}] )
	system-zstd? ( >=app-arch/zstd-1.4.8[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
	dev-util/scons
	doxygen? ( app-doc/doxygen )
	gdnative? ( linux? ( ${VIRTUALX_DEPEND} ) )
	godot_platforms_android? ( ${JDK_DEPEND} )
	lld? ( sys-devel/lld )
	webm-simd? (
		dev-lang/yasm
	)"
S="${WORKDIR}/godot-${PV}-stable"
S_GMB="${WORKDIR}/godot-mono-builds-release-${EGIT_COMMIT_GMB_STABLE:0:7}"
S_MONO="${WORKDIR}/mono-mono-${GMB_MONO_V}"
#GEN_DL_MANIFEST=1
# 20b171c - used for ccache
PATCHES=(
	"${FILESDIR}/godot-3.2.3-add-lld-thinlto-to-platform-server.patch"
)

# zero means true
has_mono_android() {
	for p in ${GODOT_MONO_ANDROID} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}

# zero means true
has_mono_ios() {
	for p in ${GODOT_MONO_IOS} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}

# zero means true
has_mono_linux() {
	for p in ${GODOT_MONO_LINUX} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}

# zero means true
has_mono_osx() {
	for p in ${GODOT_MONO_OSX} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}

# zero means true
has_mono_web() {
	for p in ${GODOT_MONO_WEB} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}

# zero means true
has_mono_windows() {
	for p in ${GODOT_MONO_WINDOWS} ; do
		if has ${p} ; then
			return 0
		fi
	done

	return 1
}



_set_check_req() {
	if use linux && use server ; then
		CHECKREQS_DISK_BUILD="2762M"
		CHECKREQS_DISK_USR="445M"
	elif use server ; then
		CHECKREQS_DISK_BUILD="1431M"
		CHECKREQS_DISK_USR="229M"
	elif use linux ; then
		CHECKREQS_DISK_BUILD="1460M"
		CHECKREQS_DISK_USR="241M"
	fi
}

pkg_pretend() {
	if use mono ; then
		if has network-sandbox $FEATURES \
			|| has sandbox $FEATURES \
			|| has usersandbox $FEATURES ; then
eerror
eerror "mono support requires network-sandbox, sandbox, usersandbox to be"
eerror "disabled in FEATURES on a per-package level."
eerror
			die
		fi
		if [[ -z "${XAUTHORITY}" ]] ; then
ewarn
ewarn "The build may require you emerge in a X session."
ewarn
		fi
	fi

	_set_check_req
	check-reqs_pkg_pretend
}

check_android_native()
{
	if [[ -z "${ANDROID_NDK_ROOT}" ]] ; then
ewarn
ewarn "ANDROID_NDK_ROOT must be set as a per-package environmental variable."
ewarn
	fi
	if [[ -z "${ANDROID_HOME}" ]] ; then
ewarn
ewarn "ANDROID_HOME must be set as a per-package environmental variable"
ewarn "pointing to the root of the SDK."
ewarn
	fi
	if [[ -z "${EGODOT_ANDROID_API_LEVEL}" ]] ; then
eerror
eerror "EGODOT_ANDROID_API_LEVEL must be set as a per-package environmental"
eerror "variable.  See metadata.xml or \`epkginfo -x godot\` for more info."
eerror
		die
	fi
}

check_android_sandbox()
{
	# For gradle wrapper
	if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES for gradle"
eerror "wrapper and the android USE flag."
eerror
		die
	fi
}

check_emscripten()
{
	if [[ -n "${EMCC_WASM_BACKEND}" && "${EMCC_WASM_BACKEND}" == "1" ]] ; then
		:;
	else
eerror
eerror "You must switch your emscripten to wasm by \`source /etc/profile\`."
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
eerror "You must switch your emscripten to wasm by \`source /etc/profile\`."
eerror "See \`eselect emscripten\` for details."
eerror
			die
		fi
	fi
	if [[ -z "${EMSCRIPTEN}" ]] ; then
eerror
eerror "EMSCRIPTEN environmental variable must be set"
eerror
		die
	fi

	local emcc_v=$(emcc --version | head -n 1 | grep -E -o -e "[0-9.]+")
	local emscripten_v=$(echo "${EMSCRIPTEN}" | cut -f 2 -d "-")
	if [[ "${emcc_v}" != "${emscripten_v}" ]] ; then
eerror
eerror "EMCC_V=${emcc_v} != EMSCRIPTEN_V=${emscripten_v}.  A"
eerror "\`eselect emscripten set <#>\` followed by \`source /etc/profile\`"
eerror "are required."
eerror
		die
	fi
}

check_mingw()
{
	if [[ -z "${EGODOT_MINGW32_SYSROOT}" \
		&& -z "${EGODOT_MINGW64_SYSROOT}" ]] ; then
ewarn
ewarn "EGODOT_MINGW32_SYSROOT or EGODOT_MINGW64_SYSROOT must be specified."
ewarn "See metadata.xml or \`epkginfo -x godot\` for details"
ewarn
	fi

	if [[ -n "${EGODOT_MINGW32_SYSROOT}" ]] ; then
		if [[ -f "${EGODOT_MINGW32_SYSROOT}/i686-w64-mingw32-gcc" ]] ; then
eerror
eerror "${EGODOT_MINGW32_SYSROOT}/i686-w64-mingw32-gcc was not found."
eerror
			die
		fi
	fi

	if [[ -n "${EGODOT_MINGW64_SYSROOT}" ]] ; then
		if [[ -f "${EGODOT_MINGW64_SYSROOT}/x86_64-w64-mingw32-gcc" ]] ; then
eerror
eerror "${EGODOT_MINGW64_SYSROOT}/i686-w64-mingw32-gcc was not found."
eerror
			die
		fi
	fi
}

check_mono_android()
{
	if [[ -z "${ANDROID_NDK_ROOT}" ]] ; then
ewarn
ewarn "ANDROID_NDK_ROOT must be set as a per-package environmental variable"
ewarn "pointing to the root of the NDK."
ewarn
	fi
	if [[ -z "${ANDROID_SDK_ROOT}" ]] ; then
ewarn
ewarn "ANDROID_SDK_ROOT must be set as a per-package environmental variable"
ewarn "pointing to the root of the SDK."
ewarn
	fi
}

check_mono_ios()
{
	if [[ "${USE}" =~ "godot_mono_ios_cross" ]] ; then
		if [[ -z "${LIBCLANG_PATH}" ]] ; then
eerror
eerror "LIBCLANG_PATH must be set as a per-package environmental variable."
eerror
			die
		fi
		if [[ -z "${IPHONEPATH}" ]] ; then
eerror
eerror "IPHONEPATH must be set as a per-package environmental variable."
eerror
			die
		fi
		if [[ -z "${IPHONESDK}" ]] ; then
eerror
eerror "IPHONESDK must be set as a per-package environmental variable."
eerror
			die
		fi
		if [[ -z "${MACOS_SDK_PATH}" ]] ; then
eerror
eerror "MACOS_SDK_PATH must be set as a per-package environmental variable."
eerror
			die
		fi
	fi
	if has_mono_ios ; then
		# x86 for simulator, arm for device
		if [[ -z "${IPHONESDK}" ]] ; then
eerror
eerror "IPHONESDK must be set as a per-package environmental variable."
eerror
			die
		fi
	fi

	if [[ -z "${EIOS_SDK_VERSION}" ]] ; then
eerror
eerror "EIOS_SDK_VERSION must be defined as a per-package environmental"
eerror "variable.  See metadata.xml or \`epkginfo -x godot\`for details."
eerror
		die
	fi

	if [[ -z "${EXCODE_SDK_VERSION}" ]] ; then
eerror
eerror "EXCODE_SDK_VERSION must be defined as a per-package environmental"
eerror "variable.  See metadata.xml or \`epkginfo -x godot\`for details."
eerror
		die
	fi

	if ver_test ${EIOS_SDK_VERSION} \
		-lt ${EXPECTED_IOS_SDK_MIN_VERSION} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_IOS_SDK_MIN_VERSION}"
eerror
		die
	fi
	if ver_test ${EXCODE_SDK_VERSION} \
		-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_IOS} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_IOS} for iOS"
eerror
		die
	fi

}

check_osxcross()
{
	if [[ -z "${OSXCROSS_ROOT}" ]] ; then
eerror
eerror "OSXCROSS_ROOT must be set as a per-package environmental variable.  See"
eerror "metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi
	if which xcrun ; then
eerror
eerror "Missing xcrun from the osxcross package."
eerror
		die
	fi
	if [[ -z "${EOSXCROSS_SDK}" ]] ; then
eerror
eerror "EOSXCROSS_SDK must be set as a per-package environmental variable.  See"
eerror "metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi
	if [[ ! -f \
"${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc" \
	   ]] ; then
eerror
eerror "Cannot find x86_64-apple-${EOSXCROSS_SDK}-cc.  Fix either OSXCROSS_ROOT"
eerror "(${OSXCROSS_ROOT}) or EOSXCROSS_SDK (${EOSXCROSS_SDK}).  Did not find"
eerror "${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc"
eerror
		die
	fi
	if use godot_osx_x86_64 ; then
		if ver_test ${EXCODE_SDK_VERSION} \
			-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} for"
eerror "x86_64."
eerror
			die
		fi
	fi
	if use godot_osx_arm64 ; then
		if ver_test ${EXCODE_SDK_VERSION} \
			-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_ARM64} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_ARM64} for"
eerror "arm64."
eerror
			die
		fi
	fi
}

check_store_apl()
{
	if use godot_platforms_ios ; then
		if ver_test ${EIOS_SDK_VERSION} -lt ${IOS_SDK_MIN_STORE} ; then
ewarn
ewarn "Your IOS SDK does not meet minimum store requirements of"
ewarn ">=${IOS_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
		fi
	fi

	if use godot_platforms_ios || use godot_platforms_osx ; then
		if ver_test ${EXCODE_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
ewarn
ewarn "Your Xcode SDK does not meet minimum store requirements of"
ewarn ">=${XCODE_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
		fi
	fi
}

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
eerror
eerror "dev-java/openjdk:${JAVA_V} or dev-java/openjdk-bin:${JAVA_V} must be installed."
eerror
		die
	fi
}

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2021"
ewarn
ewarn "Building with gdnative may not work and currently gets stuck when"
ewarn "generating the API.  Disable the gdnative USE flag until this notice is"
ewarn "removed."
ewarn
	if use gdnative ; then
ewarn
ewarn "The gdnative USE flag is untested."
ewarn
	fi
	if use gdscript ; then
ewarn
ewarn "The gdscript USE flag is untested."
ewarn
	fi
	if use godot_platforms_android ; then
ewarn
ewarn "The godot_platforms_android USE flag is untested.  Help test and fix."
ewarn
		check_android_native
		check_android_sandbox

		setup_openjdk

		einfo "JAVA_HOME=${JAVA_HOME}"
		einfo "PATH=${PATH}"
	fi
	if use godot_platforms_ios ; then
ewarn
ewarn "The godot_platforms_ios USE flag is untested.  Help test and fix."
ewarn
		check_osxcross
	fi
	if use godot_platforms_mono ; then
ewarn
ewarn "The godot_platforms_mono USE flag is untested and is a Work In Progress (WIP)."
ewarn
	fi
	if use godot_platforms_osx ; then
ewarn
ewarn "The godot_platforms_osx USE flag is untested.  Help test and fix."
ewarn
		check_osxcross
	fi
	if use godot_platforms_web ; then
ewarn
ewarn "The godot_platforms_web USE flag is a Work In Progress (WIP)."
ewarn
		check_emscripten
	fi
	if use godot_platforms_windows ; then
ewarn
ewarn "The godot_platforms_windows USE flag is untested.  Help test and fix."
ewarn
		check_mingw
	fi
	if [[ "${USE}" =~ godot_mono_android ]] ; then
ewarn
ewarn "The godot_mono_android_* USE flags are untested.  Help test and fix."
ewarn "godot_mono_android requires Android API level >= ${EXPECTED_MIN_ANDROID_API_LEVEL}."
ewarn
		check_mono_android
	fi
	if has_mono_ios ; then
ewarn
ewarn "The godot_mono_ios_* USE flags are untested and incomplete.  Help test and fix."
ewarn
		check_mono_ios
		check_osxcross
	fi
	if has_mono_linux ; then
ewarn
ewarn "The godot_mono_linux_* USE flags are untested."
ewarn
	fi
	if has_mono_osx ; then
ewarn
ewarn "The godot_mono_osx_* USE flags are untested and incomplete.  Help test and fix."
ewarn
		check_osxcross
	fi
	if has_mono_web ; then
ewarn
ewarn "The godot_mono_web_* USE flags are a Work In Progress (WIP)."
ewarn
		check_emscripten
	fi
	if has_mono_windows ; then
ewarn
ewarn "The godot_mono_windows_* USE flags are untested.  Help test and fix."
ewarn
		check_mingw
	fi
	check_store_apl

	_set_check_req
	check-reqs_pkg_setup
	python-any-r1_pkg_setup
	if use lto && use clang ; then
		if has_version "sys-devel/clang:13" \
			&& has_version "sys-devel/llvm:13" ; then
			LLVM_MAX_SLOT=13
		elif has_version "sys-devel/clang:12" \
			&& has_version "sys-devel/llvm:12" ; then
			LLVM_MAX_SLOT=12
		elif has_version "sys-devel/clang:11" \
			&& has_version "sys-devel/llvm:11" ; then
			LLVM_MAX_SLOT=11
		else
eerror
eerror "Both sys-devel/clang:\${SLOT} and sys-devel/llvm:\${SLOT} must have the"
eerror "same slot.  LTO enabled for LLVM 11-13 for this series only."
eerror
			die
		fi
einfo
einfo "LLVM_MAX_SLOT=${LLVM_MAX_SLOT} for LTO"
einfo
		llvm_pkg_setup
	fi
	if use clang && use godot_web_wasm32 ; then
		LLVM_MAX_SLOT=13
einfo
einfo "LLVM_MAX_SLOT=${LLVM_MAX_SLOT} for WASM"
einfo
		llvm_pkg_setup
	fi
}

pkg_nofetch() {
	# fetch restriction is on third party packages with all-rights-reserved in code
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
einfo
einfo "This package contains an all-rights-reserved for several third-party"
einfo "packages and fetch restricted because the font doesn't come from the"
einfo "originator's site.  Please read:"
einfo "https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/all-rights-reserved"
einfo
einfo "If you agree, you may download"
einfo "  - ${FN_SRC}"
einfo "from ${PN}'s GitHub page which the URL should be"
einfo
einfo "${URI_DL}"
einfo
einfo "at the green download button and rename it to ${FN_DEST} and place them"
einfo "in ${distdir} or you can \`wget -O ${distdir}/${FN_DEST} ${URI_A}\`"
einfo
	if use examples-snapshot || [[ -n "${GEN_DL_MANIFEST}" ]] ; then
einfo
einfo "You also need to obtain the godot-demo-projects snapshot tarball from"
einfo "${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_DEMOS_SNAPSHOT}"
einfo "through the green button > download ZIP and place it in ${distdir} as"
einfo "${FN_DEST_ESN} or you can copy and paste the"
einfo "below command \`wget -O ${distdir}/${FN_DEST_ESN} \
${URI_PROJECT_DEMO}/archive/${FN_SRC_ESN}\`"
einfo
	fi
	if use examples-stable || [[ -n "${GEN_DL_MANIFEST}" ]] ; then
einfo
einfo "You also need to obtain the godot-demo-projects stable tarball from"
einfo "${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_DEMOS_STABLE}"
einfo "through the green button > download ZIP and place it in ${distdir} as"
einfo "${FN_DEST_EST} or you can copy and paste the"
einfo "below command \`wget -O ${distdir}/${FN_DEST_EST} \
${URI_PROJECT_DEMO}/archive/${FN_SRC_EST}\`"
einfo
	fi

	if use gdnative || [[ -n "${GEN_DL_MANIFEST}" ]] ; then
einfo
einfo "You also need to obtain the godot-cpp tarball from"
einfo "${URI_ORG}/godot-cpp/tree/${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}"
einfo "through the green button > download ZIP and place it in ${distdir} as"
einfo "${FN_DEST_CPP} or you can copy and paste the"
einfo "below command \`wget -O ${distdir}/${FN_DEST_CPP} \
${URI_ORG}/godot-cpp/archive/${FN_SRC_CPP}\`"
einfo
	fi

	if [[ "${USE}" =~ godot_mono_ ]] || [[ -n "${GEN_DL_MANIFEST}" ]] ; then
einfo
einfo "You also need to obtain the godot-mono-builds tarball from"
einfo "${URI_ORG}/godot-mono-builds/releases and place it in ${distdir} as"
einfo "${FN_DEST_GMB} or you can copy and paste the"
einfo "below command \`wget -O ${distdir}/${FN_DEST_GMB} \
${URI_ORG}/godot-mono-builds/archive/${FN_SRC_GMB}\`"
einfo
einfo "You also need to obtain the mono tarball from"
einfo "${URI_MONO_PRJ}/releases and place it in ${distdir} as"
einfo "${FN_DEST_MONO} or you can copy and paste the"
einfo "below command \`wget -O ${distdir}/${FN_DEST_MONO} \
${URI_MONO_PRJ}/archive/${FN_SRC_MONO}\`"
einfo
	fi
}

src_unpack() {
	unpack ${A}
	if use examples-stable ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_DEMOS_STABLE}"
	elif use examples-snapshot ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_DEMOS_SNAPSHOT}"
	elif use examples-live ; then
		wget -O "${T}/demos.tar.gz" \
			${URI_PROJECT_DEMO}/archive/master.tar.gz
		unpack "${T}/demos.tar.gz"
		export S_DEMOS="${WORKDIR}/${PND}-master"
	fi
	if use gdnative ; then
		mv "${WORKDIR}/godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}" \
			godot-cpp || die
		mv godot-cpp "${S}" || die
	fi
}

src_prepare() {
	default

	platforms_copy_sources

	godot_prepare_impl1() {
		if [[ "${EPLATFORM}" == "godot_platforms_linux" \
			|| "${EPLATFORM}" == "server_dedicated" \
			|| "${EPLATFORM}" == "server_headless" ]] ; then
			cd "${BUILD_DIR}" || die
			S="${BUILD_DIR}" \
			multilib_copy_sources
		fi
	}
	platforms_foreach_impl godot_prepare_impl1

	if use gdnative ; then
		godot_prepare_impl2() {
			if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
				cd "${BUILD_DIR}" || die
				multilib_prepare_gdnative() {
					cd "${BUILD_DIR}" || die
					pushd godot-cpp || die
						rm -rf godot-headers || die
einfo
einfo "Linking ${BUILD_DIR}/modules/gdnative/include -> godot-headers."
einfo
						ln -s "${BUILD_DIR}/modules/gdnative/include" \
							godot-headers || die
					popd
				}
				multilib_foreach_abi multilib_prepare_gdnative
			fi
		}
		platforms_foreach_impl godot_prepare_impl2
	fi
}

_configure_emscripten()
{
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
	export EM_CACHE="${T}/emscripten/cache"
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
}

# gen_fs() and gen_ds() common options.
#	f[name] # can only be "godot" or "godot_server"
#	f[platform] # can only be ".android", ".iphone", ".osx", ".windows", ".x11"
#	f[configuation] # can only be release = ".opt", debug = "" (default), release_debug = ".opt"
#	f[tools] # can be ".tools" (default) or ".debug" only.
#	f[bitness] # can only be ".64" or ".32" or "" (default)
#	f[llvm] # can only be ".llvm" or "" (default)
#	f[mono] # can only be ".mono" or ""
#	f[sanitizer] # can only be ".s" or "" (default)
# Generate filename source
gen_fs()
{
	local -n f=$1
	local fs=\
"${f[name]}${f[platform]}${f[configuation]}${f[tools]}${f[bitness]}${f[llvm]}${f[mono]}${f[sanitizer]}"
	echo "${fs}"
}

# Generate filename destination for multislotting [aka multiple installation].
gen_ds()
{
	local -n f=$1
	local fd=\
"${f[name]}${SLOT_MAJ}${f[platform]}${f[configuation]}${f[tools]}${f[bitness]}${f[llvm]}${f[mono]}${f[sanitizer]}"
	echo "${fd}"
}

src_compile_android()
{
	export CCACHE=${CCACHE_ANDROID}
	local options_modules_
	if [[ -n "${EGODOT_ANDROID_CONFIG}" ]] ; then
		einfo "Using config override for Android"
		einfo "${EGODOT_ANDROID_CONFIG}"
		options_modules_=(${EGODOT_ANDROID_CONFIG})
	else
		options_modules_=(${options_modules[@]})
	fi
	for a in ${GODOT_ANDROID} ; do
		if use ${a} ; then
			case "${a}" in
				godot_android_armv7 | \
				godot_android_x86)
					bitness=32
					;;
				godot_android_arm64v8 | \
				godot_android_x86_64)
					bitness=64
					;;
				*)
					bitness=default
					;;
			esac

			einfo "Creating export templates for Android (${a})"
			for c in release release_debug ; do
				scons ${options_android[@]} \
					${options_modules_[@]} \
					$([[ -z "${EGODOT_ANDROID_CONFIG}" ]] \
						&& echo ${options_modules_static[@]}) \
					android_arch=${a} \
					bits=${bitness} \
					target=${c} \
					tools=no \
					|| die
			done

			case "${a}" in
				godot_android_armv7 | \
				godot_android_x86 |\
				godot_android_arm64v8 | \
				godot_android_x86_64)
					src_compile_gdnative
					;;
			esac
		fi
	done
	pushd platform/android/java || die
		export TERM=linux # pretend to be outside of X
		gradle_cmd=$(find /usr/bin/ \
			-regextype posix-extended \
			-regex '.*/gradle-[0-9]+.[0-9]+')
		"${gradle_cmd}" wrapper || die
		./gradlew generateGodotTemplates || die
	popd
}

src_compile_ios()
{
	export CCACHE=${CCACHE_IOS}
	local options_modules_
	if [[ -n "${EGODOT_IOS_CONFIG}" ]] ; then
		einfo "Using config override for IOS"
		einfo "${EGODOT_IOS_CONFIG}"
		options_modules_=(${EGODOT_IOS_CONFIG})
	else
		options_modules_=(${option_modules[@]})
	fi
	for a in ${GODOT_IOS} ; do
		if use ${a} ; then
			case "${a}" in
				godot_ios_armv7)
					bitness=32
					;;
				godot_ios_arm64 | \
				godot_ios_x86_64)
					bitness=64
					;;
				*)
					bitness=default
					;;
			esac

			einfo "Creating export template for iOS (${a})"
			for c in release release_debug ; do
				scons ${options_iphone[@]} \
					${options_modules_[@]} \
					$([[ -z "${EGODOT_IOS_CONFIG}" ]] \
						&& echo ${options_modules_static[@]}) \
					arch=${a} \
					bits=${bitness} \
					target=${c} \
					tools=no \
					|| die
			done

			# Not supported upstream
			case "${a}" in
				godot_ios_armv7 | \
				godot_ios_arm64 | \
				godot_ios_x86_64)
					ewarn "GDNative not supported upstream for iOS"
					#src_compile_gdnative
					;;
			esac
		fi
	done
}

src_compile_gdnative()
{
	unset CCACHE
	if use gdnative ; then
		local options_platform
		local options_modules_x
		local extra_args_godot
		local extra_args_cpp
		local platform_
		local harch
		local platform=${EPLATFORM/godot_platforms_/}

		case ${EPLATFORM} in
			godot_platforms_android)
				harch=${a/godot_android_/}
				if [[ "${harch}" == "arm64v8" ]] ; then
					harch2=arm64-v8a
				else
					harch2=${harch}
				fi
				options_platform=(${options_android[@]})
				options_modules_x=(${options_modules_static[@]})
				godot_platform=android
				extra_args_cpp=(
					TARGET_ARCH="${harch2}"
					android_arch=${harch}
					android_api_level=${EGODOT_ANDROID_API_LEVEL}
					bits=${bitness}
					target=$(usex debug "debug" "release")
				)
				extra_args_godot=(
					android_arch=${harch}
					bits=${bitness}
				)
				;;
			godot_platforms_ios)
				ewarn "Not supported upstream"
				harch=${a/godot_ios_/}
				options_platform=(${options_iphone[@]})
				options_modules_x=(${options_modules_static[@]})
				godot_platform=iphone
				extra_args_cpp=(
					TARGET_ARCH="${harch}"
					bits=${bitness}
					ios_arch=${harch}
					target=$(usex debug "debug" "release")
				)
				if [[ ${a} =~ (x86_64|x86) ]] ; then
					extra_args_cpp+=(
						ios_simulator=$(usex ios-sim)
					)
				fi
				extra_args_godot=( bits=${bitness} )
				;;
			godot_platforms_linux)
				harch=${a/godot_linux_/}
				options_platform=(${options_linux[@]})
				options_modules_x=(${options_modules_shared[@]})
				godot_platform=x11
				extra_args_cpp=(
					TARGET_ARCH="${harch}"
					bits=${bitness}
					target=$(usex debug "debug" "release")
				)
				extra_args_godot=( bits=${bitness} )
				;;
			godot_platforms_osx)
				harch=${a/godot_osx_/}
				options_platform=(${options_osx[@]})
				options_modules_x=(${options_modules_static[@]})
				godot_platform=osx
				extra_args_cpp=(
					TARGET_ARCH="${harch}"
					bits=${bitness}
					target=$(usex debug "debug" "release")
				)
				extra_args_godot=( bits=${bitness} )
				;;
			godot_platforms_web)
				harch=${a/godot_web_/}
				options_platform=(${options_javascript[@]})
				options_modules_x=(${options_modules_static[@]})
				godot_platform=javascript
				extra_args_cpp=(
					TARGET_ARCH="${harch}"
					bits=${bitness}
					target=$(usex debug "debug" "release")
				)
				extra_args_godot=( bits=${bitness} )
				;;
			godot_platforms_windows)
				harch=${a/godot_windows_/}
				options_platform=(${options_windows[@]})
				options_modules_x=(${options_modules_static[@]})
				godot_platform=windows
				extra_args_cpp=(
					TARGET_ARCH="${harch}"
					bits=${bitness}
					target=$(usex debug "debug" "release")
				)
				extra_args_godot=( bits=${bitness} )
				;;
			*)
				return
		esac

		unset e
		declare -A e
		e["name"]="godot"
		e["platform"]=".${godot_platform}"
		e["configuation"]="" # blank means debug
		e["tools"]=".tools"
		e["bitness"]=".${bitness}"
		e["llvm"]=$(usex clang ".llvm" "")
		e["sanitizer"]=""
		local fs=$(gen_fs e)
		einfo "fs=${fs}"

		if [[ ! -f "bin/${fs}" ]] ; then
			einfo "Rebuilding ${fs}"
				scons ${options_x11[@]} \
				${options_modules_x[@]} \
				${extra_args_godot[@]} \
					|| die
		fi

		# has do be done before C# API bindings to prevent crash
		einfo "Building GDNative C++ bindings for ${platform} (${harch})"

		for x in $(find /dev/input -name "event*") ; do
#			einfo "Adding \`addpredict ${x}\` sandbox rule"
#			addpredict "${x}"
			einfo "Adding \`addwrite ${x}\` sandbox rule"
			addwrite "${x}"
		done

		# Build for server fails here with
		# pure virtual method called
		local api_path="${BUILD_DIR}/godot-cpp/godot-headers/api.json"

		if [[ ! -f bin/${fs} ]] ; then
			die "Missing bin/${fs}"
		fi

		# virtx is always success
		# FIXME: stuck here
		virtx \
		bin/${fs} --audio-driver Dummy \
			--gdnative-generate-json-api \
			"${api_path}"

		if [[ ! -f "${api_path}" ]] ; then
			die "Missing expected ${api_path}"
		fi

		einfo "Generating GDNative C++ bindings for ${platform} (${harch})"
		pushd godot-cpp || die
			# See https://github.com/godotengine/godot-cpp/blob/master/SConstruct
			scons ${options_platform} \
				${options_modules[@]} \
				${options_modules_x[@]} \
				generate_bindings=yes \
				${extra_args_cpp[@]} \
				|| die
		popd
	fi
}

src_compile_linux()
{
	unset CCACHE
	for bitness in 32 64 ; do
		if [[ "${bitness}" == 32 ]] ; then
			! use godot_linux_x86 && continue
			einfo "Building Linux export templates for x86"
		else
			! use godot_linux_x86_64 && continue
			einfo "Building Linux export templates for x86_64"
		fi
		for c in release release_debug ; do
			scons ${options_x11[@]} \
				${options_modules[@]} \
				${options_modules_shared[@]} \
				bits=${bitness} \
				target=${c} \
				tools=no \
				|| die
		done
		src_compile_gdnative
	done

	if multilib_is_native_abi && ! use mono ; then
		einfo "Building Linux editor without Mono"
		scons ${options_x11[@]} \
			${options_modules[@]} \
			${options_modules_shared[@]} \
			$(usex debug "target=debug_release" "") \
			bits=default \
			module_mono_enabled=no \
			"CFLAGS=${CFLAGS}" \
			"CCFLAGS=${CXXFLAGS}" \
			"LINKFLAGS=${LDFLAGS}" || die
	fi

	if [[ -n "${EGODOT_CUSTOM_MODULES_BUILD}" ]] ; then
		IFS=$';'
		for x in ${EGODOT_CUSTOM_MODULES_BUILD} ; do
			local n=$(echo "${x}" | cut -f 1 -d ":")
			local c=$(echo "${x}" | cut -f 2 -d ":")
			einfo "Building the ${n} custom module"
			pushd modules/${n} || die
				eval "${c}"
			popd
		done
		IFS=$' \t\n'
	fi
}

src_compile_linux_server()
{
	unset CCACHE
	local options_extra=(
		$(usex debug "target=debug_release" "")
	)

	if [[ "${EPLATFORM}" == "server_dedicated" ]] ; then
		einfo "Building dedicated server"
		scons ${options_server[@]} \
			${options_modules[@]} \
			${options_modules_shared[@]} \
			${options_extra[@]} \
			tools=no \
			|| die
	fi
	if [[ "${EPLATFORM}" == "server_headless" ]] ; then
		einfo "Building editor server"
		scons ${options_server[@]} \
			${options_modules[@]} \
			${options_modules_shared[@]} \
			${options_extra[@]} \
			tools=yes \
			|| die
	fi
}

src_compile_osx()
{
	export CCACHE=${CCACHE_OSX}
	for a in ${GODOT_OSX} ; do
		if use ${a} ; then
			einfo "Creating export template for OSX (${a})"
			for c in release release_debug ; do
				scons ${options_osx[@]} \
					${options_modules[@]} \
					${options_modules_static[@]} \
					arch=${a} \
					target=${c} \
					tools=no \
					|| die
			done

			if [[ "${a}" == godot_osx_x86_64 ]] ; then
				bitness=64
				src_compile_gdnative
			fi
		fi
	done
}

src_compile_web()
{
	unset CCACHE
	local options_modules_
	if [[ -n "${EGODOT_WEB_CONFIG}" ]] ; then
		einfo "Using config override for Web"
		einfo "${EGODOT_WEB_CONFIG}"
		options_modules_=(${EGODOT_WEB_CONFIG})
	else
		options_modules_=(${options_modules[@]})
	fi
	einfo "Creating export templates for the Web with WebAssembly (WASM)"
	_configure_emscripten

	for c in release release_debug ; do
		scons ${options_javascript[@]} \
			${options_modules_[@]} \
			$([[ -z "${EGODOT_WEB_CONFIG}" ]] \
				&& echo ${options_modules_static[@]}) \
			target=${c} \
			tools=no \
			|| die
	done
}

src_compile_windows()
{
	unset CCACHE
	for a in ${GODOT_WINDOWS} ; do
		if use ${a} ; then
			local bitness
			if [[ "${a}" == "x86_64" ]] ; then
				bitness=64
			else
				bitness=32
			fi
			einfo "Creating export template for Windows (${a})"
			for c in release release_debug ; do
				scons ${options_windows[@]} \
					${options_modules[@]} \
					${options_modules_static[@]} \
					bits=${bitness} \
					target=${c} \
					tools=no \
					|| die
			done
			src_compile_gdnative
		fi
	done
}

build_mono_runtimes()
{
	export MONO_SOURCE_ROOT="${S_MONO}"
	pushd "${S_GMB}" || die
	if [[ "${USE}" =~ godot_mono_ ]] ; then
		einfo "Patching internal Mono"
		${EPYTHON} ./patch_mono.py || die
	fi
	if use godot_mono_web ; then
		einfo "Patching internal Mono for WASM"
		${EPYTHON} ./patch_emscripten.py || die
	fi

	# AOT compilation only generated for Android and iOS
	if has_mono_android ; then
		for a in ${GODOT_MONO_ANDROID[@]} ; do
			if use ${a} ; then
				local args=(
					--install-dir="${WORKDIR}/mrt/android"
					--target=${a}
				)
				if [[ "${a}" =~ cross ]] ; then
einfo
einfo "Building ${a/godot_mono_android_/} for Android with precompiled"
einfo "optimized AOT."
einfo
				else
einfo
einfo "Building Mono runtime for Android (${a})."
einfo
				fi
				${EPYTHON} ./android.py configure ${args[@]} || die
				${EPYTHON} ./android.py make ${args[@]} || die
			fi
		done
		local args=(
			--install-dir="${WORKDIR}/mrt/android"
			--product=android
		)
		einfo "Building Android BCL (Base Class Library)"
		${EPYTHON} ./bcl.py make ${args[@]} || die
	fi
	if has_mono_ios ; then
		# People that have this can finish this
		einfo "Building Mono runtime for iOS"
		for a in ${GODOT_MONO_IOS[@]} ; do
			if use ${a} ; then
				local args=(
					--install-dir="${WORKDIR}/mrt/ios"
					--ios-sdk="${IPHONESDK}"
					--ios-toolchain="${IPHONEPATH}"
					--osx-sdk="${MACOS_SDK_PATH}"
					--target=${a}
				)
				if [[ ${a} =~ (i386|x86_64) ]] ; then
einfo
einfo "Building Mono runtime for iPhone simulator."
einfo
				elif [[ ${a} =~ cross ]] ; then
einfo
einfo "Building ${a/godot_mono_ios_/} targeting the iPhone device with"
einfo "precompiled optimized AOT."
einfo
# Building does not work see
# https://github.com/godotengine/godot-mono-builds/tree/master#ios
				elif [[ ${a} =~ (armv7|arm64) ]] ; then
einfo
einfo "Building Mono runtime for ${a/godot_mono_ios_/} iPhone device."
einfo
				fi
				${EPYTHON} ./ios.py configure ${args[@]} || die
				${EPYTHON} ./ios.py make ${args[@]} || die
			fi
		done
		local args=(
			--install-dir="${WORKDIR}/mrt/ios"
			--product=ios
		)
		einfo "Building the iOS BCL (Base Class Library)"
		${EPYTHON} ./bcl.py make ${args[@]}  || die
	fi
	if has_mono_linux ; then
		local args=(
			--install-dir="${WORKDIR}/mrt/linux"
			--target=x86
			--target=x86_64
		)
		einfo "Building Mono runtime for the 64-/32-bit Linux desktop"
		${EPYTHON} ./linux.py configure ${args[@]} || die
		${EPYTHON} ./linux.py make ${args[@]} || die
		local args=(
			--install-dir="${WORKDIR}/mrt/linux"
			--product=desktop
		)
		einfo "Building the BCL (Base Class Library)"
		${EPYTHON} ./bcl.py make ${args[@]} || die
	fi
	if has_mono_osx ; then
		local args=(
			--install-dir="${WORKDIR}/mrt/osx"
			--osx-sdk "${MACOS_SDK_PATH}"
			--target=x86_64
		)
		einfo "Building Mono runtime for 64-bit macOS"
		${EPYTHON} ./osx.py configure ${args[@]} || die
		${EPYTHON} ./osx.py make ${args[@]} || die
		local args=(
			--install-dir="${WORKDIR}/mrt/osx"
			--product=desktop
		)
		einfo "Building the BCL (Base Class Library)"
		${EPYTHON} ./bcl.py make ${args[@]} || die
	fi
	if has_mono_windows ; then
		for b in x86 x86_64 ; do
			einfo "Building Mono runtime for ${b} Windows desktop"
			local tsyspath
			if [[ "${b}" == "x86_64" ]] ; then
				tsyspath=${EGODOT_MINGW32_SYSROOT}
			else
				tsyspath=${EGODOT_MINGW64_SYSROOT}
			fi
			PATH="${tsyspath}:${PATH}" \
			${EPYTHON} ./windows.py configure \
				${args[@]} \
				--install-dir="${WORKDIR}/mrt/windows" \
				--target=${b} \
				|| die
			PATH="${tsyspath}:${PATH}" \
			${EPYTHON} ./windows.py make \
				${args[@]} \
				--install-dir="${WORKDIR}/mrt/windows" \
				--target=${b} \
				|| die
			local args=(
				--install-dir="${WORKDIR}/mrt/windows"
				--product=desktop-win32
			)
			einfo "Building the BCL (Base Class Library)"
			PATH="${syspaths}:${PATH}" \
			${EPYTHON} ./bcl.py make ${args[@]} || die
		done
	fi
	if has_mono_web ; then
		_configure_emscripten
		local args=(
			--install-dir="${WORKDIR}/mrt/web"
			--target=runtime
		)
		einfo "Building Mono runtime for WASM"
		${EPYTHON} ./wasm.py configure ${args[@]} || die
		${EPYTHON} ./wasm.py make ${args[@]} || die
		einfo "Building WASM BCL (Base Class Library)"
		local args=(
			--install-dir="${WORKDIR}/mrt/web"
			--product=wasm
		)
		${EPYTHON} ./bcl.py make ${args} || die
	fi
	popd
}

src_compile_mono()
{
	unset CCACHE
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

	build_mono_runtimes

	# Glue to enable the Mono module.
	einfo "Generating glue source code for Mono support and C# solution"
	scons ${options_x11[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
		module_mono_enabled=yes \
		mono_glue=no \
		tools=yes \
		|| die

	unset e
	declare -A e
	e["name"]="godot"
	e["platform"]=".x11"
	e["tools"]=".tools"
	e["bitness"]=$(_get_bitness)
	e["llvm"]=$(usex clang ".llvm" "")
	e["mono"]=".mono"
	local fs=$(gen_fs e)

	einfo "Making modules/mono/glue/mono_glue.gen.cpp"
	bin/${fs} --audio-driver Dummy \
		--generate-mono-glue \
		modules/mono/glue || die

	if ! ( find bin -name "data.*" ) ; then
eerror
eerror "Missing export templates directory (data.mono.*.*.*).  Likely caused by"
eerror "crash while generating mono_glue.gen.cpp."
eerror
		die
	fi

	einfo "Building Linux editor with Mono support"
	scons ${options_x11[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
		bits=default \
		module_mono_enabled=yes \
		tools=yes \
		"CFLAGS=${CFLAGS}" \
		"CCFLAGS=${CXXFLAGS}" \
		"LINKFLAGS=${LDFLAGS}" || die

	options_export_templates=(
		module_mono_enabled=yes
		tools=no
	)
	if has_mono_linux ; then
		options_export_templates+=( mono_static=$(usex portable) )
	else
		options_export_templates+=( mono_static=yes )
	fi

	if has_mono_android ; then
		NDK_V=$(best_version "dev-util/android-ndk" | sed -e "s|dev-util/android-ndk-||")
		einfo "Building Mono export templates for Android"
		for a in ${GODOT_MONO_ANDROID} ; do
			local options_extra=(
				android_arch=${a}
				ndk_platform=${NDK_V}
				mono_prefix="${WORKDIR}/mrt/android"
			)
			[[ ${a} =~ armv7 ]] && options_extra+=( android_neon=$(usex neon) )
			if use ${a} ; then
				for c in release release_debug ; do
					scons ${options_android[@]} \
						${options_modules[@]} \
						${options_modules_static[@]} \
						${options_extra[@]} \
						${options_export_templates} \
						target=${c} \
						|| die
				done
			fi
		done
	fi
	if has_mono_ios ; then
		einfo "Building Mono export templates for iOS"
		for a in ${GODOT_MONO_IOS} ; do
			local options_extra=(
				arch=${a}
				mono_prefix="${WORKDIR}/mrt/ios"
			)
			if use ${a} ; then
				for c in release release_debug ; do
					scons ${options_iphone[@]} \
						${options_modules[@]} \
						${options_modules_static[@]} \
						${options_extra[@]} \
						${options_export_templates} \
						target=${c} \
						|| die
				done
			fi
		done
	fi
	if has_mono_linux ; then
		einfo "Building Mono export templates for Linux"
		local options_extra=(
			mono_prefix="${WORKDIR}/mrt/linux"
		)
		for c in release release_debug ; do
			scons ${options_x11[@]} \
				${options_modules[@]} \
				${options_modules_shared[@]} \
				${options_extra[@]}
				${options_export_templates} \
				target=${c} \
				|| die
		done
	fi
	if has_mono_osx ; then
		einfo "Building Mono export templates for OSX"
		local options_extra=(
			mono_prefix="${WORKDIR}/mrt/osx"
		)
		for c in release release_debug ; do
			scons ${options_osx[@]} \
				${options_modules[@]} \
				${options_modules_static[@]} \
				${options_extra[@]} \
				${options_export_templates} \
				target=${c} \
				|| die
		done
	fi
	if has_mono_windows ; then
		einfo "Building Mono export templates for Windows"
		local options_extra=(
			mono_prefix="${WORKDIR}/mrt/windows"
		)
		for b in 32 64 ; do
			local tsyspath
			if [[ ${b} == "32" ]] ; then
				tsyspath="${EGODOT_MINGW32_SYSROOT}"
			else
				tsyspath="${EGODOT_MINGW64_SYSROOT}"
			fi
			for c in release release_debug ; do
				PATH="${tsyspath}:${PATH}" \
				scons ${options_windows[@]} \
					${options_modules[@]} \
					${options_modules_static[@]} \
					${options_extra[@]} \
					${options_export_templates} \
					target=${c} \
					|| die
			done
		done
	fi
	if has_mono_web ; then
		einfo "Building Mono export templates for Web"
		local options_extra=(
			mono_prefix="${WORKDIR}/mrt/web"
		)
		for c in release release_debug ; do
			scons ${options_javascript[@]} \
				${options_modules[@]} \
				${options_modules_static[@]} \
				${options_extra[@]} \
				${options_export_templates} \
				target=${c} \
				|| die
		done
	fi


	if use mono_pregen_assemblies ; then
		# Generate the Godot C# API assemblies.
		local sln_folder="build_GodotSharp"
		local release=$(usex debug "Debug" "Release")
		mkdir -p build_GodotSharp || die
		einfo \
"Generating bindings source code and sln file for Mono"
		bin/${fs} --audio-driver Dummy \
			--generate-cs-api ${sln_folder} || die
		if [[ -f "${sln_folder}/GodotSharp.sln" ]] ; then
			einfo "Pregenerating Godot API assemblies for Mono"
			for configuration in debug release ; do
				local data_api_folder="bin/data.mono.x11${bitness}.${configuration}/Api"
				mkdir -p ${data_api_folder} || die
				msbuild ${sln_folder}/GodotSharp.sln \
					/p:Configuration=${configuration^} || die
				mkdir -p ${data_api_folder} || die
				cp -a \
build_GodotSharp/GodotSharp/bin/${configuration}/GodotSharp.{dll,pdb,xml} \
					${data_api_folder} || die
				cp -a \
build_GodotSharp/GodotSharpEditor/bin/${configuration}/GodotSharpEditor.{dll,pdb,xml} \
					${data_api_folder} || die
			done
		fi
	fi
}

src_compile() {
	local myoptions=()
	myoptions+=( production=$(usex !debug) )
	local options_android=(
		platform=android
	)
	local options_iphone=(
		platform=iphone
		game_center=$(usex game-center)
		icloud=$(usex icloud)
		use_lto=$(usex lto)
		store_kit=$(usex store-kit)
	)
	local options_javascript=(
		platform=javascript
		javascript_eval=$(usex javascript_eval)
		threads_enabled=$(usex javascript_threads)
		use_lto=$(usex lto)
		use_closure_compiler=$(usex closure-compiler)
	)
	local options_linux=(
		platform=linux
	)
	local options_osx=(
		platform=osx
		osxcross_sdk=${EOSXCROSS_SDK}
		use_asan=$(usex asan_client)
		use_tsan=$(usex tsan_client)
		use_ubsan=$(usex ubsan_client)
	)
	local options_server=(
		platform=server
		use_asan=$(usex asan_server)
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_lsan=$(usex lsan_server)
		use_msan=$(usex msan_server)
		use_thinlto=$(usex lto)
		use_tsan=$(usex tsan_server)
		use_ubsan=$(usex ubsan_server)
	)
	local options_windows=(
		platform=windows
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_thinlto=$(usex lto)
		use_asan=$(usex asan_client)
	)
	local options_x11=(
		platform=x11
		pulseaudio=$(usex pulseaudio)
		udev=$(usex gamepad)
		touch=$(usex touch)
		use_asan=$(usex asan_client)
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_lsan=$(usex lsan_client)
		use_msan=$(usex msan_client)
		use_thinlto=$(usex lto)
		use_tsan=$(usex tsan_client)
		use_ubsan=$(usex ubsan_client)
	)
	local options_modules_shared=(
		builtin_bullet=$(usex !system-bullet)
		builtin_embree=$(usex !system-embree)
		builtin_enet=$(usex !system-enet)
		builtin_freetype=$(usex !system-freetype)
		builtin_libogg=$(usex !system-libogg)
		builtin_libpng=$(usex !system-libpng)
		builtin_libtheora=$(usex !system-libtheora)
		builtin_libvorbis=$(usex !system-libvorbis)
		builtin_libvpx=$(usex !system-libvpx)
		builtin_libwebp=$(usex !system-libwebp)
		builtin_libwebsockets=$(usex !system-libwebsockets)
		builtin_mbedtls=$(usex !system-mbedtls)
		builtin_miniupnpc=$(usex !system-miniupnpc)
		builtin_pcre2=$(usex !system-pcre2)
		builtin_opus=$(usex !system-opus)
		builtin_recast=$(usex !system-recast)
		builtin_squish=$(usex !system-squish)
		builtin_wslay=$(usex !system-wslay)
		builtin_xatlas=$(usex !system-xatlas)
		builtin_zlib=$(usex !system-zlib)
		builtin_zstd=$(usex !system-zstd)
		pulseaudio=$(usex pulseaudio)
		use_static_cpp=$(usex portable)
		builtin_certs=$(usex portable)
		$(usex portable "" \
"system_certs_path=/etc/ssl/certs/ca-certificates.crt")
	)
	local options_modules_static=(
		builtin_bullet=True
		builtin_embree=True
		builtin_enet=True
		builtin_freetype=True
		builtin_libogg=True
		builtin_libpng=True
		builtin_libtheora=True
		builtin_libvorbis=True
		builtin_libvpx=True
		builtin_libwebp=True
		builtin_libwebsockets=True
		builtin_mbedtls=True
		builtin_miniupnpc=True
		builtin_pcre2=True
		builtin_opus=True
		builtin_recast=True
		builtin_squish=True
		builtin_wslay=True
		builtin_xatlas=True
		builtin_zlib=True
		builtin_zstd=True
		pulseaudio=False
		use_static_cpp=True
		builtin_certs=True
	)

	if use optimize-size ; then
		myoptions+=( optimize=size )
	else
		myoptions+=( optimize=speed )
	fi

	options_modules+=(
		disable_3d=$(usex !3d)
		disable_advanced_gui=$(usex !advanced-gui)
		minizip=$(usex minizip)
		builtin_pcre2_with_jit=$(usex jit)
		module_bmp_enabled=$(usex bmp)
		module_bullet_enabled=$(usex bullet)
		module_camera_enabled=$(usex camera)
		module_csg_enabled=$(usex csg)
		module_cvtt_enabled=$(usex cvtt)
		module_dds_enabled=$(usex dds)
		module_denoise_enabled=$(usex denoise)
		module_etc_enabled=$(usex etc1)
		module_enet_enabled=$(usex enet)
		module_freetype_enabled=$(usex freetype)
		module_gdnative_enabled=$(usex gdnative)
		module_gdscript_enabled=$(usex gdscript)
		module_gltf_enabled=$(usex gltf)
		module_gridmap_enabled=$(usex gridmap)
		module_hdr_enabled=$(usex hdr)
		module_jpg_enabled=$(usex jpeg)
		module_jsonrpc_enabled=$(usex jsonrpc)
		module_lightmapper_cpu_enabled=$(usex lightmapper_cpu)
		module_mbedtls_enabled=$(usex mbedtls)
		module_minimp3_enabled=$(usex mp3)
		module_mobile_vr_enabled=$(usex mobile-vr)
		module_ogg_enabled=$(usex ogg)
		module_opensimplex_enabled=$(usex opensimplex)
		module_opus_enabled=$(usex opus)
		module_pvr_enabled=$(usex pvrtc)
		module_raycast_enabled=$(usex raycast)
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
		module_webxr_enabled=$(usex webxr)
		module_xatlas_enabled=$(usex xatlas)
		${EGODOT_ADDITIONAL_CONFIG} )

	godot_compile_impl() {
		cd "${BUILD_DIR}" || die
		if [[ "${EPLATFORM}" == "godot_platforms_android" ]] ; then
			src_compile_android
		elif [[ "${EPLATFORM}" == "godot_platforms_ios" ]] ; then
			src_compile_ios
		elif [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
			multilib_compile_linux() {
				cd "${BUILD_DIR}" || die
				src_compile_linux
			}
			multilib_foreach_abi multilib_compile_linux
		elif [[ "${EPLATFORM}" == "godot_platforms_osx" ]] ; then
			src_compile_osx
		elif [[ "${EPLATFORM}" == "server_dedicated" \
			|| "${EPLATFORM}" == "server_headless" ]] ; then
			multilib_compile_server() {
				cd "${BUILD_DIR}" || die
				src_compile_linux_server
			}
			multilib_foreach_abi multilib_compile_server
		elif [[ "${EPLATFORM}" == "godot_platforms_mono" ]] ; then
			# native for now
			src_compile_mono
		elif [[ "${EPLATFORM}" == "godot_platforms_web" ]] ; then
			# int/pointers are 32-bit in wasm
			src_compile_web
		elif [[ "${EPLATFORM}" == "godot_platforms_windows" ]] ; then
			multilib_compile_windows() {
				cd "${BUILD_DIR}" || die
				src_compile_windows
			}
			multilib_foreach_abi multilib_compile_windows
		fi
	}
	platforms_foreach_impl godot_compile_impl

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

_get_bitness() {
	[[ $(get_libdir) =~ 64 ]] && echo ".64" || echo ".32"
}

src_install_android()
{
	einfo "Installing export templates for Android"
	insinto /usr/share/godot/${SLOT_MAJ}/android/templates
	doins bin/android_{release,debug}.apk
	echo "${PV}.${STATUS}" > "${T}/version.txt" || die
	doins "${T}/version.txt"

	for a in ${GODOT_ANDROID} ; do
		if use ${a} ; then
			arch_suffix=${a/godot_android_/}

			if [[ "${arch_suffix}" == "arm64v8" ]] ; then
				${arch_suffix}="arm64-v8a"
			fi

			src_install_gdnative
		fi
	done
}

src_install_demos()
{
	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	if use examples-live || use examples-snapshot \
		|| use examples-stable ; then
		einfo "Installing demos"
		doins -r "${S_DEMOS}"/*
	fi
}

src_install_gdnative()
{
	if use gdnative ; then
		if [[ "${EPLATFORM}" == "godot_platforms_android" ]] ; then
			einfo "Installing GDNative bindings for Android"
			local libext=".a"
			local configuration="."$(usex debug "debug" "release")
			local platform=".android"

			einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
			dolib.a godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
		elif [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
			local libext=$(usex portable ".a" ".so")
			local configuration="."$(usex debug "debug" "release")
			local platform=".linux"
			arch_suffix=".${bitness}"

			if use portable ; then
				einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
				dolib.a godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
			else
				einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
				dolib.so godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
			fi

			einfo "Installing GDNative bindings for Linux"
			local platform="x11" # can only be x11 or server
			insinto /usr/include/gdnative-${platform}
			doins -r modules/gdnative/include/*
			insinto /usr/$(get_libdir)/pkgconfig

			cat "${FILESDIR}/godot${SLOT_MAJ}-gdnative-${platform}.pc.in" | \
				sed -e "s|@prefix@|/usr|g" \
				-e "s|@exec_prefix@|\${prefix}|g" \
				-e "s|@libdir@|/usr/$(get_libdir)|g" \
			-e "s|@includedir@|\${prefix}/include/gdnative-${platform}|g" \
				-e "s|@version@|${PV}|g" \
				-e "s|@bitness@|${bitness}|g" \
				-e "s|@configuration@|${configuration}|g" \
				> "${T}/godot${SLOT_MAJ}-gdnative-${platform}.pc" || die
			doins "${T}/godot${SLOT_MAJ}-gdnative-${platform}.pc"

		elif [[ "${EPLATFORM}" == "godot_platforms_osx" ]] ; then
			einfo "Installing GDNative bindings for OSX"
			local libext=".a"
			local configuration="."$(usex debug "debug" "release")
			local platform=".osx"

			einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
			dolib.a godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
		elif [[ "${EPLATFORM}" == "godot_platforms_windows" ]] ; then
			einfo "Installing GDNative bindings for Windows"
			local libext=".a"
			local configuration="."$(usex debug "debug" "release")
			local platform=".windows"

			einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
			dolib.a godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
		elif [[ "${EPLATFORM}" == "godot_platforms_web" ]] ; then
			einfo "Installing GDNative bindings for Web"
			local libext=".bc"
			local configuration="."$(usex debug "debug" "release")
			local platform=".javascript"

			einfo "lib=godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}"
			dolib.a godot-cpp/bin/libgodot-cpp${platform}${configuration}${arch_suffix}${libext}
		elif [[ "${EPLATFORM}" == "godot_platforms_ios" ]] ; then
			ewarn "Installing GDNative bindings for iOS is not supported"
		fi
	fi
}

src_install_linux()
{
	local bitness=$(_get_bitness)
	bitness=${bitness//./}
	exeinto /usr/share/godot/${SLOT_MAJ}/linux/templates
	einfo "Installing export templates for Linux"
	for bitness in 32 64 ; do
		for c in debug release ; do
			if [[ -f "bin/godot.x11.opt.${bitness}" && "${c}" == "release" ]] ; then
				newexe bin/godot.x11.opt.${bitness} \
					linux_x11_${bitness}_${c}
			fi
			if [[ -f "bin/godot.x11.opt.debug.${bitness}" && "${c}" == "debug" ]] ; then
				newexe bin/godot.x11.opt.debug.${bitness} \
					linux_x11_${bitness}_${c}
			fi
		done
	done
	if multilib_is_native_abi ; then
		einfo "Setting up Linux editor environment"
		make_desktop_entry \
			"/usr/bin/godot${SLOT_MAJ}" \
			"Godot${SLOT_MAJ}" \
			"/usr/share/pixmaps/godot${SLOT_MAJ}.png" \
			"Development;IDE"
		newicon icon.png godot${SLOT_MAJ}.png
	fi

	if [[ -n "${EGODOT_CUSTOM_MODULES_LIBS}" ]] ; then
		for x in ${EGODOT_CUSTOM_MODULES_LIBS} ; do
			einfo "Installing ${x} custom module"
			local d_base=$(_get_d_base)
			exeinto "${d_base}/bin"
			doexe bin/${x}
		done
	fi

	for bitness in 32 64 ; do
		if [[ "${bitness}" == 32 ]] ; then
			! use godot_linux_x86 && continue
		else
			! use godot_linux_x86_64 && continue
		fi
		src_install_gdnative
	done
}

src_install_linux_server()
{
	local bitness=$(_get_bitness)
	bitness=${bitness//./}
	insinto /usr/share/godot/${SLOT_MAJ}/${EPLATFORM//godot_platforms_/}/templates
	einfo "Installing export templates for ${EPLATFORM//godot_platforms_/}"
	doins bin/linux_server_${bitness}
}

_get_d_base()
{
	echo "/usr/$(get_libdir)/${PN}${SLOT_MAJ}/${platform}"
}

src_install_mono()
{
	local d_base=$(_get_d_base)
	into "${d_base}/bin"
	if [[ -f bin/libmonosgen-2.0.so ]] ; then
		einfo "Installing the shared Mono glue library"
		dolib.so bin/libmonosgen-2.0.so
	else
		if ! use portable ; then
eerror
eerror "The Mono glue library is missing or was not built statically."
eerror
			die
		fi
	fi

	einfo "Installing Mono runtimes"
	insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates"
	for p in android ios x11 osx javascript windows ; do
		insinto "${d_base}/bin"
		for bitness in .32 .64 "" ; do
			for configuration in .debug .release ; do
				local data_api_folder="bin/data.mono.${p}${bitness}${configuration}"
				if [ -d "${data_api_folder}" ] ; then
einfo
einfo "Installing Mono data directory for ${p} (${bitness/./})"
einfo
					doins -r ${data_api_folder}
				fi
			done
		done
	done

	einfo "Installing Mono BCL (Base Class Library)"
	insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates"
	if has_mono_android ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/monodroid"
		for a in ${GODOT_MONO_ANDROID[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/android/monodroid-bcl"
				doins -r "${WORKDIR}/mrt/android/monodroid_tools-bcl"
			fi
		done
	fi
	if has_mono_ios ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/monotouch"
		for a in ${GODOT_MONO_IOS[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/ios/monotouch-bcl"
				doins -r "${WORKDIR}/mrt/ios/monotouch_runtime-bcl"
				doins -r "${WORKDIR}/mrt/ios/monotouch_tools-bcl"
			fi
		done
	fi
	if has_mono_linux ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/net_4_x"
		for a in ${GODOT_MONO_LINUX[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/linux/net_4_x-bcl"
			fi
		done
	fi
	if has_mono_osx ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/net_4_x"
		for a in ${GODOT_MONO_OSX[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/osx/net_4_x-bcl"
			fi
		done
	fi
	if has_mono_web ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/wasm"
		for a in ${GODOT_MONO_WEB[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/web/wasm-bcl"
				doins -r "${WORKDIR}/mrt/web/wasm_tools-bcl"
			fi
		done
	fi
	if has_mono_windows ; then
		insinto "/usr/share/godot/${SLOT_MAJ}/mono/templates/bcl/net_4_x_win"
		for a in ${GODOT_MONO_WINDOWS[@]} ; do
			if use ${a} ; then
				doins -r "${WORKDIR}/mrt/web/net_4_x-win32-bcl"
			fi
		done
	fi
}

src_install_web()
{
	einfo "Installing export templates for Web"
	insinto /usr/share/godot/${SLOT_MAJ}/web/templates
	doins bin/javascript_{release,debug}.zip
}

_install_linux_editor_or_server() {
	local -n t=$1
	local fs=$(gen_fs t)
	local fd=$(gen_fd t)
	local d_base=$(_get_d_base)
	exeinto "${d_base}/bin"
	einfo "fs=${fs}"
	einfo "fd=${fd}"
	mv bin/${fs} bin/${fd} || die
	doexe bin/${fd}
	if [[ "${EPLATFORM}" == "server_dedicated" \
		|| "${EPLATFORM}" == "server_headless" ]] ; then
		dosym "${d_base}/bin/${fd}" "/usr/bin/${t[dname]}${SLOT_MAJ}-${ABI}"
	else
		dosym "${d_base}/bin/${fd}" "/usr/bin/${t[dname]}${SLOT_MAJ}"
	fi
}

src_install() {
	for x in server x11 ; do
		if [[ "${x}" == "server" ]] && ! use server ; then
			continue
		fi
	done

	godot_install_impl() {
		if [[ "${EPLATFORM}" == "godot_platforms_linux" \
			|| "${EPLATFORM}" == "godot_platforms_mono" \
			|| "${EPLATFORM}" == "server_dedicated" \
			|| "${EPLATFORM}" == "server_headless" ]] ; then
			cd "${BUILD_DIR}" || die
			multilib_install_impl() {
				cd "${BUILD_DIR}" || die
				# Generate the inputs for filename generation with e.
				unset e
				declare -A e
				if [[ "${EPLATFORM}" == "server" ]] ; then
					e["name"]="godot_server"
				else
					e["name"]="godot"
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" \
					|| "${EPLATFORM}" == "godot_platforms_mono" ]] ; then
					# Destination name for symlinks
					e["dname"]="godot"
				elif [[ "${EPLATFORM}" == "server_dedicated" ]] ; then
					e["dname"]="godot_game_server"
				elif [[ "${EPLATFORM}" == "server_headless" ]] ; then
					e["dname"]="godot_editor_server"
				fi
				e["platform"]=".x11"
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
					e["configuation"]=""
				else
					e["configuation"]=".opt"
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" \
				  || "${EPLATFORM}" == "godot_platforms_mono" \
				  || "${EPLATFORM}" == "server_headless" ]] ; then
					e["tools"]=".tools"
				fi
				e["bitness"]=$(_get_bitness)
				e["llvm"]=$(usex clang ".llvm" "")
				if [[ "${EPLATFORM}" == "godot_platforms_mono" ]] ; then
					e["mono"]=".mono"
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" \
					|| "${EPLATFORM}" == "godot_platforms_mono" ]] \
					&& (use asan_client || use lsan_client \
					|| use tsan_client || use ubsan_client); then
					e["sanitizer"]=".s"
				elif [[ "${EPLATFORM}" == "server_dedicated" \
					|| "${EPLATFORM}" == "server_headless" ]] \
					&& (use asan_server || use lsan_server \
					|| use tsan_server || use ubsan_server); then
					e["sanitizer"]=".s"
				else
					e["sanitizer"]=""
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] && use mono ; then
					einfo "Skipping mono editor"
					:; # subset, install only one X enabled editor
				elif [[ "${EPLATFORM}" == "godot_platforms_linux" ]] \
					&& ! multilib_is_native_abi ; then
					einfo "Skipping 32-bit editor"
					:;
				elif [[ "${EPLATFORM}" == "godot_platforms_linux" \
					|| "${EPLATFORM}" == "server_dedicated" \
					|| "${EPLATFORM}" == "server_headless" ]] ; then
					_install_linux_editor_or_server e
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
					src_install_linux
				fi
				if [[ "${EPLATFORM}" == "server_dedicated" \
                                        || "${EPLATFORM}" == "server_headless" ]] ; then
					src_install_linux_server
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_mono" ]] \
					&& multilib_is_native_abi ; then
					src_install_mono
				fi
			}
			multilib_foreach_abi multilib_install_impl
		elif [[ "${EPLATFORM}" == "godot_platforms_android" ]] ; then
			src_install_android
		elif [[ "${EPLATFORM}" == "godot_platforms_ios" ]] ; then
			:; # TODO
		elif [[ "${EPLATFORM}" == "godot_platforms_osx" ]] ; then
			:; # TODO
		elif [[ "${EPLATFORM}" == "godot_platforms_web" ]] ; then
			src_install_web
		elif [[ "${EPLATFORM}" == "godot_platforms_windows" ]] ; then
			:; # TODO
		fi
	}
	platforms_foreach_impl godot_install_impl

	src_install_demos
}

pkg_postinst() {
	for p in ${EPLATFORMS} ; do
		if use ${p} ; then
einfo
einfo "You need to copy the ${p} templates from"
einfo "/usr/share/godot/${SLOT_MAJ}/${p}/templates to"
einfo "~/.local/share/godot/templates/${PV}.${STATUS} or"
einfo "\${XDG_DATA_HOME}/godot/templates/${PV}.${STATUS}"
einfo
		fi
	done
}
