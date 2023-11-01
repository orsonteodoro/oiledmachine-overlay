# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
MAINTAINER_MODE=1
if [[ "${PV##*.}" == "0" ]] ; then
	MY_PV=$(ver_cut 1-2 ${PV})
else
	MY_PV="${PV}"
fi
ROCM_SKIP_COMMON_PATHS_PATCHES=1
ROCM_SLOT="5.1"
ROCM_VERSION="${PV}"

inherit rocm unpacker

SRC_URI=""

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
IUSE="r1"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	!sci-libs/miopenkernels:0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	net-misc/wget
"
RESTRICT="
"
S="${WORKDIR}"
PATCHES=(
)

# hash of filename : data
# hashing is required for the key because of bug evaluating ~ within single quotes.
declare -A EXPECTED_SHA1=(
["A8450be309b432778765b4b85f10c03b493ff7bdd"]="00345d4ccdabcf12b2e65cad106014be4fddef55"
["A2c45a83b85a55b48fdd402429b1b5e8a128e41b7"]="214ffad02acbb58c6c976b972f0f1d5f45250e1e"
["Af44a727a79e34d9aa8e516fbdb364d7df3e9bdf8"]="59bf79435a3e35f21117083f6c60ddffc6874e9c"
["A139b97c9a6d7cbda13c20746ec0f13b8fcf9db92"]="3c1d003d96720b6338a66b30b30e16ebce748f40"
["A896d1a60a4b5b26985e85b0b6885ec905f9fc5d2"]="e99eff2dff2a546cb485d7becb823f7bfafee9b7"
["Af0038e118eddb9e6a57299884dbdab0b8bc4ad79"]="f70904b62e4c94930cabc4bc99f8244aa283ae62"
["A8a7a7535fdb0639aa915f06025a46a530fbc9f65"]="d3989e6303e7fa99c144090871ef7dd3296edf00"
["Abef4f13f0eb272dbf4397888e85eec706a0f5b93"]="98aac4345e51e02378e233a6f11c46510acc17b3"
["Ace9bb247196132f0a40a90aacd3f94285182c88c"]="566bd586400990980e271fafc48ff90cca653c20"
["A8777c6599f8e746f1bd5925fbd3b8d0ba8d020fd"]="a41a4be9ead2a6493642ca764fa0b43779da978d"
)

declare -A EXPECTED_SHA256=(
["A8450be309b432778765b4b85f10c03b493ff7bdd"]="ecaaa5de7c96295d7886293d3c61504fa47ba75c600946388c2dea4b5859b48b"
["A2c45a83b85a55b48fdd402429b1b5e8a128e41b7"]="f02b933aaeb73406bce981300af78ec1b3755150d2bd8b781bce6bdb722e85b6"
["Af44a727a79e34d9aa8e516fbdb364d7df3e9bdf8"]="2345a01e55728371c90e87f34056ac507f6ac08ad26ab53867b036f1e5e16782"
["A139b97c9a6d7cbda13c20746ec0f13b8fcf9db92"]="cfe980069463f681a702c7ec518a636a042ead90ae15e0b54c36208cbb4ec4d2"
["A896d1a60a4b5b26985e85b0b6885ec905f9fc5d2"]="1dad2d8419572118a9dec5c69b1656a54cd1896c860f9c1b34ca308d6caab6e7"
["Af0038e118eddb9e6a57299884dbdab0b8bc4ad79"]="44da26a2df4bb3661fb337163f6309bd22b400d58397e922aff89993bfc72efd"
["A8a7a7535fdb0639aa915f06025a46a530fbc9f65"]="515a90842452c4ed59ba18f8173f1d015e0a7a36be0bfa7b10470bd68e03d0e6"
["Abef4f13f0eb272dbf4397888e85eec706a0f5b93"]="28466594a92f7a63399da26e0985abd98dcdbafa8846f7af08612e55003fae0b"
["Ace9bb247196132f0a40a90aacd3f94285182c88c"]="c7c28dce304dc74648ec656c99470d691b1ae9d7aa25e9c1e30dc8af07af4500"
["A8777c6599f8e746f1bd5925fbd3b8d0ba8d020fd"]="4504b836dc662848d5068a87e1be0b3cec3635408cd40d2919e3f2c0d988b2e9"
)

declare -A EXPECTED_MD5=(
["A8450be309b432778765b4b85f10c03b493ff7bdd"]="98d55c0319459ccaa6afb17904b5db3e"
["A2c45a83b85a55b48fdd402429b1b5e8a128e41b7"]="31367946af922f777ead273653e0549e"
["Af44a727a79e34d9aa8e516fbdb364d7df3e9bdf8"]="6672921db95c1a8b033b1d79c0177a4b"
["A139b97c9a6d7cbda13c20746ec0f13b8fcf9db92"]="03a80666b15567a1637d091193beb539"
["A896d1a60a4b5b26985e85b0b6885ec905f9fc5d2"]="89f4b91d096798ea5dcd9c8becc7bcd2"
["Af0038e118eddb9e6a57299884dbdab0b8bc4ad79"]="f332164af2d0b538353ac6faabcd07b5"
["A8a7a7535fdb0639aa915f06025a46a530fbc9f65"]="b8c6a1d75b2af36dee7e38670dec5d3c"
["Abef4f13f0eb272dbf4397888e85eec706a0f5b93"]="46b1a228a9ed678349858ad96e8a802f"
["Ace9bb247196132f0a40a90aacd3f94285182c88c"]="f4a7f7174bc58339c289dbcef9004107"
["A8777c6599f8e746f1bd5925fbd3b8d0ba8d020fd"]="014efaef938963640dc2c93b652f1129"
)

declare -A EXPECTED_SIZE=(
["A8450be309b432778765b4b85f10c03b493ff7bdd"]="261947114"
["A2c45a83b85a55b48fdd402429b1b5e8a128e41b7"]="390901186"
["Af44a727a79e34d9aa8e516fbdb364d7df3e9bdf8"]="272103046"
["A139b97c9a6d7cbda13c20746ec0f13b8fcf9db92"]="272103058"
["A896d1a60a4b5b26985e85b0b6885ec905f9fc5d2"]="325614808"
["Af0038e118eddb9e6a57299884dbdab0b8bc4ad79"]="308967330"
["A8a7a7535fdb0639aa915f06025a46a530fbc9f65"]="81389970"
["Abef4f13f0eb272dbf4397888e85eec706a0f5b93"]="500036678"
["Ace9bb247196132f0a40a90aacd3f94285182c88c"]="321387202"
["A8777c6599f8e746f1bd5925fbd3b8d0ba8d020fd"]="32160"
)

check_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download kernels."
eerror
		die
	fi
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack ${1}
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	check_sandbox
	# Obtained from after csplit below manually removing junk items:
	local uri_base="https://repo.radeon.com/rocm/apt/${MY_PV}/"
	local files=(
pool/main/m/miopen-hip-gfx1030-36kdb/miopen-hip-gfx1030-36kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb/miopen-hip-gfx900-56kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb/miopen-hip-gfx900-64kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb/miopen-hip-gfx906-60kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb/miopen-hip-gfx906-64kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb/miopen-hip-gfx908-120kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb/miopen-hip-gfx90a-104kdb_2.20.0.50601-93~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb/miopen-hip-gfx90a-110kdb_2.20.0.50601-93~20.04_amd64.deb
	)

	if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
		# For hashes
		wget "https://repo.radeon.com/rocm/apt/${MY_PV}/dists/ubuntu/main/binary-amd64/Packages"
		csplit \
			--quiet \
			--prefix=Packages \
			--suffix-format=%02d.txt \
			--suppress-matched \
			Packages /^$/ {*}

		IFS=$'\n'
		local L=(
			$(grep -i -r -e "miopen-hip.*deb" "${WORKDIR}" \
			| cut -f 2 -d " " \
			| sort \
			| uniq)
		)

		einfo "Update files array with the following:"
		einfo
		local p
		for p in ${L[@]} ; do
			[[ "${p}" =~ "${PV}" ]] && continue # Skip duplicate
			echo "${p}"
		done
		einfo

		declare -A EXPECTED_SHA1
		declare -A EXPECTED_SHA256
		declare -A EXPECTED_MD5
		declare -A EXPECTED_SIZE
		for p in $(grep -l -r -e "miopen-hip.*deb" "${WORKDIR}" \
			| cut -f 2 -d " " \
			| sort) ; do
			local bn=$(basename $(grep "Filename:" "${p}" \
				| cut -f 2 -d " "))
			[[ "${bn}" =~ "${PV}" ]] && continue # Skip duplicate
			[[ -z "${bn}" ]] && continue

	# bnsan means base name (aka file name) sanitized.  Sometimes you cannot
	# use the raw base name as the key to the associative array.
			local bnsan="A"$(echo "${bn}" \
				| sha1sum \
				| cut -f 1 -d " ")
			local expected_sha1=$(grep "SHA1:" "${p}" \
				| cut -f 2 -d " ")
			local expected_sha256=$(grep "SHA256:" "${p}" \
				| cut -f 2 -d " ")
			local expected_md5=$(grep "MD5sum:" "${p}" \
				| cut -f 2 -d " ")
			local expected_size=$(grep "^Size:" "${p}" \
				| cut -f 2 -d " ")
			EXPECTED_SHA1["${bnsan}"]="${expected_sha1}"
			EXPECTED_SHA256["${bnsan}"]="${expected_sha256}"
			EXPECTED_MD5["${bnsan}"]="${expected_md5}"
			EXPECTED_SIZE["${bnsan}"]="${expected_size}"
		done
		IFS=$' \n\r\t'

		einfo "Update arrays:"
		echo
		declare -p EXPECTED_SHA1 \
			| sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" \
			| fold -w 120 -s
		echo
		declare -p EXPECTED_SHA256 \
			| sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" \
			| fold -w 180 -s
		echo
		declare -p EXPECTED_MD5 \
			| sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" \
			| fold -w 120 -s
		echo
		declare -p EXPECTED_SIZE \
			| sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" \
			| fold -w 80 -s
		echo

		die
	fi

	export EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${EDISTDIR}" || die
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		for y in ${files[@]} ; do
			if use "amdgpu_targets_${x}" && [[ "${y}" =~ "${x}" ]] ; then
	# Do it this way via wget instead of SRC_URI because the files are too large.
				addwrite "${EDISTDIR}"
				local bn=$(basename "${y}")
				[[ "${bn}" =~ "${PV}" ]] && continue # Skip duplicate
				wget -c "${uri_base}/${y}"
				local bnsan="A"$(echo "${bn}" \
					| sha1sum \
					| cut -f 1 -d " ")
				local actual_sha1=$(sha1sum $(basename "${y}") \
					| cut -f 1 -d " ")
				local actual_sha256=$(sha256sum $(basename "${y}") \
					| cut -f 1 -d " ")
				local actual_md5=$(md5sum $(basename "${y}") \
					| cut -f 1 -d " ")
				local actual_size=$(stat -c "%s" $(basename "${y}"))
einfo "Checking file integrity for ${EDISTDIR}/${bn}"
				if [[ "${EXPECTED_SHA1[${bnsan}]}" != "${actual_sha1}" ]] ; then
eerror
eerror "Expected sha1:  ${EXPECTED_SHA1[${bnsan}]}"
eerror "Actual sha1:  ${actual_sha1}"
eerror
eerror "sha1 checksum mismatch.  Delete the file and re-emerge."
eerror
					die
				fi
				if [[ "${EXPECTED_SHA256[${bnsan}]}" != "${actual_sha256}" ]] ; then
eerror
eerror "Expected sha256:  ${EXPECTED_SHA256[${bnsan}]}"
eerror "Actual sha256:  ${actual_sha256}"
eerror
eerror "sha256 checksum mismatch.  Delete the file and re-emerge."
eerror
					die
				fi
				if [[ "${EXPECTED_MD5[${bnsan}]}" != "${actual_md5}" ]] ; then
eerror
eerror "Expected md5:  ${EXPECTED_MD5[${bnsan}]}"
eerror "Actual md5:  ${actual_md5}"
eerror
eerror "md5 checksum mismatch.  Delete the file and re-emerge."
eerror
					die
				fi
				if [[ "${EXPECTED_SIZE[${bnsan}]}" != "${actual_size}" ]] ; then
eerror
eerror "Expected size:  ${EXPECTED_SIZE[${bnsan}]}"
eerror "Actual size:  ${actual_size}"
eerror
eerror "File size mismatch.  Delete the file and re-emerge."
eerror
					die
				fi
				pushd "${WORKDIR}" || die
					unpack_deb "${EDISTDIR}/${bn}"
				popd
			fi
		done
	done
}

src_prepare() {
	default
}

src_install() {
	insinto "/opt/rocm-${MY_PV}/share/miopen/db"
	local f
	for f in $(find . -name "*.kdb") ; do
		doins "${f}"
	done
einfo "Compressing kernels"
	pushd "${ED}/opt/rocm-${MY_PV}/share/miopen/db" || die
		for f in $(find . -name "*.kdb") ; do
			bzip2 -kv "${f}"
		done
	popd
}

# OILEDMACHINE-OVERLAY-STATUS:  finished
