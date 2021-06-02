# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

STATUS="rc"

GODOT_PLATFORMS_=(android ios linux osx web windows)
EPLATFORMS="server_dedicated server_headless ${GODOT_PLATFORMS_[@]/#/godot_platforms_}"
PYTHON_COMPAT=( python3_{7..10} )
LLVM_MAX_LTO_SLOT=11 # LTO breaks with 13 but 11 is stable
inherit check-reqs desktop eutils flag-o-matic llvm multilib-build platforms \
python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="all-rights-reserved Apache-2.0 BSD BSD-2 CC-BY-3.0 FTL ISC MIT \
MPL-2.0 OFL-1.1 openssl RSA Unlicense ZLIB"

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# thirdparty/fonts/DroidSans*.ttf - Apache-2.0

# thirdparty/fonts/source_code_pro.otf - all-rights-reserved OFL-1.1 # \
#   The original OFL-1.1 does not contain all rights reserved but stated in \
#   LICENSE.SourceCodePro.txt

#KEYWORDS="~amd64 ~x86" # disabled because ebuilds are still in development
PND="${PN}-demo-projects"

# tag 2.1 deterministic / static snapshot / 2.1 branch / 20200203
EGIT_COMMIT_2_1_DEMOS_SNAPSHOT="7dec39be19f9d8b486a5d4a1dae24e1fb9c848e6"

# 2.1 stable
EGIT_COMMIT_2_1_DEMOS_STABLE="5fe6147a345a9fa75d94cfb84c1bb5221645160c"

EGIT_COMMIT="89e531d223ef189219e266cc61ea79a7dd2d5f54"

FN_SRC="${EGIT_COMMIT}.zip"
FN_DEST="${P}.zip"
FN_SRC_ESN="${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}.zip" # examples snapshot
FN_DEST_ESN="${PND}-${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}.zip"
FN_SRC_EST="${EGIT_COMMIT_2_1_DEMOS_STABLE}.zip" # examples stable
FN_DEST_EST="${PND}-${EGIT_COMMIT_2_1_DEMOS_STABLE}.zip"
URI_ORG="https://github.com/godotengine"
URI_PROJECT="${URI_ORG}/godot"
URI_PROJECT_DEMO="${URI_ORG}/godot-demo-projects"
URI_DL="${URI_PROJECT}/tree/${EGIT_COMMIT}"
URI_A="${URI_PROJECT}/archive/${EGIT_COMMIT}.zip"
SRC_URI="${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST}
examples-snapshot? (
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_ESN} \
		-> ${FN_DEST_ESN}
)
examples-stable? (
  ${URI_PROJECT_DEMO}/archive/${FN_SRC_EST} \
		-> ${FN_DEST_EST}
)"
SLOT_MAJ="2"
SLOT="${SLOT_MAJ}/${PV}"

GODOT_ANDROID_=(arm6 arm7 arm64v8 x86 x86_64)
GODOT_IOS_=(arm armv7 armv64 x86 x86_64)
GODOT_LINUX_=(x86 x86_64)
GODOT_OSX_=(x86_64)
GODOT_WEB_=(asmjs)
GODOT_WINDOWS_=(i686 x86_64)

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_ANDROID=" ${GODOT_ANDROID_[@]/#/godot_android_}"
IUSE+=" ${GODOT_ANDROID}"
GODOT_IOS=" ${GODOT_IOS_[@]/#/godot_iphone_}"
IUSE+=" ${GODOT_IOS}"
GODOT_LINUX=" ${GODOT_LINUX_[@]/#/godot_linux_}"
IUSE+=" ${GODOT_LINUX}"
GODOT_OSX=" ${GODOT_OSX_[@]/#/godot_osx_}"
IUSE+=" ${GODOT_OSX}"
GODOT_WINDOWS=" ${GODOT_WINDOWS_[@]/#/godot_windows_}"
IUSE+=" ${GODOT_WINDOWS}"
GODOT_WEB=" ${GODOT_WEB_[@]/#/godot_web_}"
IUSE+=" ${GODOT_WEB}"
GODOT_PLATFORMS=" ${GODOT_PLATFORMS_[@]/#/godot_platforms_}"
IUSE+=" +godot_platforms_linux"
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_ANDROID}" godot_platforms_android)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_IOS}" godot_platforms_ios)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_LINUX}" godot_platforms_linux)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_OSX}" godot_platforms_osx)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_WEB}" godot_platforms_web)
REQUIRED_USE+=" "$(gen_required_use_template "${GODOT_WINDOWS}" godot_platforms_windows)

IUSE+=" +3d +advanced-gui +clang debug docs examples-snapshot examples-stable \
+linux lld lto portable server server_dedicated server_headless"
IUSE+=" +bmp +dds +exr +etc1 +minizip +musepack +pbm +jpeg +mod +ogg +pvrtc \
+svg +s3tc +speex +theora +vorbis +webm +webp +xml" # encoding/container formats
IUSE+=" +gdscript +visual-script web" # for scripting languages
IUSE+=" +gridmap +ik +recast" # for 3d
IUSE+=" +openssl" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +freetype +pulseaudio +speex" # for libraries
IUSE+=" system-freetype system-glew system-libmpcdec system-libogg \
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp \
system-openssl system-opus system-recast system-speex \
system-squish system-zlib"
IUSE+=" android"
IUSE+=" doxygen"
IUSE+=" asan_server lsan_server"
IUSE+=" asan_client lsan_client"
IUSE+=" -ios-sim +icloud +game-center +store-kit" # ios
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	abi_x86_32? ( godot_linux_x86 godot_platforms_linux )
	abi_x86_64? ( godot_linux_x86_64 godot_platforms_linux )
	clang
	docs? ( doxygen )
	doxygen? ( docs )
	examples-snapshot? ( !examples-stable )
	examples-stable? ( !examples-snapshot )
	godot_linux_x86? ( abi_x86_32 godot_platforms_linux )
	godot_linux_x86_64? ( abi_x86_64 godot_platforms_linux )
	godot_platforms_android? ( || ( ${GODOT_ANDROID} ) )
	godot_platforms_ios? ( || ( ${GODOT_IOS} ) )
	godot_platforms_linux
	godot_platforms_linux? ( || ( ${GODOT_LINUX} ) )
	godot_platforms_osx? ( || ( ${GODOT_OSX} ) )
	godot_platforms_web? ( || ( ${GODOT_WEB} ) )
	godot_platforms_windows? ( || ( ${GODOT_WINDOWS} ) )
	lld? ( clang )
	lsan_client? ( asan_client )
	lsan_server? ( asan_server )
	portable? (
		!asan_client
		!asan_server
		!system-freetype
		!system-glew
		!system-libmpcdec
		!system-libogg
		!system-libpng
		!system-libtheora
		!system-libvorbis
		!system-libvpx
		!system-libwebp
		!system-openssl
		!system-opus
		!system-recast
		!system-speex
		!system-squish
		!system-zlib
	)
	server? ( || ( server_dedicated
		server_headless ) )
	server_dedicated? ( server )
	server_headless? ( server )"

# See https://github.com/godotengine/godot/tree/2.1/thirdparty for versioning
# See https://docs.godotengine.org/en/2.1/development/compiling/compiling_for_android.html
# See https://docs.godotengine.org/en/2.1/development/compiling/compiling_for_web.html
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# See https://developer.apple.com/ios/submit/ for app store requirement
# Some are repeated because they were shown to be in the ldd list
APST_REQ_STORE_DATE="April 2021"
IOS_SDK_MIN_STORE="14"
XCODE_SDK_MIN_STORE="12"
EXPECTED_IOS_SDK_MIN_VERSION_SIM="9"
EXPECTED_IOS_SDK_MIN_VERSION_=""
EXPECTED_XCODE_SDK_MIN_VERSION_X86_64="10.9"
LIBOGG_V="1.3.3"
LIBVORBIS_V="1.3.6"
CDEPEND="
	godot_android_x86? ( >=dev-util/android-ndk-21 )
	godot_android_x86_64? ( >=dev-util/android-ndk-21 )
	godot_android_arm64v8? ( >=dev-util/android-ndk-21 )
	godot_platforms_android? (
		dev-util/android-sdk-update-manager
		>=dev-util/android-ndk-17:=
		dev-java/gradle-bin
		dev-java/openjdk:8
	)
	godot_platforms_ios? ( sys-devel/osxcross )
	godot_platforms_osx? ( sys-devel/osxcross )
	godot_platforms_web? ( <dev-util/emscripten-2[asmjs] )
	godot_platforms_windows? ( sys-devel/crossdev )"
CDEPEND_CLANG="
	clang? (
		!lto? ( sys-devel/clang[${MULTILIB_USEDEP}] )
		lto? (
			<sys-devel/clang-$((${LLVM_MAX_LTO_SLOT}+1))[${MULTILIB_USEDEP}]
			<sys-devel/llvm-$((${LLVM_MAX_LTO_SLOT}+1))[${MULTILIB_USEDEP},gold]
		)
	)"
CDEPEND_GCC="
	!clang? ( <sys-devel/gcc-6.0 )"
DEPEND+=" ${PYTHON_DEPS}
	${CDEPEND}
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
	>=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}]
        media-sound/pulseaudio[${MULTILIB_USEDEP}]
	net-libs/libasyncns[${MULTILIB_USEDEP}]
	sys-apps/tcp-wrappers[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
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
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	!portable? ( >=app-misc/ca-certificates-20180226 )
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	system-freetype? ( >=media-libs/freetype-2.8.1[${MULTILIB_USEDEP}] )
	system-glew? ( >=media-libs/glew-1.13.0[${MULTILIB_USEDEP}] )
	system-libmpcdec? ( >=media-sound/musepack-tools-475[${MULTILIB_USEDEP}] )
	system-libogg? ( >=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}] )
	system-libpng? ( >=media-libs/libpng-1.6.37[${MULTILIB_USEDEP}] )
	system-libtheora? ( >=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP}] )
	system-libvorbis? ( >=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}] )
	system-libvpx? ( media-libs/libvpx[${MULTILIB_USEDEP}] )
	system-libwebp? ( >=media-libs/libwebp-1.1.0[${MULTILIB_USEDEP}] )
	system-opus? (
		>=media-libs/opus-1.1.5[${MULTILIB_USEDEP}]
		>=media-libs/opusfile-0.8[${MULTILIB_USEDEP}]
	)
	system-openssl? ( || (	>=dev-libs/openssl-1.0.2u[${MULTILIB_USEDEP}]
				>=dev-libs/openssl-compat-1.0.2u:1.0.0 ) )
	system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	system-speex? ( >=media-libs/speex-2.1_rc1[${MULTILIB_USEDEP}] )
	system-squish? ( >=media-libs/libsquish-1.15[${MULTILIB_USEDEP}] )
	system-zlib? ( >=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND_SANTIZIER="
	${CDEPEND_CLANG}
	${CDEPEND_GCC}"
BDEPEND+=" ${CDEPEND}
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
        dev-util/scons
	asan_client? (
		${BDEPEND_SANTIZIER}
	)
	asan_server? (
		${BDEPEND_SANTIZIER}
	)
	doxygen? ( app-doc/doxygen )
	lld? ( sys-devel/lld )
	lsan_client? (
		${BDEPEND_SANTIZIER}
	)
	lsan_server? (
		${BDEPEND_SANTIZIER}
	)
	web? ( app-arch/zip )"
S="${WORKDIR}/godot-${EGIT_COMMIT}"
RESTRICT="fetch mirror"

# 43757fc - 20170924 - gcc lto fix
# ec644cc - 20170926 - flto number of jobs and adds llvm+thinlto options
# a1c890a (same as above)
# 0407c2a - 20171027 - fix mingw keyerror with lto
# cefdb34 - 20171102 - lto for platform/iphone
# 9e912a4 - 20190305 - lto, ubsan/asan,lsan; debugging symbols scons options
# 919bbf8 - 20200311 - skipped but contains lto for wasm
# fd7f253 - 20190318 - lld for x11
# a76d59c (same as above)
# 51f9042 - 20190425 - thinlto for x11
# 7e65a11 (same as above)
# ec30cf0 - 20191022 - thinlto for mingw
# 20b171c - 20210309 - used for ccache

PATCHES=(
	"${FILESDIR}/godot-2.1.7_rc-43757fc.patch"
	"${FILESDIR}/godot-2.1.7_rc-ec644cc.patch"
	"${FILESDIR}/godot-2.1.7_rc-0407c2a.patch"
	"${FILESDIR}/godot-2.1.7_rc-cefdb34.patch"
	"${FILESDIR}/godot-2.1.7_rc-9e912a4-lto-only.patch"
	"${FILESDIR}/godot-2.1.7_rc-fd7f253.patch"
	"${FILESDIR}/godot-2.1.7_rc-51f9042.patch"
	"${FILESDIR}/godot-2.1.7_rc-ec30cf0.patch"
	"${FILESDIR}/godot-2.1.7_rc-20b171c.patch"
)

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
	_set_check_req
	check-reqs_pkg_pretend
}

check_android_native()
{
	if [[ -z "${ANDROID_NDK_ROOT}" ]] ; then
		ewarn \
"ANDROID_NDK_ROOT must be set as a per-package environmental variable pointing\n\
to the root of the NDK."
	fi
	if [[ -z "${ANDROID_HOME}" ]] ; then
		ewarn \
"ANDROID_HOME must be set as a per-package environmental variable pointing\n\
to the root of the SDK."
	fi
	if [[ -z "${EGODOT_ANDROID_API_LEVEL}" ]] ; then
		die \
"EGODOT_ANDROID_API_LEVEL must be set as a per-package environmental variable.\n\
See metadata.xml or \`epkginfo -x godot\` for more info."
	fi
}

check_android_sandbox()
{
	# For gradle wrapper
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES for gradle wrapper\n\
and the android USE flag."
	fi
}

check_emscripten()
{
	if [[ -z "${EMCC_WASM_BACKEND}" \
		|| ( -n "${EMCC_WASM_BACKEND}" \
			&& "${EMCC_WASM_BACKEND}" == "0" ) ]] ; then
		:;
	else
		die \
"You must switch your emscripten to asmjs followed by\n\
\`source /etc/profile\`.  See \`eselect emscripten\` for details."
	fi

	if eselect emscripten 2>/dev/null 1>/dev/null ; then
		if eselect emscripten list | grep -F -e "*" \
			| grep -q -F -e "emscripten-fastcomp" ; then
			:;
		else
			die \
"You must switch your emscripten to asmjs (with emscripten-fastcomp) followed\n\
by \`source /etc/profile\`.  See \`eselect emscripten\` for details."
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
\`eselect emscripten set <#>\` followed by \`source /etc/profile\` \
are required."
	fi
}

check_ios()
{
	if [[ -z "${IPHONEPATH}" ]] ; then
		die \
"IPHONEPATH must be set as a per-package environmental variable."
	fi
	if [[ -z "${IPHONESDK}" ]] ; then
		die \
"IPHONESDK must be set as a per-package environmental variable."
	fi

	if [[ -z "${EIOS_SDK_VERSION}" ]] ; then
		die \
"EIOS_SDK_VERSION must be defined as a per-package environmental variable.\n\
See metadata.xml or \`epkginfo -x godot\`for details."
	fi

	if [[ -z "${EXCODE_SDK_VERSION}" ]] ; then
		die \
"EXCODE_SDK_VERSION must be defined as a per-package environmental variable.\n\
See metadata.xml or \`epkginfo -x godot\`for details."
	fi
}

check_mingw()
{
	if [[ -z "${EGODOT_MINGW32_SYSROOT}" \
		&& -z "${EGODOT_MINGW64_SYSROOT}" ]] ; then
		ewarn \
"EGODOT_MINGW32_SYSROOT or EGODOT_MINGW64_SYSROOT must be specified.\n\
See metadata.xml or \`epkginfo -x godot\` for details"
	fi

	if [[ -n "${EGODOT_MINGW32_SYSROOT}" ]] ; then
		if [[ -f "${EGODOT_MINGW32_SYSROOT}/i686-w64-mingw32-gcc" ]] ; then
			die \
"${EGODOT_MINGW32_SYSROOT}/i686-w64-mingw32-gcc was not found."
		fi
	fi

	if [[ -n "${EGODOT_MINGW64_SYSROOT}" ]] ; then
		if [[ -f "${EGODOT_MINGW64_SYSROOT}/x86_64-w64-mingw32-gcc" ]] ; then
			die \
"${EGODOT_MINGW64_SYSROOT}/i686-w64-mingw32-gcc was not found."
		fi
	fi
}


check_osxcross()
{
	if [[ -z "${OSXCROSS_ROOT}" ]] ; then
		die \
"OSXCROSS_ROOT must be set as a per-package environmental variable.  See\n\
metadata.xml or \`epkginfo -x godot\` for details."
	fi
	if which xcrun ; then
		die \
"Missing xcrun from the osxcross package."
	fi
	if [[ -z "${EOSXCROSS_SDK}" ]] ; then
		die \
"EOSXCROSS_SDK must be set as a per-package environmental variable.  See\n\
metadata.xml or \`epkginfo -x godot\` for details."
	fi
	if [[ ! -f \
"${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc" \
	   ]] ; then
		die \
"Cannot find x86_64-apple-${EOSXCROSS_SDK}-cc.  Fix either OSXCROSS_ROOT \
(${OSXCROSS_ROOT}) or EOSXCROSS_SDK (${EOSXCROSS_SDK}).  Did not find \
${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc"
	fi
	if use godot_osx_x86_64 ; then
		if ver_test ${EXCODE_SDK_VERSION} \
			-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} ; then
			die \
"${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} for x86_64"
		fi
	fi
}

check_store_apl()
{
	if use godot_platforms_ios ; then
		if ver_test ${EIOS_SDK_VERSION} -lt ${IOS_SDK_MIN_STORE} ; then
			ewarn \
"Your IOS SDK does not meet minimum store requirements of\n\
>=${IOS_SDK_MIN_STORE} as of ${APST_REQ_STORE_DATE}."
		fi
	fi

	if use godot_platforms_ios || use godot_platforms_osx ; then
		if ver_test ${EXCODE_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
			ewarn \
"Your Xcode SDK does not meet minimum store requirements of\n\
>=${XCODE_SDK_MIN_STORE} as of ${APST_REQ_STORE_DATE}."
		fi
	fi
}

pkg_setup() {
	if use gdscript ; then
		ewarn \
"The gdscript USE flag is untested."
	fi
	if use godot_platforms_android ; then
		ewarn \
"The godot_platforms_android USE flag is untested.  Help test and fix."
		check_android_native
		check_android_sandbox
	fi
	if use godot_platforms_ios ; then
		ewarn \
"The godot_platforms_ios USE flag is untested.  Help test and fix."
		check_ios
		check_osxcross
	fi
	if use godot_platforms_osx ; then
		ewarn \
"The godot_platforms_osx USE flag is untested.  Help test and fix."
		check_osxcross
	fi
	if use godot_platforms_web ; then
		ewarn \
"The godot_platforms_web USE flag is a Work In Progress (WIP)."
		check_emscripten
	fi
	if use godot_platforms_windows ; then
		ewarn \
"The godot_platforms_windows USE flag is untested.  Help test and fix."
		check_mingw
	fi
	check_store_apl

	_set_check_req
	check-reqs_pkg_setup
	python_setup
	if use lto && use clang ; then
		LLVM_MAX_SLOT=${LLVM_MAX_LTO_SLOT}
		einfo "LLVM_MAX_SLOT=${LLVM_MAX_SLOT} for LTO"
		llvm_pkg_setup
	fi
}

pkg_nofetch() {
	# fetch restriction is on third party packages with all-rights-reserved in code
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"\n\
This package contains an all-rights-reserved for several third-party packages\n\
and a font is fetch restricted because the font doesn't come from the\n\
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
${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}\n\
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
${URI_PROJECT_DEMO}/tree/${EGIT_COMMIT_2_1_DEMOS_STABLE}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_EST} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_EST} \
${URI_PROJECT_DEMO}/archive/${FN_SRC_EST}\`\n\
\n"
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

	if use examples-stable ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_2_1_DEMOS_STABLE}"
	elif use examples-snapshot ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}"
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
	export EMMAKEN_CFLAGS="-c" # silence warning and build as .o files (default)
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
}

# gen_fs() and gen_fs() common options.
#	f[name] " # can only be "godot" or "godot_server"
#	f[platform] # can only be ".android", ".iphone", ".osx", ".windows", ".x11"
#	f[configuation] # can only be release = ".opt", debug = "" (default), release_debug = ".opt"
#	f[tools] # can only be ".tools" (default) or ".debug" only.
#	f[bitness] # can only be ".64" or ".32" or "" (default)
#	f[llvm] # can only be ".llvm" or "" (default)
#	f[sanitizer] # can only be ".s" or ""
# Generate filename source
gen_fs()
{
	local -n f=$1
	local fs=\
"${f[name]}${f[platform]}${f[configuation]}${f[tools]}${f[bitness]}${f[llvm]}${f[sanitizer]}"
	echo "${fs}"
}

# Generate filename destination for multislotting [aka multiple installation].
gen_fd()
{
	local -n f=$1
	local fd=\
"${f[name]}${SLOT_MAJ}${f[platform]}${f[configuation]}${f[tools]}${f[bitness]}${f[llvm]}${f[sanitizer]}"
	echo "${fd}"
}

src_compile_android()
{
	export CCACHE=${CCACHE_ANDROID}
	local options_modules_
	if [[ -n "${EGODOT_ANDROID_CONFIG}" ]] ; then
		einfo "Using config override for Android"
		einfo "${EGODOT_ANDROID_CONFIG}"
		option_modules_=(${EGODOT_ANDROID_CONFIG})
	else
		option_modules_=(${options_modules[@]})
	fi
	for a in ${GODOT_ANDROID} ; do
		if use ${a} ; then
			einfo "Creating export templates for Android (${a})"
			for c in release release_debug ; do
				scons ${options_android[@]} \
					${options_modules_[@]} \
					$([[ -z "${EGODOT_ANDROID_CONFIG}" ]] \
						&& echo ${options_modules_static[@]}) \
					$([[ ${c} == release_debug ]] \
						&& echo "debug_release=True") \
					android_arch=${a} \
					target=${c} \
					tools=no \
					|| die
			done
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
			einfo "Creating export template for iOS (${a})"
			for c in release release_debug ; do
				scons ${options_iphone[@]} \
					${options_modules_[@]} \
					$([[ -z "${EGODOT_IOS_CONFIG}" ]] \
						&& echo ${options_modules_static[@]}) \
					$([[ ${c} == release_debug ]] \
						&& echo "debug_release=True") \
					arch=${a} \
					target=${c} \
					tools=no \
					|| die
			done
		fi
	done
}

src_compile_linux()
{
	unset CCACHE
	for b in 32 64 ; do
		if [[ "${b}" == 32 ]] ; then
			! use godot_linux_x86 && continue
			einfo "Building Linux export templates for x86"
		else
			! use godot_linux_x86_64 && continue
			einfo "Building Linux export templates for x86_64"
		fi
		for c in release release_debug ; do
			scons ${options_x11[@]} \
				${options_modules[@]} \
				$([[ ${c} == release_debug ]] \
					&& echo "debug_release=True") \
				bits=${b} \
				target=${c} \
				tools=no \
				|| die
		done
	done

	if multilib_is_native_abi ; then
		einfo "Building Linux editor"
		scons ${options_x11[@]} \
			${options_modules[@]} \
			$(usex debug "debug_release=True" "") \
			$(usex debug "target=debug_release" "") \
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
		$(usex debug "debug_release=True" "")
		$(usex debug "target=debug_release" "")
	)

	if [[ "${EPLATFORM}" == "server_dedicated" ]] ; then
		einfo "Building dedicated server"
		scons ${options_server[@]} \
			${options_modules[@]} \
			${options_extra[@]} \
			tools=no \
			|| die
	fi
	if [[ "${EPLATFORM}" == "server_headless" ]] ; then
		einfo "Building editor server"
		scons ${option_server[@]} \
			${options_modules[@]} \
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
					target=${c} \
					tools=no \
					|| die
			done
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
	einfo "Creating export templates for the Web with Asm.js"
	_configure_emscripten

	for c in release release_debug ; do
		scons ${options_javascript[@]} \
			${options_modules_[@]} \
			$([[ -z "${EGODOT_WEB_CONFIG}" ]] \
				&& echo ${options_modules_static[@]}) \
			$([[ ${c} == release_debug ]] \
				&& echo "debug_release=True") \
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
		fi
	done
}

src_compile() {
	local myoptions=()
	local options_android=(
		platform=android
		ndk_platform=android-${EGODOT_ANDROID_API_LEVEL}
	)
	local options_iphone=(
		platform=iphone
		game_center=$(usex game-center)
		icloud=$(usex icloud)
		ios_sim=$(usex ios-sim)
		use_lto=$(usex lto)
		store_kit=$(usex store-kit)
	)
	local options_javascript=(
		platform=javascript
		# lto skipped
	)
	local options_osx=(
		platform=osx
		osxcross_sdk=${EOSXCROSS_SDK}
	)
	local options_server=(
		platform=server
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_leak_sanitizer=$(usex lsan_server)
		use_lto=$(usex lto)
		use_sanitizer=$(usex asan_server)
		use_thinlto=$(usex lto)
	)
	local options_windows=(
		platform=windows
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_thinlto=$(usex lto)
	)
	local options_x11=(
		platform=x11
		pulseaudio=$(usex pulseaudio)
		touch=$(usex touch)
		use_leak_sanitizer=$(usex lsan_client)
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_sanitizer=$(usex asan_client)
		use_thinlto=$(usex lto)
		udev=$(usex gamepad)
	)
	local options_modules_shared=(
		builtin_freetype=$(usex !system-freetype)
		builtin_glew=$(usex !system-glew)
		builtin_libmpcdec=$(usex !system-libmpcdec)
		builtin_libpng=$(usex !system-libpng)
		builtin_libtheora=$(usex !system-libtheora)
		builtin_libvorbis=$(usex !system-libvorbis)
		builtin_libvpx=$(usex !system-libvpx)
		builtin_libwebp=$(usex !system-libwebp)
		builtin_opus=$(usex !system-opus)
		builtin_recast=$(usex !system-recast)
		builtin_speex=$(usex !system-speex)
		builtin_squish=$(usex !system-squish)
		builtin_zlib=$(usex !system-zlib)
		use_static_cpp=$(usex portable)
	)
	local options_modules_static=(
		builtin_freetype=True
		builtin_glew=True
		builtin_libmpcdec=True
		builtin_libpng=True
		builtin_libtheora=True
		builtin_libvorbis=True
		builtin_libvpx=True
		builtin_libwebp=True
		builtin_opus=True
		builtin_recast=True
		builtin_speex=True
		builtin_squish=True
		builtin_zlib=True
		use_static_cpp=True
	)

	# The cscript is orphaned and was a rough draft.
	options_modules+=(
		disable_3d=$(usex !3d)
		disable_advanced_gui=$(usex !advanced-gui)
		minizip=$(usex minizip)
		module_bmp_enabled=$(usex bmp)
		module_chibi_enabled=$(usex mod)
		module_cscript_enabled=False
		module_dds_enabled=$(usex dds)
		module_etc1_enabled=$(usex etc1)
		module_freetype_enabled=$(usex freetype)
		module_gdscript_enabled=$(usex gdscript)
		module_gridmap_enabled=$(usex gridmap)
		module_ik_enabled=$(usex ik)
		module_jpg_enabled=$(usex jpeg)
		module_mpc_enabled=$(usex musepack)
		module_ogg_enabled=$(usex ogg)
		module_openssl_enabled=$(usex ogg)
		module_pbm_enabled=$(usex pbm)
		module_pvrtc_enabled=$(usex pvrtc)
		module_recast_enabled=$(usex recast)
		module_squish_enabled=$(usex s3tc)
		module_speex_enabled=$(usex speex)
		module_svg_enabled=$(usex svg)
		module_theora_enabled=$(usex theora)
		module_tinyexr_enabled=$(usex exr)
		module_visual_script_enabled=$(usex visual-script)
		module_vorbis_enabled=$(usex vorbis)
		module_webm_enabled=$(usex webm)
		module_webp_enabled=$(usex webp)
		xml=$(usex xml)
		${EGODOT_ADDITIONAL_CONFIG} )

	# if asan or clang, use llvm
	# if gcc 4-5, use llvm

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
		elif [[ "${EPLATFORM}" == "godot_platforms_web" ]] ; then
			# int is 32-bit in asm.js
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
	fi
}

_get_bitness() {
	[[ $(get_libdir) =~ 64 ]] && echo ".64" || echo ".32"
}

_package_web_templates()
{
	for t in debug release ; do
		if [[ ! -f bin/javascript_${t}.zip ]] ; then
			einfo "Packaging bin/javascript_${t}.zip"
			release_type=".debug"
			if [[ "${t}" == "release" ]] ; then
				release_type=""
			fi
			cp bin/godot.javascript${release_type}.opt.asm.js \
				godot.asm.js || die
			cp bin/godot.javascript${release_type}.opt.js       \
				godot.js || die
			cp bin/godot.javascript${release_type}.opt.html.mem \
				godot.mem || die
			cp tools/dist/html_fs/godot.html . || die
			cp tools/dist/html_fs/godotfs.js . || die
			zip bin/javascript_${t}.zip godot.asm.js \
				godot.js godot.mem godotfs.js godot.html || die
		fi
	done
}

_get_d_base()
{
	echo "/usr/$(get_libdir)/${PN}${SLOT_MAJ}/${platform}"
}

_install_linux_editor_or_server() {
	local -n t=$1
	local fs=$(gen_fs t)
	local fd=$(gen_fd t)
	local d_base=$(_get_d_base)
	exeinto "${d_base}/bin"
	mv bin/${fs} bin/${fd} || die
	doexe bin/${fd}
	if [[ "${EPLATFORM}" == "server_dedicated" \
		|| "${EPLATFORM}" == "server_headless" ]] ; then
		dosym "${d_base}/bin/${fd}" "/usr/bin/${t[dname]}${SLOT_MAJ}-${ABI}"
	else
		dosym "${d_base}/bin/${fd}" "/usr/bin/${t[dname]}${SLOT_MAJ}"
	fi
}

src_install_android()
{
	einfo "Installing export templates for Android"
	insinto /usr/share/godot/${SLOT_MAJ}/android/templates
	doins bin/android_{release,debug}.apk
	local pv=$(ver_cut 1-3 ${PV}).${STATUS}
	echo "${pv}.${STATUS}" > "${T}/version.txt" || die
	doins "${T}/version.txt"
}

src_install_demos()
{
	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	if use examples-snapshot || use examples-stable ; then
		einfo "Installing demos"
		doins -r "${S_DEMOS}"/*
	fi
}

src_install_linux()
{
	local bitness=$(_get_bitness)
	bitness=${bitness//./}
	exeinto /usr/share/godot/${SLOT_MAJ}/${EPLATFORM//godot_platforms_/}/templates
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
}

src_install_linux_server()
{
	local bitness=$(_get_bitness)
	bitness=${bitness//./}
	insinto /usr/share/godot/${SLOT_MAJ}/${EPLATFORM//godot_platforms_/}/templates
	einfo "Installing export templates for ${EPLATFORM//godot_platforms_/}"
	doins bin/linux_server_${bitness}
}

src_install_web()
{
	einfo "Installing export templates for Web"
	_package_web_templates
	insinto /usr/share/godot/${SLOT_MAJ}/web/templates
	doins bin/javascript_{release,debug}.zip
}

src_install() {
	godot_install_impl() {
		if [[ "${EPLATFORM}" == "godot_platforms_linux"
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
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] ; then
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
				  || "${EPLATFORM}" == "server_headless" ]] ; then
					e["tools"]=".tools"
				fi
				e["bitness"]=$(_get_bitness)
				e["llvm"]=$(usex clang ".llvm" "")
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] \
					&& (use asan_client || use lsan_client); then
					e["sanitizer"]=".s"
				elif [[ "${EPLATFORM}" == "server" ]] \
					&& (use asan_server || use lsan_server); then
					e["sanitizer"]=".s"
				else
					e["sanitizer"]=""
				fi
				if [[ "${EPLATFORM}" == "godot_platforms_linux" ]] \
					&& ! multilib_is_native_abi ; then
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
	einfo "2.1.x branch is still supported partially upstream as of 2021."
	einfo "It's recommended to use 3.x instead."
	einfo
	einfo "For details see:"
	einfo "https://docs.godotengine.org/en/stable/about/release_policy.html"

	for p in ${EPLATFORMS} ; do
		if use ${p} ; then
			einfo \
"You need to copy the ${p} templates from /usr/share/godot/${SLOT_MAJ}/${p}/templates\n\
to ~/.local/share/godot/templates or \${XDG_DATA_HOME}/godot/templates"
		fi
	done

	if use web ; then
		einfo \
"asmjs is deprecated and used as the default for 2.1.x.  Use WASM found on\n\
the >=3.2 branch."
	fi
}
