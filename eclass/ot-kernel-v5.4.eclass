# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.4.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 5.4.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.4 eclass defines specific applicable patching for the 5.4.x
# linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v5.4/Documentation/process/changes.rst

# To update the array sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

# PV is for 9999 (live) context check
MY_PV="${PV}" # ver_test context
# Based on AMD GPU firmware names from
# https://elixir.bootlin.com/linux/v5.4.299/source/drivers/gpu/drm/amd/display/include/dal_types.h	DCN 2.1.0
# https://elixir.bootlin.com/linux/v5.4.299/source/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c		navi12_vcn
# and linux-firmware firmware upload date
KERNEL_RELEASE_DATE="20200824" # Based on navi12 vcn first presence
# Initially, the required firmware date was thought to be feature complete and in
# sync with the kernel driver on the release date of the kernel.  It is not the
# case.  Because of many reasons (code review sabateurs, job security, marketing
# product leak, last minute bugs, release scheduling), this firmware(s)
# supporting the latest hardware or the microarchitectures listed in the driver
# may be delayed.
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
	+cpu_flags_arm_lse # 8.1
	cpu_flags_arm_neon
	+cpu_flags_arm_pac # 8.3-A
)

C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_MAJOR_VER="2"
C2TCP_VER="2.2"

CK_COMMITS_BLACKLISTED_COMMITS=(
# Avoid merge conflict or duplicates with already upstreamed.
5b6cd7cfe6cf6e1263b0a5d2ee461c8058b76213 # -ck1 extraversion
)

CK_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.4...ckolivas:5.4-ck
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/7acac2e4000e75f3349106a8847cf1021651446b^..5b6cd7cfe6cf6e1263b0a5d2ee461c8058b76213.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
7acac2e4000e75f3349106a8847cf1021651446b
36d5e8df1fead191fa6fe9e83fcdfc69532238f2
8e6e0d9402f93bb4759f89c0f01ec03cbefe5efa
6d1555691d16804bb16d61f16996692f50bc1374
ea1ace768425220e605f405f36560a4a6d2b0859
7012590838d45aa3b6c6833bb0e1f624c5fcaaea
688c8d0716e6598dd7c25c89d4699704a3337bd5
e907c530c3d52bb212ebe09efba6b78a2ff393a6
96cf984e774168908dc1b67b052a7a8afd62cb3b
33b744fc53a49695b73d2f54868b72ea83b6809e
07b17741bbe52aa1660dfde672540375bea92d2a
aa88bb077c4091cc11481585b6579919c2b01210
87dd1d82e1df3f3809fe39614061a33b01e5d6f0
32d7185a9368c7ff9e79cbedd1c8ff03298340a4
1b7439521c9c12fbae47b827f51970b65e3357f1
5b6cd7cfe6cf6e1263b0a5d2ee461c8058b76213
)
CK_KV="5.4.0"

CXX_STD="-std=gnu++11" # See https://github.com/torvalds/linux/blob/v5.4/tools/build/feature/Makefile#L318
DISABLE_DEBUG_PV="1.4.2"
EXTRAVERSION="-ot"
GENPATCHES_BLACKLIST=" 2400"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
GCC_PV="4.6"
GCC_COMPAT=( {13..4} )
GCC_MAX_SLOT=${GCC_COMPAT[0]}
GCC_MIN_SLOT=${GCC_COMPAT[-1]}
GCC_SLOT_NOT_KCP=( ${GCC_COMPAT[@]} ) # Without kernel-compiler-patch
GCC_SLOT_KCP="${GCC_COMPAT[0]}" # With kernel-compiler-patch
GCC_MIN_KCP_GENPATCHES_AMD64=11
GCC_MIN_KCP_GRAYSKY2_AMD64=11
GCC_MIN_KCP_GRAYSKY2_ARM64=5
GCC_MIN_KCP_ZEN_SAUCE_AMD64=9
KMOD_PV="13"
LLVM_COMPAT=( {18..10} )
LLVM_MAX_SLOT=${LLVM_COMPAT[0]}
LLVM_MIN_SLOT=${LLVM_COMPAT[-1]}
LLVM_MIN_KCFI_ARM64="not supported"
LLVM_MIN_KCFI_AMD64="not supported"
LLVM_MIN_KCP_GENPATCHES_AMD64=12
LLVM_MIN_KCP_GRAYSKY2_AMD64=12
LLVM_MIN_KCP_GRAYSKY2_ARM64=3
LLVM_MIN_KCP_ZEN_SAUCE_AMD64="not supported"
LLVM_MIN_LTO="not supported"
LLVM_MIN_PGO="not supported"
LLVM_MIN_PGO_S390="not supported"
LLVM_MIN_SHADOWCALLSTACK_ARM64="not supported"
MUQSS_VER="0.196"

PATCH_ALLOW_O3_COMMIT="4edc8050a41d333e156d2ae1ed3ab91d0db92c7e" # id from zen repo
PATCH_KCP_COMMIT="cbf238bae1a5132b8b35392f3f3769267b2acaf5" # id from zen repo ; aka more-uarches
PATCH_TRESOR_VER="3.18.5"
PATCH_ZEN_SAUCE_BRANDING="1baa02fbd7a419fdd0e484ba31ba82c90c7036cf" # id from zen repo

PATCH_ZEN_SAUCE_BLACKLISTED_COMMITS=(
	${PATCH_ZEN_SAUCE_BRANDING}
	56f6f4315aedbbcbef8ad61f187347c20a270e49 # ZEN: Add a choice of boot logos [permissions issue and conflicts with logo patch]
)

PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.4...zen-kernel:zen-kernel:5.4/zen-sauce
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/1baa02fbd7a419fdd0e484ba31ba82c90c7036cf^..376d7ed3c04b5576fe753c0dbe588a423c8be9c3.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
1baa02fbd7a419fdd0e484ba31ba82c90c7036cf
ef12d902c1323bbbeacc3babc91aae15976474ca
56f6f4315aedbbcbef8ad61f187347c20a270e49
e4afee68d66b61cfd0bdabe937a0e0eb1cea5844
a1ced5e49a5044e14f4b46e7db2ff4a5afe92118
e92e67143385cf285851e12aa8b7f083dd38dd24
f75e102a6ad92d8acb4354895a799d3a60193990
ee18749616cbf6ff69de3fc9147737bd021aa519
304fc592677954ea3028109e4ebd66408da8f7d6
cbf238bae1a5132b8b35392f3f3769267b2acaf5
4edc8050a41d333e156d2ae1ed3ab91d0db92c7e
cba81e70bf716d85151dd20fb4fd001517c98579
3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0
92f669d8f5542fe3981115706a7b9066a0903b4a
c9a8f36311f14311a3202501c88009f758683c0f
90dd01794267f5713bf98910c691f01e00debc4b
e6e7b853433c818466bdb54263fe5333b141c0af
7e92cd42bc8f1bdc7b7eaa7d66db53e624c694e8
15ec264afa9883c6bd3032b1a3af63da502a215e
d28734240cb56a0efb60b13ecd7f33141da41314
f6b72de6bd17972cee50c4ce97b67954048833de
a7c2e93c81a96375414db26fdd18cb9fae8421b9
376d7ed3c04b5576fe753c0dbe588a423c8be9c3
)

# top is oldest, bottom is newest
# TODO: Split patch like in newer versions
PATCH_ZEN_TUNE_COMMITS=(
# Generated by copy+paste.
3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0
)

# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
# commits [oldest] a b c d e... [newest]
# b:a
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE=(
c9a8f36311f14311a3202501c88009f758683c0f:3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0
) # \
# ZEN: Add CONFIG to rename the mq-deadline scheduler (c9a8f36) requires \
# ZEN: Implement zen-tune v5.4 (3e05ad8)

# For 5.4
PATCH_ZEN_MUQSS_COMMITS=(
# From https://github.com/torvalds/linux/compare/v5.4...zen-kernel:zen-kernel:5.4/muqss
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/7acac2e4000e75f3349106a8847cf1021651446b^..45589d24eea4cdfe59e87a65389fd72d91f43bf0.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
7acac2e4000e75f3349106a8847cf1021651446b
#50955efefbe23a4270faca36a99999b76d2dc4db # Same as 7acac2e
c73934ea38cffac75c43ea4fd9f67100e82d8ea2
be525d11c201565e2c8999efc3f78c745f5d6886
6c26d7bda791335dc0bf7b401c1cecad359b1a15
86df8beb7c996a985f11b20bf4bb84419f491297
c9a70eeacf3fc0d62fe3027bf57eff737015b23b
696ba980602e5c099e7e19b49e18bceeb5eec1e8
c181de6e33ad80ca524a3379ac2c68d3872b481b
2896b534ad8eaa904a9887080829c84a82a1a6b5
1342bc5878c7640cc04117e010f005bac0873b78
6c8fd1641dea5418c68dad4bf48d2d128a2a13e5
f4fea36124c5f81e91cdcd9e91fc1758b1e98dfc
9c0ad2b62cb6ab19b5c610e37a3d38770b0b0207
59f2b3e40d8cd3569be0e72bfa855a53398f4400
880a7229b3627f9933d30f847da350e1ff53ba2d
dce8f01fd3d28121e3bf215255c5eded3855e417
3ca137b68d689fcb1c5cadad1416c7791d84d48e
530963db1905c4de80985b947858b391e1d363e7
d1bebeb959a56324fe436443ea2f21a8391632d9
45589d24eea4cdfe59e87a65389fd72d91f43bf0
)
PATCH_ZEN_MUQSS_EXCLUDED_COMMITS=(
)
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
	cpu_flags_x86_pclmul # (CRYPTO_GHASH_CLMUL_NI_INTEL) pclmulqdq - kernel 2.6, gcc 4.4, llvm 3.2 ; 2010
	cpu_flags_x86_sha
	cpu_flags_x86_sha256
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_2 # crc32
	cpu_flags_x86_ssse3
)
ZEN_KV="5.4.0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
# clang is default OFF based on https://github.com/torvalds/linux/blob/v5.4/Documentation/process/changes.rst
IUSE+="
${ARM_FLAGS[@]}
${PPC_FLAGS[@]}
${X86_FLAGS[@]}
bmq build c2tcp +cfs -clang deepcc -debug doc -dwarf4 -expoline -gdb +genpatches
-genpatches_1510 muqss orca pgo qt5 +retpoline rock-dkms rt symlink tresor
tresor_prompt tresor_sysfs uksm zen-muqss zen-sauce
"

REQUIRED_USE+="
	dwarf4? (
		debug
		gdb
	)
	expoline? (
		!clang
		s390
	)
	gdb? (
		debug
		dwarf4
	)
	tresor_prompt? (
		tresor
	)
	tresor_sysfs? (
		tresor
	)
"

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bmq? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" c2tcp? ( MIT )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" orca? ( MIT )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no default license
	#   found in the project.  (The implementation is based on an academic paper
	#   from public universities.)
LICENSE+=" zen-muqss? ( GPL-2 )"
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

#
# The highest GCC version required by KCP was chosen to support the latest CPUs
# without adding too many conditionals or complicating the ebuild with USE flag
# spam.
#
KCP_RDEPEND="
	amd64? (
		!clang? (
			>=sys-devel/gcc-11.1
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

# We can eagerly prune the gcc dep from cpu_flag_x86_* but we want to handle
# both inline assembly (.c) and assembler file (.S) cases.
#
# We add more binutils/llvm/gcc checks because the distro and other popular
# overlays don't delete their older ebuilds.
#
CDEPEND+="
	${KCP_RDEPEND}
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.21
	>=sys-devel/bison-2.0
	>=sys-devel/flex-2.5.35
	>=dev-build/make-3.81
	app-arch/cpio
	app-shells/bash
	dev-util/pkgconf
	sys-apps/grep[pcre]
	virtual/libelf
	virtual/pkgconfig
	bzip2? (
		app-arch/bzip2
	)
	cpu_flags_arm_lse? (
		>=sys-devel/binutils-2.25
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
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
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
	pgo? (
		sys-devel/binutils[static-libs]
		sys-libs/libunwind[static-libs]
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
	xz? (
		>=sys-apps/kmod-${KMOD_PV}[lzma]
		app-arch/xz-utils
	)
	zstd? (
		>=sys-apps/kmod-${KMOD_PV}[zstd]
		app-arch/zstd
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
	doc? (
		$(python_gen_cond_dep '
			>=dev-python/sphinx-1.3[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
"

PDEPEND+="
	rock-dkms? (
		|| (
			~sys-kernel/rock-dkms-5.6.1
			~sys-kernel/rock-dkms-5.5.1
			~sys-kernel/rock-dkms-5.4.3
			~sys-kernel/rock-dkms-5.3.3
			~sys-kernel/rock-dkms-5.2.3
			~sys-kernel/rock-dkms-5.1.3
		)
	)
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

if [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BMQ_SRC_URI}
		${C2TCP_URIS}
		${CK_SRC_URIS}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${GENPATCHES_URI}
		${O3_ALLOW_SRC_URI}
		${RT_SRC_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${UKSM_SRC_URI}
		${ZEN_MUQSS_SRC_URIS}
		${ZEN_SAUCE_URIS}
	"
else
	SRC_URI+="
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${O3_ALLOW_SRC_URI}
		bmq? (
			${BMQ_SRC_URI}
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
		muqss? (
			${CK_SRC_URIS}
		)
		orca? (
			${C2TCP_URIS}
		)
		rt? (
			${RT_SRC_URI}
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
		zen-muqss? (
			${ZEN_MUQSS_SRC_URIS}
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
ewarn "Upstream backport mitigation:  Grade F (incomplete coverage)"
ewarn "Release quality:  For recovery purposes only.  Use >= 6.6 series for production."
ewarn
	if use genpatches ; then
ewarn
ewarn "genpatches is EOL (End of Life) for the ${KV_MAJOR_MINOR} series."
ewarn
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
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-wait-fix-for-5.4-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-wait-fix-for-5.4-aesni.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-i686-v2.6.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.4.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.2-for-5.4.patch"
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

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-glue-helper-in-kconfig.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-xts-setkey-5.4-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-xts-setkey-5.4-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-explicit-int-dont_switch-arg-for-6.1.patch"

	if [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-access_ok-5.4_aesni.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-cpuid-aesni-check-for-5.4.patch"
	fi


	if [[ "${tresor_patch_target}" == "x86_64_generic_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-256-5.4_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.4_x86_64.patch"
	elif [[ "${tresor_patch_target}" == "x86_generic_128" ]] ; then
	# Patch reuse was tested okay.
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-preprocessor-cond-changes-for-128-5.4_x86_64.patch"
	#elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
	#	Only 64-bit X86 supported.
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
	if use muqss ; then
ewarn
ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL and"
ewarn "Idle dynticks system (tickless idle) CONFIG_NO_HZ_IDLE may cause the"
ewarn "system to lock up."
ewarn
ewarn "You must choose Periodic timer ticks (constant rate, no dynticks)"
ewarn "  CONFIG_HZ_PERIODIC for it not to lock up."
ewarn
	fi
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
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex and futex2

	if [[ "${path}" =~ "${BMQ_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/bmq_v5.4-r2-fix-for-5.4.256.patch"

	elif [[ "${path}" =~ "ck-0.196-5.4-7acac2e.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.196-5.4-33b744f.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"

	elif [[ "${path}" =~ "0148-rtmutex-Handle-the-various-new-futex-race-conditions.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0059-locking-percpu-rwsem-Remove-the-embedded-rwsem.patch" ]] ; then
		# This patch belongs to the -rt patchset.
		# Skipping 1 already applied hunk.
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""

	elif [[ "${path}" =~ "${O3_ALLOW_FN}" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"

	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPTS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes

	elif [[ "${path}" =~ "${UKSM_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/uksm-5.4-rebase-for-5.4.147.patch"

	elif [[ "${path}" =~ "zen-muqss-${ZEN_KV}-7acac2e.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "zen-muqss-${ZEN_KV}-c181de6.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "zen-muqss-${ZEN_KV}-530963d.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "zen-sauce-${ZEN_KV}-4edc805.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-5.4-4edc805-fix.patch"
	elif [[ "${path}" =~ "zen-muqss-5.4.0-50955ef.patch" ]] ; then
		: # Skipped already applied

	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-5-4-272-orca-c2tcp-0521.patch"
	elif [[ "${path}" =~ "zen-sauce-5.4.0-e4afee6.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-4.19.0-7ab867e-fix-for-4.19.294.patch"
	elif [[ "${path}" =~ "zen-sauce-5.4.0-376d7ed.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-5.4.0-376d7ed-fix-for-5.4.256.patch"
	elif [[ "${path}" =~ "zen-muqss-5.4.0-86df8be.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-muqss-5.4.0-86df8be-fix-for-5.4.256.patch"
	elif [[ "${path}" =~ "zen-sauce-5.4.0-3e05ad8.patch" ]] ; then
		if ot-kernel_use bmq ; then
			_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
			_dpatch "${PATCH_OPTS}" \
				"${FILESDIR}/zen-sauce-5.4.0-3e05ad8-compat-with-bmq-v5.4-r2-for-5.4.256.patch"
		else
			_dpatch "${PATCH_OPTS}" "${path}"
		fi
	elif [[ "${path}" =~ "zen-sauce-5.4.0-7e92cd4.patch" ]] ; then
		if ot-kernel_use bmq ; then
			: # Patch for MuQSS only
		else
			_dpatch "${PATCH_OPTS}" "${path}"
		fi

	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: ot-kernel_filter_genpatches_blacklist_cb
# @DESCRIPTION:
# Filter
ot-kernel_filter_genpatches_blacklist_cb() {
	if \
		   ver_test $(ver_cut 1-3 "${MY_PV}") -eq "5.4.85" \
		&& ver_test "${GENPATCHES_VER}"    -eq "87" \
	; then
		echo "2400"
	else
		echo ""
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "dev-util/oprofile" "0.9" "CONFIG_OPROFILE"
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

	if ot-kernel_use pgo && [[ "${arch}" == "s390" ]] ; then
		die "Clang PGO is not supported for this series.  Disable either the clang or pgo USE flag."
	fi
	if ot-kernel_use pgo ; then
		die "Clang PGO is not supported for this series.  Disable either the clang or pgo USE flag."
	fi
	if has kcfi ${IUSE_EFFECTIVE} && [[ "${OT_KERNEL_SECURITY_CRITICAL_TYPES}" =~ "kcfi" ]] && [[ "${arch}" == "arm64" ]] ; then
		die "KCFI is not supported for this series.  Disable the kcfi USE flag."
	fi
	if has kcfi ${IUSE_EFFECTIVE} && [[ "${OT_KERNEL_SECURITY_CRITICAL_TYPES}" =~ "kcfi" ]] && [[ "${arch}" == "x86_64" ]] ; then
		die "KCFI is not supported for this series.  Disable the kcfi USE flag."
	fi
	if has lto ${IUSE_EFFECTIVE} && ot-kernel_use lto ; then
		die "LTO is not supported for this series.  Disable the lto USE flag."
	fi
	if has shadowcallstack ${IUSE_EFFECTIVE} && ot-kernel_use shadowcallstack && [[ "${arch}" == "x86_64" ]] ; then
		die "ShadowCallStack is not supported for this series.  Disable the shadowcallstack USE flag."
	fi

	if tc-is-clang && [[ "${kcp_provider}" =~ "zen-sauce" ]] ; then
eerror
eerror "The kernel_compiler_patch was not released for llvm for this series of genpatches."
eerror "OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER needs to be updated."
eerror
		die
	fi

	# Descending sort
	if grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF4=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif [[ "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_llvm_min_slot=${LLVM_MIN_KCP_GRAYSKY2_AMD64} # 12
	else
		_llvm_min_slot=${LLVM_MIN_SLOT} # 10
	fi
	echo "${_llvm_min_slot}"
}

# @FUNCTION: ot-kernel_get_gcc_min_slot
# @DESCRIPTION:
# Get the inclusive min slot for gcc
ot-kernel_get_gcc_min_slot() {
	local _gcc_min_slot
	local kcp_provider=$(ot-kernel_get_kcp_provider)

	local wants_kcp_rpi=0
	if [[ "${CFLAGS}" =~ "-mcpu=cortex-a72" ]] ; then
		wants_kcp_rpi=1
	fi

	# Descending sort
	if grep -q -E -e "^CONFIG_DEBUG_INFO_SPLIT=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_INIT_STACK_ALL_ZERO=y" "${path_config}" ; then
	# Prevent:
	# <redacted>-pc-linux-gnu-gcc-11: error: unrecognized command-line option '-ftrivial-auto-var-init=zero'
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_KCOV=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif [[ "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_AMD64} # 11
	elif grep -q -E -e "^CONFIG_KASAN_SW_TAGS=y" "${path_config}" ; then
		_gcc_min_slot=11
	elif [[ "${kcp_provider}" =~ "zen-sauce" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=${GCC_MIN_KCP_ZEN_SAUCE_AMD64} # 9
	elif grep -q -E -e "^CONFIG_KASAN_GENERIC=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_RETHUNK=y" "${path_config}" ; then
		_gcc_min_slot=8
	elif grep -q -E -e "^CONFIG_RETPOLINE=y" "${path_config}" ; then
		_gcc_min_slot=7
	elif (( ${wants_kcp_rpi} == 1 )) ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_ARM64} # 5
	elif has cpu_flags_x86_avx512vl ${IUSE_EFFECTIVE} && ot-kernel_use cpu_flags_x86_avx512vl ; then
		_gcc_min_slot=5
	else
		_gcc_min_slot=${GCC_MIN_SLOT} # 4
	fi
	echo "${_gcc_min_slot}"
}

# @FUNCTION: ot-kernel_get_llvm_max_slot
# @DESCRIPTION:
# Get the inclusive max slot for llvm
ot-kernel_get_llvm_max_slot() {
	local _llvm_max_slot

	# Ascending sort
	_llvm_max_slot=${LLVM_MAX_SLOT} # 18
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
	_gcc_max_slot=${GCC_MAX_SLOT} # 13
	echo "${_gcc_max_slot}"
}
