# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"

CFLAGS_HARDENED_USE_CASES="network server untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE IO SO"
FRAMEWORK="4.5" # Target .NET Framework
VIRTUALX_REQUIRED="manual"

inherit godot-3.5
inherit cflags-hardened desktop flag-o-matic llvm python-any-r1 sandbox-changes scons-utils virtualx

SRC_URI="
	https://github.com/godotengine/${MY_PN}/archive/${PV}-${STATUS}.tar.gz -> ${MY_P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/godot-${PV}-${STATUS}"

DESCRIPTION="Godot editor"
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

KEYWORDS="~amd64 ~riscv ~x86"
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
clang debug jit lld lto +neon +optimize-speed optimize-size portable
"
IUSE_CONTAINERS_CODECS_FORMATS="
+bmp +dds +etc +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +s3tc +svg
+tga +theora +vorbis +webm webm-simd +webp
"
IUSE_GUI="
+advanced-gui
"
IUSE_INPUT="
camera -gamepad +touch
"
IUSE_LIBS="
+cvtt +freetype +opensimplex +pcre2 +pulseaudio
"
IUSE_NET="
ca-certs-relax +enet +jsonrpc +mbedtls +upnp +webrtc +websocket
"
IUSE_SCRIPTING="
csharp-external-editor -gdscript gdscript_lsp -mono monodevelop +visual-script
vscode
"
IUSE_SYSTEM="
system-bullet system-embree system-enet system-freetype system-libogg
system-libpng system-libtheora system-libvorbis system-libvpx system-libwebp
system-libwebsockets system-mbedtls system-miniupnpc -system-mono system-opus
system-pcre2 system-recast system-squish system-wslay system-xatlas system-zlib
system-zstd
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
	${LLVM_COMPAT[@]/#/llvm_slot_}
	ebuild_revision_7
"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	3d
	advanced-gui
	freetype
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	csharp-external-editor? (
		mono
		|| (
			monodevelop
			vscode
		)
	)
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
		!system-recast
		!system-squish
		!system-xatlas
		!system-zlib
		!system-zstd
		!tsan
	)
	riscv? (
		mono? (
			system-mono
		)
	)
	vscode? (
		csharp-external-editor
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
				=llvm-core/clang-runtime-${s}[compiler-rt,sanitize]
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
		system-mono? (
			=dev-lang/mono-$(ver_cut 1-2 ${MONO_PV})*
			>=dev-lang/mono-${MONO_PV_MIN}
		)
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
		dev-dotnet/dotnet-sdk-bin:6.0
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
		sys-devel/gcc
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
	virtual/opengl
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
        gamepad? (
		virtual/libudev
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
	system-recast? (
		>=dev-games/recastnavigation-${RECASTNAVIGATION_PV}
	)
	system-squish? (
		>=media-libs/libsquish-${LIBSQUISH_PV}
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
BDEPEND+="
	${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/pkgconf-${PKGCONF_PV}[pkg-config(+)]
	dev-build/scons
	lld? (
		llvm-core/lld
	)
	mono? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
	webm-simd? (
		dev-lang/yasm
	)
	|| (
		${CDEPEND_CLANG}
		${CDEPEND_GCC}
	)
"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

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

		sandbox-changes_no_network_sandbox "To download micropackages"
	fi
}

src_configure() {
	default
	cflags-hardened_append
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
	scons ${options_x11[@]} \
		${options_modules[@]} \
		${options_modules_shared[@]} \
		bits=default \
		target=${target} \
		${options_extra[@]} \
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
	local f=$(basename bin/godot*x11*)
	virtx \
	bin/${f} \
		--audio-driver Dummy \
		--generate-mono-glue \
		modules/mono/glue
}

_assemble_datafiles() {
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
	dest="${WORKDIR}/templates/bcl/net_4_x"
einfo "Mono support:  Collecting BCL"
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

add_portable_mono_prefix() {
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
	_assemble_datafiles
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
	local target="editor"
	local configuration="release_debug"
einfo "Building Linux editor"
	if use mono ; then
		src_compile_linux_yes_mono
	else
		src_compile_linux_no_mono
	fi
}

src_compile() {
	local myoptions=()
	myoptions+=(
		production=$(usex !debug)
	)
	local options_linux=(
		platform="linux"
	)
	local options_x11=(
		platform="x11"
		pulseaudio=$(usex pulseaudio)
		touch=$(usex touch)
		udev=$(usex gamepad)
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
		$(usex portable "" \
"system_certs_path=/etc/ssl/certs/ca-certificates.crt")
	)
	local options_modules_static=(
		builtin_certs=True
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

	src_compile_linux
}

_install_linux_editor() {
	local d_base="/usr/$(get_libdir)/${MY_PN}/${SLOT_MAJ}"
	exeinto "${d_base}/bin"
	local f
	f=$(basename bin/godot*tools*)
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

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	_install_linux_editor
	_install_template_datafiles
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
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  mono, csharp, split-packages, multiplatform, portable-games, multislot
