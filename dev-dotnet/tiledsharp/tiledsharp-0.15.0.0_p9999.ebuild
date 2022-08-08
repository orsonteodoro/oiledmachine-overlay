# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="TiledSharp"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/marshallward/TiledSharp.git"

inherit dotnet eutils mono git-r3
#inherit gac

DESCRIPTION="C# library for parsing and importing TMX and TSX files generated
by Tiled, a tile map generation tool."
HOMEPAGE="https://github.com/marshallward/TiledSharp"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
USE_DOTNET="net35 net40 net45 test"
IUSE+=" ${USE_DOTNET} debug developer doc"
#IUSE+=" gac"
REQUIRED_USE+="
	^^ ( ${USE_DOTNET} )
	test? ( ^^ ( net35 net40 net45 ) )
"
#	gac? ( ^^ ( net40 net45 ) )
BDEPEND+="
	dev-dotnet/dotnet-sdk-bin
	doc? ( app-doc/doxygen )
"
SLOT="0/${PV}"
#KEYFILE="dotnet-overlay-mono.snk"
#SRC_URI="
#https://github.com/gentoo/dotnet/raw/master/eclass/mono.snk
#	-> ${KEYFILE}
#"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
TOOLS_VERSION="Current"
STRONG_ARGS_NETFX="/p:SignAssembly=true /p:AssemblyOriginatorKeyFile="
DOCS=( LICENSE NOTICE CHANGELOG README.rst )

#PATCHES=(
#	"${FILESDIR}/tiledsharp-0.15.0.0_p9999-csproj-changes.patch"
#)
unset LFRAMEWORK
# Lookup table for USE flag framework -> dotnet cli framework
declare -A LFRAMEWORK=(
	[3.5]="net35"
	[4.0]="net40"
	[4.5]="net45"
)

pkg_setup() {
	if ls /opt/dotnet-sdk-bin-*/dotnet 2>/dev/null 1>/dev/null ; then
		local p=$(ls /opt/dotnet-sdk-bin-*/dotnet | head -n 1)
		export PATH="$(dirname ${p}):${PATH}"
	else
eerror
eerror "Could not find dotnet.  Emerge dev-dotnet/dotnet-sdk-bin"
eerror
		die
	fi
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	dotnet_pkg_setup
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi
}

src_configure() {
	default
	for x in $(find . -name "*.csproj") ; do
		sed -i -e "s|netstandard2.0;||g" "${x}" || die
		sed -i -e "s|netcoreapp2.0;||g" "${x}" || die
		sed -i -e "s|netcoreapp2.1;||g" "${x}" || die
	done
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	local actual_version=$(grep \
		-e "AssemblyVersion" \
		"${S}/TiledSharp/src/AssemblyInfo.cs" \
		| cut -f 2 -d "\"")
	local expected_version=$(ver_cut 1-4 "${PV}")
	if ver_test ${actual_version} -ne ${expected_version} ; then
eerror
eerror "Actual version:  ${actual_version}"
eerror "Expected version:  ${expected_version}"
eerror
eerror "This was supposed to be EOL."
eerror
		die
	fi
}

src_compile() {
	einfo "FRAMEWORK=${FRAMEWORK}"
	local configuration=$(usex debug "Debug" "Release")
	dotnet build "TiledSharp/TiledSharp.csproj" \
		-f ${LFRAMEWORK["${FRAMEWORK}"]} \
		-c ${configuration} || die
	if use test ; then
		dotnet build "TiledSharp.Test/TiledSharp.Test.csproj" \
			-f ${LFRAMEWORK["${FRAMEWORK}"]} \
			-c ${configuration} || die
	fi
	if use doc ; then
		cd docs || die
		doxygen Doxyfile
	fi
}

strong_sign() {
	local assembly="${1}"
	local keyfile="${2}"
	if use gac; then
		einfo "Strong signing ${assembly}"
		if ! sn -R "${assembly}" "${keyfile}" ; then
eerror
eerror "Failed to strong sign"
eerror
eerror "Assembly/DLL:  ${assembly}"
eerror "Keyfile:  ${keyfile}"
eerror
			die
		fi
	fi
}

# Copy and sanitize permissions
copy_next_to_file() {
	local source="${1}"
	local attachment="${2}"
	local bn_attachment=$(basename "${attachment}")
	local permissions="${3}"
	local owner="${4}"
	local fingerprint=$(sha256sum "${source}" | cut -f 1 -d " ")
	for x in $(find "${ED}" -type f) ; do
		[[ -L "${x}" ]] && continue
		x_fingerprint=$(sha256sum "${x}" | cut -f 1 -d " ")
		if [[ "${fingerprint}" == "${x_fingerprint}" ]] ; then
			local destdir=$(dirname "${x}")
			cp -a "${attachment}" "${destdir}" || die
			chmod "${permissions}" "${destdir}/${bn_attachment}" || die
			chown "${owner}" "${destdir}/${bn_attachment}" || die
einfo
einfo "Copied ${attachment} -> ${destdir}"
einfo
		fi
	done
}

src_install() {
	local configuration=$(usex debug "Debug" "Release")
	local framework="${LFRAMEWORK[${FRAMEWORK}]}"
	insinto "/usr/lib/mono/${framework}"
	local p="TiledSharp/bin/${configuration}/${framework}"
#	strong_sign "$(pwd)/${p}/TiledSharp.dll" \
#		"${DISTDIR}/${KEYFILE}" || die
#	egacinstall "${p}/TiledSharp.dll"
	doins "${p}/TiledSharp.dll"
	if use developer ; then
		doins "${p}/TiledSharp.pdb"
		copy_next_to_file \
			"$(pwd)/${p}/TiledSharp.dll" \
			"$(pwd)/${p}/TiledSharp.pdb" \
			0644 \
			root:root
	fi
	use doc && dodoc -r docs/html
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
