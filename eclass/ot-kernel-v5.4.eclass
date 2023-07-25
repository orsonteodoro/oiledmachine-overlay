# Copyright 2019-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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

CXX_STD="-std=gnu++98"
LLVM_MAX_SLOT=15
LLVM_MIN_SLOT=10
DISABLE_DEBUG_PV="1.4.1"
EXTRAVERSION="-ot"
GENPATCHES_BLACKLIST=" 2400"
GENPATCHES_VER="${GENPATCHES_VER:?1}"
KV_MAJOR=$(ver_cut 1 "${PV}")
KV_MAJOR_MINOR=$(ver_cut 1-2 "${PV}")
MUQSS_VER="0.196"

PATCH_ALLOW_O3_COMMIT="4edc8050a41d333e156d2ae1ed3ab91d0db92c7e" # from zen repo
PATCH_KCP_COMMIT="cbf238bae1a5132b8b35392f3f3769267b2acaf5" # from zen repo
PATCH_TRESOR_V="3.18.5"

CK_KV="5.4.0"
CK_COMMITS=(
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

# Avoid merge conflict.
CK_COMMITS_BL=(
5b6cd7cfe6cf6e1263b0a5d2ee461c8058b76213
)

ZEN_KV="5.4.0"
PATCH_ZENSAUCE_COMMITS=(
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

# Avoid merge conflict.
PATCH_ZENSAUCE_BRANDING="
1baa02fbd7a419fdd0e484ba31ba82c90c7036cf
"

# top is oldest, bottom is newest
# TODO: Split patch like in newer versions
PATCH_ZENTUNE_COMMITS=\
"3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0"

# LEFT_ZENTUNE:RIGHT_ZENSAUCE
PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE=(
c9a8f36311f14311a3202501c88009f758683c0f:3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0
) # \
# ZEN: Implement zen-tune v5.4 (3e05ad8)
# ZEN: Add CONFIG to rename the mq-deadline scheduler (c9a8f36) needs\

PATCH_ZENSAUCE_BL=(
	${PATCH_KCP_COMMIT}
	${PATCH_ZENSAUCE_BRANDING}
)

# For 5.4
ZEN_MUQSS_COMMITS=(
7acac2e4000e75f3349106a8847cf1021651446b
50955efefbe23a4270faca36a99999b76d2dc4db
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
ZEN_MUQSS_EXCLUDED_COMMITS=(
)

# For 5.6
# This corresponds to the futex-proton-v3 branch.
# Repo order is bottom oldest and top newest.
FUTEX_KV="5.6.0_rc1"
FUTEX_COMMITS=( # oldest
dc3e0456bf719cde7ce44e1beb49d4ad0e5f0c71
714afdc15b847a7a33c5206b6e1ddf64697c07d6
ec85ea95a00b490a059bcc817bc1b4660062dba0
00d3ee9cff824d4d38e82d252e4300999f87f1a5
e8d4d6ded8544b5716c66d326aa290db8501518c
) # newest

IUSE+="
bmq build +cfs clang disable_debug futex +genpatches -genpatches_1510 muqss
symlink tresor rt tresor_aesni tresor_i686 tresor_prompt tresor_sysfs
tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-muqss zen-sauce
zen-sauce-all -zen-tune
"

REQUIRED_USE+="
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
	zen-sauce-all? (
		zen-sauce
	)
	zen-tune? (
		zen-sauce
	)
"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="\
A customizable kernel package with \
BMQ, \
CVE fixes, \
FUTEX_WAIT_MULTIPLE, \
genpatches, \
kernel_compiler_patch, \
MUQSS, \
TRESOR, \
UKSM, \
zen-muqss, \
zen-sauce, \
zen-tune. \
"

inherit ot-kernel

LICENSE+=" GPL-2" # kernel_compiler_patch
LICENSE+=" GPL-2" # -O3 patch
LICENSE+=" HPND" # See drivers/gpu/drm/drm_encoder.c
LICENSE+=" bmq? ( GPL-3 )" # see \
	# https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
	# third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" futex? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
	# GPL-2 applies to the files being patched \
	# all-rights-reserved applies to new files introduced and no default license
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
			$(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT})
		)
	)
	|| (
		>=sys-devel/gcc-6.5.0
		$(gen_clang_llvm_pair 10 ${LLVM_MAX_SLOT})
	)
"

CDEPEND+="
	>=dev-lang/perl-5
	>=sys-apps/util-linux-2.10o
	>=sys-devel/bc-1.06.95
	>=sys-devel/binutils-2.21
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
"

BDEPEND+="
	build? (
		${CDEPEND}
	)
"

RDEPEND+="
	${KCP_RDEPEND}
"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:
else
	KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:-"cdn.kernel.org"}
	SRC_URI+="
		${KERNEL_PATCH_URIS[@]}
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${KV_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	"
fi

if [[ "${UPDATE_MANIFEST:-0}" == "1" ]] ; then
	SRC_URI+="
		${BMQ_SRC_URI}
		${CK_SRC_URIS}
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_1_URI}
		${FUTEX_SRC_URIS}
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
		${ZENSAUCE_URIS}
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
		futex? (
			${FUTEX_SRC_URIS}
		)
		genpatches? (
			${GENPATCHES_URI}
		)
		muqss? (
			${CK_SRC_URIS}
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
			${ZENSAUCE_URIS}
		)
	"
fi

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	if has zen-tune ${IUSE} ; then
		if use zen-tune ; then
ewarn
ewarn "The zen-tune patch might cause lock up or slow io under heavy load like"
ewarn "npm.  These use flags are not recommended."
ewarn
		fi
	fi

	if use tresor ; then
ewarn
ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
ewarn
ewarn "Please migrate your data outside the XTS(tresor) partition(s) into a different"
ewarn "partition.  Keep the commit frozen, or checkout kept rewinded to a"
ewarn "specific commit before upcoming XTS(tresor) key changes.  Checkout repo"
ewarn "as head when you have migrated the data are ready to use the updated"
ewarn "XTS(tresor) with setkey changes.  This new XTS setkey change will not be"
ewarn "backwards compatible."
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
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-5.4-aesni.patch"
	fi

	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPTS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.4.patch"
	if ot-kernel_use tresor_x86_64-256-bit-key-support ; then
		if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
			_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.2-for-5.4.patch"
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
	_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-glue-helper-in-kconfig.patch"
	if ot-kernel_use tresor_x86_64 || ot-kernel_use tresor_i686 ; then
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-xts-setkey-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/tresor-xts-setkey-5.4-aesni.patch"
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
#    fail.]
# 2. Replace the original patch with a completely updated patch.
# 3. Copy the original patch then slightly modify and apply the patch.
#    (Modifications may fix the path changes between minor versions.)
ot-kernel_filter_patch_cb() {
	local path="${1}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.
	# Using patch with fuzz factor is disallowed with define parts or syscall_*.tbl of futex and futex2

	if [[ "${path}" =~ "${BMQ_FN}" ]] ; then
		_dpatch "${PATCH_OPTS}" "${path}"
	elif [[ "${path}" =~ "ck-0.196-5.4-7acac2e.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.196-5.4-33b744f.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "0148-rtmutex-Handle-the-various-new-futex-race-conditions.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
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
	else
		_dpatch "${PATCH_OPTS}" "${path}"
	fi
}

# @FUNCTION: ot-kernel_filter_genpatches_blacklist_cb
# @DESCRIPTION:
# Filter
ot-kernel_filter_genpatches_blacklist_cb() {
	if ( ver_test $(ver_cut 1-3 "${PV}") -eq "5.4.85" ) \
		&& ( ver_test "${GENPATCHES_VER}" -eq "87" ) ; then
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
