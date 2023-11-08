# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

# TODO: check each compiler flag for GODOT_ANDROID_

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

inherit godot-4.1
inherit desktop flag-o-matic java-pkg-2 multilib-build python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot export template for Android"
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

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

GODOT_ANDROID_=(arm7 arm64v8 x86 x86_64)
GODOT_ANDROID="${GODOT_ANDROID_[@]/#/godot_android_}"
SANITIZERS=(
	asan
	lsan
	msan
	tsan
	ubsan
)

IUSE_3D="
+3d +csg +denoise +glslang +gltf +gridmap +lightmapper_rd +mobile-vr
+msdfgen +raycast +recast +vhacd +xatlas
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
+freetype +graphite +opensimplex +pcre2 +pulseaudio +vulkan
"
IUSE_NET="
+enet +jsonrpc +mbedtls +multiplayer +text-server-adv -text-server-fb +upnp
+webrtc +websocket
"
IUSE_SCRIPTING="
-gdscript gdscript_lsp mono +visual-script
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
	${GODOT_ANDROID}
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://docs.godotengine.org/en/3.4/development/compiling/compiling_for_android.html
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
		${GODOT_ANDROID}
	)
"
EXPECTED_MIN_ANDROID_API_LEVEL="29"
JAVA_SLOT="11" # See https://github.com/godotengine/godot/blob/3.4-stable/.github/workflows/android_builds.yml#L32
NDK_PV="21"

CDEPEND+="
	>=dev-java/gradle-bin-7.2
	dev-util/android-sdk-update-manager
	godot_android_x86_64? (
		>=dev-util/android-ndk-21:=
	)
	godot_android_arm64v8? (
		>=dev-util/android-ndk-21:=
	)
"
RDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	virtual/jre:${JAVA_SLOT}
"
DEPEND+="
	${RDEPEND}
	virtual/jdk:${JAVA_SLOT}
	mono? (
		=dev-games/godot-mono-runtime-monodroid-$(ver_cut 1-2 ${MONO_PV})*
		dev-games/godot-editor:${SLOT}[mono]
	)
"
BDEPEND+="
	${CDEPEND}
	${JDK_DEPEND}
	${PYTHON_DEPS}
	dev-util/scons
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

check_android_native()
{
	export ANDROID_NDK_ROOT="/opt/android-ndk"
#	ANDROID_SDK_DIR="/opt/android-sdk-update-manager"
#	export ANDROID_HOME="${EPREFIX}${ANDROID_SDK_DIR}" # already set by dev-util/android-sdk-update-manager env.d
	if [[ ! -e "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/"*"/bin" ]] ; then
eerror
eerror "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/*/bin is unreachable"
eerror
		die
	fi
	if [[ -z "${ANDROID_HOME}" ]] ; then
eerror
eerror "Missing ANDROID_HOME set by dev-util/android-sdk-update-manager."
eerror "Do \`env-update ; source /etc/profile\` to fix it."
eerror
		die
	fi
	local ndk_version=$(best_version "dev-util/android-ndk" \
		| sed -e "s|dev-util/android-ndk-||g")
	export NDK_PLATFORM="android-${ndk_version}"
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
	check_android_native
	check_android_sandbox

	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}

	einfo "JAVA_HOME=${JAVA_HOME}"
	einfo "PATH=${PATH}"

	python-any-r1_pkg_setup
}

src_prepare() {
	default
	if use mono ; then
		cp -aT "/usr/share/${MY_PN}/${SLOT_MAJ}/mono-glue/modules/mono/glue" \
			modules/mono/glue || die
	fi
	java-pkg-2_src_prepare
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
	for a in ${GODOT_ANDROID} ; do
		if use ${a} ; then
			local arch="${a/godot_android_}"
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

			if use neon && use godot_android_arm7 ; then
				options_extra+=( android_neon=True )
			elif ! use neon && use godot_android_arm7 ; then
				options_extra+=( android_neon=False )
			fi

			options_mono=()
			if use mono ; then
				options_mono=(
					mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/android-${arch}-$(get_configuration3)"
				)
			fi

			einfo "Building for Android (${a})"
			scons ${options_android[@]} \
				${options_modules[@]} \
				${options_modules_static[@]} \
				${options_extra[@]} \
				${options_mono[@]} \
				android_arch=${arch} \
				bits=${bitness} \
				target=${configuration} \
				tools=no \
				ndk_platform=${NDK_PLATFORM} \
				|| die
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

set_production() {
	if [[ "${configuration}" == "release" ]] ; then
		echo "production=True"
	fi
}

src_compile_android_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_glue=yes (default)
	local options_extra=(
		$(set_production)
		copy_mono_root=yes
		module_mono_enabled=yes
		tools=no
	)
	_compile
}

src_compile_android_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_android() {
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_android_yes_mono
		else
			src_compile_android_no_mono
		fi
	done
}

src_compile() {
	local myoptions=()
	local options_android=(
		platform=android
		vulkan=$(usex vulkan)
	)
	local options_modules_static=(
		builtin_brotli=True
		builtin_embree=True
		builtin_enet=True
		builtin_certs=True
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
		builtin_pcre2_with_jit=$(usex jit)
		brotli=$(usex brotli)
		disable_3d=$(usex !3d)
		disable_advanced_gui=$(usex !advanced-gui)
		graphite=$(usex graphite)
		minizip=$(usex minizip)
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

	src_compile_android
}

_get_bitness() {
	local x="${1}"
	if [[ "${x}" =~ "64" ]] ; then
		echo "64"
	elif [[ "${x}" =~ "32" ]] ; then
		echo "32"
	else
		echo -n ""
	fi
}

_get_configuration() {
	local x="${1}"
	if [[ "${x}" =~ ".debug" ]] ; then
		echo "debug"
	elif [[ "${x}" =~ ".opt" ]] ; then
		echo "release"
	else
		echo -n ""
	fi
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

	local x
	for x in $(find bin -type f) ; do
		local bitness=$(_get_bitness "${x}")
		local configuration=$(_get_configuration "${x}")
		if [[ "${x}" =~ ".apk" && "${x}" =~ "${configuration}" ]] ; then
			newins "${x}" "android_${configuration}.apk"
		fi
	done

	doins bin/android_source.apk
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
