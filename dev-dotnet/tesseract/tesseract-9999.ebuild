# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PV="6.0"
TARGET_FRAMEWORK="netstandard20"
inherit git-r3 lcnr

DESCRIPTION="A .Net wrapper for tesseract-ocr"
HOMEPAGE="https://github.com/charlesw/tesseract"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
${TARGET_FRAMEWORK} developer mono

fallback-commit
"
REQUIRED_USE=" || ( ${TARGET_FRAMEWORK} )"
EXPECTED_LEPTONICA_PV="1.82.0"
EXPECTED_TESSERACT_PV="5.2.0"
RDEPEND="
	mono? (
		>=dev-lang/mono-5.4
	)
	=app-text/tesseract-$(ver_cut 1-2 ${EXPECTED_TESSERACT_PV})*
	~media-libs/leptonica-${EXPECTED_LEPTONICA_PV}
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_PV}:${DOTNET_PV}
"
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
EGIT_REPO_URI="https://github.com/charlesw/tesseract.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"
MY_PV="${EXPECTED_TESSERACT_PV}"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

unset M
declare -A M=(
	[netstandard20]="netstandard2.0"
)

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
	einfo " -- USING ${TARGET_FRAMEWORK} FRAMEWORK -- "
}

src_unpack() {
	use fallback-commit && export EGIT_COMMIT="b6a69bfbb1c61aba63f3c6c201d6ff784557960b" # Nov 30, 2022
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	[[ -e "docs/Compling_tesseract_and_leptonica.md" ]] || die "File moved?"
	local actual_leptonica_pv=$(grep "git checkout -b" "docs/Compling_tesseract_and_leptonica.md" \
		| head -n 1 \
		| grep -E -o  -e "[0-9]+\.[0-9]+\.[0-9]+" \
		| tail -n 1)
	local actual_tesseract_pv=$(grep "git checkout -b" "docs/Compling_tesseract_and_leptonica.md" \
		| tail -n 1 \
		| grep -E -o  -e "[0-9]+\.[0-9]+\.[0-9]+" \
		| tail -n 1)
	einfo "Inspecting tesseract version change"
	if ver_test "${actual_tesseract_pv}" -ne "${EXPECTED_TESSERACT_PV}" ; then
eerror
eerror "Version change detected for tesseract dependency"
eerror
eerror "Actual pv:\t${actual_tesseract_pv}"
eerror "Expected pv:\t${EXPECTED_TESSERACT_PV}"
eerror
		die
	fi
	einfo "Inspecting leptonica version change"
	if ver_test "${actual_leptonica_pv}" -ne "${EXPECTED_LEPTONICA_PV}" ; then
eerror
eerror "Version change detected for leptonica dependency"
eerror
eerror "Actual pv:\t${actual_leptonica_pv}"
eerror "Expected pv:\t${EXPECTED_LEPTONICA_PV}"
eerror
		die
	fi
}

src_compile() {
	local configuration="Release"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	dotnet publish \
		"src/Tesseract/Tesseract.csproj" \
		-f ${M[${TARGET_FRAMEWORK}]} \
		-p:Configuration="${configuration}" \
		|| die
	dotnet publish \
		"src/Tesseract.Drawing/Tesseract.Drawing.csproj" \
		-f ${M[${TARGET_FRAMEWORK}]} \
		-p:Configuration="${configuration}" \
		|| die
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

prune_marches() {
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

_install_mono() {
	local tfm="${M[${TARGET_FRAMEWORK}]}"
# See explanation why 4.5 (for latest runtime assemblies) is being used
# https://www.mono-project.com/docs/about-mono/releases/4.4.0/
	local mtfm="4.5"
	insinto "/usr/lib/mono/${mtfm}"
	exeinto "/usr/lib/mono/${mtfm}"
	dodir /usr/lib/mono/${mtfm}
	dosym /opt/${SDK}/shared/Tesseract/${MY_PV}/${tfm}/Tesseract.dll \
		/usr/lib/mono/${mtfm}/Tesseract.dll
	dosym /opt/${SDK}/shared/Tesseract.Drawing/${MY_PV}/${tfm}/Tesseract.Drawing.dll \
		/usr/lib/mono/${mtfm}/Tesseract.Drawing.dll

	dosym /opt/${SDK}/shared/Tesseract/${MY_PV}/${tfm}/Tesseract.dll \
		/usr/lib/mono/${mtfm}/Tesseract.dll

	local narch=$(get_march "${CHOST}")
	local v
	v="${EXPECTED_LEPTONICA_PV}"
	if [[ ! -e "${ESYSROOT}/usr/lib/mono/${mtfm}/leptonica-${v}.dll" ]] ; then
		dosym /opt/${SDK}/shared/Tesseract/${MY_PV}/${tfm}/${narch}/leptonica-${v}.dll \
			/usr/lib/mono/${mtfm}/leptonica-${v}.dll
	fi
	v=$(ver_cut 1-2 "${EXPECTED_TESSERACT_PV}")
	v="${v/.}"
	if [[ ! -e "${ESYSROOT}/usr/lib/mono/${mtfm}/tesseract${v}.dll" ]] ; then
		dosym /opt/${SDK}/shared/Tesseract/${MY_PV}/${tfm}/${narch}/tesseract${v}.dll \
			/usr/lib/mono/${mtfm}/tesseract${v}.dll
	fi
}

_install_dotnet_sdk() {
	[[ -e "${ESYSROOT}/opt/${s}" ]] || die
	local tfm="${M[${TARGET_FRAMEWORK}]}"

	local NS=(
		"Tesseract"
		"Tesseract.Drawing"
	)

	local ns
	for ns in ${NS[@]} ; do
		insinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		exeinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		prune_marches "src/${ns}/bin/${configuration}/${tfm}/publish"
		doins -r "src/${ns}/bin/${configuration}/${tfm}/publish/"*
	done
}

src_install() {
	local configuration="Release"

	_install_dotnet_sdk
	use mono && _install_mono


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
