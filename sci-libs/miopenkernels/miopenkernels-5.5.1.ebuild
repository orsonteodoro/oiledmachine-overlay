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
["Af1e9bb366665f9042366b472b7a053ab556688a1"]="b807f280130971491dee1f10a7023233769280ce"
["A4f0b1a8f87f2267741df1bd66eb98f893e1f469c"]="eb484918e46ef3f0858dd734c92d25170e8214b9"
["A49dbfead1ea83935e17c80cdd7bbed51d4919bcb"]="7d178c8b6eef1c9dab331b2dfce182e5a2213b91"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="813ca5f4e81876441e77835b380350330567b8e6"
["A399314b03e08b9bcfc3d01e4a75a57908530dd50"]="49748986cacc255db6b829d61b0c17cfd778f511"
["A40648aa7a46a6c80cce22c1d4f8ad8558b089d90"]="97e9718c1a19f16857082157a4e1be5516f16f9d"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="e4a61fb01e2a460543e20f714cb1b7e142f0303b"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="303cd24a5226decfbdd07619f261a788320a5ed5"
["A83c9449857d20e5c0e2313a4e9093814240cb587"]="2ecde0b84ae8e7e01701eea4a6ddf255b7472a1e"
["A79adc47bb6ae40856e7944cafdf242a125dd5010"]="0c9d5b7e80494e17ed9e60bcbd442f197c383b22"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="486ff20aad8166e4bf93b0fc147e7b87f15336b2"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="187a8ae6fa1fb505af1712c17cdecebdeeeedd10"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="222a3a1fc71f087b92bc2b1ff874f62d86a95a46"
["A2d52e8b3542a75e44ac0ca49bfe194445c514004"]="101e8808f1b75c4c2e3c1f260eafa03cdf9b150d"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="afd2b70f4716af00ddb083a89b77da76e5e7f48a"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="a12071a3a1e03d7147f0f12a30eb6cb7c1f016bd"
["Ac85bd9769c612e398ca13507af6264b36e46f7c0"]="ec25ada24cf45e409ec42b91d682f40b27273882"
["A54e6a60a7a1f34a4b2097bfe268e719651cfee16"]="cdd7a0312e7f6740445973452492a4a7cb993317"
) > /dev/null

declare -A EXPECTED_SHA256=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="f02543422a5020de195d3e5d0fb6f6f7e16d1dc149bf580c4eb3b2e79ace8139"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="573f1282eea3cf457e1b1f6a735670e73458b8ef77290a234c288c7bc24c2e80"
["Af1e9bb366665f9042366b472b7a053ab556688a1"]="ed4cc4d27ad0cd2fdf87fda9caa6d7ac4c2726790b910d02957276af33dde3b7"
["A4f0b1a8f87f2267741df1bd66eb98f893e1f469c"]="655067cca3581ccebfd754e255137f3608e6ebd7bfb01c9d408ae4b1fa3974b6"
["A49dbfead1ea83935e17c80cdd7bbed51d4919bcb"]="419fa191f8526dbcb9fae0aa87092b94130820362e6d78139f9ecc2143dcd0c5"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="49397997123b7314a3a268da14978203bd6dae9b2309c199b9987927581decf3"
["A399314b03e08b9bcfc3d01e4a75a57908530dd50"]="8ede833e98f9696775fe4422288de4d92684f2bda1707fc96af85f0f91883de6"
["A40648aa7a46a6c80cce22c1d4f8ad8558b089d90"]="f1b612d14a476970164638f1e77deb2a0f67f0812ff1bde993d445bc7b442ff8"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="d0a3b3f6c1b393f8984f65ecec2ae7d0b03c7ab6984f28a0a99cfef8805a5851"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="a0a9a98156e0d3fab80162d98ccac03c3a79ad25babb238f8fd9d5134cd9cd24"
["A83c9449857d20e5c0e2313a4e9093814240cb587"]="367056d48d935fa9b58c1d2c3b5dd67dd32faca42b99b9327d11a3d518df6ff6"
["A79adc47bb6ae40856e7944cafdf242a125dd5010"]="d61d8592ca9e4c419fb395bc2643198e9ab6a4d22f7283e4d6682a632c39e366"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="bac11a50236fa3f3e86948ba0433976d9af35bc4cda88d30290f9c4e2fc06dc8"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="3a246c66e26caac5eac98f6bcf23b2b9e0ec79cab7e1bb99969bb016339f625e"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="2c29bc75b9171ee92ca5ee5b42a829425e27d530fb676a8c62ab674518979513"
["A2d52e8b3542a75e44ac0ca49bfe194445c514004"]="2d0ef76484ac11298d81090636f720c448e7e929017df43aac83e422a794caf6"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="4c9197f1655eaddfcdfdb168b4b029ca6b92ad91a56522617457896780ad4854"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="17208bcfd22f108e592ec01d8e5361a9df196eb89a40119358e8121f246226d4"
["Ac85bd9769c612e398ca13507af6264b36e46f7c0"]="c487112d010300f8e869335be73b2fa60315fb7684fbdea2a65a3f9cd023642c"
["A54e6a60a7a1f34a4b2097bfe268e719651cfee16"]="bbc292e5a6407c427827edc4e04ffb11f0ebeb8815df00f88470fff06fa3397f"
) > /dev/null

declare -A EXPECTED_MD5=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="e482b21dcea8612afbcc9f414556727a"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="afee69ca697a412ceefccf76d147b211"
["Af1e9bb366665f9042366b472b7a053ab556688a1"]="3e2b1ee230a182daa3de9b88ecb12b50"
["A4f0b1a8f87f2267741df1bd66eb98f893e1f469c"]="16ae4b2722b9a783e4a75341e8876fdb"
["A49dbfead1ea83935e17c80cdd7bbed51d4919bcb"]="58a21a98547054aabe7c3b948a0719b3"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="b0c8ab6b61cd99173140962954fb718a"
["A399314b03e08b9bcfc3d01e4a75a57908530dd50"]="a9a1e1eaea57c1a3c73ec7de73d30b03"
["A40648aa7a46a6c80cce22c1d4f8ad8558b089d90"]="089cc30a621674e47498b1dd3518880f"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="be4c63856b058e96b79fd4fff76f6d6e"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="2632904e61e8703b8fb77f4ba0307c98"
["A83c9449857d20e5c0e2313a4e9093814240cb587"]="3b82c531207237c2e718d63427ea3333"
["A79adc47bb6ae40856e7944cafdf242a125dd5010"]="8ca846540f4f346537d700fe67a22a6f"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="7b190ea632073185afa8991152501215"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="ebf495fddbcd5f8a77f0fa13e980f459"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="7e5eb3259bc5cb42f191b92f5ea88577"
["A2d52e8b3542a75e44ac0ca49bfe194445c514004"]="ec20eda3ad92c28dd2648f2184292f9e"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="2504bb324f8401d9d85b4e5726ef689d"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="1435e84afeb00655a0ffeafc807b8375"
["Ac85bd9769c612e398ca13507af6264b36e46f7c0"]="6dc797c58a4707f3ef6f808e418ddaa2"
["A54e6a60a7a1f34a4b2097bfe268e719651cfee16"]="11a102cfd864017b97cc6a6f58f7497f"
) > /dev/null

declare -A EXPECTED_SIZE=(
["Ab2634560812147271e578bfdd4207c6050a2e672"]="390901264"
["A0d7f0414a82485d20d5a544a48a69dcdff053c9a"]="308966928"
["Af1e9bb366665f9042366b472b7a053ab556688a1"]="261949952"
["A4f0b1a8f87f2267741df1bd66eb98f893e1f469c"]="308966896"
["A49dbfead1ea83935e17c80cdd7bbed51d4919bcb"]="32064"
["Ad5b7b00398c2e979ac7e6c4cfb694be55746bbde"]="78767914"
["A399314b03e08b9bcfc3d01e4a75a57908530dd50"]="500035492"
["A40648aa7a46a6c80cce22c1d4f8ad8558b089d90"]="776589404"
["A249ea9c8ec3977a9123cdada233ce528b5849b19"]="272102782"
["A9a58a25f6aa8edd8e15e0caef84f55558be91808"]="272102784"
["A83c9449857d20e5c0e2313a4e9093814240cb587"]="78762952"
["A79adc47bb6ae40856e7944cafdf242a125dd5010"]="390902908"
["A3102ee97f7f56008887f2bb399a2650651b11a78"]="500036610"
["A62a8ddec98c7d53e19dd2ccf56987a17be9f6508"]="308967280"
["Ac4f150361654434641f1308686b4d90e493ee5ad"]="261947038"
["A2d52e8b3542a75e44ac0ca49bfe194445c514004"]="272103068"
["A89e04c78811b61e6b5cf86821732d9a075f7d3a6"]="31924"
["Aa18d26d4c8977064d3c23caa48421603b0c40c77"]="776591522"
["Ac85bd9769c612e398ca13507af6264b36e46f7c0"]="272102532"
["A54e6a60a7a1f34a4b2097bfe268e719651cfee16"]="308967176"
) > /dev/null

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
pool/main/m/miopen-hip-gfx1030-36kdb/miopen-hip-gfx1030-36kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx1030-36kdb5.5.1/miopen-hip-gfx1030-36kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx1030-36kdb5.5.1/miopen-hip-gfx1030-36kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb/miopen-hip-gfx900-56kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb/miopen-hip-gfx900-56kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb5.5.1/miopen-hip-gfx900-56kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb5.5.1/miopen-hip-gfx900-56kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb/miopen-hip-gfx900-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb/miopen-hip-gfx900-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb5.5.1/miopen-hip-gfx900-64kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb5.5.1/miopen-hip-gfx900-64kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb/miopen-hip-gfx906-60kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb/miopen-hip-gfx906-60kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb5.5.1/miopen-hip-gfx906-60kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb5.5.1/miopen-hip-gfx906-60kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb/miopen-hip-gfx906-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb/miopen-hip-gfx906-64kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb5.5.1/miopen-hip-gfx906-64kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb5.5.1/miopen-hip-gfx906-64kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb/miopen-hip-gfx908-120kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb/miopen-hip-gfx908-120kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb5.5.1/miopen-hip-gfx908-120kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb5.5.1/miopen-hip-gfx908-120kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb/miopen-hip-gfx90a-104kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb/miopen-hip-gfx90a-104kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb5.5.1/miopen-hip-gfx90a-104kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb5.5.1/miopen-hip-gfx90a-104kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb/miopen-hip-gfx90a-110kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb/miopen-hip-gfx90a-110kdb_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb5.5.1/miopen-hip-gfx90a-110kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb5.5.1/miopen-hip-gfx90a-110kdb5.5.1_2.19.0.50501-74~20.04_amd64.deb
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

		einfo "Update files array with the following:"
		einfo
		grep -i -r -e "miopen-hip.*deb" "${WORKDIR}" \
			| cut -f 2 -d " " \
			| sort
		einfo

		declare -A EXPECTED_SHA1
		declare -A EXPECTED_SHA256
		declare -A EXPECTED_MD5
		declare -A EXPECTED_SIZE
		IFS=$'\n'
		local p
		for p in $(grep -l -r -e "miopen-hip.*deb" "${WORKDIR}" \
			| cut -f 2 -d " " \
			| sort) ; do
			local bn=$(basename $(grep "Filename:" "${p}" \
				| cut -f 2 -d " "))
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
				wget -c "${uri_base}/${y}"
				local bn=$(basename "${y}")
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
