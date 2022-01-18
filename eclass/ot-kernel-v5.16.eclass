# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.16.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.16.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.16 eclass defines specific applicable patching for the 5.16.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="3831287bf9e0e2302c8a6e95dfbe5e23d642ed51"
PATCH_BBRV2_TAG_NAME="v2alpha-2021-08-21"
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="1a45fd4faf30229a3d3116de7bfe9d2f933d3562" # descendant / newest
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # descendant / newest
PATCH_KCP_COMMIT="26ccc379bd67b59063e73f96642ba8f401b312bc"
PATCH_LRU_GEN_COMMIT_A_PARENT="df0cc57e057f18e44dac8e6c18aba47ab53202f9"
PATCH_LRU_GEN_COMMIT_A="53ef88ecd9b684c40f1427827a86ad3b03daccf0" # ancestor / oldest
PATCH_LRU_GEN_COMMIT_D="2be4e051f9381b6e7dd3270fb519fc9a638a5398" # descendant / newest
PATCH_ZEN_LRU_GEN_COMMIT_A_PARENT="df0cc57e057f18e44dac8e6c18aba47ab53202f9"
PATCH_ZEN_LRU_GEN_COMMIT_A="53ef88ecd9b684c40f1427827a86ad3b03daccf0" # ancestor / oldest
PATCH_ZEN_LRU_GEN_COMMIT_D="0696726eaf6d68ec2d0d5c30ca7bc50e9b71a2c5" # descendant / newest
# Corresponding to [5.15-rc1, x86-cfi-v3]
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

PATCH_ZENSAUCE_COMMITS=(
df189d7b3d6def4d3456528433dea747953125f0
c5a351434d9c28a38ca821bd4908046b6cf51954
8444e1dc1a5996f3a19a1b14b3a6620cb9cf68b5
26ccc379bd67b59063e73f96642ba8f401b312bc
3831287bf9e0e2302c8a6e95dfbe5e23d642ed51
299017e5e185d75245864ec89c053cd26cf8af68
7848ab3f52e0e77054806a1abdb3b1c9ba010adb
c113c2451fbe897b3a6b1ab75799dbcb1f873415
c3f87f928013ec084aa99cb9ddcc514dc4af0cf1
50b43196a404f4bf21fd1347c7800db5329ddbe5
613d2ac998443ffdea7aa79d7177e6e6efa04c00
9a03abf64b186e30be7244e90a3548707bcf5122
9a85929c5d21b030134dc243f60ebaa617afed20
5a57b88b7dd651b2e37febf06b868d60720e8a5f
000ad68c8d9a196dde2bb9da65b653fc4c4c69a4
46d4fa35d24255d6c6a4abcf78e0dc62bd963b08
d7406fe7e75e1fe31e6b16474fb76f99e2c5926c
401c6704aa18f98cdb1de026b64ae936fbdefcf3
5f7f9f73b386527ef178bf9a68d8f84f8d9692f2
b05e3d9b7f3594ddaa7d67be798d7acfe09f9e1c
73f721b513d15cb68dd36f56bf35c49164f926f8
157e1814f25ab399070c421a96cdbf657f66a097
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
df189d7b3d6def4d3456528433dea747953125f0
"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
46d4fa35d24255d6c6a4abcf78e0dc62bd963b08:c3f87f928013ec084aa99cb9ddcc514dc4af0cf1
)
#ZEN: INTERACTIVE: Use BFQ as our elevator (c6d1cd) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (39376e2)
# fixup! ZEN: INTERACTIVE: Increase max number of tasks rebalanced at once (1cef339) needs
# ZEN: Reduce up threshold for all non-muqss schedulers (5ad20a8)

# Message marked with INTERACTIVE:
PATCH_ZENTUNE_COMMITS=(
000ad68c8d9a196dde2bb9da65b653fc4c4c69a4
46d4fa35d24255d6c6a4abcf78e0dc62bd963b08
d7406fe7e75e1fe31e6b16474fb76f99e2c5926c
401c6704aa18f98cdb1de026b64ae936fbdefcf3
5f7f9f73b386527ef178bf9a68d8f84f8d9692f2
b05e3d9b7f3594ddaa7d67be798d7acfe09f9e1c
73f721b513d15cb68dd36f56bf35c49164f926f8
)
PATCH_BFQ_DEFAULT="46d4fa35d24255d6c6a4abcf78e0dc62bd963b08"
PATCH_ZENSAUCE_BL=(
	${PATCH_ZENSAUCE_BRANDING}
	${PATCH_KCP_COMMIT}
)

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

# From 5.12, forwardported to 5.13
# not present
ZEN_MUQSS_COMMITS=(
)
ZEN_MUQSS_EXCLUDED_COMMITS=(
)

# Have to pull and apply one-by-one because of already applied commits
CFI_X86_COMMITS=(
1d7789c770ab3efc373250423e01e03889de1b39
7fb10a9f0f9a8d8edf03f74af5ab02d570e997c2
857e4865f1cede7d5c3f2a0992e01e3a66f21289
b04cc291daa34371e4ec7c1f3333730c255f23ee
a730ee8477502d71cfaec0feed69cff70e02951d
5e1147e7a4a29eb51707142b688ceca9125c96c1
ab111b4a1d0df58200ec43ec48a04693a8604be0
4259f7b1eda915b477e4aa3d54c86574f256343c
fb191486eb8126b7f6aed0c5daad7c519f204e65
7f62bb10e676dc80c0392afff66b489b871556e5
68dad239efa204790b8f381af2d09d96a6148f59
ff6a17bfb0455ed92e8aead7422e6dcc0aeff2db
2aba9b859e6c6c4acaba3c31b5594ae59ca272fe
a7e53b07af8df54620788b3b290660f8b1cbd2fa
343e2895647f40a338010aeb13da7d142271446d
)

CFI_EXCLUDE_COMMITS=(
)

# For 5.13
# This corresponds to the tonyk/futex_waitv branch.
# Repo order is bottom oldest and top newest.
# Used for fsync in proton
FUTEX_WAIT_MULTIPLE_OPTCODE31=( # oldest
b70e738f08403950aa3053c36b98c6b0eeb0eb90
) # newest

FUTEX_PROTON_COMPAT=(
${FUTEX_WAIT_MULTIPLE_OPTCODE31[@]}
)

# The futex2-dev commits with fwm opcode31 commits codepaths follow as if futex_wait_multiple not futex2.

# Corresponding to futex2-dev branch
# for 5.15-rc1
FUTEX_COMMITS=( # oldest
6f9eb8a836b2620327c0d4ded960673dbd761179
b6382cdf6ec279fe61e9242a6a89d6146c870404
f5c1ee46eeb68a59e3a6781959d0d1c25f40f5df
4f9c741df0a35f9bbfb6f2fea653ecd3e583d663
2b0c72de17e96323ea9c71610364a1b44e0f10dc
8067fd6dc22722b36915718603cb4dd513d64962
b88c926ac58eee428e37663e7ba8061af2528c06
d810c70ed7b8228349af3c277f8c3cc0d5fa0f7b
${FUTEX_PROTON_COMPAT[@]}
) # newest

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 cfi +cfs clang disable_debug futex futex-proton
+genpatches -genpatches_1510 +kernel-compiler-patch lru_gen lto
+O3 prjc rt shadowcallstack tresor tresor_aesni tresor_i686 tresor_sysfs
tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-lru_gen zen-muqss
zen-sauce zen-sauce-all -zen-tune"
IUSE+=" clang-pgo"
REQUIRED_USE+="
	!prjc
	^^ ( cfs prjc zen-muqss )
	futex-proton? ( futex )
	genpatches_1510? ( genpatches )
	O3? ( zen-sauce )
	lru_gen? ( !zen-lru_gen )
	prjc? ( !rt )
	rt? ( cfs !prjc !zen-muqss )
	shadowcallstack? ( cfi )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-lru_gen? ( !lru_gen )
	zen-sauce-all? ( zen-sauce )
	zen-tune? ( zen-sauce )"

EXCLUDE_SCS=( alpha amd64 arm hppa ia64 mips ppc ppc64 riscv s390 sparc x86 )
gen_scs_exclusion() {
        for a in ${EXCLUDE_SCS[@]} ; do
                echo " ${a}? ( !shadowcallstack )"
	done
}
REQUIRED_USE+=" "$(gen_scs_exclusion)

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	!uksm
	!zen-muqss
	zen-muqss? ( !rt )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel \
patchset, GraySky2's kernel_compiler_patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" clang-pgo? ( GPL-2 )"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" futex? ( GPL-2 Linux-syscall-note GPL-2+ )" # same as original file
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
LICENSE+=" lru_gen? ( GPL-2 )"
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

gen_cfi_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
		)
		     "
	done
}

gen_shadowcallstack_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
		)
		     "
	done
}

gen_lto_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*
			>=sys-devel/lld-${v}
		)
		"
	done
}

gen_clang_pgo_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*
		)
		"
	done
}

RDEPEND+=" cfi? (
		arm64? (
			|| ( $(gen_cfi_rdepend 12 14) )
		)
		amd64? (
			|| ( $(gen_cfi_rdepend 13 14) )
		)
	)
"
RDEPEND+=" clang-pgo? (
		|| ( $(gen_clang_pgo_rdepend 13 14) )
		sys-kernel/genkernel[clang-pgo]
	   )"
RDEPEND+=" lto? ( || ( $(gen_lto_rdepend 11 14) ) )"
RDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_rdepend 10 14) ) ) )"

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
			>=sys-devel/gcc-9.0
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
	clang? ( || ( $(gen_clang_llvm_pair 12 14) ) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_llvm_pair 12 14)
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

# Not on the servers yet
NOT_READY_YET="
	   prjc? ( ${PRJC_SRC_URI} )
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-muqss? ( ${ZEN_MUQSS_SRC_URIS} )
"

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   cfi? ( amd64? ( ${CFI_X86_SRC_URIS} ) )
	   clang-pgo? ( ${CLANG_PGO_URI} )
	   futex? ( ${FUTEX_SRC_URIS} )
	   genpatches? (
		${GENPATCHES_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   lru_gen? ( ${LRU_GEN_SRC_URI} )
	   rt? ( ${RT_SRC_ALT_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   zen-lru_gen? ( ${ZEN_LRU_GEN_SRC_URI} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	if use tresor ; then
		if [[ -n "${OT_KERNEL_DEVELOPER}" && "${OT_KERNEL_DEVELOPER}" == "1" ]] ; then
			:;
		else
eerror
eerror "Building for TRESOR is currently broken for ${PV}.  Use the older LTS"
eerror "branches instead.  Disable the tresor USE flag for this series to"
eerror "continue."
eerror
			die
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
ewarn
ewarn "The zen-tune patch might cause lock up or slow io under heavy load"
ewarn "like npm.  These use flags are not recommended."
ewarn
		fi
	fi

#	if use tresor ; then
#ewarn
#ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
#ewarn
#	fi

	if ! use arm64 && use shadowcallstack ; then
ewarn
ewarn "ShadowCallStack is only offered on the arm64 platform."
ewarn
	fi

	if use cfi && use amd64 ; then
ewarn
ewarn "The CFI patch for x86-64 is in development and originally for the"
ewarn "5.15 series."
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

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
function ot-kernel_filter_patch_cb() {
	local path="${1}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"
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
	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/cfi-x86-3bc6889-makefile-fix-for-5.15.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/clang-pgo-support-profraw-v6-to-v8.patch"
	elif [[ "${path}" =~ "cfi-x86-5.14-5140d56.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"

		# Add this to the end of the cfi commit list
		_dpatch "${PATCH_OPS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"
	elif [[ "${path}" =~ "bbrv2-5.15-1ca5498-1a45fd4.patch" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 10 0 "" # actually only 1 failed not 10
		_dpatch "${PATCH_OPS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"
	elif [[ "${path}" =~ "cfi-x86-5.15-343e289.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/cfi-x86-343e289-fix-for-5.15.patch"
	elif [[ "${path}" =~ "futex-5.15-b70e738.patch" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPS}" "${FILESDIR}/futex-b70e738-2-hunk-fix-for-5.15.patch"
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
