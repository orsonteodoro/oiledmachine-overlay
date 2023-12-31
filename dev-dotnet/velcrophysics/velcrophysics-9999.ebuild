# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 lcnr

DESCRIPTION="High performance 2D collision detection system with realistic \
physics responses."
HOMEPAGE="https://github.com/Genbox/VelcroPhysics"
PROJECT_NAME="VelcroPhysics"
LICENSE="MIT Ms-PL"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
IUSE="net50 net60 demo hello-world mono monogame samples standalone testbed"
REQUIRED_USE="
	|| ( monogame standalone )
	|| ( net50 net60 )
	demo? ( samples )
	hello-world? ( samples )
	samples? (
		|| (
			demo
			hello-world
			testbed
		)
	)
	testbed? ( samples )

	net60? (
		!demo
		!hello-world
		!testbed
	)
	mono? ( standalone )
	!net50
" # net50 not tested
RDEPEND="
	mono? ( dev-lang/mono )
	monogame? (
		net60? (
			>=dev-dotnet/monogame-3.8.1h
		)
		net50? (
			>=dev-dotnet/monogame-3.8
			 <dev-dotnet/monogame-3.8.1
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	net50? (
		>=dev-dotnet/dotnet-sdk-bin-5.0:5.0
	)
	net60? (
		>=dev-dotnet/dotnet-sdk-bin-6.0:6.0
	)
"
SRC_URI=""
RESTRICT="mirror"
S="${WORKDIR}/${P}"

# The dotnet-sdk-bin supports only 1 ABI at a time.
declare -A DOTNET_SUPPORTED_SDKS=(
	["net50"]="dotnet-sdk-bin-5.0"
	["net60"]="dotnet-sdk-bin-6.0"
)

EGIT_REPO_URI="https://github.com/Genbox/VelcroPhysics.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"

EXPECTED_BUILD_FILES="\
"
MONOGAME_PV_DOTNET5="3.8.0.1641"
MONOGAME_PV_DOTNET6="3.8.1.303"

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	use net50 && sdk="${DOTNET_SUPPORTED_SDKS[net50]}"
	use net60 && sdk="${DOTNET_SUPPORTED_SDKS[net60]}"
	if [[ -e "${EPREFIX}/opt/${sdk}" ]] ; then
		export SDK="${sdk}"
		export PATH="${EPREFIX}/opt/${SDK}:${PATH}"
		found=1
	fi
	if (( ${found} != 1 )) ; then
eerror
eerror "You need a dotnet SDK."
eerror
eerror "Supported SDK versions: ${DOTNET_SUPPORTED_SDKS[@]}"
eerror
		die
	fi
	use net50 && export FRAMEWORK="5.0"
	use net60 && export FRAMEWORK="6.0"
	einfo " -- USING .NET ${FRAMEWORK} -- "
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local acutal_build_files=(
		$(sha512sum $(find "${S}" -name "*.csproj" | sort) | cut -f 1 -d " ")
	)
	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "Change in build files detected"
eerror
eerror "Actual build files:  ${actual_build_files}"
eerror "Expected build files:  ${EXPECTED_BUILD_FILES}"
eerror
		die
	fi
}

src_prepare() {
	default
	local p
	for p in $(find "${WORKDIR}" -name "*.csproj") ; do
		if use net60 && grep -q "${MONOGAME_PV_DOTNET5}" "${p}"; then
einfo "Edited ${p}:  MonoGame ${MONOGAME_PV_DOTNET5} -> ${MONOGAME_PV_DOTNET6}"
			sed -i -e "s|${MONOGAME_PV_DOTNET5}|${MONOGAME_PV_DOTNET6}|g" "${p}" || die
		fi
	done

	for ns in $(_get_ns) ; do
		use net50 && tfm="${NS_FW5[${ns}]}"
		use net60 && tfm="${NS_FW6[${ns}]}"
		if [[ "${ns}" == "VelcroPhysics.MonoGame" ]] ; then
			p="src/VelcroPhysics/VelcroPhysics.MonoGame.csproj"
		else
			p="src/${ns}/$(_ns_proj ${ns}).csproj"
		fi
		if [[ \
			   "${ns}" =~ "ContentPipelines" \
			|| "${ns}" == "VelcroPhysics.MonoGame" \
			|| "${ns}" == "VelcroPhysics.MonoGame.DebugView" \
		]] ; then
einfo "Edited ${p}:  netstandard2.0 -> ${tfm}"
			sed -i -e "s|netstandard2\.0|${tfm}|g" \
				"${p}" || die
		fi
		if [[ "${tfm}" == "net6.0" ]] ; then
einfo "Edited ${p}:  net5.0 -> ${tfm}"
			sed -i -e "s|net5\.0|${tfm}|g" "${p}" || die
		fi
	done
}

NS=(
	"VelcroPhysics"
	"VelcroPhysics.MonoGame"
	"VelcroPhysics.MonoGame.DebugView"
	"VelcroPhysics.MonoGame.ContentPipelines.SVGImport"
	"VelcroPhysics.MonoGame.ContentPipelines.TextureToVertices"
	"VelcroPhysics.MonoGame.Samples.Testbed"
	"VelcroPhysics.MonoGame.Samples.HelloWorld"
	"VelcroPhysics.MonoGame.Samples.Demo"
	"VelcroPhysics.Benchmarks"
)

declare -A NS_FW5=(
	["VelcroPhysics"]="netstandard2.0"
	["VelcroPhysics.MonoGame"]="netcoreapp3.1"
	["VelcroPhysics.MonoGame.DebugView"]="netcoreapp3.1"

	["VelcroPhysics.MonoGame.ContentPipelines.SVGImport"]="netcoreapp3.1"
	["VelcroPhysics.MonoGame.ContentPipelines.TextureToVertices"]="netcoreapp3.1"

	["VelcroPhysics.MonoGame.Samples.Testbed"]="net5.0"
	["VelcroPhysics.MonoGame.Samples.HelloWorld"]="net5.0"
	["VelcroPhysics.MonoGame.Samples.Demo"]="net5.0"
	["VelcroPhysics.Benchmarks"]="net5.0"
)

declare -A NS_FW6=(
	["VelcroPhysics"]="netstandard2.0"
	["VelcroPhysics.MonoGame"]="net6.0"
	["VelcroPhysics.MonoGame.DebugView"]="net6.0"

	["VelcroPhysics.MonoGame.ContentPipelines.SVGImport"]="net6.0"
	["VelcroPhysics.MonoGame.ContentPipelines.TextureToVertices"]="net6.0"

	["VelcroPhysics.MonoGame.Samples.Testbed"]="net6.0"
	["VelcroPhysics.MonoGame.Samples.HelloWorld"]="net6.0"
	["VelcroPhysics.MonoGame.Samples.Demo"]="net6.0"
	["VelcroPhysics.Benchmarks"]="net6.0"
)

_get_ns() {
	local ns
	for ns in ${NS[@]} ; do
		if ! use monogame && [[ "${ns}" =~ "MonoGame" ]] ; then
			continue
		fi

		if ! use standalone && ! [[ "${ns}" =~ "MonoGame" ]] ; then
			continue
		fi

		if [[ "${ns}" == "VelcroPhysics.MonoGame.Samples.Demo" ]] ; then
			use demo && echo "${ns}"
		elif [[ "${ns}" == "VelcroPhysics.MonoGame.Samples.HelloWorld" ]] ; then
			use hello-world && echo "${ns}"
		elif [[ "${ns}" == "VelcroPhysics.MonoGame.Samples.Testbed" ]] ; then
			use testbed && echo "${ns}"
		else
			echo "${ns}"
		fi
	done
}

_ns_proj() {
	local ns="${1}"
	if [[ "${ns}" =~ "ContentPipelines" ]] ; then
		echo "${ns/ContentPipelines/Content}"
	else
		echo "${ns}"
	fi
}

_get_mgplatform() {
	# Corresponds to MonoGamePlatform
	if use elibc_bionic ; then
		echo "Android"
	elif use elibc_mingw ; then
		echo "Windows"
#	elif use elibc_Darwin ; then
#		echo "iOS"
	else
		echo "DesktopGL"
	fi
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	local configuration="Release"
	local tfm

	for ns in $(_get_ns) ; do
		use net50 && tfm="${NS_FW5[${ns}]}"
		use net60 && tfm="${NS_FW6[${ns}]}"
		local proj
		if [[ "${ns}" == "VelcroPhysics.MonoGame" ]] ; then
			proj="src/VelcroPhysics/VelcroPhysics.MonoGame.csproj"
		else
			proj="src/${ns}/$(_ns_proj ${ns}).csproj"
		fi

		if false && use net60 && [[ "${ns}" == "VelcroPhysics.MonoGame.Samples.Testbed" ]] ; then
			mkdir -p "${WORKDIR}/dotnet-mgcb" || die
			pushd "${WORKDIR}/dotnet-mgcb" || die
				dotnet new tool-manifest || die
				dotnet tool install --local dotnet-mgcb --version ${MONOGAME_PV_DOTNET6} || die
			popd
		fi

		dotnet publish \
			-f "${tfm}" \
			-p:Configuration=${configuration} \
			-p:MonoGamePlatform=$(_get_mgplatform) \
			"${proj}" || die
	done
}

_get_publish() {
	local ns="${1}"
	if [[ "${ns}" =~ "ContentPipelines" ]] ; then
		echo "src/bin/${tfm}/publish"
	elif [[ "${ns}" == "VelcroPhysics.MonoGame" ]] ; then
		echo "src/VelcroPhysics/bin/${configuration}/${tfm}/publish"
	elif [[ "${ns}" == "VelcroPhysics" ]] ; then
		echo "src/VelcroPhysics/bin/${configuration}/${tfm}/publish"
	else
		echo "src/${ns}/bin/${configuration}/${tfm}/publish"
	fi
}

src_install() {
	local tfm
	local configuration="Release"
	for ns in $(_get_ns) ; do
		use net50 && tfm="${NS_FW5[${ns}]}"
		use net60 && tfm="${NS_FW6[${ns}]}"
		insinto "/opt/${SDK}/shared/${ns}/${PV}/${tfm}"
		doins -r $(_get_publish "${ns}")/*
		if use mono ; then
			local mtfm=""
#
# Mono only supports <= .NET 4.8.x and <= .NET Standard 2.1
# See https://www.mono-project.com/docs/about-mono/releases/4.4.0/
# for why the 4.5 folder is used for the latest .NET runtimes and x.y-api for
# reference assemblies (that are only for build time metadata only).
#
			[[ "${tfm}" == "net6.0" ]] && continue # Not compatible
			[[ "${tfm}" == "net5.0" ]] && continue # Not compatible
			[[ "${tfm}" == "netstandard2.0" ]] && mtfm="4.5"
			local ns2="${ns}"
			ns2="${ns/ContentPipelines/Content}"
			dodir "/usr/lib/mono/${mtfm}"
			dosym "/opt/${SDK}/shared/${ns}/${PV}/${tfm}/Genbox.${ns2}.dll" \
				"/usr/lib/mono/${mtfm}/${ns2}.dll"
		fi
	done
	dodoc "README.md"

	if [[ -e "${HOME}/.nuget" ]] ; then
		LCNR_SOURCE="${HOME}/.nuget"
		LCNR_TAG="third_party"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
