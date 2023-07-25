# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"
MAINTAINER_MODE="0"

AMDGPU_TARGETS_OVERRIDE=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
ROCM_VERSION="${PV}"
inherit rocm unpacker

SRC_URI=""

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE=""
RDEPEND="
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
["Ab2634560812147271e578bfdd4207c6050a2e672"]="7bf535756a9bf98def56f909797c5076484e4ed8"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="e6ef5335e6010bd6f83b68bf2987bd4d27ab427b"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="813ca5f4e81876441e77835b380350330567b8e6"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="e4a61fb01e2a460543e20f714cb1b7e142f0303b"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="303cd24a5226decfbdd07619f261a788320a5ed5"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="486ff20aad8166e4bf93b0fc147e7b87f15336b2"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="187a8ae6fa1fb505af1712c17cdecebdeeeedd10"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="222a3a1fc71f087b92bc2b1ff874f62d86a95a46"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="afd2b70f4716af00ddb083a89b77da76e5e7f48a"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="a12071a3a1e03d7147f0f12a30eb6cb7c1f016bd"
)

declare -A EXPECTED_SHA256=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="f02543422a5020de195d3e5d0fb6f6f7e16d1dc149bf580c4eb3b2e79ace8139"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="573f1282eea3cf457e1b1f6a735670e73458b8ef77290a234c288c7bc24c2e80"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="49397997123b7314a3a268da14978203bd6dae9b2309c199b9987927581decf3"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="d0a3b3f6c1b393f8984f65ecec2ae7d0b03c7ab6984f28a0a99cfef8805a5851"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="a0a9a98156e0d3fab80162d98ccac03c3a79ad25babb238f8fd9d5134cd9cd24"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="bac11a50236fa3f3e86948ba0433976d9af35bc4cda88d30290f9c4e2fc06dc8"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="3a246c66e26caac5eac98f6bcf23b2b9e0ec79cab7e1bb99969bb016339f625e"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="2c29bc75b9171ee92ca5ee5b42a829425e27d530fb676a8c62ab674518979513"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="4c9197f1655eaddfcdfdb168b4b029ca6b92ad91a56522617457896780ad4854"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="17208bcfd22f108e592ec01d8e5361a9df196eb89a40119358e8121f246226d4"
)

declare -A EXPECTED_MD5=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="e482b21dcea8612afbcc9f414556727a"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="afee69ca697a412ceefccf76d147b211"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="b0c8ab6b61cd99173140962954fb718a"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="be4c63856b058e96b79fd4fff76f6d6e"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="2632904e61e8703b8fb77f4ba0307c98"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="7b190ea632073185afa8991152501215"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="ebf495fddbcd5f8a77f0fa13e980f459"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="7e5eb3259bc5cb42f191b92f5ea88577"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="2504bb324f8401d9d85b4e5726ef689d"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="1435e84afeb00655a0ffeafc807b8375"
)

declare -A EXPECTED_SIZE=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="390901264"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="308966928"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="78767914"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="272102782"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="272102784"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="500036610"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="308967280"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="261947038"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="31924"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="776591522"
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
	# obtain from after csplit below:
	local uri_base="https://repo.radeon.com/rocm/apt/${MY_PV}/"
	local files=(
pool/main/m/miopen-hip-gfx1030-36kdb/miopen-hip-gfx1030-36kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb/miopen-hip-gfx900-56kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb/miopen-hip-gfx900-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb/miopen-hip-gfx906-60kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb/miopen-hip-gfx906-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb/miopen-hip-gfx908-120kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb/miopen-hip-gfx90a-104kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb/miopen-hip-gfx90a-110kdb_2.19.0.50501-74~20.04_amd64.deb
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
	for x in ${AMDGPU_TARGETS_OVERRIDE[@]} ; do
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

src_install() {
	insinto /opt/rocm-${MY_PV}/share/miopen/db
	local f
	for f in $(find . -name "*.kdb") ; do
		doins "${f}"
	done
}

# OILEDMACHINE-OVERLAY-STATUS:  in-development
