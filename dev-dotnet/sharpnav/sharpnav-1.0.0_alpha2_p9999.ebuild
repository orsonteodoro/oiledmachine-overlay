# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOTNET_PV="6.0"
inherit dotnet eutils gac git-r3

DESCRIPTION="SharpNav is advanced pathfinding for C#"
HOMEPAGE="http://sharpnav.com"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="SharpNav"
USE_DOTNET="net45"
UCONFIGURATIONS=(
	MonoGame
	OpenTK
	SharpDX
	Standalone
) # Upstream configurations
IUSE="
${USE_DOTNET}
${UCONFIGURATIONS[@],,}
developer +gac extras tests
"
REQUIRED_USE="
	|| ( ${USE_DOTNET} )
	|| ( ${UCONFIGURATIONS[@],,} )
	gac? ( net45 )
	sharpdx? (
		|| (
			elibc_mingw
			elibc_Winnt
		)
	)
"
SLOT="0/${PV}"
RDEPEND="
	dev-dotnet/gwen-dotnet
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
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_PV}:${DOTNET_PV}
"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
EGIT_REPO_URI="https://github.com/Robmaister/SharpNav.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

pkg_setup() {
	dotnet_pkg_setup
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
	local suffix
	for suffix in $(_get_configration) ; do
		cp -a "${S}" "${S}_${suffix}" || die
	done
}

Asrc_prepare() {
	default
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-1.patch"
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-2.patch"

	# Disable for the unit tests
	if use tests ; then
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/MathHelper.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Distance.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Containment.cs || die
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Intersection.cs || die
		eapply "${FILESDIR}/${PN}-9999.20161023-mathhelper-pi.patch"
		eapply "${FILESDIR}/${PN}-9999.20161023-missing-nunit-ref.patch"
	else
		eapply "${FILESDIR}/${PN}-9999.20161013-no-tests.patch"
	fi

}

NS=(
	"SharpNav"
	"SharpNav.CLI"
	"SharpNav.Examples"
	"SharpNav.GUI"
#	"SharpNav.Tests"
)

# From dotnet.eclass removing /p:Configuration
_exbuild() {
	elog "xbuild ""$@"" /tv:4.0 /p:TargetFrameworkVersion=v""${FRAMEWORK}"" || die"
	xbuild "$@" /tv:4.0 /p:TargetFrameworkVersion=v"${FRAMEWORK}" || die
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	local ns
	for ns in ${NS[@]} ; do
		local uc
		for uc in $(_get_configration) ; do
			pushd "${S}_${uc}" || die
				cd "Source" || die
				if use "${uc,,}" ; then
					dotnet msbuild \
						"${ns}/${ns}.csproj" \
						-t:restore \
						-p:RestorePackagesConfig=true \
						-p:Configuration="${uc}" \
						-p:Platform=AnyCPU \
						|| die
					_exbuild \
						/p:Configuration="${uc}" \
						/p:Platform=AnyCPU \
						"${ns}/${ns}.csproj" \
						|| die
				fi
			popd
		done
	done
}


src_install() {
	local configuration="Release"
	exeinto "/usr/lib/mono/4.5"
	insinto "/usr/lib/mono/4.5"
	d_base="${d}"

	die

	local uc
	for uc in $(_get_configration) ; do
		pushd "${S}_${uc}" || die
			if use "${uc}" ; then
		                egacinstall "${WORKDIR}/${uc}/SharpNav.dll" \
					"${PN}/${uc}"
				insinto "${d_base}/${uc}"
				doins "${WORKDIR}/${uc}/SharpNav.dll"
				if use developer ; then
					doins "${WORKDIR}/${uc}/SharpNav.dll.mdb"
					doins "${WORKDIR}/${uc}/SharpNav.XML"
					copy_next_to_file \
						"${WORKDIR}/${uc}/SharpNav.dll" \
						"${WORKDIR}/${uc}/SharpNav.dll.mdb"
						644 \
						root:root
					copy_next_to_file \
						"${WORKDIR}/${uc}/SharpNav.dll" \
						"${WORKDIR}/${uc}/SharpNav.XML"
						644 \
						root:root
				fi
				if use extras && [[ "${uc}" == "Standalone" ]] ; then
					insinto "${d_base}/bin"
					doins \
				"Binaries/Clients/GUI/${uc}/SharpNavGUI.exe"
					doins \
				"Binaries/Clients/CLI/${uc}/SharpNav.exe"
				fi
			fi
		popd
	done
}

pkg_postinst() {
	einfo "The standalone dll is placed in the gac but the other"
	einfo "(MonoGame and OpenTK) dlls have been placed outside the gac"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
