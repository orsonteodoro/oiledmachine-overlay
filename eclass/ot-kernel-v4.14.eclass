#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019-2020 Orson Teodoro
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

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.162"
PATCH_CK_COMMIT_B="78f861790848e83e6c98cd8f3408dbad7c9f4c3d" # bottom / oldest
PATCH_CK_COMMIT_T="fbc0b4595aeccc2cc03e292ac8743565b3d3037b" # top / newest
PATCH_KCP_COMMIT="c53ae690ee282d129fae7e6e10a4c00e5030d588" # GraySky2's kernel_compiler_patch
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_PDS_V="${PATCH_PDS_V:=098i}"
PATCH_TRESOR_V="3.18.5"

# Obtained from:  date -d "2017-11-12 10:46:13 -0800" +%s
LINUX_TIMESTAMP=1510512373

IUSE="+cfs disable_debug +genpatches +kernel-compiler-patch
muqss pds +O3 rt tresor tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64
uksm"
REQUIRED_USE+="
	^^ ( cfs muqss pds )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )"

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
	pds? ( !rt )
	rt? ( cfs !muqss !pds )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, GraySky2's Kernel \
GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, genpatches, TRESOR"

inherit ot-kernel

LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" pds? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # does not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no default license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)

KCP_RDEPEND="
	sys-devel/gcc:12
	sys-devel/gcc:11
	sys-devel/gcc:10
	sys-devel/gcc:9.4.0
	sys-devel/gcc:9.3.0
	sys-devel/gcc:8.5.0
	sys-devel/gcc:8.4.0
	sys-devel/gcc:7.5.0
	sys-devel/gcc:6.5.0"

RDEPEND+=" kernel-compiler-patch? ( || ( ${KCP_RDEPEND} ) )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

SRC_URI+=" genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
	   )
	   muqss? ( ${CK_SRC_URI} )
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
function ot-kernel_pkg_setup_cb() {
	# TRESOR for x86_64 generic was known to pass crypto testmgr on this
	# version.
	ewarn \
"This ot-sources ${PV} release is only for research purposes or to access\n\
TRESOR devices.  This ${K_MAJOR_MINOR}.x series is EOL for this repo but not for\n\
upstream.  It will be removed immediately once TRESOR has been fixed for\n\
mainline / stable for >=5.x ."

	if use tresor ; then
		ewarn \
"TRESOR for ${PV} is stable.  See dmesg for details on correctness."
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	# for 4.20 series and 5.x use tresor-testmgr-ciphers-update.patch instead
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update-for-linux-4.14.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
	local fuzz_factor=0
	[[ "${path}" =~ "${TRESOR_AESNI_FN}" ]] && fuzz_factor=3
        _dpatch "${PATCH_OPS} -F ${fuzz_factor}" \
		"${FILESDIR}/tresor-testmgr-linux-4.14.127.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-4.14-i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-prompt-wait-fix-for-4.14-aesni.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-4.14.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-i686-v2.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-for-4.14-aesni-v2.patch"
	fi

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-4.14.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-show-passed-for-linux-4.14.patch"
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will\n\
cause a kernel panic on boot."
		ewarn \
"Using CONFIG_FORCE_IRQ_THREADING may halt the boot process when showing\n\
loading initial ramdisk."
		ewarn \
"Expect several seconds of pause at loading initial ramdisk when booting."
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	:;
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
function ot-kernel_filter_patch_cb() {
	local path="${1}"
	if [[ "${path}" =~ "${CK_FN}" ]] ; then
		# Using --dry-run reports more failures than on the actual.
		# The point is that --dry-run is not reliable in some way.
		# The reason is that patching is restarted from the original
		# and does not resume at the not the intermediate images.
		# In the actual patching, 2 hunks actually failed.
		# The added -N arg is used to skip the duplicate hunks
		_tpatch "${PATCH_OPS} -N -F 3" "${path}" 9 1 ""
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-0.162-rebase-for-4.14.213.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-dont-attach-ckversion.patch"
	elif [[ "${path}" =~ "0179-mm-memcontrol-Replace-local_irq_disable-with-local-l.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "0235-rtmutex-Handle-the-various-new-futex-race-conditions.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "0249-rtmutex-add-sleeping-lock-implementation.patch" ]] ; then
		# PREEMPT_RT
		_tpatch "${PATCH_OPS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/4.14.215-rt105-0249-rtmutex-add-sleeping-lock-implementation-fix-for-4.14.220.patch"
	elif [[ "${path}" =~ "0362-net-core-protect-users-of-napi_alloc_cache-against-r.patch" ]] ; then
		# PREEMPT_RT
		_tpatch "${PATCH_OPS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/4.14.215-rt105-0362-net-core-protect-users-of-napi_alloc_cache-against-r-fix-for-4.14.220.patch"
	elif [[ "${path}" =~ "0467-Revert-rtmutex-Handle-the-various-new-futex-race-con.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "0469-futex-Make-the-futex_hash_bucket-lock-raw.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "0470-futex-Delay-deallocation-of-pi_state.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "0481-futex-Make-the-futex_hash_bucket-spinlock_t-again-an.patch" ]] ; then
		# PREEMPT_RT
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "${PDS_FN}" ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/pds-4.14_pds098i-rebase-for-4.14.213.patch"
	elif [[ "${path}" =~ "${O3_CO_FN}" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 1 0 ""
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/O3-config-option-7d0295dc49233d9ddff5d63d5bdc24f1e80da722-fix-for-4.14.patch"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${UKSM_FN}" ]] ; then
		_tpatch "${PATCH_OPS} -F 3" "${path}" 1 0 ""
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/uksm-4.14-rebase-for-4.14.212.patch"
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
