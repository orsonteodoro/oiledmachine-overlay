# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# U22

# Ebuild for VisualScript visual programming language support

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

ANGLE_VULNERABILITY_HISTORY="BO HO IU IO OOBA OOBR OOBW TC UAF"
# It can collect GPS coords for geolocation based games or gamified app or the
# game engine can be used for app purposes not just games.
CFLAGS_HARDENED_USE_CASES="network server sensitive-data untrusted-data"
CFLAGS_HARDENED_VTABLE_VERIFY=1
ENET_VULNERABILITY_HISTORY="DOS"
FREETYPE_VULNERABILITY_HISTORY="CE HO IO SO UAF UM"
LIBPNG_VULNERABILITY_HISTORY="BO CE DOS HO IO NPD MC OOBR SO UAF UM"
LIBJPEG_TURBO_VULNERABILITY_HISTORY="BO CE DOS HO IO NPD OOBR SO UM"
LIBTHEORA_VULNERABILITY_HISTORY="IO"
LIBVORBIS_VULNERABILITY_HISTORY="BO CE DOS HO IO OOBR"
LIBWEBP_VULNERABILITY_HISTORY="DF HO IO UAF UM"
MBEDTLS_VULNERABILITY_HISTORY="DF DOS IO NPD OOBR SO UAF UM"
MINIUPNPC_VULNERABILITY_HISTORY="BO DOS"
PCRE2_VULNERABILITY_HISTORY="DOS"
TINYEXR_VULNERABILITY_HISTORY="DOS HO IO"
ZLIB_VULNERABILITY_HISTORY="BO CE DF"
ZSTD_VULNERABILITY_HISTORY="BO"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="
${ANGLE_VULNERABILITY_HISTORY}
${ENET_VULNERABILITY_HISTORY}
${FREETYPE_VULNERABILITY_HISTORY}
${LIBJPEG_TURBO_VULNERABILITY_HISTORY}
${LIBPNG_VULNERABILITY_HISTORY}
${LIBTHEORA_VULNERABILITY_HISTORY}
${LIBVORBIS_VULNERABILITY_HISTORY}
${MINIUPNPC_VULNERABILITY_HISTORY}
${PCRE2_VULNERABILITY_HISTORY}
${TINYEXR_VULNERABILITY_HISTORY}
${ZLIB_VULNERABILITY_HISTORY}
${ZSTD_VULNERABILITY_HISTORY}
CE IO SO
"
FRAMEWORK="4.5" # Target .NET Framework
VIRTUALX_REQUIRED="manual"

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse"
)

inherit godot-3.6
inherit cflags-hardened check-glibcxx-ver desktop flag-o-matic edo llvm python-any-r1 sandbox-changes scons-utils toolchain-funcs virtualx

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot editor"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="
	(
		Apache-2.0
		Bison-exception-2.2
		custom
		GPL-3
		BSD
		BSD-2
		MIT
	)
	(
		icu
		ISC
		Old-MIT
	)
	all-rights-reserved
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	CC0-1.0
	CC-BY-3.0
	CC-BY-4.0
	FTL
	ISC
	IJG
	LGPL-2.1
	MIT
	MPL-2.0
	OFL-1.1
	openssl
	Unlicense
	ZLIB
	|| (
		Apache-2.0
		MIT
	)
	|| (
		public-domain
		Unlicense
	)
	|| (
		public-domain
		MIT
		Unlicense
	)
"

# thirdparty/spirv-cross || ( Apache-2.0 MIT )
# thirdparty/misc/r128 - || ( public-domain Unlicense )
# thirdparty/misc/smolv || ( public-domain MIT Unlicense )
# thirdparty/misc/stb_rect_pack.h || ( public-domain MIT Unlicense )

# See https://github.com/godotengine/godot/blob/4.5-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# See https://github.com/godotengine/godot/blob/4.5-stable/platform/linuxbsd/detect.py#L76
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

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

SANITIZERS=(
	asan
	hwasan
	lsan
	msan
	tsan
	ubsan
)

IUSE_3D="
+bullet +csg +gltf +gridmap +lightmapper_cpu +mobile-vr
+raycast +vhacd +xatlas
"
IUSE_AUDIO="
+alsa +pulseaudio +speech
"
IUSE_BUILD="
${CPU_FLAGS_X86[@]}
${SANITIZERS[@]}
clang debug jit lld lto mold +optimize-speed optimize-size portable
sanitize-in-production +visual-script
"
IUSE_CONTAINERS_CODECS_FORMATS="
+bmp +cvtt +dds +etc +exr +fbx +hdr +jpeg +minizip -mp1
-mp2 +mp3 +ogg +opus +pvrtc +s3tc +svg +tga +theora +vorbis +webm +webp
"
IUSE_GUI="
+dbus -editor-splash +wayland +X
"
IUSE_INPUT="
camera -gamepad +touch
"
IUSE_LIBS="
+denoise
+freetype +navigation +opengl +opensimplex +pcre2 +squish
"
IUSE_NET="
ca-certs-relax +enet +jsonrpc +mbedtls +text-server-adv
+upnp +webrtc +websocket
"
IUSE_SCRIPTING="
csharp-external-editor -gdscript gdscript_lsp -mono monodevelop vscode
"
IUSE_SYSTEM="
system-bullet system-embree system-enet system-freetype
system-libogg system-libpng system-libtheora system-libvorbis
system-libwebp system-libwebsockets system-mbedtls system-miniupnpc
-system-mono system-opus system-pcre2 system-recastnavigation
system-squish system-libvpx system-wslay system-xatlas system-zlib system-zstd
"
IUSE+="
	${IUSE_3D}
	${IUSE_AUDIO}
	${IUSE_BUILD}
	${IUSE_CONTAINERS_CODECS_FORMATS}
	${IUSE_GUI}
	${IUSE_INPUT}
	${IUSE_LIBS}
	${IUSE_NET}
	${IUSE_SCRIPTING}
	${IUSE_SYSTEM}
	${LLVM_COMPAT[@]/#/llvm_slot_}
	ebuild_revision_15
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/4.5-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
# opengl - for fixing black screen
REQUIRED_USE+="
	freetype
	opengl
	pcre2
	svg
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	csharp-external-editor? (
		mono
		|| (
			monodevelop
			vscode
		)
	)
	gdscript_lsp? (
		jsonrpc
		websocket
	)
	lld? (
		clang
	)
	mp1? (
		mp3
	)
	mp2? (
		mp3
	)
	mono? (
		system-mono
	)
	optimize-size? (
		!optimize-speed
	)
	optimize-speed? (
		!optimize-size
	)
	portable? (
		!asan
		!hwasan
		!lsan
		!msan
		!system-bullet
		!system-embree
		!system-enet
		!system-freetype
		!system-libogg
		!system-libpng
		!system-libtheora
		!system-libvorbis
		!system-libwebp
		!system-libwebsockets
		!system-mbedtls
		!system-miniupnpc
		!system-mono
		!system-opus
		!system-pcre2
		!system-recastnavigation
		!system-squish
		!system-xatlas
		!system-zlib
		!system-zstd
		!sanitize-in-production
		!tsan
		!ubsan
	)
	riscv? (
		mono? (
			system-mono
		)
	)
	speech? (
		|| (
			alsa
			pulseaudio
		)
	)
	vscode? (
		csharp-external-editor
	)
	?? (
		asan
		hwasan
	)
"

gen_cdepend_lto_llvm() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=llvm-runtimes/clang-runtime-${s}[compiler-rt,sanitize]
				=llvm-runtimes/compiler-rt-sanitizers-${s}*:=[${san_type}]
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}
gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS[@]} ; do
		echo "
			${a}? (
				!clang? (
					sys-devel/gcc[sanitize]
				)
				clang? (
					$(gen_clang_sanitizer ${a})
				)
			)
		"
	done
}

CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"
CDEPEND+="
	${CDEPEND_SANITIZER}
	!dev-games/godot
	mono? (
		(
			>=dev-lang/mono-6.12.0
			dev-lang/mono:=
		)
		>=dev-dotnet/dotnet-sdk-bin-${DOTNET_SDK_PV}:${DOTNET_SDK_SLOT}
	)
"
CDEPEND_CLANG="
	clang? (
		!lto? (
			llvm-core/clang
		)
		lto? (
			$(gen_cdepend_lto_llvm)
		)
	)
"
CDEPEND_GCC="
	!clang? (
		>=sys-devel/gcc-${GCC_PV}
	)
"
DEPEND+="
	${PYTHON_DEPS}
	${CDEPEND}
        >=media-libs/freetype-${FREETYPE_PV}
	>=media-libs/libogg-${LIBOGG_PV}
	>=media-libs/libvorbis-${LIBVORBIS_PV}
	>=sys-libs/zlib-${ZLIB_PV}
	app-arch/bzip2
	dev-libs/libbsd
	media-libs/alsa-lib
	media-libs/flac
	media-libs/libpng
	media-libs/libsndfile
        media-sound/pulseaudio
	net-libs/libasyncns
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
        x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxshmfence
	!portable? (
		!ca-certs-relax? (
			>=app-misc/ca-certificates-${CA_CERTIFICATES_PV}[cacert]
		)
		ca-certs-relax? (
			app-misc/ca-certificates[cacert]
		)
	)
	dbus? (
		sys-apps/dbus
	)
        gamepad? (
		virtual/libudev
	)
	opengl? (
		virtual/opengl
	)
	speech? (
		!pulseaudio? (
			alsa? (
				|| (
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,espeak]
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,espeak]
					>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[alsa,flite]
				)
			)
		)
		pulseaudio? (
			|| (
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[espeak,pulseaudio]
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[espeak,pulseaudio]
				>=app-accessibility/speech-dispatcher-${SPEECH_DISPATCHER_PV}[flite,pulseaudio]
			)
		)
	)
	system-bullet? (
		>=sci-physics/bullet-${BULLET_PV}
	)
	system-enet? (
		>=net-libs/enet-${ENET_PV}
	)
	system-embree? (
		>=media-libs/embree-${EMBREE_PV}
	)
	system-freetype? (
		>=media-libs/freetype-${FREETYPE_PV}
	)
	system-libogg? (
		>=media-libs/libogg-${LIBOGG_PV}
	)
	system-libpng? (
		>=media-libs/libpng-${LIBPNG_PV}
	)
	system-libtheora? (
		>=media-libs/libtheora-${LIBTHEORA_PV}
	)
	system-libvorbis? (
		>=media-libs/libvorbis-${LIBVORBIS_PV}
	)
	system-libvpx? (
		>=media-libs/libvpx-${LIBVPX_PV}
	)
	system-libwebp? (
		>=media-libs/libwebp-${LIBWEBP_PV}
	)
	system-mbedtls? (
		>=net-libs/mbedtls-${MBEDTLS_PV}
	)
	system-miniupnpc? (
		>=net-libs/miniupnpc-${MINIUPNPC_PV}
	)
	system-opus? (
		>=media-libs/opus-${OPUS_PV}
	)
	system-pcre2? (
		>=dev-libs/libpcre2-${LIBPCRE2_PV}[jit?]
	)
	system-recastnavigation? (
		>=dev-games/recastnavigation-${RECASTNAVIGATION_PV}
	)
	system-squish? (
		>=dev-libs/squish-${SQUISH_PV}
	)
	system-wslay? (
		>=net-libs/wslay-${WSLAY_PV}
	)
	system-xatlas? (
		media-libs/xatlas
	)
	system-zlib? (
		>=sys-libs/zlib-${ZLIB_PV}
	)
	system-zstd? (
		>=app-arch/zstd-${ZSTD_PV}
	)
	wayland? (
		>=gui-libs/libdecor-0.1.0
	)
"
RDEPEND+="
	${DEPEND}
	mono? (
		csharp-external-editor? (
			|| (
				monodevelop? (
					|| (
						dev-dotnet/monodevelop-bin
						dev-dotnet/dotdevelop
					)
				)
				vscode? (
					app-editors/vscode
				)
			)
		)
	)
"
gen_bdepend_lld() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/lld:${s}
			)
		"
	done
}
BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		>=dev-build/scons-4.7.0[${PYTHON_USEDEP}]
	')
	>=dev-util/pkgconf-${PKGCONF_PV}[pkg-config(+)]
	lld? (
		$(gen_bdepend_lld)
	)
	mold? (
		sys-devel/mold
	)
	mono? (
		app-portage/gentoolkit
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
	wayland? (
		>=dev-util/wayland-scanner-1.20.0
	)
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
"
PATCHES=(
	"${FILESDIR}/godot-3.6-set-ccache-dir.patch"
	"${FILESDIR}/godot-3.6-sanitizers.patch"
	"${FILESDIR}/godot-4.3-optionalize-x86-flags.patch"
)

check_speech_dispatcher() {
	if use speech ; then
		if [[ ! -f "${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ]] ; then
eerror
eerror "Missing ${ESYSROOT}/etc/speech-dispatcher/speechd.conf"
eerror
			die
		fi
		if has_version "app-accessibility/speech-dispatcher[pulseaudio]" ; then
			if ! grep -q -e "^AudioOutputMethod.*\"pulse\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf"
eerror
eerror "AudioOutputMethod \"pulse\""
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[alsa]" ; then
			if ! grep -q -e "^AudioOutputMethod.*\"alsa\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AudioOutputMethod \"alsa\""
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		fi
		if has_version "app-accessibility/speech-dispatcher[espeak]" ; then
			if ! grep -q -e "^AddModule.*\"espeak-ng\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AddModule \"espeak-ng\"                \"sd_espeak-ng\" \"espeak-ng.conf\""
eerror "DefaultModule espeak-ng"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*espeak-ng" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule espeak-ng"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[espeak]" ; then
			if ! grep -q -e "^AddModule.*\"espeak\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "AddModule \"espeak\"                   \"sd_espeak\"    \"espeak.conf\""
eerror "DefaultModule espeak"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*espeak" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule espeak"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		elif has_version "app-accessibility/speech-dispatcher[flite]" ; then
			if ! grep -q -e "^AddModule.*\"flite\"" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "#AddModule \"flite\"                    \"sd_flite\"     \"flite.conf\""
eerror "DefaultModule flite"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
			if ! grep -q -e "^DefaultModule.*flite" \
				"${ESYSROOT}/etc/speech-dispatcher/speechd.conf" ; then
eerror
eerror "The following changes are required to"
eerror "${ESYSROOT}/etc/speech-dispatcher/speechd.conf:"
eerror
eerror "DefaultModule flite"
eerror
eerror "The ~/.config/speech-dispatcher/speechd.conf should be removed or have"
eerror "the same settings."
eerror
				die
			fi
		fi
	fi
}

pkg_setup() {
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
	if use gdscript ; then
ewarn "The gdscript USE flag is untested."
	fi

	python-any-r1_pkg_setup
	if use lto && use clang ; then
		LLVM_MAX_SLOT="not_found"
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if has_version "llvm-core/clang:${s}" \
				&& has_version "llvm-core/llvm:${s}" ; then
				LLVM_MAX_SLOT=${s}
				break
			fi
		done
		if [[ "${LLVM_MAX_SLOT}" == "not_found" ]] ; then
eerror
eerror "Both llvm-core/clang:\${SLOT} and llvm-core/llvm:\${SLOT} must have the"
eerror "same slot."
eerror
			die
		fi
einfo "LLVM_MAX_SLOT=${LLVM_MAX_SLOT} for LTO"
		llvm_pkg_setup
	fi

	if [[ "${LANG}" == "POSIX" ]] ; then
ewarn "LANG=POSIX not supported"
	fi

	if use mono ; then
einfo "USE=mono is under contruction"
		local p=$(ls "/opt/dotnet-sdk-bin-${DOTNET_SDK_SLOT}/dotnet" | head -n 1)
		export PATH="$(dirname ${p}):${PATH}"
		export DOTNET_CLI_TELEMETRY_OPTOUT=1

		sandbox-changes_no_network_sandbox "To download micropackages"
	fi

	use speech && check_speech_dispatcher
}

# In 2025, almost all free models use textures.
# In earlier decades, a significant number of free models didn't have textures.
warn_missing_texture_format() {
	#if use blend ; then
		use dds || ewarn ".blend models may require USE=dds"
		use exr || ewarn ".blend models may require USE=exr"
		use jpeg || ewarn ".blend models may require USE=jpeg"
		use tga || ewarn ".blend models may require USE=tga"
	#fi
	#if use collada ; then
		use jpeg || ewarn ".dae models may require USE=jpeg"
	#fi
	if use gltf ; then
		use jpeg || ewarn ".gltf models may require USE=jpeg"
		use webp || ewarn ".gltf models may require USE=webp"
	fi
	if use fbx ; then
		use jpeg || ewarn ".fbx models may require USE=jpeg"
		use tga || ewarn ".fbx models may require USE=tga"
	fi
	#if use obj ; then
		use jpeg || ewarn ".obj models may require USE=jpeg"
	#fi
	#if use escn ; then
	# From Blender's Godot-Blender-Exporter add-on
		use jpeg || ewarn ".escn models may require USE=jpeg"
		use tga || ewarn ".escn models may require USE=tga"
	#fi
}

src_configure() {
	default
	#cflags-hardened_append
	warn_missing_texture_format

	if tc-is-gcc ; then
		local gcc_pv=$(gcc-fullversion)
		if ver_test "${gcc_pv}" -lt "${GCC_PV}" ; then
eerror "Switch to >=sys-devel/gcc-${GCC_PV}"
			die
		fi
	fi
	if tc-is-clang ; then
		local clang_pv=$(clang-fullversion)
		local clang_pv_min="${LLVM_COMPAT[-1]}"
		if ver_test "${clang_pv}" -lt "${clang_pv_min}" ; then
eerror "Switch to >=llvm-core/clang-${clang_pv_min}"
			die
		fi
	fi
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
	if use mono ; then
		# mono_static=yes bug
		if use system-mono ; then
			# The code assumes unilib system not multilib.
			mkdir -p "${WORKDIR}/mono" || die
			ln -s "/usr/$(get_libdir)" "${WORKDIR}/mono/lib" || die
			ln -s "/usr/include" "${WORKDIR}/mono/include" || die
		fi
	fi
	if use sanitize-in-production ; then
# You can use UBSan and tc-malloc or scudo with GWP-ASan.
		if use asan || use hwasan ; then
			:
		else
ewarn "You are missing a address sanitizer for USE=sanitize-in-production."
ewarn "You are responsible for adding a LD_PRELOAD wrapper to a sample based address sanitizer (e.g. tc-malloc, scudo)."
		fi
		if ! use ubsan ; then
ewarn "You are missing the UBSan sanitizer for USE=sanitize-in-production."
		fi
	fi
}

_compile() {
	# Define lto here because scons does not evaluate lto= as steady-state.
	scons ${options_x11[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
		bits=default \
		target=${target} \
		${options_extra[@]} \
		lto=$(usex lto "thin" "none") \
		"CFLAGS=${CFLAGS}" \
		"CCFLAGS=${CXXFLAGS}" \
		"LINKFLAGS=${LDFLAGS}" || die
}

_gen_mono_glue() {
	# Sandbox violation prevention
	# * ACCESS DENIED:  mkdir:         /var/lib/portage/home/.cache
	export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache" # Prevent sandbox violation
	export MESA_SHADER_CACHE_DIR="${HOME}/mesa_shader_cache"
	for x in $(find /dev/input -name "event*") ; do
einfo "Adding \`addwrite ${x}\` sandbox rule"
		addwrite "${x}"
	done

einfo "Mono support:  Generating glue sources"
	# Generates modules/mono/glue/mono_glue.gen.cpp
	local f=$(basename "bin/godot"*"x11"*)
	virtx \
	bin/${f} \
		--audio-driver Dummy \
		--generate-mono-glue \
		"modules/mono/glue"
}

_assemble_datafiles_for_export_templates() {
einfo "Mono support:  Assembling data files"
	if [[ ! -e "bin/GodotSharp" ]] ; then
eerror
eerror "Missing export templates data directory.  It is likely caused by a"
eerror "crash while generating mono_glue.gen.cpp."
eerror
		die
	fi

	local src
	local dest
	src="${S}/bin/GodotSharp/Mono/lib/mono/${FRAMEWORK}"
	PLATFORM="Linux"
	if [[ "${PLATFORM}" == "Android" ]] ; then
		dest="${WORKDIR}/templates/bcl/monodroid"
	elif [[ "${PLATFORM}" == "iOS" ]] ; then
		dest="${WORKDIR}/templates/bcl/monotouch"
	elif [[ "${PLATFORM}" =~ ("Linux"|"macOS") ]] ; then
		dest="${WORKDIR}/templates/bcl/net_4_x"
	elif [[ "${PLATFORM}" == "WebAssembly" ]] ; then
		dest="${WORKDIR}/templates/bcl/wasm"
	elif [[ "${PLATFORM}" == "Windows" ]] ; then
		dest="${WORKDIR}/templates/bcl/net_4_x_win"
	fi
einfo "Mono support:  Collecting BCL for ${PLATFORM}"
	mkdir -p "${dest}"
	cp -aT "${src}" "${dest}" || die

	# You would expect it to be already packaged and ready to go.

	# Api (Missing)
	if [[ -e "${S}/bin/GodotSharp/Api" ]] ; then
		src="${S}/bin/GodotSharp/Api"
		dest="${WORKDIR}/templates/data.mono.x11.64.${configuration}/Api"
einfo "Mono support:  Collecting datafiles (Mono/Api)"
		mkdir -p "${dest}"
		cp -aT "${src}" "${dest}" || die
	fi

	# Mono/etc
	src="${S}/bin/GodotSharp/Mono/etc/mono"
	dest="${WORKDIR}/templates/data.mono.x11.64.${configuration}/Mono/etc/mono"
einfo "Mono support:  Collecting datafiles (Mono/etc)"
	mkdir -p "${dest}"
	cp -aT "${src}" "${dest}" || die


	# Mono/lib (Missing)
	if find "${S}/bin/GodotSharp" -name "libmono" -o -name "libMono" ; then
		src="${S}/bin/GodotSharp/Mono/etc/mono"
		dest="${WORKDIR}/templates/data.mono.x11.64.${configuration}/Mono/lib"
einfo "Mono support:  Collecting datafiles (Mono/lib)"
		mkdir -p "${dest}"
		for x in $(find "${S}/bin/GodotSharp" -name "libmono" -o -name "libMono") ; do
			cp -aT "${src}" "${dest}" || die
		done
	fi

	# Tools
	if [[ -e "${S}/bin/GodotSharp/Api" ]] ; then
		src="${S}/bin/GodotSharp/Tools"
		dest="${WORKDIR}/templates/data.mono.x11.64.${configuration}/Tools"
einfo "Mono support:  Collecting datafiles (Tools)"
		mkdir -p "${dest}"
		cp -aT "${src}" "${dest}" || die
	fi

	# FIXME:  libmonosgen-2.0.so needs 32-bit or static linkage
	if [[ -e "bin/libmonosgen-2.0.so" ]] ; then
		# Should be copied next to editor or export templates
einfo "Collecting monogens runtime library"
		cp -a "bin/libmonosgen-2.0.so" "${WORKDIR}/templates" || die
	fi
}

set_production() {
	if ! use debug ; then
		echo "production=True"
	fi
}

get_configuration3() {
	if use debug ; then
		echo "debug"
	else
		echo "release"
	fi
}

get_configuration4() {
	if use debug ; then
		echo "debug"
	else
		echo "release_debug"
	fi
}

add_portable_mono_prefix() {
	if ! use system-mono ; then
		if use amd64 ; then
			options_extra+=(
				copy_mono_root=yes
				mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-linux-x86_64-$(get_configuration3)" # Portable Mono base path
			)
		elif use x86 ; then
			options_extra+=(
				copy_mono_root=yes
				mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-linux-x86-$(get_configuration3)" # Portable Mono base path
			)
		fi
# Not supported due to a lack of time.
ewarn "You are linking to portable mono.  USE=-system-mono is not supported for this ebuild."
ewarn "Rebuild the system-mono as portable instead and set USE=system-mono"
		[[ -e "${mono_prefix}/include" ]] || die "Missing ${mono_prefix}/include"
		[[ -e "${mono_prefix}/lib" ]] || die "Missing ${mono_prefix}/lib"
	fi
}

src_compile_linux_yes_mono() {
einfo "Mono support:  Building the Mono glue generator"
	# tools=yes (default)
	# mono_glue=yes (default)
	local options_extra=(
		$(set_production)
		module_mono_enabled=yes
		mono_glue=no
	)
	add_portable_mono_prefix
	_compile
	_gen_mono_glue
	#_assemble_datafiles_for_export_templates
einfo "Mono support:  Building final binary"
	# CI adds mono_static=yes
	options_extra=(
		$(set_production)
		module_mono_enabled=yes

# Will re-enable once the godot-mono-runtime* is complete
#		mono_static=yes
#		mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/linux-x86_64"
	)
	add_portable_mono_prefix
	_compile
}

src_compile_linux_no_mono() {
einfo "Creating export template"
	# tools=yes (default)
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
	)
	_compile
}

src_compile_linux() {
	local target=$(get_configuration4)
	local configuration="debug"
einfo "Building Linux editor"
	if use mono ; then
		src_compile_linux_yes_mono
	else
		src_compile_linux_no_mono
	fi
}

get_linker() {
	if use lld ; then
		echo "lld"
	elif use mold ; then
		echo "mold"
	else
		echo "bfd"
	fi
}

src_compile() {
	local myoptions=()
	myoptions+=(
		production=$(usex !debug)
	)
	local options_linux=(
		lto=$(usex lto "thin" "none")
		platform="linuxbsd"
	)
	local options_x11=(
		platform="x11"
		alsa=$(usex alsa)
		dbus=$(usex dbus)
		libdecor=$(usex wayland)
		linker=$(get_linker)
		lto=$(usex lto)
		pulseaudio=$(usex pulseaudio)
		speechd=$(usex speech)
		touch=$(usex touch)
		udev=$(usex gamepad)
		use_asan=$(usex asan)
		use_hwasan=$(usex hwasan)
		use_llvm=$(usex clang)
		use_lsan=$(usex lsan)
		use_msan=$(usex msan)
		use_sanitize_in_production=$(usex sanitize-in-production)
		use_tsan=$(usex tsan)
		use_ubsan=$(usex ubsan)
		wayland=$(usex wayland)
		x11=$(usex X)
	)
	local options_modules_shared=(
		builtin_bullet=$(usex !system-bullet)
		builtin_certs=$(usex portable)
		builtin_embree=$(usex !system-embree)
		builtin_enet=$(usex !system-enet)
		builtin_freetype=$(usex !system-freetype)
		builtin_libogg=$(usex !system-libogg)
		builtin_libpng=$(usex !system-libpng)
		builtin_libtheora=$(usex !system-libtheora)
		builtin_libvorbis=$(usex !system-libvorbis)
		builtin_libvpx=$(usex !system-libvpx)
		builtin_libwebp=$(usex !system-libwebp)
		builtin_mbedtls=$(usex !system-mbedtls)
		builtin_miniupnpc=$(usex !system-miniupnpc)
		builtin_opus=$(usex !system-opus)
		builtin_pcre2=$(usex !system-pcre2)
		builtin_recast=$(usex !system-recastnavigation)
		builtin_rvo2_2d=True
		builtin_rvo2_3d=True
		builtin_squish=True # $(usex !system-squish) # Missing?
		builtin_wslay=$(usex !system-wslay)
		builtin_xatlas=$(usex !system-xatlas)
		builtin_zlib=$(usex !system-zlib)
		builtin_zstd=$(usex !system-zstd)
		pulseaudio=$(usex pulseaudio)
		use_static_cpp=$(usex portable)
		$(usex portable "" "system_certs_path=/etc/ssl/certs/ca-certificates.crt")
	)
	local options_modules_static=(
		builtin_bullet=True
		builtin_certs=True
		builtin_embree=True
		builtin_enet=True
		builtin_freetype=True
		builtin_libjpeg_turbo=True
		builtin_libogg=True
		builtin_libpng=True
		builtin_libtheora=True
		builtin_libvorbis=True
		builtin_libvpx=True
		builtin_libwebp=True
		builtin_mbedtls=True
		builtin_miniupnpc=True
		builtin_opus=True
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
		myoptions+=(
			optimize=size
		)
	else
		myoptions+=(
			optimize=speed
		)
	fi

	options_modules+=(
		builtin_pcre2_with_jit=$(usex jit)
		cpu_flags_x86_sse2=$(usex cpu_flags_x86_sse2)
		cpu_flags_x86_sse=$(usex cpu_flags_x86_sse)
		minimp3_extra_formats=$(usex mp2 True $(usex mp1 True False))
		minizip=$(usex minizip)
		no_editor_splash=$(usex !editor-splash)
		opengl3=$(usex opengl)
		module_bullet_enabled=$(usex bullet)
		module_bmp_enabled=$(usex bmp)
		module_camera_enabled=$(usex camera)
		module_csg_enabled=$(usex csg)
		module_cvtt_enabled=$(usex cvtt)
		module_dds_enabled=$(usex dds)
		module_denoise_enabled=$(usex denoise)
		module_enet_enabled=$(usex enet)
		module_etc_enabled=$(usex etc)
		module_fbx_enabled=$(usex fbx)
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
		module_navigation_enabled=$(usex navigation)
		module_ogg_enabled=$(usex ogg)
		module_opensimplex_enabled=$(usex opensimplex)
		module_opus_enabled=$(usex opus)
		module_pvr_enabled=$(usex pvrtc)
		module_raycast_enabled=$(usex raycast)
		module_regex_enabled=$(usex pcre2)
		module_squish_enabled=$(usex squish)
		module_stb_vorbis_enabled=$(usex vorbis)
		module_svg_enabled=$(usex svg)
		module_tga_enabled=$(usex tga)
		module_theora_enabled=$(usex theora)
		module_tinyexr_enabled=$(usex exr)
		module_upnp_enabled=$(usex upnp)
		module_vhacd_enabled=$(usex vhacd)
		module_visual_script_enabled=$(usex visual-script)
		module_vorbis_enabled=$(usex vorbis)
		module_webm_enabled=$(usex webm)
		module_webp_enabled=$(usex webp)
		module_webrtc_enabled=$(usex webrtc)
		module_websocket_enabled=$(usex websocket)
		module_webxr_enabled=False
		module_xatlas_unwrap_enabled=$(usex xatlas)
	)

	src_compile_linux
}

_install_linux_editor() {
	local d_base="/usr/$(get_libdir)/${MY_PN}/${SLOT_MAJ}"
	exeinto "${d_base}/bin"
	local f
	f=$(basename "bin/godot"*"x11"*)
	doexe "bin/${f}"
	dosym \
		"${d_base}/bin/${f}" \
		"/usr/bin/godot${SLOT_MAJ}"
einfo "Setting up Linux editor environment"
	make_desktop_entry \
		"/usr/bin/godot${SLOT_MAJ}" \
		"Godot${SLOT_MAJ}" \
		"/usr/share/pixmaps/godot${SLOT_MAJ}.png" \
		"Development;IDE"
	newicon "icon.png" "godot${SLOT_MAJ}.png"
}

_install_template_datafiles() {
	local prefix
	if use mono ; then
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/mono"
		insinto "${prefix}"
		doins -r "${WORKDIR}/templates"
		echo "${PV}.${STATUS}.mono" > "${T}/version.txt" || die
		insinto "${prefix}/templates"
		doins "${T}/version.txt"
	else
		prefix="/usr/share/godot/${SLOT_MAJ}/export-templates/standard"
		insinto "${prefix}"
		echo "${PV}.${STATUS}" > "${T}/version.txt" || die
		insinto "${prefix}/templates"
		doins "${T}/version.txt"
	fi
}

_install_mono_glue() {
	local prefix="/usr/share/${MY_PN}/${SLOT_MAJ}/mono-glue"
	insinto "${prefix}/modules/mono/glue"
	doins "modules/mono/glue/mono_glue.gen.cpp"
	insinto "${prefix}/modules/mono/glue/GodotSharp/GodotSharp"
	doins -r "modules/mono/glue/GodotSharp/GodotSharp/Generated"
	insinto "${prefix}/modules/mono/glue/GodotSharp/GodotSharpEditor"
	doins -r "modules/mono/glue/GodotSharp/GodotSharpEditor/Generated"
}

_install_editor_data_files() {
	local d_base="/usr/$(get_libdir)/${MY_PN}/${SLOT_MAJ}"
	insinto "${d_base}/bin"
	exeinto "${d_base}/bin"
	doins -r "bin/GodotSharp"
	doexe "bin/libmonosgen-2.0.so"
	if use system-mono ; then
		dodir "/usr/$(get_libdir)/godot/3/GodotSharp/Mono"
		IFS=$'\n'
		local L=(
			$(equery f mono)
		)
		local src_path
		for src_path in "${L[@]}" ; do
			if [[ "${src_path}" =~ ^"/usr/lib/" ]] ; then
				:
			elif [[ "${src_path}" =~ ^"/usr/lib64/" ]] ; then
				:
			elif [[ "${src_path}" =~ ^"/usr/include/" ]] ; then
				:
			elif [[ "${src_path}" =~ ^"/usr/bin/" ]] ; then
				:
			else
				continue
			fi
			local new_prefix="/usr/$(get_libdir)/godot/${SLOT_MAJ}/bin/GodotSharp/Mono"
			local new_path=$(echo "${src_path}" | sed -e "s|^/usr|${new_prefix}|")
			local d=$(dirname "${new_path}")
			dodir "${d}"
			cp -a "${src_path}" "${ED}/${new_path}" || die
		done
		IFS=$' \t\n'
	fi
}

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	_install_linux_editor
	use mono && _install_editor_data_files
	#_install_template_datafiles
	use mono && _install_mono_glue
}

pkg_postinst() {
	if use csharp-external-editor ; then
einfo
einfo "Instructions in setting up the external editor can be found at:"
einfo
einfo "  https://docs.godotengine.org/en/$(ver_cut 1-2 ${PV})/tutorials/scripting/c_sharp/c_sharp_basics.html#configuring-an-external-editor"
einfo
	fi
	if use asan || use hwasan || use lsan || use msan || use tsan ; then
ewarn
ewarn "You need to rebuild this package if the sanitizer package is updated or"
ewarn "removed to prevent a denial of service since the build scripts do not"
ewarn "statically link the sanitizer libraries."
ewarn
	fi
ewarn "VisualScript support has been dropped in the 4.x series.  Please convert your code to GDScript or C#."
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  mono, csharp, split-packages, multiplatform, portable-games, multislot
# OILEDMACHINE-OVERLAY-TEST:  PASSED (4.5, 20250922)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.6, 20250923)
# Hello World test:  passed
# GDScript:  passed
# C# Hello world test:  passed
