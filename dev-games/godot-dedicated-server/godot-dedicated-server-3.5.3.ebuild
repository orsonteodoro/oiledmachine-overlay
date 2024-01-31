# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

inherit godot-3.5
inherit desktop flag-o-matic llvm python-any-r1 scons-utils

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot built as a Linux dedicated server"
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

# See https://github.com/godotengine/godot/blob/3.5.2-stable/thirdparty/README.md for Apache-2.0 licensed third party.

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
	Apache-2.0
	BSD
	DOTNET-libraries-and-runtime-components-patents
	IDPL
	ISC
	LGPL-2.1
	Mono-patents
	MPL-1.1
	openssl
	OSL-1.1
"
# Apache-2.0 MPL-1.1 -- mcs/class/RabbitMQ.Client/src/client/events/ModelShutdownEventHandler.cs (RabbitMQ.Client.dll)
# ISC BSD openssl - btls=on
LICENSE+=" mono? ( ${MONO_LICENSE} )"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

KEYWORDS="~amd64 ~riscv ~x86"

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

SANITIZERS=(
	asan
	lsan
	msan
	tsan
	ubsan
)

IUSE_3D="
+3d +bullet +csg +denoise +gltf +gridmap +lightmapper_cpu +mobile-vr +raycast
+recast +vhacd +xatlas
"
IUSE_BUILD="
${SANITIZERS[@]}
clang debug lld jit lto +neon +optimize-speed optimize-size portable
"
IUSE_CONTAINERS_CODECS_FORMATS="
+bmp +cvtt +dds +etc +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +s3tc +svg
+tga +theora +vorbis +webm webm-simd +webp
"
IUSE_GUI="
+advanced-gui
"
IUSE_INPUT="
camera
"
IUSE_LIBS="
+freetype +pcre2 +opensimplex
"
IUSE_NET="
ca-certs-relax +enet +jsonrpc +mbedtls +upnp +webrtc +websocket
"
IUSE_SCRIPTING="
-gdscript gdscript_lsp +mono +visual-script
"
IUSE_SYSTEM="
system-bullet system-embree system-enet system-freetype system-libogg
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp
system-libwebsockets system-mbedtls system-miniupnpc system-mono system-opus
system-pcre2 system-recast system-squish system-wslay system-zlib system-zstd
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
	${IUSE_SYSTEM}
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
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
		!system-mono
		!system-opus
		!system-pcre2
		!system-squish
		!system-zlib
		!system-zstd
		!tsan
	)
	riscv? (
		mono? (
			system-mono
		)
	)
"

gen_cdepend_lto_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				>=sys-devel/lld-${s}
			)
		"
	done
	echo -e "${o}"
}

gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				=sys-libs/compiler-rt-sanitizers-${s}*:=[${san_type}]
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
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


CDEPEND_GCC_SANITIZER="
	!clang? (
		sys-devel/gcc[sanitize]
	)
"
CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"
CDEPEND+="
	${CDEPEND_SANITIZER}
"
CDEPEND_CLANG="
	clang? (
		!lto? (
			sys-devel/clang
		)
		lto? (
			|| (
				$(gen_cdepend_lto_llvm)
			)
		)
	)
"
CDEPEND_GCC="
	!clang? ( sys-devel/gcc )
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
	net-libs/libasyncns
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	virtual/opengl
	mono? (
		!system-mono? (
			|| (
				amd64? (
					=dev-games/godot-mono-runtime-linux-x86_64-$(ver_cut 1-2 ${MONO_PV})*
				)
				x86? (
					=dev-games/godot-mono-runtime-linux-x86-$(ver_cut 1-2 ${MONO_PV})*
				)
			)
		)
		system-mono? (
			=dev-lang/mono-$(ver_cut 1-2 ${MONO_PV})*
		)
	)
	!portable? (
		!ca-certs-relax? (
			>=app-misc/ca-certificates-${CA_CERTIFICATES_PV}[cacert]
		)
		ca-certs-relax? (
			app-misc/ca-certificates[cacert]
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
		>=media-libs/opusfile-${OPUSFILE_PV}
	)
	system-pcre2? (
		>=dev-libs/libpcre2-${LIBPCRE2_PV}[jit?]
	)
	system-squish? (
		>=media-libs/libsquish-${LIBSQUISH_PV}
	)
	system-wslay? (
		>=net-libs/wslay-${WSLAY_PV}
	)
	system-zlib? (
		>=sys-libs/zlib-${ZLIB_PV}
	)
	system-zstd? (
		>=app-arch/zstd-${ZSTD_PV}
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/pkgconf-${PKGCONF_PV}[pkg-config(+)]
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
	"${FILESDIR}/godot-3.2.3-add-lld-thinlto-to-platform-server.patch"
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
	einfo "Building dedicated gaming server"
	scons ${options_server[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
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

get_configuration3() {
	if [[ "${configuration}" =~ "debug" ]] ; then
		echo "debug"
	elif [[ "${configuration}" =~ "release" ]] ; then
		echo "release"
	else
		echo ""
	fi
}

src_compile_server_yes_mono() {
	einfo "Mono support:  Building final binary"
	# mono_glue=yes (default)
	# CI puts mono_glue=no without reason.
	# There must be a good reason?
	# Either for faster testing or security
	local options_extra=(
		$(set_production)
		module_mono_enabled=yes
		mono_glue=no
		mono_static=yes
		tools=no
	)
	if ! use system-mono ; then
		if use amd64 ; then
			options_extra+=(
				copy_mono_root=yes
				mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-linux-x86_64-$(get_configuration3)"
			)
		elif use x86 ; then
			options_extra+=(
				copy_mono_root=yes
				mono_prefix="/usr/lib/godot/${SLOT_MAJ}/mono-runtime/desktop-linux-x86-$(get_configuration3)"
			)
		fi
	fi
	_compile
}

src_compile_server_no_mono() {
	local options_extra=(
		$(set_production)
		module_mono_enabled=no
		tools=no
	)
	_compile
}

src_compile_server() {
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating export template"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		if use mono ; then
			einfo "USE=mono is under contruction"
			src_compile_server_yes_mono
		else
			src_compile_server_no_mono
		fi
	done
}

src_compile() {
	local myoptions=()
	#myoptions+=(
	#	production=$(usex !debug)
	#)
	local options_server=(
		platform=server
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
		builtin_xatlas=True
		builtin_zlib=$(usex !system-zlib)
		builtin_zstd=$(usex !system-zstd)
		pulseaudio=False
		use_static_cpp=$(usex portable)
		builtin_certs=$(usex portable)
		$(usex portable "" \
"system_certs_path=/etc/ssl/certs/ca-certificates.crt")
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

	src_compile_server
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

_install_server() {
	# NO EXPORT TEMPLATE
	local d="/usr/$(get_libdir)/godot/${SLOT_MAJ}/bin/dedicated-server"
	exeinto "${d}"
	einfo "Installing export templates"
	local x
	for x in $(find bin -type f) ; do
		[[ "${x}" =~ "godot_server" ]] || continue
		local configuration=$(_get_configuration "${x}")
		local p="${x}"
		doexe "${p}"
		dosym "${d}/$(basename ${x})" \
			/usr/bin/godot-dedicated-server-${configuration}
		if [[ "${x}" =~ "release" ]] ; then
			dosym "${d}/$(basename ${x})" \
				/usr/bin/godot-dedicated-server
		fi
	done
}

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	_install_server
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
