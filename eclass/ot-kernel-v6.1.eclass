# Copyright 2020-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v6.1.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 6.1.x kernel
# @DESCRIPTION:
# The ot-kernel-v6.1 eclass defines specific applicable patching for the 6.1.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v6.1/Documentation/process/changes.rst
# For compiler versions, see
# https://github.com/torvalds/linux/blob/v6.1/scripts/min-tool-version.sh#L26

KERNEL_RELEASE_DATE="20221211"
CXX_STD="-std=gnu++11"
GCC_MAX_SLOT=13
GCC_MIN_SLOT=6
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=11
DISABLE_DEBUG_PV="1.4.1"
EXTRAVERSION="-ot"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KV_MAJOR=$(ver_cut 1 "${PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${PV}")
PATCH_ALLOW_O3_COMMIT="58c80177a3c7a80258336faf346acecdc411dbde" # from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor / oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant / newest
CLANG_PGO_KV="5.13.0_rc2"
PATCH_CLANG_PGO_COMMIT_A_PARENT="fca41af18e10318e4de090db47d9fa7169e1bf2f"
PATCH_CLANG_PGO_COMMIT_A="3bc68891829b776b9a5dd9174de05e69138af7b6" # oldest exclusive
PATCH_CLANG_PGO_COMMIT_D="a15058eaefffc37c31326b59fa08b267b2def603" # descendant / newest
PATCH_KCP_COMMIT="b88b54d2df7b41ba362df4bf6df7c69536b5bda0" # from zen repo
PATCH_MULTIGEN_LRU_COMMIT_A_PARENT=""
PATCH_MULTIGEN_LRU_COMMIT_A="" # ancestor / oldest
PATCH_MULTIGEN_LRU_COMMIT_D="" # descendant / newest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A_PARENT=""
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A="" # ancestor / oldest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_D="" # descendant / newest
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it may miss some commits, so verify all
# the commits in order.

#C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020

ZEN_KV="6.1.0"
PATCH_ZENSAUCE_COMMITS=(
f884ec1baec395379fcb427bbc2b3231ba9484a2
ecf47767080ed4ab1e5d1c2dc0eec0518e713a45
de09ca82f5200498edf14e6680891b846d05ef14
0a22064e3f5b73d00cda9ec55258a8c8158cd88f
8f951cdf30840ae40705506386ecd43453ad3d29
b88b54d2df7b41ba362df4bf6df7c69536b5bda0
7042e70222c4f9205194f5d296bc3272c0537eee
e09ddbe1a0c863359ba6e053d9f7d7fc5242bcec
5e066b1a1d6719a7c43585e3c5a408fcdf065c77
379cbab18b5c75c622b93e2c5abdfac141fe9654
e95c82e24dee2dac9f50593b51c9709cd7654f53
534e7cc98412c28aa0115f4dfe36734f3d50c754
7052cfb177a2ffcc2a8066e9f722f40c80f28259
817b89f071edfda3fbe87c1dd1e78be848ca593d
167602079fa211e9db4cb2c5921382d335d65eb9
6eda5d78611dc65d486531aa798c330d0ea63e52
2aafb56f20e4b63d8c4af172fe9d017c64bc4129
f22bc56be85e69c71c8e36041193856bb8b01525
6951c44a6cacf4c9f12eede7508db7b26b6f3682
c7a4c6f6e1f0cd6c9100187412d76e8efe718ade
90ca7255bd687a9a0219a668adb102c88eeec68e
0a2e457e582589da38236e04d7d757f80d0d7e1a
80592adcd16ec3d96569c908ede9656f5756da4e
8fcf775844a6cf76b27cdfba74d311228b520708
01489237173dca73e1bf532d1d6835b21112bb6e
2e4db1e69cbb271db43b989d08eed8c6747dc83a
9b6162cc8d2bde3ec029fe84cd12ada9c56732f9
ca8da81b6ec94851525b11076b1a12852ad04c6e
c02deac299a473f66b7de625038d69e2aad555c4
d4e6f69ec4407163efcfd23e0dac5f9571b6ade1
810361c77f4dd8dfb3c95fd998d120075122f171
9381f7633208cb517fee827051afc6a7c1decd3d
)

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
f884ec1baec395379fcb427bbc2b3231ba9484a2
"

# Fixme
# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
)

# Message marked with INTERACTIVE:
PATCH_ZENTUNE_COMMITS=(
6951c44a6cacf4c9f12eede7508db7b26b6f3682
c7a4c6f6e1f0cd6c9100187412d76e8efe718ade
90ca7255bd687a9a0219a668adb102c88eeec68e
0a2e457e582589da38236e04d7d757f80d0d7e1a
80592adcd16ec3d96569c908ede9656f5756da4e
8fcf775844a6cf76b27cdfba74d311228b520708
01489237173dca73e1bf532d1d6835b21112bb6e
2e4db1e69cbb271db43b989d08eed8c6747dc83a
9b6162cc8d2bde3ec029fe84cd12ada9c56732f9
ca8da81b6ec94851525b11076b1a12852ad04c6e
c02deac299a473f66b7de625038d69e2aad555c4
d4e6f69ec4407163efcfd23e0dac5f9571b6ade1
810361c77f4dd8dfb3c95fd998d120075122f171
)
PATCH_BFQ_DEFAULT="c7a4c6f6e1f0cd6c9100187412d76e8efe718ade" # SQ
PATCH_KYBER_DEFAULT="90ca7255bd687a9a0219a668adb102c88eeec68e" # MQ
PATCH_ZENSAUCE_BL=(
	${PATCH_KCP_COMMIT}
	${PATCH_ZENSAUCE_BRANDING}
)

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

# Have to pull and apply one-by-one because of already applied commits
# Corresponding to [5.15, cfi-5.15]
CFI_KV="5.15.0"
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

# KCFI merged in 6.1

BBRV2_KV="5.13.12"
BBRV2_VERSION="v2alpha-2022-08-28"
BBRV2_COMMITS=( # oldest
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
cf9b1dacabb1ef62481a452f7f169e1679e2da49
a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361
) # newest
RUST_PV="1.62.0"

IUSE+="
bbrv2 build c2tcp cfi +cfs clang clang-pgo deepcc disable_debug -exfat
+genpatches -genpatches_1510 kcfi lto multigen_lru orca prjc rock-dkms rt -rust
shadowcallstack symlink tresor tresor_aesni tresor_i686 tresor_prompt
tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support uksm
zen-multigen_lru zen-sauce zen-sauce-all -zen-tune
"

# Not ready yet
REQUIRED_USE+="
	!cfi
	!uksm
	!multigen_lru
	!zen-multigen_lru
"

REQUIRED_USE+="
	cfi? (
		!kcfi
	)
	genpatches_1510? (
		genpatches
	)
	kcfi? (
		!cfi
		!shadowcallstack
	)
	multigen_lru? (
		!zen-multigen_lru
	)
	shadowcallstack? (
		cfi
	)
	tresor? (
		^^ (
			tresor_aesni
			tresor_i686
			tresor_x86_64
		)
	)
	tresor_aesni? (
		tresor
	)
	tresor_i686? (
		tresor
	)
	tresor_prompt? (
		tresor
	)
	tresor_sysfs? (
		|| (
			tresor_aesni
			tresor_i686
			tresor_x86_64
		)
	)
	tresor_x86_64? (
		tresor
	)
	tresor_x86_64-256-bit-key-support? (
		tresor
		tresor_x86_64
	)
	zen-multigen_lru? (
		!multigen_lru
	)
	zen-sauce-all? (
		zen-sauce
	)
	zen-tune? (
		zen-sauce
	)
"

EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	ia64
	mips
	ppc
	ppc64
	riscv
	s390
	sparc
	x86
)
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

DESCRIPTION="\
A customizable kernel package with \
BBRv2, \
C2TCP, \
CFI, \
CVE fixes, \
DeepCC, \
genpatches, \
kernel_compiler_patch, \
multigen_lru, \
Orca, \
Project C (BMQ, PDS-mq), \
RT_PREEMPT (-rt), \
zen-multigen_lru, \
zen-sauce, \
zen-tune. \
"

# Not ready yet
#UKSM, \

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" c2tcp? ( MIT )"
LICENSE+=" clang-pgo? ( GPL-2 )"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfi? ( GPL-2 )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" kcfi? ( GPL-2 )"
LICENSE+=" prjc? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" multigen_lru? ( GPL-2 )"
LICENSE+=" orca? ( MIT )"
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
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*[compiler-rt,sanitize]
			=sys-libs/compiler-rt-${s}*:=
			=sys-libs/compiler-rt-sanitizers-${s}*:=[cfi]
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_kcfi_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_shadowcallstack_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*[compiler-rt,sanitize]
			=sys-libs/compiler-rt-${s}*:=
			=sys-libs/compiler-rt-sanitizers-${s}*:=[shadowcallstack?]
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_lto_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_clang_pgo_rdepend() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			=sys-devel/clang-runtime-${s}*
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

gen_clang_llvm_pair() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

KCP_RDEPEND="
	clang? (
		|| (
			$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
		)
	)
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
	)
"

CDEPEND+="
	>=app-shells/bash-4.2
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.23
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=sys-devel/make-3.82
	app-arch/cpio
	dev-util/pkgconf
	sys-apps/grep[pcre]
	virtual/libelf
	virtual/pkgconfig
	bzip2? (
		app-arch/bzip2
	)
	gtk? (
		dev-libs/glib:2
		gnome-base/libglade:2.0
		x11-libs/gtk+:2
	)
	gzip? (
		>=sys-apps/kmod-13[zlib]
		app-arch/gzip
	)
	lz4? (
		app-arch/lz4
	)
	lzma? (
		app-arch/xz-utils
	)
	lzo? (
		app-arch/lzop
	)
	ncurses? (
		sys-libs/ncurses
	)
	openssl? (
		>=dev-libs/openssl-1.0.0
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	rust? (
		>=dev-util/cbindgen-0.56.0
		~virtual/rust-${RUST_PV}
	)
	xz? (
		app-arch/xz-utils
		sys-apps/kmod[lzma]
	)
	zstd? (
		app-arch/zstd
		sys-apps/kmod[zstd]
	)
"

RDEPEND+="
	!build? (
		${CDEPEND}
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
"

DEPEND+="
	${RDEPEND}
"

BDEPEND+="
	build? (
		${CDEPEND}
	)
"

# KCFI requires https://reviews.llvm.org/D119296 patch
RDEPEND+="
	${KCP_RDEPEND}
	cfi? (
		amd64? (
			|| (
				$(gen_cfi_rdepend 13 ${LLVM_MAX_SLOT})
			)
		)
		arm64? (
			|| (
				$(gen_cfi_rdepend 12 ${LLVM_MAX_SLOT})
			)
		)
	)
	clang-pgo? (
		sys-kernel/genkernel[clang-pgo]
		|| (
			$(gen_clang_pgo_rdepend 13 ${LLVM_MAX_SLOT})
		)
	)
	lto? (
		|| (
			$(gen_lto_rdepend 11 ${LLVM_MAX_SLOT})
		)
	)
	kcfi? (
		arm64? (
			|| (
				$(gen_kcfi_rdepend 15 ${LLVM_MAX_SLOT})
			)
		)
		amd64? (
			|| (
				$(gen_kcfi_rdepend 15 ${LLVM_MAX_SLOT})
			)
		)
	)
	s390? (
		|| (
			$(gen_clang_pgo_rdepend 15 ${LLVM_MAX_SLOT})
		)
	)
	shadowcallstack? (
		arm64? (
			|| (
				$(gen_shadowcallstack_rdepend 10 ${LLVM_MAX_SLOT})
			)
		)
	)
"

PDEPEND+="
	rock-dkms? (
		|| (
			~sys-kernel/rock-dkms-5.6.0
		)
	)
"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:
else
	KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
	SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}
	"
fi

# Not on the servers yet
NOT_READY_YET="
"

if [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI_DISABLED="
		${MULTIGEN_LRU_SRC_URI}
		${ZEN_MULTIGEN_LRU_SRC_URI}
	"
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${C2TCP_URIS}
		${CFI_SRC_URIS}
		${CLANG_PGO_URI}
		${GENPATCHES_URI}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		${PRJC_SRC_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${ZENSAUCE_URIS}
	"
else
	SRC_URI_DISABLED="
		multigen_lru? (
			${MULTIGEN_LRU_SRC_URI}
		)
		zen-multigen_lru? (
			${ZEN_MULTIGEN_LRU_SRC_URI}
		)
	"
	SRC_URI+="
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		bbrv2? (
			${BBRV2_SRC_URIS}
		)
		c2tcp? (
			${C2TCP_URIS}
		)
		cfi? (
			amd64? (
				${CFI_SRC_URIS}
			)
		)
		clang-pgo? (
			${CLANG_PGO_URI}
		)
		deepcc? (
			${C2TCP_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		orca? (
			${C2TCP_URIS}
		)
		prjc? (
			${PRJC_SRC_URI}
		)
		rt? (
			${RT_SRC_ALT_URI}
		)
		tresor? (
			${TRESOR_AESNI_SRC_URI}
			${TRESOR_I686_SRC_URI}
			${TRESOR_README_SRC_URI}
			${TRESOR_RESEARCH_PDF_SRC_URI}
			${TRESOR_SYSFS_SRC_URI}
		)
		zen-sauce? (
			${ZENSAUCE_URIS}
		)
	"
fi

# Not ready yet
#		   uksm? ( ${UKSM_SRC_URI} )

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
ewarn "TRESOR for ${KV_MAJOR_MINOR} is in development."
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
einfo "You may require the genkernel 4.x series to build the ${KV_MAJOR_MINOR}.x"
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
# The purpose of this function is to apply hunk fixes, resolve merge conflicts,
# or mispatches.
#
# Typical patch patterns:
#
# 1. Apply original patch with _tpatch, then apply a patch to fix hunks with
#    _dpatch.  [_tpatch is patch with no die.  _dpatch is patch with die on
#    fail.]
# 2. Replace the original patch with a completely updated patch.
# 3. Copy the original patch then slightly modify and apply the patch.
#    (Modifications may fix the path changes between minor versions.)
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
		&& ver_test $(ver_cut 1-3 "${PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
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

	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-50b614c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-50b614c-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-41ceaf5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-41ceaf5-fix-for-5.17.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-3ff0ac8.patch" ]] ; then
		# Dropped hunk from net/ipv4/bpf_tcp_ca.c
		_tpatch "${PATCH_OPTS}" "${path}" 3 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-3ff0ac8-fix-for-6.0.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"

	elif [[ "${path}" =~ "cfi-${CFI_KV}-8dfd451.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-8dfd451-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-f5bff50.patch" ]] ; then
		# f5bff50 is the same as 7fb10a9
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-7fb10a9-rebase-for-5.18.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-bd6966b.patch" ]] ; then
eerror
eerror "Please use the kcfi USE flag instead."
eerror "Still investigating alternative CFI patch."
eerror
eerror "See cfi-${CFI_KV}-bd6966b.patch"
eerror
		die
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-bd6966b-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-3cb32c4.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-3cb32c4-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-e921a27.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 8 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-e921a27-fix-for-5.19.10.patch"
		# Skipped paravirt_types.h, paravirt.c changes with missing paravirt_iret
	elif [[ "${path}" =~ "cfi-${CFI_KV}-a09066b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-a09066b-fix-for-5.19.10.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-aa4fb87.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 7 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-aa4fb87-fix-for-5.15.69.patch"
#	elif [[ "${path}" =~ "cfi-${CFI_KV}-5140d56.patch" ]] ; then
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"
#
#		# Add this to the end of the cfi commit list
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"

	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-cf9b1da.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 5 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cf9b1da-fix-for-6.1.patch"
	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
# Patch needs fix
einfo "See ${path}"
		die
		_tpatch "${PATCH_OPTS}" "${path}" 10 0 ""
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

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "dev-util/pahole" "1.16" "CONFIG_DEBUG_INFO_BTF"
	_ot-kernel_check_versions "net-dialup/ppp" "2.4.0" "CONFIG_PPP"
	_ot-kernel_check_versions "net-firewall/iptables" "1.4.2" "CONFIG_NETFILTER"
	_ot-kernel_check_versions "net-fs/nfs-utils" "1.0.5" "NFS_FS"
	_ot-kernel_check_versions "sys-apps/pcmciautils" "004" "CONFIG_PCMCIA"
	_ot-kernel_check_versions "sys-boot/grub" "0.93" ""
	_ot-kernel_check_versions "sys-fs/btrfs-progs" "0.18" "CONFIG_BTRFS_FS"
	_ot-kernel_check_versions "sys-fs/e2fsprogs" "1.41.4" "CONFIG_EXT2_FS"
	_ot-kernel_check_versions "sys-fs/jfsutils" "1.1.3" "CONFIG_JFS_FS"
	_ot-kernel_check_versions "sys-fs/reiserfsprogs" "3.6.3" "CONFIG_REISERFS_FS"
	_ot-kernel_check_versions "sys-fs/squashfs-tools" "4.0" "CONFIG_SQUASHFS"
	_ot-kernel_check_versions "sys-fs/quota" "3.09" "CONFIG_QUOTA"
	_ot-kernel_check_versions "sys-fs/xfsprogs" "2.6.0" "CONFIG_XFS_FS"
	_ot-kernel_check_versions "sys-process/procps" "3.2.0" ""
	_ot-kernel_check_versions "virtual/udev" "081" ""
}
