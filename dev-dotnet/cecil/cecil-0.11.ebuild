# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
KEYWORDS="~amd64 ~arm64 ~x86"

SLOT="0"

USE_DOTNET="net40 netstandard20 netcoreapp21"
IUSE="+${USE_DOTNET} +gac nupkg +pkg-config +debug +developer test"
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"
REQUIRED_USE="test? ( || ( netcoreapp21 net40 ) ) nupkg? ( !debug net40 netstandard20 ) gac? ( net40 )"

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
TOOLS_VERSION="Current"

src_prepare() {
	default

	dotnet_copy_sources

	erestore "${METAFILETOBUILD}"
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
		if use developer; then
			PARAMETERS=" -p:DebugSymbols=True"
		else
			PARAMETERS=" -p:DebugSymbols=False"
		fi
		PARAMETERS+=" ${STRONG_ARGS_NETCORE}${BUILD_DIR}/cecil.snk"

		if dotnet_is_netfx "${EDOTNET}" || [[ "${EDOTNET}" =~ netstandard ]]; then
			exbuild ${PARAMETERS} Mono.Cecil.csproj
			exbuild ${PARAMETERS} symbols/mdb/Mono.Cecil.Mdb.csproj
			exbuild ${PARAMETERS} symbols/pdb/Mono.Cecil.Pdb.csproj
			exbuild ${PARAMETERS} rocks/Mono.Cecil.Rocks.csproj
		fi

		if dotnet_is_netfx "${EDOTNET}" || [[ "${EDOTNET}" =~ netcoreapp ]]; then
			if use test ; then
				exbuild ${PARAMETERS} Test/Mono.Cecil.Tests.csproj
				exbuild ${PARAMETERS} symbols/mdb/Test/Mono.Cecil.Mdb.Tests.csproj
				exbuild ${PARAMETERS} symbols/pdb/Test/Mono.Cecil.Pdb.Tests.csproj
				exbuild ${PARAMETERS} rocks/Test/Mono.Cecil.Rocks.Tests.csproj
			fi
		fi

		if dotnet_is_netfx "${EDOTNET}" ; then
			# https://github.com/gentoo/dotnet/issues/305
			local moniker="$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})"

			L="bin/${C}/${moniker}"
			estrong_resign "${L}/Mono.Cecil.dll" cecil.snk

			L="rocks/bin/${C}/${moniker}"
			estrong_resign "${L}/Mono.Cecil.Rocks.dll" cecil.snk

			L="symbols/mdb/bin/${C}/${moniker}"
			estrong_resign "${L}/Mono.Cecil.Mdb.dll" cecil.snk

			L="symbols/pdb/bin/${C}/${moniker}"
			estrong_resign "${L}/Mono.Cecil.Pdb.dll" cecil.snk
		fi

		# for nuspec
		cp -a Test bin rocks symbols "${S}"
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
		local moniker="$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})"
		if dotnet_is_netfx "${EDOTNET}" ; then
			L="bin/${C}/${moniker}"
			egacinstall "${L}/Mono.Cecil.dll"

			L="rocks/bin/${C}/${moniker}"
			egacinstall "${L}/Mono.Cecil.Rocks.dll"

			L="symbols/mdb/bin/${C}/${moniker}"
			egacinstall "${L}/Mono.Cecil.Mdb.dll"

			L="symbols/pdb/bin/${C}/${moniker}"
			egacinstall "${L}/Mono.Cecil.Pdb.dll"
		fi

		if [[ ! ( "${EDOTNET}" =~ netcoreapp ) ]]; then
			L="bin/${C}/${moniker}"
			doins "${L}/Mono.Cecil.dll"
			doins "${L}/Mono.Cecil.pdb"

			L="rocks/bin/${C}/${moniker}"
			doins "${L}/Mono.Cecil.Rocks.dll"
			doins "${L}/Mono.Cecil.Rocks.pdb"

			L="symbols/mdb/bin/${C}/${moniker}"
			doins "${L}/Mono.Cecil.Mdb.dll"
			doins "${L}/Mono.Cecil.Mdb.pdb"

			L="symbols/pdb/bin/${C}/${moniker}"
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
		fi
	}

	dotnet_foreach_impl install_impl

	einstall_pc_file "${PN}" "${PV}" ${GAC_DLL_NAMES}

	enupkg "${WORKDIR}/${NUSPEC_ID}.${NUSPEC_VERSION}.nupkg"
}
