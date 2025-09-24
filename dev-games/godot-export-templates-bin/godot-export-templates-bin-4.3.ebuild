# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

STATUS="stable"

ANDROID_MIN_API="21" # From tarball, see src_configure
ANDROID_SDK_VER="34" # From tarball, see src_configure
CLANG_PV_EMSCRIPTEN="??" # From CI logs
DOTNET_SDK_PV="8.0" # From docs
EMSCRIPTEN_PV="3.1.64" # Based on https://github.com/godotengine/godot/blob/4.3-stable/.github/workflows/web_builds.yml#L10 U22
EMSCRIPTEN_NODE_PV="10.19" # Based on emscripten
JDK_PV="17" # From https://github.com/godotengine/godot/blob/4.3-stable/.github/workflows/android_builds.yml#L50
MINGW_PV="14.1.1" # From binary inspection
NDK_PV="23.2" # From https://github.com/godotengine/godot/blob/4.3-stable/platform/android/detect.py#L61

# It assumes that the docs are 100% correct, since the logs are deleted.
# The export templates allow to run the project on the prebuilt target platforms.
ANDROID_MIN_VER="6.0" # Based on docs
# Chrome min version:  https://github.com/emscripten-core/emscripten/blob/3.1.39/src/settings.js#L1904
# Firefox min version:  https://github.com/emscripten-core/emscripten/blob/3.1.39/src/settings.js#L1878
# Safari min version:  https://github.com/emscripten-core/emscripten/blob/3.1.39/src/settings.js#L1893
BROWSERS_MIN_VER="Chrome 75, Firefox 68, Safari 14.1"
IOS_MIN_VER="12.0" # From -miphoneos-version-min=
LINUX_MIN_VER="D11, U20, F32" # Based on https://github.com/godotengine/godot/blob/4.3-stable/.github/workflows/linux_builds.yml#L20 and GLIBC_PV
MACOS_MIN_VER="10.13" # From -mmacosx-version-min=
WINDOWS_MIN_VER="10" # Based on docs

# Emscripten core info is at:
# https://github.com/emscripten-core/emsdk/blob/3.1.39/emscripten-releases-tags.txt
# https://github.com/emscripten-core/emscripten/blob/3.1.39/ChangeLog.md

SRC_URI="
	mono? (
		https://github.com/godotengine/godot/releases/download/${PV}-${STATUS}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz
	)
	standard? (
		https://github.com/godotengine/godot/releases/download/${PV}-${STATUS}/Godot_v${PV}-${STATUS}_export_templates.tpz
	)
"

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

# See https://github.com/godotengine/godot/blob/4.5-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

# Listed because of mono_static=yes
# mono_static=yes (applied to iOS, WASM builds) # See https://docs.godotengine.org/en/3.4/development/compiling/compiling_with_mono.html#command-line-options
DOTNET_LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	CC-BY-3.0
	CC-BY-SA-3.0
	CC0-1.0
	custom
	DOTNET-libraries-and-runtime-components-patents
	GPL-2-with-linking-exception
	HPND
	LGPL-2.1+
	MIT
	Ms-PL
	public-domain
	Unicode-DFS-2016
	UoI-NCSA
	W3C-Software-and-Document-Notice-and-License
	ZLIB
"
# See dotnet-sdk ebuild
LICENSE+="
	mono? (
		${DOTNET_LICENSE}
	)
"
# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.

KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
HOMEPAGE="https://godotengine.org"
FILENAMES="
android_debug.apk
android_release.apk
android_source.zip
ios.zip
linux_debug.arm32
linux_debug.arm64
linux_debug.x86_32
linux_debug.x86_64
linux_release.arm32
linux_release.arm64
linux_release.x86_32
linux_release.x86_64
macos.zip
web_debug.zip
web_dlink_debug.zip
web_dlink_nothreads_debug.zip
web_dlink_nothreads_release.zip
web_dlink_release.zip
web_nothreads_debug.zip
web_nothreads_release.zip
web_release.zip
windows_debug_arm64_console.exe
windows_debug_arm64.exe
windows_debug_x86_32_console.exe
windows_debug_x86_32.exe
windows_debug_x86_64_console.exe
windows_debug_x86_64.exe
windows_release_arm64_console.exe
windows_release_arm64.exe
windows_release_x86_32_console.exe
windows_release_x86_32.exe
windows_release_x86_64_console.exe
windows_release_x86_64.exe
"
get_build_ids() {
	local x
	for x in ${FILENAMES[@]} ; do
		local t="${x}"
		t="${t%.apk}"
		t="${t%.exe}"
		t="${t%.zip}"
		t="${t//./-}"
		t="${t//_/-}"
		echo " ${t}"
	done
}
BUILD_IDS=$(get_build_ids)
IUSE+="
${BUILD_IDS}
custom mono standard
ebuild_revision_1
"
REQUIRED_USE="
	|| (
		${BUILD_IDS}
	)
"
SLOT="$(ver_cut 1-2 ${PV})"
RESTRICT="binchecks"
BDEPEND="
	app-arch/unzip
"

pkg_setup() {
	if use custom ; then
einfo "USE=custom (installing individually per microarch)"
	else
ewarn "USE=-custom (installing whole tarball(s))"
	fi
}

get_build_id() {
	local filename="${1}"
	local t="${1}"
	t="${t%.apk}"
	t="${t%.exe}"
	t="${t%.zip}"
	t="${t//./-}"
	t="${t//_/-}"
	echo "${t}"
}

filter_build_id() {
	local filename="${1}"
	local platform_id=$(get_build_id "${1}")
	pushd "${WORKDIR}/${type}/templates" >/dev/null 2>&1 || die
		local keep=0
		if use "${type}" && use "${platform_id}" ; then
			keep=1
		fi
		if (( ${keep} == 0 )) ; then
			einfo "Removing ${filename}"
			rm "${filename}" || die
		else
			einfo "Keeping ${filename}"
		fi
	popd >/dev/null 2>&1 || die
}

filter_standard() {
	local type="standard"
	filter_build_id "android_debug.apk"
	filter_build_id "android_release.apk"
	filter_build_id "android_source.zip"
	filter_build_id "ios.zip"
	filter_build_id "linux_debug.arm32"
	filter_build_id "linux_debug.arm64"
	filter_build_id "linux_debug.x86_32"
	filter_build_id "linux_debug.x86_64"
	filter_build_id "linux_release.arm32"
	filter_build_id "linux_release.arm64"
	filter_build_id "linux_release.x86_32"
	filter_build_id "linux_release.x86_64"
	filter_build_id "macos.zip"
	filter_build_id "version.txt"
	filter_build_id "web_debug.zip"
	filter_build_id "web_dlink_debug.zip"
	filter_build_id "web_dlink_nothreads_debug.zip"
	filter_build_id "web_dlink_nothreads_release.zip"
	filter_build_id "web_dlink_release.zip"
	filter_build_id "web_nothreads_debug.zip"
	filter_build_id "web_nothreads_release.zip"
	filter_build_id "web_release.zip"
	filter_build_id "windows_debug_arm64_console.exe"
	filter_build_id "windows_debug_arm64.exe"
	filter_build_id "windows_debug_x86_32_console.exe"
	filter_build_id "windows_debug_x86_32.exe"
	filter_build_id "windows_debug_x86_64_console.exe"
	filter_build_id "windows_debug_x86_64.exe"
	filter_build_id "windows_release_arm64_console.exe"
	filter_build_id "windows_release_arm64.exe"
	filter_build_id "windows_release_x86_32_console.exe"
	filter_build_id "windows_release_x86_32.exe"
	filter_build_id "windows_release_x86_64_console.exe"
	filter_build_id "windows_release_x86_64.exe"
}

filter_mono() {
	local type="mono"
	filter_build_id "android_debug.apk"
	filter_build_id "android_release.apk"
	filter_build_id "android_source.zip"
	filter_build_id "ios.zip"
	filter_build_id "linux_debug.arm32"
	filter_build_id "linux_debug.arm64"
	filter_build_id "linux_debug.x86_32"
	filter_build_id "linux_debug.x86_64"
	filter_build_id "linux_release.arm32"
	filter_build_id "linux_release.arm64"
	filter_build_id "linux_release.x86_32"
	filter_build_id "linux_release.x86_64"
	filter_build_id "macos.zip"
	filter_build_id "version.txt"
	filter_build_id "windows_debug_arm64_console.exe"
	filter_build_id "windows_debug_arm64.exe"
	filter_build_id "windows_debug_x86_32_console.exe"
	filter_build_id "windows_debug_x86_32.exe"
	filter_build_id "windows_debug_x86_64_console.exe"
	filter_build_id "windows_debug_x86_64.exe"
	filter_build_id "windows_release_arm64_console.exe"
	filter_build_id "windows_release_arm64.exe"
	filter_build_id "windows_release_x86_32_console.exe"
	filter_build_id "windows_release_x86_32.exe"
	filter_build_id "windows_release_x86_64_console.exe"
	filter_build_id "windows_release_x86_64.exe"
}

src_unpack() {
	mkdir -p "${S}" || die
	if use custom ; then
		mkdir -p "${WORKDIR}/mono" || die
		mkdir -p "${WORKDIR}/standard" || die
		if use mono ; then
			unzip -x "${DISTDIR}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz" -d "${WORKDIR}/mono" || die
		fi
		if use standard ; then
			unzip -x "${DISTDIR}/Godot_v${PV}-${STATUS}_export_templates.tpz" -d "${WORKDIR}/standard" || die
		fi
	fi
}

get_android_sdk_info() {
	local type="${1}"
	pushd "${WORKDIR}/${type}/templates" >/dev/null 2>&1 || die
		local L=(
			"debug"
			"release"
		)
		local x
		for x in ${L[@]} ; do
			local f="android_${x}.apk"
			if [[ -e "${f}" ]] ; then
				mkdir -p "sandbox" || die
				cp -a "${f}" "sandbox" || die
				pushd "sandbox" >/dev/null 2>&1 || die
					unzip -qq -x "${f}" || die
					local android_min_api=$(cat "classes.dex" \
						| strings \
						| grep -o -E "min-api\":[0-9]+" \
						| cut -f 2 -d ":")
				popd >/dev/null 2>&1 || die
				rm -rf "sandbox"
echo
einfo "Inspecting android_${x}.apk"
einfo "Android API minimum:  ${android_min_api}"
			fi
		done

		if [[ -e "${DISTDIR}/${src_tarball}" ]] ; then
			local f="android_source.zip"
			if [[ -e "${f}" ]] ; then
				mkdir -p "sandbox" || die
				cp -a "${f}" "sandbox" || die
				pushd "sandbox" >/dev/null 2>&1 || die
					unzip -qq -x "${f}" || die
					local android_sdk_pv=$(cat "config.gradle" \
						| grep -e "compileSdk" \
						| grep -o -E -e "[0-9]+")
				popd >/dev/null 2>&1 || die
				rm -rf "sandbox"
echo
einfo "Inspecting ${f} (${type}):"
einfo "Android SDK version:  ${android_sdk_pv}"
			fi
		fi
	popd >/dev/null 2>&1 || die
}

get_glibc_info() {
	local type="${1}"
	pushd "${WORKDIR}/${type}/templates" >/dev/null 2>&1 || die
		local x
		for x in $(find . -executable -type f); do
echo
einfo "Inspecting ${x}:"
			strings "${x}" | grep -E -e "GLIBC_[0-9.]+" | sort -V | tail -n 1
		done
	popd >/dev/null 2>&1 || die
}

get_compiler_info() {
	local type="${1}"
	pushd "${WORKDIR}/${type}/templates" >/dev/null 2>&1 || die
		local x
		for x in $(find . -executable -type f); do
echo
einfo "Inspecting ${x} (${type}):"
			strings "${x}" | grep -i -E -e "(gcc|clang).*[0-9]+\.[0-9]+\.[0-9]+" | sort -V | uniq
		done
	popd >/dev/null 2>&1 || die
}

get_compiler_info_osxcross() {
	local type="${1}"
	pushd "${WORKDIR}/${type}/templates" >/dev/null 2>&1 || die
		local L=(
			"ios.zip"
			"macos.zip"
		)
		local f
		for f in ${L[@]} ; do
			mkdir -p "sandbox" || die
			cp -a "${f}" "sandbox" || die
			pushd "sandbox" >/dev/null 2>&1 || die
				unzip -qq -x "${f}" || die
				local x
				for x in $(find . -executable -type f -o -name "*.a"); do
echo
einfo "Inspecting ${x} (${f}, ${type}):"
					strings "${x}" | grep -i -E -e "(gcc|clang).*[0-9]+\.[0-9]+\.[0-9]+" | sort -V | uniq
				done
			popd >/dev/null 2>&1 || die
			rm -rf "sandbox"
		done || die
	popd >/dev/null 2>&1 || die
}

src_configure() {
	use custom || return
einfo "Build info for developers:"
# Disclosed to prevent possible linking issues from versioned symbols
	if use standard ; then
		get_android_sdk_info "standard"
		get_glibc_info "standard"
		get_compiler_info "standard"
		get_compiler_info_osxcross "standard"
	fi
	if use mono ; then
		get_android_sdk_info "mono"
		get_glibc_info "mono"
		get_compiler_info "mono"
		get_compiler_info_osxcross "mono"
	fi
}

src_compile() {
	if use custom ; then
		if use mono ; then
			filter_mono
		fi
		if use standard ; then
			filter_standard
		fi
	fi
}

src_install() {
	export STRIP="true"
	insinto "/usr/share/godot/${SLOT}/prebuilt-export-templates"
	if ! use custom ; then
		use mono && doins $(realpath "${DISTDIR}/Godot_v${PV}-${STATUS}_mono_export_templates.tpz")
		use standard && doins $(realpath "${DISTDIR}/Godot_v${PV}-${STATUS}_export_templates.tpz")
	else
		if use mono ; then
			insinto "/usr/share/godot/${SLOT}/prebuilt-export-templates/mono"
			doins -r "${WORKDIR}/mono/"*
		fi
		if use standard ; then
			insinto "/usr/share/godot/${SLOT}/prebuilt-export-templates/standard"
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
	einfo "Developer details:"

einfo
einfo "Additional SDK minimum requirements:"
einfo
einfo ".NET SDK version:  ${DOTNET_SDK_PV}"
einfo "Android API minimum:  ${ANDROID_MIN_API}"
einfo "Android NDK version:  ${NDK_PV}"
einfo "Android SDK version:  ${ANDROID_SDK_VER}"
einfo "Clang version used with Emscripten:  ${CLANG_PV_EMSCRIPTEN}"
einfo "Emscripten version:  ${EMSCRIPTEN_PV}"
einfo "JDK version used for Android export template:  ${JDK_PV}"
einfo

einfo
einfo "Platform minimum versions required for export templates:"
einfo
einfo "Android:  ${ANDROID_MIN_VER} or later"
einfo "macOS:  ${MACOS_MIN_VER} or later"
einfo "iOS:  ${IOS_MIN_VER} or later"
einfo "Linux:  ${LINUX_MIN_VER} or later"
einfo "Web:  ${BROWSERS_MIN_VER} or later"
einfo "Windows:  ${WINDOWS_MIN_VER} or later"
einfo


einfo "CPU microarchitectures:  See metadata.xml"
ewarn "The x86-64 export templates require SSE 4.2 or Haswell or newer to prevent an illegal instruction error."
	if use custom ; then
		if use mono ; then
einfo
einfo "The following still must be done for export templates (Mono/C#):"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}.mono"
einfo "  cp -aT /usr/share/godot/${SLOT}/prebuilt-export-templates/mono/templates ~/.local/share/godot/templates/${PV}.${STATUS}.mono"
einfo
		fi
		if use standard ; then
einfo
einfo "The following still must be done for export templates (standard):"
einfo
einfo "  mkdir -p ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo "  cp -aT /usr/share/godot/${SLOT}/prebuilt-export-templates/standard/templates ~/.local/share/godot/templates/${PV}.${STATUS}"
einfo
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
