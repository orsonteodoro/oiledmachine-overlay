# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
URI_DL="${URI_PROJECT}/tree/${EGIT_COMMIT}"
URI_A="${URI_PROJECT}/archive/${EGIT_COMMIT}.zip"
SRC_URI="${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST} 
examples-snapshot? (
  ${URI_ORG}/godot-demo-projects/archive/${FN_SRC_ESN} \
		-> ${FN_DEST_ESN}
)
examples-stable? (
  ${URI_ORG}/godot-demo-projects/archive/${FN_SRC_EST} \
		-> ${FN_DEST_EST}
)"
SLOT="2/${PV}"
IUSE+=" +3d +advanced-gui clang debug docs examples-snapshot examples-stable \
lto portable sanitizer server +X"
IUSE+=" +bmp +dds +exr +etc1 +minizip +musepack +pbm +jpeg +mod +ogg +pvrtc \
+svg +s3tc +speex +theora +vorbis +webm +webp +xml" # formats formats
IUSE+=" cpp +gdscript +visual-script" # for scripting languages
IUSE+=" +gridmap +ik +recast" # for 3d
IUSE+=" +openssl" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +freetype +pcre2 +opensimplex +pulseaudio" # for libraries
IUSE+=" system-freetype system-glew system-libmpcdec system-libogg \
system-libpng system-libtheora system-libvorbis system-libvpx system-openssl \
system-opus system-pcre2 system-recast system-speex system-squish system-zlib"
IUSE+=" android"
IUSE+=" doxygen"
DEPEND+=" ${PYTHON_DEPS}
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
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
	android? ( dev-util/android-sdk-update-manager )
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	cpp? ( dev-util/scons
		|| ( sys-devel/clang[${MULTILIB_USEDEP}]
		   <sys-devel/gcc-6.0 ) )
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
	system-zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" || ( sys-devel/clang[${MULTILIB_USEDEP}]
	     <sys-devel/gcc-6.0 )
         dev-util/scons
         virtual/pkgconfig[${MULTILIB_USEDEP}]
	 clang? ( sys-devel/clang[${MULTILIB_USEDEP}] )
	 doxygen? ( app-doc/doxygen )
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

pkg_setup() {
	if use android ; then
		ewarn "The android USE flag is untested."
	fi
	if use cpp ; then
		ewarn "The cpp USE flag is untested."
	fi
	if use gdscript ; then
		ewarn "The gdscript USE flag is untested."
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
				module_ik_enabled=$(usex ik)
				module_jpg_enabled=$(usex jpeg)
				module_mpc_enabled=$(usex musepack)
				module_ogg_enabled=$(usex ogg)
				module_opensimplex_enabled=$(usex opensimplex)
				module_openssl_enabled=$(usex ogg)
				module_pbm_enabled=$(usex pbm)
				module_pvrtc_enabled=$(usex pvrtc)
				module_regex_enabled=$(usex pcre2)
				module_recast_enabled=$(usex recast)
				module_squish_enabled=$(usex s3tc)
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
"${type2}${SLOT}.${type1}${target}${tools}${bitness}${llvm}${sanitizer}"
	mv bin/${fs} bin/${fd} || die
	local d_base="/usr/$(get_libdir)/${PN}${SLOT}/${type1}"
	exeinto "${d_base}/bin"
	doexe bin/${fd}
	dosym "${d_base}/bin/${fd}" /usr/bin/${type2}${SLOT}-${ABI}
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
				cat "${FILESDIR}/godot${SLOT}-custom-module.pc.in" \
					| sed -e "s|@prefix@|/usr|g" \
					       -e "s|@exec_prefix@|\${prefix}|g" \
					       -e "s|@libdir@|/usr/$(get_libdir)|g" \
					       -e "s|@version@|${PV}|g" \
						> "${T}/godot${SLOT}-custom-module.pc" \
						|| die
				doins "${T}/godot${SLOT}-custom-module.pc"

				insinto /usr/include/${PN}${SLOT}-cpp
				doins -r "${S}"/core "${S}"/drivers
				insinto /usr/include/${PN}${SLOT}-cpp/platform
				if use X && [[ "${EGODOT}" == "X" ]] ; then
					doins -r "${S}"/platform/x11
				fi
				if use server \
					&& [[ "${EGODOT}" == "server" ]] ; then
					doins -r "${S}"/platform/server
				fi
			fi
			make_desktop_entry \
				"/usr/bin/godot${SLOT}-${ABI}" \
				"Godot${SLOT} (${ABI})" \
				"/usr/share/pixmaps/godot${SLOT}.png" \
				"Development;IDE"
		}

		godot_foreach_impl godot_install_impl
	}

	multilib_foreach_abi multilib_install_impl

	insinto /usr/share/godot${SLOT}/godot-demo-projects
	if use examples-snapshot || use examples-stable ; then
		doins -r "${S_DEMOS}"/*
	fi

	newicon icon.png godot${SLOT}.png
}

pkg_postinst() {
	einfo "2.1.x branch is still supported partially upstream as of 2021."
	einfo "It's recommended to use 3.x instead."
	einfo
	einfo "For details see:"
	einfo "https://docs.godotengine.org/en/stable/about/release_policy.html"
}
