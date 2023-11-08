# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

inherit godot-3.5
inherit desktop flag-o-matic llvm multilib-build python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot export template for Windows (using MinGW64-w64 for 64-bit)"
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

# See https://github.com/godotengine/godot/blob/3.5.2-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

#KEYWORDS=""

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

SANITIZERS=(
	asan
	lsan
	msan
	tsan
	ubsan
)

IUSE_3D="
+3d +bullet +csg +denoise +gltf +gridmap +lightmapper_cpu +mobile-vr
+raycast +recast +vhacd +xatlas
"
IUSE_BUILD="
${SANITIZERS[@]}
clang +dds debug jit lld lto +neon +optimize-speed optimize-size +portable
"
IUSE_CONTAINERS_CODECS_FORMATS="
+bmp +cvtt +etc +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +s3tc +svg
+tga +theora +vorbis +webm webm-simd +webp
"
IUSE_GUI="
+advanced-gui
"
IUSE_INPUT="
camera
"
IUSE_LIBS="
+freetype +opensimplex +pcre2 +pulseaudio
"
IUSE_NET="
+enet +jsonrpc +mbedtls +upnp +webrtc +websocket
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
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	!clang
	!lld
	portable
	denoise? (
		lightmapper_cpu
	)
	gdscript_lsp? (
		jsonrpc
		websocket
	)
	lld? (
		clang
	)
	lsan? (
		asan
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
"

gen_cdepend_lto_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/lld:${s}
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
	echo -e "${o}"
}

CDEPEND_GCC_SANITIZER="
	!clang? (
		sys-devel/gcc[sanitize]
	)
"
gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				=sys-devel/clang-runtime-${s}[${MULTILIB_USEDEP},compiler-rt,sanitize]
				=sys-libs/compiler-rt-sanitizers-${s}*:=[${MULTILIB_USEDEP},${san_type}]
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
	echo "${o}"
}
gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS[@]} ; do
		echo "
	${a}? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? (
				|| (
					$(gen_clang_sanitizer ${a})
				)
			)
		)
	)

		"
	done
}


# All DISABLED_* is kept around because of sanitizers.
DISABLED_CDEPEND="
	${CDEPEND_SANITIZER}
"
# All dependencies are in the project.
DISABLED_DEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	virtual/opengl[${MULTILIB_USEDEP}]
"
DISABLED_RDEPEND+="
	${DEPEND}
"
DISABLED_BDEPEND+="
	lld? (
		sys-devel/lld
	)
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
"

CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"
CDEPEND+="
	sys-devel/crossdev
"
CDEPEND_CLANG="
	clang? (
		!lto? (
			sys-devel/clang[${MULTILIB_USEDEP}]
		)
		lto? (
			|| (
				$(gen_cdepend_lto_llvm)
			)
		)
	)
"
CDEPEND_GCC="
	!clang? (
		sys-devel/gcc[${MULTILIB_USEDEP}]
	)
"

BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	dev-util/scons
	mono? (
		=dev-games/godot-mono-runtime-mingw32-$(ver_cut 1-2 ${MONO_PV})*
		dev-games/godot-editor:${SLOT}[mono]
	)
	webm-simd? (
		dev-lang/yasm
	)
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ]] ; then
eerror
eerror "${p} was not found."
eerror
		die
	fi
}

check_mingw()
{
	export MINGW32_CHOST=${MINGW32_CHOST:-i686-w64-mingw32-}
	export MINGW32_SYSROOT="${ESYSROOT}/usr/${MINGW32_CHOST%-}"
	export MINGW32_PREFIX="${MINGW32_SYSROOT}/${MINGW32_CHOST}"

	if use clang ; then
		test_path "${MINGW32_PREFIX}/clang"
		test_path "${MINGW32_PREFIX}/clang++"
		test_path "${MINGW32_PREFIX}/as"
		test_path "${MINGW32_PREFIX}/ar"
		test_path "${MINGW32_PREFIX}/ranlib"
	else
		test_path "${MINGW32_PREFIX}/gcc"
		test_path "${MINGW32_PREFIX}/g++"
		test_path "${MINGW32_PREFIX}/as"
		test_path "${MINGW32_PREFIX}/gcc-ar"
		test_path "${MINGW32_PREFIX}/gcc-ranlib"
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
	check_mingw

	python-any-r1_pkg_setup
	if use lto && use clang ; then
		LLVM_MAX_SLOT="not_found"
		local s
		for s in ${LLVM_SLOTS[@]} ; do
			if has_version "sys-devel/clang:${s}" \
				&& has_version "sys-devel/llvm:${s}" ; then
				LLVM_MAX_SLOT=${s}
				break
			fi
		done
		if [[ "${LLVM_MAX_SLOT}" == "not_found" ]] ; then
eerror
eerror "Both sys-devel/clang:\${SLOT} and sys-devel/llvm:\${SLOT} must have the"
eerror "same slot."
eerror
			die
		fi
einfo
einfo "LLVM_MAX_SLOT=${LLVM_MAX_SLOT} for LTO"
einfo
		llvm_pkg_setup
	fi
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

_compile() {
	einfo "Building for Windows (x86)"
	scons ${options_windows[@]} \
		${options_modules[@]} \
		${options_modules_static[@]} \
		${options_extra[@]} \
		bits=${bitness} \
		target=${configuration} \
		|| die
}

set_production() {
	if [[ "${configuration}" == "release" ]] ; then
		echo "production=True"
	fi
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

# libmonosgen-2.0.so needs 32-bit or static linkage
src_compile_windows_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_glue=yes (default)
	local options_extra=(
		$(set_production)
		copy_mono_root=yes
		module_mono_enabled=yes
		mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-windows-x86-$(get_configuration3)"
		tools=no
	)
	_compile
}

src_compile_windows_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_windows()
{
	local bitness=32
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_windows_yes_mono
		else
			src_compile_windows_no_mono
		fi
	done
}

src_compile() {
	local myoptions=()
	local options_windows=(
		platform=windows
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_thinlto=$(usex lto)
		use_asan=$(usex asan)
	)
	local options_modules_static=(
		builtin_bullet=True
		builtin_certs=True
		builtin_embree=True
		builtin_enet=True
		builtin_freetype=True
		builtin_libogg=True
		builtin_libpng=True
		builtin_libtheora=True
		builtin_libvorbis=True
		builtin_libvpx=True
		builtin_libwebp=True
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
	)

	if use optimize-size ; then
		myoptions+=( optimize=size )
	else
		myoptions+=( optimize=speed )
	fi

	options_modules+=(
		builtin_pcre2_with_jit=$(usex jit)
		disable_3d=$(usex !3d)
		disable_advanced_gui=$(usex !advanced-gui)
		minizip=$(usex minizip)
		module_bmp_enabled=$(usex bmp)
		module_bullet_enabled=$(usex bullet)
		module_camera_enabled=$(usex camera)
		module_csg_enabled=$(usex csg)
		module_cvtt_enabled=$(usex cvtt)
		module_dds_enabled=$(usex dds)
		module_denoise_enabled=$(usex denoise)
		module_etc_enabled=$(usex etc)
		module_enet_enabled=$(usex enet)
		module_freetype_enabled=$(usex freetype)
		module_gdnative_enabled=False
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
		module_webxr_enabled=False
		module_xatlas_enabled=$(usex xatlas)
	)

	src_compile_windows
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
		if [[ "${x}" =~ "bin/godot" && "${x}" =~ "${configuration}" ]] ; then
			newexe "${x}" "windows_${bitness}_${configuration}.exe"
		fi
	done

	# Data files also
	use mono && doins -r "${WORKDIR}/bin/data"*
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
