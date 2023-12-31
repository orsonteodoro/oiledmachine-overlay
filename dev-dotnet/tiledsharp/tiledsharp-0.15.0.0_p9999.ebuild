# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="TiledSharp"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/marshallward/TiledSharp.git"

USE_DOTNET="net40"
inherit dotnet git-r3 lcnr

DESCRIPTION="C# library for parsing and importing TMX and TSX files generated \
by Tiled, a tile map generation tool."
HOMEPAGE="https://github.com/marshallward/TiledSharp"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE+=" ${USE_DOTNET} doc test"
REQUIRED_USE+="
	^^ ( ${USE_DOTNET} )
	test? ( ^^ ( ${USE_DOTNET} ) )
"
BDEPEND+="
	dev-dotnet/dotnet-sdk-bin
	doc? ( app-doc/doxygen )
"
SLOT="0/$(ver_cut 1-2 ${PV})"
#KEYFILE="dotnet-overlay-mono.snk"
#SRC_URI="
#https://github.com/gentoo/dotnet/raw/master/eclass/mono.snk
#	-> ${KEYFILE}
#"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
TOOLS_VERSION="Current"
DOCS=( CHANGELOG README.rst )

PATCHES=(
	"${FILESDIR}/${PN}-0.15.0.0_p9999-set-output-path.patch"
	"${FILESDIR}/${PN}-0.15.0.0_p9999-linux-tiledsharp-csproj.patch"
)
unset LFRAMEWORK
# Lookup table for USE flag framework -> dotnet cli framework
declare -A LFRAMEWORK=(
	[3.5]="net35"
	[4.0]="net40"
	[4.5]="net45"
)
EXPECTED_BUILDFILES="\
8e3f126a176e19bcc0180b96c9c6aaa34d039649071e604c13689345692c82a1\
3a16e31916afe71b9b08e21d0f40523dc22fdc95264aa0f062187e968511b771\
"

pkg_setup() {
	dotnet_pkg_setup
	if ls "${EROOT}/opt/dotnet-sdk-bin-"*"/dotnet" 2>/dev/null 1>/dev/null ; then
		local p=$(ls "${EROOT}/opt/dotnet-sdk-bin-"*"/dotnet" | head -n 1)
		export PATH="$(dirname ${p}):${PATH}"
	else
eerror
eerror "Could not find dotnet.  Emerge dev-dotnet/dotnet-sdk-bin"
eerror
		die
	fi
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi
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

	local actual_buildfiles=$(cat $(find "${S}" -name "*.csproj" | sort) | sha512sum | cut -f 1 -d " ")
	if [[ "${actual_buildfiles}" != "${EXPECTED_BUILDFILES}" ]] ; then
eerror
eerror "Actual version:  ${actual_buildfiles}"
eerror "Expected version:  ${EXPECTED_BUILDFILES}"
eerror
eerror "This was supposed to be EOL, but there has been a change in the"
eerror "buildfiles.  This indicates that a new dependency, feature, install"
eerror "section, etc has changed."
eerror
		die
	fi
}

src_compile() {
	einfo "FRAMEWORK=${FRAMEWORK}"
	local configuration="Release"
	dotnet build "TiledSharp/TiledSharp.csproj" \
		-f ${LFRAMEWORK["${FRAMEWORK}"]} \
		-c ${configuration} || die
	if use test ; then
		dotnet build "TiledSharp.Test/TiledSharp.Test.csproj" \
			-f ${LFRAMEWORK["${FRAMEWORK}"]} \
			-c ${configuration} \
			|| die
	fi
	if use doc ; then
		cd docs || die
		doxygen Doxyfile
	fi
}

src_install() {
	local configuration="Release"
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	local p=$(realpath "TiledSharp/bin/${configuration}/"*)
	doexe "${p}/TiledSharp.dll"
	use doc && dodoc -r docs/html
	einstalldocs

	if [[ "${HOME}/.nuget" ]] ; then
		LCNR_SOURCE="${HOME}/.nuget"
		LCNR_TAG="third_party"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
