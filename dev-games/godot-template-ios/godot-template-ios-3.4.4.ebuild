# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

# TODO: check each compiler flag for GODOT_IOS_

MY_PN="godot"
MY_P="${MY_PN}-${PV}"
STATUS="stable"

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop eutils flag-o-matic llvm multilib-build python-any-r1 scons-utils

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

#KEYWORDS=""

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
lto +neon +optimize-speed +opensimplex optimize-size +portable +raycast
"
IUSE+=" ca-certs-relax"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm webm-simd +webp" # encoding/container formats

GODOT_IOS_=(arm armv7 armv64 x86 x86_64)

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_IOS="${GODOT_IOS_[@]/#/godot_ios_}"
IUSE+=" ${GODOT_IOS}"

IUSE+=" -gdscript gdscript_lsp +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +gltf +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +mbedtls +upnp +webrtc +websocket" # for connections
IUSE+=" -gamepad +touch" # for input
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
SANITIZERS=" asan lsan msan tsan ubsan"
IUSE+=" ${SANITIZERS}"
IUSE+=" -ios-sim +icloud +game-center +store-kit" # ios
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# See https://developer.apple.com/ios/submit/ for app store requirement
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	portable
	denoise? ( lightmapper_cpu )
	gdscript_lsp? ( jsonrpc websocket )
	|| ( ${GODOT_IOS} )
	lld? ( clang )
	lsan? ( asan )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!asan
		!tsan
	)
"
# See https://developer.apple.com/ios/submit/ for app store requirement
APST_REQ_STORE_DATE="April 2021"
IOS_SDK_MIN_STORE="14"
XCODE_SDK_MIN_STORE="12"
EXPECTED_XCODE_SDK_MIN_VERSION_IOS="10"
EXPECTED_IOS_SDK_MIN_VERSION="10"
FREETYPE_V="2.10.4"
LIBOGG_V="1.3.5"
LIBVORBIS_V="1.3.7"
NDK_V="21"
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
	sys-devel/osxcross
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
DISABLED_DEPEND+="
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
"
DISABLED_RDEPEND+=" ${DEPEND}"
DISABLED_BDEPEND+="
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
#GEN_DL_MANIFEST=1

check_osxcross()
{
	if [[ -z "${OSXCROSS_ROOT}" ]] ; then
eerror
eerror "OSXCROSS_ROOT must be set as a per-package environmental variable.  See"
eerror "metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi
	if which xcrun ; then
eerror
eerror "Missing xcrun from the osxcross package."
eerror
		die
	fi
	if [[ -z "${EOSXCROSS_SDK}" ]] ; then
eerror
eerror "EOSXCROSS_SDK must be set as a per-package environmental variable.  See"
eerror "metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi
	if [[ ! -f \
"${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc" \
	   ]] ; then
eerror
eerror "Cannot find x86_64-apple-${EOSXCROSS_SDK}-cc.  Fix either OSXCROSS_ROOT"
eerror "(${OSXCROSS_ROOT}) or EOSXCROSS_SDK (${EOSXCROSS_SDK}).  Did not find"
eerror "${OSXCROSS_ROOT}/target/bin/x86_64-apple-${EOSXCROSS_SDK}-cc"
eerror
		die
	fi
}

check_store_apl()
{
	if ver_test ${EIOS_SDK_VERSION} -lt ${IOS_SDK_MIN_STORE} ; then
ewarn
ewarn "Your IOS SDK does not meet minimum store requirements of"
ewarn ">=${IOS_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi

	if ver_test ${EXCODE_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
ewarn
ewarn "Your Xcode SDK does not meet minimum store requirements of"
ewarn ">=${XCODE_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi
}

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2021"
ewarn
	if use gdscript ; then
ewarn
ewarn "The gdscript USE flag is untested."
ewarn
	fi
	check_osxcross
	check_store_apl

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

src_configure() {
	default
	if use portable ; then
		strip-flags
		filter-flags -march=*
	fi
}

src_compile_ios()
{
	unset CCACHE
	for a in ${GODOT_IOS} ; do
		if use ${a} ; then
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

			einfo "Creating export template for iOS (${a})"
			for c in release release_debug ; do
				scons ${options_iphone[@]} \
					${options_modules[@]} \
					${options_modules_static[@]} \
					arch=${a} \
					bits=${bitness} \
					target=${c} \
					tools=no \
					|| die
				local arch="${a/godot_ios_}"
				mkdir -p "bin2/${c}/${arch}" || die
				mv bin/* "bin2/${c}/${arch}" || die
			done
		fi
	done
}

src_compile() {
	local myoptions=()
	myoptions+=( production=$(usex !debug) )
	local options_iphone=(
		platform=iphone
		game_center=$(usex game-center)
		icloud=$(usex icloud)
		use_lto=$(usex lto)
		store_kit=$(usex store-kit)
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
		builtin_libwebsockets=True
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
		${EGODOT_ADDITIONAL_CONFIG}
	)

	src_compile_ios
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
	local c
	if [[ "${x}" =~ ".debug" ]] ; then
		echo "debug"
	elif [[ "${x}" =~ ".opt" ]] ; then
		echo "release"
	else
		echo -n ""
	fi
}

_get_arch() {
	local x="${1}"
	local arch
	for arch in ${GODOT_IOS_} ; do
		if [[ "${x}" =~ "/${arch}/" ]] ; then
			echo "${arch}"
			return
		fi
	done
	echo -n ""
}

_install_export_templates()
{
	einfo "Installing export templates"

	local x
	for x in $(find bin -type f) ; do
		local bitness=$(_get_bitness "${x}")
		local c=$(_get_configuration "${x}")
		local a=$(_get_arch "${x}")
		insinto /usr/share/godot/${SLOT_MAJ}/export_templates/ios/${a}
		newins "${x}" "iphone.zip"
	done
}

src_install() {
	_install_export_templates
}

pkg_postinst() {
	local arches=$(echo "${GODOT_IOS_[@]}" | sed -e 's| |, |g')
einfo
einfo "The following still must be done:"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  echo \"${PV}.${STATUS}\" > ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  cp -aT /usr/share/godot/${SLOT_MAJ}/ios/templates/<ARCH> ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  # (replacing <ARCH> with either one of ${arches})"
einfo
}
