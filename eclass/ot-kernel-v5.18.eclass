# Copyright 2020-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.18.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.18.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.18 eclass defines specific applicable patching for the 5.18.x
# linux kernel.

CXX_STD="-std=gnu++11"
GCC_MAX_SLOT=13
GCC_MIN_SLOT=6
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=10
DISABLE_DEBUG_V="1.4.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
PATCH_ALLOW_O3_COMMIT="9f2a43f24a978e33f6cbbf6a9e9fef2b8b434278" # from zen repo
PATCH_BBRV2_TAG_NAME="v2alpha-2021-08-21"
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="1a45fd4faf30229a3d3116de7bfe9d2f933d3562" # descendant / newest
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # descendant / newest
PATCH_KCP_COMMIT="21d0707cf05cabf4df165f8e65b95ae8cfd473a5" # from zen repo
PATCH_MULTIGEN_LRU_COMMIT_A_PARENT="4b0986a3613c92f4ec1bdc7f60ec66fea135991f"
PATCH_MULTIGEN_LRU_COMMIT_A="2382afbecfe3806bdd7c8062e33c4f1fca77e8d8" # ancestor / oldest
PATCH_MULTIGEN_LRU_COMMIT_D="400d2d9622c0b7bea7079d64d77236bd5c8174b0" # descendant / newest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A_PARENT="4b0986a3613c92f4ec1bdc7f60ec66fea135991f"
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A="2382afbecfe3806bdd7c8062e33c4f1fca77e8d8" # ancestor / oldest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_D="6f1ecc2810b66850ee15266d1223a4c26434a0cc" # descendant / newest
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

PATCH_ZENSAUCE_COMMITS=(
4f7b3eec44a54d8d18594cf4f83cd714e9bdab60
87a80e231779a2bd7df07de71e520eedfad911f7
dba00166b172c07e207cb8489ca0b4d6c9017746
21d0707cf05cabf4df165f8e65b95ae8cfd473a5
9f2a43f24a978e33f6cbbf6a9e9fef2b8b434278
a5bfcc1ec76bb25fd33354766c19ab09eb78c06e
d5933d5eed4f892b0ffedb84c92beac6662c8adc
68ab7aed71734a0bcf859bb4e5c940b80663ac31
90ada3c9b3619edbf8baf13735a6ade5468a8557
7e0e26dd9d8967fd08ed64f3b87899e5bcb50466
38340ce3e7354f61213653ffd78fc7ab3f924f9d
105a4e9780e6cc204abc2d0a6e77b5436b5bf05d
f70b127df5ec259064b84fa42fe323c72b914823
bc968c130425528fba6d2372d6433d9db0998a5f
cf71bd32dc443c2bc6512f1d630edf251c6d2f65
7816ca3920e05b0973e242b8d8168a61b5f95dd5
bf7ba01972771466d28c411d99ed0931e25728ef
4eb5a0e7624644ea27b2f34d9ada5f82cc977f20
e9fdb59fd84f30601fcf1ad9767144281abefe60
98f47fb21a241c726c515539d2071787f1af9fc5
1ddedc551af44f312f493eed0347077c23dd6afc
d64f442da0142ba83a7c4c214245c6f2f3c4b0a3
6a23e14830cbf72f2cd5b3614780473abf3562fe
c515e5a47e968c51390e0ce3ca9bc2c970dc1baf
2351e39547f11e15ea1f4288f1ff13495102ac28
0752dcbbc5076205c12d19c3735d70fad9773ba0
2ccae2ed2e9ae055950412f4254becd2b020d00d
1be7d9f22c113fda29716fa4c2110ff4f80f5e90
8f51fb6ecfdf0ee39643d9b9c95a0204a03d3a94
0f72f7556637e7b1da2c040ab29116f0ceea10c0
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
4f7b3eec44a54d8d18594cf4f83cd714e9bdab60
"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
1ddedc551af44f312f493eed0347077c23dd6afc:7e0e26dd9d8967fd08ed64f3b87899e5bcb50466
) # \
#ZEN: INTERACTIVE: Use BFQ as our elevator (1ddedc5) needs \
#ZEN: Add CONFIG to rename the mq-deadline scheduler (7e0e26d)

# Message marked with INTERACTIVE:
PATCH_ZENTUNE_COMMITS=(
98f47fb21a241c726c515539d2071787f1af9fc5
1ddedc551af44f312f493eed0347077c23dd6afc
d64f442da0142ba83a7c4c214245c6f2f3c4b0a3
6a23e14830cbf72f2cd5b3614780473abf3562fe
c515e5a47e968c51390e0ce3ca9bc2c970dc1baf
2351e39547f11e15ea1f4288f1ff13495102ac28
0752dcbbc5076205c12d19c3735d70fad9773ba0
2ccae2ed2e9ae055950412f4254becd2b020d00d
1be7d9f22c113fda29716fa4c2110ff4f80f5e90
)
PATCH_BFQ_DEFAULT="1ddedc551af44f312f493eed0347077c23dd6afc"
PATCH_ZENSAUCE_BL=(
	${PATCH_ZENSAUCE_BRANDING}
	${PATCH_KCP_COMMIT}
)

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

# Have to pull and apply one-by-one because of already applied commits
# Corresponding to [5.15, cfi-5.15]
CFI_COMMITS=(
8dfd451f45dbb26f049083248bf80463a71bc5fd
f5bff50472d56909b1cce5463d120a996a34b004
ceb2e9c1636efe86ce835a78fd6783ab89e8f976
bd6966b9d8eedce598371b3bfdbe0e03cee497a7
4ae0924a08505cb9edd119d9eaadd03a80b65590
8eda1c26606e71618cc99a6efa1680d287dfc4f7
d879decba121257f1a120d10f277d8a382f96995
3cb32c428616aa260553eb4c68b2a4f87971ae92
e921a2782b9bb64b29516e186a9d841319f2a71c
ca65ed990fe39aa0aa92ec3262208a41e6c1edf9
227509670d08484176020753d998581e56ee496c
5eef9c1387806fd8672d002432ef2a7fbde3c332
c982d8b1bbcebb610f664841764cb1dbaed6c938
6e7d1b0c4b9134f065ddad6db8325b4eeeae319b
a09066b2a6f436ea4b8acc25dce279d5ecd3811d
aa4fb87a71a95bef81d9742a772d1dc8eb4fceea
)

CFI_EXCLUDE_COMMITS=(
)

BBR2_VERSION="v2alpha-2021-08-21"
BBR2_COMMITS=( # oldest
1ca5498fa4c6d4d8d634b1245d41f1427482824f
#46ddceed8f8dad02a97e79c40893c385b859d1c8 # already applied
#94af063d5a381af0e2063cfd97dcce9783ed25c6 # already applied
2bab755134b19856f11a2f693f4bc40f864b00f2
50b614c0a65125d5c22fca6605fdcf88e0a9258a
41ceaf5611bf5b9384e3f2aec5b591d5734126f9
0511a3cf52a609f30c1f3f4ebb5924ddce7daca1
16ac0c6cb9ecb89e4815cfedf15d7bfd456f5ae4
7636a4ccf0f51e69a1e37bff97851dff0d344919
e46c8a0354f91d6e0d5c20f812212ddc39f0a550
1e924b1343bfa67d78ab3293c63e6cff8062dc48
73f8adbd5afbe316ed091b073c5ec2efea8b8b36
602b949a1c191599c6243a7bef62e5f6dcbc7553
3ff0ac8e14d8b260ba04a980fc62fabbf61db1aa
5ab6f739f03ff9bd533c43e7c7e0fa904b84236f
c6ef88ba01cc47ac4c6a2cfe51e15eaa4d833476
51b6837ecb1ab7d4dacdcc0be92e56ba7b99fbb8
f1097cdeb6d4b2413bbd4cf6fb824993c0808e5a
a20075fb0483240680164d7117bb48eb14c4d221
cf413174f0934b09b6537a7bec41690c4ee3a52d
6f7df9135aed2181681cc57c4dd167efed4052be
e707a7fbb949daa7214c597ebdb56dbb89466853
e77879755ff930875d0747fa5c7d94923d248a22
41b842efcd2a6b70b94068d106c1cff19f88a416
0e156e93538efa4c03b60f763ceb23bdbd6e52bc
d29d596279f9ce7a33c7cc68277886e49381ea05
1a45fd4faf30229a3d3116de7bfe9d2f933d3562
) # newest

HAVE_CLANG_PGO=1
KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" build symlink"
IUSE+=" ${KCP_IUSE} bbrv2 cfi +cfs clang disable_debug
+genpatches -genpatches_1510 +kernel-compiler-patch lto multigen_lru +O3 prjc rt
shadowcallstack tresor tresor_aesni tresor_i686 tresor_prompt tresor_sysfs
tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-multigen_lru zen-sauce
zen-sauce-all -zen-tune"
IUSE+=" clang-pgo"
IUSE+=" -exfat"

# Not ready yet
REQUIRED_USE+="
	!uksm
	!cfi
"

REQUIRED_USE+="
	genpatches_1510? ( genpatches )
	multigen_lru? ( !zen-multigen_lru )
	O3? ( zen-sauce )
	shadowcallstack? ( cfi )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_prompt? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-multigen_lru? ( !multigen_lru )
	zen-sauce-all? ( zen-sauce )
	zen-tune? ( zen-sauce )"

EXCLUDE_SCS=( alpha amd64 arm hppa ia64 mips ppc ppc64 riscv s390 sparc x86 )
gen_scs_exclusion() {
	local a
        for a in ${EXCLUDE_SCS[@]} ; do
                echo " ${a}? ( !shadowcallstack )"
	done
}
REQUIRED_USE+=" "$(gen_scs_exclusion)

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizable kernel package with \
BBRv2, \
CFI, \
CVE fixes, \
genpatches, \
kernel_compiler_patch, \
multigen_lru, \
Project C (BMQ, PDS-mq), \
RT_PREEMPT (-rt), \
zen-multigen_lru, \
zen-sauce, \
zen-tune."

# Not ready yet
#UKSM, \

inherit ot-kernel

LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" clang-pgo? ( GPL-2 )"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
gen_kcp_license() {
	local out=""
	local a
	for a in ${KCP_MA[@]} ; do
		out+=" kernel-compiler-patch-${a}? ( GPL-2 )"
	done
	echo "${out}"
}
LICENSE+=" "$(gen_kcp_license)
LICENSE+=" multigen_lru? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no defaults license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)
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
			|| ( $(gen_cfi_rdepend 12 ${LLVM_MAX_SLOT}) )
		)
		amd64? (
			|| ( $(gen_cfi_rdepend 13 ${LLVM_MAX_SLOT}) )
		)
	)
"
RDEPEND+=" clang-pgo? (
		|| ( $(gen_clang_pgo_rdepend 13 ${LLVM_MAX_SLOT}) )
		sys-kernel/genkernel[clang-pgo]
	   )"
RDEPEND+=" lto? ( || ( $(gen_lto_rdepend 11 ${LLVM_MAX_SLOT}) ) )"
RDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_rdepend 10 ${LLVM_MAX_SLOT}) ) ) )"

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
	clang? ( || ( $(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT}) ) )
	|| (
		(
			>=sys-devel/gcc-9.0
		)
		$(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT})
	)
"

KCP_TC0="
	clang? ( || ( $(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT}) ) )
	|| (
		(
			>=sys-devel/gcc-10.1
		)
		$(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT})
	)"

KCP_TC1="
	clang? ( || ( $(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT}) ) )
	|| (
		(
			>=sys-devel/gcc-10.3
		)
		$(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT})
	)"

KCP_TC2="
	clang? ( || ( $(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT}) ) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
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
	:
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

# For CPU microarchitectures >= year 2020, assumes mutually exclusive
# kernel-compiler-patch* USE flag usage
gen_kcp_ma_uri() {
	local out=""
	local a
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
"

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URIS} )
	   cfi? ( amd64? ( ${CFI_SRC_URIS} ) )
	   clang-pgo? ( ${CLANG_PGO_URI} )
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
	   multigen_lru? ( ${MULTIGEN_LRU_SRC_URI} )
	   prjc? ( ${PRJC_SRC_URI} )
	   rt? ( ${RT_SRC_ALT_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   zen-multigen_lru? ( ${ZEN_MULTIGEN_LRU_SRC_URI} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

# Not ready yet
#	   uksm? ( ${UKSM_SRC_URI} )

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	if use tresor ; then
		if [[ -n "${OT_KERNEL_DEVELOPER}" && "${OT_KERNEL_DEVELOPER}" == "1" ]] ; then
			:
		else
ewarn
# Need to fix linking problem
ewarn "TRESOR for ${K_MAJOR_MINOR} is in development."
ewarn
ewarn "Please migrate your data outside the XTS(tresor) partition(s) into a different"
ewarn "partition.  Keep the commit frozen, or checkout kept rewinded to commit"
ewarn "20a1c90 before the XTS(tresor) key changes to backup and restore from"
ewarn "it. Checkout repo as HEAD when you have migrated the data are ready to"
ewarn "use the updated XTS(tresor) with setkey changes.  This new XTS setkey"
ewarn "change will not be backwards compatible."
ewarn
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

	# Allow for multiple builds for different kernel configs (e.g. server, gaming-client etc),
	# but it is really needed to isolate the -rt build.
	if [[ -z "${OT_KERNEL_BUILDCONFIGS_5_16}" ]] ; then
		OT_KERNEL_BUILDCONFIGS_5_16_="ot:build:/etc/kernels/kernel-config-${K_MAJOR_MINOR}-ot-$(uname -m):$(uname -m):${CHOST}:cfs:manual"
		if use rt ; then
			# Split for security reasons
			OT_KERNEL_BUILDCONFIGS_5_16_="${OT_KERNEL_BUILDCONFIGS_5_16_};rt:build:/etc/kernels/kernel-config-${K_MAJOR_MINOR}-rt-$(uname -m):$(uname -m):${CHOST}:cfs:manual"
		fi
	else
		export OT_KERNEL_BUILDCONFIGS_5_16_="${OT_KERNEL_BUILDCONFIGS_5_16}"
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPTS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPTS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.15-v4_i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.15-v4_aesni.patch"
	fi

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
		fi
	fi

	if ! ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
		else
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
		fi
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi

	# tresor-xts-setkey update applied in these below
	if ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-removed-i686-256-v1.patch"
		fi
	else
		if ot-kernel_use tresor_aesni ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-removed-aesni-v1.patch"
		elif ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-removed-i686-128-v1.patch"
		fi
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
einfo
einfo "You may require the genkernel 4.x series to build the ${K_MAJOR_MINOR}.x"
einfo "kernel series."
einfo
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
	:
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
ot-kernel_filter_patch_cb() {
	local path="${1}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${path}"
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"
	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
		einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
		einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/cfi-x86-3bc6889-makefile-fix-for-5.15.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/clang-pgo-support-profraw-v6-to-v8.patch"
	elif [[ "${path}" =~ "cfi-x86-5.14-5140d56.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"

		# Add this to the end of the cfi commit list
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"
	elif [[ "${path}" =~ "cfi-5.17-a09066b.patch" ]] ; then
		# 343e289 is the same as a09066b
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-343e289-fix-for-5.15.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.18-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"
	elif [[ "${path}" =~ "cfi-x86-5.17-fb19148.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "kernel-locking-Use-a-pointer-in-ww_mutex_trylock.patch" ]] ; then
		: # already applied
	elif [[ "${path}" =~ "cfi-5.18-f5bff50.patch" ]] ; then
		# f5bff50 is the same as 7fb10a9
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-7fb10a9-rebase-for-5.18.patch"
	elif [[ "${path}" =~ "cfi-5.17-e921a27.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "cfi-5.17-aa4fb87.patch" ]] ; then
		: # Skip for now since missing EXPORT_SYMBOL*
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.18-50b614c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-50b614c-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.18-41ceaf5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-41ceaf5-fix-for-5.17.patch"
	elif [[ "${path}" =~ "cfi-5.18-bd6966b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-bd6966b-fix-for-5.18.patch"
	elif [[ "${path}" =~ "cfi-5.18-3cb32c4.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-3cb32c4-fix-for-5.18.patch"
	else
		_dpatch "${PATCH_OPTS}" "${path}"
	fi
}

# @FUNCTION: ot-kernel_filter_clang_pgo_patch_cb
# @DESCRIPTION:
# Apply and fix to the Clang PGO patch
ot-kernel_filter_clang_pgo_patch_cb() {
	local path="${1}"
	_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
	_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-3bc6889-a15058e-fixes-for-5.17.patch"
}
