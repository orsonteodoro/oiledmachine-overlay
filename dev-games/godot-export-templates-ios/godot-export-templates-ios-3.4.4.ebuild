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
inherit desktop eutils flag-o-matic multilib-build python-any-r1 scons-utils

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

IUSE+=" +3d +advanced-gui camera +dds debug +denoise jit +lightmapper_cpu
lto +neon +optimize-speed +opensimplex optimize-size +portable +raycast
"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm webm-simd +webp" # encoding/container formats

IUSE+=" mono" # for scripting languages

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
	!mono
	portable
	denoise? ( lightmapper_cpu )
	gdscript_lsp? ( jsonrpc websocket )
	|| ( ${GODOT_IOS} )
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

BDEPEND+="
	${PYTHON_DEPS}
	dev-util/scons
	webm-simd? (
		dev-lang/yasm
	)
"
S="${WORKDIR}/godot-${PV}-stable"
PATCHES=(
	"${FILESDIR}/godot-3.4.4-set-ccache-dir.patch"
)

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
	check_osxcross
	check_store_apl

	python-any-r1_pkg_setup
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
	# CCACHE disabled for cross-compile
	unset CCACHE
}

_compile() {
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
					${options_extra[@]} \
					arch=${a} \
					bits=${bitness} \
					target=${configuration} \
					tools=no \
					|| die
				local arch="${a/godot_ios_}"
				mkdir -p "bin2/${configuration}/${arch}" || die
				mv bin/* "bin2/${configuration}/${arch}" || die
			done
		fi
	done
}

_gen_glue() {
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
	local f=$(basename bin/godot*windows*)
	virtx \
	bin/${f} \
		--audio-driver Dummy \
		--generate-mono-glue \
		modules/mono/glue

	if [[ ! -e "bin/GodotSharp" ]] ; then
eerror
eerror "Missing export templates data directory.  It is likely caused by a"
eerror "crash while generating mono_glue.gen.cpp."
eerror
		die
	fi

	einfo "Mono support:  Collecting BCL"
	mkdir -p "${WORKDIR}/templates/bcl/monotouch"
	cp -aT "${S}/bin/GodotSharp/Mono/lib/mono/4.5" \
		"${WORKDIR}/templates/bcl/monotouch" || die

	# Not distributed in prepackaged
	#einfo "Mono support:  Collecting datafiles"
	#mkdir -p "${WORKDIR}/templates/data.mono.iphone.${bitness}.${configuration}/Mono"
	#cp -aT "${S}/bin/GodotSharp/Mono/etc/mono" \
	#	"${WORKDIR}/templates/data.mono.iphone.${bitness}.${configuration}/Mono" || die
}

src_compile_ios_yes_mono() {
	local options_extra
	einfo "Mono support:  Building temporary binary"
	options_extra=( module_mono_enabled=yes mono_glue=no )
	_compile
	_gen_glue
	einfo "Mono support:  Building final binary"
	options_extra=( module_mono_enabled=yes )
	_compile
}

src_compile_ios_no_mono() {
	einfo "Creating export template"
	local options_extra=( module_mono_enabled=no tools=no )
	_compile
}

src_compile_ios() {
	if use mono ; then
		einfo "USE=mono is under contruction"
		src_compile_ios_yes_mono
	else
		src_compile_ios_no_mono
	fi
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
		local a=$(_get_arch "${x}")
		insinto /usr/share/godot/${SLOT_MAJ}/export_templates/ios/${a}
		newins "${x}" "iphone.zip"
	done

	# Data files also
	use mono && doins -r "${WORKDIR}/templates"
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
#	local arches=$(echo "${GODOT_IOS_[@]}" | sed -e 's| |, |g')
einfo
einfo "The following still must be done:"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo "  cp -aT ${prefix} ~/.local/share/godot/templates/${PV}.${STATUS}${suffix}"
einfo
}
