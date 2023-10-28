# Copyright 2020-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.15.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 5.15.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.15 eclass defines specific applicable patching for the 5.15.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v5.15/Documentation/process/changes.rst

# PV is for 9999 (live) context check
MY_PV="${PV}" # ver_test context
UPSTREAM_PV="${MY_PV/_/-}" # file context
KERNEL_RELEASE_DATE="20211031" # of first stable release
CXX_STD="-std=gnu++11" # See https://github.com/torvalds/linux/blob/v5.15/tools/build/feature/Makefile#L318
GCC_MAX_SLOT=13
GCC_MIN_SLOT=6
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=10
CLANG_PGO_SUPPORTED=1
DISABLE_DEBUG_PV="1.4.1"
EXTRAVERSION="-ot"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KV_MAJOR=$(ver_cut 1 "${MY_PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${MY_PV}")
PATCH_ALLOW_O3_COMMIT="b67c5033547771052515687e96adf98858ea0de6" # from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor ~ oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant ~ newest
PATCH_KCP_COMMIT="ff1381103099207c61c0e8426e82eabbb2808b04" # from zen repo
PATCH_MULTIGEN_LRU_COMMIT_A_PARENT="8bb7eca972ad531c9b149c0a51ab43a417385813"
PATCH_MULTIGEN_LRU_COMMIT_A="a16cb0d264fdfcbe171a689738ef4726394dfe62" # ancestor ~ oldest
PATCH_MULTIGEN_LRU_COMMIT_D="87542b28c81281bd1a54969df035ccf5ce1853da" # descendant ~ newest
PATCH_OPENRGB_COMMIT="aa864eded832387e4ace9652ca2edbeb8155d703" # apply from zen repo
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A_PARENT="8bb7eca972ad531c9b149c0a51ab43a417385813"
PATCH_ZEN_MULTIGEN_LRU_COMMIT_A="a16cb0d264fdfcbe171a689738ef4726394dfe62" # ancestor ~ oldest
PATCH_ZEN_MULTIGEN_LRU_COMMIT_D="f16e06ddde0e38b172d8da03d4fd39c3296b0564" # descendant ~ newest
PATCH_TRESOR_VER="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A^..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020

ZEN_KV="5.15.0"
PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.15...zen-kernel:zen-kernel:5.15/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/7607cbe5890545c3d4a2c5598cfb0eb9255ab46a^..2f3fee79abe0a75597d511cb0ccfb12db1688b69.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
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
776bded2cf3b004f783d7dc52d9d74aeab966cd3
66ebd054e5444851a69974541525e0f651202aea
6c274a0c3cd6e014d388022c54f2bf0dbe6a12a3
05429691ac69cfe6704530bfed1d5911efb828bb
2f3fee79abe0a75597d511cb0ccfb12db1688b69
)

# Avoid merge conflict.
PATCH_ZEN_SAUCE_BRANDING="
7607cbe5890545c3d4a2c5598cfb0eb9255ab46a
"

# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
# commits [oldest] a b c d e... [newest]
# b:a
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE=(
de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac:05447263701b202e0086bb2cae098cf6d46c158e
) # \
# ZEN: INTERACTIVE: Use BFQ as our elevator (de75df0) requires \
# ZEN: Add CONFIG to rename the mq-deadline scheduler (0544726)

# Message marked with INTERACTIVE:
PATCH_ZEN_TUNE_COMMITS=(
00e58bccf05365ce65f6e9694e1ca3b9ad30f345
de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac
3045edebf785deb5d687abd9898ac9702be5325c
7bfc78d87614496288ad4e90f7d749a942a83718
be5ba234ca0a5aabe74bfc7e1f636f085bd3823c
09955b8fd454ae284590fc4c9f47e7c96f3bad51
16b72839cb862810bbf976e223f85ff4d1959ebd
96c43bfad5c8dcb116ab2088e46228707aaeca9f
)
PATCH_BFQ_DEFAULT="de75df02de322eaa8a0cd35ef9e4f7a1c010c9ac"
PATCH_ZEN_SAUCE_BL=(
	${PATCH_ZEN_SAUCE_BRANDING}
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

BBRV2_KV="5.13.12"
BBRV2_VERSION="v2alpha-2022-08-28"
BBRV2_COMMITS=( # oldest
# From https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1...v2alpha-2022-08-28
#
# Generated from:
# f428e49 - comes from Makefile
# wget -q -O - https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1^..v2alpha-2022-08-28.patch \
#       | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# Removed extra commit from generated list.
1ca5498fa4c6d4d8d634b1245d41f1427482824f
46ddceed8f8dad02a97e79c40893c385b859d1c8
94af063d5a381af0e2063cfd97dcce9783ed25c6
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

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE+="
bbrv2 build c2tcp cfi +cfs clang deepcc disable_debug -exfat +genpatches
-genpatches_1510 kpgo-utils lto multigen_lru orca pgo prjc rock-dkms rt
shadowcallstack symlink tresor tresor_aesni tresor_i686 tresor_prompt
tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support uksm
zen-multigen_lru zen-sauce
"
REQUIRED_USE+="
	genpatches_1510? (
		genpatches
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
DeepCC, \
genpatches, \
kernel_compiler_patch, \
multigen_lru, \
Orca, \
Project C (BMQ, PDS-mq), \
RT_PREEMPT (-rt), \
UKSM, \
zen-multigen_lru, \
zen-sauce. \
"

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" c2tcp? ( MIT )"
LICENSE+="
	pgo? (
		clang? (
			GPL-2
		)
	)
"
# A gcc pgo patch in 2014 exists but not listed for license reasons.
LICENSE+=" cfi? ( GPL-2 )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" prjc? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" multigen_lru? ( GPL-2 )"
LICENSE+=" orca? ( MIT )"
LICENSE+=" pgo? ( GPL-2 GPL-2+ )" # GCC_PGO kernel patch only
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no defaults license
	#   found in the project.  (The implementation is based on an academic paper
	#   from public universities.)
LICENSE+=" zen-sauce? ( GPL-2 )"

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

GCC_PV="5.1"
KMOD_PV="13"
CDEPEND+="
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.23
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=sys-devel/make-3.81
	app-arch/cpio
	app-shells/bash
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
		>=sys-apps/kmod-${KMOD_PV}[zlib]
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
	xz? (
		>=sys-apps/kmod-${KMOD_PV}[lzma]
		app-arch/xz-utils
	)
	zstd? (
		>=sys-apps/kmod-${KMOD_PV}[zstd]
		app-arch/zstd
	)

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
	kpgo-utils? (
		sys-kernel/kpgo-utils
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
	pgo? (
		(
			sys-devel/binutils[static-libs]
			sys-libs/libunwind[static-libs]
		)
		clang? (
			|| (
				$(gen_clang_pgo_rdepend 13 ${LLVM_MAX_SLOT})
			)
		)
	)
	lto? (
		|| (
			$(gen_lto_rdepend 11 ${LLVM_MAX_SLOT})
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

RDEPEND+="
	!build? (
		${CDEPEND}
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

PDEPEND+="
	rock-dkms? (
		|| (
			~sys-kernel/rock-dkms-5.4.3
			~sys-kernel/rock-dkms-5.3.3
			~sys-kernel/rock-dkms-5.1.3
		)
	)
"

if [[ "${PV}" =~ "9999" ]] ; then
	:;
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
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${C2TCP_URIS}
		${CFI_SRC_URIS}
		${GENPATCHES_URI}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		${MULTIGEN_LRU_SRC_URI}
		${PRJC_SRC_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${UKSM_SRC_URI}
		${ZEN_MULTIGEN_LRU_SRC_URI}
		${ZEN_SAUCE_URIS}
	"
else
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
		deepcc? (
			${C2TCP_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		multigen_lru? (
			${MULTIGEN_LRU_SRC_URI}
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
		uksm? (
			${UKSM_SRC_URI}
		)
		zen-multigen_lru? (
			${ZEN_MULTIGEN_LRU_SRC_URI}
		)
		zen-sauce? (
			${ZEN_SAUCE_URIS}
		)
	"
fi

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	if use cfi && use amd64 ; then
ewarn
ewarn "The CFI patch for x86-64 is in development and originally for the"
ewarn "5.15 series."
ewarn
	fi

	if use shadowcallstack && ! use arm64 ; then
ewarn
ewarn "ShadowCallStack is only offered on the arm64 platform."
ewarn
	fi

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

#	if use tresor ; then
#ewarn
#ewarn "TRESOR for ${MY_PV} is tested working.  See dmesg for details on correctness."
#ewarn
#	fi
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
#    fail.]  Essentially, we apply all the correct hunks first and replace the
#    the broken hunks afterwards.
# 2. Replace the original patch with a completely updated patch.
# 3. Copy the original patch then slightly modify and apply the patch.
#    (Modifications may fix the path changes between minor versions.)
#
# The reasons for each above:
#
# 1.  To see where the ebuild maintainer introduced error and to tell upstream
#     how to fix their patchset.  It allows the users to code review the fix.
# 2.  The context has mostly changed outside the edited parts or a mispatch
#     occurred as in hunk placed in the wrong place.
# 3.  Fix renamed files.
#
ot-kernel_filter_patch_cb() {
	local path="${1}"
einfo "${path}"
	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "prjc_v5.15-r1.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/prjc_v5.15-r1-fix-for-5.15.131.patch"
		#_dpatch "${PATCH_OPTS}" "${FILESDIR}/prjc-5.15-sched_post_fork-change.patch" # Review
	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 3 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-v9-fix-for-5.15.131.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-__no_profile-for-6.5.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-kconfig-depends-not-ARCH_WANTS_NO_INSTR-or-CC_HAS_NO_PROFILE_FN_ATTR.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-support-profraw-v6-to-v8.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-94af063.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-40bc606-fix-for-5.15.53.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-50b614c.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-50b614c-fix-for-5.15.53.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-41ceaf5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-41ceaf5-fix-for-5.15.53.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-3ff0ac8.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-3ff0ac8-fix-for-5.15.69.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"

	elif [[ "${path}" =~ "cfi-${CFI_KV}-a09066b.patch" ]] ; then
		# a09066b is the same as 343e289
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-343e289-fix-for-5.15.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-bd6966b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-bd6966b-fix-for-5.15.69.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-e921a27.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-e921a27-fix-for-5.15.69.patch"
	elif [[ "${path}" =~ "cfi-${CFI_KV}-aa4fb87.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 7 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-aa4fb87-fix-for-5.15.69.patch"
#	elif [[ "${path}" =~ "cfi-${CFI_KV}-5140d56.patch" ]] ; then
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-5140d56-moved-for-5.13.patch"
#
#		# Add this to the end of the cfi commit list
#		_dpatch "${PATCH_OPTS}" "${FILESDIR}/cfi-x86-cfi_init-ifdef-module-unload.patch"

	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-cf9b1da.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cf9b1da-fix-for-5.15.84.patch"
	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-5-15-131-orca-c2tcp-0521.patch"

	elif [[ "${path}" =~ "zen-sauce-5.15.0-e6e6ceb.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-5.15.0-e6e6ceb-fix-for-5.15.131.patch"

	elif [[ "${path}" =~ "uksm-5.15.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/uksm-5.15-fix-for-5.15.131.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}"
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
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
