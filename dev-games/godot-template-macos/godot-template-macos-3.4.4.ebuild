# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

MY_PN="godot"
MY_P="${MY_PN}-${PV}"
STATUS="stable"

PYTHON_COMPAT=( python3_{8..10} )
# 64 bit only
inherit desktop eutils flag-o-matic python-any-r1 scons-utils

DESCRIPTION="Godot export template for macOS"
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

IUSE+=" +3d +advanced-gui app-bundle camera +dds debug +denoise
jit +lightmapper_cpu
+neon +optimize-speed +opensimplex optimize-size +portable +raycast
universal2
"
IUSE+=" +bmp +etc1 +exr +hdr +jpeg +minizip +mp3 +ogg +opus +pvrtc +svg +s3tc
+theora +tga +vorbis +webm webm-simd +webp" # encoding/container formats

GODOT_OSX_=(arm64 x86_64)

gen_required_use_template()
{
	local l=(${1})
	for x in ${l[@]} ; do
		echo "${x}? ( || ( ${2} ) )"
	done
}

GODOT_OSX="${GODOT_OSX_[@]/#/godot_osx_}"
IUSE+=" ${GODOT_OSX}"

IUSE+=" -gdscript gdscript_lsp +visual-script" # for scripting languages
IUSE+=" +bullet +csg +gridmap +gltf +mobile-vr +recast +vhacd +xatlas" # for 3d
IUSE+=" +enet +jsonrpc +mbedtls +upnp +webrtc +websocket" # for connections
IUSE+=" +cvtt +freetype +pcre2 +pulseaudio" # for libraries
SANITIZERS=" asan lsan tsan ubsan"
IUSE+=" ${SANITIZERS}"
# media-libs/xatlas is a placeholder
# net-libs/wslay is a placeholder
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	app-bundle? ( universal2 )
	portable
	denoise? ( lightmapper_cpu )
	gdscript_lsp? ( jsonrpc websocket )
	|| ( ${GODOT_OSX} )
	lsan? ( asan )
	optimize-size? ( !optimize-speed )
	optimize-speed? ( !optimize-size )
	portable? (
		!asan
		!tsan
	)
"
APST_REQ_STORE_DATE="April 2021"
XCODE_SDK_MIN_STORE="12"
EXPECTED_XCODE_SDK_MIN_VERSION_ARM64="10.15" # See https://github.com/godotengine/godot/blob/3.4-stable/platform/osx/detect.py#L80
EXPECTED_XCODE_SDK_MIN_VERSION_X86_64="10.12"

BDEPEND+="
	${PYTHON_DEPS}
	dev-util/scons
	webm-simd? (
		dev-lang/yasm
	)
"
BDEPEND+="
	app-bundle? ( app-arch/zip )
"
S="${WORKDIR}/godot-${PV}-stable"
#GEN_DL_MANIFEST=1

verify_cross_toolchain() {
	export OSXCROSS_ROOT="${EGODOT_MACOS_SYSROOT}"

	local found_cc=0
	local found_cxx=0
	local arch
	for arch in ${GODOT_OSX_[@]} ; do
		if use "godot_osx_${arch}" ; then
			# Modify project instead?
			export CC="${OSXCROSS_ROOT}/target/bin/${arch}-apple-${EGODOT_MACOS_SDK_VERSION}-cc"
			export CXX="${OSXCROSS_ROOT}/target/bin/${arch}-apple-${EGODOT_MACOS_SDK_VERSION}-c++"
			if [[ -e "${CC}" ]] ; then
einfo
einfo "Found CC=${CC}"
einfo
				found_cc=1
			else
ewarn
ewarn "CC=${CC} is missing.  It requires either symlinks, or a ebuild & project"
ewarn "mod."
ewarn
			fi
			if [[ -e "${CXX}" ]] ; then
einfo
einfo "Found CC=${CC}"
einfo
				found_cxx=1
			else
ewarn
ewarn "CC=${CC} is missing.  It requires either symlinks, or a ebuild & project"
ewarn "mod."
ewarn
			fi
		fi
	done

	if (( ${found_cc} > 0 && ${found_cxx} > 0 )) ; then
eerror
eerror "The cross toolchain is not ready.  It requires either symlinks, or"
eerror "ebuild and project modding."
eerror
		die
	fi
}

check_osxcross()
{
	if [[ -z "${EGODOT_MACOS_SYSROOT}" ]] ; then
eerror
eerror "EGODOT_MACOS_SYSROOT must be set as a per-package environmental"
eerror "variable.  See metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi
	if which xcrun ; then
eerror
eerror "Missing xcrun from the osxcross package."
eerror
		die
	fi
	if [[ -z "${EGODOT_MACOS_SDK_VERSION}" ]] ; then
eerror
eerror "EGODOT_MACOS_SDK_VERSION must be set as a per-package environmental"
eerror "variable.  See metadata.xml or \`epkginfo -x godot\` for details."
eerror
		die
	fi

	if use godot_osx_x86_64 \
		&& ver_test ${EGODOT_MACOS_SDK_VERSION} -lt 10.8 ; then
eerror
eerror "SDK version requested:  ${EGODOT_MACOS_SDK_VERSION}"
eerror "SDK required:  >= 10.8"
eerror
eerror "Error:  x86_64 is not supported with < SDK 10.8."
eerror "Solution:  Update the SDK."
eerror
		die
	fi

	verify_cross_toolchain

	if use godot_osx_x86_64 ; then
		if ver_test ${EGODOT_MACOS_SDK_VERSION} \
			-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_X86_64} for"
eerror "x86_64."
eerror
			die
		fi
	fi
	if use godot_osx_arm64 ; then
		if ver_test ${EGODOT_MACOS_SDK_VERSION} \
			-lt ${EXPECTED_XCODE_SDK_MIN_VERSION_ARM64} ; then
eerror
eerror "${PN} requires Xcode >= ${EXPECTED_XCODE_SDK_MIN_VERSION_ARM64} for"
eerror "arm64."
eerror
			die
		fi
	fi
}

check_store_apl()
{
	if ver_test ${EGODOT_MACOS_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
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

src_compile_osx()
{
	unset CCACHE
	for a in ${GODOT_OSX} ; do
		if use ${a} ; then
			local extra_options=(
				OSXCROSS_ROOT=${EGODOT_MACOS_SYSROOT}
				osxcross_sdk=${EGODOT_MACOS_SDK_VERSION}
			)
			einfo "Creating export template for OSX (${a})"
			for c in release release_debug ; do
				scons ${options_osx[@]} \
					${options_modules[@]} \
					${options_modules_static[@]} \
					${extra_options[@]} \
					arch=${a} \
					target=${c} \
					tools=no \
					|| die
			done
		fi
	done
	if use universal2 ; then
		for c in opt opt.debug ; do
			lipo -create \
				bin/godot.osx.${c}.x86_64 \
				bin/godot.osx.${c}.arm64 \
				-output bin/godot.osx.${c}.universal || die
		done
	fi

	if use app-bundle ; then
		# Generate .app bundle
		cp -r misc/dist/osx_template.app . || die
		mkdir -p osx_template.app/Contents/MacOS || die
		for c in opt opt.debug ; do
			local c2=release
			if [[ "${c}" =~ "debug" ]] ; then
				c2=debug
			fi
			cp bin/godot.osx.${c}.universal \
				osx_template.app/Contents/MacOS/godot_osx_${c2}.64 || die
		done
		chmod +x osx_template.app/Contents/MacOS/godot_osx* || die
		zip -q -9 -r osx.zip osx_template.app || die
	fi
}

src_compile() {
	local myoptions=()
	myoptions+=( production=$(usex !debug) )
	local options_osx=(
		platform=osx
		osxcross_sdk=${EOSXCROSS_SDK}
		use_asan=$(usex asan)
		use_tsan=$(usex tsan)
		use_ubsan=$(usex ubsan)
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

	src_compile_osx
}

_get_bitness() {
	local x="${1}"
	if [[ "${x}" =~ "64" ]] ; then
		echo "64"
	elif [[ "${x}" =~ "32" ]] ; then
		echo "32"
	elif [[ "${x}" =~ "universal" ]] ; then
		echo "64"
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

_install_export_templates() {
	insinto /usr/share/godot/${SLOT_MAJ}/macos/templates
	einfo "Installing export templates"

	local x
	for x in $(find bin -type f) ; do
		local bitness=$(_get_bitness "${x}")
		local c=$(_get_configuration "${x}")
		if [[ "${x}" =~ "osx.zip" ]] ; then
			doins "${x}"
		else
			newins "${x}" "godot_osx_${c}.${bitness}"
		fi
	done
}

src_install() {
	_install_export_templates
}

pkg_postinst() {
einfo
einfo "The following still must be done:"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  echo \"${PV}.${STATUS}\" > ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  cp -aT /usr/share/godot/${SLOT_MAJ}/macos/templates ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo
}
