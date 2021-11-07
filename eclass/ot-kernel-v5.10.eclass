# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.10.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.10.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.10 eclass defines specific applicable patching for the 5.10.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.205"
PATCH_ALLOW_O3_COMMIT="228e792a116fd4cce8856ea73f2958ec8a241c0c"
PATCH_BBRV2_TAG_NAME="v2alpha-2021-07-07"
PATCH_BBRV2_COMMIT_A_PARENT="2c85ebc57b3e1817b6ce1a6b703928e113a90442" # 5.10
PATCH_BBRV2_COMMIT_A="c13e23b9782c9a7f4bcc409bfde157e44a080e82" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="3d76056b85feab3aade8007eb560c3451e7d3433" # descendant / newest
PATCH_KCP_COMMIT="986ea2483af3ba52c0e6c9e647c05c753a548fb8"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

CK_COMMITS=(
35f6640868573a07b1291c153021f5d75749c15e
ea9b4218b46eae24eef6162be269934f4bb5dfb6
aa59b50641d91d37ca28bfadbcd5281ff40f148d
e123b4092b42207e6b73373e5d583533e5f81d57
0b9ec366834a7cb054ac486230b52706c5c100bf
2ea8fdb7dc4d79679a7f77e483a8fc54ef5a727f
04468a7eb2c75c6e0bdfdcbe754674c8e50c0c08
6ca339e2a03ab0281cacfe684bd0f1c538f485c5
202d57347034c71c786cd37310a3f4bdb0900744
8a04d624810bc8abe736c704c5f918999b6f95cd
21fef3fefa84f136104c32c150c038dac7ea0edf
8a06fc83fb4698eed8580738d449a05c4604b38f
fa98200feaf4f5e593326b19261bee010e66d533
6ad64c43e446bd13db9758bf254be544461a76cb
0be1591cfd163660fe0fdb850e013e29ba355351
9cdf59bc2dbfb640dbb057757e4101b147275e86
a2fb34e34d157c303d07ee16b1ad42c8720ab320
13f5f8abb25489af1cc019a4a3bc83cced6da67c
)

# Avoid merge conflict or dupes
CK_COMMITS_BL=(
9cdf59bc2dbfb640dbb057757e4101b147275e86
a2fb34e34d157c303d07ee16b1ad42c8720ab320
)

PATCH_ZENSAUCE_COMMITS=(
dda238180bacda4c39f71dd16d754a48da38e676
9a2e0d950bfd77fb51a42a5fc7e81a9187606c38
5b3d9f2372600c3b908b1bd0e8c9b8c6ed351fa2
986ea2483af3ba52c0e6c9e647c05c753a548fb8
228e792a116fd4cce8856ea73f2958ec8a241c0c
b81ab9b618d694217a54b5d2de70c7f37d3f3e07
4ace3c6c50dbd58ee5f200a5461289d0491873a6
0bf1b8c445de4481942ca8ace8dc209ece865bd3
513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3
28eaff69b01d9248cac394cce37361d0d6a52714
973d42f99af15b2e610204fbe8252251ed7cc8c1
890ac858741436a40c274efb3514c5f6a96c7c80
0cbcc41992693254e5e4c7952853c6aa7404f28e
9b6c7af596e209356850e0991969df68f396aea6
b5e9497d44347c16e732f6ea8838a79a64694b36
7e5629d0fc7ed407babc036c1bc7910d9c73dbef
0e9fea26940d7e6e784dcf57909428138b8109e8
fade4cc2bf56ce6c563c04764224b6b84a45587f
b7b24b494b62e02c21a9a349da2d036849f9dd8b
b7b984993f303b89dd738c26f8742cfcf0ac98ea
8cd3f16931b2a05a693bbfc093d44fd504c67700
843f85a8fb80f3b8e4de4ca3c0cab34730cc1b33
5dc3c67b4c2497187c2e4331a4822cb52db9aa65
3f2c3d43bb1330953e090c01f8dfb6a4701bbac4
223b7e095efa96045c164f3bf3576e1d1f599946
2b52b792670d6c1a93d086a10c6872575e849c17
e1b127aa22601f9cb2afa3daad4c69e6a42a89f5
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
dda238180bacda4c39f71dd16d754a48da38e676
"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE="
0cbcc41992693254e5e4c7952853c6aa7404f28e:513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3
"
#ZEN: INTERACTIVE: Use BFQ as our elevator(0cbcc41) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (513af58)

# ancestor / oldest, descendant / newest
PATCH_ZENTUNE_COMMITS=(
890ac858741436a40c274efb3514c5f6a96c7c80
0cbcc41992693254e5e4c7952853c6aa7404f28e
9b6c7af596e209356850e0991969df68f396aea6
b5e9497d44347c16e732f6ea8838a79a64694b36
7e5629d0fc7ed407babc036c1bc7910d9c73dbef
0e9fea26940d7e6e784dcf57909428138b8109e8
fade4cc2bf56ce6c563c04764224b6b84a45587f
b7b24b494b62e02c21a9a349da2d036849f9dd8b
)
PATCH_BFQ_DEFAULT="0cbcc41992693254e5e4c7952853c6aa7404f28e"
PATCH_ZENSAUCE_BL=(
	${PATCH_ZENSAUCE_BRANDING}
	${PATCH_KCP_COMMIT}
)

# Backport from 5.9, updated to 5.10, with zen changes
ZEN_MUQSS_COMMITS=(
9d6b3eef3a1ec22d4d3c74e0b773ff52d3b3a209
3b17bfa60ca1e8d94cb7a4c490dd79a14c53a074
25b07958996a2d2dcff8b54917c01bf01196e68e
c68e24eb9e7ff9cf585ca395a9a95023404ddea4
e52e9340936ec51702e13997519a36279f848b47
f4a3f1a4685f1c2453535dc10c5a4c1cb9d2c37e
cd185b24202c18832ee493cf1e7f3d38cadefb3f
31a1b5cfd19718a53b207ee66850516a97964c9a
cb705098cd4fbc5da1dd898642602d98f265e74c
81170db5534ada1574b366fd7df75080ce5a50de
a809bb5c75fc246f155872631258828a6df3485d
14891c776915dcbabab79d89e9b819114bfa794c
e610927931872d67a868b14bdb6f48d83dd992ed
e219172bbe43aed68943e72b19897191b6bd8f8f
37fa42a7ec254ecbec319f603cd595d6308021ea
4d8602abd84dbc4219e337331f7d8bd7a91ce8c6
aa17b2d1d0c2814b2cdd33e2b1cf171b5ac30b86
9089e95bb3d0e64dc64ae90eb509da5075f49248
16b6c9f2c576d43096a216a802c61573286ae5a7
f52ed229284681b01ba3785a581fefb89cb91d87
5e029bcb673aa73c2a432f5f78f60351821f5b33
2da693aab6562ed337fd383bdd368d65081cb955
76154be76bebec4ef22db220f7e98bc2f7ed940c
abcc55ee0e4b908af47d67d2a594d63862a5e914
780ad761cfe51dfdd178db93be8443355a7597d7
1ee7b1ab0da8b81ad41bf83e795ba80cf1288739
)
ZEN_MUQSS_EXCLUDED_COMMITS=(
)

# For 5.6
# This corresponds to the futex-proton-v3 branch.
# Repo order is bottom oldest and top newest.
FUTEX_COMMITS=( # oldest
dc3e0456bf719cde7ce44e1beb49d4ad0e5f0c71
714afdc15b847a7a33c5206b6e1ddf64697c07d6
ec85ea95a00b490a059bcc817bc1b4660062dba0
00d3ee9cff824d4d38e82d252e4300999f87f1a5
e8d4d6ded8544b5716c66d326aa290db8501518c
) # newest

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 +cfs clang disable_debug futex
+genpatches -genpatches_1510 +kernel-compiler-patch muqss +O3 prjc rt tresor
tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64
tresor_x86_64-256-bit-key-support uksm zen-muqss zen-sauce zen-sauce-all
-zen-tune"
REQUIRED_USE+="
	^^ ( cfs muqss prjc zen-muqss )
	genpatches_1510? ( genpatches )
	O3? ( zen-sauce )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-sauce-all? ( zen-sauce )
	zen-tune? ( zen-sauce )"

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
	prjc? ( !rt )
	zen-muqss? ( !rt )
	rt? ( cfs !muqss !prjc !zen-muqss )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel \
patchset, GraySky2's kernel_compiler_patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" futex? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
gen_kcp_license() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		out+=" kernel-compiler-patch-${a}? ( GPL-2 )"
	done
	echo "${out}"
}
LICENSE+=" "$(gen_kcp_license)
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no defaults license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)
LICENSE+=" zen-muqss? ( GPL-2 )"
LICENSE+=" zen-tune? ( GPL-2 )"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_clang_llvm_pair() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
		)
		     "
	done
}

KCP_RDEPEND="
	clang? ( || ( $(gen_clang_llvm_pair 10 14) ) )
	|| (
		(
			>=sys-devel/gcc-6.5.0
		)
		$(gen_clang_llvm_pair 10 14)
	)
"

KCP_TC0="
	clang? ( || ( $(gen_clang_llvm_pair 10 14) ) )
	|| (
		(
			>=sys-devel/gcc-10.1
		)
		$(gen_clang_llvm_pair 10 14)
	)"

KCP_TC1="
	clang? ( || ( $(gen_clang_llvm_pair 10 14) ) )
	|| (
		(
			>=sys-devel/gcc-10.3
		)
		$(gen_clang_llvm_pair 10 14)
	)"

KCP_TC2="
	clang? ( || ( $(gen_clang_llvm_pair 12 13) ) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_llvm_pair 12 13)
	)"

KCP_MA_RDEPEND="
	kernel-compiler-patch-zen3? ( ${KCP_TC1} )
	kernel-compiler-patch-cooper_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-tiger_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-sapphire_rapids? ( ${KCP_TC2} )
	kernel-compiler-patch-rocket_lake? ( ${KCP_TC2} )
	kernel-compiler-patch-alder_lake? ( ${KCP_TC2} )"

RDEPEND+=" ${KCP_MA_RDEPEND}
	   kernel-compiler-patch? ( ${KCP_RDEPEND} )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

# For CPU microarchitectures >= year 2020, assumes mutually exclusive
# kernel-compiler-patch* USE flag usage
gen_kcp_ma_uri() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		[[ "${a}" =~ cortex-a72 ]] && continue
		out+="
	   kernel-compiler-patch-${a}? (
		${KCP_SRC_9_1_URI}
	   )"
	done
	echo "${out}"
}

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex? ( ${FUTEX_SRC_URIS} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   muqss? ( ${CK_SRC_URIS} )
	   prjc? ( ${PRJC_SRC_URI} )
	   rt? ( ${RT_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-muqss? ( ${ZEN_MUQSS_SRC_URIS} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
ewarn
ewarn "The zen-tune patch might cause lock up or slow io under heavy load like"
ewarn "npm.  These use flags are not recommended."
ewarn
		fi
	fi

	if use tresor ; then
ewarn
ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
ewarn
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_aesni.patch"
	fi

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
		fi
	fi

	if ! use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
		else
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
		fi
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
einfo
einfo "You may require the genkernel 4.x series to build the ${K_MAJOR_MINOR}.x"
einfo "kernel series."
einfo
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	:;
}

# @FUNCTION: ot-kernel_filter_genpatches_blacklist_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_filter_genpatches_blacklist_cb() {
	# remove patches that have been already applied upstream
	echo " 2400"
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
function ot-kernel_filter_patch_cb() {
	local path="${1}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with futex

	if [[ "${path}" =~ "prjc_v5.10-r2.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "${PRJC_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "futex-5.10-e8d4d6d.patch" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPS}" "${FILESDIR}/futex-e8d4d6d-2-hunk-fix-for-5.10.patch"
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
