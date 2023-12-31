# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="MonoGame"
MY_PV="3.8.1_HOTFIX"
MY_P="${PN}-${MY_PV}"

inherit git-r3 lcnr

# Multiple frameworks actually but highest is required
DOTNET_V="6.0"
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

KEYWORDS=" ~amd64 ~arm64-macos"

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

# Not supported by ebuild because of dotnet workload install uwp missing
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

IUSE+=" ${ERIDS[@]}"
REQUIRED_USE+="
	^^ (
		${ERIDS[@]}
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

# The dev-dotnet/dotnet-sdk-bin ebuild supports only one march
RDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_V}:${DOTNET_V}
	media-libs/libpng
	sys-devel/gcc[openmp]
	sys-libs/zlib[minizip]
	virtual/libc
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_V}:${DOTNET_V}
"

IUSE+="
	${PLATFORMS[@]}
	developer
	nupkg
"

SRC_URI=""
SLOT="0/$(ver_cut 1-2 ${PV})"
S="${WORKDIR}/${MY_P}"
RESTRICT="mirror"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-6.0" )

get_crid_platform() {
	local hrid="${1}"
	local cplatform="${hrid%-*}"
	cplatform="${cplatform/uwp/win}"
	echo "${cplatform}"
}

get_hrid_platform() {
	local hrid="${1}"
	echo "${hrid%-*}"
}

get_hrid_arch() {
	local hrid="${1}"
	echo "${hrid##*-}"
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
	[[ "${USE}" =~ ("android"|"ios"|"macos"|"uap"|"win") ]] && die "Linux only supported for now.  Disable all other platforms."
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

get_deploy_type() {
	echo "publish"
	use nupkg "pack"
}

_dotnet() {
	local command="${1}"
	local project="${2}"

	local extra_args=()
	if [[ "${project}" =~ "Templates.VSExtension" ]] ; then
		extra_args+=( -t:PackageAddin )
	fi

	if [[ "${command}" == "publish" && "${project}" =~ "MonoGame.Templates.VSExtension.csproj" ]] ; then
		extra_args+=( -f net472 )
	elif [[ "${command}" == "publish" && "${project}" =~ "MonoGame.Templates.CSharp.csproj" ]] ; then
		extra_args+=( -f netstandard2.0 )
	elif [[ "${command}" == "publish" && "${project}" =~ "MonoGame.Packaging.Flatpak.csproj" ]] ; then
		extra_args+=( -f netstandard2.0 )
	elif [[ "${command}" == "publish" ]] ; then
		extra_args+=( -f ${tfm} )
	fi

	if [[ \
		   "${command}" == "build" \
		|| "${command}" == "pack" \
		|| "${command}" == "publish" \
	]] ; then
		extra_args+=(
			--runtime "${crid}"
		)
	fi

	if [[ "${command}" =~ "msbuild" ]] ; then
		prun \
		dotnet "${command}" "${project}" \
			-p:Configuration=${configuration} \
			-p:RuntimeIdentifiers=${crid} \
			-p:PublishReadyToRun=false \
			-p:TieredCompilation=false \
			${extra_args[@]}
	else
		if [[ "${command}" == "build" || "${command}" == "publish" ]] ; then
			extra_args+=(
				--self-contained false
			)
		elif [[ "${command}" == "pack" ]] ; then
			extra_args+=(
				-t:Pack
			)
		fi

		prun \
		dotnet "${command}" "${project}" \
			-c "${configuration}" \
			-p:PublishReadyToRun=false \
			-p:TieredCompilation=false \
			${extra_args[@]}
	fi
}

_build_build_tools() {
	local build_tools_A=(
		"Tools/MonoGame.Content.Builder/MonoGame.Content.Builder.csproj"
		"Tools/MonoGame.Effect.Compiler/MonoGame.Effect.Compiler.csproj"
		"Tools/MonoGame.Content.Builder.Task/MonoGame.Content.Builder.Task.csproj"
		"Tools/MonoGame.Packaging.Flatpak/MonoGame.Packaging.Flatpak.csproj"
	)

	local p
	for p in ${build_tools_A[@]} ; do
		_dotnet "${deploy_type}" "${p}"
	done

	local arch2
	if [[ "${harch}" =~ "win" ]] ; then
		arch2="Windows"
	elif [[ "${harch}" =~ "osx" ]] ; then
		arch2="Mac"
	else
		arch2="Linux"
	fi

	_dotnet "${deploy_type}" "Tools/MonoGame.Content.Builder.Editor/MonoGame.Content.Builder.Editor.${arch2}.csproj"
	_dotnet "${deploy_type}" "Tools/MonoGame.Content.Builder.Editor.Launcher/MonoGame.Content.Builder.Editor.Launcher.${arch2}.csproj"
	_dotnet "${deploy_type}" "Tools/MonoGame.Content.Builder.Editor.Launcher.Bootstrap/MonoGame.Content.Builder.Editor.Launcher.Bootstrap.csproj"
}

_build_content_pipeline() {
	_dotnet "${deploy_type}" "Tools/MonoGame.Effect.Compiler/MonoGame.Effect.Compiler.csproj"
	_dotnet "${deploy_type}" "MonoGame.Framework.Content.Pipeline/MonoGame.Framework.Content.Pipeline.csproj"
}

_build_templates() {
	local templates=(
		"Templates/MonoGame.Templates.CSharp/MonoGame.Templates.CSharp.csproj"
		"Templates/MonoGame.Templates.VSMacExtension/MonoGame.Templates.VSMacExtension.csproj"
		"Templates/MonoGame.Templates.VSExtension/MonoGame.Templates.VSExtension.csproj"
	)
	local p
	for p in ${templates[@]} ; do
		if [[ "${p}" =~ "Templates.CSharp" ]] ; then
			_dotnet "${deploy_type}" "${p}"
		elif [[ "${p}" =~ "Templates.VSExtension" && "${native_hrid}" =~ "win" ]] ; then
			_dotnet "msbuild" "${p}"
		elif [[ "${p}" =~ "Templates.VSMacExtension" ]] && has_version "dev-util/monodevelop" ; then
			_dotnet "build" "${p}"
		fi
	done
}

_build_init() {
	export MGFXC_WINE_PATH="${HOME}/.winemonogame"
}

_build_console_check() {
	[[ "${hrid_native}" =~ "win" ]] || return
	_dotnet "build" "MonoGame.Framework/MonoGame.Framework.ConsoleCheck.csproj"
}

_run_tests() {
	# Run test with virtx?
	if [[ "${native_hrid}" =~ "win" ]] ; then
		_dotnet "run" "Tests/MonoGame.Tests.WindowsDX.csproj"
	elif [[ "${native_hrid}" =~ "osx" ]] ; then
		_dotnet "run" "Tests/MonoGame.Tests.DesktopGL.csproj"
	elif [[ "${native_hrid}" =~ "linux" ]] ; then
		_dotnet "run" "Tests/MonoGame.Tests.DesktopGL.csproj"
	fi
	_dotnet "run" "Tools/MonoGame.Tools.Tests/MonoGame.Tools.Tests.csproj"
}

get_native_hrid() {
	# Based on gcc -dumpmachine
	local arch="${CBUILD%%-*}"
	if [[ "${CBUILD}" =~ "linux" ]] ; then
		echo "linux-${arch}"
	elif [[ "${CBUILD}" =~ ("apple"|"darwin") ]] ; then
		echo "osx-${arch}"
	elif [[ "${CBUILD}" =~ ("mingw") ]] ; then
		echo "win-${arch}"
	else
		echo "unknown-unknown"
	fi
}

_build_monogame_framework() {
	unset monogame_framework
	declare -A monogame_framework=(
		[android]="MonoGame.Framework/MonoGame.Framework.Android.csproj"
		[linux]="MonoGame.Framework/MonoGame.Framework.DesktopGL.csproj"
		[linux-musl]="MonoGame.Framework/MonoGame.Framework.DesktopGL.csproj"
		[ios]="MonoGame.Framework/MonoGame.Framework.iOS.csproj"
		[osx]="MonoGame.Framework/MonoGame.Framework.DesktopGL.csproj"
		[uwp]="MonoGame.Framework/MonoGame.Framework.WindowsUniversal.csproj"
		[win]="MonoGame.Framework/MonoGame.Framework.WindowsDX.csproj"
	)
	_dotnet "${deploy_type}" "${monogame_framework[${hplatform}]}"
}

src_prepare() {
	default
	local configuration="Release"
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			cp -a "${S}" "${S}_${hrid}_${configuration}" || die
		fi
	done
}

_init_workloads() {
	unset workloads
	declare -A workloads=(
		[android]="0"
		[ios]="0"
		[macos]="0"
	)
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local cplatform=$(get_crid_platform "${hrid}")
			[[ "${cplatform}" == "android" ]] && workloads[android]=1
			[[ "${cplatform}" == "ios" && "${native_hrid}" =~ "win" ]] && workloads[ios]=1 # Not available from Linux
			[[ "${cplatform}" == "osx" ]] && workloads[macos]=1
		fi
	done

	# Only download once per platform
	for k in ${!workloads[@]} ; do
		if [[ "${workloads[${k}]}" == "1" ]] ; then
			# Bug dotnet restore cannnot use it
			dotnet workload install "${k}" || die
		fi
	done
}

src_compile() {
	local configuration="Release"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	#_init_workloads

	local native_hrid="$(get_native_hrid)"

	# It's still a mess or porting.
	# It doesn't fully disclose all the RID or microarches
	# See the rid-catalog
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			pushd "${S}_${hrid}_${configuration}" || die
			local crid=$(get_crid "${erid}")
			local hplatform=$(get_hrid_platform "${hrid}")

			local garch=$(get_garch "${erid}")

			local tfm
			local tfm2
			if [[ "${hplatform}" =~ ("uwp") ]] ; then
				tfm="uap${UAP_VERSION_MIN}"
				tfm2="v6.0"
			elif [[ "${hplatform}" =~ ("iossimulator") ]] ; then
				tfm="net${DOTNET_V}-ios"
				tfm2="v6.0"
			elif [[ "${hplatform}" =~ ("android"|"ios"|"windows") ]] ; then
				tfm="net${DOTNET_V}-${hplatform}"
				tfm2="v6.0"
			else
				tfm="net${DOTNET_V}"
				tfm2="v6.0"
			fi

			# Corresponds to build.cake
			local deploy_type
			for deploy_type in $(get_deploy_type) ; do
				_build_init
				_build_console_check
				_build_monogame_framework
				_build_content_pipeline
				_build_build_tools
				_build_templates
			done

			if [[ "${CHOST}" == "${CBUILD}" && "${hrid}" == "${native_hrid}" ]] ; then
				_run_tests
			fi
			popd || die
		fi
	done
}

add_nupkg() {
	local x
	for x in $(find "${S}_${hrid}_${configuration}/Artifacts/${ns}" -name "*.nupkg") ; do
		doins "${x}"
	done
}

add_ns() {
	local namespace="${1}"
	local d
	[[ -e "${S}_${hrid}_${configuration}/Artifacts/${ns}" ]] || return
	for d in $(find "${S}_${hrid}_${configuration}/Artifacts/${ns}" \
		-name "publish" \
		-type d) ; do
		if [[ "${d}" =~ "publish" ]] ; then
			# Really messy.  Needs to get rid of incompatible microarches.
			doins -r "${d}/"*
		fi
	done
}

# Deletes all other march folders != target carch
prune_marches_folders() {
	local path="${1}"
	local carch="${2}" # Target microarch
	local MARCH=(
		"arm"
		"arm64"
		"armel"
		"armv6"
		"loongarch64"
		"mips64"
		"ppc64le"
		"s390x"
		"x64"
		"x86"
	)

	local march
	for march in ${MARCH[@]} ; do
		local d
		for d in $(find "${path}" -type d -name "${march}") ; do
			local a
			a=$(basename "${d}")
			if [[ "${a}" != "${carch}" ]] ; then
				rm -vrf "${d}" || true
			fi
		done
	done
}

# Deletes all other march .so/bin/assemblies != target hrid
prune_marches_bin() {
	local hrid="${1}"
	# Remove junk files output by from dotnet publish.
	einfo "Pruning binaries for non-native arches"
	for f in $(find "${ED}/opt/${SDK}/shared/${ns}.${hrid}/${MY_PV}/${tfm}" -type f) ; do
		if file "${f}" | grep -q -e "PE32 executable (DLL).*Mono/.Net assembly" ; then
			continue # .dll
		elif ! [[ "${hrid}" =~ "uap-x64" ]] && strings "${f}" | grep -q -e "mrm_pri2" ; then
			# file doesn't support pri file magic yet used with uap
			rm -vrf "${f}" # .pri
		elif [[ "${hrid}" != "android-arm" ]] && file "${f}" | grep -q -e "ELF.*shared object.*EABI5" ; then
			rm -vrf "${f}" # .so
		elif [[ "${hrid}" != "android-arm64" ]] && file "${f}" | grep -q -e "ELF.*shared object.*aarch64" ; then
			rm -vrf "${f}" # .so
		elif [[ "${hrid}" != "android-arm64" && "${hrid}" != "linux-x64" ]] && file "${f}" | grep -q -e "ELF.*shared object.*x86-64" ; then
			rm -vrf "${f}" # .so
		elif [[ "${hrid}" != "android-x86" && "${hrid}" != "linux-x86" ]] && file "${f}" | grep -q -e "ELF.*shared object.*80386" ; then
			rm -vrf "${f}" # .so
		elif [[ "${hrid}" != "linux-x64" ]] && file "${f}" | grep -q -e "ELF.*executable.*x86-64.*Linux" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "linux-x86" ]] && file "${f}" | grep -q -e "ELF.*executable.*80386.*Linux" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "linux-x64" ]] && file "${f}" | grep -q -e "ELF.*executable.*x86-64" && readelf -n "${f}" | grep -q -e "Linux" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "linux-x86" ]] && file "${f}" | grep -q -e "ELF.*executable.*80386" && readelf -n "${f}" | grep -q -e "Linux" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "android-x64" ]] && file "${f}" | grep -q -e "ELF.*executable.*x86-64" && readelf -n "${f}" | grep -q -e "Android" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "android-x86" ]] && file "${f}" | grep -q -e "ELF.*executable.*80386" && readelf -n "${f}" | grep -q -e "Android" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "ios-arm" ]] && file "${f}" | grep -q -E -e "arm(|_v7):.*dynamically linked shared library" ; then
			rm -vrf "${f}" # dylib
		elif [[ "${hrid}" != "ios-arm64" ]] && file "${f}" | grep -q -E -e "arm64(|e):.*dynamically linked shared library" ; then
			rm -vrf "${f}" # dylib
		elif [[ "${hrid}" != "osx-x64" ]] && file "${f}" | grep -q -e "x86_64:.*dynamically linked shared library" ; then
			rm -vrf "${f}" # dylib
		elif [[ "${hrid}" != "osx-x64" ]] && file "${f}" | grep -q -e "Mach-O.*x86_64 executable" ; then
			rm -vrf "${f}" # executable
		elif [[ "${hrid}" != "win-x86" ]] && file "${f}" | grep -q -e "PE32 executable.*Windows" ; then
			rm -vrf "${f}" # .exe
		elif [[ "${hrid}" != "win-x64" ]] && file "${f}" | grep -q -e "PE32[+] executable.*Windows" ; then
			rm -vrf "${f}" # .exe
		fi
	done
}

_install() {
	local NS=(
		"MonoGame.Framework.Android"
		"MonoGame.Framework.DesktopGL"
		"MonoGame.Framework.iOS"
		"MonoGame.Framework.WindowsDX"

		"MonoGame.Templates.CSharp"

		"MonoGame.Effect.Compiler"
		"MonoGame.Framework.Content.Pipeline"
		"MonoGame.Packaging.Flatpak"

		"MonoGame.Content.Builder"
		"MonoGame.Content.Builder.Task"
		"MonoGame.Content.Builder.Editor.Windows"
		"MonoGame.Content.Builder.Editor.Launcher.Windows"
		"MonoGame.Content.Builder.Editor.Mac"
		"MonoGame.Content.Builder.Editor.Launcher.Mac"
		"MonoGame.Content.Builder.Editor.Linux"
		"MonoGame.Content.Builder.Editor.Launcher.Linux"
		"MonoGame.Content.Builder.Editor.Launcher.Bootstrap"
	)

	# These namespaces are usually split in nupkg.
	# Split here also
	local ns
	for ns in ${NS[@]} ; do
		local tfm=""
		if [[ "${ns}" =~ "MonoGame.".*"Android" ]] ; then
			tfm="net${DOTNET_V}-macos"
		elif [[ "${ns}" =~ "MonoGame.".*"iOS" ]] ; then
			tfm="net${DOTNET_V}-ios"
		elif [[ "${ns}" =~ "MonoGame.".*"Mac" ]] ; then
			tfm="net${DOTNET_V}-macos"
		elif [[ "${ns}" =~ "MonoGame.".*"WindowsUniversal" ]] ; then
			tfm="uap${UAP_VERSION_MIN}"
		elif [[ "${ns}" =~ "MonoGame.".*"Windows" ]] ; then
			tfm="net${DOTNET_V}-windows"
		elif [[ "${ns}" =~ "MonoGame.Packaging.Flatpak" ]] ; then
			tfm="netstandard2.0"
		elif [[ "${ns}" =~ "MonoGame.Templates.CSharp" ]] ; then
			tfm="netstandard2.0"
		elif [[ "${ns}" =~ "MonoGame.Templates.VSExtension" ]] ; then
			tfm="net472"
		else
			tfm="net${DOTNET_V}"
		fi
		insinto "/opt/${SDK}/shared/${ns}.${hrid}/${MY_PV}/${tfm}"
		add_ns "${ns}"
		insinto "/opt/${SDK}/packs/${ns}.${hrid}/${MY_PV}/${tfm}"

		use nupkg && add_nupkg "${p}"

		einfo "Pruning non-native microarchitecture folders"
		prune_marches_bin "${hrid}"
		prune_marches_folders "${ED}/opt/${SDK}/shared/${ns}.${hrid}/${MY_PV}/${tfm}" "${crid#*-}"
	done
}

src_install() {
	local configuration="Release"
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local crid=$(get_crid "${erid}")
			local hplatform=$(get_hrid_platform "${hrid}")
			local x
			_install
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
		elif file "${x}" | grep -q "shared library" ; then
			fperms 0775 "${path}"
		fi
	done
	if ! use developer ; then
		find "${ED}" \( -name "*.pdb" -o -name "*.xml" \) -delete
	fi

	LCNR_SOURCE="${HOME}/.nuget"
	LCNR_TAG="third_party"
	lcnr_install_files

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

pkg_postinst() {
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

	local libdirs=$(find "${ED}" -name "*.so*" -exec bash -c "dirname {}" \; \
		| uniq \
		| tr "\n" ":" \
		| sed -e "s|${ED}||g")

#
# We don't do it systemwide via env.d because it may conflict with the system
# package.
#
einfo
einfo "You must manually set LD_LIBRARY_PATH=\"${libdirs}:\${LD_LIBRARY_PATH}\""
einfo "in order for P/Invoke to work properly."
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-QUALITY:  BUILDS
# OILEDMACHINE-OVERLAY-META-TAGS:  work-in-progress untested
# OILEDMACHINE-OVERLAY-META-DETAILED-NOTES:
