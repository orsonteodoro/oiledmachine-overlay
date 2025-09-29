# Copyright 2020-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO package:
# sphinx-rtd-dark-mode

# @ECLASS: ot-kernel-v6.16.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 6.16.x kernel
# @DESCRIPTION:
# The ot-kernel-v6.16 eclass defines specific applicable patching for the 6.16.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/master/Documentation/process/changes.rst
# https://github.com/torvalds/linux/blob/v6.16/Documentation/process/changes.rst
# For compiler versions, see
# https://github.com/torvalds/linux/blob/v6.16/scripts/min-tool-version.sh#L26

# To update the array sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

# TODO:  Update patchsets
# TODO:  Update versions

#GENPATCHES_FALLBACK_COMMIT="acbfddfa35863bb536010294d1284ee857b9e13b" # 2023-10-08 10:56:26 -0400
#LINUX_SOURCES_FALLBACK_COMMIT="8bc9e6515183935fa0cccaf67455c439afe4982b" # 2023-10-31 18:50:13 -1000
# PV is for 9999 (live) context check
if [[ "${PV}" =~ "9999" ]] ; then
	#RC_PV="rc2"
	# MY_PV is in ver_test context
	if [[ -n "${RC_PV}" ]] ; then
		MY_PV=$(ver_cut 1-3 "${PV}")"_${RC_PV}"
	else
		MY_PV=$(ver_cut 1-3 "${PV}")
	fi
else
	RC_PV=""
	MY_PV="${PV}" # ver_test context
fi
# AMDGPU_FIRMWARE_RELEASE_DATE is based on firmware names from
# https://elixir.bootlin.com/linux/v6.16.9/source/drivers/gpu/drm/amd/display/include/dal_types.h	DCN 4.0.1
# https://elixir.bootlin.com/linux/v6.16.9/source/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c		VCN 5.0.1
# https://elixir.bootlin.com/linux/v6.16.9/source/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c		the last gfx version for gc_12_0_1 and others with .bin reference
# and linux-firmware firmware upload date
KERNEL_RELEASE_DATE="20250727"
AMD_SEV_FIRMWARE_RELEASE_DATE="20230828" # Based on amd_sev_fam19h_model1xh file first presence
AMDGPU_FIRMWARE_RELEASE_DATE="20241203" # Based on vcn 5.0.0 and dcn 4.0.1 and gc_12_0_1 first presence
AMDXDNA_FIRMWARE_RELEASE_DATE="20241203" # Based on npu.sbin first presence
ATH_FIRMWARE_RELEASE_DATE="20241010" # Based on presence of latest added board-2 (QCN9274) file in https://github.com/torvalds/linux/blob/v6.16/drivers/net/wireless/ath/ath12k/hw.c
IVPU_FIRMWARE_RELEASE_DATE="20250307" # Based on presence of added vpu_37xx_v1 bin referenced in https://github.com/torvalds/linux/blob/v6.16/drivers/accel/ivpu/ivpu_fw.c
RTL8XXXU_FIRMWARE_RELEASE_DATE="20230517" # Based on latest added rtl8192fufw bin from https://github.com/torvalds/linux/blob/v6.16/drivers/net/wireless/realtek/rtl8xxxu/
RTLWIFI_FIRMWARE_RELEASE_DATE="20241010" # Based on latest added rtl8192dufw bin from https://github.com/torvalds/linux/blob/v6.16/drivers/net/wireless/realtek/rtlwifi/
RTW_FIRMWARE_RELEASE_DATE="20250421" # Based on latest added rtw8852c_fw-2 and rtw8922a_fw-3 bin drivers from https://github.com/torvalds/linux/blob/v6.16/drivers/net/wireless/realtek/rtw89
# Initially, the required firmware date was thought to be feature complete and in
# sync with the kernel driver on the release date of the kernel.  It is not the
# case.  Because of many reasons (code review sabateurs, job security, marketing
# product leak, last minute bugs, release scheduling), this firmware(s)
# supporting the latest hardware or the microarchitectures listed in the driver
# may be delayed.
#
# This also means that each vendor will have an early release or late release
# of their devices' firmware.
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

BBRV3_COMMITS=( # oldest
# wget -q -O - https://github.com/google/bbr/compare/ba2274dcfda859b8a27193e68ad37bfe4da28ddc^..7542cc7c41c0492a0cdbeb77e295cbfdcd9f5e11.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
#ba2274dcfda859b8a27193e68ad37bfe4da28ddc # Already applied
f601c9f8eee1585892530f6e4d847c6801b3bd2d
9cb2d74a55ce4d621666a93c59f8635a91c03975
767930979dacb584aa07b9f492f521d1f06a9bc3
4e589c6069b75bf559f59e09fa19871fd92fb44d
ade2a0e3f26b45f0de9fe9b368c9bef6609a2c8f
1f4015e7004cea97a458feb4bb847a78a3367607
f82a3d3f940c5220b37a2e0884ef399fc8b952c2
bfa26db027f29177f05a9772094ed16c8c88c488
0fa4869b2177bafeadc4a15a5d9c37dad13b147b
c20e56d9661031647ddc99c47ae8971d0a7b99b7
a5cc0063dc64f3d43c82390567ec9ddf16f4727c
4fef7ac2a9ccc4402d8d079002c65e42e9187068
dc4a1f8de1f074d505b3f539df47635af22621f9
9f5cbd8717f7c95c7def5af51972316ea92cbf7b
40f1ce936f1a1732add87dd3518fdd6e5fa0982c
aa27c22a2ebe5696b5b42002337425e2a53b2f79
5ad789ec25187629f09d7636ebd05ae1391fe916
a1d32ad82d426f29c71dd837393b3d7ea8501b5e
#a7743a2757fae9b06613c201cce6416a95d5f345 # Don't need kernel config
04ed1b49454dd2ce5d19a877b34612039a069a69
7ce213b7ed213c55a5f71b1b85bbdbb6d664f4b4
d0d8043bc8e63e445224ac29085b694b01980fff
#fea8e5afef8fee4ec491a8841b08854d8e87e503 # Don't need kernel config
c27c87b3b097705828db63a23c79a8e83f39c809
#ca7f11ebc4d4a99ccfd44be8555d505b26996c12 # Comment junk
cc97916dc4f073730d747c9a5fdfc081460ca7e1
#537b1b761e1d0036923adba7a80d3655cfff095d # Comment junk
a59d131c35ce04e7be84c3cf3fe3a7c7a4cf8457
#107339d7f48c95ae8a7461150e143fc53b08fea9 # Comment junk
7542cc7c41c0492a0cdbeb77e295cbfdcd9f5e11
)
BBRV3_KV="6.4.0" # According to Makefile, but the net folder has tagged net-6.5-rc1 commit
BBRV3_VERSION="7542cc7" # Latest commit in the branch

C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_MAJOR_VER="2" # Missing kernel/sysctl_binary.c >= 5.9
C2TCP_VER="2.2"
# For CFI users, KCFI merged in 6.1
CLANG_PGO_SUPPORTED=1
CXX_STD="-std=gnu++14" # See https://github.com/torvalds/linux/blob/v6.16/tools/build/feature/Makefile#L331
DISABLE_DEBUG_PV="1.4.2"
EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
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
GCC_PV="8.1"
GCC_COMPAT=( {14..5} )
GCC_MAX_SLOT=${GCC_COMPAT[0]}
GCC_MIN_SLOT=${GCC_COMPAT[-1]}
GCC_MIN_KCP_GENPATCHES_AMD64=14
GCC_MIN_KCP_GRAYSKY2_AMD64=14
GCC_MIN_KCP_GRAYSKY2_ARM64=5
GCC_MIN_KCP_ZEN_SAUCE_AMD64=14
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KMOD_PV="13"
# llvm slot originally 16, testing 18
LLVM_COMPAT=( {19..13} ) # Limited by Rust
LLVM_MAX_SLOT=${LLVM_COMPAT[0]}
LLVM_MIN_SLOT=${LLVM_COMPAT[-1]}
LLVM_MIN_KCFI_ARM64=16
LLVM_MIN_KCFI_AMD64=16
LLVM_MIN_KCP_GENPATCHES_AMD64=19
LLVM_MIN_KCP_GRAYSKY2_AMD64=18 # It should be 19 but downgraded to 18.
LLVM_MIN_KCP_GRAYSKY2_ARM64=3
LLVM_MIN_KCP_ZEN_SAUCE_AMD64="not released"
LLVM_MIN_LTO=17
LLVM_MIN_PGO=13
LLVM_MIN_PGO_S390=15
LLVM_MIN_SHADOWCALLSTACK_ARM64=10
PATCH_ALLOW_O3_COMMIT="" # id from zen repo
PATCH_BBRV2_COMMIT_A_PARENT="f428e49b8cb1fbd9b4b4b29ea31b6991d2ff7de1" # 5.13.12
PATCH_BBRV2_COMMIT_A="1ca5498fa4c6d4d8d634b1245d41f1427482824f" # ancestor ~ oldest
PATCH_BBRV2_COMMIT_D="a23c4bb59e0c5a505fc0f5cc84c4d095a64ed361" # descendant ~ newest
PATCH_BFQ_DEFAULT="208f2c37cff2a2bde18adcdd79274254e03fac8d" # id from zen repo
PATCH_KCP_COMMIT="" # id from zen repo ; aka more-uarches
PATCH_KYBER_DEFAULT="0f5c2376123a8592d9b05167327c67e4cd5e1564" # id from zen repo
PATCH_OPENRGB_COMMIT="" # id from zen repo
PATCH_TRESOR_VER="3.18.5"
PATCH_ZEN_SAUCE_BRANDING="a6fa175c7e23941ba2a8fde4254095b077cfb49c" # id from zen repo

PATCH_ZEN_SAUCE_BLACKLISTED_COMMITS=(
# Avoid merge conflict or duplicates with already upstreamed.
	${PATCH_ZEN_SAUCE_BRANDING}
# Disabled ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.
)

PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v6.16...zen-kernel:zen-kernel:6.16/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/a6fa175c7e23941ba2a8fde4254095b077cfb49c^..08d11019f3924f192e1a68d7d2007f8ec7bdf889.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
a6fa175c7e23941ba2a8fde4254095b077cfb49c
fff64147d7411e03ec87ec1f9716fe5795dbdfd1
459a5e391bb4a45420d2423a679f5353c0b5e45f
8f7dbc1fba107ae9369d57f037f876f3ca69e910
bbb5a430ae315840d98fda2561e462829f1182df
bc4a77fd53959912f1cc2a866f5d4be640ce5211
8d22c0c1af988a7dbed31fee2af6ae9e1df4ce15
99d27906c618fb2092ccb42824996bd22724ff80
f6ed65cd7bda9cb6009c6a12efd7c4311df31936
32b4326a7da6c860fbf2f54cee3ef47684d3e69e
8b27c81fbddbde60634661baeb1fd475de32355b
cab7ea1a4ef6685a133ae121ca27098b9dd31287
3d7d0f26977a6d4f6bff2edb4e6388da83789e87
db369c984b7e14f64054fe756c156f2c04b3227a
576a897a4b9558ba70dd35987c24c53d7642f259
77ad4ad132593a5838fa42942f190a1586d166fd
5aa2c66fd59f226e8bbda0aa5628970d38cb2aa4
f7340c5dabce15dd3285d340f952cfb7fb396344
fb5c79d96cc87e4778ac0f2a53bc7c0c23078c54
208f2c37cff2a2bde18adcdd79274254e03fac8d
9d0d6a80618eca3c985f2307971455d6c8ae9fe7
0f5c2376123a8592d9b05167327c67e4cd5e1564
21dd0495958b7c1bd34f2d83537a4f3af5b804c3
413db39ffc2d95bf43fa5690cbf6300f5d5e45bd
eb785518e63a468a6825aca26ca5de7dc1368a3a
b418708702f7927a7922b90871ab1cdf1df9bb94
92850f57d0d3dd0c55a6556f4c4a9afd38da7f8a
e50f640560fcaf14d24142b226cbd7e317cf1f74
e3afdec765f5277bbd3b2196e0facb8b428fb9d2
c7afc157454cc7f09bc57eadf2efed6fb7fd006d
08d11019f3924f192e1a68d7d2007f8ec7bdf889
93372fd9b050a3339f7e6a97b543fd28326ed661
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
# Semi generated from and copy and paste:
# wget -q -O - https://github.com/torvalds/linux/compare/fb5c79d96cc87e4778ac0f2a53bc7c0c23078c54^..c7afc157454cc7f09bc57eadf2efed6fb7fd006d.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
fb5c79d96cc87e4778ac0f2a53bc7c0c23078c54
208f2c37cff2a2bde18adcdd79274254e03fac8d
9d0d6a80618eca3c985f2307971455d6c8ae9fe7 # Not marked interactive, but changes same elevator.c file
0f5c2376123a8592d9b05167327c67e4cd5e1564
21dd0495958b7c1bd34f2d83537a4f3af5b804c3
413db39ffc2d95bf43fa5690cbf6300f5d5e45bd
eb785518e63a468a6825aca26ca5de7dc1368a3a
b418708702f7927a7922b90871ab1cdf1df9bb94
92850f57d0d3dd0c55a6556f4c4a9afd38da7f8a
e50f640560fcaf14d24142b226cbd7e317cf1f74
e3afdec765f5277bbd3b2196e0facb8b428fb9d2
c7afc157454cc7f09bc57eadf2efed6fb7fd006d
08d11019f3924f192e1a68d7d2007f8ec7bdf889
93372fd9b050a3339f7e6a97b543fd28326ed661
)
PPC_FLAGS=(
	cpu_flags_ppc_476fpe
	cpu_flags_ppc_altivec
)
QT5_PV="5.15"
QT6_PV="6.4"
RISCV_FLAGS=(
	+cpu_flags_riscv_rvv
)
declare -A RUST_PV_TO_LLVM_SLOT=(
# Capped by LLVM_COMPAT
	["9999"]="20"
	#["1.86.0"]="19"
	#["1.85.0"]="19"
	["1.84.1"]="19"
	["1.83.0"]="19"
	["1.82.0"]="19"
	["1.81.0"]="18"
	["1.80.1"]="18"
	["1.79.0"]="18"
	["1.78.0"]="18"
)
RUST_SLOTS=(
	"9999" # Needs -Z flags for Rust sanitizers and SSP, otherwise Rust drivers/subsystems has no SSP.
)
RUST_MAX_VER="1.81.1" # Inclusive
RUST_MIN_VER="1.78.0"
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
	cpu_flags_x86_gfni # kernel 6.1, gcc 8, llvm 6
	cpu_flags_x86_pclmul # (CRYPTO_GHASH_CLMUL_NI_INTEL) pclmulqdq - kernel 2.6, gcc 4.4, llvm 3.2 ; 2010
	cpu_flags_x86_sha
	cpu_flags_x86_sha256
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_2 # crc32
	cpu_flags_x86_ssse3
	cpu_flags_x86_tpause # kernel 5.8, gcc 6.5, llvm 7
	cpu_flags_x86_vaes # kernel 6.10
	cpu_flags_x86_vpclmulqdq # (CRYPTO_POLYVAL_CLMUL_NI) vpclmulqdq - kernel 6.0, gcc 8.1, llvm 6 ; 2017
)
ZEN_KV="6.14.0"

if ! [[ "${PV}" =~ "9999" ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
if [[ "${PV}" =~ "9999" ]] ; then
	:
else
IUSE+="
"
fi
# CET default ON based on CI.
# clang is default OFF based on https://github.com/torvalds/linux/blob/v6.16/Documentation/process/changes.rst
# kcfi default OFF based on CI using clang 17.
IUSE+="
${ARM_FLAGS[@]}
${PPC_FLAGS[@]}
${RISCV_FLAGS[@]}
${X86_FLAGS[@]}
bbrv2 bbrv3 build c2tcp +cet +cfs -clang deepcc -debug doc -dwarf4 -dwarf5
-dwarf-auto -exfat -expoline -gdb +genpatches -genpatches_1510 -kcfi -lto nest
orca pgo prjc qt5 qt6 +retpoline rt -rust shadowcallstack symlink tresor tresor_prompt
tresor_sysfs zen-sauce
"

REQUIRED_USE+="
	!prjc
	!zen-sauce
	?? (
		qt5
		qt6
	)
	bbrv2? (
		!bbrv3
	)
	bbrv3? (
		!bbrv2
	)
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

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bbrv2? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v2alpha#license
LICENSE+=" bbrv3? ( || ( GPL-2 BSD ) )" # https://github.com/google/bbr/tree/v3
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
			llvm-core/clang:${s}
			llvm-core/llvm:${s}
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
			=llvm-runtimes/clang-runtime-${s}*[compiler-rt,sanitize]
			=llvm-runtimes/compiler-rt-${s}*:=
			=llvm-runtimes/compiler-rt-sanitizers-${s}*:=[shadowcallstack?]
			llvm-core/clang:${s}
			llvm-core/lld:${s}
			llvm-core/llvm:${s}
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
			=llvm-runtimes/clang-runtime-${s}*
			llvm-core/clang:${s}
			llvm-core/lld:${s}
			llvm-core/llvm:${s}
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
			=llvm-runtimes/clang-runtime-${s}*
			llvm-core/clang:${s}
			llvm-core/llvm:${s}
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
			llvm-core/clang:${s}
			llvm-core/llvm:${s}
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
			llvm-core/clang:${s}
			llvm-core/lld:${s}
			llvm-core/llvm:${s}
		)
		     "
	done
}

gen_clang_debug_zstd_pair() {
	local min=${1}
	local max=${2}
	local usedep="${3}"
	local s
	for s in $(_seq ${min} ${max}) ; do
		echo "
		(
			llvm-core/clang:${s}
			llvm-core/llvm:${s}[zstd]
		)
		     "
	done
}

# It should be llvm 19 but downgraded to 18 based on experience.
#
# The highest GCC version required by KCP was chosen to support the latest CPUs
# without adding too many conditionals or complicating the ebuild with USE flag
# spam.
#
KCP_RDEPEND="
	amd64? (
		!clang? (
			>=sys-devel/gcc-14.1
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

gen_rust_cdepend() {
	local s
	for s in ${RUST_SLOTS[@]} ; do
		local llvm_slot=${RUST_PV_TO_LLVM_SLOT[${s}]}
		echo "
			(
				llvm-core/clang:${llvm_slot}
				llvm-core/llvm:${llvm_slot}
				|| (
					=dev-lang/rust-${s}
					=dev-lang/rust-bin-${s}
				)
			)
		"
	done
}

# KCFI requires https://reviews.llvm.org/D119296 patch
# We can eagerly prune the gcc dep from cpu_flag_x86_* but we want to handle
# both inline assembly (.c) and assembler file (.S) cases.
# The unlabeled debug section below partly refers to zlib compression of debug info.
# CET-IBT: gcc 8.1, llvm 7, binutils 2.27
# CET-SS: gcc 8.1, llvm 6, binutils 2.29
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
	>=sys-devel/binutils-2.30
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=dev-build/make-4.0
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
	cpu_flags_riscv_rvv? (
		!clang? (
			>=sys-devel/binutils-2.38
		)
		clang? (
			$(gen_clang_lld 14 ${LLVM_MAX_SLOT})
		)
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
	cpu_flags_x86_vaes? (
		!clang? (
			>=sys-devel/binutils-2.30
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
		zstd? (
			!clang? (
				>=sys-devel/gcc-13[zstd]
			)
			clang? (
				|| (
					$(gen_clang_debug_zstd_pair 16 ${LLVM_MAX_SLOT})
				)
			)
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
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qtcore-${QT6_PV}:6
		>=dev-qt/qtgui-${QT6_PV}:6
		>=dev-qt/qtwidgets-${QT6_PV}:6
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
		>=dev-util/cbindgen-0.65.1
		>=dev-util/pahole-1.16[${PYTHON_SINGLE_USEDEP}]
		|| (
			$(gen_rust_cdepend)
		)
		|| (
			dev-lang/rust:=
			dev-lang/rust-bin:=
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
		>=sys-kernel/linux-firmware-${AMD_SEV_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${AMDGPU_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${AMDXDNA_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${ATH_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${IVPU_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${RTL8XXXU_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${RTLWIFI_FIRMWARE_RELEASE_DATE}
		>=sys-kernel/linux-firmware-${RTW_FIRMWARE_RELEASE_DATE}
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
if ! [[ "${PV}" =~ "9999" ]] ; then
	RDEPEND+="
		!=sys-kernel/ot-sources-${KV_MAJOR_MINOR}.0.9999
	"
fi

DEPEND+="
	${RDEPEND}
"

BDEPEND+="
	build? (
		${CDEPEND}
	)
	doc? (
		$(python_gen_cond_dep '
			>=dev-python/sphinx-3.4.3[${PYTHON_USEDEP}]
			dev-python/alabaster[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
"
if ! [[ "${PV}" =~ "9999" ]] ; then
	BDEPEND+="
		!=sys-kernel/ot-sources-${KV_MAJOR_MINOR}.0.9999
	"
fi

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

if [[ "${PV}" =~ "9999" && "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${BBRV3_SRC_URIS}
		${NEST_URI}
		${RT_SRC_ALT_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	"
elif [[ "${PV}" =~ "9999" ]] ; then
	SRC_URI+="
		bbrv2? (
			${BBRV2_SRC_URIS}
		)
		bbrv3? (
			${BBRV3_SRC_URIS}
		)
		nest? (
			${NEST_URI}
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
	"
elif [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BBRV2_SRC_URIS}
		${BBRV3_SRC_URIS}
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
		bbrv3? (
			${BBRV3_SRC_URIS}
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
ewarn
ewarn "Upstream backport mitigation:  Grade A"
ewarn "Release quality:  Production ready"
ewarn
	if [[ "${PV}" =~ "9999" ]] ; then
ewarn
ewarn "This ebuild series is a WIP / IN DEVELOPMENT."
ewarn "Expect patchtime failures."
ewarn

ewarn
ewarn "Patches are not ready.  Please disable all patch USE flags for this"
ewarn "series."
ewarn

ewarn
ewarn "You are using the live kernel sources.  This may result in data loss,"
ewarn "data format incompatibilities, or vulnerabilities."
ewarn
ewarn "The live sources is intended for people that want to submit commits or"
ewarn "patches to upstream, to use security fixes, for ebuild maintainers or"
ewarn "modders to smooth out updates before stable."
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
			"${FILESDIR}/tresor-prompt-update-for-6.6-v4_i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-update-for-6.6-v4_aesni.patch"
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
	else
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
		"${FILESDIR}/tresor-add-crypto-header-for-6.6.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-change-to-for_each_process_thread-for-6.6.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-256-for-6.6_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]]  ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-128-for-6.6_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		# Already applied in tresor-drop-xts-and-use-ctr-template-for-5.15_i686.patch
		:
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-use-ecb-cbc-helpers-256-for-6.6_aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-kconfig-crypto-simd-for-6.1.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-access_ok-for-6.6.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		:
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-add-crypto-header-to-tresor_glue-for-6.6_aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-cpuid-aesni-check-for-6.8.patch"
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

	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		# Makefile.rej - skipped extraversion change
		_tpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}" 1 0 ""
		ot-kernel_apply_tresor_fixes

	elif [[ "${path}" =~ "${CLANG_PGO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 5 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/clang-pgo-v9-fixes-for-6.8.1.patch"
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
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-3ff0ac8-fix-for-6.7.4.patch"
	elif [[ "${path}" =~ "bbrv2-${BBRV2_VERSION}-${BBRV2_KV}-c6ef88b.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-fix-for-5.14.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-c6ef88b-use-get_random_u32_below-for-6.2.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-cf9b1da.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-cf9b1da-fix-for-6.3.patch"
	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		if use bbrv3 ; then
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-11-5-orca-c2tcp-0521-bbr3-compat.patch"
		elif use bbrv2 ; then
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-11-5-orca-c2tcp-0521-bbr2-compat.patch"
		else
			_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-6-11-5-orca-c2tcp-0521.patch"
		fi
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-1e924b1.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-1e924b1-fix-for-6.5.2.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-2bab755.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-2bab755-fix-for-6.7.4.patch"
	elif [[ "${path}" =~ "bbrv2-v2alpha-2022-08-28-5.13.12-5ab6f73.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv2-v2alpha-2022-08-28-5.13.12-5ab6f73-fix-for-6.8.1.patch"

	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-9cb2d74.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-9cb2d74-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-c20e56d.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-c20e56d-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-4fef7ac.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-7542cc7-6.4.0-4fef7ac-fix-for-6.8.1.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-a5cc006.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-7542cc7-6.4.0-a5cc006-fix-for-6.8.1.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-40f1ce9.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-40f1ce9-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-aa27c22.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 4 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-aa27c22-fix-for-6.6.0-git-6bc986a.patch"
	elif [[ "${path}" =~ "bbrv3-7542cc7-6.4.0-a1d32ad.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bbrv3-6e321d1-6.4.0-a1d32ad-fix-for-6.6.0-git-6bc986a.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "app-arch/tar" "1.28" ""
	_ot-kernel_check_versions "dev-embedded/u-boot-tools" "2017.01" "" # mkimage
	_ot-kernel_check_versions "dev-util/global" "6.6.5" "" # gtags
	_ot-kernel_check_versions "dev-util/pahole" "1.16" "CONFIG_DEBUG_INFO_BTF"
	_ot-kernel_check_versions "net-dialup/ppp" "2.4.0" "CONFIG_PPP"
	_ot-kernel_check_versions "net-firewall/iptables" "1.4.2" "CONFIG_NETFILTER"
	_ot-kernel_check_versions "net-fs/nfs-utils" "1.0.5" "NFS_FS"
	_ot-kernel_check_versions "sys-apps/gawk" "5.1.0" ""
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
	if [[ "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCP_GRAYSKY2_AMD64} # 18
	elif grep -q -E -e "^CONFIG_HAS_LTO_CLANG=y" "${path_config}" ; then
		_llvm_min_slot=17
	elif grep -q -E -e "^CONFIG_CC_HAS_RANDSTRUCT=y" "${path_config}" ; then
		_llvm_min_slot=16
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_COMPRESSED_ZSTD=y" "${path_config}" ; then
		_llvm_min_slot=16
	elif grep -q -E -e "^CONFIG_RUST=y" "${path_config}" ; then
		_llvm_min_slot=16
	elif grep -q -E -e "^CONFIG_CFI_CLANG=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_ARM64} # 16
	elif grep -q -E -e "^CONFIG_CFI_CLANG=y" "${path_config}" && [[ "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCFI_AMD64} # 16
	elif grep -q -E -e "^CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_CPU_BIG_ENDIAN=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF4=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF5=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_MITIGATION_SLS=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif grep -q -E -e "^CONFIG_UNWIND_PATCH_PAC_INTO_SCS=y" "${path_config}" && [[ "${arch}" == "arm64" ]] ; then
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
	elif grep -q -E -e "^CONFIG_RISCV_ISA_V=y" "${path_config}" && [[ "${arch}" == "riscv" ]] ; then
		_llvm_min_slot=14
	elif grep -q -E -e "^CONFIG_X86_KERNEL_IBT=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=14
	elif has cpu_flags_arm_pac ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_arm_pac && [[ "${auth}" == "arm64" ]] ; then
		_llvm_min_slot=14
	elif ot-kernel_use pgo ; then
		_llvm_min_slot=${LLVM_MIN_PGO} # 13
	else
		_llvm_min_slot=${LLVM_MIN_SLOT} # 13
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
	if [[ "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_AMD64} # 14
	elif grep -q -E -e "^CONFIG_DEBUG_INFO_COMPRESSED_ZSTD=y" "${path_config}" ; then
		_gcc_min_slot=13
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
	elif grep -q -E -e "^CONFIG_MITIGATION_SLS=y" "${path_config}" && [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
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
		_gcc_min_slot=9 # CET-IBT
	elif has cpu_flags_arm_pac ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_arm_pac && [[ "${auth}" == "arm64" ]] ; then
		_gcc_min_slot=9
	elif has cpu_flags_x86_tpause ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_x86_tpause ; then
		_gcc_min_slot=9
	elif grep -q -E -e "^CONFIG_KASAN_GENERIC=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_UBSAN_SIGNED_WRAP=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_X86_USER_SHADOW_STACK=y" "${path_config}" && [[ "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=8 # CET-SS
	elif ot-kernel_use cpu_flags_x86_vpclmulqdq ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_MITIGATION_RETPOLINE=y" "${path_config}" ; then
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

	# TODO:
	# The dev-libs/gdrcopy ebuild needs the max gcc version capped at the
	# max allowed gcc for the nvidia-cuda-toolkit ebuild.  This will
	# interfere with the mitigations which need also a minimum gcc version
	# for compiler mitigation flags.  We can make the user decide to go the
	# max compatibility route or security route with environment variable
	# similar to ot-kernel-pkgflags.  This cap is to avoid symbol issue.

	# The same goes with external modules.  Certain external modules require
	# maximum gcc version.
	#
	# This issue applies to:
	# sys-kernel/pcc
	# sys-cluster/knem
	# sys-cluster/xpmem

	# Ascending sort
	if grep -q -E -e "^CONFIG_ARCH_RPC=y" "${path_config}" && [[ "${arch}" == "arm" ]] ; then
		_gcc_max_slot=8
	elif grep -q -E -e "^CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC=y" "${path_config}" && [[ "${arch}" == "riscv" ]] ; then
		_gcc_max_slot=10
	else
		_gcc_max_slot=${GCC_MAX_SLOT} # 14
	fi
	echo "${_gcc_max_slot}"
}
