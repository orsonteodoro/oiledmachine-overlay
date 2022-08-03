# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"
STATUS="stable"
MONO_PV="6.12.0.158" # same as godot-export-templates-bin

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop eutils flag-o-matic llvm multilib-build python-any-r1 scons-utils

DESCRIPTION="Godot export template for JavaScript"
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

# See https://github.com/godotengine/godot/blob/3.4.4-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# Listed because of mono_static=yes
MONO_LICENSE="
	MIT
	BSD-4
	IDPL
	LGPL-2.1
	MPL-1.1
	OSL-1.1
"
LICENSE+=" mono? ( ${MONO_LICENSE} )"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

KEYWORDS="~amd64"

FN_SRC="${PV}-stable.tar.gz"
FN_DEST="${MY_P}.tar.gz"
URI_ORG="https://github.com/godotengine"
URI_PROJECT="${URI_ORG}/${MY_PN}"
URI_DL="${URI_PROJECT}/releases"
URI_A="${URI_PROJECT}/archive/${PV}-stable.tar.gz"
if [[ "${AUPDATE}" == "1" ]] ; then
	# Used to generate hashes and download all assets.
	SRC_URI="
		${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST}
	"
else
	SRC_URI="
		${URI_PROJECT}/archive/${FN_SRC} -> ${FN_DEST}
	"
	RESTRICT="fetch mirror"
fi
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

# webxr, camera is enabled upstream by default
IUSE+=" +3d +advanced-gui camera +dds debug +denoise
+lightmapper_cpu
+neon +optimize-speed +opensimplex optimize-size +portable +raycast
webxr"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm +webp" # encoding/container formats

IUSE+=" -mono" # for scripting languages

GODOT_JAVASCRIPT_=(wasm32)

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_JAVASCRIPT="${GODOT_JAVASCRIPT_[@]/#/godot_javascript_}"
IUSE+=" ${GODOT_JAVASCRIPT}"

IUSE+=" -closure-compiler -gdscript gdscript_lsp +javascript_eval
-javascript_threads -mono +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +gltf +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +upnp +webrtc +websocket" # for connections
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
# in master, sanitizers also applies to javascript
SANITIZERS=" asan lsan msan tsan ubsan"
IUSE+=" ${SANITIZERS}"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://docs.godotengine.org/en/3.4/development/compiling/compiling_for_web.html
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	portable
	denoise? ( lightmapper_cpu )
	gdscript_lsp? ( jsonrpc websocket )
	|| ( ${GODOT_JAVASCRIPT} )
	lsan? ( asan )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!asan
		!tsan
	)
"
EMSCRIPTEN_V="2.0.10"

LLVM_SLOTS=(13) # See https://github.com/godotengine/godot/blob/3.4-stable/misc/hooks/pre-commit-clang-format#L79
gen_cdepend_llvm() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				>=sys-devel/lld-${s}
			)
		"
	done
}

gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				 sys-devel/clang:${s}
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				 sys-devel/llvm:${s}
				=sys-libs/compiler-rt-sanitizers-${s}*[${san_type}]
			)
		"
	done
}
gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS} ; do
		echo "
			${a}? (
				|| (
					|| ( $(gen_clang_sanitizer ${a}) )
				)
			)
		"
	done
}

CDEPEND+="
	$(gen_cdepend_sanitizers)
	|| ( $(gen_cdepend_llvm) )
	!closure-compiler? (
		>=dev-util/emscripten-${EMSCRIPTEN_V}[wasm(+)]
	)
	closure-compiler? (
		>=dev-util/emscripten-${EMSCRIPTEN_V}[closure-compiler,closure_compiler_nodejs,wasm(+)]
	)
"

RDEPEND=" ${CDEPEND}"

DEPEND+="
	${CDEPEND}
	mono? (
		dev-games/godot-editor:${SLOT}[mono]
		=dev-games/godot-mono-runtime-wasm-$(ver_cut 1-2 ${MONO_PV})*:=
	)
"

BDEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
	dev-util/scons
"
S="${WORKDIR}/godot-${PV}-stable"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

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
eerror "The EMSCRIPTEN environmental variable must be set."
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
	check_emscripten

	python-any-r1_pkg_setup
	if use clang && use godot_javascript_wasm32 ; then
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
	einfo "Creating export templates"
	_configure_emscripten
	scons ${options_javascript[@]} \
		${options_modules[@]} \
		${options_modules_static[@]} \
		${options_extra[@]} \
		target=${configuration} \
		tools=no \
		|| die
}

set_production() {
	if [[ "${configuration}" == "release" ]] ; then
		echo "production=True"
	fi
}

src_compile_javascript_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_static=yes (default on this platform)
	# mono_glue=yes (default)
	local options_extra=(
		$(set_production)
		module_mono_enabled=yes
		mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/wasm"
		tools=no
	)
	_compile
}

src_compile_javascript_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_javascript()
{
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_javascript_yes_mono
		else
			src_compile_javascript_no_mono
		fi
	done
}

src_compile() {
	local myoptions=()
	local options_javascript=(
		platform=javascript
		javascript_eval=$(usex javascript_eval)
		threads_enabled=$(usex javascript_threads)
		use_lto=False
		use_closure_compiler=$(usex closure-compiler)
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
		builtin_pcre2_with_jit=False
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
		module_gdnative_enabled=False
		module_gdscript_enabled=$(usex gdscript)
		module_gltf_enabled=$(usex gltf)
		module_gridmap_enabled=$(usex gridmap)
		module_hdr_enabled=$(usex hdr)
		module_jpg_enabled=$(usex jpeg)
		module_jsonrpc_enabled=$(usex jsonrpc)
		module_lightmapper_cpu_enabled=$(usex lightmapper_cpu)
		module_mbedtls_enabled=False
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
	)

	src_compile_javascript
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

_get_configuration2() {
	local x="${1}"
	if [[ "${x}" =~ ".opt.debug" ]] ; then
		echo "opt.debug"
	elif [[ "${x}" =~ ".opt" ]] ; then
		echo "opt"
	else
		echo -n ""
	fi
}

_get_threads() {
	local x="${1}"
	local c
	if [[ "${x}" =~ "threads" ]] ; then
		echo "threads"
	else
		echo -n ""
	fi
}

_get_gdnative() {
	local x="${1}"
	local c
	if [[ "${x}" =~ "gdnative" ]] ; then
		echo "gdnative"
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
		local name="webassembly"
		local bitness=$(_get_bitness "${x}")
		local configuration=$(_get_configuration "${x}")
		local configuration2=$(_get_configuration2 "${x}")
		local threads=$(_get_threads "${x}")
		local gdnative=$(_get_gdnative "${x}")
		[[ "${threads}" =~ "gdnative" ]] && name+="_threads"
		[[ "${gdnative}" =~ "threads" ]] && name+="_gdnative"
		name+="_${configuration}.zip"
		if [[ "${x}" =~ "bin/godot" && "${x}" =~ "${configuration2}" && "${x}" =~ ".zip" ]] ; then
			newins "${x}" "${name}"
		fi
	done
}

src_install() {
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
