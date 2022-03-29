# Copyright 2019-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v4.14.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 4.14.x kernel
# @DESCRIPTION:
# The ot-kernel-v4.14 eclass defines specific applicable patching for the
# 4.14.x linux kernel.

CXX_STD="-std=gnu++98"
GCC_MAX_SLOT=10
GCC_MIN_SLOT=6
DISABLE_DEBUG_V="1.4.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.162"
PATCH_KCP_COMMIT="c53ae690ee282d129fae7e6e10a4c00e5030d588" # GraySky2's kernel_compiler_patch
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_PDS_V="${PATCH_PDS_V:-098i}"
PATCH_TRESOR_V="3.18.5"

CK_COMMITS=(
fbc0b4595aeccc2cc03e292ac8743565b3d3037b
e8e37da685f7988182d7920a711e00dd2457af65
44fc740a3ff85d378c28a416a076cc7e019d7b8c
d27b58b0707ac311be5a51594fc6f22ed1d109e5
5da7d1778b96c514394334c92de9b3d8d71f4a29
9df803c28bb8ccb2588c0ccaf857b9e673175fed
ff1ab759022323229ca1e7b368c0df5e2aa1dabc
3ef5df78c2f425115b87f0f2f59fd189c0f1bbe3
6044370cf4bbc5e05f5d78f5772c1d88e3153603
071486de633698dcdd163295173ce4663ec9158c
ef412af05347ab4a0885080864677b85bf51072a
9e47a80f690080c12ce607158b96c305707543b8
5902b315d4061ebbe73a62c52e6d3b618066cebc
ed0ab4c80fcb6fa4abb4f2f897e591df6eaa2d0e
99d2963b648787f2fc2b72343674b8726f5c3ab2
8e9317792c2f83621445c386240d62d54cebb826
811cb391e71c1d60387dbbd6ae0bbc4e61f06acb
6bfb805cbac27b18fb4ad7537fe90dfc39e17f35
1588e6bf316231685204e358dfe172851b39fd1e
df2a75f4864b30011ab6a6f365d9378d8eafa53b
a79d648fcde72fc98048d4435bc86864a59fd01b
a17a37f6698721fe40c0f6e68c4ded5317d8477b
24da54ee4acc4ba2675e838da27bd28df08016bf
8faec5cb69d9ea6e641155e20ff70930a88f1e65
315a82476414f83cf099458a05148d76f30b6c8c
03ee562c01e1a60b2b4dae80e88db83b87559cba
721f586b71653a931e73d25116fd92e0ee62a434
78f861790848e83e6c98cd8f3408dbad7c9f4c3d
)

# Split commits, but not final commit
CK_COMMITS_BL_BFQ_SPLIT=(
811cb391e71c1d60387dbbd6ae0bbc4e61f06acb
6bfb805cbac27b18fb4ad7537fe90dfc39e17f35
1588e6bf316231685204e358dfe172851b39fd1e
df2a75f4864b30011ab6a6f365d9378d8eafa53b
a79d648fcde72fc98048d4435bc86864a59fd01b
)

CK_BFQ_MQ=(
99d2963b648787f2fc2b72343674b8726f5c3ab2
24da54ee4acc4ba2675e838da27bd28df08016bf
)

# Split commits, but not final commit
CK_COMMITS_BL_RQSHARE_SPLIT=(
a17a37f6698721fe40c0f6e68c4ded5317d8477b
8faec5cb69d9ea6e641155e20ff70930a88f1e65
315a82476414f83cf099458a05148d76f30b6c8c
03ee562c01e1a60b2b4dae80e88db83b87559cba
721f586b71653a931e73d25116fd92e0ee62a434
)

# Avoid merge conflicts or already upstreamed.
CK_COMMITS_BL=(
${CK_COMMITS_BL_BFQ_SPLIT[@]}
${CK_COMMITS_BL_RQSHARE_SPLIT[@]}
8e9317792c2f83621445c386240d62d54cebb826
)


# 811cb39 -> a79d648 is about the same as 24da54e
# a17a37f, 8faec5c -> 721f586 is about the same as 78f8617

# Obtained from:  date -d "2017-11-12 10:46:13 -0800" +%s
LINUX_TIMESTAMP=1510512373

IUSE+=" build symlink"
IUSE+=" bfq-mq +cfs disable_debug +genpatches -genpatches_1510
+kernel-compiler-patch muqss pds +O3 rt tresor tresor_aesni tresor_i686
tresor_prompt tresor_sysfs tresor_x86_64 uksm"
REQUIRED_USE+="
	bfq-mq? ( muqss )
	genpatches_1510? ( genpatches )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_prompt? ( tresor )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, GraySky2's
kernel_compiler_patch, GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler,
genpatches, TRESOR"

inherit ot-kernel

LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" pds? ( GPL-3 )" # \
  # See https://gitlab.com/alfredchen/PDS-mq/-/blob/master/LICENSE
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no default license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)

KCP_RDEPEND=" >=sys-devel/gcc-6.5.0"

RDEPEND+=" kernel-compiler-patch? ( || ( ${KCP_RDEPEND} ) )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:
else
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

SRC_URI+=" genpatches? (
		${GENPATCHES_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
	   )
	   muqss? ( ${CK_SRC_URIS} )
	   O3? (
		${O3_CO_SRC_URI}
		${O3_RO_SRC_URI}
	   )
	   rt? ( ${RT_SRC_URI} )
	   pds? ( ${PDS_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
	   )
	   uksm? ( ${UKSM_SRC_URI} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
ot-kernel_pkg_setup_cb() {
	# TRESOR for x86_64 generic was known to pass crypto testmgr on this
	# version.
ewarn
ewarn "This ot-sources ${PV} release is only for research purposes or to access"
ewarn "TRESOR devices.  This ${K_MAJOR_MINOR}.x series is EOL for this repo but"
ewarn "not for upstream.  It will be removed immediately once TRESOR has been"
ewarn "fixed for mainline / stable for >= 5.x."
ewarn

	if use tresor ; then
ewarn
ewarn "TRESOR for ${PV} is stable.  See dmesg for details on correctness."
ewarn
	fi

	# Allow for multiple builds for different kernel configs (e.g. server, gaming-client etc),
	# but it is really needed to isolate the -rt build.
	if [[ -z "${OT_KERNEL_BUILDCONFIGS_4_14}" ]] ; then
		OT_KERNEL_BUILDCONFIGS_4_14_="ot:build:/etc/kernels/kernel-config-${K_MAJOR_MINOR}-ot-$(uname -m):$(uname -m):${CHOST}:cfs:manual"
		if use rt ; then
			# Split for security reasons
			OT_KERNEL_BUILDCONFIGS_4_14_="${OT_KERNEL_BUILDCONFIGS_4_14_};rt:build:/etc/kernels/kernel-config-${K_MAJOR_MINOR}-rt-$(uname -m):$(uname -m):${CHOST}:cfs:manual"
		fi
	else
		export OT_KERNEL_BUILDCONFIGS_4_14_="${OT_KERNEL_BUILDCONFIGS_4_14}"
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
# Filtered patch function
ot-kernel_filter_patch_cb() {
	local path="${1}"

	# WARNING: Fuzz matching is not intelligent enough to distiniguish syscall
	#          number overlap.  Always inspect each and every hunk.

	if [[ "${path}" =~ "ck-0.162-4.14-fbc0b45.patch" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/ck-0.162-4.14-fbc0b45-2-hunk-fix-for-4.14.246.patch"
		_dpatch "${PATCH_OPTS}" "${FILESDIR}/ck-0.162-4.14-fbc0b45-build-time-fixes-for-4.14.213.patch"
	elif [[ "${path}" =~ "ck-0.162-4.14-ff1ab75.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.162-4.14-071486d.patch" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
	elif [[ "${path}" =~ "ck-0.162-4.14-24da54e.patch" ]] ; then
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
	elif [[ "${path}" =~ "${PDS_FN}" ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/pds-4.14_pds098i-rebase-for-4.14.213.patch"
	elif [[ "${path}" =~ "${O3_CO_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPTS}" \
"${FILESDIR}/O3-config-option-7d0295d-fix-for-4.14.patch"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		_dpatch "${PATCH_OPTS} -F 3" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${UKSM_FN}" ]] ; then
		_tpatch "${PATCH_OPTS}" "${path}" 2 0 "" # 2 hunk failure without fuzz
		_dpatch "${PATCH_OPTS}" \
			"${FILESDIR}/uksm-4.14-rebase-for-4.14.246.patch"
	else
		_dpatch "${PATCH_OPTS}" "${path}"
	fi
}
