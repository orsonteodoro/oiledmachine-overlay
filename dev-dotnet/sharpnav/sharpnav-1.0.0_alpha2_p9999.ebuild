# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 lcnr

DESCRIPTION="SharpNav is advanced pathfinding for C#"
HOMEPAGE="http://sharpnav.com"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="SharpNav"
USE_DOTNET="net451"
UCONFIGURATIONS=(
	MonoGame
	OpenTK
	SharpDX
	Standalone
) # Upstream configurations
IUSE="
${USE_DOTNET}
${UCONFIGURATIONS[@],,}
cli-client developer examples extras gui-client
"
REQUIRED_USE="
	|| ( ${USE_DOTNET} )
	|| ( ${UCONFIGURATIONS[@],,} )
	sharpdx? (
		|| (
			elibc_mingw
		)
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND="
	dev-dotnet/gwen-dotnet
	examples? (
		opentk? (
			media-libs/freealut
			media-libs/libsdl2
			virtual/opencl
			virtual/opengl
			x11-libs/libX11
		)
	)
	monogame? (
		dev-dotnet/monogame
		dev-dotnet/nvorbis
		dev-dotnet/opentk
	)
	dev-dotnet/newtonsoft-json
	dev-dotnet/yamldotnet
	dev-util/nunit:3
"
DEPEND="${RDEPEND}"
BDEPEND+="
	|| (
		dev-dotnet/mono-msbuild-bin
		dev-dotnet/msbuild-bin:16[symlink]
	)
"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
EGIT_REPO_URI="https://github.com/Robmaister/SharpNav.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0_alpha2_p9999-deps-update-v3.patch"
)

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi
}

EXPECTED_BUILD_FILES="\
3f15f020ef42e1d99de0743ab9c607e0339b6d06b6929a2c084e909f984e25fd\
e9be22b7dc3316a7e15ab5d38e0bcd9900f2517841325a44f2b9e536b81bd0d2\
"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local actual_build_files=$(cat $(find . -name "*.csproj" | sort) \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "Detected build files changes."
eerror
eerror "Expected build files:  ${EXPECTED_BUILD_FILES}"
eerror "Actual build files:  ${actual_build_files}"
eerror
		die
	fi
}

_get_configration() {
	local c
	for c in ${UCONFIGURATIONS[@]} ; do
		use ${c,,} && echo "${c}"
	done
}

src_prepare() {
	default

	# Disable for the unit tests
	if has tests ${IUSE} && use tests ; then
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/MathHelper.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Distance.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Containment.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Intersection.cs || die
	fi

	sed -i -e "s|AssemblyName>SharpNav|AssemblyName>SharpNav.CLI|g" \
		"${S}/Source/SharpNav.CLI/SharpNav.CLI.csproj" || die

	local uc
	for uc in $(_get_configration) ; do
		cp -a "${S}" "${S}_${uc}" || die

	done
}

NS=(
	"SharpNav"
	"SharpNav.Examples"
	"SharpNav.GUI"
	"SharpNav.Tests"
	"SharpNav.CLI"
)

_get_NS() {
	local ns
	for ns in ${NS[@]} ; do
		if [[ "${ns}" == "SharpNav.CLI" ]] ; then
			use cli-client && echo "${ns}"
		elif [[ "${ns}" == "SharpNav.Examples" ]] ; then
			use examples && echo "${ns}"
		elif [[ "${ns}" == "SharpNav.GUI" ]] ; then
			use gui-client && echo "${ns}"
		elif [[ "${ns}" == "SharpNav.Tests" ]] ; then
			has "test" ${IUSE} && use test && echo "${ns}"
		else
			echo "${ns}"
		fi
	done
}

# From dotnet.eclass removing /p:Configuration
_exbuild() {
	elog "xbuild ""$@"" /tv:4.0 /p:TargetFrameworkVersion=v""${FRAMEWORK}"" || die"
	xbuild "$@" /tv:4.0 /p:TargetFrameworkVersion=v"${FRAMEWORK}" || die
}

ns_has_configuration() {
	local ns="${1}"
	local configuration="${2}"
	grep -q "${configuration}" "${ns}/${ns}.csproj"
}

prun() {
	einfo "cmd:  ${@}"
	${@} || die
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	local uc
	for uc in $(_get_configration) ; do
		pushd "${S}_${uc}" || die
			cd "Source" || die
			local ns
			for ns in $(_get_NS) ; do
				if use "${uc,,}" && ns_has_configuration "${ns}" "${uc}" ; then
					einfo "Restoring ${ns}"
					prun \
					msbuild \
						"${ns}/${ns}.csproj" \
						-restore:True \
						-p:RestorePackagesConfig=true \
						-t:restore \
						-p:Platform=AnyCPU \
						-p:Configuration="${uc}" \
						-p:NuGetPackageRoot2="${HOME}/.nuget" \
						/p:SolutionDir="${S}_${uc}"
				elif use "${uc,,}" && ! ns_has_configuration "${ns}" "${uc}" ; then
					ewarn "${ns} does not have ${uc} configuration"
				fi
			done
		popd
	done

	local uc
	for uc in $(_get_configration) ; do
		pushd "${S}_${uc}" || die
			cd "Source" || die
			for ns in $(_get_NS) ; do
				if use "${uc,,}" && ns_has_configuration "${ns}" "${uc}" ; then
					einfo "Building ${ns}"
					prun \
					msbuild \
						"${ns}/${ns}.csproj" \
						-t:build \
						-p:Configuration="${uc}" \
						-p:Platform=AnyCPU \
						-p:NuGetPackageRoot2="${HOME}/.nuget"
				elif use "${uc,,}" && ! ns_has_configuration "${ns}" "${uc}" ; then
					ewarn "${ns} does not have ${uc} configuration"
				fi
			done
		popd
	done
}

get_march() {
	local chost="${1}"
	if [[ "${chost}" =~ "arm".*"hf" ]] ; then
		echo "arm"
	elif [[ "${chost}" =~ "arm" ]] ; then
		echo "armel"
	elif [[ "${chost}" =~ "armv6" ]] ; then
		echo "armv6"
	elif [[ "${chost}" =~ "aaarch" ]] ; then
		echo "arm64"
	elif [[ "${chost}" =~ "loongarch64" ]] ; then
		echo "loongarch64"
	elif [[ "${chost}" =~ "s390x" ]] ; then
		echo "s390x"
	elif [[ "${chost}" =~ "powerpc64le" ]] ; then
		echo "ppc64le"
	elif [[ "${chost}" =~ "mips64el" ]] ; then
		echo "mips64" # LE
	elif [[ "${chost}" =~ "x86_64" ]] ; then
		echo "x64"
	elif [[ "${chost}" =~ i[3456]86 ]] ; then
		echo "x86"
	else
eerror
eerror "Microarch is not supported"
eerror
eerror "CHOST:  ${CHOST}"
eerror "Supported and expected microarches:  ${MARCH[@]}"
eerror
		die
	fi
}

_prune_marches() {
	local path="${1}"
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

	local narch=$(get_march "${CHOST}")

	einfo "Pruning non-native microarchitectures"
	local march
	for march in ${MARCH[@]} ; do
		local d
		for d in $(find "${path}" -type d -name "${march}") ; do
			local a
			a=$(basename "${d}")
			if [[ "${a}" != "${narch}" ]] ; then
				rm -vrf "${d}" || true
			fi
		done
	done
}

_install_dir() {
	local dir="${1}"
	[[ -d "${dir}" ]] && doins -r "${dir}"/*
}

_install_files() {
	local uc="${1}"
	local ns="${2}"

	local assembly_folder="4.5"
	if [[ "${uc}" == "Standalone" ]] && [[ "${ns}" == "SharpNav.CLI" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/Standalone/CLI"
		_install_dir "Binaries/Clients/CLI/Standalone"
	fi
	if [[ "${uc}" == "Standalone" ]] && [[ "${ns}" == "SharpNav.GUI" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/Standalone/GUI"
		_install_dir "Binaries/Clients/GUI/Standalone"
	fi
	if [[ "${uc}" == "Standalone" ]] && [[ "${ns}" == "SharpNav.Examples" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/Standalone/Examples"
		_install_dir "Binaries/Examples/Standalone"
	fi
	if [[ "${uc}" == "Standalone" ]] && [[ "${ns}" == "SharpNav" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/Standalone/lib/net451"
		_install_dir "Binaries/SharpNav/Standalone"
	fi
	if [[ "${uc}" == "MonoGame" ]] && [[ "${ns}" == "SharpNav" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/MonoGame/lib/net451"
		_install_dir "Binaries/SharpNav/MonoGame"
	fi
	if [[ "${uc}" == "OpenTK" ]] && [[ "${ns}" == "Examples" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/OpenTK/Examples"
		_install_dir "Binaries/Examples/OpenTK"
	fi
	if [[ "${uc}" == "OpenTK" ]] && [[ "${ns}" == "SharpNav" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/OpenTK/lib/net451"
		_install_dir "Binaries/SharpNav/OpenTK"
	fi
	if [[ "${uc}" == "SharpDX" ]] && [[ "${ns}" == "SharpNav" ]] ; then
		insinto "/usr/lib/mono/${assembly_folder}/SharpNav/SharpDX/lib/net451"
		_install_dir "Binaries/SharpNav/SharpDX"
	fi
}

_fix_permissions() {
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
}

src_install() {
	local configuration="Release"

	local uc
	for uc in $(_get_configration) ; do
		pushd "${S}_${uc}" || die
			local ns
			for ns in $(_get_NS) ; do
				_install_files "${uc}" "${ns}"
			done
		popd
	done
	_prune_marches "${ED}"
	_fix_permissions
	if ! use developer ; then
		find "${ED}" \( -name "*.pdb" -o -name "*xml" \) -delete
	fi

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
