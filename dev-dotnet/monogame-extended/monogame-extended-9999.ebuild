# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_V="6.0"
inherit git-r3 lcnr

DESCRIPTION="MonoGame.Extended are classes and extensions to make MonoGame more \
awesome"
HOMEPAGE="http://www.monogameextended.net/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="MonoGame.Extended"
TARGET_FRAMEWORK="net60"
IUSE="${TARGET_FRAMEWORK} developer"
REQUIRED_USE="|| ( ${TARGET_FRAMEWORK} )"
RDEPEND="
	>=dev-dotnet/monogame-3.8.1h
"
BDEPEND="
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_V}:${DOTNET_V}
"
DEPEND="${RDEPEND}"
SRC_URI=""
SLOT="0/$(ver_cut 1-2 ${PV})"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_V}" )

EGIT_REPO_URI="https://github.com/craftworkgames/MonoGame.Extended.git"
EGIT_BRANCH="develop"
EGIT_COMMIT="HEAD"

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
	einfo " -- USING .NET ${TARGET_FRAMEWORK} -- "
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local actual_tfm=$(grep -r -e "TargetFramework" \
		"${S}/src/cs/MonoGame.Extended/MonoGame.Extended.csproj" \
		| sed "s|[<>]|^|g" \
		| cut -f 3 -d "^")
	local EXPECTED_TFM="net${DOTNET_V}"
	if [[ "${actual_tfm}" != "${EXPECTED_TFM}" ]] ; then
eerror
eerror "TFM mismatch"
eerror
eerror "Actual:  ${actual_tfm}"
eerror "Expected:  ${EXPECTED_TFM}"
eerror
		die
	fi
}

NS=(
	"MonoGame.Extended"
	"MonoGame.Extended.Tiled"
	"MonoGame.Extended.Content.Pipeline"
	"MonoGame.Extended.Animations"
	"MonoGame.Extended.Collisions"
	"MonoGame.Extended.Graphics"
	"MonoGame.Extended.Particles"
	"MonoGame.Extended.Entities"
	"MonoGame.Extended.Tweening"
	"MonoGame.Extended.Input"
	"MonoGame.Extended.Gui"
)

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	local configuration="Release"
	local tfm="net${DOTNET_V}"
	local x
	for ns in ${NS[@]} ; do
		einfo "Building ${ns}"
		dotnet publish \
			"src/cs/${ns}/${ns}.csproj" \
			-c "${configuration}" \
			-f "${tfm}" \
			|| die
	done
}

src_install() {
	local configuration="Release"
	local tfm="net${DOTNET_V}"

	local ns
	for ns in ${NS[@]} ; do
		insinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		exeinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		if [[ "${ns}" =~ "MonoGame.Extended.Content.Pipeline" ]] ; then
			doins -r "src/cs/${ns}/bin/${tfm}/publish/"*
		else
			doins -r "src/cs/${ns}/bin/${configuration}/${tfm}/publish/"*
		fi
	done

	if ! use developer ; then
		find "${ED}" \( -name "*.pdb" -o -name "*.xml" \) -delete
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
		elif file "${x}" | grep -q "shared library" ; then
			fperms 0775 "${path}"
		fi
	done
	dodoc README.md

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
