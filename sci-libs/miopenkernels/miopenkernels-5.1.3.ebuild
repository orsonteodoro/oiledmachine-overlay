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
MY_PV="${PV}"
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
["A4f7d94e51ece7173027a54b0160a602d5dfec9d6"]="54025c78c23f626330028cf1ec6e90545b8f8037"
["A2ee1578fd347424d134d60a9f4119c4e1f1f5570"]="3cacfedb7f6db7a167ccf8dd9f5e597b70a49fe1"
["Ae912aa960b493ad8293df04f14e594459462ae7a"]="9423618f30e52672f828dd50c435c39c8393105a"
["A510109c8318bcac2493aa090afdb10ae1b03962f"]="80ffba6b07ca8c1e6455364fe1c76301e7843962"
["A99ca03b523446e2487a81fa4e79e12305c977255"]="2ced3fe74ffa06b6237dcc63ad0a8f2e9c973b5b"
["A8470268e54706858b6d36992e2079b9ed54762f6"]="acb0cda6f716c303a550083ab913c0d66e545799"
["A6d1f1360462914fafb98f5a09279b7345566ac67"]="e9dc648aadbcd3423646f288aaf6eb244ae4178a"
["A28edf034be26d43f4e9b8a7685b7c102817c398d"]="5c424f727c13a6106fe7a53c10f32f51564b6fc2"
)

declare -A EXPECTED_SHA256=(
["A4f7d94e51ece7173027a54b0160a602d5dfec9d6"]="5330c3d53685b81d877f229d7f2c48febebdc7e7bfdff78004bb833bc9d74110"
["A2ee1578fd347424d134d60a9f4119c4e1f1f5570"]="06d3bfe0bbb90053ecc53fa27349faaea68842bb0c7c72ccb0fe394c4b468617"
["Ae912aa960b493ad8293df04f14e594459462ae7a"]="5684106aea35f7229eacc2da45ec3c6201c763ee0a679c0a3975ea4242143703"
["A510109c8318bcac2493aa090afdb10ae1b03962f"]="a9fea8f51e117a6238f3307f046bc5a2bb944704cd629620d4ef27424c24f5fb"
["A99ca03b523446e2487a81fa4e79e12305c977255"]="af492531c2f433a71a3d9d3ac8e672886c7770eabacd3be0adaea4ec0da9a16c"
["A8470268e54706858b6d36992e2079b9ed54762f6"]="5ce054e8c989d9f30e1a452d0414b33420af06b40af05efd6ff5c48d6dedff13"
["A6d1f1360462914fafb98f5a09279b7345566ac67"]="2702b3cb234bdc836eb3c149d610017934d4fe5b1f192482321f2771d80c2679"
["A28edf034be26d43f4e9b8a7685b7c102817c398d"]="1b55a053fa91d93e3e08f8109501efb85c4b249c8ead11a8f4bf047028089ab4"
)

declare -A EXPECTED_MD5=(
["A4f7d94e51ece7173027a54b0160a602d5dfec9d6"]="33cefa6da54d1f3f916e966bb805e080"
["A2ee1578fd347424d134d60a9f4119c4e1f1f5570"]="de7de31c02ba3de4d7bb0116c8ff9296"
["Ae912aa960b493ad8293df04f14e594459462ae7a"]="fcb9c1681dd7f69c0e32ff32c625ad1e"
["A510109c8318bcac2493aa090afdb10ae1b03962f"]="ff140663eee691f2111e971f2450f5cb"
["A99ca03b523446e2487a81fa4e79e12305c977255"]="c2f077a8ecd3fea420fa5dc58756a8d4"
["A8470268e54706858b6d36992e2079b9ed54762f6"]="7488c446c2322061e2035eedbc0f16bc"
["A6d1f1360462914fafb98f5a09279b7345566ac67"]="f3658503bd35832e9bcd2fab8b72ca75"
["A28edf034be26d43f4e9b8a7685b7c102817c398d"]="fb93abc9a0383b28c7f9b88c24562152"
)

declare -A EXPECTED_SIZE=(
["A4f7d94e51ece7173027a54b0160a602d5dfec9d6"]="174789448"
["A2ee1578fd347424d134d60a9f4119c4e1f1f5570"]="329295428"
["Ae912aa960b493ad8293df04f14e594459462ae7a"]="212725064"
["A510109c8318bcac2493aa090afdb10ae1b03962f"]="290769576"
["A99ca03b523446e2487a81fa4e79e12305c977255"]="224472120"
["A8470268e54706858b6d36992e2079b9ed54762f6"]="191462388"
["A6d1f1360462914fafb98f5a09279b7345566ac67"]="329295462"
["A28edf034be26d43f4e9b8a7685b7c102817c398d"]="290769562"
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
pool/main/m/miopenkernels-gfx1030-36kdb/miopenkernels-gfx1030-36kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb/miopenkernels-gfx900-56kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb/miopenkernels-gfx900-64kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb/miopenkernels-gfx906-60kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb/miopenkernels-gfx906-64kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb/miopenkernels-gfx908-120kdb_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx90a-104/miopenkernels-gfx90a-104_1.1.0.50103-66_amd64.deb
pool/main/m/miopenkernels-gfx90a-110/miopenkernels-gfx90a-110_1.1.0.50103-66_amd64.deb
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
