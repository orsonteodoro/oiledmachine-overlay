# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

STATUS="rc"

PYTHON_COMPAT=( python3_{6..9} )
inherit check-reqs desktop eutils godot multilib-build python-single-r1 \
scons-utils toolchain-funcs

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

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
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
IUSE+=" +3d +advanced-gui clang debug docs examples-snapshot examples-stable \
javascript lto portable sanitizer server +X"
IUSE+=" +bmp +dds +exr +etc1 +minizip +musepack +pbm +jpeg +mod +ogg +pvrtc \
+svg +s3tc +speex +theora +vorbis +webm +webp +xml" # formats formats
IUSE+=" cpp +gdscript +visual-script" # for scripting languages
IUSE+=" +gridmap +ik +recast" # for 3d
IUSE+=" +openssl" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +freetype +pcre2 +pulseaudio +speex" # for libraries
IUSE+=" system-freetype system-glew system-libmpcdec system-libogg \
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp \
system-openssl system-opus system-pcre2 system-recast system-speex \
system-squish system-zlib"
IUSE+=" android"
IUSE+=" doxygen"

# See https://github.com/godotengine/godot/tree/2.1/thirdparty for versioning
# See https://docs.godotengine.org/en/2.1/development/compiling/compiling_for_android.html
# See https://docs.godotengine.org/en/2.1/development/compiling/compiling_for_web.html
# Some are repeated because they were shown to be in the ldd list
LIBOGG_V="1.3.3"
LIBVORBIS_V="1.3.6"
DEPEND+=" ${PYTHON_DEPS}
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
	android? (
		dev-util/android-sdk-update-manager
		>=dev-util/android-ndk-17
		dev-java/gradle-bin
		dev-java/openjdk:8
	)
	cpp? ( dev-util/scons
		|| ( sys-devel/clang[${MULTILIB_USEDEP}]
		   <sys-devel/gcc-6.0 ) )
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	javascript? (
		<dev-util/emscripten-2[asmjs]
	)
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
	system-pcre2? ( dev-libs/libpcre2[${MULTILIB_USEDEP}] )
	system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	system-speex? ( >=media-libs/speex-2.1_rc1[${MULTILIB_USEDEP}] )
	system-squish? ( >=media-libs/libsquish-1.15[${MULTILIB_USEDEP}] )
	system-zlib? ( >=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" || ( sys-devel/clang[${MULTILIB_USEDEP}]
	     <sys-devel/gcc-6.0 )
         dev-util/scons
         virtual/pkgconfig[${MULTILIB_USEDEP}]
	 clang? ( sys-devel/clang[${MULTILIB_USEDEP}] )
	 doxygen? ( app-doc/doxygen )
	 javascript? ( app-arch/zip )
	 sanitizer? ( sys-devel/clang[${MULTILIB_USEDEP}] )"
S="${WORKDIR}/godot-${EGIT_COMMIT}"
RESTRICT="fetch mirror"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	|| ( server X )
	docs? ( doxygen )
	doxygen? ( docs )
	examples-snapshot? ( !examples-stable )
	examples-stable? ( !examples-snapshot )
	portable? (
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
		!system-pcre2
		!system-recast
		!system-speex
		!system-squish
		!system-zlib
	)"

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
	_set_check_req
	check-reqs_pkg_pretend
}

_check_emscripten()
{
	if [[ -z "${EMCC_WASM_BACKEND}" \
		|| ( -n "${EMCC_WASM_BACKEND}" \
			&& "${EMCC_WASM_BACKEND}" == "0" ) ]] ; then
		:;
	else
		die \
"You must switch your emscripten to asmjs.  See \`eselect emscripten\` for \
details."
	fi

	if eselect emscripten 2>/dev/null 1>/dev/null ; then
		if eselect emscripten list | grep -F -e "*" \
			| grep -q -F -e "emscripten-fastcomp" ; then
			:;
		else
			die \
"You must switch your emscripten to asmjs (with emscripten-fastcomp).  \n\
See \`eselect emscripten\` for details."
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
	if use gdscript ; then
		ewarn "The gdscript USE flag is untested."
	fi
	if use javascript ; then
		ewarn \
"The javascript USE flag is untested and possibly unfinished on the ebuild level."
		_check_emscripten
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

	if use examples-stable ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_2_1_DEMOS_STABLE}"
	elif use examples-snapshot ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}"
	fi

	multilib_copy_sources

	multilib_prepare_impl() {
		cd "${BUILD_DIR}" || die
		S="${BUILD_DIR}" \
		godot_copy_sources
	}
	multilib_foreach_abi multilib_prepare_impl
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
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

			myoptions+=(
				debug_symbols=$(usex debug)
				disable_3d=$(usex !3d)
				disable_advanced_gui=$(usex !advanced-gui)
				builtin_freetype=$(usex !system-freetype)
				builtin_glew=$(usex !system-glew)
				builtin_libmpcdec=$(usex !system-libmpcdec)
				builtin_libpng=$(usex !system-libpng)
				builtin_libtheora=$(usex !system-libtheora)
				builtin_libvorbis=$(usex !system-libvorbis)
				builtin_libvpx=$(usex !system-libvpx)
				builtin_libwebp=$(usex !system-libwebp)
				builtin_pcre2=$(usex !system-pcre2)
				builtin_opus=$(usex !system-opus)
				builtin_recast=$(usex !system-recast)
				builtin_speex=$(usex !system-speex)
				builtin_squish=$(usex !system-squish)
				builtin_zlib=$(usex !system-zlib)
				minizip=$(usex minizip)
				module_bmp_enabled=$(usex bmp)
				module_chibi_enabled=$(usex mod)
				module_cscript_enabled=$(usex cpp)
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
				module_regex_enabled=$(usex pcre2)
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
				pulseaudio=$(usex pulseaudio)
			        target=$(usex debug "debug" "release_debug")
				touch=$(usex touch)
				udev=$(usex gamepad)
				use_leak_sanitizer=$(usex sanitizer)
				use_lto=$(usex lto)
				use_sanitizer=$(usex sanitizer)
				use_static_cpp=$(usex portable)
				xml=$(usex xml) )

			if use android \
				&& [[ "${EGODOT}" == "X" ]] ; then
				einfo "Creating export templates for Android"
				export TERM=linux # pretend to be outside of X
				for aa in ${EGODOT_ANDROID_ARCHES[@]} ; do
					scons platform=android target=release android_arch=${aa} || die
					scons platform=android target=release_debug android_arch=${aa} || die
				done
				pushd platform/android/java || die
					gradle_cmd=$(find /usr/bin/ \
						-regextype posix-extended \
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
					${myoptions[@]} \
					tools=no \
					target=release
				scons platform=javascript \
					${myoptions[@]} \
					tools=no \
					target=release_debug
			fi

			if use sanitizer || use clang ; then
				myoptions+=( use_llvm=yes )
				export _LLVM=".llvm"
			elif tc-is-gcc; then
				find /usr/*/gcc-bin/[4-5].[0-9.]*/gcc \
					2> /dev/null
				if [[ "$?" != "0" ]] ; then
					einfo "Using clang"
					myoptions+=( use_llvm=yes )
					export _LLVM=".llvm"
				fi
			fi

			scons platform=$(_use_flag_to_platform "${EGODOT}") \
				${myoptions[@]} \
				"CFLAGS=${CFLAGS}" \
				"CCFLAGS=${CXXFLAGS}" \
				"LINKFLAGS=${LDFLAGS}" || die
		}
		godot_foreach_impl godot_compile_impl
	}
	multilib_foreach_abi multilib_compile_impl

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

_copy_impl() {
	local type1="${1}" # can only be x11 or server
	local type2
	if [[ "${type1}" == "server" ]] ; then
		type2="godot_server"
	else
		type2="godot"
	fi
	local tools=".tools" # can only be .tools or .debug only.
				# based on the tools option
	local fs=\
"${type2}.${type1}${target}${tools}${bitness}${llvm}${sanitizer}"
	local fd=\
"${type2}${SLOT_MAJ}.${type1}${target}${tools}${bitness}${llvm}${sanitizer}"
	mv bin/${fs} bin/${fd} || die
	local d_base="/usr/$(get_libdir)/${PN}${SLOT_MAJ}/${type1}"
	exeinto "${d_base}/bin"
	doexe bin/${fd}
	dosym "${d_base}/bin/${fd}" /usr/bin/${type2}${SLOT_MAJ}-${ABI}
}

_package_js_templates()
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
			zip bin/javascript_${release_type}.zip godot.asm.js \
				godot.js godot.mem godotfs.js godot.html || die
		fi
	done
}

src_install() {
	multilib_install_impl() {
		cd "${BUILD_DIR}" || die
		godot_install_impl() {
			local bitness=$(_get_bitness)
			local target=$(usex debug "" ".opt")
			local llvm="${_LLVM}"
			if [[ "${EGODOT}" == "server" ]] ; then
				llvm=""
			fi
			local sanitizer=$(usex sanitizer "s" "")

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
				local pv=$(ver_cut 1-3 ${PV}).${STATUS}
				echo "${pv}.${STATUS}" > "${T}/version.txt" || die
				doins "${T}/version.txt"
			fi
			if use javascript \
				&& [[ "${EGODOT}" == "X" ]] ; then
				_package_js_templates
				insinto /usr/share/godot/${SLOT_MAJ}/javascript/templates
				doins bin/javascript_{release,debug}.zip
			fi
		}

		godot_foreach_impl godot_install_impl
	}

	multilib_foreach_abi multilib_install_impl

	insinto /usr/share/godot${SLOT_MAJ}/godot-demo-projects
	if use examples-snapshot || use examples-stable ; then
		doins -r "${S_DEMOS}"/*
	fi

	newicon icon.png godot${SLOT_MAJ}.png
}

pkg_postinst() {
	einfo "2.1.x branch is still supported partially upstream as of 2021."
	einfo "It's recommended to use 3.x instead."
	einfo
	einfo "For details see:"
	einfo "https://docs.godotengine.org/en/stable/about/release_policy.html"

	if use javascript ; then
		einfo \
"asmjs is deprecated and used as the default for 2.1.x.  Use WASM found on\n\
the >=3.2 branch."
	fi

	if use android ; then
		local pv=$(ver_cut 1-3 ${PV}).${STATUS}
		einfo \
"You need to copy the Android templates to ~/.local/share/godot/templates \
or \${XDG_DATA_HOME}/godot/templates"
		einfo "from /usr/share/godot/${SLOT_MAJ}/android/templates/*"
	fi

	if use javascript ; then
		einfo \
"You need to copy the JavaScript templates to ~/.local/share/godot/templates \
or \${XDG_DATA_HOME}/godot/templates"
		einfo "from /usr/share/godot/${SLOT_MAJ}/javascript/templates/*"
	fi
}
