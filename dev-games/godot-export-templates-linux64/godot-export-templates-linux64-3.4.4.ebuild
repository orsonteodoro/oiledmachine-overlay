# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"
STATUS="stable"

MULTILIB_COMPAT=( abi_x86_64 )
PYTHON_COMPAT=( python3_{8..10} )
inherit desktop eutils flag-o-matic llvm multilib-build python-any-r1 scons-utils

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

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

KEYWORDS="~amd64 ~riscv"

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

IUSE+=" +3d +advanced-gui camera clang +dds debug +denoise
jit +lightmapper_cpu lld
lto +neon +optimize-speed +opensimplex optimize-size portable +raycast
"
IUSE+=" ca-certs-relax"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm webm-simd +webp" # encoding/container formats

IUSE+=" -mono" # for scripting languages

IUSE+=" -gdscript gdscript_lsp +mono +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +gltf +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +mbedtls +upnp +webrtc +websocket" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
IUSE+=" system-bullet system-embree system-enet system-freetype system-libogg
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp
system-libwebsockets system-mbedtls system-miniupnpc system-opus system-pcre2
system-recast system-squish system-wslay system-xatlas
system-zlib system-zstd"
SANITIZERS=" asan lsan msan tsan ubsan"
IUSE+=" ${SANITIZERS}"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	denoise? ( lightmapper_cpu )
	gdscript_lsp? ( jsonrpc websocket )
	lld? ( clang )
	lsan? ( asan )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!asan
		!system-bullet
		!system-embree
		!system-enet
		!system-freetype
		!system-libogg
		!system-libpng
		!system-libtheora
		!system-libvorbis
		!system-libvpx
		!system-libwebp
		!system-libwebsockets
		!system-mbedtls
		!system-miniupnpc
		!system-opus
		!system-pcre2
		!system-recast
		!system-squish
		!system-xatlas
		!system-zlib
		!system-zstd
		!tsan
	)
"
FREETYPE_V="2.10.4"
LIBOGG_V="1.3.5"
LIBVORBIS_V="1.3.7"
ZLIB_V="1.2.11"

LLVM_SLOTS=(12 13) # See https://github.com/godotengine/godot/blob/3.4-stable/misc/hooks/pre-commit-clang-format#L79
gen_cdepend_lto_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
				(
					sys-devel/clang:${s}[${MULTILIB_USEDEP}]
					sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
					>=sys-devel/lld-${s}
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
				 sys-devel/clang:${s}[${MULTILIB_USEDEP}]
				=sys-devel/clang-runtime-${s}[${MULTILIB_USEDEP},compiler-rt,sanitize]
				 sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				=sys-libs/compiler-rt-sanitizers-${s}*[${MULTILIB_USEDEP},${san_type}]
			)
		"
	done
	echo "${o}"
}

gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS} ; do
		echo "
	${a}? (
		|| (
			${CDEPEND_GCC_SANITIZER}
			clang? ( || ( $(gen_clang_sanitizer ${a}) ) )
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
	mono? (
		dev-games/godot-editor:${SLOT}[mono]
		>=dev-lang/mono-6.0.0.176
		dev-dotnet/dotnet-sdk-bin
	)
"
CDEPEND_CLANG="
	clang? (
		!lto? ( sys-devel/clang[${MULTILIB_USEDEP}] )
		lto? ( || ( $(gen_cdepend_lto_llvm) ) )
	)
"
CDEPEND_GCC="
	!clang? ( sys-devel/gcc[${MULTILIB_USEDEP}] )
"
# All dependencies are in the project.
DEPEND+="
	${PYTHON_DEPS}
	${CDEPEND}
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/flac[${MULTILIB_USEDEP}]
        >=media-libs/freetype-${FREETYPE_V}[${MULTILIB_USEDEP}]
	>=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	>=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}]
        media-sound/pulseaudio[${MULTILIB_USEDEP}]
	net-libs/libasyncns[${MULTILIB_USEDEP}]
	sys-apps/tcp-wrappers[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_V}[${MULTILIB_USEDEP}]
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
	!portable? (
		ca-certs-relax? (
			app-misc/ca-certificates[cacert]
		)
		!ca-certs-relax? (
			>=app-misc/ca-certificates-20211101[cacert]
		)
	)
        gamepad? ( virtual/libudev[${MULTILIB_USEDEP}] )
	system-bullet? ( >=sci-physics/bullet-3.17[${MULTILIB_USEDEP}] )
	system-enet? ( >=net-libs/enet-1.3.17[${MULTILIB_USEDEP}] )
	system-embree? ( >=media-libs/embree-3.13.0[${MULTILIB_USEDEP}] )
	system-freetype? ( >=media-libs/freetype-${FREETYPE_V}[${MULTILIB_USEDEP}] )
	system-libogg? ( >=media-libs/libogg-${LIBOGG_V}[${MULTILIB_USEDEP}] )
	system-libpng? ( >=media-libs/libpng-1.6.37[${MULTILIB_USEDEP}] )
	system-libtheora? ( >=media-libs/libtheora-1.1.1[${MULTILIB_USEDEP}] )
	system-libvorbis? ( >=media-libs/libvorbis-${LIBVORBIS_V}[${MULTILIB_USEDEP}] )
	system-libvpx? ( >=media-libs/libvpx-1.6.0[${MULTILIB_USEDEP}] )
	system-libwebp? ( >=media-libs/libwebp-1.1.0[${MULTILIB_USEDEP}] )
	system-mbedtls? ( >=net-libs/mbedtls-2.16.12[${MULTILIB_USEDEP}] )
	system-miniupnpc? ( >=net-libs/miniupnpc-2.2.2[${MULTILIB_USEDEP}] )
	system-opus? (
		>=media-libs/opus-1.1.5[${MULTILIB_USEDEP}]
		>=media-libs/opusfile-0.8[${MULTILIB_USEDEP}]
	)
	system-pcre2? ( >=dev-libs/libpcre2-10.36[${MULTILIB_USEDEP},jit?] )
	system-recast? ( dev-games/recastnavigation[${MULTILIB_USEDEP}] )
	system-squish? ( >=media-libs/libsquish-1.15[${MULTILIB_USEDEP}] )
	system-wslay? ( >=net-libs/wslay-1.1.1[${MULTILIB_USEDEP}] )
	system-xatlas? ( media-libs/xatlas[${MULTILIB_USEDEP}] )
	system-zlib? ( >=sys-libs/zlib-${ZLIB_V}[${MULTILIB_USEDEP}] )
	system-zstd? ( >=app-arch/zstd-1.4.8[${MULTILIB_USEDEP}] )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
	dev-util/scons
	lld? ( sys-devel/lld )
	webm-simd? (
		dev-lang/yasm
	)
"
S="${WORKDIR}/godot-${PV}-stable"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

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
		if has_version "sys-devel/clang:13" \
			&& has_version "sys-devel/llvm:13" ; then
			LLVM_MAX_SLOT=13
		elif has_version "sys-devel/clang:12" \
			&& has_version "sys-devel/llvm:12" ; then
			LLVM_MAX_SLOT=12
		elif has_version "sys-devel/clang:11" \
			&& has_version "sys-devel/llvm:11" ; then
			LLVM_MAX_SLOT=11
		else
eerror
eerror "Both sys-devel/clang:\${SLOT} and sys-devel/llvm:\${SLOT} must have the"
eerror "same slot.  LTO enabled for LLVM 11-13 for this series only."
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

src_prepare() {
	if use mono ; then
		cp -aT "/usr/share/${MY_PN}/${SLOT_MAJ}/mono-glue/x11/modules/mono/glue" \
			modules/mono/glue || die
	fi
}

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
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

src_compile_linux_yes_mono() {
	local options_extra
	einfo "Mono support:  Building temporary binary"
	options_extra=( module_mono_enabled=yes mono_glue=no tools=yes )
	_compile
	_gen_glue
	einfo "Mono support:  Building final binary"
	options_extra=( module_mono_enabled=yes tools=no )
	_compile
}

src_compile_linux_no_mono() {
	local options_extra=( module_mono_enabled=no tools=no )
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
	myoptions+=( production=$(usex !debug) )
	local options_linux=(
		platform=linux
	)
	local options_x11=(
		platform=x11
		pulseaudio=$(usex pulseaudio)
		udev=$(usex gamepad)
		touch=$(usex touch)
		use_asan=$(usex asan)
		use_lld=$(usex lld)
		use_llvm=$(usex clang)
		use_lto=$(usex lto)
		use_lsan=$(usex lsan)
		use_msan=$(usex msan)
		use_thinlto=$(usex lto)
		use_tsan=$(usex tsan)
		use_ubsan=$(usex ubsan)
	)
	local options_modules_shared=(
		builtin_bullet=$(usex !system-bullet)
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
		builtin_pcre2=$(usex !system-pcre2)
		builtin_opus=$(usex !system-opus)
		builtin_recast=$(usex !system-recast)
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
		builtin_pcre2_with_jit=$(usex jit)
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
	use mono && doins -r "${WORKDIR}/templates/"*
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
