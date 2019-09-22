# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit check-reqs desktop eutils godot multilib-build python-r1 scons-utils

DESCRIPTION="Godot Engine - Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="Apache-2.0 BitstreamVera BSD CC-BY-3.0 FTL ISC LGPL-2.1 MIT MPL-2.0 OFL-1.1 openssl Unlicense ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
PND="${PN}-demo-projects"
EGIT_COMMIT_3_DEMOS_SNAPSHOT="e113915c80ff1cb73942dc0294ee9290e6f566f4" # tag 3 deterministic / static snapshot
EGIT_COMMIT_3_DEMOS_STABLE="d69cc10a0b8a0ed402b377ba99725af85eff48d5" # latest release
EGIT_COMMIT_GODOT_CPP_SNAPSHOT="c2ec46f64a24de9a46b06c3e987c306f549ccadb" # 20190805
SRC_URI="https://github.com/godotengine/godot/archive/${PV}-stable.tar.gz -> ${P}.tar.gz
	 examples-snapshot? ( https://github.com/godotengine/godot-demo-projects/archive/${EGIT_COMMIT_3_DEMOS_SNAPSHOT}.tar.gz -> ${PND}-${EGIT_COMMIT_3_DEMOS_SNAPSHOT}.tar.gz )
	 examples-stable? ( https://github.com/godotengine/godot-demo-projects/archive/${EGIT_COMMIT_3_DEMOS_STABLE}.tar.gz -> ${PND}-${EGIT_COMMIT_3_DEMOS_STABLE}.tar.gz )
	 gdnative? ( https://github.com/GodotNativeTools/godot-cpp/archive/${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}.tar.gz -> godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}.tar.gz
		     https://github.com/godotengine/godot/commit/d0f2b5c8abe128c16c5ae6f5ab76f046686aa041.patch -> godot-issue-28084-bind-AudioEffectSpectrumAnalyzer-FFT_Size-enums.patch
		     https://github.com/godotengine/godot/commit/2da83a278b80a59076186cd46898d2baa597a1d2.patch -> godot-mono-add-missing-godottools-sln.patch )"
SLOT="3"
IUSE="+3d +advanced-gui clang debug docs examples-snapshot examples-stable examples-live lto +optimize-speed optimize-size portable sanitizer server +X"
IUSE+=" +bmp +etc +exr +hdr +jpeg +minizip +ogg +pvrtc +svg +s3tc +theora +tga +vorbis +webm +webp" # formats formats
IUSE+=" +cpp +gdnative +gdscript -mono +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +mobile-vr +recast +xatlas" # for 3d
IUSE+=" +enet +mbedtls +upnp +websocket" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
IUSE+=" system-bullet system-enet system-freetype system-libogg system-libpng system-libtheora system-libvorbis system-libvpx system-libwebsockets system-mbedtls system-miniupnpc system-opus system-pcre2 system-recast system-speex system-squish system-xatlas system-zlib system-zstd"
IUSE+=" android"
# media-libs/xatlas is a placeholder
RDEPEND="android? ( dev-util/android-sdk-update-manager )
	 app-arch/bzip2[${MULTILIB_USEDEP}]
	 dev-libs/libbsd[${MULTILIB_USEDEP}]
         gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	 gdnative? ( dev-util/scons
		     || ( sys-devel/clang[${MULTILIB_USEDEP}]
	                  sys-devel/gcc ) )
	 media-libs/alsa-lib[${MULTILIB_USEDEP}]
	 media-libs/flac[${MULTILIB_USEDEP}]
         media-libs/freetype[${MULTILIB_USEDEP}]
	 media-libs/libogg[${MULTILIB_USEDEP}]
	 media-libs/libpng[${MULTILIB_USEDEP}]
	 media-libs/libsndfile[${MULTILIB_USEDEP}]
	 media-libs/libvorbis[${MULTILIB_USEDEP}]
         media-sound/pulseaudio[${MULTILIB_USEDEP}]
	 mono? ( dev-dotnet/nuget[${MULTILIB_USEDEP}]
		 dev-util/msbuild[${MULTILIB_USEDEP}]
		 >=dev-lang/mono-5.2[${MULTILIB_USEDEP}] )
	 net-libs/libasyncns[${MULTILIB_USEDEP}]
	 ${PYTHON_DEPS}
	 sys-apps/tcp-wrappers[${MULTILIB_USEDEP}]
	 sys-apps/util-linux[${MULTILIB_USEDEP}]
	 sys-libs/zlib[${MULTILIB_USEDEP}]
	 system-bullet? ( sci-physics/bullet[${MULTILIB_USEDEP}] )
	 system-enet? ( net-libs/enet[${MULTILIB_USEDEP}] )
         system-freetype? ( media-libs/freetype[${MULTILIB_USEDEP}] )
	 system-libogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )
	 system-libpng? ( media-libs/libpng[${MULTILIB_USEDEP}] )
	 system-libtheora? ( media-libs/libtheora[${MULTILIB_USEDEP}] )
	 system-libvorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	 system-libvpx? ( media-libs/libvpx[${MULTILIB_USEDEP}] )
	 system-mbedtls? ( net-libs/mbedtls[${MULTILIB_USEDEP}] )
	 system-miniupnpc? ( net-libs/miniupnpc[${MULTILIB_USEDEP}] )
	 system-opus? ( media-libs/opus[${MULTILIB_USEDEP}] )
	 system-pcre2? ( dev-libs/libpcre2[${MULTILIB_USEDEP}] )
	 system-recast? ( dev-libs/recastnavigation[${MULTILIB_USEDEP}] )
	 system-squish? ( media-libs/libsquish[${MULTILIB_USEDEP}] )
	 system-xatlas? ( media-libs/xatlas[${MULTILIB_USEDEP}] )
	 system-zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	 system-zstd? ( app-arch/zstd[${MULTILIB_USEDEP}] )
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
	 x11-libs/libxshmfence[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	 clang? ( sys-devel/clang[${MULTILIB_USEDEP}] )
         dev-util/scons
         virtual/pkgconfig[${MULTILIB_USEDEP}]"
S="${WORKDIR}/godot-${PV}-stable"
RESTRICT="mirror"
REQUIRED_USE="docs? ( python_targets_python2_7 || ( $(python_gen_useflags 'python3*') ) )
	      examples-live? ( !examples-snapshot !examples-stable )
	      examples-snapshot? ( !examples-live !examples-stable )
	      examples-stable? ( !examples-live !examples-snapshot )
	      optimize-size? ( !optimize-speed )
	      optimize-speed? ( !optimize-size )
	      portable? ( !system-bullet !system-enet !system-freetype !system-libogg !system-libpng !system-libtheora !system-libvorbis !system-libvpx !system-libwebsockets !system-mbedtls !system-miniupnpc !system-opus !system-pcre2 !system-recast !system-speex !system-squish !system-xatlas !system-zlib !system-zstd )
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
	if use mono ; then
		if has network-sandbox $FEATURES || has sandbox $FEATURES || has usersandbox $FEATURES ; then
			die "mono support requires network-sandbox, sandbox, usersandbox to be disabled in FEATURES on a per-package level."
		fi
		if [[ -z "${XAUTHORITY}" ]] ; then
			ewarn "The build may require you emerge in an X session."
		fi
	fi

	_set_check_req
	check-reqs_pkg_pretend
}

pkg_setup() {
	_set_check_req
	check-reqs_pkg_setup
	python_setup
}

src_unpack() {
	unpack ${A}
	if use examples-stable ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_3_DEMOS_STABLE}"
	elif use examples-snapshot ; then
		export S_DEMOS="${WORKDIR}/${PND}-${EGIT_COMMIT_3_DEMOS_SNAPSHOT}"
	elif use examples-live ; then
		wget -O "${T}/demos.tar.gz" https://github.com/godotengine/godot-demo-projects/archive/master.tar.gz
		unpack "${T}/demos.tar.gz"
		export S_DEMOS="${WORKDIR}/${PND}-master"
	fi
	mv "${WORKDIR}/godot-cpp-${EGIT_COMMIT_GODOT_CPP_SNAPSHOT}" godot-cpp
	mv godot-cpp "${S}"
}

src_prepare() {
	default

	if use gdnative ; then
		eapply "${DISTDIR}/godot-issue-28084-bind-AudioEffectSpectrumAnalyzer-FFT_Size-enums.patch"
		eapply "${DISTDIR}/godot-mono-add-missing-godottools-sln.patch"
		eapply "${FILESDIR}/trial.patch"
	fi

	multilib_copy_sources

	multilib_prepare_impl1() {
		S="${BUILD_DIR}" \
		godot_copy_sources
	}

	multilib_foreach_abi multilib_prepare_impl1

	multilib_prepare_impl2() {
		godot_prepare_impl2() {
			pushd godot-cpp || die
				rm -rf godot_headers
				ln -s "${BUILD_DIR}/modules/gdnative/include" godot_headers
			popd
		}

		godot_foreach_impl godot_prepare_impl2
	}

	multilib_foreach_abi multilib_prepare_impl2
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
}

_build() {
	local p1="${1}" # only x11 and server allowed
	local p2 # only godot and godot_server allowed

	if [[ "${p1}" == "x11" ]] ; then
		p2="godot"
	elif [[ "${p1}" == "server" ]] ; then
		p2="godot_server"
	fi

	local target=$(usex debug "" ".opt")
	local sanitizer=$(usex sanitizer "s" "")
	local tools=".tools" # can only be .tools or .debug only based on the tools option
	local selected_platform=".x11"
	local bitness=$(_get_bitness)
	local llvm=$(usex clang ".llvm" "")
	local mono=$(usex mono ".mono" "")
	local fs="${p2}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"

	if use mono ; then
		# Prevent crash
		# ERROR: generate_cs_core_project: Condition ' !file ' is true. returned: ERR_FILE_CANT_WRITE
		# halts at build_GodotSharp/GodotSharp/Core/Attributes/ExportAttribute.cs
		#          build_GodotSharp/GodotSharp/Core/Extensions/NodeExtensions.cs
		# Script doesn't check if those paths are created first.
		mkdir -p build_GodotSharp/GodotSharp/Core/{Attributes,Extensions,Interfaces} || die

		# Glue to enable the Mono module.
		einfo "Generating glue source code for the ${p1}'s mono"
		scons platform=${p1} ${myoptions[@]} tools=yes mono_glue=no "CFLAGS=${CFLAGS}" "CCFLAGS=${CXXFLAGS}" "LINKFLAGS=${LDFLAGS}" || die
		einfo "Making modules/mono/glue/mono_glue.gen.cpp"
		bin/${fs} --audio-driver Dummy --generate-mono-glue modules/mono/glue || die
		if ! ( find bin -name "data.*" ) ; then
			die "Missing export templates directory (data.mono.*.*.*).  Likely caused by crash while generating mono_glue.gen.cpp."
		fi
		if [[ "${p1}" == "x11" ]] ; then
			einfo "Building mono export templates for ${p1}"
			scons platform=${p1} ${myoptions[@]} tools=no "CFLAGS=${CFLAGS}" "CCFLAGS=${CXXFLAGS}" "LINKFLAGS=${LDFLAGS}" || die
		fi
	fi

	if use gdnative ; then
		# has do be done before C# API bindings to prevent crash
		einfo "Building GDNative C++ bindings for ${p1}"
		bin/${fs} --audio-driver Dummy --gdnative-generate-json-api godot-cpp/godot_headers/api.json || die
		einfo "Generating GDNative C++ bindings for ${p1}"
		pushd godot-cpp || die
			local bitness=$(_get_bitness)
			bitness="${bitness//./}"
			scons platform=linux ${myoptions[@]//release_debug/release} generate_bindings=yes bits=${bitness} "CFLAGS=${CFLAGS}" "CCFLAGS=${CXXFLAGS}" "LINKFLAGS=${LDFLAGS}" || die
		popd
	fi

	if false ; then
#	if use mono ; then
		# Generate the Godot C# API assemblies.
		local data_api_folder="bin/GodotSharp/Api"
		local sln_folder="build_GodotSharp"
		local release=$(usex debug "Debug" "Release")
		mkdir -p build_GodotSharp || die
		einfo "Generating bindings source code and sln file for the ${p1}'s mono"
		bin/${fs} --audio-driver Dummy --generate-cs-api ${sln_folder} || die
		einfo "Building Godot dlls for ${p1}'s mono"
		msbuild ${sln_folder}/GodotSharp.sln /p:Configuration=${release} || die
		mkdir -p ${data_api_folder}
		cp -a build_GodotSharp/GodotSharp/bin/${release}/{GodotSharp.dll,GodotSharp.pdb,GodotSharp.xml} ${data_api_folder} || die
		cp -a build_GodotSharp/GodotSharpEditor/bin/${release}/{GodotSharpEditor.dll,GodotSharpEditor.pdb,GodotSharpEditor.xml} ${data_api_folder} || die
	fi

	einfo "Building final ${p1} with or without mono"
	scons platform=${p1} ${myoptions[@]} "CFLAGS=${CFLAGS}" "CCFLAGS=${CXXFLAGS}" "LINKFLAGS=${LDFLAGS}" || die
}

_use_flag_to_platform() {
	case ${1} in
		X) echo "x11" ;;
		server) echo "server" ;;
	esac
}

src_compile() {
	multilib_compile_impl() {
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
				myoptions+=( builtin_certs=no \
					     system_certs_path="/etc/ssl/certs/ca-certificates.crt" )
			fi

			myoptions+=(
				debug_symbols=$(usex debug "yes" "no") \
				disable_3d=$(usex 3d "no" "yes") \
				disable_advanced_gui=$(usex advanced-gui "no" "yes") \
				builtin_enet=$(usex system-enet "no" "yes") \
				builtin_freetype=$(usex system-freetype "no" "yes") \
				builtin_libpng=$(usex system-libpng "no" "yes") \
				builtin_libtheora=$(usex system-libtheora "no" "yes") \
				builtin_libvorbis=$(usex system-libvorbis "no" "yes") \
				builtin_libvpx=$(usex system-libvpx "no" "yes") \
				builtin_libwebsockets=$(usex system-libwebsockets "no" "yes") \
				builtin_mbedtls=$(usex system-mbedtls "no" "yes") \
				builtin_miniupnpc=$(usex system-miniupnpc "no" "yes") \
				builtin_pcre2=$(usex system-pcre2 "no" "yes") \
				builtin_opus=$(usex system-opus "no" "yes") \
				builtin_recast=$(usex system-recast "no" "yes") \
				builtin_squish=$(usex system-squish "no" "yes") \
				builtin_xatlas=$(usex system-xatlas "no" "yes") \
				builtin_zlib=$(usex system-zlib "no" "yes") \
				builtin_zstd=$(usex system-zstd "no" "yes") \
				minizip=$(usex minizip "yes" "no") \
				module_bmp_enabled=$(usex bmp "yes" "no") \
				module_bullet_enabled=$(usex bullet "yes" "no") \
				module_csg_enabled=$(usex csg "yes" "no") \
				module_cvtt_enabled=$(usex cvtt "yes" "no") \
				module_etc_enabled=$(usex etc "yes" "no") \
				module_enet_enabled=$(usex enet "yes" "no") \
				module_freetype_enabled=$(usex freetype "yes" "no") \
				module_gdnative_enabled=$(usex gdnative "yes" "no") \
				module_gdscript_enabled=$(usex gdscript "yes" "no") \
				module_hdr_enabled=$(usex hdr "yes" "no") \
				module_jpg_enabled=$(usex jpeg "yes" "no") \
				module_mbedtls_enabled=$(usex mbedtls "yes" "no") \
				module_mono_enabled=$(usex mono "yes" "no") \
				module_ogg_enabled=$(usex ogg "yes" "no") \
				module_pvr_enabled=$(usex pvrtc "yes" "no") \
				module_regex_enabled=$(usex pcre2 "yes" "no") \
				module_recast_enabled=$(usex recast "yes" "no") \
				module_squish_enabled=$(usex s3tc "yes" "no") \
				module_svg_enabled=$(usex svg "yes" "no") \
				module_theora_enabled=$(usex theora "yes" "no") \
				module_tinyexr_enabled=$(usex exr "yes" "no") \
				module_tga_enabled=$(usex tga "yes" "no") \
				module_upnp_enabled=$(usex upnp "yes" "no") \
				module_visual_script_enabled=$(usex visual-script "yes" "no") \
				module_vorbis_enabled=$(usex vorbis "yes" "no") \
				module_webm_enabled=$(usex webm "yes" "no") \
				module_websocket_enabled=$(usex websocket "yes" "no") \
				module_webp_enabled=$(usex webp "yes" "no") \
				module_xatlas_enabled=$(usex xatlas "yes" "no") \
				pulseaudio=$(usex pulseaudio "yes" "no") \
				target=$(usex debug "debug" "release_debug") \
				touch=$(usex touch "yes" "no") \
				udev=$(usex gamepad "yes" "no") \
				use_asan=$(usex sanitizer "yes" "no") \
				use_lsan=$(usex sanitizer "yes" "no") \
				use_lto=$(usex lto "yes" "no") \
				use_static_cpp=$(usex portable "yes" "no") \
				use_ubsan=$(usex sanitizer "yes" "no") )

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
	local d_base="/usr/$(get_libdir)/${PN}${SLOT}/${type1}"
	exeinto "${d_base}/bin"
	local fs="${type2}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"
	local fd="${type2}${SLOT}${selected_platform}${target}${tools}${bitness}${llvm}${mono}${sanitizer}"
	cp bin/${fs} bin/${fd} || die
	doexe bin/${fd}
	dosym "${d_base}/${fd}" /usr/bin/${type2}${SLOT}
	dosym "${d_base}/${fd}" /usr/bin/${type2}${SLOT}
	if use mono ; then
		into "${d_base}/bin"
		dolib.so bin/libmonosgen-2.0.so
		insinto "${d_base}/bin"
		local release=$(usex debug ".debug" ".release_debug")
		[ -d bin/data.mono.${type1}${bitness}${release} ] && doins -r bin/data.mono.${type1}${bitness}${release}
		doins -r bin/GodotSharp
	fi
	if use gdnative ; then
		insinto /usr/include/gdnative-${type1}
		doins -r modules/gdnative/include/*
		insinto /usr/$(get_libdir)/pkgconfig
		local release=$(usex debug ".debug" ".release")
		cat "${FILESDIR}/godot${SLOT}-gdnative-${type1}.pc.in" | \
			sed -e "s|@prefix@|/usr|g" \
			       -e "s|@exec_prefix@|\${prefix}|g" \
			       -e "s|@libdir@|/usr/$(get_libdir)|g" \
			       -e "s|@includedir@|\${prefix}/include/gdnative-${type1}|g" \
			       -e "s|@version@|${PV}|g" \
			       -e "s|@bitness@|${bitness//./}|g" \
			       -e "s|@release@|${release}|g" \
				> "${T}/godot${SLOT}-gdnative-${type1}.pc" || die
		doins "${T}/godot${SLOT}-gdnative-${type1}.pc"
		local release=$(usex debug ".debug" ".release")
		einfo "lib=godot-cpp/bin/libgodot-cpp.linux${release}${bitness}.a"
		dolib.a godot-cpp/bin/libgodot-cpp.linux${release}${bitness}.a
	fi
}

src_install() {
	multilib_install_impl() {
		godot_install_impl() {
			local bitness=$(_get_bitness)
			local target=$(usex debug "" ".opt")
			local sanitizer=$(usex sanitizer "s" "")
			local tools=".tools" # can be .tools or .debug only.  based on the tools option
			local selected_platform=".x11"
			local llvm=$(usex clang ".llvm" "")
			local mono=$(usex mono ".mono" "")

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
		}

		godot_foreach_impl godot_install_impl
	}

	multilib_foreach_abi multilib_install_impl

	insinto /usr/share/godot${SLOT}
	if use examples-live || use examples-snapshot || use examples-stable ; then
		doins -r "${S_DEMOS}"/*
	fi

	newicon icon.png godot3.png
	make_desktop_entry "/usr/bin/godot${SLOT}" "Godot${SLOT}" "/usr/share/pixmaps/godot3.png" "Development;IDE"
}
