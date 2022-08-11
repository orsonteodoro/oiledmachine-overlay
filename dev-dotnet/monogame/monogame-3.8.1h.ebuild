# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV="3.8.1_HOTFIX"
MY_P="${PN}-${MY_PV}"

inherit git-r3

FRAMEWORK="6.0"
UAP_VERSION_MIN="10.0"

DESCRIPTION="One framework for creating powerful cross-platform games."
HOMEPAGE="http://www.monogame.net"
LICENSE="
	Ms-PL
	MIT
	Apache-2.0
	GamepadConfig
	FIPL-1.0
	FTL
	BSD MIT
	GPL-2
	GPL-2+
	GPL-3
	LGPL-2
	LGPL-2.1+
	LGPL-3
	WTFPL
	ZLIB
"
# Many licenses because of the ThirdParty folder.
# Ms-PL*, MIT - LICENSE.txt
# Apache-2.0 - ThirdParty/Dependencies/ffmpeg/licenses/vo-aacenc.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/opencore-amr.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/vo-amrwbenc.txt
# BSD, MIT - ThirdParty/Dependencies/assimp/Assimp_License.txt
# BSD - ThirdParty/Dependencies/ffmpeg/licenses/opus.txt
# custom (for commerical & noncommerial using MonoGame) - ThirdParty/GamepadConfig/License.txt
# Ms-PL - ThirdParty/Dependencies/NVorbis/COPYING, ThirdParty/NVorbis/LICENSE
# FIPL-1.0 - ThirdParty/Dependencies/FreeImage.NET/license-fi.txt
# FTL - ThirdParty/Dependencies/ffmpeg/licenses/freetype.txt
# MIT - ThirdParty/Dependencies/Tests/NDesk_LICENSE.txt, \
#   ThirdParty/Dependencies/SharpDX/License.txt
# MIT - ThirdParty/Dependencies/SharpDoc/Styles/Standard/syntaxhighlighter/MIT-LICENSE
# GPL-2 - ThirdParty/Dependencies/makeself/COPYING, \
#   ThirdParty/Dependencies/ffmpeg/licenses/rtmpdump.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/frei0r.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/x264.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/lame.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/x265.txt \
#   ThirdParty/Dependencies/ffmpeg/licenses/xvid.txt
# GPL-2+ - Dependencies/ffmpeg/licenses/vid.stab.txt
# GPL-3 - ThirdParty/Dependencies/ffmpeg/licenses/libiconv.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/xavs.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/gnutls.txt
# LGPL-2 - ThirdParty/Dependencies/ffmpeg/licenses/schroedinger.txt
# LGPL-3 - ThirdParty/Dependencies/SharpDoc/Styles/Standard/syntaxhighlighter/LGPL-LICENSE
# LGPL-2.1+ - ThirdParty/Dependencies/ffmpeg/licenses/soxr.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/twolame.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/libbluray.txt, \
#   ThirdParty/Dependencies/ffmpeg/licenses/gme.txt
# WTFPL - ThirdParty/Dependencies/ffmpeg/licenses/libcaca.txt
# ZLIB - ThirdParty/SDL_GameControllerDB/LICENSE
# ZLIB - ThirdParty/Dependencies/Tests/nunit_LICENSE.txt

KEYWORDS=" ~amd64 ~x64-cygwin ~arm64-macos"

# Some arches are disabled because of internal assemblies are prebuilt.

# For dotnet runtimes, see https://github.com/dotnet/runtime/blob/main/src/libraries/Microsoft.NETCore.Platforms/src/runtime.json
# For CI and supported platforms, see https://github.com/MonoGame/MonoGame/blob/v3.8.1_HOTFIX/build.cake
#arm here is armv7
# ANDROID_MARCH_=( arm arm64 x64 x86 ) # dotnet runtimes available
ANDROID_MARCH_=( arm arm64 x64 x86 ) # Based on CI
#   arm=armv7
ANDROID_MARCH="${ANDROID_MARCH_[@]/#/monogame_android_}"

# IOS_MARCH_=( arm arm64 x64 x86 ) # dotnet runtimes available
IOS_MARCH_=( arm arm64 ) # Based on CI
IOS_MARCH="${IOS_MARCH_[@]/#/monogame_ios_}"
# OS >= 11.2

# IOSSIMULATOR_MARCH_=( arm64 x64 x86 ) # dotnet runtimes available
IOSSIMULATOR_MARCH_=( arm64 x64 x86 ) # Based on CI
IOSSIMULATOR_MARCH="${IOSSIMULATOR_MARCH_[@]/#/monogame_iossimulator_}"

# arm here is armv7*hf only; armel is armv7*s*
# LINUX_MARCH_=( arm arm64 armel armv6 loongarch64 ppc64le mips64 s390x x64 x86 ) # dotnet runtimes available
LINUX_MARCH_=( x64 ) # Based on CI
LINUX_MARCH="${LINUX_MARCH_[@]/#/monogame_linux_}"

# arm here is armv7 or armv6; armel is armv7*s*
# LINUX_MUSL_MARCH_=( arm arm64 armel ppc64le s390x x64 x86 ) # dotnet runtimes available
LINUX_MUSL_MARCH_=( ) # Based on CI
LINUX_MUSL_MARCH="${LINUX_MUSL_MARCH_[@]/#/monogame_linux_musl_}"

# OSX_MARCH_=( arm64 x64 ) # dotnet runtimes available
OSX_MARCH_=( x64 ) # Based on CI
OSX_MARCH="${OSX_MARCH_[@]/#/monogame_osx_}"

# WIN_MARCH_= ( arm arm64 x64 x86 ) # dotnet runtimes available
WIN_MARCH_=( x64 ) # Based on CI
WIN_MARCH="${WIN_MARCH_[@]/#/monogame_win_}"


#	${LINUX_MUSL_MARCH[@]}
#	${IOSSIMULATOR_MARCH[@]}
ALL_ARCHES=(
	${ANDROID_MARCH[@]}
	${IOS_MARCH[@]}
	${LINUX_MARCH[@]}
	${OSX_MARCH[@]}
	${WIN_MARCH[@]}
)

IUSE+=" ${ALL_ARCHES[@]} "
REQUIRED_USE+="
	|| ( ${ALL_ARCHES[@]} )
	elibc_Cygwin? ( || ( ${WIN_MARCH[@]} ) )
	elibc_glibc? ( || ( ${LINUX_MARCH[@]} ) linux )
	uwp? ( elibc_Cygwin )
"
#	elibc_musl? ( || ( ${LINUX_MUSL_MARCH[@]} ) )

# The dev-dotnet/dotnet-sdk-bin ebuild supports only one march
RDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
	linux? (
		media-libs/libpng
		sys-devel/gcc[openmp]
		sys-libs/zlib[minizip]
		virtual/libc
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
"
PLATFORMS=(android ios linux macos uwp windowsdx)

IUSE+="
	${PLATFORMS[@]}
	debug
	+linux
"
REQUIRED_USE+=" || ( ${PLATFORMS[@]} )"

gen_required_use_android() {
	local flag
	for flag in ${ANDROID_MARCH[@]} ; do
		echo "
			${flag}? ( android )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_android)

gen_required_use_ios() {
	local flag
	for flag in ${IOS_MARCH[@]} ; do
		echo "
			${flag}? ( ios )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_ios)

gen_required_use_iossimulator() {
	local flag
	for flag in ${IOSSIMULATOR_MARCH[@]} ; do
		echo "
			${flag}? ( ios )
		"
	done
}
#REQUIRED_USE+=" "$(gen_required_use_iossimulator)

gen_required_use_linux() {
	local flag
	for flag in ${LINUX_MARCH[@]} ; do
		echo "
			${flag}? ( linux )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_linux)

gen_required_use_linux_musl() {
	local flag
	for flag in ${LINUX_MUSL_MARCH[@]} ; do
		echo "
			${flag}? ( linux )
		"
	done
}
#REQUIRED_USE+=" "$(gen_required_use_linux_musl)

gen_required_use_osx() {
	local flag
	for flag in ${OSX_MARCH[@]} ; do
		echo "
			${flag}? ( macos )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_osx)

gen_required_use_uwp() {
	local flag
	for flag in ${UWP_MARCH[@]} ; do
		echo "
			${flag}? ( uwp )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_uwp)

gen_required_use_windowsdx() {
	local flag
	for flag in ${WIN_MARCH[@]} ; do
		echo "
			${flag}? ( windowsdx )
		"
	done
}
REQUIRED_USE+=" "$(gen_required_use_windowsdx)

SRC_URI=""
SLOT="0/${PV}"
S="${WORKDIR}/${MY_P}"
RESTRICT="mirror"

SUPPORTED_SDKS=(6.0)

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local found=0
	for pv in ${SUPPORTED_SDKS} ; do
		if [[ -e "${EPREFIX}/opt/dotnet-sdk-bin-${pv}" ]] ; then
			export PATH="/opt/dotnet-sdk-bin-${pv}:${PATH}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "You need dev-dotnet/dotnet-sdk-bin."
eerror
eerror "Supported SDK versions: ${SUPPORTED_SDKS}"
eerror
		die
	fi
}

src_unpack() {
	# For .gitmodules
	local my_pv="${PV}"
	EGIT_COMMIT="v${MY_PV}"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/MonoGame/MonoGame.git"
	git-r3_fetch
	git-r3_checkout
}

# print command and run
prun() {
	local args=(${@})
	einfo "command:  ${args[@]}"
	"${args[@]}" || die
}

src_compile() {
	local configuration=$(usex debug "Debug" "Release")
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	declare -A platforms=(
		[android]="MonoGame.Framework.Android.sln"
		[linux]="MonoGame.Tools.Linux.sln"
		[ios]="MonoGame.Framework.iOS.sln"
		[macos]="MonoGame.Tools.Mac.sln"
		[uwp]="MonoGame.Framework.WindowsUniversal.sln"
		[windowsdx]="MonoGame.Framework.WindowsDX.sln"
	)

	# It's still a mess or porting.
	# It doesn't fully disclose all the RID or microarches
	# See the rid-catalog
	local arch

	if use android ; then
		for arch in ${ANDROID_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_android_}"
				prun \
				dotnet build "${platforms[android]}" ${args[@]} \
					-c "${configuration}" \
					-r "android-${arch}" \
					-o "${S}_android_${arch}_${configuration}_build"
			fi
		done
	fi
	if use ios ; then
		for arch in ${IOS_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_ios_}"
				prun \
				dotnet build "${platforms[ios]}" ${args[@]} \
					-c "${configuration}" \
					-r "ios-${arch}" \
					-o "${S}_ios_${arch}_${configuration}_build"
			fi
		done
		for arch in ${IOSSIMULATOR_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_iossimulator_}"
				prun \
				dotnet build "${platforms[ios]}" ${args[@]} \
					-c "${configuration}" \
					-r "iossimulator-${arch}" \
					-o "${S}_iossimulator_${arch}_${configuration}_build"
			fi
		done
	fi
	if use linux ; then
		for arch in ${LINUX_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_linux_}"
				prun \
				dotnet build "${platforms[linux]}" ${args[@]} \
					-c "${configuration}" \
					-r "linux-${arch}" \
					-o "${S}_linux_${arch}_${configuration}_build"
			fi
		done
#		for arch in ${LINUX_MUSL_MARCH[@]} ; do
#			if use "${arch}" ; then
#				arch="${arch/monogame_linux_musl_}"
#				prun \
#				dotnet build "${platforms[linux]}" ${args[@]} \
#					-c "${configuration}" \
#					-r "linux-musl-${arch}" \
#					-o "${S}_linux_musl_${arch}_${configuration}_build"
#			fi
#		done
	fi
	if use macos ; then
		for arch in ${OSX_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_osx_}"
				prun \
				dotnet build "${platforms[macos]}" ${args[@]} \
					-c "${configuration}" \
					-r "osx-${arch}" \
					-o "${S}_macos_${arch}_${configuration}_build"
			fi
		done
	fi
	if use uwp ; then
		for arch in ${WIN_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_win_}"
				prun \
				dotnet build "${platforms[uwp]}" ${args[@]} \
					-c "${configuration}" \
					-r "win-${arch}" \
					-o "${S}_uwp_${configuration}_build"
			fi
		done
	fi
	if use windowsdx ; then
		for arch in ${WIN_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_win_}"
				prun \
				dotnet build "${platforms[windowsdx]}" ${args[@]} \
					-c "${configuration}" \
					-r "win-${arch}" \
					-o "${S}_windowsdx_${arch}_${configuration}_build"
			fi
		done
	fi
}

src_install() {
	local configuration=$(usex debug "Debug" "Release")
	local arch
	if use android ; then
		for arch in ${ANDROID_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_android_}"
				insinto "/opt/monogame-android/${arch}"
				doins -r "${S}_android_${arch}_${configuration}_build"
			fi
		done
	fi
	if use ios ; then
		for arch in ${LINUX_MARCH[@]} ; do
			if use "${arch}" ; then
				arch=$"{arch/monogame_ios_}"
				insinto "/opt/monogame-ios/${arch}"
				doins -r "${S}_ios_${arch}_${configuration}_build"
			fi
		done
		for arch in ${IOSSIMULATOR_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_iossimulator_}"
				insinto "/opt/monogame-iossimulator/${arch}"
				doins -r "${S}_iossimulator_${arch}_${configuration}_build"
			fi
		done
	fi
	if use linux ; then
		for arch in ${LINUX_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_linux_}"
				insinto "/opt/monogame-linux/${arch}"
				doins -r "${S}_linux_${arch}_${configuration}_build"
			fi
		done

#		for arch in ${LINUX_MUSL_MARCH[@]} ; do
#			if use "${arch}" ; then
#				arch="${arch/monogame_linux_musl_}"
#				insinto "/opt/monogame-linux-musl/${arch}"
#				doins -r "${S}_linux_musl_${arch}_${configuration}_build"
#			fi
#		done
	fi
	if use macos ; then
		for arch in ${OSX_MARCH[@]} ; do
			if use ${arch} ; then
				arch="${arch/monogame_osx_}"
				insinto "/opt/monogame-macos/${arch}"
				doins -r "${S}_macos_${arch}_${configuration}_build"
			fi
		done
	fi
	if use uwp ; then
		for arch in ${WIN_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_win_}"
				insinto "/opt/monogame-uwp/${arch}"
				doins -r "${S}_uwp_${arch}_${configuration}_build"
			fi
		done
	fi
	if use windowsdx ; then
		for arch in ${WIN_MARCH[@]} ; do
			if use "${arch}" ; then
				arch="${arch/monogame_win_}"
				insinto "/opt/monogame-windowsdx/${arch}"
				doins -r "${S}_windowsdx_${arch}_${configuration}_build"
			fi
		done
	fi

	local libc_suffix=""
#	[[ "${CHOST}" == "${CBUILD}" && "${CHOST}" =~ "musl" ]] && libc_suffix="-musl"

	#
	# To claify the ambiguity of arm, armv6, armel, ..., etc, see
	#
	#   https://github.com/dotnet/installer/blob/v6.0.400/eng/common/cross/toolchain.cmake
	#   https://github.com/dotnet/runtime/blob/v6.0.8/eng/common/cross/toolchain.cmake
	#
	# arm = armv7*hf (hard float)
	# armel = armv7 (soft float)
	# armv6 only supported on musl
	#
	# This distro assumes arm is armv6 (in rust eclass), the package assumes
	# arm is armv7 or if building for alpine [musl] armv6 or armv7
	#

	# Native
	if [[ "${CHOST}" == "${CBUILD}" ]] && use arm && [[ "${CHOST}" =~ "armv7".*"hf" ]] ; then
		dosym "/opt/monogame-linux${libc_suffix}/arm" "/opt/monogame"
	elif [[ "${CHOST}" == "${CBUILD}" ]] && use arm && [[ "${CHOST}" =~ "armv7" ]] ; then
		# Soft float
		dosym "/opt/monogame-linux${libc_suffix}/armel" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use arm && [[ "${CHOST}" =~ "armv6" ; then
#		dosym "/opt/monogame-linux${libc_suffix}/armv6" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use arm && [[ "${CHOST}" =~ "armv6" ; then
#		dosym "/opt/monogame-linux${libc_suffix}/arm" "/opt/monogame"
	elif [[ "${CHOST}" == "${CBUILD}" ]] && use arm64 ; then
		dosym "/opt/monogame-linux${libc_suffix}/arm64" "/opt/monogame"

	elif [[ "${CHOST}" == "${CBUILD}" ]] && use amd64 ; then
		# It does have .so files and executible programs so multilib
		dosym "/opt/monogame-linux/x64" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use loong && [[ "${CHOST}" =~ "loongarch64" ]] ; then
#		dosym "/opt/monogame-linux/loongarch64" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use mips && [[ "${CHOST}" =~ "mips64" ]] ; then
#		dosym "/opt/monogame-linux/mips64" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use ppc64 ; then
#		dosym "/opt/monogame-linux${libc_suffix}/ppc64le" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use s390x ; then
#		dosym "/opt/monogame-linux${libc_suffix}/s390x" "/opt/monogame"
#	elif [[ "${CHOST}" == "${CBUILD}" ]] && use x86 ; then
#		dosym "/opt/monogame-linux${libc_suffix}/x86" "/opt/monogame"

	# Gentoo Prefix / crossdev
#	elif use x86-linux ; then
# You can only do Gentoo Prefix because dev-dotnet/dotnet-sdk-bin ebuild is not
# multiabi.  But, the same ebuild doesn't support Gentoo Prefix (no KEYWORD).
#		dosym "/opt/monogame-linux/x86" "/opt/monogame"
	elif use x64-macos  ; then
		dosym "/opt/monogame-macos/x64" "/opt/monogame"
	elif use arm64-macos  ; then
		dosym "/opt/monogame-macos/arm64" "/opt/monogame"
	elif use x64-cygwin  ; then
		dosym "/opt/monogame-win/x64" "/opt/monogame"
	else
einfo
einfo "You are responsible to setting the symlink from"
einfo "/opt/monogame-\${platform}/\${arch} -> opt/monogame"
einfo
	fi

einfo
einfo "Restoring file permissions"
einfo
	local x
	for x in $(find "${ED}") ; do
		local path=$(echo "${x}" | sed -e "s|${ED}||g")
		if file "${x}" | grep -q "executable" ; then
			fperms 0775 "${path}"
		elif file "${x}" | grep -q "shared object" ; then
			fperms 0775 "${path}"
		fi
	done
}

pkg_posinst() {
ewarn
ewarn "Security Notice:"
ewarn
ewarn "It may contain vulnerable third party executables and library files."
ewarn
ewarn "Linux port:"
ewarn
ewarn "  FFmpeg dated 2014 (commit: 2351ea8, corresponding to 2.2git, vulnerable)"
ewarn "  Freetype: unknown version"
ewarn "  libpng:  1.6.34 (vulnerable)"
ewarn
ewarn "For details on vulnerabilities see"
ewarn
ewarn "FFMpeg 2.2:  https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=ffmpeg%202.2&search_type=all"
ewarn "libpng:  https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=1.6.34%20libpng&search_type=all"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-QUALITY:  BUILDS
# OILEDMACHINE-OVERLAY-META-TAGS:  work-in-progress untested
# OILEDMACHINE-OVERLAY-META-DETAILED-NOTES:
