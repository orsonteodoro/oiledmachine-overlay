# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit check-reqs desktop eutils godot multilib-build python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="all-rights-reserved Apache-2.0 BSD BSD-2 CC-BY-3.0 FTL ISC MIT MPL-2.0 OFL-1.1 openssl RSA Unlicense ZLIB"
# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # The MIT license does not have all rights reserved but the source does
# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # libpng license does not contain all rights reserved, but this source does
# thirdparty/fonts/DroidSans*.ttf - Apache-2.0
# thirdparty/fonts/source_code_pro.otf - all-rights-reserved OFL-1.1 # The original OFL-1.1 does not contain all rights reserved but stated in LICENSE.SourceCodePro.txt
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
PND="${PN}-demo-projects"
EGIT_COMMIT_2_1_DEMOS_SNAPSHOT="7dec39be19f9d8b486a5d4a1dae24e1fb9c848e6" # tag 2.1 deterministic / static snapshot / 2.1 branch / 20200203
EGIT_COMMIT_2_1_DEMOS_STABLE="5fe6147a345a9fa75d94cfb84c1bb5221645160c" # 2.1 stable
EGIT_COMMIT="89e531d223ef189219e266cc61ea79a7dd2d5f54"
FN_SRC="${EGIT_COMMIT}.zip"
FN_DEST="${P}.zip"
FN_SRC_ESN="${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}.zip" # examples snapshot
FN_DEST_ESN="${PND}-${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}.zip"
FN_SRC_EST="${EGIT_COMMIT_2_1_DEMOS_STABLE}.zip" # examples stable
FN_DEST_EST="${PND}-${EGIT_COMMIT_2_1_DEMOS_STABLE}.zip"
A_URL="https://github.com/godotengine/godot/tree/${EGIT_COMMIT}"
A_URL2="https://github.com/godotengine/godot/archive/${EGIT_COMMIT}.zip"
SRC_URI="https://github.com/godotengine/godot/archive/${FN_SRC} -> ${FN_DEST}
	 examples-snapshot? ( https://github.com/godotengine/godot-demo-projects/archive/${FN_SRC_ESN} -> ${FN_DEST_ESN} )
	 examples-stable? ( https://github.com/godotengine/godot-demo-projects/archive/${FN_SRC_EST} -> ${FN_DEST_EST} )"
SLOT="2"
IUSE="+3d +advanced-gui clang debug docs examples-snapshot examples-stable lto portable sanitizer server +X"
IUSE+=" +bmp +dds +exr +etc1 +minizip +musepack +pbm +jpeg +mod +ogg +pvrtc +svg +s3tc +speex +theora +vorbis +webm +webp +xml" # formats formats
IUSE+=" cpp +gdscript +visual-script" # for scripting languages
IUSE+=" +gridmap +ik +recast" # for 3d
IUSE+=" +openssl" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +freetype +pcre2 +opensimplex +pulseaudio" # for libraries
IUSE+=" system-freetype system-glew system-libmpcdec system-libogg system-libpng system-libtheora system-libvorbis system-libvpx system-openssl system-opus system-pcre2 system-recast system-speex system-squish system-zlib"
IUSE+=" android"
IUSE+=" doxygen"
RDEPEND="android? ( dev-util/android-sdk-update-manager )
	 cpp? ( dev-util/scons
		|| ( sys-devel/clang[${MULTILIB_USEDEP}]
		   <sys-devel/gcc-6.0 ) )
	 dev-libs/libbsd[${MULTILIB_USEDEP}]
         gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	 media-libs/alsa-lib[${MULTILIB_USEDEP}]
	 media-libs/flac[${MULTILIB_USEDEP}]
	 media-libs/libogg[${MULTILIB_USEDEP}]
	 media-libs/libsndfile[${MULTILIB_USEDEP}]
	 media-libs/libvorbis[${MULTILIB_USEDEP}]
         media-sound/pulseaudio[${MULTILIB_USEDEP}]
	 net-libs/libasyncns[${MULTILIB_USEDEP}]
	 ${PYTHON_DEPS}
	 sys-apps/tcp-wrappers[${MULTILIB_USEDEP}]
	 sys-apps/util-linux[${MULTILIB_USEDEP}]
         system-freetype? ( media-libs/freetype[${MULTILIB_USEDEP}] )
	 system-glew? ( media-libs/glew[${MULTILIB_USEDEP}] )
	 system-libmpcdec? ( media-sound/musepack-tools[${MULTILIB_USEDEP}] )
	 system-libogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )
	 system-libpng? ( media-libs/libpng[${MULTILIB_USEDEP}] )
	 system-libtheora? ( media-libs/libtheora[${MULTILIB_USEDEP}] )
	 system-libvorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	 system-libvpx? ( media-libs/libvpx[${MULTILIB_USEDEP}] )
	 system-opus? ( media-libs/opus[${MULTILIB_USEDEP}] )
	 system-openssl? ( dev-libs/openssl[${MULTILIB_USEDEP}] )
	 system-pcre2? ( dev-libs/libpcre2[${MULTILIB_USEDEP}] )
	 system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	 system-squish? ( media-libs/libsquish[${MULTILIB_USEDEP}] )
	 system-zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
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
	 x11-libs/libxshmfence[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	 clang? ( sys-devel/clang[${MULTILIB_USEDEP}] )
         dev-util/scons
	 doxygen? ( app-doc/doxygen )
	 sanitizer? ( sys-devel/clang[${MULTILIB_USEDEP}] )
	 || ( sys-devel/clang[${MULTILIB_USEDEP}]
	     <sys-devel/gcc-6.0 )
         virtual/pkgconfig[${MULTILIB_USEDEP}]"
S="${WORKDIR}/godot-${EGIT_COMMIT}"
RESTRICT="fetch mirror"
REQUIRED_USE="doxygen? ( docs )
	      docs? ( doxygen )
	      examples-snapshot? ( !examples-stable )
	      examples-stable? ( !examples-snapshot )
	      portable? ( !system-freetype !system-glew !system-libmpcdec !system-libogg !system-libpng !system-libtheora !system-libvorbis !system-libvpx !system-openssl !system-opus !system-pcre2 !system-recast !system-speex !system-squish !system-zlib )
	      ${PYTHON_REQUIRED_USE}
	      || ( server X )"

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

pkg_setup() {
	ewarn "Ebuild is still Work In Progress (WIP) or in development and may not work."
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
${A_URL}\n\
\n\
at the green download button and rename it to ${FN_DEST} and place them in\n\
${distdir} or you can \`wget -O ${distdir}/${FN_DEST} ${A_URL2}\`\n\
\n"
	if use examples-snapshot ; then
		einfo \
"\n\
You also need to obtain the godot-demo-projects snapshot tarball from\n\
https://github.com/godotengine/godot-demo-projects/tree/${EGIT_COMMIT_2_1_DEMOS_SNAPSHOT}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_ESN} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_ESN} \
https://github.com/godotengine/godot-demo-projects/archive/${FN_SRC_ESN}\`\n\
\n"
	fi
	if use examples-stable ; then
		einfo \
"\n\
You also need to obtain the godot-demo-projects stable tarball from\n\
https://github.com/godotengine/godot-demo-projects/tree/${EGIT_COMMIT_2_1_DEMOS_STABLE}\n\
through the green button > download ZIP and place it in ${distdir} as\n\
${FN_DEST_EST} or you can copy and paste the\n\
below command \`wget -O ${distdir}/${FN_DEST_EST} \
https://github.com/godotengine/godot-demo-projects/archive/${FN_SRC_EST}\`\n\
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
		cd "${BUILD_DIR}"
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
		server) echo "server" ;;
	esac
}

src_compile() {
	multilib_compile_impl() {
		cd "${BUILD_DIR}"
		godot_compile_impl() {
			local myoptions=()

			if [[ "$(get_libdir)" =~ 64 ]] ; then
				myoptions+=( bits=64 )
			else
				myoptions+=( bits=32 )
			fi

			myoptions+=(
				debug_symbols=$(usex debug "yes" "no") \
				disable_3d=$(usex 3d "no" "yes") \
				disable_advanced_gui=$(usex advanced-gui "no" "yes") \
				builtin_freetype=$(usex system-freetype "no" "yes") \
				builtin_glew=$(usex system-glew "no" "yes") \
				builtin_libmpcdec=$(usex system-libmpcdec "no" "yes") \
				builtin_libpng=$(usex system-libpng "no" "yes") \
				builtin_libtheora=$(usex system-libtheora "no" "yes") \
				builtin_libvorbis=$(usex system-libvorbis "no" "yes") \
				builtin_libvpx=$(usex system-libvpx "no" "yes") \
				builtin_pcre2=$(usex system-pcre2 "no" "yes") \
				builtin_opus=$(usex system-opus "no" "yes") \
				builtin_recast=$(usex system-recast "no" "yes") \
				builtin_speex=$(usex system-speex "no" "yes") \
				builtin_squish=$(usex system-squish "no" "yes") \
				builtin_zlib=$(usex system-zlib "no" "yes") \
				minizip=$(usex minizip "yes" "no") \
				module_bmp_enabled=$(usex bmp "yes" "no") \
				module_chibi_enabled=$(usex mod "yes" "no") \
				module_cscript_enabled=$(usex cpp "yes" "no") \
				module_dds_enabled=$(usex dds "yes" "no") \
				module_etc1_enabled=$(usex etc1 "yes" "no") \
				module_freetype_enabled=$(usex freetype "yes" "no") \
				module_gdscript_enabled=$(usex gdscript "yes" "no") \
				module_ik_enabled=$(usex ik "yes" "no") \
				module_jpg_enabled=$(usex jpeg "yes" "no") \
				module_mpc_enabled=$(usex musepack "yes" "no") \
				module_ogg_enabled=$(usex ogg "yes" "no") \
				module_opensimplex_enabled=$(usex opensimplex "yes" "no") \
				module_openssl_enabled=$(usex ogg "yes" "no") \
				module_pbm_enabled=$(usex pbm "yes" "no") \
				module_pvrtc_enabled=$(usex pvrtc "yes" "no") \
				module_regex_enabled=$(usex pcre2 "yes" "no") \
				module_recast_enabled=$(usex recast "yes" "no") \
				module_squish_enabled=$(usex s3tc "yes" "no") \
				module_svg_enabled=$(usex svg "yes" "no") \
				module_theora_enabled=$(usex theora "yes" "no") \
				module_tinyexr_enabled=$(usex exr "yes" "no") \
				module_visual_script_enabled=$(usex visual-script "yes" "no") \
				module_vorbis_enabled=$(usex vorbis "yes" "no") \
				module_webm_enabled=$(usex webm "yes" "no") \
				module_webp_enabled=$(usex webp "yes" "no") \
				pulseaudio=$(usex pulseaudio "yes" "no") \
			        target=$(usex debug "debug" "release_debug") \
				touch=$(usex touch "yes" "no") \
				udev=$(usex gamepad "yes" "no") \
				use_leak_sanitizer=$(usex sanitizer "yes" "no") \
				use_lto=$(usex lto "yes" "no") \
				use_sanitizer=$(usex sanitizer "yes" "no") \
				use_static_cpp=$(usex portable "yes" "no") \
				xml=$(usex xml "yes" "no") )

			if use sanitizer || use clang ; then
				myoptions+=( use_llvm=yes )
				export _LLVM=".llvm"
			elif tc-is-gcc; then
				find /usr/*/gcc-bin/[4-5].[0-9.]*/gcc 2> /dev/null
				if [[ "$?" != "0" ]] ; then
					einfo "Using clang"
					myoptions+=( use_llvm=yes )
					export _LLVM=".llvm"
				fi
			fi

			scons platform=$(_use_flag_to_platform "${EGODOT}") ${myoptions[@]} "CFLAGS=${CFLAGS}" "CCFLAGS=${CXXFLAGS}" "LINKFLAGS=${LDFLAGS}" || die
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
	local tools=".tools" # can only be .tools or .debug only.  based on the tools option
	local fs="${type2}.${type1}${target}${tools}${bitness}${llvm}${sanitizer}"
	local fd="${type2}${SLOT}.${type1}${target}${tools}${bitness}${llvm}${sanitizer}"
	cp bin/${fs} bin/${fd} || die
	local d_base="/usr/$(get_libdir)/${PN}${SLOT}/${type1}"
	exeinto "${d_base}/bin"
	doexe bin/${fd}
	dosym "${d_base}/${fd}" /usr/bin/${type2}${SLOT}-${ABI}
}

src_install() {
	multilib_install_impl() {
		cd "${BUILD_DIR}"
		godot_install_impl() {
			local bitness=$(_get_bitness)
			local target=$(usex debug "" ".opt")
			local llvm="${LLVM}"
			local sanitizer=$(usex sanitizer "s" "")

			_copy_impl $(_use_flag_to_platform "${EGODOT}")

			if use cpp ; then
				insinto /usr/$(get_libdir)/pkgconfig
				cat "${FILESDIR}/godot${SLOT}-custom-module.pc.in" | \
					sed -e "s|@prefix@|/usr|g" \
					       -e "s|@exec_prefix@|\${prefix}|g" \
					       -e "s|@libdir@|/usr/$(get_libdir)|g" \
					       -e "s|@version@|${PV}|g" \
						> "${T}/godot${SLOT}-custom-module.pc" || die
				doins "${T}/godot${SLOT}-custom-module.pc"

				insinto /usr/include/${PN}${SLOT}-cpp
				doins -r "${S}"/core "${S}"/drivers
				insinto /usr/include/${PN}${SLOT}-cpp/platform
				if use X ; then
					doins -r "${S}"/platform/x11
				fi
				if use server ; then
					doins -r "${S}"/platform/server
				fi
			fi
			make_desktop_entry "/usr/bin/godot${SLOT}-${ABI}" "Godot${SLOT} (${ABI})" "/usr/share/pixmaps/godot${SLOT}.png" "Development;IDE"
		}

		godot_foreach_impl godot_install_impl
	}

	multilib_foreach_abi multilib_install_impl

	insinto /usr/share/godot${SLOT}
	if use examples-snapshot || use examples-stable ; then
		doins -r "${S_DEMOS}"/*
	fi

	newicon icon.png godot${SLOT}.png
}
