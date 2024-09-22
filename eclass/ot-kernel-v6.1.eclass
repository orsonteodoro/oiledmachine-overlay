# Copyright 2020-2023 Orson Teodoro <orsonteodoro@hotmail.com>
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

# To update the array sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

# PV is for 9999 (live) context check
MY_PV="${PV}" # ver_test context
KERNEL_RELEASE_DATE="20221211" # of first stable release
KV_MAJOR=$(ver_cut 1 "${MY_PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${MY_PV}")
if ver_test "${MY_PV}" -eq "${KV_MAJOR_MINOR}" ; then
	# Normalize versioning
	UPSTREAM_PV="${KV_MAJOR_MINOR}.0" # file context
else
	UPSTREAM_PV="${MY_PV/_/-}" # file context
fi

ARM_FLAGS=(
# Some are default ON for security reasons or bug avoidance.
	+cpu_flags_arm_bti
	+cpu_flags_arm_lse # 8.1
	+cpu_flags_arm_mte # 8.3, kernel 5.10, gcc 10.1, llvm 8 ; Disabled this and used v8_3 instead.
	cpu_flags_arm_neon
	+cpu_flags_arm_pac # 8.3-A
	+cpu_flags_arm_tlbi # 8.4
)

BBRV2_COMMITS=( # oldest
# From https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1...v2alpha-2022-08-28
#
# Generated from:
# f428e49 - comes from Makefile
# wget -q -O - https://github.com/google/bbr/compare/f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1^..v2alpha-2022-08-28.patch \
#       | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# Removed extra commit from generated list.
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
BBRV2_KV="5.13.12"
BBRV2_VERSION="v2alpha-2022-08-28"

C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
CLANG_PGO_SUPPORTED=1
CXX_STD="-std=gnu++14" # See https://github.com/torvalds/linux/blob/v6.1/tools/build/feature/Makefile#L318
DISABLE_DEBUG_PV="1.4.2"
EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	ia64
	loong
	mips
	ppc
	ppc64
	riscv
	s390
	sparc
	x86
)
EXTRAVERSION="-ot"
GCC_PV="5.1"
GCC_COMPAT=( {13..5} )
GCC_MAX_SLOT=${GCC_COMPAT[0]}
GCC_MIN_SLOT=${GCC_COMPAT[-1]}
GCC_MIN_KCP_GENPATCHES_AMD64=13
GCC_MIN_KCP_GRAYSKY2_AMD64=13
GCC_MIN_KCP_GRAYSKY2_ARM64=5
GCC_MIN_KCP_ZEN_SAUCE_AMD64=13
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KMOD_PV="13"
LLVM_COMPAT=( {18..11} )
LLVM_MAX_SLOT=${LLVM_COMPAT[0]}
LLVM_MIN_SLOT=${LLVM_COMPAT[-1]}
LLVM_MIN_KCFI_ARM64=16
LLVM_MIN_KCFI_AMD64=16
LLVM_MIN_KCP_GENPATCHES_AMD64=15
LLVM_MIN_KCP_GRAYSKY2_AMD64=15
LLVM_MIN_KCP_GRAYSKY2_ARM64=3
LLVM_MIN_KCP_ZEN_SAUCE_AMD64=15
LLVM_MIN_LTO=12
LLVM_MIN_PGO=13
LLVM_MIN_PGO_S390=15
LLVM_MIN_SHADOWCALLSTACK_ARM64=10
PATCH_ALLOW_O3_COMMIT="7042e70222c4f9205194f5d296bc3272c0537eee" # id from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor ~ oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant ~ newest
PATCH_BFQ_DEFAULT="c7a4c6f6e1f0cd6c9100187412d76e8efe718ade" # id from zen repo
PATCH_KCP_COMMIT="b88b54d2df7b41ba362df4bf6df7c69536b5bda0" # id from zen repo ; aka more-uarches
PATCH_KYBER_DEFAULT="90ca7255bd687a9a0219a668adb102c88eeec68e" # id from zen repo
PATCH_OPENRGB_COMMIT="de09ca82f5200498edf14e6680891b846d05ef14" # id from zen repo
PATCH_TRESOR_VER="3.18.5"
PATCH_ZEN_SAUCE_BRANDING="f884ec1baec395379fcb427bbc2b3231ba9484a2" # id from zen repo

PATCH_ZEN_SAUCE_BLACKLISTED_COMMITS=(
# Avoid merge conflict or duplicates with already upstreamed.
	${PATCH_ZEN_SAUCE_BRANDING}
# Disabled ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.
)

PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v6.1...zen-kernel:zen-kernel:6.1/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/f884ec1baec395379fcb427bbc2b3231ba9484a2^..9381f7633208cb517fee827051afc6a7c1decd3d.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
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

# FIXME:
# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
# commits [oldest] a b c d e... [newest]
# b:a
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE=(
)

# Message marked with INTERACTIVE:
PATCH_ZEN_TUNE_COMMITS=(
# Generated by copy and paste.
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
RUST_PV="1.62.0"
PPC_FLAGS=(
	cpu_flags_ppc_476fpe
	cpu_flags_ppc_altivec
)
X86_FLAGS=(
# See also
# arch/x86/Kconfig.assembler
# arch/x86/Makefile
# include/opcode/i386.h from binutils <= 2.17.x
# opcodes/i386-opc.tbl from binutils >= 2.18.x
	cpu_flags_x86_aes
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512vl # kernel 5.7, gcc 5.1, llvm 3.7
	cpu_flags_x86_gfni
	cpu_flags_x86_pclmul  # (CRYPTO_GHASH_CLMUL_NI_INTEL) pclmulqdq - kernel 2.6, gcc 4.4, llvm 3.2 ; 2010
	cpu_flags_x86_sha
	cpu_flags_x86_sha256
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_2 # crc32
	cpu_flags_x86_ssse3
	cpu_flags_x86_tpause # kernel 5.8, gcc 6.5, llvm 7
	cpu_flags_x86_vpclmulqdq # (CRYPTO_POLYVAL_CLMUL_NI) vpclmulqdq - kernel 6.0, gcc 8.1, llvm 6 ; 2017
)
ZEN_KV="6.1.0"

# KCFI merged in 6.1

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
# CET default ON based on CI.
# clang is default OFF based on https://github.com/torvalds/linux/blob/v6.1/Documentation/process/changes.rst
# kcfi default OFF based on CI using clang 17.
IUSE+="
${ARM_FLAGS[@]}
${PPC_FLAGS[@]}
${X86_FLAGS[@]}
bbrv2 build c2tcp +cet +cfs -clang deepcc -debug -dwarf4 -dwarf5 -dwarf-auto
-exfat -expoline -gdb +genpatches -genpatches_1510 -kcfi -lto nest orca pgo prjc
qt5 +retpoline rt -rust shadowcallstack symlink tresor tresor_prompt tresor_sysfs
zen-sauce
ia64
"

REQUIRED_USE+="
	dwarf4? (
		debug
		gdb
	)
	dwarf5? (
		debug
		gdb
	)
	dwarf-auto? (
		debug
		gdb
	)
	expoline? (
		!clang
		s390
	)
	gdb? (
		debug
		|| (
			dwarf-auto
			dwarf5
			dwarf4
		)
	)
	genpatches_1510? (
		genpatches
	)
	tresor_prompt? (
		tresor
	)
	tresor_sysfs? (
		tresor
	)
"

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
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" exfat? ( GPL-2+ OIN )" # See https://en.wikipedia.org/wiki/ExFAT#Legal_status
LICENSE+=" kcfi? ( GPL-2 )"
LICENSE+=" nest? ( GPL-2 )"
LICENSE+=" prjc? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" orca? ( MIT )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
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

gen_clang_lld() {
	local min=${1}
	local max=${2}
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		     "
	done
}

KCP_RDEPEND="
	amd64? (
		!clang? (
			>=sys-devel/gcc-13.9
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair ${LLVM_MIN_KCP_GRAYSKY2_AMD64} ${LLVM_MAX_SLOT})
			)
		)
	)
	arm64? (
		!clang? (
			>=sys-devel/gcc-5.1.0
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair ${LLVM_MIN_KCP_GRAYSKY2_ARM64} ${LLVM_MAX_SLOT})
			)
		)
	)
"

# KCFI requires https://reviews.llvm.org/D119296 patch
# We can eagerly prune the gcc dep from cpu_flag_x86_* but we want to handle
# both inline assembly (.c) and assembler file (.S) cases.
# The unlabeled debug section below refers to zlib compression of debug info.
# CET-IBT: gcc 8.1, llvm 7, binutils 2.27
#
# We add more binutils/llvm/gcc checks because the distro and other popular
# overlays don't delete their older ebuilds.
#
CDEPEND+="
	${KCP_RDEPEND}
	>=app-shells/bash-4.2
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.23
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=dev-build/make-3.82
	app-arch/cpio
	dev-util/pkgconf
	sys-apps/grep[pcre]
	virtual/libelf
	virtual/pkgconfig
	arm64? (
		big-endian? (
			!clang? (
				sys-devel/binutils
			)
			clang? (
				$(gen_clang_lld 15 ${LLVM_MAX_SLOT})
			)
		)
	)
	bzip2? (
		app-arch/bzip2
	)
	cet? (
		!clang? (
			>=sys-devel/binutils-2.29
			>=sys-devel/gcc-9
		)
		clang? (
			|| (
				$(gen_clang_lld 14 ${LLVM_MAX_SLOT})
			)
		)
	)
	cpu_flags_arm_bti? (
		arm64? (
			!clang? (
				>=sys-devel/gcc-10.1
			)
			clang? (
				$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
			)
		)
	)
	cpu_flags_arm_lse? (
		>=sys-devel/binutils-2.25
	)
	cpu_flags_arm_mte? (
		>=sys-devel/binutils-2.33
		!clang? (
			>=sys-devel/gcc-10.1
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair 9 ${LLVM_MAX_SLOT})
			)
		)
	)
	cpu_flags_arm_pac? (
		arm64? (
			>=sys-devel/binutils-2.33.1
			!clang? (
				>=sys-devel/gcc-9.1
			)
			clang? (
				|| (
					$(gen_clang_llvm_pair 14 ${LLVM_MAX_SLOT})
				)
			)
		)
	)
	cpu_flags_arm_tlbi? (
		>=sys-devel/binutils-2.30
	)
	cpu_flags_ppc_476fpe? (
		>=sys-devel/binutils-2.25
	)
	cpu_flags_x86_aes? (
		>=sys-devel/binutils-2.19
	)
	cpu_flags_x86_avx? (
		>=sys-devel/binutils-2.19
	)
	cpu_flags_x86_avx2? (
		>=sys-devel/binutils-2.22
	)
	cpu_flags_x86_avx512bw? (
		>=sys-devel/binutils-2.25
	)
	cpu_flags_x86_gfni? (
		!clang? (
			>=sys-devel/binutils-2.30
			>=sys-devel/gcc-6
		)
	)
	cpu_flags_x86_pclmul? (
		>=sys-devel/binutils-2.19
	)
	cpu_flags_x86_sha? (
		>=sys-devel/binutils-2.24
	)
	cpu_flags_x86_sha256? (
		>=sys-devel/binutils-2.24
	)
	cpu_flags_x86_sse2? (
		>=sys-devel/binutils-2.11
	)
	cpu_flags_x86_sse4_2? (
		>=sys-devel/binutils-2.18
	)
	cpu_flags_x86_ssse3? (
		>=sys-devel/binutils-2.17
	)
	cpu_flags_x86_tpause? (
		!clang? (
			>=sys-devel/binutils-2.31.1
			>=sys-devel/gcc-9
		)
	)
	cpu_flags_x86_vpclmulqdq? (
		>=sys-devel/binutils-2.19
	)
	debug? (
		(
			!clang? (
				>=sys-devel/gcc-5
			)
			clang? (
				|| (
					$(gen_clang_llvm_pair 12 ${LLVM_MAX_SLOT})
				)
			)
			>=sys-devel/binutils-2.26
		)
	)
	dwarf4? (
		!clang? (
			>=sys-devel/binutils-2.35.2
			>=sys-devel/gcc-4.5
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair 16 ${LLVM_MAX_SLOT})
			)
		)
		>=dev-debug/gdb-7.0
	)
	dwarf5? (
		!clang? (
			>=sys-devel/binutils-2.35.2
			>=sys-devel/gcc-5
			riscv? (
				>=sys-devel/binutils-2.42
			)
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair 16 ${LLVM_MAX_SLOT})
			)
		)
		>=dev-debug/gdb-8.0
	)
	dwarf-auto? (
		!clang? (
			>=sys-devel/binutils-2.35.2
			riscv? (
				>=sys-devel/binutils-2.42
			)
		)
		>=dev-debug/gdb-8.0
	)
	expoline? (
		!clang? (
			s390? (
				>=sys-devel/gcc-7.4.0
			)
		)
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
	retpoline? (
		!clang? (
			>=sys-devel/gcc-7.3.0
		)
		clang? (
			|| (
				$(gen_clang_llvm_pair 5 ${LLVM_MAX_SLOT})
			)
		)
	)
	rust? (
		$(python_gen_any_dep '
			>=dev-util/pahole-1.16[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-util/cbindgen-0.56.0
		~virtual/rust-${RUST_PV}
		!clang? (
			>=sys-devel/gcc-4.5
		)
		clang? (
			$(gen_clang_llvm_pair 16 ${LLVM_MAX_SLOT})
		)
	)
	xz? (
		>=sys-apps/kmod-${KMOD_PV}[lzma]
		app-arch/xz-utils
	)
	zstd? (
		>=sys-apps/kmod-${KMOD_PV}[zstd]
		app-arch/zstd
	)

	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
	lto? (
		|| (
			$(gen_lto_rdepend ${LLVM_MIN_LTO} ${LLVM_MAX_SLOT})
		)
	)
	kcfi? (
		arm64? (
			|| (
				$(gen_kcfi_rdepend ${LLVM_MIN_KCFI_ARM64} ${LLVM_MAX_SLOT})
			)
		)
		amd64? (
			|| (
				$(gen_kcfi_rdepend ${LLVM_MIN_KCFI_AMD64} ${LLVM_MAX_SLOT})
			)
		)
	)
	pgo? (
		(
			sys-devel/binutils[static-libs]
			sys-libs/libunwind[static-libs]
		)
		clang? (
			|| (
				$(gen_clang_pgo_rdepend ${LLVM_MIN_PGO} ${LLVM_MAX_SLOT})
			)
			s390? (
				|| (
					$(gen_clang_pgo_rdepend ${LLVM_MIN_PGO_S390} ${LLVM_MAX_SLOT})
				)
			)
		)
	)
	shadowcallstack? (
		arm64? (
			!clang? (
				>=sys-devel/gcc-12.1
			)
			clang? (
				|| (
					$(gen_shadowcallstack_rdepend ${LLVM_MIN_SHADOWCALLSTACK_ARM64} ${LLVM_MAX_SLOT})
				)
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
"

if [[ "${PV}" =~ "9999" ]] ; then
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
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${C2TCP_URIS}
		${GENPATCHES_URI}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${KCP_SRC_CORTEX_A72_URI}
		${NEST_URI}
		${PRJC_SRC_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
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
		deepcc? (
			${C2TCP_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		nest? (
			${NEST_URI}
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
			${ZEN_SAUCE_URIS}
		)
	"
fi

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
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
ewarn "XTS support for TRESOR has been dropped for the ${KV_MAJOR_MINOR}"
ewarn "series.  Use the older versions 4.19.x, 5.4.x, 5.10.x to convert"
ewarn "xts(tresor) -> cbc(tresor)."
ewarn
ewarn "CTR support for TRESOR is currently on hold for the ${KV_MAJOR_MINOR}"
ewarn "series.  Use the older versions 4.19.x, 5.4.x, 5.10.x for working"
ewarn "ctr(tresor)."
ewarn
		fi
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
ot-kernel_apply_tresor_fixes() {
	if [[ -z "${TRESOR_MAX_KEY_SIZE}" ]] ; then
		if [[ "${arch}" == "x86_64" ]] ; then
			TRESOR_MAX_KEY_SIZE="256"
		else
			TRESOR_MAX_KEY_SIZE="128"
		fi
	fi

	local tresor_patch_target # <arch>_<type>_<max_key_size>
	if [[ -n "${TRESOR_TARGET_OVERRIDE}" ]] ; then
		# For development
		tresor_patch_target="${TRESOR_TARGET_OVERRIDE}"
	elif [[ "${arch}" == "x86_64" ]] && ot-kernel_use cpu_flags_x86_aes ; then
		tresor_patch_target="x86_64_aesni_256"
	elif [[ "${arch}" == "x86_64" ]] && [[ "${TRESOR_MAX_KEY_SIZE}" == "192" || "${TRESOR_MAX_KEY_SIZE}" == "256" ]] ; then
		tresor_patch_target="x86_64_generic_256"
	elif [[ "${arch}" == "x86_64" ]] && [[ "${TRESOR_MAX_KEY_SIZE}" == "128" ]] ; then
		tresor_patch_target="x86_64_generic_128"
	elif [[ "${arch}" == "x86" ]] ; then
		tresor_patch_target="x86_generic_128"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

        _dpatch "${PATCH_OPTS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPTS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-6.1-v4_i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-6.1-v4_aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.6.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi

	# tresor-xts-setkey update applied in these below
	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-i686-256-v1.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-aesni-v1.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-helper-removed-i686-128-v1.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-glue_helper-for-5.15_x86_64.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-for-5.15_i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_256" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-256-for-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-128-for-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-drop-xts-and-use-ctr-template-for-6.1_aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-rename-to-freezer_active-for-6.1.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-linux-stdarg-for-6.1_x86_64.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-explicit-int-dont_switch-arg-for-6.1.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-kconfig-crypto-simd-for-6.1.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		:
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-enc-dec-blk-for-6.1_aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-cpuid-aesni-check-for-6.1.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-256-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.15_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
	# Patch reuse was tested okay.
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.15_x86_64.patch"
	#elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
	#	Only 64-bit X86 supported.
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
	local msg_extra="${2}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex

	if [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${path}"
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"

	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 "${MY_PV}") -ge "5.10.4" ; then
einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0006-net-Remove-the-obsolte-u64_stats_fetch_-_irq-users-n.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		filterdiff \
			-x "*/net/core/devlink.c" \
			"${path}" \
			> \
			"${T}/0006-net-Remove-the-obsolte-u64_stats_fetch_-_irq-users-n.patch" \
			|| die
		_dpatch "${PATCH_OPTS}" "${T}/0006-net-Remove-the-obsolte-u64_stats_fetch_-_irq-users-n.patch"
	elif [[ "${path}" =~ "0012-Linux-6.1.46-rt14-rc1.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Skipped patch.
		:
	elif [[ "${path}" =~ "0053-io-mapping-don-t-disable-preempt-on-RT-in-io_mapping.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0054-locking-rwbase-Mitigate-indefinite-writer-starvation.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0055-revert-softirq-Let-ksoftirqd-do-its-job.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0056-kernel-fork-beware-of-__put_task_struct-calling-cont.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0057-debugobjects-locking-Annotate-debug_object_fill_pool.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0058-sched-avoid-false-lockdep-splat-in-put_task_struct.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0059-seqlock-Do-the-lockdep-annotation-before-locking-in-.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0060-mm-page_alloc-Use-write_seqlock_irqsave-instead-writ.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0061-bpf-Remove-in_atomic-from-bpf_link_put.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0062-posix-timers-Ensure-timer-ID-search-loop-limit-is-va.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "0063-drm-i915-Do-not-disable-preemption-for-resets.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Already applied
		:
	elif [[ "${path}" =~ "/series"$ ]] ; then
		# This patch belongs to the -rt patchset.
		# Skipped.  Not a patch.
		:

	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-v9-fix-for-6.1.77.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-__no_profile-for-6.5.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-kconfig-depends-not-ARCH_WANTS_NO_INSTR-or-CC_HAS_NO_PROFILE_FN_ATTR.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-support-profraw-v6-to-v8.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-support-profraw-v9.patch"

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
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-cf9b1da.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 5 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cf9b1da-fix-for-6.1.patch"

	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		if use bbrv2 ; then
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-1-52-orca-c2tcp-0521-bbr2-compat.patch"
		else
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-1-52-orca-c2tcp-0521.patch"
		fi
	elif [[ "${path}" =~ "prjc_v6.1-r4.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/prjc_v6.4-r0-fix-for-6.4.15.patch" # Same hunks

	elif [[ "${path}" =~ "zen-sauce-6.1.0-0a22064.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/zen-sauce-6.1.0-0a22064-fix-for-6.1.52.patch"
	elif [[ "${path}" =~ "zen-sauce-6.1.0-f22bc56.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/zen-sauce-6.1.0-f22bc56-fix-for-6.1.57.patch"

	elif [[ "${path}" =~ "Nest_v6.6.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/nest-6.6-fix-for-6.1.82.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
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

# @FUNCTION: ot-kernel_check_usedeps
# @DESCRIPTION:
# Check the USEDEP of the dependency.
ot-kernel_check_usedeps() {
	if tc-is-clang && grep -q -E -e "^CONFIG_ARCH_RPC=y" "${path_config}" && [[ "${arch}" == "arm" ]] ; then
		die "Disable the clang USE flag or in OT_KERNEL_USE."
	fi
}

# @FUNCTION: ot-kernel_get_llvm_min_slot
# @DESCRIPTION:
# Get the inclusive min slot for clang
ot-kernel_get_llvm_min_slot() {
	local _llvm_min_slot

	local wants_kcp=0
	local wants_kcp_rpi=0

	if [[ "${CFLAGS}" =~ "-march" ]] ; then
		wants_kcp=1
	fi
	if [[ -n "${X86_MICROARCH_OVERRIDE}" ]] ; then
		wants_kcp=1
	fi
	if [[ "${CFLAGS}" =~ "-mcpu=cortex-a72" ]] ; then
		wants_kcp_rpi=1
	fi

	local kcp_provider=$(ot-kernel_get_kcp_provider)

	# Descending sort
	if grep -q -E -e "^CONFIG_CC_HAS_RANDSTRUCT=y" "${path_config}" ; then
		_llvm_min_slot=16
	elif grep -q -E -e "^CONFIG_CFI_CLANG=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_ARM64} # 16
	elif grep -q -E -e "^CONFIG_CFI_CLANG=y" "${path_config}" && [[ "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_AMD64} # 16
	elif grep -q -E -e "^CONFIG_RUST=y" "${path_config}" ; then
		_llvm_min_slot=16
	elif [[ "${kcp_provider}" == "genpatches" || "${kcp_provider}" == "graysky2" || "${kcp_provider}" =~ "zen-sauce" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCP_GRAYSKY2_AMD64} # 15
	elif grep -q -E -e "^CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_CPU_BIG_ENDIAN=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF4=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF5=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif ot-kernel_use pgo && [[ "${arch}" == "s390" ]] ; then
		_llvm_min_slot=${LLVM_MIN_PGO_S390} # 15
	elif grep -q -E -e "^CONFIG_CC_HAS_IBT=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=14
	elif grep -q -E -e "^CONFIG_HAVE_KMSAN_COMPILER=y" "${path_config}" ; then
		_llvm_min_slot=14
	elif grep -q -E -e "^CONFIG_KCSAN_WEAK_MEMORY=y" "${path_config}" ; then
		_llvm_min_slot=14
	elif grep -q -E -e "^CONFIG_RANDOMIZE_KSTACK_OFFSET=y" "${path_config}" ; then
		_llvm_min_slot=14
	elif grep -q -E -e "^CONFIG_X86_KERNEL_IBT=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=14
	elif has cpu_flags_arm_pac ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_arm_pac && [[ "${auth}" == "arm64" ]] ; then
		_llvm_min_slot=14
	elif ot-kernel_use clang && ot-kernel_use pgo ; then
		_llvm_min_slot=${LLVM_MIN_PGO} # 13
	elif grep -q -E -e "^CONFIG_ARM64_BTI_KERNEL=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=12
	elif grep -q -E -e "^CONFIG_COMPAT=y" "${path_config}" && [[ "${arch}" == "powerpc" ]] ; then
		_llvm_min_slot=12
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_COMPRESSED=y" "${path_config}" ; then
		_llvm_min_slot=12
	elif grep -q -E -e "^CONFIG_KASAN_HW_TAGS=y" "${path_config}" ; then
		_llvm_min_slot=12
	elif has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ; then
		_llvm_min_slot=${LLVM_MIN_LTO} # 12
	elif has shadowcallstack ${IUSE_EFFECTIVE} && ot-kernel_use shadowcallstack && [[ "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_SHADOWCALLSTACK_ARM64} # 10
	else
		_llvm_min_slot=${LLVM_MIN_SLOT} # 11
	fi
	echo "${_llvm_min_slot}"
}

# @FUNCTION: ot-kernel_get_gcc_min_slot
# @DESCRIPTION:
# Get the inclusive min slot for gcc
ot-kernel_get_gcc_min_slot() {
	local _gcc_min_slot
	local kcp_provider=$(ot-kernel_get_kcp_provider)

	# Descending sort
	if [[ "${kcp_provider}" == "genpatches" || "${kcp_provider}" == "graysky2" || "${kcp_provider}" =~ "zen-sauce" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_AMD64} # 13
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_SPLIT=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_INIT_STACK_ALL_ZERO=y" "${path_config}" ; then
	# Prevent:
	# <redacted>-pc-linux-gnu-gcc-11: error: unrecognized command-line option '-ftrivial-auto-var-init=zero'
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_KCOV=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_SHADOW_CALL_STACK=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_EXPOLINE_EXTERN=y" "${path_config}" && [[ "${arch}" == "s390" ]] ; then
		_gcc_min_slot=11
	elif grep -q -E -e "^CONFIG_KASAN_SW_TAGS=y" "${path_config}" ; then
		_gcc_min_slot=11
	elif grep -q -E -e "^CONFIG_ARM64_BTI_KERNEL=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_gcc_min_slot=10
	elif grep -q -E -e "^CONFIG_KASAN_HW_TAGS=y" "${path_config}" ; then
		_gcc_min_slot=10
	elif grep -q -E -e "^CONFIG_ARM64_MTE=y" "${path_config}" ; then
		_gcc_min_slot=10
	elif grep -q -E -e "^CONFIG_CC_HAS_IBT=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=9
	elif grep -q -E -e "^CONFIG_X86_KERNEL_IBT=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=9
	elif has cpu_flags_arm_pac ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_arm_pac && [[ "${auth}" == "arm64" ]] ; then
		_gcc_min_slot=9
	elif has cpu_flags_x86_tpause ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_x86_tpause ; then
		_gcc_min_slot=9
	elif grep -q -E -e "^CONFIG_KASAN_GENERIC=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif ot-kernel_use cpu_flags_x86_vpclmulqdq ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_RETPOLINE=y" "${path_config}" ; then
		_gcc_min_slot=7
	elif grep -q -E -e "^CONFIG_ARCH_RPC=y" "${path_config}" && [[ "${arch}" == "arm" ]] ; then
		_gcc_min_slot=6
	elif has cpu_flags_x86_gfni ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_x86_gfni ; then
		_gcc_min_slot=6
	else
		_gcc_min_slot=${GCC_MIN_SLOT} # 5
	fi
	echo "${_gcc_min_slot}"
}

# @FUNCTION: ot-kernel_get_llvm_max_slot
# @DESCRIPTION:
# Get the inclusive max slot for llvm
ot-kernel_get_llvm_max_slot() {
	local _llvm_max_slot

	# Ascending sort
	if grep -q -E -e "^CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC=y" "${path_config}" && [[ "${arch}" == "riscv" ]] ; then
		_llvm_max_slot=16
	else
		_llvm_max_slot=${LLVM_MAX_SLOT} # 18
	fi
	echo "${_llvm_max_slot}"
}

# @FUNCTION: ot-kernel_get_gcc_max_slot
# @DESCRIPTION:
# Get the inclusive max slot for gcc
ot-kernel_get_gcc_max_slot() {
	local _gcc_max_slot

	# Ascending sort
	if grep -q -E -e "^CONFIG_ARCH_RPC=y" "${path_config}" && [[ "${arch}" == "arm" ]] ; then
		_gcc_max_slot=8
	elif grep -q -E -e "^CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC=y" "${path_config}" && [[ "${arch}" == "riscv" ]] ; then
		_gcc_max_slot=10
	else
		_gcc_max_slot=${GCC_MAX_SLOT} # 13
	fi
	echo "${_gcc_max_slot}"
}
