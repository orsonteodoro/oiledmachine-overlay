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
PATCH_CK_COMMIT_B="13f5f8abb25489af1cc019a4a3bc83cced6da67c" # bottom / newest
PATCH_CK_COMMIT_T="35f6640868573a07b1291c153021f5d75749c15e" # top / oldest
PATCH_FUTEX_COMMIT_B="f678870308608b485d1c771509208c93eab8538a" # bottom / newest
PATCH_FUTEX_COMMIT_T="9fd101849c8a3324c6038ef31fe08a528f7a6fe4" # top / oldest
PATCH_FUTEX2_COMMIT_B="65d8ec592b14a8c75ce2a04bfef5a188cd279d00" # bottom / newest
PATCH_FUTEX2_COMMIT_T="4f6d01d9753e7ff0e6ca0ab6082f8b75256cdb57" # top / oldest
PATCH_BBRV2_COMMIT_B="00ac5e0aceb8f6d56065072ddc71b7324bbb48ce" # bottom / newest
PATCH_BBRV2_COMMIT_T="c13e23b9782c9a7f4bcc409bfde157e44a080e82" # top / oldest
PATCH_KCP_COMMIT="986ea2483af3ba52c0e6c9e647c05c753a548fb8"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# where Y is top and X is bottom
PATCH_ZENSAUCE_COMMITS=\
"dda238180bacda4c39f71dd16d754a48da38e676 \
9a2e0d950bfd77fb51a42a5fc7e81a9187606c38 \
5b3d9f2372600c3b908b1bd0e8c9b8c6ed351fa2 \
986ea2483af3ba52c0e6c9e647c05c753a548fb8 \
228e792a116fd4cce8856ea73f2958ec8a241c0c \
b81ab9b618d694217a54b5d2de70c7f37d3f3e07 \
4ace3c6c50dbd58ee5f200a5461289d0491873a6 \
0bf1b8c445de4481942ca8ace8dc209ece865bd3 \
513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3 \
28eaff69b01d9248cac394cce37361d0d6a52714 \
973d42f99af15b2e610204fbe8252251ed7cc8c1 \
890ac858741436a40c274efb3514c5f6a96c7c80 \
0cbcc41992693254e5e4c7952853c6aa7404f28e \
9b6c7af596e209356850e0991969df68f396aea6 \
b5e9497d44347c16e732f6ea8838a79a64694b36 \
7e5629d0fc7ed407babc036c1bc7910d9c73dbef \
0e9fea26940d7e6e784dcf57909428138b8109e8 \
fade4cc2bf56ce6c563c04764224b6b84a45587f \
b7b24b494b62e02c21a9a349da2d036849f9dd8b \
b7b984993f303b89dd738c26f8742cfcf0ac98ea \
8cd3f16931b2a05a693bbfc093d44fd504c67700 \
843f85a8fb80f3b8e4de4ca3c0cab34730cc1b33 \
5dc3c67b4c2497187c2e4331a4822cb52db9aa65 \
3f2c3d43bb1330953e090c01f8dfb6a4701bbac4 \
223b7e095efa96045c164f3bf3576e1d1f599946 \
2b52b792670d6c1a93d086a10c6872575e849c17 \
e1b127aa22601f9cb2afa3daad4c69e6a42a89f5"

#--

# Disabled 0cbcc41992693254e5e4c7952853c6aa7404f28e : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show throughput performance degration with SSD with BFQ.

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE="
0cbcc41992693254e5e4c7952853c6aa7404f28e:513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3
"
#ZEN: INTERACTIVE: Use BFQ as our elevator(0cbcc41) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (513af58)

# top / oldest, bottom / newest
PATCH_ZENTUNE_COMMITS=\
"890ac858741436a40c274efb3514c5f6a96c7c80 \
9b6c7af596e209356850e0991969df68f396aea6 \
b5e9497d44347c16e732f6ea8838a79a64694b36 \
7e5629d0fc7ed407babc036c1bc7910d9c73dbef \
0e9fea26940d7e6e784dcf57909428138b8109e8 \
fade4cc2bf56ce6c563c04764224b6b84a45587f \
b7b24b494b62e02c21a9a349da2d036849f9dd8b"
PATCH_BFQ_DEFAULT="0cbcc41992693254e5e4c7952853c6aa7404f28e"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_BFQ_DEFAULT}
	${PATCH_KCP_COMMIT}
"

# ZEN interactive MuQSS patches
# top is oldest, bottom is newest
PATCH_ZENTUNE_MUQSS_COMMITS=\
"4d8602abd84dbc4219e337331f7d8bd7a91ce8c6 \
aa17b2d1d0c2814b2cdd33e2b1cf171b5ac30b86 \
9089e95bb3d0e64dc64ae90eb509da5075f49248 \
16b6c9f2c576d43096a216a802c61573286ae5a7"

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 +cfs clang disable_debug futex-wait-multiple futex2
+genpatches +kernel-compiler-patch muqss +O3 prjc rt tresor tresor_aesni
tresor_i686 tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support uksm
zen-sauce -zen-tune zen-tune-muqss"
REQUIRED_USE+="
	^^ ( cfs muqss prjc )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-tune? ( zen-sauce )
	zen-tune-muqss? ( muqss zen-tune )"

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
	prjc? ( !rt )
	rt? ( cfs !muqss !prjc )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel \
patchset, GraySky2's kernel_compiler_patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" bbrv2? ( GPL-2 )" # tcp_bbr2.c is Dual BSD/GPL but other parts are based on licensing of original file
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" futex2? ( GPL-2 Linux-syscall-note GPL-2+ )" # same as original file
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
LICENSE+=" zen-tune? ( GPL-2 )"
LICENSE+=" zen-tune-muqss? ( GPL-2 )"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_clang_gcc_pair() {
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
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-6.5.0
		)
		$(gen_clang_gcc_pair 10 14)
	)
"

KCP_TC0="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC1="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10.3
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC2="
	clang? ( $(gen_clang_gcc_pair 12 13) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_gcc_pair 12 13)
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
		${KCP_SRC_9_0_URI}
	   )"
	done
	echo "${out}"
}

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_0_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   muqss? ( ${CK_SRC_URI} )
	   O3? ( ${O3_ALLOW_SRC_URI} )
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
	   zen-sauce? ( ${ZENSAUCE_URIS} )
	   zen-tune-muqss? ( ${ZENTUNE_MUQSS_URIS} )"

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
	elif [[ "${path}" =~ "${CK_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-dont-attach-ckversion.patch"
	elif [[ "${path}" =~ "${PRJC_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
