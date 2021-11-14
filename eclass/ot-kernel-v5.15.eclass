# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.15.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.15.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.15 eclass defines specific applicable patching for the 5.15.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="40fecdec8599c28fc9d1003c301d2202e39db8a6"
PATCH_BBRV2_TAG_NAME="v2alpha-2021-08-21"
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="1a45fd4faf30229a3d3116de7bfe9d2f933d3562" # descendant / newest
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # descendant / newest
PATCH_KCP_COMMIT="ff1381103099207c61c0e8426e82eabbb2808b04"
PATCH_LRU_GEN_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_LRU_GEN_COMMIT_A="f48857ddf21f86a716a88b6278851c0066fbf66f" # ancestor / oldest
PATCH_LRU_GEN_COMMIT_D="c43874ec588df89dfe285e1fa978c9f3f9b7e570" # descendant / newest
PATCH_ZEN_LRU_GEN_COMMIT_A_PARENT="7d2a07b769330c34b4deabeed939325c77a7ec2f"
PATCH_ZEN_LRU_GEN_COMMIT_A="f48857ddf21f86a716a88b6278851c0066fbf66f" # ancestor / oldest
PATCH_ZEN_LRU_GEN_COMMIT_D="99e7c83f97caf5a659eadcd6d547d68ae648ab0d" # descendant / newest
# Corresponding to [5.15-rc1, x86-cfi-v3]
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

PATCH_ZENSAUCE_COMMITS=(
7607cbe5890545c3d4a2c5598cfb0eb9255ab46a
dcc1c5d635f155c7a9458cd93827899211224486
aa864eded832387e4ace9652ca2edbeb8155d703
ff1381103099207c61c0e8426e82eabbb2808b04
b67c5033547771052515687e96adf98858ea0de6
e5a3bbcb4908996f6034817704297979cbf2dc07
4398d18270d5391b13d108a79b8ec235e0ffa10a
fb7fb66f2c1f923dc039d99125ed94d54435bb9f
05447263701b202e0086bb2cae098cf6d46c158e
10a037e3ae47516141287fb489fb7ea0ae18fc0a
f1030c5bd8cd8f67cef664c0b6b9841afbc49363
e6e6ceba3e07be085b0249d7fc03e795d58dc577
bd79567171b5faa0394ebdfcf46394864b60479f
0d865e68797b90a0de0123adcbe8c77c4ea4ae22
57a46dc390017363b2db52e70f4b07c9a71f76c6
00e58bccf05365ce65f6e9694e1ca3b9ad30f345
de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac
3045edebf785deb5d687abd9898ac9702be5325c
7bfc78d87614496288ad4e90f7d749a942a83718
be5ba234ca0a5aabe74bfc7e1f636f085bd3823c
09955b8fd454ae284590fc4c9f47e7c96f3bad51
16b72839cb862810bbf976e223f85ff4d1959ebd
96c43bfad5c8dcb116ab2088e46228707aaeca9f
ce769e35208203536d176326e72560548848b5ff
35b5b825073000f04477651683c4aa11b98d12c8
c793cc79debeafd0d1cee613dfc99d64c2cbcc94
4218499052f1010e8b466db363b0ce4857756299
81ba2917231b206b7b6b9b160e456c5452c4f62e
e350f22a04b707a15d6af29d6d5a97e86445eacc
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
7607cbe5890545c3d4a2c5598cfb0eb9255ab46a
"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac:05447263701b202e0086bb2cae098cf6d46c158e
)
#ZEN: INTERACTIVE: Use BFQ as our elevator (c6d1cd) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (39376e2)
# fixup! ZEN: INTERACTIVE: Increase max number of tasks rebalanced at once (1cef339) needs
# ZEN: Reduce up threshold for all non-muqss schedulers (5ad20a8)

# Message marked with INTERACTIVE:
PATCH_ZENTUNE_COMMITS=(
7607cbe5890545c3d4a2c5598cfb0eb9255ab46a
de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac
3045edebf785deb5d687abd9898ac9702be5325c
7bfc78d87614496288ad4e90f7d749a942a83718
be5ba234ca0a5aabe74bfc7e1f636f085bd3823c
09955b8fd454ae284590fc4c9f47e7c96f3bad51
16b72839cb862810bbf976e223f85ff4d1959ebd
96c43bfad5c8dcb116ab2088e46228707aaeca9f
)
PATCH_BFQ_DEFAULT="de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac"
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
	^^ ( cfs prjc zen-muqss )
	futex-proton? ( futex )
	genpatches_1510? ( genpatches )
	O3? ( zen-sauce )
	lru_gen? ( !zen-lru_gen )
	prjc? ( !rt )
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
	!lru_gen
	!uksm
	!zen-lru_gen
	!zen-muqss
	prjc? ( !rt )
	zen-muqss? ( !rt )
	rt? ( cfs !prjc !zen-muqss )
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
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-lru_gen? ( ${ZEN_LRU_GEN_SRC_URI} )
	   zen-muqss? ( ${ZEN_MUQSS_SRC_URIS} )
"

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   cfi? ( amd64? ( ${CFI_X86_SRC_URIS} ) )
	   clang-pgo? ( ${CLANG_PGO_URI} )
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
	   lru_gen? ( ${LRU_GEN_SRC_URI} )
	   prjc? ( ${PRJC_SRC_URI} )
	   rt? ( ${RT_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
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
