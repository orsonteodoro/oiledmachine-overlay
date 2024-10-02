# Copyright 2019-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v4.19.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the 4.19.x kernel
# @DESCRIPTION:
# The ot-kernel-v4.19 eclass defines specific applicable patching for the
# 4.19.x linux kernel.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# For *DEPENDs, see
# https://github.com/torvalds/linux/blob/v4.19/Documentation/process/changes.rst

# To update the array sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

# PV is for 9999 (live) context check
MY_PV="${PV}" # ver_test context
KERNEL_RELEASE_DATE="20220731" # of first stable release
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
)

C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_MAJOR_VER="2"
C2TCP_VER="2.2"

# ck notes: \
# 811cb39 -> a79d648 is about the same as 24da54e \
# a17a37f, 8faec5c -> 721f586 is about the same as 78f8617

CK_COMMITS_BLACKLISTED_COMMITS=(
# Avoid merge conflicts or duplicates with already upstreamed.
da178919d63ecfec2738877abae02cd2ce8aa29c # -ck1 extraversion
)
CK_COMMITS=(
# From https://github.com/torvalds/linux/compare/v4.19...ckolivas:4.19-ck
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/dc988b5f353c28a846da592e31b504c32d95ed5e^..da178919d63ecfec2738877abae02cd2ce8aa29c.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
dc988b5f353c28a846da592e31b504c32d95ed5e
ba77544e4687e62fe9d8ca870ceb47ea87d1cbfe
2432d1de7128e6ac986749bc52eb30c4c1c654d0
d67d0504370871bea9e73c69c840fb3d0a88d9cb
552f25751a108c7e185b82aa3110d43bfe1e59b1
65ea992f1da66b8c0a5554776d1350417b9107cb
7b74daf29a88f3314af306509bd40d45c34f11c7
8a679ba5279cbff1a8e4c47b55ac4bd6d66289f8
cd03bffabeee4f4c8438969b3b4d184d0d0bb81b
ba3f464ce9dd28a8999f56b327b458f869258a1a
befdee72d814b6c302da85af524b15762e72e0cf
9ddcf0d8c14d64c57fe5ecf2a7e668e68a3d842b
df4136f6de5b3f45c2f4be7a3cc042903e983e0c
ace3d66508ad4e17da3f579eaf04c5582b8256a2
d8f6f203f5bdabdf1a5ddb6bdc9e13fae2b640b9
da178919d63ecfec2738877abae02cd2ce8aa29c
)
CK_KV="4.19.0"

CXX_STD="-std=gnu++14" # See https://github.com/torvalds/linux/blob/v5.19/tools/build/feature/Makefile#L318
DISABLE_DEBUG_PV="1.4.2"
EXTRAVERSION="-ot"
GCC_PV="4.6"
GCC_COMPAT=( {13..4} )
GCC_MAX_SLOT=${GCC_COMPAT[0]}
GCC_MIN_SLOT=${GCC_COMPAT[-1]}
GCC_MIN_KCP_GENPATCHES_AMD64=11
GCC_MIN_KCP_GRAYSKY2_AMD64=11
GCC_MIN_KCP_GRAYSKY2_ARM64=5
GCC_MIN_KCP_ZEN_SAUCE_AMD64="not supported"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
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
MUQSS_VER="0.180"
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_PDS_VER="${PATCH_PDS_VER:-099h}"
PATCH_TRESOR_VER="3.18.5"
PATCH_ZEN_SAUCE_BRANDING="c340c84b774aee3eda9a818fc4c0dc6a46a2c83d" # id from zen repo

# Avoid merge conflicts.
# BFQ is not made default
# BL = Blacklisted
PATCH_ZEN_SAUCE_BLACKLISTED_COMMITS=(
	${PATCH_ZEN_SAUCE_BRANDING}
	# ZEN: Add a choice of boot logos [permissions issue and conflicts with logo patch] \
	bec5c50bb387f4c4956fc4553d2c6491363b1489
)

PATCH_ZEN_SAUCE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v4.19...zen-kernel:zen-kernel:4.19/misc
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/c340c84b774aee3eda9a818fc4c0dc6a46a2c83d^..face163a2ef728af8ed4d4923b56711ff882b350.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
c340c84b774aee3eda9a818fc4c0dc6a46a2c83d
beecc486dbe2bf08033ebe3183245b82ced26cc2
bec5c50bb387f4c4956fc4553d2c6491363b1489
7ab867e328af68deda133c44d7a788d03148d039
85301de35c719b25323d924f4afe3a0c1d37fa85
ceb4173d278282f68eaa25e33660404431ce09f4
9bee6d9300487ed3593feadc074e52ca26dba0ed
61b2705ca0533311aa35fa9ddaa098214eb071e6
c53ae690ee282d129fae7e6e10a4c00e5030d588
7d0295dc49233d9ddff5d63d5bdc24f1e80da722
562a14babcd56efc2f51c772cb2327973d8f90ad
dd59878702406214a858b96541484cb815017ba3
efae3c117386b0d0c4aebac980be40f8d9d643ec
b548c75351fddf33a7b2b93b0c04d5698583d938
0b9aaee6f3c154c641a51fe85c1fdc6a43e99085
fd4645c2e1ad2c6e478f6ff92be5ec559130ed9f
e3cac2b4fbe70c670966818b67f4b6fbdb6e66f5
170b2e90d7a511364ebb151f57cd101828833d4c
1a6fe347cb588521e221de8966551564a80f202c
face163a2ef728af8ed4d4923b56711ff882b350
)

# This is a list containing elements of LEFT_ZEN_COMMIT:RIGHT_ZEN_COMMIT.  Each
# element means that the left commit requires right commit which can be
# resolved by adding the right commit to ZEN_SAUCE_WHITELIST.
# commits [oldest] a b c d e... [newest]
# b:a
PATCH_ZEN_TUNE_COMMITS_DEPS_ZEN_SAUCE="
"

# ancestor ~ oldest, descendant ~ newest
PATCH_ZEN_TUNE_COMMITS=(
# From https://github.com/torvalds/linux/compare/v4.19...zen-kernel:zen-kernel:4.19/zen-tune
#
# Generated from:
# wget -q -O - https://github.com/torvalds/linux/compare/05d2f46ed42ca12307b9c792e00d02e14e87d2d1^..78fb15ac04bff56dfeb0b6fe692fb6e0ccf4e56b.patch \
#        | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
05d2f46ed42ca12307b9c792e00d02e14e87d2d1
640a5eade4fd32d1fa2e1532c5a08dc8ec89be27
6081521f7fc834e289d855d7091aea32d384314e
460fcdd471488ad74772bbbf85f6394ca159463c
15d385b63181948205a846c5136060c6d1acfe9d
51fea0a233c2b4d7e36ff2c8f6a523791571e798
10fb7ff8ab73879cd51b889d3878f1af43742701
9cc1a07a280cd48e3985fcec4cc407aef5e47aa1
646892330bc8ec470f9bf8f84258cb1041edccaa
f3c6cb010527051e39b341e2859d8239cc0cd413
f468511a824c557ced1be2fed1b4ba923a067bcc
3bf7a408c5f4e6bcd08cb2f2308500fdc32f257f
59617f4466958b9031ccf51946f004f9ef8f6f0d
78fb15ac04bff56dfeb0b6fe692fb6e0ccf4e56b
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
	cpu_flags_x86_avx512bw # raid6
	cpu_flags_x86_pclmul # (CRYPTO_GHASH_CLMUL_NI_INTEL) pclmulqdq - kernel 2.6, gcc 4.4, llvm 3.2 ; 2010
	cpu_flags_x86_sha
	cpu_flags_x86_sha256
	cpu_flags_x86_sse2
	cpu_flags_x86_sse4_2 # crc32
	cpu_flags_x86_ssse3
)
ZEN_KV="4.19.0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
# clang is default OFF based on https://github.com/torvalds/linux/blob/v4.19/Documentation/process/changes.rst
IUSE+="
${ARM_FLAGS[@]}
${PPC_FLAGS[@]}
${X86_FLAGS[@]}
build c2tcp +cfs -clang deepcc -debug -dwarf4 -expoline +genpatches -gdb
-genpatches_1510 muqss orca pds pgo qt5 +retpoline rt symlink tresor tresor_prompt
tresor_sysfs uksm zen-sauce
"
REQUIRED_USE+="
	dwarf4? (
		debug
		gdb
	)
	expoline? (
		s390? (
			!clang
		)
	)
	gdb? (
		debug
		dwarf4
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

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patches
LICENSE+=" c2tcp? ( MIT )"
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" deepcc? ( MIT )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" orca? ( MIT )"
LICENSE+=" pds? ( GPL-3 )" # \
	# See https://gitlab.com/alfredchen/PDS-mq/-/blob/master/LICENSE
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no default license
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
	>=sys-devel/binutils-2.20
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
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${C2TCP_URIS}
		${CK_SRC_URIS}
		${GENPATCHES_URI}
		${PDS_SRC_URI}
		${RT_SRC_URI}
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${UKSM_SRC_URI}
		${ZEN_SAUCE_URIS}
	"
else
	SRC_URI+="
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
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
		pds? (
			${PDS_SRC_URI}
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
			${TRESOR_SYSFS_SRC_URI}
			${TRESOR_README_SRC_URI}
			${TRESOR_RESEARCH_PDF_SRC_URI}
		)
		uksm? (
			${UKSM_SRC_URI}
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
	# TRESOR for x86_64 generic was known to pass crypto testmgr on this
	# version.
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
	elif [[ "${arch}" == "x86_64" ]] && [[ "${TRESOR_MAX_KEY_SIZE}" == "128" ]]  ; then
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

	local fuzz_factor=0
	[[ "${path}" =~ "${TRESOR_AESNI_FN}" ]] && fuzz_factor=3
        _dpatch "${PATCH_OPTS} -F ${fuzz_factor}" \
		"${FILESDIR}/tresor-testmgr-linux-4.19.306.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-wait-fix-for-4.19-i686.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-prompt-wait-fix-for-4.19-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-4.14.patch"

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-i686-v2.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-aesni-v2.patch"
	fi

	if [[ "${tresor_patch_target}" == "x86_64_generic_256" || "${tresor_patch_target}" == "x86_64_generic_128" || "${tresor_patch_target}" == "x86_generic_128" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-4.14.patch"
	elif [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-testmgr-show-passed-for-linux-4.14.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-glue-helper-in-kconfig.patch"
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-explicit-int-dont_switch-arg-for-6.1.patch"

	if [[ "${tresor_patch_target}" == "x86_64_aesni_256" ]] ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-access_ok-4.19_aesni.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-cpuid-aesni-check-for-4.19.patch"
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
ot-kernel_pkg_postinst_cb() {
	if use muqss ; then
ewarn
ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will"
ewarn "cause a kernel panic on boot."
ewarn
ewarn "Using CONFIG_FORCE_IRQ_THREADING may halt the boot process when showing"
ewarn "loading initial ramdisk."
ewarn
ewarn "Expect several seconds of pause at loading initial ramdisk when booting."
ewarn
	fi
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

	if [[ "${path}" =~ "ck-0.162-${CK_KV}-fbc0b45.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/ck-0.162-4.14-fbc0b45-2-hunk-fix-for-4.14.246.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/ck-0.162-4.14-fbc0b45-build-time-fixes-for-4.14.213.patch"
	elif [[ "${path}" =~ "ck-0.162-${CK_KV}-ff1ab75.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.162-${CK_KV}-071486d.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.162-${CK_KV}-24da54e.patch" ]] ; then
		# -N is used to skip the duplicate hunks
		_tpatch "${PATCH_OPTS} -N" "${path}" 0 1 ""
	elif [[ "${path}" =~ "ck-0.180-4.19.0-dc988b5.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.180-4.19.0-dc988b5-fixes-for-4.19.294.patch"
	elif [[ "${path}" =~ "ck-0.180-4.19.0-ba77544.patch" ]] ; then
		# Single hunk
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.180-4.19.0-ba77544-fixes-for-4.19.294.patch"
	elif [[ "${path}" =~ "ck-0.180-4.19.0-8a679ba.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.180-4.19.0-8a679ba-fix-for-4.19.294.patch"
	elif [[ "${path}" =~ "ck-0.180-4.19.0-befdee7.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/ck-0.180-4.19.0-befdee7-fix-for-4.19.294.patch"

	elif [[ "${path}" =~ "0179-mm-memcontrol-Replace-local_irq_disable-with-local-l.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0235-rtmutex-Handle-the-various-new-futex-race-conditions.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0467-Revert-rtmutex-Handle-the-various-new-futex-race-con.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0469-futex-Make-the-futex_hash_bucket-lock-raw.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0470-futex-Delay-deallocation-of-pi_state.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0481-futex-Make-the-futex_hash_bucket-spinlock_t-again-an.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"

	elif [[ "${path}" =~ "v4.19_pds099h.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 3 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/v4.19_pds099h-fixes-for-4.19.294.patch"

	elif [[ "${path}" =~ "${O3_CO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/O3-config-option-7d0295d-fix-for-4.14.patch"

	elif [[ "${path}" =~ ("${TRESOR_AESNI_FN}"|"${TRESOR_I686_FN}") ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
		ot-kernel_apply_tresor_fixes

	elif [[ "${path}" =~ "${UKSM_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 "" # 2 hunk failure without fuzz
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/uksm-4.14-rebase-for-4.14.246.patch"

	elif [[ "${path}" =~ "linux-4-13-1-orca-c2tcp-0521.patch" ]] ; then
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/linux-4-19-310-orca-c2tcp-0521.patch"

	elif [[ "${path}" =~ "zen-sauce-4.19.0-7ab867e.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-4.19.0-7ab867e-fix-for-4.19.294.patch"
	elif [[ "${path}" =~ "zen-sauce-4.19.0-7d0295d.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-4.19.0-7d0295d-fix-for-4.19.294.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: ot-kernel_check_versions
# @DESCRIPTION:
# Check optional version requirements
ot-kernel_check_versions() {
	_ot-kernel_check_versions "app-admin/mcelog" "0.6" ""
	_ot-kernel_check_versions "dev-util/oprofile" "0.9" "CONFIG_OPROFILE"
	_ot-kernel_check_versions "net-dialup/ppp" "2.4.0" "CONFIG_PPP"
	_ot-kernel_check_versions "net-dialup/isdn4k-utils" "3.1_pre1" "CONFIG_PPP"
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

	# Descending sort
	if ot-kernel_use pgo && [[ "${arch}" == "s390" ]] ; then
		die "Clang PGO is not supported for this series.  Disable either the clang or pgo USE flag."
	fi
	if ot-kernel_use pgo ; then
		die "Clang PGO is not supported for this series.  Disable either the clang or pgo USE flag."
	fi
	if has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi && [[ "${arch}" == "arm64" ]] ; then
		die "KCFI is not supported for this series.  Disable the kcfi USE flag."
	fi
	if has kcfi ${IUSE_EFFECTIVE} && ot-kernel_use kcfi && [[ "${arch}" == "x86_64" ]] ; then
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
eerror "The kernel_compiler_patch was not released for this series for zen-sauce."
eerror "OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER needs to be updated."
eerror
		die
	fi

	if grep -q -E -e "^CONFIG_DEBUG_INFO_DWARF4=y" "${path_config}" ; then
		_llvm_min_slot=15
	elif [[ "${kcp_provider}" == "genpatches" || "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
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

	if tc-is-gcc && [[ "${kcp_provider}" =~ "zen-sauce" ]] ; then
eerror
eerror "The kernel_compiler_patch was not released for this series for zen-sauce."
eerror "OT_KERNEL_KERNEL_COMPILER_PATCH_PROVIDER needs to be updated."
eerror
		die
	fi

	if grep -q -E -e "^CONFIG_DEBUG_INFO_SPLIT=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_INIT_STACK_ALL_ZERO=y" "${path_config}" ; then
	# Prevent:
	# <redacted>-pc-linux-gnu-gcc-11: error: unrecognized command-line option '-ftrivial-auto-var-init=zero'
		_gcc_min_slot=12
	elif grep -q -E -e "^CONFIG_KCOV=y" "${path_config}" ; then
		_gcc_min_slot=12
	elif [[ "${kcp_provider}" == "genpatches" || "${kcp_provider}" == "graysky2" ]] && [[ "${arch}" == "x86"  || "${arch}" == "x86_64" ]] ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_AMD64} # 11
	elif grep -q -E -e "^CONFIG_RETPOLINE=y" "${path_config}" ; then
		_gcc_min_slot=7
	elif (( ${wants_kcp_rpi} == 1 )) ; then
		_gcc_min_slot=${GCC_MIN_KCP_GRAYSKY2_ARM64} # 5
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

	# Ascending sort
	_gcc_max_slot=${GCC_MAX_SLOT} # 13
	echo "${_gcc_max_slot}"
}
