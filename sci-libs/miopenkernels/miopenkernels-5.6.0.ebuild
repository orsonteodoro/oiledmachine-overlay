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
MY_PV=$(ver_cut 1-2 ${PV})
ROCM_SKIP_COMMON_PATHS_PATCHES=1
ROCM_VERSION="${PV}"
inherit rocm unpacker

SRC_URI=""

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="r1"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
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
["Aec7dca048027f0f6f25f40af0197e4e8a0db9eca"]="524bbe96383729786b8a4b59c4764ddf813c9bd2"
["Adb65a6d33366ead7199778de802e74ed1a9c899d"]="7325f77bce6b600519aaa1af9fadc625540b9086"
["A0256f2fbf5c67f08dc5aa45c90a6b5a80ecd4b9d"]="e86c337755a66419055e9abc9c1f5035890d96b8"
["Af2eecdd4642162e08d3013ebf175e0cad723f0d9"]="406ab920d3ffc1edf822cf3dd7853c7e4c2591d7"
["Af3ead9cea20555ad0aebc2df459bcf9cbc6567c2"]="b8be3f496eb610679e56578590e858efb277553e"
["A82827e14770a53ac26657399880f42da87001175"]="7c9bb2c850112ee25dfc5e42379afcb1390dbeff"
["A9c4b64399626b720727816f942f5a04de37eac0a"]="27959f4fab433d31240134589261251224271d7e"
["Acd8cbe668837ca0b9c29e03d72155eb8fc0d8bce"]="30ec518ddcb54699eeb9a70bccac8de296757e98"
["Afa9e8d78b4d37311bf4208ee28838c16cf0cd1f7"]="2f260eb0d452896b17099de89684473f81057e1a"
["A62e6018160941dfd64753d254f8f258203600dc3"]="9f282522b44b75fe7e0d4389053c5a02b5ab25fd"
)

declare -A EXPECTED_SHA256=(
["Aec7dca048027f0f6f25f40af0197e4e8a0db9eca"]="daf2c1ec77b54813842f37da525c6059a2e4353751bf91decf433ec7548be8b1"
["Adb65a6d33366ead7199778de802e74ed1a9c899d"]="51babf99690e8fdb9a4145a4421d16cc1f550404e085a1d3810299ffe2662899"
["A0256f2fbf5c67f08dc5aa45c90a6b5a80ecd4b9d"]="c756f2270bd2034731a753ef6190c82c6ad3524298d3f1d571985db1dc19f2f1"
["Af2eecdd4642162e08d3013ebf175e0cad723f0d9"]="37221956a568b5fe8dc33e7a2f61a8ed2728faa85b20e6f82ce6809d6bc5dd57"
["Af3ead9cea20555ad0aebc2df459bcf9cbc6567c2"]="ba1d74791470a8af403e121e7407396904ce647f9977b3cfa89d51b3fe056329"
["A82827e14770a53ac26657399880f42da87001175"]="daffd6f1e33d9326aa595c67baa7afa8c0b4b8ac208d8dd786c725969002f503"
["A9c4b64399626b720727816f942f5a04de37eac0a"]="04eedf775bd8e729716bcab33ede3dcd758cdceefedb2a3e46a9934842a436b6"
["Acd8cbe668837ca0b9c29e03d72155eb8fc0d8bce"]="2be69d7171f2937466c5014cba836bdb58ab2668d7e64b93d488a7b4cc86b991"
["Afa9e8d78b4d37311bf4208ee28838c16cf0cd1f7"]="9353e34ff7c9123ea2c4ded8b1a35cf1adb5276a15c92a52d5ef5233bb52f44a"
["A62e6018160941dfd64753d254f8f258203600dc3"]="f29f55e9acba3e495f2e24f6e2683db05a6261204c439d8df422e1a5ffef8f94"
)

declare -A EXPECTED_MD5=(
["Aec7dca048027f0f6f25f40af0197e4e8a0db9eca"]="40a112b4a721465fcbd16a897beb557b"
["Adb65a6d33366ead7199778de802e74ed1a9c899d"]="1779f66496cd33cb01433ac75360e3b1"
["A0256f2fbf5c67f08dc5aa45c90a6b5a80ecd4b9d"]="07393488bc6ba0121feeaac375e6b660"
["Af2eecdd4642162e08d3013ebf175e0cad723f0d9"]="1642737eb69425aa5b9c1dc13fbbaec8"
["Af3ead9cea20555ad0aebc2df459bcf9cbc6567c2"]="01570d619163855d32ad428013d909e7"
["A82827e14770a53ac26657399880f42da87001175"]="0991f79dbd4d649965a76344e420e5bc"
["A9c4b64399626b720727816f942f5a04de37eac0a"]="b50942b76786435dd5703de5bbc6aa30"
["Acd8cbe668837ca0b9c29e03d72155eb8fc0d8bce"]="0489f1a439da87dfc942e5d4b64cea59"
["Afa9e8d78b4d37311bf4208ee28838c16cf0cd1f7"]="56665f0775de6ac71d6e7fb5be31c356"
["A62e6018160941dfd64753d254f8f258203600dc3"]="d5bf6f5bf22f261624efb9c31487b546"
)

declare -A EXPECTED_SIZE=(
["Aec7dca048027f0f6f25f40af0197e4e8a0db9eca"]="390901188"
["Adb65a6d33366ead7199778de802e74ed1a9c899d"]="321387208"
["A0256f2fbf5c67f08dc5aa45c90a6b5a80ecd4b9d"]="32150"
["Af2eecdd4642162e08d3013ebf175e0cad723f0d9"]="261946534"
["Af3ead9cea20555ad0aebc2df459bcf9cbc6567c2"]="776591590"
["A82827e14770a53ac26657399880f42da87001175"]="308966848"
["A9c4b64399626b720727816f942f5a04de37eac0a"]="272103008"
["Acd8cbe668837ca0b9c29e03d72155eb8fc0d8bce"]="272103008"
["Afa9e8d78b4d37311bf4208ee28838c16cf0cd1f7"]="81363874"
["A62e6018160941dfd64753d254f8f258203600dc3"]="500036704"
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
pool/main/m/miopen-hip-gfx1030-36kdb/miopen-hip-gfx1030-36kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-56kdb/miopen-hip-gfx900-56kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx900-64kdb/miopen-hip-gfx900-64kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-60kdb/miopen-hip-gfx906-60kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx906-64kdb/miopen-hip-gfx906-64kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx908-120kdb/miopen-hip-gfx908-120kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-104kdb/miopen-hip-gfx90a-104kdb_2.20.0.50600-67~20.04_amd64.deb
pool/main/m/miopen-hip-gfx90a-110kdb/miopen-hip-gfx90a-110kdb_2.20.0.50600-67~20.04_amd64.deb
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
