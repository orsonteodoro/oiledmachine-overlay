# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

# 64 bit only
inherit godot-4.1
inherit desktop flag-o-matic python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot export template for macOS"
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

#KEYWORDS=""

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "
			${x}? (
				|| (
					${2}
				)
			)
		"
	done
}

GODOT_OSX_=(
	arm64
	x86_64
)

GODOT_OSX="${GODOT_OSX_[@]/#/godot_osx_}"

SANITIZERS=(
	asan
	lsan
	tsan
	ubsan
)

IUSE_3D="
+3d +csg +denoise +glslang +gltf +gridmap +lightmapper_rd +mobile-vr
+msdfgen +openxr +raycast +recast +vhacd +xatlas
"
IUSE_BUILD="
${SANITIZERS[@]}
debug jit +neon +optimize-speed optimize-size +portable
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
+freetype +graphite +opensimplex +pcre2 +pulseaudio +volk +vulkan
"
IUSE_NET="
+enet +jsonrpc +mbedtls +multiplayer +text-server-adv -text-server-fb +upnp
+webrtc +websocket
"
IUSE_SCRIPTING="
-gdscript gdscript_lsp -mono +visual-script
"
IUSE+="
	${IUSE_3D}
	${IUSE_BUILD}
	${IUSE_CONTAINERS_CODECS_FORMATS}
	${IUSE_GUI}
	${IUSE_INPUT}
	${IUSE_LIBS}
	${IUSE_NET}
	${IUSE_SCRIPTING}
	${GODOT_OSX}
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EGODOT_MACOS_SDK_VERSION
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	portable
	denoise? (
		lightmapper_rd
	)
	gdscript_lsp? (
		jsonrpc websocket
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
		vulkan? (
			volk
		)
	)
	|| (
		${GODOT_OSX}
	)
"
APST_REQ_STORE_DATE="April 2021"
XCODE_SDK_MIN_STORE="12"
EXPECTED_XCODE_SDK_MIN_VERSION_ARM64="10.15" # See https://github.com/godotengine/godot/blob/3.4-stable/platform/osx/detect.py#L80
EXPECTED_XCODE_SDK_MIN_VERSION_X86_64="10.12"

BDEPEND+="
	${PYTHON_DEPS}
	app-arch/zip
	dev-build/scons
	mono? (
		dev-games/godot-editor:${SLOT}[mono]
		=dev-games/godot-mono-runtime-macos-$(ver_cut 1-2 ${MONO_PV})*
	)
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ]] ; then
eerror
eerror "${p} is unreachable"
eerror
	fi
}

yn_path() {
	local p="${1}"
	if ! realpath -e "${p}" ]] ; then
		return 1
	fi
	return 0
}

test_osxcross() {
	if [[ -z "${OSXCROSS_SDK}" ]] ; then
eerror
eerror "OSXCROSS_SDK must be defined as an environment variable."
eerror "It must be darwin<version> replacing <version>."
eerror
		die
	fi
	test_path "${OSXCROSS_ROOT}/target/bin"
	local arch="ARCH_NOT_DEFINED"
	if use godot_osx_arm64 ; then
		arch="arm64"
	fi
	if use godot_osx_x86_64 ; then
		arch="x86_64"
	fi
	test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-cc"
	test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-c++"
	test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-ar"
	test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-ranlib"
	test_path "${OSXCROSS_ROOT}/target/bin/${arch}-*-as"
}

test_prefixed_toolchain() {
	local found=0
	yn_path "/opt/local/libexec/llvm-*/bin/clang" && found=1
	clang --version 2>/dev/null 1>/dev/null && found=1
	if (( ${found} == 0 )) ; then
eerror
eerror "Could not find a prefixed toolchain"
eerror
		die
	fi
}

check_cross_toolchain() {
	if [[ -n "${OSXCROSS_ROOT}" ]] ; then
einfo
einfo "Using OSXCross"
einfo
		test_path "${OSXCROSS_ROOT}"
		test_osxcross
	elif [[ -n "${MACPORTS_PREFIX}" ]] ; then
einfo
einfo "Using prefixed toolchain"
einfo
		test_path "${MACPORTS_PREFIX}"
		test_prefixed_toolchain
	else
eerror
eerror "Either one of the following needs to be defined as an environment"
eerror "variable:"
eerror
eerror "  OSXCROSS_ROOT"
eerror "  MACPORTS_PREFIX"
eerror
		die
	fi

	if [[ -z "${MACOS_SDK_PATH}" ]] ; then
eerror
eerror "MACOS_SDK_PATH must be defined as an environment variable."
eerror
		die
	fi
	test_path "${MACOS_SDK_PATH}"
}

check_store_apl()
{
	if ver_test ${MACOS_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
ewarn
ewarn "Your Xcode SDK does not meet minimum store requirements of"
ewarn ">=${XCODE_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
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
	check_cross_toolchain
	check_store_apl

	python-any-r1_pkg_setup

	which lipo 2>/dev/null 1>/dev/null || die "Missing lipo"
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


_compile()
{
	local enabled_arches=()
	local configuration2=$(get_configuration2)
	for a in ${GODOT_OSX} ; do
		if use ${a} ; then
			local arch="${a/godot_osx_}"
			local options_mono=()
			if use mono ; then
				options_mono=(
					mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-osx-${arch}-$(get_configuration3)"
				)
			fi
			einfo "Building for macOS (${a})"
			scons ${options_osx[@]} \
				${options_modules[@]} \
				${options_modules_static[@]} \
				${options_mono[@]} \
				${options_extra[@]} \
				arch=${arch} \
				target=${configuration} \
				tools=no \
				OSXCROSS_ROOT=${EGODOT_MACOS_SYSROOT} \
				|| die
			enabled_arches+=( bin/godot.osx.${configuration2}.${arch} )
		fi
	done

	# Generate universal2 binary
	lipo -create \
		${enabled_arches[@]} \
		-output bin/godot.osx.${configuration2}.universal || die

	cp bin/godot.osx.${configuration}.universal \
		osx_template.app/Contents/MacOS/godot_osx_${configuration2}.64 || die
	chmod +x osx_template.app/Contents/MacOS/godot_osx* || die
}

set_production() {
	if [[ "${configuration}" == "release" ]] ; then
		echo "production=True"
	fi
}

src_compile_osx_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_glue=yes (default)
	# FIXME:
	local options_extra=(
		$(set_production)
		copy_mono_root=yes
		module_mono_enabled=yes
		tools=no
	)
	_compile
}

src_compile_osx_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_osx()
{
	cp -r misc/dist/osx_template.app . || die
	mkdir -p osx_template.app/Contents/MacOS || die
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_osx_yes_mono
		else
			src_compile_osx_no_mono
		fi
	done
	zip -q -9 -r osx.zip osx_template.app || die
}

src_compile() {
	local myoptions=()
	local options_osx=(
		platform=osx
		osxcross_sdk=${EGODOT_MACOS_SDK_VERSION}
		use_asan=$(usex asan)
		use_tsan=$(usex tsan)
		use_ubsan=$(usex ubsan)
		use_volk=$(usex volk)
		vulkan=$(usex vulkan)
	)
	local options_modules_static=(
		builtin_brotli=True
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
		builtin_openxr=True
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
		brotli=$(usex brotli)
		builtin_pcre2_with_jit=$(usex jit)
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

	src_compile_osx
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

	doins "osx.zip"
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
einfo
einfo "The following still must be done:"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo "  cp -aT ${prefix} ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
