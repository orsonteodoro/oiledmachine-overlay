# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

TARGET_FRAMEWORK="netstandard2.0"
DOTNET_PV="6.0"
inherit dotnet git-r3

DESCRIPTION="SFML.Net is a C# language binding for SFML"
HOMEPAGE="http://www.sfml-dev.org"
LICENSE="ZLIB"
IUSE="
${USE_DOTNET} developer mono nupkg

fallback-commit
"
REQUIRED_USE=""
RDEPEND="
	=media-libs/libsfml-2.5*
	=dev-libs/csfml-2.5*
	mono? (
		>=dev-lang/mono-5.4
	)
"
DEPEND="${RDEPEND}"
GIT_USER="SFML"
PROJECT_NAME="SFML.Net"
SRC_URI=""
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

EGIT_REPO_URI="https://github.com/SFML/SFML.Net.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

EXPECTED_BUILD_FILES="\
6c7f2bcc6e2f4a2749df6c366a77b31094c8fa28b1a3873738e33c0731a888e3\
f664b59e1280ad5c6b5d35fbc8d8c6e4bc739d3229bb3dd291632877deb16038\
"

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
	use fallback-commit && export EGIT_COMMIT="f678eb2cf1eadf1a4f95cf1febd1da1d78ddcd7f" # Oct 27, 2022
	git-r3_fetch
	git-r3_checkout
	local actual_build_files=$(cat \
		$(find . -name "*.csproj" -o -name "*.props" | sort) \
			| sha512sum \
			| cut -f 1 -d " ")
	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "A change in build files has been detected."
eerror
eerror "Expected build files:\t${EXPECTED_BUILD_FILES}"
eerror "Actual build files:\t${actual_build_files}"
eerror
		die
	fi
}

NS=(
	"SFML.Window"
	"SFML.Graphics"
	"SFML.Audio"
	"SFML.Net"
	"SFML.System"
)

src_prepare() {
	default
	sed -i -e "s|1.0.0-beta2-18618-05|1.1.1|g" \
		"${S}/SFML.NuGet.props" || die
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	local configuration="Release"
	cd "${S}" || die
	local tfm="${TARGET_FRAMEWORK}"
	dotnet publish \
		-c "${configuration}" \
		|| die
}

_install_dotnet_sdk() {
	doins -r "src/${ns}/bin/${configuration}/${tfm}/publish/"*
}

_install_mono() {
	dodir "/usr/lib/mono/4.5"
	dosym "/opt/${SDK}/shared/${ns}/$(ver_cut 1-2 ${PV})/${tfm}/${ns}.dll" \
		"/usr/lib/mono/4.5/${ns}.dll"
}

_install_nupkg() {
	if use nupkg ; then
		insinto "/opt/${SDK}/packs/${ns}/$(ver_cut 1-2 ${PV})/${tfm}"
		doins "src/${ns}/bin/${configuration}/${ns}.$(ver_cut 1-2).0.nupkg"
		use developer && doins "src/${ns}/bin/${configuration}/${ns}.$(ver_cut 1-2).0.snupkg"
	fi
}

src_install() {
	local configuration="Release"
	cd "${BUILD_DIR}"

	local tfm="${TARGET_FRAMEWORK}"
	for ns in ${NS[@]} ; do
		exeinto "/opt/${SDK}/shared/${ns}/$(ver_cut 1-2 ${PV})/${tfm}"
		insinto "/opt/${SDK}/shared/${ns}/$(ver_cut 1-2 ${PV})/${tfm}"
		_install_dotnet_sdk
		use mono && _install_mono
		_install_nupkg
	done
	if ! use developer ; then
		find "${ED}" \( -name "*.pdb" -o -name "*.xml" \) -delete
	fi
	dodoc README.md license.txt
}
