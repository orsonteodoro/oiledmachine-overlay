# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

MULTILIB_COMPAT=( abi_x86_64 )
inherit godot-4.1
inherit desktop flag-o-matic llvm multilib-build python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot export template for Linux (64-bit)"
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
#KEYWORDS="" # Ebuild not recently tested

# See https://github.com/godotengine/godot/blob/4.0.1-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# Listed because of possible mono_static=yes
MONO_LICENSE="
	MIT
	Apache-2.0
	BoringSSL-ECC
	BoringSSL-PSK
	BSD
	DOTNET-libraries-and-runtime-components-patents
	IDPL
	ISC
	LGPL-2.1
	LGPL-2.1-with-linking-exception
	Mono-patents
	MPL-1.1
	openssl
	OSL-1.1
"
# Apache-2.0 MPL-1.1 -- mcs/class/RabbitMQ.Client/src/client/events/ModelShutdownEventHandler.cs (RabbitMQ.Client.dll)
# BSD-4 openssl - btls=on
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# openssl - external/boringssl/crypto/ecdh/ecdh.c (libmono-btls-shared.dll)
LICENSE+=" mono? ( ${MONO_LICENSE} )"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

KEYWORDS="~amd64 ~riscv"

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
+3d +csg +denoise +glslang +gltf +gridmap +lightmapper_rd +mobile-vr
+msdfgen +openxr +raycast +recast +vhacd +xatlas
"
IUSE_AUDIO="
+alsa +pulseaudio +speech
"
IUSE_BUILD="
${SANITIZERS[@]}
clang debug jit lld lto +neon +optimize-speed optimize-size portable
"
IUSE_CONTAINERS_CODECS_FORMATS="
+astc +bmp +brotli +cvtt +dds +etc +exr +hdr +jpeg +minizip +mp3 +ogg
+pvrtc +s3tc +svg +tga +theora +vorbis +webp
"
IUSE_GUI="
+advanced-gui +dbus
"
IUSE_INPUT="
camera -gamepad +touch
"
IUSE_LIBS="
+freetype +graphite +opensimplex +pcre2 +volk +vulkan
"
IUSE_NET="
ca-certs-relax +enet +jsonrpc +mbedtls +multiplayer +text-server-adv
-text-server-fb +upnp +webrtc +websocket
"
IUSE_SCRIPTING="
-gdscript gdscript_lsp +mono +visual-script
"
IUSE_SYSTEM="
system-brotli system-embree system-enet system-freetype
system-glslang system-icu system-libogg system-libpng system-libtheora
system-libvorbis system-libwebp system-libwebsockets
system-mbedtls system-miniupnpc system-mono system-msdfgen system-openxr
system-pcre2 system-recast system-squish system-wslay system-xatlas
system-zlib system-zstd
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
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	denoise? (
		lightmapper_rd
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
		!system-embree
		!system-enet
		!system-freetype
		!system-glslang
		!system-icu
		!system-libogg
		!system-libpng
		!system-libtheora
		!system-libvorbis
		!system-libwebp
		!system-libwebsockets
		!system-mbedtls
		!system-miniupnpc
		!system-mono
		!system-msdfgen
		!system-pcre2
		!system-recast
		!system-squish
		!system-xatlas
		!system-zlib
		!system-zstd
		!tsan
		vulkan? (
			volk
		)
	)
	riscv? (
		mono? ( system-mono )
	)
	speech? (
		|| (
			alsa
			pulseaudio
		)
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
	!clang? ( sys-devel/gcc[sanitize] )
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

CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"
# Some people on riscv or arm64 may want to export to x86_64
CDEPEND+="
	${CDEPEND_SANITIZER}
	mono? (
		dev-games/godot-editor:${SLOT}[mono]
		!system-mono? (
			=dev-games/godot-mono-runtime-linux-x86_64-$(ver_cut 1-2 ${MONO_PV})*
		)
		system-mono? (
			=dev-games/godot-mono-runtime-linux-x86_64-$(ver_cut 1-2 ${MONO_PV})*
		)
	)
"
DISABLED_CDEPEND="
	mono? (
		system-mono? (
			=dev-lang/mono-$(ver_cut 1-2 ${MONO_PV})*
			>=dev-lang/mono-${MONO_PV_MIN}
		)
	)
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
	!clang? ( sys-devel/gcc[${MULTILIB_USEDEP}] )
"
# All dependencies are in the project.
DEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	!portable? (
		!ca-certs-relax? (
			>=app-misc/ca-certificates-${CA_CERTIFICATES_PV}[cacert]
		)
		ca-certs-relax? (
			app-misc/ca-certificates[cacert]
		)
	)
        >=media-libs/freetype-${FREETYPE_PV}[${MULTILIB_USEDEP}]
	>=media-libs/libogg-${LIBOGG_PV}[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-${LIBVORBIS_PV}[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
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
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	dbus? (
		sys-apps/dbus
	)
        gamepad? (
		virtual/libudev[${MULTILIB_USEDEP}]
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
	system-brotli? (
		>=app-arch/brotli-${BROTLI_PV}[${MULTILIB_USEDEP}]
	)
	system-enet? (
		>=net-libs/enet-${ENET_PV}[${MULTILIB_USEDEP}]
	)
	system-embree? (
		>=media-libs/embree-${EMBREE_PV}[${MULTILIB_USEDEP}]
	)
	system-freetype? (
		>=media-libs/freetype-${FREETYPE_PV}[${MULTILIB_USEDEP}]
	)
	system-glslang? (
		>=dev-util/glslang-${GLSLANG_PV}[${MULTILIB_USEDEP}]
	)
	system-icu? (
		>=dev-libs/icu-${ICU_PV}
	)
	system-libogg? (
		>=media-libs/libogg-${LIBOGG_PV}[${MULTILIB_USEDEP}]
	)
	system-libpng? (
		>=media-libs/libpng-${LIBPNG_PV}[${MULTILIB_USEDEP}]
	)
	system-libtheora? (
		>=media-libs/libtheora-${LIBTHEORA_PV}[${MULTILIB_USEDEP}]
	)
	system-libvorbis? (
		>=media-libs/libvorbis-${LIBVORBIS_PV}[${MULTILIB_USEDEP}]
	)
	system-libwebp? (
		>=media-libs/libwebp-${LIBWEBP_PV}[${MULTILIB_USEDEP}]
	)
	system-mbedtls? (
		>=net-libs/mbedtls-${MBEDTLS_PV}[${MULTILIB_USEDEP}]
	)
	system-miniupnpc? (
		>=net-libs/miniupnpc-${MINIUPNPC_PV}[${MULTILIB_USEDEP}]
	)
	system-msdfgen? (
		>=media-libs/msdfgen-${MSDFGEN_PV}[${MULTILIB_USEDEP}]
	)
	system-openxr? (
		>=media-libs/openxr-${OPENXR_PV}
	)
	system-pcre2? (
		>=dev-libs/libpcre2-${LIBPCRE2_PV}[${MULTILIB_USEDEP},jit?]
	)
	system-recast? (
		>=dev-games/recastnavigation-${RECASTNAVIGATION_PV}[${MULTILIB_USEDEP}]
	)
	system-squish? (
		>=media-libs/libsquish-${LIBSQUISH_PV}[${MULTILIB_USEDEP}]
	)
	system-wslay? (
		>=net-libs/wslay-${WSLAY_PV}[${MULTILIB_USEDEP}]
	)
	system-xatlas? (
		media-libs/xatlas[${MULTILIB_USEDEP}]
	)
	system-zlib? (
		>=sys-libs/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}]
	)
	system-zstd? (
		>=app-arch/zstd-${ZSTD_PV}[${MULTILIB_USEDEP}]
	)
	vulkan? (
		media-libs/vulkan-loader[${MULTILIB_USEDEP},X]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/pkgconf-${PKGCONF_PV}[${MULTILIB_USEDEP},pkg-config(+)]
	dev-build/scons
	lld? (
		sys-devel/lld
	)
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
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
ewarn
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
ewarn
	if use gdscript ; then
ewarn
ewarn "The gdscript USE flag is untested."
ewarn
	fi

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

	if use mono ; then
		einfo "USE=mono is under contruction"
		if ls /opt/dotnet-sdk-bin-*/dotnet 2>/dev/null 1>/dev/null ; then
			local p=$(ls /opt/dotnet-sdk-bin-*/dotnet | head -n 1)
			export PATH="$(dirname ${p}):${PATH}"
		else
eerror
eerror "Could not find dotnet.  Emerge dev-dotnet/dotnet-sdk-bin"
eerror
			die
		fi
		export DOTNET_CLI_TELEMETRY_OPTOUT=1

		if has network-sandbox ${FEATURES} ; then
eerror
eerror "Mono support requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
			die
		fi
	fi

	use speech && check_speech_dispatcher
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
	if use mono ; then
		# mono_static=yes bug
		if use system-mono ; then
			# The code assumes unilib system not multilib.
			mkdir -p "${WORKDIR}/mono" || die
			ln -s "/usr/$(get_libdir)" "${WORKDIR}/mono/lib" || die
			ln -s "/usr/include" "${WORKDIR}/mono/include" || die
		fi
	fi
}

_compile() {
	einfo "Building for 64-bit Linux"
	scons ${options_x11[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
		${options_extra[@]} \
		bits=${bitness} \
		target=${configuration} \
		tools=no \
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

src_compile_linux_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_glue=yes (default)
	# mono_static=yes ; CI uses this
	local options_extra=(
		$(set_production)
		copy_mono_root=yes
		module_mono_enabled=yes
		mono_static=yes
		tools=no
	)
	if ! use system-mono ; then
		if use amd64 ; then
			options_extra+=(
				copy_mono_root=yes
				mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-linux-x86_64-$(get_configuration3)"
			)
		fi
	fi
	_compile
}

src_compile_linux_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_linux() {
	local bitness=64
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			src_compile_linux_yes_mono
		else
			src_compile_linux_no_mono
		fi
	done
}

src_compile() {
	local myoptions=()
	local options_linux=(
		platform=linux
	)
	local options_x11=(
		platform=x11
		dbus=$(usex dbus)
		pulseaudio=$(usex pulseaudio)
		udev=$(usex gamepad)
		touch=$(usex touch)
		use_alsa=$(usex alsa)
		use_asan=$(usex asan)
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_lsan=$(usex lsan)
		use_msan=$(usex msan)
		use_speechd=$(usex speech)
		use_thinlto=$(usex lto)
		use_tsan=$(usex tsan)
		use_ubsan=$(usex ubsan)
		use_volk=$(usex volk)
		vulkan=$(usex vulkan)
	)
	local options_modules_shared=(
		builtin_brotli=$(usex !system-brotli)
		builtin_embree=$(usex !system-embree)
		builtin_enet=$(usex !system-enet)
		builtin_freetype=$(usex !system-freetype)
		builtin_glslang=$(usex !system-glslang)
		builtin_libogg=$(usex !system-libogg)
		builtin_libpng=$(usex !system-libpng)
		builtin_libtheora=$(usex !system-libtheora)
		builtin_libvorbis=$(usex !system-libvorbis)
		builtin_libwebp=$(usex !system-libwebp)
		builtin_mbedtls=$(usex !system-mbedtls)
		builtin_miniupnpc=$(usex !system-miniupnpc)
		builtin_msdfgen=$(usex !system-msdfgen)
		builtin_pcre2=$(usex !system-pcre2)
		builtin_openxr=$(usex !system-openxr)
		builtin_recast=$(usex !system-recast)
		builtin_rvo2=True
		builtin_squish=$(usex !system-squish)
		builtin_wslay=$(usex !system-wslay)
		builtin_xatlas=$(usex !system-xatlas)
		builtin_zlib=$(usex !system-zlib)
		builtin_zstd=$(usex !system-zstd)
		pulseaudio=$(usex pulseaudio)
		use_static_cpp=$(usex portable)
		builtin_certs=$(usex portable)
		$(usex portable "" \
"system_certs_path=/etc/ssl/certs/ca-certificates.crt")
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

	src_compile_linux
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
	for x in $(find bin -maxdepth 1 | sed -e "1d") ; do
		local bitness=$(_get_bitness "${x}")
		local configuration=$(_get_configuration "${x}")
		if [[ "${x}" =~ "bin/godot" && "${x}" == "${configuration}" ]] ; then
			newexe "${x}" "linux_x11_${bitness}_${configuration}"
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
