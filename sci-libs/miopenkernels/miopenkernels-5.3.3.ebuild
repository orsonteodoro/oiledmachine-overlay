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
inherit rocm

SRC_URI=""

DESCRIPTION="Prebuilt kernels to reduce startup latency"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen#installing-miopen-kernels-package"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	net-misc/wget
"
PDEPEND="
	~sci-libs/miopen-${PV}
"
RESTRICT="
"
S="${WORKDIR}"
PATCHES=(
)

# hash of filename : data
# hashing is required for the key because of bug evaluating ~ within single quotes.
declare -A EXPECTED_SHA1=(
["Addb75331c12ce15896c0e9199c3b07b2162f0b9b"]="99b84d57ef332bd0d9ebdbd7e0b87a8371b32e19"
["Aec7b78e4c8389e1a088ff1d56a87514689e03a47"]="cda0e4daafe000d8727da86725a3821ab93582a2"
["A5921040b219da856c6b5c13541f3e9bd683c09fe"]="5a89f9d5097eb36f27d9e8868105dda2ec660d4b"
["A90208f09b170200541b86d933f594ed124d5cd0f"]="73531a1c91cb2bedc6d8595db58eb4e4faf2ebaf"
["Acadaa140690e525ef11a4b0d48e31b0065ca68ee"]="16ce8783bde1000161c842ed77d450c9e5bfce13"
["A7a679c70b695da2936149c3196466cb67fc5f320"]="24137b6f4b838aaddd542309a39a675ab9c6019e"
["A17727fc6891e349fa2f8c54e8a4e8009df2070bf"]="b8eaaab0a1244625eb051d502dcf416f49e3af72"
["A8d64a41657f4cb233356a3985f5502f7909292c8"]="3676a94cb0d5d065048e4cee98e66f08d5ba22c1"
["A84aaeb49adbe38e1a136d3294f179fff8b1b8662"]="9a5796c6c8c33cc64afa9a8ced9e8da778179de5"
["A0d358eef14f4271fb83c02bf4839d16082dc8f71"]="9dc6052598b8a750747d1ed1e5d19761efa72804"
["Ac4380458e9d15e96851a46be6773541cf9ea1089"]="853ef9203c0dd8d2452cff63760142acd3943f1f"
["A7175fb91a957efacd1ea523bffea41d43c11fbf2"]="99ef27fb35f296870694f9784f006af56c0d624a"
["Acadfbd68a422fceb183a9f694e583d29a61eced7"]="d1b0c6c26d151b7875eaa668b73eef93ac9ce3ef"
["Aeddd72756c18bac361911cc8c340a7a7bdb04bde"]="458f7831fa141231f23cb0889733c7a8692da965"
["A3e52492e66e1337b49c93721cac43994b3906690"]="042ba968e810a0a0edd9bfb25c91f410d22ef124"
["A250830df3ccd3c4f388f6ed02a8ab477e7077da3"]="bd35228c51e5f964708f6a7da9355304a38ea252"
) > /dev/null

declare -A EXPECTED_SHA256=(
["Addb75331c12ce15896c0e9199c3b07b2162f0b9b"]="f55f4536c5be4525a23ea3825a17c93641b00bb997c91b1250a3cd2e215c7105"
["Aec7b78e4c8389e1a088ff1d56a87514689e03a47"]="5894ec6221a758dc17a5276cca308d7f041e7687e207aad4e93a04af0dc24db0"
["A5921040b219da856c6b5c13541f3e9bd683c09fe"]="7af30399b5392c46295145a6d774c8c464d4946b280880785d77d0ed79c7f3cd"
["A90208f09b170200541b86d933f594ed124d5cd0f"]="9c5297de2a039c3e72bd822518e87b2d8fc26837edcc4fe9290fb829e8a26516"
["Acadaa140690e525ef11a4b0d48e31b0065ca68ee"]="b03f008148ddd2b5152690f320807e74fd362e5003949326e49d258a3c5b1c24"
["A7a679c70b695da2936149c3196466cb67fc5f320"]="54b58fb96daa01770fc4cf3586d43cff60a7304369f4ca896977caad5b1d0315"
["A17727fc6891e349fa2f8c54e8a4e8009df2070bf"]="ebbc1869cd93ab0584f2525e8bc4d27b47c1ffac35b1f5c3abef6edd9c31ca28"
["A8d64a41657f4cb233356a3985f5502f7909292c8"]="09e817ac256fc1c90ba665f585070182ca493656b25ef7bdb5b1ec1ebf918e6a"
["A84aaeb49adbe38e1a136d3294f179fff8b1b8662"]="abb061e54ca721853df1610dadaf2264faf3f928e0f321849e961c8e48706864"
["A0d358eef14f4271fb83c02bf4839d16082dc8f71"]="91c40668e8a3b56b075497a1b285e8ed821de509213d8dfba39a6ef5f6ec91cc"
["Ac4380458e9d15e96851a46be6773541cf9ea1089"]="85534dab7c0aeb3a855b68c3a9178f64821108bfcf25cea1ff11cb88c9fa39f1"
["A7175fb91a957efacd1ea523bffea41d43c11fbf2"]="e09714c7bf0d74711152513a873e298b82d69267f0205d84143bacb33d24f9b5"
["Acadfbd68a422fceb183a9f694e583d29a61eced7"]="4ea712453ad1c7d318b7eaf2e948c3426090763e5988af8bc6720ea039f9378f"
["Aeddd72756c18bac361911cc8c340a7a7bdb04bde"]="b4ced67afcfc956f05250ce862b28f5433bea491372ffd0c91945a9aec5ccf46"
["A3e52492e66e1337b49c93721cac43994b3906690"]="0971a956d434b9f5434171174bc5c6b19af3567670158f5809c4818c04e3cdf3"
["A250830df3ccd3c4f388f6ed02a8ab477e7077da3"]="91cdd238fe4ba34efded4bc331096ee9e6d26c176a768838894d6d97574d4c2b"
) > /dev/null

declare -A EXPECTED_MD5=(
["Addb75331c12ce15896c0e9199c3b07b2162f0b9b"]="c333f7a984d1d84e2c0d95082ff8c5f7"
["Aec7b78e4c8389e1a088ff1d56a87514689e03a47"]="6675f6710d95e0d7f6758377b2760d43"
["A5921040b219da856c6b5c13541f3e9bd683c09fe"]="ae01b2b6028ec6d9efb681bcda8b2d4f"
["A90208f09b170200541b86d933f594ed124d5cd0f"]="3d5a769d00d2be815398f7f53a384eb7"
["Acadaa140690e525ef11a4b0d48e31b0065ca68ee"]="fb7e8f8c634a77ea76f51cc982c0b599"
["A7a679c70b695da2936149c3196466cb67fc5f320"]="39d71b904e97d5512a578aa23a5a9fc7"
["A17727fc6891e349fa2f8c54e8a4e8009df2070bf"]="b236efad37c1db0d95166cb03588113e"
["A8d64a41657f4cb233356a3985f5502f7909292c8"]="acacadac9a6b8f31b1c6d7fb99ffae88"
["A84aaeb49adbe38e1a136d3294f179fff8b1b8662"]="8f161521a76ca3434aaf4f154d46bc70"
["A0d358eef14f4271fb83c02bf4839d16082dc8f71"]="3a4d626520b408707b66ea89298d0182"
["Ac4380458e9d15e96851a46be6773541cf9ea1089"]="917bcf6f9ce95615285b731932f4c724"
["A7175fb91a957efacd1ea523bffea41d43c11fbf2"]="d1f01f9dd33600417bf2e297342a73e7"
["Acadfbd68a422fceb183a9f694e583d29a61eced7"]="dbc158218d104e8b2f8bd3ec6cb152a6"
["Aeddd72756c18bac361911cc8c340a7a7bdb04bde"]="88f3e7137a68a5272c9a9463da35cc95"
["A3e52492e66e1337b49c93721cac43994b3906690"]="9a04bc46123094c94ecb58f41d085931"
["A250830df3ccd3c4f388f6ed02a8ab477e7077da3"]="e8602ae648e67f51d642b7807d3c781c"
) > /dev/null

declare -A EXPECTED_SIZE=(
["Addb75331c12ce15896c0e9199c3b07b2162f0b9b"]="968"
["Aec7b78e4c8389e1a088ff1d56a87514689e03a47"]="239414010"
["A5921040b219da856c6b5c13541f3e9bd683c09fe"]="290769484"
["A90208f09b170200541b86d933f594ed124d5cd0f"]="315287848"
["Acadaa140690e525ef11a4b0d48e31b0065ca68ee"]="290769510"
["A7a679c70b695da2936149c3196466cb67fc5f320"]="329295376"
["A17727fc6891e349fa2f8c54e8a4e8009df2070bf"]="205802044"
["A8d64a41657f4cb233356a3985f5502f7909292c8"]="308966836"
["A84aaeb49adbe38e1a136d3294f179fff8b1b8662"]="213718190"
["A0d358eef14f4271fb83c02bf4839d16082dc8f71"]="329295398"
["Ac4380458e9d15e96851a46be6773541cf9ea1089"]="272103708"
["A7175fb91a957efacd1ea523bffea41d43c11fbf2"]="308967068"
["Acadfbd68a422fceb183a9f694e583d29a61eced7"]="222472292"
["Aeddd72756c18bac361911cc8c340a7a7bdb04bde"]="782"
["A3e52492e66e1337b49c93721cac43994b3906690"]="337703964"
["A250830df3ccd3c4f388f6ed02a8ab477e7077da3"]="272102808"
) > /dev/null

src_unpack() {
	# obtain from after csplit below:
	local uri_base="http://repo.radeon.com/rocm/apt/${MY_PV}/"
	local files=(
pool/main/m/miopenkernels-gfx1030-36kdb/miopenkernels-gfx1030-36kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx1030-36kdb/miopenkernels-gfx1030-36kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx1030-36kdb5.3.3/miopenkernels-gfx1030-36kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx1030-36kdb5.3.3/miopenkernels-gfx1030-36kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb/miopenkernels-gfx900-56kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb/miopenkernels-gfx900-56kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb5.3.3/miopenkernels-gfx900-56kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-56kdb5.3.3/miopenkernels-gfx900-56kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb/miopenkernels-gfx900-64kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb/miopenkernels-gfx900-64kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb5.3.3/miopenkernels-gfx900-64kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx900-64kdb5.3.3/miopenkernels-gfx900-64kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb/miopenkernels-gfx906-60kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb/miopenkernels-gfx906-60kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb5.3.3/miopenkernels-gfx906-60kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-60kdb5.3.3/miopenkernels-gfx906-60kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb/miopenkernels-gfx906-64kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb/miopenkernels-gfx906-64kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb5.3.3/miopenkernels-gfx906-64kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx906-64kdb5.3.3/miopenkernels-gfx906-64kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb/miopenkernels-gfx908-120kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb/miopenkernels-gfx908-120kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb5.3.3/miopenkernels-gfx908-120kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx908-120kdb5.3.3/miopenkernels-gfx908-120kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-104kdb/miopenkernels-gfx90a-104kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-104kdb/miopenkernels-gfx90a-104kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-104kdb5.3.3/miopenkernels-gfx90a-104kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-104kdb5.3.3/miopenkernels-gfx90a-104kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb/miopenkernels-gfx90a-110kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb/miopenkernels-gfx90a-110kdb_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb5.3.3/miopenkernels-gfx90a-110kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
pool/main/m/miopenkernels-gfx90a-110kdb5.3.3/miopenkernels-gfx90a-110kdb5.3.3_1.1.0.50303-99~20.04_amd64.deb
	)

	if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
		# For hashes
		wget "http://repo.radeon.com/rocm/apt/${MY_PV}/dists/ubuntu/main/binary-amd64/Packages"
		csplit \
			--quiet \
			--prefix=Packages \
			--suffix-format=%02d.txt \
			--suppress-matched \
			Packages /^$/ {*}

		einfo "Update files array with the following:"
		einfo
		grep -i -r -e "miopenkernels.*deb" "${WORKDIR}" | cut -f 2 -d " " | sort
		einfo

		declare -A EXPECTED_SHA1
		declare -A EXPECTED_SHA256
		declare -A EXPECTED_MD5
		declare -A EXPECTED_SIZE
		IFS=$'\n'
		local p
		for p in $(grep -l -r -e "miopenkernels.*deb" "${WORKDIR}" | cut -f 2 -d " " | sort) ; do
			local bn=$(basename $(grep "Filename:" "${p}" | cut -f 2 -d " "))
			[[ -z "${bn}" ]] && continue
			local bnsan="A"$(echo "${bn}" | sha1sum | cut -f 1 -d " ")
			local expected_sha1=$(grep "SHA1:" "${p}" | cut -f 2 -d " ")
			local expected_sha256=$(grep "SHA256:" "${p}" | cut -f 2 -d " ")
			local expected_md5=$(grep "MD5sum:" "${p}" | cut -f 2 -d " ")
			local expected_size=$(grep "^Size:" "${p}" | cut -f 2 -d " ")
			EXPECTED_SHA1["${bnsan}"]="${expected_sha1}"
			EXPECTED_SHA256["${bnsan}"]="${expected_sha256}"
			EXPECTED_MD5["${bnsan}"]="${expected_md5}"
			EXPECTED_SIZE["${bnsan}"]="${expected_size}"
		done
		IFS=$' \n\r\t'

		einfo "Update arrays:"
		echo
		declare -p EXPECTED_SHA1 | sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" | fold -w 120 -s
		echo
		declare -p EXPECTED_SHA256 | sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" | fold -w 180 -s
		echo
		declare -p EXPECTED_MD5 | sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" | fold -w 120 -s
		echo
		declare -p EXPECTED_SIZE | sed -e "s|\[|[\"|g" -e "s|\]|\"]|g" | fold -w 80 -s
		echo

		die
	fi

	export EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${EDISTDIR}" || die
	local x
	for x in ${AMDGPU_TARGETS_OVERRIDE[@]} ; do
		for y in ${files[@]} ; do
			if use "amdgpu_targets_${x}" && [[ "${y}" =~ "${x}" ]] ; then
	# Do it this way via wget instead of SRC_RUI because the files are too large.
				addwrite "${EDISTDIR}"
				wget -c "${uri_base}/${y}"
				local bn=$(basename "${y}")
				local bnsan="A"$(echo "${bn}" | sha1sum | cut -f 1 -d " ")
				local actual_sha1=$(sha1sum $(basename "${y}"))
				local actual_sha256=$(sha256sum $(basename "${y}"))
				local actual_md5=$(md5sum $(basename "${y}"))
				local actual_size=$(stat -c "%s" $(basename "${y}"))
eerror "Checking file integrity for ${EDISTDIR}/${bn}"
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
				pushd "${WOKRDIR}" || die
					unpack ${bn}
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
