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

KERNEL_RELEASE_DATE="20220731" # of first stable release
CXX_STD="-std=gnu++14" # See https://github.com/torvalds/linux/blob/v5.19/tools/build/feature/Makefile#L318
GCC_MAX_SLOT_ALT=13 # Without kernel-compiler-patch
GCC_MAX_SLOT=10 # With kernel-compiler-patch
GCC_MIN_SLOT=6
DISABLE_DEBUG_PV="1.4.1"
EXTRAVERSION="-ot"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KV_MAJOR=$(ver_cut 1 "${PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${PV}")
MUQSS_VER="0.180"
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_PDS_VER="${PATCH_PDS_VER:-099h}"
PATCH_TRESOR_VER="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/A..D.patch \
#	| grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# from A to D, where a is ancestor and d is descendant.
# When using that commit list generator, it *may miss* some commits, so verify all
# the commits in order.

C2TCP_MAJOR_VER="2"
C2TCP_VER="2.2"
C2TCP_EXTRA="0521"
C2TCP_KV="4.13.1"
C2TCP_COMMIT="991bfdadb75a1cea32a8b3ffd6f1c3c49069e1a1" # Jul 20, 2020

CK_KV="4.19.0"
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

# Avoid merge conflicts or already upstreamed.
# BL = Blacklisted to avoid merge conflict
CK_COMMITS_BL=(
da178919d63ecfec2738877abae02cd2ce8aa29c # -ck1 extraversion
)

ZEN_KV="4.19.0"
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

# Avoid merge conflict.
PATCH_ZEN_SAUCE_BRANDING="
c340c84b774aee3eda9a818fc4c0dc6a46a2c83d
"

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

# BFQ is not made default
# BL = Blacklisted
PATCH_ZEN_SAUCE_BL=(
	${PATCH_KCP_COMMIT}
	${PATCH_ZEN_SAUCE_BRANDING}
	bec5c50bb387f4c4956fc4553d2c6491363b1489 # ZEN: Add a choice of boot logos [permissions issue and conflicts with logo patch]
)

# 811cb39 -> a79d648 is about the same as 24da54e
# a17a37f, 8faec5c -> 721f586 is about the same as 78f8617

IUSE+="
build c2tcp +cfs deepcc disable_debug +genpatches -genpatches_1510 kpgo-utils
muqss orca pds pgo rt symlink tresor tresor_aesni tresor_i686 tresor_prompt
tresor_sysfs tresor_x86_64 uksm zen-sauce
"
REQUIRED_USE+="
	genpatches_1510? (
		genpatches
	)
	tresor? (
		^^ (
			tresor_aesni
			tresor_i686
			tresor_x86_64
		)
	)
	tresor_prompt? (
		tresor
	)
	tresor_aesni? (
		tresor
	)
	tresor_i686? (
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
"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="\
A customizable kernel package with \
C2TCP, \
DeepCC, \
genpatches, \
kernel_compiler_patch, \
MuQSS, \
Orca, \
PDS, \
RT_PREEMPT (-rt), \
UKSM, \
zen-sauce. \
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
LICENSE+=" pgo? ( GPL-2 GPL-2+ )" # GCC_PGO kernel patch only
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no default license
	#   found in the project.  (The implementation is based on an academic paper
	#   from public universities.)
LICENSE+=" zen-sauce? ( GPL-2 )"

KCP_RDEPEND="
	>=sys-devel/gcc-6.5.0
"

GCC_PV="4.6"
KMOD_PV="13"
CDEPEND+="
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.20
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
	kpgo-utils? (
		sys-kernel/kpgo-utils
	)
	linux-firmware? (
		>=sys-kernel/linux-firmware-${KERNEL_RELEASE_DATE}
	)
	pgo? (
		>=sys-devel/gcc-kpgo-${GCC_PV}
		sys-devel/binutils[static-libs]
		sys-libs/libunwind[static-libs]
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
	:;
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
ewarn
ewarn "This ot-sources ${PV} release is only for research purposes or to access"
ewarn "TRESOR devices.  This ${KV_MAJOR_MINOR}.x series is EOL for this repo but"
ewarn "not for upstream.  It will be removed immediately once TRESOR has been"
ewarn "fixed for mainline / stable for >= 5.x."
ewarn

	if use tresor ; then
ewarn
ewarn "TRESOR for ${PV} is stable.  See dmesg for details on correctness."
ewarn
	fi

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
	# for 4.20 series and 5.x use tresor-testmgr-ciphers-update.patch instead
	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update-for-linux-4.14.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
	local fuzz_factor=0
	[[ "${path}" =~ "${TRESOR_AESNI_FN}" ]] && fuzz_factor=3
        _dpatch "${PATCH_OPTS} -F ${fuzz_factor}" \
		"${FILESDIR}/tresor-testmgr-linux-4.14.127.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-4.14-i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-4.14-aesni.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-4.14.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-i686-v2.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-aesni-v2.patch"
	fi

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-4.14.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-testmgr-show-passed-for-linux-4.14.patch"
	fi
	_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-in-kconfig.patch"
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
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/c2tcp-0521-fix-for-4.14.305.patch"

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

	elif [[ "${path}" =~ "zen-sauce-4.19.0-7ab867e.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-4.19.0-7ab867e-fix-for-4.19.294.patch"

	elif [[ "${path}" =~ "zen-sauce-4.19.0-7d0295d.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/zen-sauce-4.19.0-7d0295d-fix-for-4.19.294.patch"

	else
		_dpatch "${PATCH_OPTS}" "${path}"
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
