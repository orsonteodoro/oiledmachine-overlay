# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"
MAINTAINER_MODE="1"

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
["Ae1a3cb26811ec93f96987e148660f1efb22d25b6"]="9a3f5fa9b9132395c780e9367943a96474fac30b"
["A892e6c10decf2cbb2d9fa4bab224c54b56e8f29e"]="3ec650593d9c91ae9d3c4c41c15782b3ceb56394"
["Abe7aba7cefa4cb50c670bae7035a73cfb0625a90"]="41b00e08b3f648f86198fcb421e6946e981ab961"
["Aabc745d3210ab5296585631a030e879a6ffa808b"]="e1d9bad7ccf0af2f5a63d6f4eb9450013b9154c2"
["A6c24b2b64caefd5e2c5e13997ebc0d178080ff80"]="8a70c5c32f0c8423a5d855dd63f39f37bd4b27a3"
["Ab866d5448b81ebf470bf6c212fc65ee1c6863a8e"]="84d5605e6304480dcbd7921742839a66fc3df855"
["Ab0b22a04311877ac3172b33792375d0b35f63938"]="6e78d6a02f4cb94de16cd324296ba2ce10341fd7"
["A6725382c755c1de2eb624789609adcf466e5ce61"]="84be7129d5bc20ce98f04779b81061e08b9e5829"
)

declare -A EXPECTED_SHA256=(
["Ae1a3cb26811ec93f96987e148660f1efb22d25b6"]="8b65b7e866705a544cee0bf70812573f067188d62eb2d25e648f39b0c546534e"
["A892e6c10decf2cbb2d9fa4bab224c54b56e8f29e"]="28106cc588915f01e1aabec46c57389cb0ca72ba43ebc524cb8d213d803e57a3"
["Abe7aba7cefa4cb50c670bae7035a73cfb0625a90"]="3d0f0f83c19a398479cfbed82535048f32fbbba88a3f0612a8bd2c22df56618e"
["Aabc745d3210ab5296585631a030e879a6ffa808b"]="6e11d6bebd7a0a0506bc0cc33e6ed5ffd69110c44b20232dece7fca51264a1fb"
["A6c24b2b64caefd5e2c5e13997ebc0d178080ff80"]="1927f246c9e6ee153a7505884973be14352a0c868504dfbcc9e75ca22a81f3d0"
["Ab866d5448b81ebf470bf6c212fc65ee1c6863a8e"]="a3f1108a4cf3c7d878d146c490dffcef69c1fe1e287d25ea291d50df15623dfd"
["Ab0b22a04311877ac3172b33792375d0b35f63938"]="06b790643e45b29448ebcf59e223ce2a718a629655d6e79ae3822ea104a530fb"
["A6725382c755c1de2eb624789609adcf466e5ce61"]="6cf3e919c7988fc7d6959c909ccbcbd75169d4382649fefd6c60268ca8c125d2"
)

declare -A EXPECTED_MD5=(
["Ae1a3cb26811ec93f96987e148660f1efb22d25b6"]="45135bc0f714fccfbdc7779f59db406c"
["A892e6c10decf2cbb2d9fa4bab224c54b56e8f29e"]="e5a57431e595377a6af7898458b934c4"
["Abe7aba7cefa4cb50c670bae7035a73cfb0625a90"]="a60e2efc56464eeba265539a6381b945"
["Aabc745d3210ab5296585631a030e879a6ffa808b"]="e5a9b673a42d44618c38604002a74fe3"
["A6c24b2b64caefd5e2c5e13997ebc0d178080ff80"]="da4e8c64a52b6c97ce080c77f1cde892"
["Ab866d5448b81ebf470bf6c212fc65ee1c6863a8e"]="70cb72d65bae018d14a504bdce7d6d3e"
["Ab0b22a04311877ac3172b33792375d0b35f63938"]="a64d6873a6337651e4159f85b266fa12"
["A6725382c755c1de2eb624789609adcf466e5ce61"]="bf8ac8e0fac55d1019139453c3493244"
)

declare -A EXPECTED_SIZE=(
["Ae1a3cb26811ec93f96987e148660f1efb22d25b6"]="290769556"
["A892e6c10decf2cbb2d9fa4bab224c54b56e8f29e"]="281017950"
["Abe7aba7cefa4cb50c670bae7035a73cfb0625a90"]="381881738"
["Aabc745d3210ab5296585631a030e879a6ffa808b"]="290769490"
["A6c24b2b64caefd5e2c5e13997ebc0d178080ff80"]="409733124"
["Ab866d5448b81ebf470bf6c212fc65ee1c6863a8e"]="329295450"
["Ab0b22a04311877ac3172b33792375d0b35f63938"]="329295444"
["A6725382c755c1de2eb624789609adcf466e5ce61"]="320539046"
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
pool/main/m/miopenkernels-gfx1030-36kdb/miopenkernels-gfx1030-36kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb/miopenkernels-gfx900-56kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb/miopenkernels-gfx900-64kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb/miopenkernels-gfx906-60kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb/miopenkernels-gfx906-64kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb/miopenkernels-gfx908-120kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-104kdb/miopenkernels-gfx90a-104kdb_1.1.0.50403-121~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb/miopenkernels-gfx90a-110kdb_1.1.0.50403-121~20.04_amd64.deb
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
			$(grep -i -r -e "miopenkernels.*deb" "${WORKDIR}" \
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
		for p in $(grep -l -r -e "miopenkernels.*deb" "${WORKDIR}" \
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
