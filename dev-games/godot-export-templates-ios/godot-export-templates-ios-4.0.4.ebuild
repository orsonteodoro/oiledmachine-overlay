# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

# TODO: check each compiler flag for GODOT_IOS_

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

inherit godot-4.0
inherit desktop flag-o-matic multilib-build python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="fetch mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot export template for iOS"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="
	all-rights-reserved
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	FTL
	ISC
	LGPL-2.1
	MIT
	MPL-2.0
	OFL-1.1
	openssl
	Unlicense
	ZLIB
"
#KEYWORDS="" # Ebuild not finished

# See https://github.com/godotengine/godot/blob/4.0.1-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# Listed because of mono_static=yes
# mono_static=yes # See https://docs.godotengine.org/en/3.4/development/compiling/compiling_with_mono.html#command-line-options
MONO_LICENSE="
	MIT
	DOTNET-libraries-and-runtime-components-patents
	IDPL
	ISC
	LGPL-2.1
	Mono-patents
	MPL-1.1
	OSL-1.1
"
# ikvm-disabled
LICENSE+=" mono? ( ${MONO_LICENSE} )"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

#KEYWORDS=""

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_IOS_=(
	arm
	armv7
	armv64
	arm64-sim
	x86
	x86_64
)

GODOT_IOS="${GODOT_IOS_[@]/#/godot_ios_}"

SANITIZERS=(
	asan
	lsan
	msan
	tsan
	ubsan
)

IUSE_3D="
+3d +csg +denoise +glslang +gltf +gridmap +lightmapper_rd +mobile-vr
+msdfgen +openxr +raycast +recast +vhacd +xatlas
"
IUSE_BUILD="
${SANITIZERS[@]}
debug jit lto +neon +optimize-speed optimize-size +portable
"
IUSE_CONTAINERS_CODECS_FORMATS="
+astc +bmp +brotli +cvtt +dds +etc +exr +hdr +jpeg +minizip +mp3 +ogg
+pvrtc +s3tc +svg +tga +theora +vorbis +webp
"
IUSE_GUI="
+advanced-gui
"
IUSE_INPUT="
camera
"
IUSE_LIBS="
+freetype +graphite +opensimplex +pcre2 +pulseaudio +vulkan
"
IUSE_NET="
+enet +jsonrpc +mbedtls +multiplayer +text-server-adv -text-server-fb +upnp
+webrtc +websocket
"
IUSE_PLATFORM_FEATURES="
+game-center +icloud -ios-sim +store-kit
"
IUSE_SCRIPTING="
-gdscript gdscript_lsp mono +visual-script
"

IUSE+="
	${IUSE_3D}
	${IUSE_BUILD}
	${IUSE_CONTAINERS_CODECS_FORMATS}
	${IUSE_GUI}
	${IUSE_LIBS}
	${IUSE_NET}
	${IUSE_PLATFORM_FEATURES}
	${IUSE_SCRIPTING}
	${GODOT_IOS}
"

# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# See https://developer.apple.com/ios/submit/ for app store requirement
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	!mono
	portable
	denoise? (
		lightmapper_rd
	)
	gdscript_lsp? (
		jsonrpc
		websocket
	)
	lsan? (
		asan
	)
	msdfgen? (
		freetype
	)
	optimize-size? (
		!optimize-speed
	)
	optimize-speed? (
		!optimize-size
	)
	portable? (
		!asan
		!tsan
	)
	|| (
		${GODOT_IOS}
	)
"
# See https://developer.apple.com/ios/submit/ for app store requirement
APST_REQ_STORE_DATE="April 2022"
IOS_SDK_MIN_STORE="15"
XCODE_SDK_MIN_STORE="13"
EXPECTED_XCODE_SDK_MIN_VERSION_IOS="10"
EXPECTED_IOS_SDK_MIN_VERSION="10"

DEPEND+="
	mono? (
		dev-games/godot-editor:${SLOT}[mono]
		=dev-games/godot-mono-runtime-monotouch-$(ver_cut 1-2 ${MONO_PV})*:=
	)
"

BDEPEND+="
	${PYTHON_DEPS}
	app-arch/zip
	dev-build/scons
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ; then
eerror
eerror "${p} is unreachable"
eerror
		die
	fi
}

check_cross_compiler_paths() {
	if [[ -z "${IPHONEPATH}" ]] ; then
eerror
eerror "IPHONEPATH must be defined as per-package environment variable."
eerror "It is the path to the toolchain"
eerror
		die
	fi
	if [[ -z "${IPHONESDK}" ]] ; then
eerror
eerror "IPHONESDK must be defined as per-package environment variable."
eerror "It is the path to the sdk"
eerror
		die
	fi
	export OSXCROSS_IOS="${IPHONEPATH}"

	test_path "${IPHONEPATH}/usr/bin"
	test_path "${IPHONEPATH}/usr/bin/*/clang"
	test_path "${IPHONEPATH}/usr/bin/*/clang++"
	test_path "${IPHONEPATH}/usr/bin/*/ar"
	test_path "${IPHONEPATH}/usr/bin/*/ranlib"
	test_path "${IPHONEPATH}/usr/include"
	test_path "${IPHONESDK}/System/Library/Frameworks/OpenGLES.framework/Headers"
	test_path "${IPHONESDK}/System/Library/Frameworks/AudioUnit.framework/Headers"

	if [[ -z "${OSXCROSS_IOS}" ]] ; then
ewarn
ewarn "OSXCROSS_IOS must be defined as per-package environment variable."
ewarn "It is set to 1 if you are using OSXCross."
ewarn
	fi
}

check_store_apl()
{
	if ver_test ${IOS_SDK_VERSION} -lt ${IOS_SDK_MIN_STORE} ; then
ewarn
ewarn "Your IOS SDK does not meet minimum store requirements of"
ewarn ">=${IOS_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi

	if [[ -n "${XCODE_SDK_VERSION}" ]] \
		&& ver_test ${XCODE_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
ewarn
ewarn "Your Xcode SDK does not meet minimum store requirements of"
ewarn ">=${XCODE_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi
}

check_sdk_versions() {
	if ver_test ${IOS_SDK_VERSION} -lt ${EXPECTED_IOS_SDK_MIN_VERSION} ; then
eerror
eerror "Your iOS SDK version must be >= ${EXPECTED_IOS_SDK_MIN_VERSION}"
eerror
		die
	fi
}

pkg_setup() {
ewarn
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
ewarn
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	if use gdscript ; then
ewarn
ewarn "The gdscript USE flag is untested."
ewarn
	fi
	check_cross_compiler_paths
	check_store_apl
	check_sdk_versions

	python-any-r1_pkg_setup
}

src_prepare() {
	default
	if use mono ; then
		cp -aT "/usr/share/${MY_PN}/${SLOT_MAJ}/mono-glue/modules/mono/glue" \
			modules/mono/glue || die
	fi
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
	# CCACHE disabled for cross-compile
	unset CCACHE
}

get_configuration2() {
	[[ "${configuration}" == "release" ]] && echo "opt"
	[[ "${configuration}" == "release_debug" ]] && echo "opt.debug"
}

get_configuration3() {
	if [[ "${configuration}" =~ "debug" ]] ; then
		echo "debug"
	elif [[ "${configuration}" =~ "release" ]] ; then
		echo "release"
	else
		echo ""
	fi
}

_compile() {
	local enabled_arches_dev=()
	local enabled_arches_sim=()
	local configuration2=$(get_configuration2)
	local configuration3=$(get_configuration3)
	local plugin
	ewarn "iOS export templates is incomplete"
	for a in ${GODOT_IOS} ; do
		if use ${a} ; then
			local arch="${a/godot_ios_}"
			local options_mono=()
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

			local ios_simulator="False"

			if [[ "${arch}" == "x86" \
				|| "${arch}" == "x86_64" \
				|| "${arch}" == "arm64-sim" ]] ; then
				ios_simulator="True"
			else
				ios_simulator="False"
			fi

			local mono_target
			if [[ "${arch}" == "x86" ]] ; then
				mono_target="i386"
			elif [[ "${arch}" == "x86_64" ]] ; then
				mono_target="x86_64"
			else
				mono_target="${arch}"
			fi

			if [[ "${arch}" == "arm64-sim" ]] ; then
				arch="arm64"
			fi

			local options_mono=()
			if use mono ; then
				options_mono=(
					mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/ios-${mono_target}-$(get_configuration3)"
				)
			fi

			local osxcross_arch=""
			if [[ "${arch}" == "arm" ]] ; then
				osxcross_arch="armv7"
			elif [[ "${arch}" == "arm64" ]] ; then
				osxcross_arch="aarch64"
			elif [[ "${arch}" == "x86" ]] ; then
				osxcross_arch="i386"
			elif [[ "${arch}" == "x86_64" ]] ; then
				osxcross_arch="x86_64"
			fi

			local ios_triple="${osxcross_arch}-apple-darwin11-"

			einfo "Building for iOS (${a})"
			scons ${options_iphone[@]} \
				${options_modules[@]} \
				${options_modules_static[@]} \
				${options_mono[@]} \
				${options_extra[@]} \
				ios_simulator=${ios_simulator} \
				arch=${arch} \
				bits=${bitness} \
				target=${configuration} \
				tools=no \
				ios_triple=${ios_triple} \
				|| die
			if [[ "${arch}" == "x86" \
				|| "${arch}" == "x86_64" \
				|| "${arch}" == "arm64-sim" ]] ; then
				enabled_arches_sim+=( bin/libgodot.iphone.${configuration2}.${arch}.a )
			else
				enabled_arches_dev+=( bin/libgodot.iphone.${configuration2}.${arch}.a )
			fi
		fi
	done

	# The documentation doesn't provide any reassurance after this point.
	# There is a disagreement and/or disconnect between prepackaged filelist
	# and the documentation.

	# Generate universal2 binary
	if (( ${enabled_arches_sim[@]} > 0 )) ; then
		lipo -create \
			${enabled_arches_sim[@]} \
			-output out/libgodot.iphone.${configuration3}.xcframework/ios-arm64_x86_64-simulator/libgodot.a || die
	fi
	if (( ${enabled_arches_dev[@]} > 0 )) ; then
		lipo -create \
			${enabled_arches_arch[@]} \
			-output out/libgodot.iphone.${configuration3}.xcframework/ios-arm64/libgodot.a || die
	fi
}

set_production() {
	if [[ "${configuration}" == "release" ]] ; then
		echo "production=True"
	fi
}

src_compile_ios_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_static=yes (default on this platform)
	# mono_glue=yes (default)
	local options_extra=(
		$(set_production)
		copy_mono_root=yes
		module_mono_enabled=yes
		tools=no
	)
	_compile
}

src_compile_ios_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_ios() {
	mkdir -p "out"
	cp -a misc/dist/ios_xcode/* "out" || die
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_ios_yes_mono
		else
			src_compile_ios_no_mono
		fi
	done
	cd out || die
	zip -q -9 -r ../iphone.zip * || die
}

src_compile() {
	local myoptions=()
	local options_iphone=(
		platform=iphone
		game_center=$(usex game-center)
		icloud=$(usex icloud)
		use_lto=$(usex lto)
		store_kit=$(usex store-kit)
		vulkan=$(usex vulkan)
	)
	local options_modules_static=(
		builtin_certs=True
		builtin_embree=True
		builtin_enet=True
		builtin_freetype=True
		builtin_glslang=True
		builtin_libogg=True
		builtin_libpng=True
		builtin_libtheora=True
		builtin_libvorbis=True
		builtin_libwebp=True
		builtin_mbedtls=True
		builtin_miniupnpc=True
		builtin_msdfgen=True
		builtin_pcre2=True
		builtin_recast=True
		builtin_rvo2=True
		builtin_squish=True
		builtin_wslay=True
		builtin_xatlas=True
		builtin_zlib=True
		builtin_zstd=True
		pulseaudio=False
		use_static_cpp=True
	)

	if use optimize-size ; then
		myoptions+=( optimize=size )
	else
		myoptions+=( optimize=speed )
	fi

	options_modules+=(
		builtin_pcre2_with_jit=$(usex jit)
		brotli=$(usex brotli)
		disable_3d=$(usex !3d)
		disable_advanced_gui=$(usex !advanced-gui)
		graphite=$(usex graphite)
		minizip=$(usex minizip)
		openxr=$(usex openxr)
		module_astcenc_enabled=$(usex astc)
		module_bmp_enabled=$(usex bmp)
		module_camera_enabled=$(usex camera)
		module_csg_enabled=$(usex csg)
		module_cvtt_enabled=$(usex cvtt)
		module_dds_enabled=$(usex dds)
		module_denoise_enabled=$(usex denoise)
		module_etcpak_enabled=$(usex etc)
		module_enet_enabled=$(usex enet)
		module_freetype_enabled=$(usex freetype)
		module_gdnative_enabled=False
		module_gdscript_enabled=$(usex gdscript)
		module_glslang_enabled=$(usex glslang)
		module_gltf_enabled=$(usex gltf)
		module_gridmap_enabled=$(usex gridmap)
		module_hdr_enabled=$(usex hdr)
		module_jpg_enabled=$(usex jpeg)
		module_jsonrpc_enabled=$(usex jsonrpc)
		module_lightmapper_rd_enabled=$(usex lightmapper_rd)
		module_mbedtls_enabled=$(usex mbedtls)
		module_minimp3_enabled=$(usex mp3)
		module_mobile_vr_enabled=$(usex mobile-vr)
		module_msdfgen_enabled=$(usex msdfgen)
		module_multiplayer_enabled=$(usex multiplayer)
		module_navigation_enabled=$(usex recast)
		module_ogg_enabled=$(usex ogg)
		module_opensimplex_enabled=$(usex opensimplex)
		module_pvr_enabled=$(usex pvrtc)
		module_raycast_enabled=$(usex raycast)
		module_regex_enabled=$(usex pcre2)
		module_squish_enabled=$(usex s3tc)
		module_stb_vorbis_enabled=$(usex vorbis)
		module_svg_enabled=$(usex svg)
		module_text_server_adv_enabled=$(usex text-server-adv)
		module_text_server_fb_enabled=$(usex text-server-fb)
		module_theora_enabled=$(usex theora)
		module_tinyexr_enabled=$(usex exr)
		module_tga_enabled=$(usex tga)
		module_upnp_enabled=$(usex upnp)
		module_visual_script_enabled=$(usex visual-script)
		module_vhacd_enabled=$(usex vhacd)
		module_vorbis_enabled=$(usex vorbis)
		module_websocket_enabled=$(usex websocket)
		module_webp_enabled=$(usex webp)
		module_webrtc_enabled=$(usex webrtc)
		module_webxr_enabled=False
		module_xatlas_enabled=$(usex xatlas)
		module_zip_enabled=$(usex minizip)
	)

	src_compile_ios
}

_install_export_templates() {
	local prefix
	if use mono ; then
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/mono"
	else
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/standard"
	fi
	insinto "${prefix}"
	exeinto "${prefix}"
	einfo "Installing export templates"

	[[ ! -e "iphone.zip" ]] || die "FIXME:  install from bin/?"
	doins "iphone.zip"
	use mono && doins -r bin/iphone-mono-libs
}

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	_install_export_templates
}

pkg_postinst() {
	local prefix
	if use mono ; then
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/mono"
	else
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/standard"
	fi
	local suffix=""
	use mono && suffix=".mono"
#	local arches=$(echo "${GODOT_IOS_[@]}" | sed -e 's| |, |g')
einfo
einfo "The following still must be done:"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo "  cp -aT ${prefix} ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
