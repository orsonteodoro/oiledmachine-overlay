# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="MonoGame"
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
# ANDROID_MARCH=( arm arm64 x64 x86 ) # dotnet runtimes available
ANDROID_MARCH=( arm arm64 x64 x86 ) # Based on CI
#   arm=armv7
ANDROID_ERIDS="${ANDROID_MARCH[@]/#/dotnet_android_}"

# IOS_MARCH_=( arm arm64 x64 x86 ) # dotnet runtimes available
IOS_MARCH=( arm arm64 ) # Based on CI
IOS_ERIDS="${IOS_MARCH[@]/#/dotnet_ios_}"
# OS >= 11.2

# IOSSIMULATOR_MARCH_=( arm64 x64 x86 ) # dotnet runtimes available
IOSSIMULATOR_MARCH=( arm64 x64 x86 ) # Based on CI
IOSSIMULATOR_ERIDS="${IOSSIMULATOR_MARCH[@]/#/dotnet_iossimulator_}"

# arm here is armv7*hf only; armel is armv7*s*
# LINUX_MARCH=( arm arm64 armel armv6 loongarch64 ppc64le mips64 s390x x64 x86 ) # dotnet runtimes available
LINUX_MARCH=( x64 ) # Based on CI
LINUX_ERIDS="${LINUX_MARCH[@]/#/dotnet_linux_}"

# arm here is armv7 or armv6; armel is armv7*s*
# LINUX_MUSL_MARCH=( arm arm64 armel ppc64le s390x x64 x86 ) # dotnet runtimes available
LINUX_MUSL_MARCH=( ) # Based on CI
LINUX_MUSL_ERIDS="${LINUX_MUSL_MARCH[@]/#/dotnet_linux_musl_}"

# OSX_MARCH=( arm64 x64 ) # dotnet runtimes available
OSX_MARCH=( x64 ) # Based on CI
OSX_ERIDS="${OSX_MARCH[@]/#/dotnet_osx_}"

# UWP_MARCH=( arm arm64 x64 x86 ) # Based on Wikipedia
UWP_MARCH=( x64 ) # Guess
UWP_ERIDS="${UWP_MARCH[@]/#/dotnet_uwp_}"

# WIN_MARCH=( arm arm64 x64 x86 ) # dotnet runtimes available
WIN_MARCH=( x64 ) # Based on CI
WIN_ERIDS="${WIN_MARCH[@]/#/dotnet_win_}"

# emerge RIDs
#	${LINUX_MUSL_ERIDS[@]}
#	${IOSSIMULATOR_ERIDS[@]}
ERIDS=(
	${ANDROID_ERIDS[@]}
	${IOS_ERIDS[@]}
	${LINUX_ERIDS[@]}
	${OSX_ERIDS[@]}
	${UWP_ERIDS[@]}
	${WIN_ERIDS[@]}
)

IUSE+=" ${ERIDS[@]} "
REQUIRED_USE+="
	|| (
		${ERIDS[@]}
	)
	elibc_Cygwin? (
		|| (
			${UWP_ERIDS[@]}
			${WIN_ERIDS[@]}
		)
	)
	elibc_glibc? (
		|| (
			${LINUX_ERIDS[@]}
		)
	)
"
#	elibc_musl? ( || ( ${LINUX_MUSL_MARCH[@]} ) )

gen_linux_required_use() {
	local erid
	for erid in ${LINUX_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_glibc
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_linux_required_use)

gen_win_required_use() {
	local erid
	for erid in ${WIN_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_Cygwin
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_win_required_use)

gen_uwp_required_use() {
	local erid
	for erid in ${UWP_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_Cygwin
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_uwp_required_use)


# The dev-dotnet/dotnet-sdk-bin ebuild supports only one march
RDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
	media-libs/libpng
	sys-devel/gcc[openmp]
	sys-libs/zlib[minizip]
	virtual/libc
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
"

IUSE+="
	${PLATFORMS[@]}
	debug
	+linux
"

SRC_URI=""
SLOT="0/${PV}"
S="${WORKDIR}/${MY_P}"
RESTRICT="mirror"

DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-6.0" )

get_crid_platform() {
	local erid="${1}"
	local cplatform="${erid%-*}"
	cplatform="${cplatform/uwp/win}"
	echo "${cplatform}"
}

get_hrid_platform() {
	local erid="${1}"
	echo "${erid%-*}"
}

get_hrid_arch() {
	local erid="${1}"
	echo "${erid##*-}"
}

# erid_arch -> Gentoo arch
get_garch() {
	local erid="${1}"
	local garch="${erid/dotnet_}"
	garch="${garch##*_}"
	garch="${garch/x64/amd64}"
	garch="${garch/armel/arm}"
	echo "${garch}"
}

# Canonical rid (uwp is win)
get_crid() {
	local erid="${1}"
	local crid="${erid/dotnet_}"
	crid="${crid//_/-}"
	crid="${crid/uwp/win}"
	echo "${crid}"
}

# Hypothetical rid (uwp is uwp)
get_hrid() {
	local erid="${1}"
	local hrid="${erid/dotnet_}"
	hrid="${hrid//_/-}"
	echo "${hrid}"
}

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local found=0
	for sdk in ${DOTNET_SUPPORTED_SDKS[@]} ; do
		if [[ -e "${EPREFIX}/opt/${sdk}" ]] ; then
			export SDK="${sdk}"
			export PATH="${EPREFIX}/opt/${sdk}:${PATH}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "You need a dotnet SDK."
eerror
eerror "Supported SDK versions: ${DOTNET_SUPPORTED_SDKS[@]}"
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
		[linux-musl]="MonoGame.Tools.Linux.sln"
		[ios]="MonoGame.Framework.iOS.sln"
		[osx]="MonoGame.Tools.Mac.sln"
		[uwp]="MonoGame.Framework.WindowsUniversal.sln"
		[win]="MonoGame.Framework.WindowsDX.sln"
	)

	# It's still a mess or porting.
	# It doesn't fully disclose all the RID or microarches
	# See the rid-catalog
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local crid=$(get_crid "${erid}")
			local harch=$(get_hrid_arch "${hrid}")
			local hplatform=$(get_hrid_platform "${hrid}")
			prun \
			dotnet publish "${platforms[${hplatform}]}" ${args[@]} \
				-c "${configuration}" \
				-r "${crid}" \
				-o "${S}_${hrid}_${configuration}_build" \
				-p:PublishReadyToRun=false \
				-p:TieredCompilation=false \
				--self-contained
		fi
	done
	ewarn "WIP (Under Construction)"
	die
}

src_install() {
	local configuration=$(usex debug "Debug" "Release")
	local erid
	for erid in ${ERIDS} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local crid=$(get_crid "${erid}")
			local harch=$(get_hrid_arch "${hrid}")
			local hplatform=$(get_hrid_platform "${hrid}")
			insinto "/opt/${SDK}/shared/${MY_PN}.Host.${crid}/${MY_PV}"
			doins -r "${S}_${hrid}_${configuration}_build/"*
		fi
	done

	local libc_suffix=""

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
