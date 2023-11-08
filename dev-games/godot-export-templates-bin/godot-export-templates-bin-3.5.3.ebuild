# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATUS="stable"

ANDROID_MIN_API="19"
ANDROID_SDK_VER="32"
IOS_MIN="10.0"
MONO_PV="6.12.0.182"
EMSCRIPTEN_PV="1.39.9" # emsdk_pv == emscripten-core_pv

# To get the internal dependency versions of the EMSCRIPTEN_PV build:
# https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/122396dfad60e1b2a83ccefa74a1425a2e05b5cb/wasm-binaries.tbz2
# 122396d ; found in https://github.com/emscripten-core/emsdk/blob/1.39.9/emscripten-releases-tags.txt

# Emscripten core info is at:
# https://github.com/emscripten-core/emscripten/blob/1.39.9/ChangeLog.md

if [[ "${AUPDATE}" == "1" ]] ; then
	SRC_URI="
		https://downloads.tuxfamily.org/godotengine/${PV}/mono/Godot_v${PV}-${STATUS}_mono_export_templates.tpz
		https://downloads.tuxfamily.org/godotengine/${PV}/Godot_v${PV}-${STATUS}_export_templates.tpz
	"
else
	SRC_URI="
		mono? (
			https://downloads.tuxfamily.org/godotengine/${PV}/mono/Godot_v${PV}-${STATUS}_mono_export_templates.tpz
		)
		standard? (
			https://downloads.tuxfamily.org/godotengine/${PV}/Godot_v${PV}-${STATUS}_export_templates.tpz
		)
	"
fi

DESCRIPTION="Godot export templates"
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
# mono_static=yes (applied to iOS, WASM builds) # See https://docs.godotengine.org/en/3.4/development/compiling/compiling_with_mono.html#command-line-options
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
	Mono-patents
	MPL-1.1
	openssl
	OSL-1.1
"
# ! = not
# MIT IDPL -- BCL
# !Apache-1.1 -- ikvm-disabled
# Apache-2.0 MPL-1.1 -- mcs/class/RabbitMQ.Client/src/client/events/ModelShutdownEventHandler.cs (RabbitMQ.Client.dll)
# BSD - mono/metadata/w32file-unix-glob.c, mono/metadata/w32file-unix-glob.h (libmonosgen.a)
# BSD openssl ISC -- btls enabled for mono-desktop (osx, windows, linux)
# !BSD !openssl !ISC -- btls disabled for ios, wasm
# IDPL MPL-1.1 -- RabbitMQ.Client
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# openssl - external/boringssl/crypto/ecdh/ecdh.c (libmono-btls-shared.dll)
# OSL-1.1 -- external/nunit-lite/NUnitLite-1.0.0/src/framework/Internal/StackFilter.cs (nunitlite.dll)
LICENSE+=" mono? ( ${MONO_LICENSE} )"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
HOMEPAGE="https://godotengine.org"
PLATFORMS="
	android
	ios
	javascript
	javascript_gdnative
	javascript_threads
	linux_x86
	linux_x86_64
	macos
	uwp_arm
	uwp_x86
	uwp_x86_64
	windows_x86
	windows_x86_64
"
IUSE+=" ${PLATFORMS} custom debug mono release standard"
REQUIRED_USE="
	android? (
		|| (
			standard
			mono
		)
	)
	ios? (
		|| (
			standard
			mono
		)
	)
	javascript? (
		|| (
			standard
			mono
		)
	)
	javascript_gdnative? (
		|| (
			standard
		)
	)
	javascript_threads? (
		|| (
			standard
		)
	)
	linux_x86? (
		|| (
			standard
			mono
		)
	)
	linux_x86_64? (
		|| (
			standard
			mono
		)
	)
	macos? (
		|| (
			standard
			mono
		)
	)
	uwp_arm? (
		|| (
			standard
		)
	)
	uwp_x86? (
		|| (
			standard
		)
	)
	uwp_x86_64? (
		|| (
			standard
		)
	)
	windows_x86? (
		|| (
			standard
			mono
		)
	)
	windows_x86_64? (
		|| (
			standard
			mono
		)
	)
	custom? (
		|| (
			debug
			release
		)
	)
	|| (
		mono
		standard
	)
	|| (
		android
		ios
		javascript
		javascript_gdnative
		javascript_threads
		linux_x86
		linux_x86_64
		uwp_arm
		uwp_x86
		uwp_x86_64
		windows_x86
		windows_x86_64
	)
"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"
RESTRICT="binchecks"
BDEPEND="app-arch/unzip"

pkg_setup() {
	if use custom ; then
einfo
einfo "USE=custom (installing individually per microarch)"
einfo
	else
ewarn
ewarn "USE=-custom (installing in bulk)"
ewarn
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	if use custom ; then
		mkdir -p "${WORKDIR}/mono" || die
		mkdir -p "${WORKDIR}/standard" || die
		if use mono ; then
			einfo "USE=mono is under construction"
			unzip -x "${DISTDIR}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz" -d "${WORKDIR}/mono" || die
		fi
		if use standard ; then
			unzip -x "${DISTDIR}/Godot_v${PV}-${STATUS}_export_templates.tpz" -d "${WORKDIR}/standard" || die
		fi
		for type in mono standard ; do
			! use mono && [[ "${type}" == "mono" ]] && continue
			! use standard && [[ "${type}" == "standard" ]] && continue
			for configuration in debug release ; do
				if use "${configuration}" ; then
					if ! use android ; then
						rm -rf "${WORKDIR}/${type}/templates/android"*"${configuration}"* || die
					fi
					if ! use javascript ; then
						rm -rf "${WORKDIR}/${type}/templates/webassembly"*"${configuration}"* || die
					fi
					if ! use linux_x86 ; then
						rm -rf "${WORKDIR}/${type}/templates/linux_x11_32"*"${configuration}"* || die
					fi
					if ! use linux_x86_64 ; then
						rm -rf "${WORKDIR}/${type}/templates/linux_x11_64"*"${configuration}"* || die
					fi
					if ! use windows_x86 ; then
						rm -rf "${WORKDIR}/${type}/templates/windows_32"*"${configuration}"* || die
					fi
					if ! use windows_x86_64 ; then
						rm -rf "${WORKDIR}/${type}/templates/windows_64"*"${configuration}"* || die
					fi
					if [[ "${type}" == "mono" ]] ; then
						local configuration2
						configuration2="${configuration}"
						# ambiguous between release and release_debug
						[[ "${configuration}" == "debug" ]] && configuration2="release_debug"
						if ! use linux_x86 ; then
							rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.x11.32.${configuration2}") || die
						fi
						if ! use linux_x86_64 ; then
							rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.x11.64.${configuration2}") || die
						fi
						if ! use windows_x86 ; then
							rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.windows.32.${configuration2}") || die
						fi
						if ! use windows_x86_64 ; then
							rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.windows.64.${configuration2}") || die
						fi
					fi
					if [[ "${type}" == "standard" ]] ; then
						if ! use javascript ; then
							rm -rf "${WORKDIR}/${type}/templates/webassembly_${configuration}"* || die
						fi
						if ! use javascript_gdnative ; then
							rm -rf "${WORKDIR}/${type}/templates/webassembly_gdnative_${configuration}"* || die
						fi
						if ! use javascript_threads ; then
							rm -rf "${WORKDIR}/${type}/templates/webassembly_threads_${configuration}"* || die
						fi
						if ! use uwp_arm ; then
							rm -rf "${WORKDIR}/${type}/templates/uwp_arm_${configuration}"* || die
						fi
						if ! use uwp_x86 ; then
							rm -rf "${WORKDIR}/${type}/templates/uwp_x86_${configuration}"* || die
						fi
						if ! use uwp_x86_64 ; then
							rm -rf "${WORKDIR}/${type}/templates/uwp_x64_${configuration}"* || die
						fi
					fi
				else
					rm -rf "${WORKDIR}/${type}/templates/android"*"${configuration}"* || die
					rm -rf "${WORKDIR}/${type}/templates/webassembly"*"${configuration}"* || die
					rm -rf "${WORKDIR}/${type}/templates/linux_x11_32"*"${configuration}"* || die
					rm -rf "${WORKDIR}/${type}/templates/linux_x11_64"*"${configuration}"* || die
					rm -rf "${WORKDIR}/${type}/templates/windows_32"*"${configuration}"* || die
					rm -rf "${WORKDIR}/${type}/templates/windows_64"*"${configuration}"* || die
					if [[ "${type}" == "mono" ]] ; then
						local configuration2
						configuration2="${configuration}"
						# ambiguous between release and release_debug
						[[ "${configuration}" == "debug" ]] && configuration2="release_debug"
						rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.x11.32.${configuration2}") || die
						rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.x11.64.${configuration2}") || die
						rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.windows.32.${configuration2}") || die
						rm -rf $(find "${WORKDIR}/${type}/templates" -type d -name "data.mono.windows.64.${configuration2}") || die
					fi
					if [[ "${type}" == "standard" ]] ; then
						rm -rf "${WORKDIR}/${type}/templates/webassembly_${configuration}"* || die
						rm -rf "${WORKDIR}/${type}/templates/webassembly_gdnative_${configuration}"* || die
						rm -rf "${WORKDIR}/${type}/templates/webassembly_threads_${configuration}"* || die
						rm -rf "${WORKDIR}/${type}/templates/uwp_arm_${configuration}"* || die
						rm -rf "${WORKDIR}/${type}/templates/uwp_x86_${configuration}"* || die
						rm -rf "${WORKDIR}/${type}/templates/uwp_x64_${configuration}"* || die
					fi
				fi
			done
			if ! use android ; then
				rm -rf "${WORKDIR}/${type}/templates/android"*"source"* || die
			fi
			if ! use ios ; then
				rm -rf "${WORKDIR}/${type}/templates/iphone"* || die
			fi
			if ! use macos ; then
				rm -rf "${WORKDIR}/${type}/templates/osx"* || die
			fi
			if [[ "${type}" == "mono" ]] ; then
				if ! use android ; then
					rm -rf "${WORKDIR}/${type}/templates/bcl/monodroid"* || die
					rm -rf "${WORKDIR}/${type}/templates/bcl/godot_android_ext"* || die
				fi
				if ! use ios ; then
					rm -rf "${WORKDIR}/${type}/templates/bcl/monotouch"* || die
					rm -rf "${WORKDIR}/${type}/templates/iphone-mono-libs"* || die
				fi
				if ! use javascript ; then
					rm -rf "${WORKDIR}/${type}/templates/bcl/wasm"* || die
				fi
				if [[ ! ( "${USE}" =~ "linux" ) ]] && ! use macos ; then
					rm -rf "${WORKDIR}/${type}/templates/bcl/net_4_x" || die
				fi
				if [[ ! ( "${USE}" =~ "windows" ) ]] ; then
					rm -rf "${WORKDIR}/${type}/templates/bcl/net_4_x_win" || die
				fi
			fi
		done
	fi
}

src_configure() {
	local needs_update=0
	# Verify metadata:
	if use mono ; then
		local mono_pv=$(unzip -p \
			$(realpath "${DISTDIR}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz") \
			"templates/data.mono.x11.64.release_debug/Mono/lib/libmono-native.so" \
			| strings \
			| grep -o -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" \
			| head -n 1)
		if [[ "${mono_pv}" != "${MONO_PV}" ]] ; then
eerror
eerror "Expected Mono:  ${MONO_PV}"
eerror "Actual Mono:  ${mono_pv}"
eerror
eerror "Bump the MONO_PV in the ebuild."
eerror
			needs_update=1
		fi
	fi

	local src_tarball
	if use standard ; then
		src_tarball="Godot_v${PV}-${STATUS}_export_templates.tpz"
	else
		src_tarball="Godot_v${PV}-${STATUS}_mono_export_templates.tpz"
	fi

	mkdir -p "${T}/sandbox" || die
	unzip -x $(realpath "${DISTDIR}/${src_tarball}") \
		"templates/android_debug.apk" \
		-d "${T}/sandbox" || die
	local android_min_api=$(unzip -p \
		"${T}/sandbox/templates/android_debug.apk" \
		"classes.dex" \
		| strings \
		| grep -o -E "min-api\":[0-9]+" \
		| cut -f 2 -d ":")
	if [[ "${android_min_api}" != "${ANDROID_MIN_API}" ]] ; then
eerror
eerror "Expected Android Min API:  ${ANDROID_MIN_API}"
eerror "Actual Android Min API:  ${android_min_api}"
eerror
eerror "Bump the ANDROID_MIN_API in the ebuild."
eerror
		needs_update=1
	fi

	unzip -x $(realpath "${DISTDIR}/${src_tarball}") \
		"templates/android_source.zip" \
		-d "${T}/sandbox" || die
	local android_sdk_pv=$(unzip -p \
		"${T}/sandbox/templates/android_source.zip" \
		"config.gradle" \
		| grep -e "compileSdk" \
		| grep -o -E -e "[0-9]+")
	if [[ "${android_sdk_pv}" != "${ANDROID_SDK_VER}" ]] ; then
eerror
eerror "Expected Android SDK ver:  ${ANDROID_SDK_VER}"
eerror "Actual Android SDK ver:  ${android_sdk_pv}"
eerror
eerror "Bump the ANDROID_SDK_VER in the ebuild."
eerror
		needs_update=1
	fi

	unzip -x \
		$(realpath "${DISTDIR}/${src_tarball}") \
		"templates/iphone.zip" \
		-d "${T}/sandbox" || die
	local ios_min=$(unzip -p \
		"${T}/sandbox/templates/iphone.zip" \
		"godot_ios.xcodeproj/project.pbxproj" \
		| grep -e "IPHONEOS_DEPLOYMENT_TARGET" \
		| head -n 1 \
		| grep -o -E "[0-9\.]+")
	if [[ "${ios_min}" != "${IOS_MIN}" ]] ; then
eerror
eerror "Expected iOS Min API:  ${IOS_MIN}"
eerror "Actual iOS Min API:  ${ios_min}"
eerror
eerror "Bump the IOS_MIN in the ebuild."
eerror
		needs_update=1
	fi

if false ; then
	if use standard ; then
		unzip -x $(realpath "${DISTDIR}/${src_tarball}") \
			"templates/webassembly_threads_debug.zip" \
			-d "${T}/sandbox" || die
		emscripten_pv=$(unzip -p \
			"${T}/sandbox/templates/webassembly_threads_debug.zip" \
			"godot.wasm" \
			| strings \
			| grep -e "emsdk_" \
			| grep -o -E -e "[0-9]+\.[0-9]+\.[0-9]+")
	fi
	if use standard && [[ "${emscripten_pv}" != "${EMSCRIPTEN_PV}" ]] ; then
eerror
eerror "Expected Emscripten version:  ${EMSCRIPTEN_PV}"
eerror "Actual Emscripten version:  ${emscripten_pv}"
eerror
eerror "Bump the EMSCRIPTEN_PV in the ebuild."
eerror
		needs_update=1
	fi
fi

	einfo "android_min_api=${android_min_api}"
	einfo "android_sdk_pv=${android_sdk_pv}"
	einfo "emscripten_pv=${emscripten_pv}"
	einfo "ios_min=${ios_min}"
	einfo "mono_pv=${mono_pv}"

	if (( ${needs_update} == 1 )) ; then
		die
	fi

	rm -rf "${T}/sandbox" || die
}

src_install() {
	use debug && export STRIP="true"
	insinto "/usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates"
	if ! use custom ; then
		use mono && doins $(realpath "${DISTDIR}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz")
		use standard && doins $(realpath "${DISTDIR}/Godot_v${PV}-${STATUS}_export_templates.tpz")
	else
		if use mono ; then
			insinto "/usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates/mono"
			doins -r "${WORKDIR}/mono/"*
		fi
		if use standard ; then
			insinto "/usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates/standard"
			doins -r "${WORKDIR}/standard/"*
		fi
		local p
		for p in $(find "${ED}" -type f) ; do
			if file "${p}" | grep -q -E -e "(executable|shared object)" ; then
				p=$(echo "${p}" | sed -e "s|^${ED}||g")
				fperms 0755 "${p}"
			fi
		done
	fi
}

pkg_postinst() {
	# Information provided for developers so others know or ebuilds know if
	# they meet requirements or security advisories:
	einfo
	einfo "Developer details:"
	einfo

	use android && einfo "Android min API:  ${ANDROID_MIN_API}"
	use android || einfo "Android min API:  N/A"

	use android && einfo "Android SDK ver:  ${ANDROID_SDK_VER}"
	use android || einfo "Android SDK ver:  N/A"

	use ios && einfo "iOS min:  ${IOS_MIN}"
	use ios || einfo "iOS min:  N/A"

	use mono && einfo "Mono version:  ${MONO_PV}"
	use mono || einfo "Mono version:  N/A"

	[[ "${USE}" =~ "javascript" ]] && einfo "Emscripten version:  ${EMSCRIPTEN_PV}"
	[[ "${USE}" =~ "javascript" ]] || einfo "Emscripten version:  N/A"

	einfo "CPU microarchitectures:  See metadata.xml"
	einfo
	if use custom ; then
		if use standard ; then
einfo
einfo "The following still must be done for export templates (Mono/C#):"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}.mono"
einfo "  cp -aT /usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates/mono/templates ~/.local/share/godot/templates/${PV}.${STATUS}.mono"
einfo
		fi
		if use mono ; then
einfo
einfo "The following still must be done for export templates (standard):"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  cp -aT /usr/share/godot/${SLOT_MAJ}/prebuilt-export-templates/standard/templates ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
