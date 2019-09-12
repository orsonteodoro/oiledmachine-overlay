# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
KEYWORDS="~amd64 ~arm64 ~x86"

SLOT="0"

USE_DOTNET="net35 net40 net462 netstandard13"
IUSE="+${USE_DOTNET} +gac nupkg +pkg-config +debug +developer test"
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg? ( !debug net35 net40 netstandard13 )"

inherit dotnet mono-pkg-config nupkg

HOMEPAGE="http://cecil.pe/"
DESCRIPTION="System.Reflection alternative to generate and inspect .NET executables/libraries"
LICENSE="MIT"

SRC_URI="https://github.com/jbevain/cecil/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT+=" mirror test"
S="${WORKDIR}/${PN}-${PV}"

METAFILETOBUILD="./Mono.Cecil.sln"

GAC_DLL_NAMES="Mono.Cecil Mono.Cecil.Mdb Mono.Cecil.Pdb Mono.Cecil.Rocks"

NUSPEC_ID="Mono.Cecil"
NUSPEC_FILE="${S}/Mono.Cecil.nuspec"
NUSPEC_VERSION="${PV}.0"
TOOLS_VERSION="4.0"

src_prepare() {
	default

	dotnet_copy_sources

	enuget_restore "${METAFILETOBUILD}"
}

_use_flag_to_folder_name() {
	local moniker="${1}"
	case $moniker in
		net35) echo "net_3_5" ;;
		net40) echo "net_4_0" ;;
		net45) echo "net_4_5" ;;
		net462) echo "net_462" ;;
		netstandard*) echo "netstandard" ;;
	esac
}

src_compile() {
	# C for CONFIGURATION
	local C
	if use debug; then
		C=Debug
	else
		C=Release
	fi
	compile_impl() {
		local PARAMETERS
		local CONFIGURATION
		if [[ "${EDOTNET}" == net462 || "${EDOTNET}" =~ netstandard ]] ; then
			TOOLS_VERSION="Current"
			CONFIGURATION="$(_use_flag_to_folder_name ${EDOTNET})_${C}"

			if use developer; then
				PARAMETERS=" -p:DebugSymbols=True"
			else
				PARAMETERS=" -p:DebugSymbols=False"
			fi
			PARAMETERS+=" ${STRONG_ARGS_NETCORE}${BUILD_DIR}/cecil.snk -p:Configuration=${CONFIGURATION}"
		else
			TOOLS_VERSION="4.0"
			CONFIGURATION="$(_use_flag_to_folder_name ${EDOTNET})_${C}"

			if use developer; then
				PARAMETERS=" /p:DebugSymbols=True"
			else
				PARAMETERS=" /p:DebugSymbols=False"
			fi
			PARAMETERS+=" ${STRONG_ARGS_NETFX}${BUILD_DIR}/cecil.snk /p:Configuration=${CONFIGURATION}"
		fi

		exbuild ${PARAMETERS} Mono.Cecil.csproj
		exbuild ${PARAMETERS} symbols/mdb/Mono.Cecil.Mdb.csproj
		exbuild ${PARAMETERS} symbols/pdb/Mono.Cecil.Pdb.csproj
		exbuild ${PARAMETERS} rocks/Mono.Cecil.Rocks.csproj

		if use test ; then
			exbuild ${PARAMETERS} Test/Mono.Cecil.Tests.csproj
			exbuild ${PARAMETERS} symbols/mdb/Test/Mono.Cecil.Mdb.Tests.csproj
			exbuild ${PARAMETERS} symbols/pdb/Test/Mono.Cecil.Pdb.Tests.csproj
			exbuild ${PARAMETERS} rocks/Test/Mono.Cecil.Rocks.Tests.csproj
		fi

		if dotnet_is_netfx "${EDOTNET}" ; then
			# https://github.com/gentoo/dotnet/issues/305

			L="bin/${CONFIGURATION}"
			estrong_resign "${L}/Mono.Cecil.dll" cecil.snk

			estrong_resign "${L}/Mono.Cecil.Rocks.dll" cecil.snk

			estrong_resign "${L}/Mono.Cecil.Mdb.dll" cecil.snk

			estrong_resign "${L}/Mono.Cecil.Pdb.dll" cecil.snk
		fi

		# for nuspec
		cp -a rocks symbols Test bin "${S}"
	}

	dotnet_foreach_impl compile_impl

	# run nuget_pack on all frameworks at once
	enuspec ${NUSPEC_FILE}
}

src_install() {
	if use debug; then
		C=Debug
	else
		C=Release
	fi

	install_impl() {
		dotnet_install_loc
		local L
		CONFIGURATION="$(_use_flag_to_folder_name ${EDOTNET})_${C}"
		if dotnet_is_netfx "${EDOTNET}" ; then
			L="bin/${CONFIGURATION}"
			egacinstall "${L}/Mono.Cecil.dll"

			egacinstall "${L}/Mono.Cecil.Rocks.dll"

			egacinstall "${L}/Mono.Cecil.Mdb.dll"

			egacinstall "${L}/Mono.Cecil.Pdb.dll"
		else
			L="bin/${CONFIGURATION}/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})"
		fi
		doins "${L}/Mono.Cecil.dll"
		doins "${L}/Mono.Cecil.pdb"

		doins "${L}/Mono.Cecil.Rocks.dll"
		doins "${L}/Mono.Cecil.Rocks.pdb"

		doins "${L}/Mono.Cecil.Mdb.dll"
		doins "${L}/Mono.Cecil.Mdb.pdb"

		doins "${L}/Mono.Cecil.Pdb.dll"
		doins "${L}/Mono.Cecil.Pdb.pdb"

		if dotnet_is_netfx "${EDOTNET}" ; then
			if [[ -d /opt/dotnet || -d /opt/dotnet_core ]] ; then
				L="$(dotnet_netcore_install_loc ${EDOTNET})"
				dodir "${L}"
				dosym "${d}/Mono.Cecil.dll" "${L}/Mono.Cecil.dll"
				dosym "${d}/Mono.Cecil.pdb" "${L}/Mono.Cecil.pdb"

				dosym "${d}/Mono.Cecil.Rocks.dll" "${L}/Mono.Cecil.Rocks.dll"
				dosym "${d}/Mono.Cecil.Rocks.pdb" "${L}/Mono.Cecil.Rocks.pdb"

				dosym "${d}/Mono.Cecil.Mdb.dll" "${L}/Mono.Cecil.Mdb.dll"
				dosym "${d}/Mono.Cecil.Mdb.pdb" "${L}/Mono.Cecil.Mdb.pdb"

				dosym "${d}/Mono.Cecil.Pdb.dll" "${L}/Mono.Cecil.Pdb.dll"
				dosym "${d}/Mono.Cecil.Pdb.pdb" "${L}/Mono.Cecil.Pdb.pdb"
			fi
		fi
	}

	dotnet_foreach_impl install_impl

	einstall_pc_file "${PN}" "${PV}" ${GAC_DLL_NAMES}

	enupkg "${WORKDIR}/${NUSPEC_ID}.${NUSPEC_VERSION}.nupkg"
}
