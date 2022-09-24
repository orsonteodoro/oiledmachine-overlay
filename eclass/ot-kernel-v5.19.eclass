# Copyright 2020-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.19.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 5.19.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.19 eclass defines specific applicable patching for the 5.19.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

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
PATCH_ALLOW_O3_COMMIT="b53feb0ba5a8f3af0795778120a38bce6676179b" # from zen repo
PATCH_BBRV2_TAG_NAME="v2alpha-2022-08-28"
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant / newest
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # descendant / newest
PATCH_KCP_COMMIT="674f779ce9e9b4b93f861468f5d3a638267f6f5a" # from zen repo
PATCH_MULTIGEN_LRU_COMMIT_A_PARENT="3d7cb6b04c3f3115719235cc6866b10326de34cd"
PATCH_MULTIGEN_LRU_COMMIT_A="861d18e1ce54266b132e05c725ba77dca4919c81" # ancestor / oldest
PATCH_MULTIGEN_LRU_COMMIT_D="1b71e31ea45f98d3f6fde67aed0a5099a14df90f" # descendant / newest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A_PARENT="3d7cb6b04c3f3115719235cc6866b10326de34cd"
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A="861d18e1ce54266b132e05c725ba77dca4919c81" # ancestor / oldest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_D="30103469083c3ef182a4f0db3b768b17a52ed608" # descendant / newest
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

PATCH_ZENSAUCE_COMMITS=(
127f953caa6bd1b249d91834b4840f57e2a7f66a
ab4134b722a69906d6c4696a0432718595fbe4ce
3a0d1deee7f40bb928881194d997b86edcb24daf
49b3e6eb92f2b018c66c448cc5d9e7cb07534f26
774445eb458cdc09be79b4ecee895e8f32ec2d21
674f779ce9e9b4b93f861468f5d3a638267f6f5a
b53feb0ba5a8f3af0795778120a38bce6676179b
a81f660b8875ee6e966d4694e1f2f46246ab0f55
c98d28e47137a04b4bf4173661b47fce6769a5d2
e5f6fc62d082284ac2061538fb8ea0488eb77080
39be9e8f0c0a53848678060cc74c6b81023efc0b
dd63a67369ab0b4ecc6b666d425b0614b409a42e
d3b1ac2f7317ea5381ae71c5f1a30c996931c676
679d1e45b09a172c485dd1094bbaf73aaf3673da
aa06f7e656988ec9d077d97c29984719acfc4bfe
fa73866c097357c51cb180543845110a39836d1a
46bef561e0cee7991386f1d5e72541468e332b1f
5c7fba5ede0afe8ef3d0915a0af960014cf1b324
8245681577cf994601c0a8fffe2c8fc9bdcd6382
33a7b49740c01b2ebf0aab11ee13299aa51635d0
1eaea61dd05e0b796d5bf80e6bdb86c5ffbaa142
b11de298281c0c76d2fe9d5076f312ad86aad2e7
8f67e06392cdd51d859a73029d23c6237299a4d2
6b3b0b14f2ad7db5db9c53de4fb342053e3c34d0
a7bd9688ba40ff5e2ce0b6619c34ee5431ba6d99
2547356a4c4bbd7037316d4a55d4205de88842ba
92f865edd9ce7d7f78f4f6afabf8ff4f63338c49
9cc0f5315b5f312f91de0645b6a944e24cb5848d
0da8625949ccf3b2d8b5633fbce842c6b5897fe3
b650361b8a30212c6dc247de1e2dd1b17a7eddde
50b4e74fa21b1f90a0af037aa1b4978c4fe17a8e
12920d76b655317a7e9858b44dcf4c57859228e1
824434cfe2bb769de0a01be78695a3e858fa0acb
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
127f953caa6bd1b249d91834b4840f57e2a7f66a
"

# Fixme
# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
)

# Message marked with INTERACTIVE:
PATCH_ZENTUNE_COMMITS=(
8245681577cf994601c0a8fffe2c8fc9bdcd6382
33a7b49740c01b2ebf0aab11ee13299aa51635d0
1eaea61dd05e0b796d5bf80e6bdb86c5ffbaa142
b11de298281c0c76d2fe9d5076f312ad86aad2e7
8f67e06392cdd51d859a73029d23c6237299a4d2
6b3b0b14f2ad7db5db9c53de4fb342053e3c34d0
a7bd9688ba40ff5e2ce0b6619c34ee5431ba6d99
2547356a4c4bbd7037316d4a55d4205de88842ba
92f865edd9ce7d7f78f4f6afabf8ff4f63338c49
9cc0f5315b5f312f91de0645b6a944e24cb5848d
0da8625949ccf3b2d8b5633fbce842c6b5897fe3

)
PATCH_BFQ_DEFAULT="33a7b49740c01b2ebf0aab11ee13299aa51635d0"
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

KCFI_COMMITS=(
eca242caae05e8f3a1f4e644bb83daf231aa5ed6
56df88e87a6450edc97aab0437baf89308703e9c
934bd5587f75a48f40d7f39e77c4d15ae5562fa1
77945f477d4ce51912cb0c9d7896a1b44841349d
55fcaf04f5537c8bd16fb3ddaaaf0f6ed9e84e4e
7770ba93f2b3d357f893b724dd4b4a22602c2fe5
25e9c5321d1df30d5687f36baca617f98475a25d
ea60f1a4fd52c7f50f520d3d056d7febe0ed6537
7872f5d4b6c7cb6ebf31cf60723d974bfa096028
dcce350b94263083709980e3f2726059ecf9ed9c
f0b22c73dd1805db73f07254d819667a2bbb7711
405adeeffb0e5eef2484e634b7e580221f226734
e2586fed6e8289024c7b60592f77c3221d97dc38
24e9e127c863044594a3db9217f691667482035e
1fd151fa27fb584010ece70ab700e2aed5d7d7aa
1fccf484a9b2f8c4570c70e08ccd688495a5f1a3
61a2ce2fbbbf0c0132dcbc304fa45179a3bd0e1e
5a525a34e47c20f5f23d54acb9a0a83733343b97
d110d35c0953ead5f529f0447d5075eaf85e1d49
4e0e0ceb2e21c9a3b71380e3e7cfd8ce8d028f15
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

IUSE+=" build symlink"
IUSE+=" bbrv2 cfi +cfs clang disable_debug
+genpatches -genpatches_1510 kcfi lto multigen_lru prjc rt
shadowcallstack tresor tresor_aesni tresor_i686 tresor_prompt tresor_sysfs
tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-multigen_lru zen-sauce
zen-sauce-all -zen-tune"
IUSE+=" clang-pgo"
IUSE+=" -exfat"

# Not ready yet
REQUIRED_USE+="
	!uksm
"

REQUIRED_USE+="
	genpatches_1510? ( genpatches )
	kcfi? ( !cfi !shadowcallstack )
	cfi? ( !kcfi )
	multigen_lru? ( !zen-multigen_lru )
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

DESCRIPTION="A customizable kernel package with
BBRv2,
CFI,
CVE fixes,
genpatches,
kernel_compiler_patch,
multigen_lru,
Project C (BMQ, PDS-mq),
RT_PREEMPT (-rt),
zen-multigen_lru,
zen-sauce,
zen-tune."

# Not ready yet
#UKSM, \

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" clang-pgo? ( GPL-2 )"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfi? ( GPL-2 )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" kcfi? ( GPL-2 )"
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" multigen_lru? ( GPL-2 )"
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

gen_kcfi_rdepend() {
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

# KCFI requires https://reviews.llvm.org/D119296 patch
RDEPEND+=" kcfi? (
		arm64? (
			|| ( $(gen_kcfi_rdepend 15 ${LLVM_MAX_SLOT}) )
		)
		amd64? (
			|| ( $(gen_kcfi_rdepend 15 ${LLVM_MAX_SLOT}) )
		)
	)
"

RDEPEND+=" clang-pgo? (
		|| ( $(gen_clang_pgo_rdepend 13 ${LLVM_MAX_SLOT}) )
		sys-kernel/genkernel[clang-pgo]
	   )
"
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
	clang? ( || ( $(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT}) ) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
	)
"
RDEPEND+=" ${KCP_RDEPEND}"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}
"
fi

# Not on the servers yet
NOT_READY_YET="
"

SRC_URI+="
	${KCP_SRC_4_9_URI}
	${KCP_SRC_8_1_URI}
	${KCP_SRC_9_1_URI}
	${KCP_SRC_CORTEX_A72_URI}
	bbrv2? ( ${BBRV2_SRC_URIS} )
	cfi? ( amd64? ( ${CFI_SRC_URIS} ) )
	clang-pgo? ( ${CLANG_PGO_URI} )
	genpatches? (
		${GENPATCHES_URI}
	)
	kcfi? ( amd64? ( ${KCFI_SRC_URIS} ) )
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
	zen-sauce? ( ${ZENSAUCE_URIS} )
"

# Not ready yet
#	   uksm? ( ${UKSM_SRC_URI} )

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	if use bbrv2 ; then
ewarn
ewarn "Fixes to forward port bbrv2 is WIP (Work In Progress)"
ewarn "Expect failure"
ewarn
	fi
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
	if has zen-tune ${IUSE} ; then
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

	if use kcfi ; then
ewarn
ewarn "KCFI is still under code review and considered experimental."
ewarn
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

	elif [[ "${path}" =~ "kernel-locking-Use-a-pointer-in-ww_mutex_trylock.patch" ]] ; then
		: # already applied

	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.19-50b614c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-50b614c-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.19-41ceaf5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-41ceaf5-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.19-3ff0ac8.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-3ff0ac8-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2021-08-21-5.19-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"

	elif [[ "${path}" =~ "kcfi-5.19-eca242c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/kcfi-eca242c-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "kcfi-5.19-934bd55.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/kcfi-934bd55-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "kcfi-5.19-55fcaf0.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/kcfi-55fcaf0-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "kcfi-5.19-1fd151f.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/kcfi-1fd151f-fix-for-5.19.10.patch"

	elif [[ "${path}" =~ "cfi-5.19-8dfd451.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-8dfd451-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-5.19-f5bff50.patch" ]] ; then
		# f5bff50 is the same as 7fb10a9
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-7fb10a9-rebase-for-5.18.patch"
	elif [[ "${path}" =~ "cfi-5.19-bd6966b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-bd6966b-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-5.19-3cb32c4.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-3cb32c4-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-5.19-e921a27.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 8 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-e921a27-fix-for-5.19.10.patch"
		# Skipped paravirt_types.h, paravirt.c changes with missing paravirt_iret
	elif [[ "${path}" =~ "cfi-5.19-a09066b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-a09066b-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-5.19-aa4fb87.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 7 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-aa4fb87-fix-for-5.15.69.patch"
#	elif [[ "${path}" =~ "cfi-5.19-5140d56.patch" ]] ; then
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"
#
#		# Add this to the end of the cfi commit list
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"
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
