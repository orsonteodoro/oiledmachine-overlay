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
MAINTAINER_MODE=0
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
["A9ae482f6e1a7514824010ea6cb499f2a9f1fc498"]="ff99ba264e45c75433a4c599b7c37ebf021dc53e"
["Aeb9082254c8943feb16a1313607f81c9efb7e306"]="8f113006cd4cf93eaf5e369b9eed1427af580777"
["A6926c5f5e1cd80363385159f1de829b98d0ac23c"]="d347cb39300fb16b22ef01ce6e1af40fd29e51c8"
["Ad90157791c108ce25a81544e926c67af62fd4e9d"]="7f79ae69114af9fb69f531d9fc35b46f6b809799"
["A9c9c4c3ab6c761efe02f4f2c64d14bfa004fadce"]="3d98e30b5eb57d955e3b3867475428e182971d17"
["A5fb34322961db96b4fdeb36fd9fdb162f21d7b08"]="b5195cdb6d003b14ff537784773b9575df5c87e7"
["A05c602228d8e96822842a88fb0c1b7e89d6b4445"]="cffedc59b4b04461c775f3c15a5cde3f97ced2ab"
["A640874c689b56202c90eb3b2e906e8671f7d18d1"]="c985bc0a27657af63f1fdc19b5b0ee3604370ebb"
["Aa4a56c86f64d508bf66f94187d9efbab4e7fbc3e"]="e4b01dcd3ed9c0fca5ae573d723a834b8b0f9edb"
["A90ac58e2ac6d4ae2b7a14373fe64f42bc113f120"]="d1d3af2960df2013093efade4ef94000467c303c"
["Acc42603207a44da30768aed1259ce7abaf35fa05"]="c7ad627cb0862beaca18eb0e54fac7b00e5b7340"
["Aae1bae95f308aeb211841e7e8d1a15b9fa94195f"]="937dbea5c1ba6222fa44d1b0efef57dd723bbb2d"
["A10d48a3c5cfb4d89d527099634fa48b0080f4ec0"]="2cb0809d2b3e6efafdd8bd0331d45e64556bacc4"
)

declare -A EXPECTED_SHA256=(
["A9ae482f6e1a7514824010ea6cb499f2a9f1fc498"]="50aa75962d4a3f319eaf16bd4182e5e9ce6499ce937aaaa1562651fb704b1666"
["Aeb9082254c8943feb16a1313607f81c9efb7e306"]="b430f912d9ac3bd51547f9ad03f1015daa825bed4e433ff4f355781d53a1eafb"
["A6926c5f5e1cd80363385159f1de829b98d0ac23c"]="bb5aefec03173f6f0ff3fdf9a31193c97ea8bac5ad39644770b01cea93771091"
["Ad90157791c108ce25a81544e926c67af62fd4e9d"]="7bbeca5591abce89e58a3f1a80634437e982fe85b8327db2f833ae04853e32c0"
["A9c9c4c3ab6c761efe02f4f2c64d14bfa004fadce"]="76dd4efe580cbaeda35797c04d2f34c7f5eb237edf48b0f32f6c861beea50d99"
["A5fb34322961db96b4fdeb36fd9fdb162f21d7b08"]="d85ae986e3ad3af63960aeab104868bf4f6e134d7e1e13aa9c93cd312281e136"
["A05c602228d8e96822842a88fb0c1b7e89d6b4445"]="f5059a3168b016e4a2aa3fddea7ff2fa41f75b729c76b32a835bd98ed0982323"
["A640874c689b56202c90eb3b2e906e8671f7d18d1"]="4ac6b9308d538d1ebe08e70e49fd3507e4cc3ead7833a161be685cda7ed5c6ec"
["Aa4a56c86f64d508bf66f94187d9efbab4e7fbc3e"]="2081835f10307c2395ecd3b75b6ba79acf028b482be01979fadeee6c10ab45e6"
["A90ac58e2ac6d4ae2b7a14373fe64f42bc113f120"]="90f8c75764435e1d582f53b2264839d0509e4accd7d5b5593abb0f2f1ef5a1e2"
["Acc42603207a44da30768aed1259ce7abaf35fa05"]="713ad42b5bc1c191a255fb7c307859ca8e7925881fe9660987a4cff6c5e16329"
["Aae1bae95f308aeb211841e7e8d1a15b9fa94195f"]="622280dfa1541b3312c9635e6cfb6205ec9efbf82d968a27953c0faefbfb65e8"
["A10d48a3c5cfb4d89d527099634fa48b0080f4ec0"]="86d24b699216e343eb961b2d405dafe481aee606671065fea90fdf1247b7d9d3"
)

declare -A EXPECTED_MD5=(
["A9ae482f6e1a7514824010ea6cb499f2a9f1fc498"]="3e3a15158a993715abcb862aec884ea9"
["Aeb9082254c8943feb16a1313607f81c9efb7e306"]="2165a273f3723a3537c653d9dbc11387"
["A6926c5f5e1cd80363385159f1de829b98d0ac23c"]="eb6bce91376743ab7d14e755c2b8b909"
["Ad90157791c108ce25a81544e926c67af62fd4e9d"]="16d53ca9ed2c02ac642331bab0417397"
["A9c9c4c3ab6c761efe02f4f2c64d14bfa004fadce"]="000a4d8889c1303aa073111da07b8e1d"
["A5fb34322961db96b4fdeb36fd9fdb162f21d7b08"]="e980433f12194a0ea3124885a6f78139"
["A05c602228d8e96822842a88fb0c1b7e89d6b4445"]="ca806c49af76503f6fba685e94784b6b"
["A640874c689b56202c90eb3b2e906e8671f7d18d1"]="4b1dafdc1e6a1a1e1fb17eefb7a1e22d"
["Aa4a56c86f64d508bf66f94187d9efbab4e7fbc3e"]="945d94bb52f1e3881cd33d22bc939870"
["A90ac58e2ac6d4ae2b7a14373fe64f42bc113f120"]="d8445ea3ad3b58f8c5b851298000b16e"
["Acc42603207a44da30768aed1259ce7abaf35fa05"]="d40b9cb5cbf38ef9a0a4447b34260cc7"
["Aae1bae95f308aeb211841e7e8d1a15b9fa94195f"]="a11a0a82a041a87ee383e0a2abe5fce8"
["A10d48a3c5cfb4d89d527099634fa48b0080f4ec0"]="bdf37da24929bdb4936acbae56db8c06"
)

declare -A EXPECTED_SIZE=(
["A9ae482f6e1a7514824010ea6cb499f2a9f1fc498"]="272266576"
["Aeb9082254c8943feb16a1313607f81c9efb7e306"]="734"
["A6926c5f5e1cd80363385159f1de829b98d0ac23c"]="325614692"
["Ad90157791c108ce25a81544e926c67af62fd4e9d"]="732"
["A9c9c4c3ab6c761efe02f4f2c64d14bfa004fadce"]="111319578"
["A5fb34322961db96b4fdeb36fd9fdb162f21d7b08"]="734"
["A05c602228d8e96822842a88fb0c1b7e89d6b4445"]="339285480"
["A640874c689b56202c90eb3b2e906e8671f7d18d1"]="734"
["Aa4a56c86f64d508bf66f94187d9efbab4e7fbc3e"]="90203954"
["A90ac58e2ac6d4ae2b7a14373fe64f42bc113f120"]="32334"
["Acc42603207a44da30768aed1259ce7abaf35fa05"]="734"
["Aae1bae95f308aeb211841e7e8d1a15b9fa94195f"]="390900968"
["A10d48a3c5cfb4d89d527099634fa48b0080f4ec0"]="321529380"
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
pool/main/m/miopen-hip-asan-gfx1030kdb/miopen-hip-asan-gfx1030kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-asan-gfx900kdb/miopen-hip-asan-gfx900kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-asan-gfx906kdb/miopen-hip-asan-gfx906kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-asan-gfx908kdb/miopen-hip-asan-gfx908kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-asan-gfx90akdb/miopen-hip-asan-gfx90akdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-gfx1030kdb/miopen-hip-gfx1030kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900kdb/miopen-hip-gfx900kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906kdb/miopen-hip-gfx906kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908kdb/miopen-hip-gfx908kdb_2.20.0.50700-63~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90akdb/miopen-hip-gfx90akdb_2.20.0.50700-63~20.04_amd64.deb
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

	# bnsan means base name (aka file name) sanitized.  Sometimes you cannot
	# use the raw base name as the key to the associative array.
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
