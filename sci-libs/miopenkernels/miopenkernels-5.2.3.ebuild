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
["A2a1473f2571379743bdb8b5ecf5375375ab5ad9b"]="cae98ce9798f1df329542b9932fc882f66646372"
["A6a5fade9e52123f9661fde2ab90926f0463b7039"]="e09ebb96fa9e982edab6c41b98b3f5febb6137cf"
["Aa419d9e97d9e0906440243815b9404615b933cee"]="fe0f01813603a484f28ea35bc7145bcfce237e27"
["Aea37f08e7b22ea8a567bf2bb6594285f8158870b"]="29701e16f99599461e7d4ecf9d36f56b4245794b"
["Ae6906b860935cb66da60585b1dd3810f4b262ee6"]="aaffb9816e03d726978f3ffea7be188125301172"
["Af60b2be53bb51ad5188f3b49848e34655b21288a"]="79d3d3da86ae25d6965594bb5d3bb9655a54f7c0"
["Ac80b04d63fde9440298e0f883d754cb07122c376"]="b999e0a178022ce2adaa1a3290606f004da6ba44"
)

declare -A EXPECTED_SHA256=(
["A2a1473f2571379743bdb8b5ecf5375375ab5ad9b"]="1b2ca974b9b8cfef458d27450ee26cc7ac22d102fccec0024a86ef71549eaf55"
["A6a5fade9e52123f9661fde2ab90926f0463b7039"]="6ed0adea80f00e1b9c95824be66013018531002025c097229ec0ccf543bb78e7"
["Aa419d9e97d9e0906440243815b9404615b933cee"]="b93445822864fd70aacfe068e6d7d49dd1c53b2c7350183759bbcf7075e57a21"
["Aea37f08e7b22ea8a567bf2bb6594285f8158870b"]="35eac06f9000567230f00bb741d9f0d7db2a01f0fb069a8d573880487c5206b9"
["Ae6906b860935cb66da60585b1dd3810f4b262ee6"]="d7f178c57dcd1c43331304ca52d90b7d50dea69eafe79c21a68f98f91c50b9fc"
["Af60b2be53bb51ad5188f3b49848e34655b21288a"]="ff8ce448a6525ca44510f931bef64995495c1e3c3f459ad348654f00cca81f29"
["Ac80b04d63fde9440298e0f883d754cb07122c376"]="cbe6703ae80be6a6149087fcf7265d4886a50b5cba7e8a723ec2c7b1117442b8"
)

declare -A EXPECTED_MD5=(
["A2a1473f2571379743bdb8b5ecf5375375ab5ad9b"]="a2f28647f500d866323bc3ef88e5fbee"
["A6a5fade9e52123f9661fde2ab90926f0463b7039"]="59f4534370b5cab9acbdaea79c09c7c2"
["Aa419d9e97d9e0906440243815b9404615b933cee"]="b88deccbe3637eb8e23a82bbd5b718e2"
["Aea37f08e7b22ea8a567bf2bb6594285f8158870b"]="c48daf415f12d733ec9bcf59088400de"
["Ae6906b860935cb66da60585b1dd3810f4b262ee6"]="f12824d8189188db6295fce4ea64f49a"
["Af60b2be53bb51ad5188f3b49848e34655b21288a"]="ddf7a2e6bd1b6e097e256fb69fa09636"
["Ac80b04d63fde9440298e0f883d754cb07122c376"]="73a924fb868365ee7dba8fd03846693f"
)

declare -A EXPECTED_SIZE=(
["A2a1473f2571379743bdb8b5ecf5375375ab5ad9b"]="329295326"
["A6a5fade9e52123f9661fde2ab90926f0463b7039"]="213718152"
["Aa419d9e97d9e0906440243815b9404615b933cee"]="329295444"
["Aea37f08e7b22ea8a567bf2bb6594285f8158870b"]="290769532"
["Ae6906b860935cb66da60585b1dd3810f4b262ee6"]="283794578"
["Af60b2be53bb51ad5188f3b49848e34655b21288a"]="314289728"
["Ac80b04d63fde9440298e0f883d754cb07122c376"]="290769532"
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
pool/main/m/miopenkernels-gfx1030-36kdb/miopenkernels-gfx1030-36kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb/miopenkernels-gfx900-56kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb/miopenkernels-gfx900-64kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb/miopenkernels-gfx906-60kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb/miopenkernels-gfx906-64kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb/miopenkernels-gfx908-120kdb_1.1.0.50203-109_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb/miopenkernels-gfx90a-110kdb_1.1.0.50203-109_amd64.deb
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

# OILEDMACHINE-OVERLAY-STATUS:  finished, builds-without-problems
