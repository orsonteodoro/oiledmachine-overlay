#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2020 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.10.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.10.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.10 eclass defines specific applicable patching for the 5.10.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.205"
PATCH_ALLOW_O3_COMMIT="d0ee207cac1217d2b111bef6f0f9581a10b35f6c"
PATCH_CK_COMMIT_B="9cdf59bc2dbfb640dbb057757e4101b147275e86" # bottom / oldest
PATCH_CK_COMMIT_T="35f6640868573a07b1291c153021f5d75749c15e" # top / newest
PATCH_FUTEX_COMMIT_B="f678870308608b485d1c771509208c93eab8538a" # bottom / oldest
PATCH_FUTEX_COMMIT_T="9fd101849c8a3324c6038ef31fe08a528f7a6fe4" # top / newest
PATCH_KGCCP_COMMIT="986ea2483af3ba52c0e6c9e647c05c753a548fb8"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}"
PATCH_ZENSAUCE_COMMITS=\
"dda238180bacda4c39f71dd16d754a48da38e676 \
9a2e0d950bfd77fb51a42a5fc7e81a9187606c38 \
5b3d9f2372600c3b908b1bd0e8c9b8c6ed351fa2 \
986ea2483af3ba52c0e6c9e647c05c753a548fb8 \
228e792a116fd4cce8856ea73f2958ec8a241c0c \
b81ab9b618d694217a54b5d2de70c7f37d3f3e07 \
4ace3c6c50dbd58ee5f200a5461289d0491873a6 \
0bf1b8c445de4481942ca8ace8dc209ece865bd3 \
513af58e2e4aa8267b1eebc1cd156e3e2a2a33e3 \
28eaff69b01d9248cac394cce37361d0d6a52714 \
973d42f99af15b2e610204fbe8252251ed7cc8c1 \
890ac858741436a40c274efb3514c5f6a96c7c80 \
0cbcc41992693254e5e4c7952853c6aa7404f28e \
9b6c7af596e209356850e0991969df68f396aea6 \
b5e9497d44347c16e732f6ea8838a79a64694b36 \
7e5629d0fc7ed407babc036c1bc7910d9c73dbef \
0e9fea26940d7e6e784dcf57909428138b8109e8 \
fade4cc2bf56ce6c563c04764224b6b84a45587f \
b7b24b494b62e02c21a9a349da2d036849f9dd8b"
PATCH_ZENTUNE_COMMIT_B="b7b24b494b62e02c21a9a349da2d036849f9dd8b" # bottom / oldest
PATCH_ZENTUNE_COMMIT_T="890ac858741436a40c274efb3514c5f6a96c7c80" # top / newest
ZENTUNE_COMMITS=\
"890ac858741436a40c274efb3514c5f6a96c7c80 \
0cbcc41992693254e5e4c7952853c6aa7404f28e \
9b6c7af596e209356850e0991969df68f396aea6 \
b5e9497d44347c16e732f6ea8838a79a64694b36 \
7e5629d0fc7ed407babc036c1bc7910d9c73dbef \
0e9fea26940d7e6e784dcf57909428138b8109e8 \
fade4cc2bf56ce6c563c04764224b6b84a45587f \
b7b24b494b62e02c21a9a349da2d036849f9dd8b"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_KGCCP_COMMIT}
	${ZENTUNE_COMMITS}
"

#ZENTUNE_MUQSS_COMMIT="" # (exclusive-end,inclusive-start]  (top,bottom]

IUSE="+cfs disable_debug futex-wait-multiple +genpatches \
+kernel-gcc-patch muqss +O3 prjc rt tresor tresor_aesni tresor_i686 \
tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-sauce \
-zen-tune zen-tune-muqss"
REQUIRED_USE="
	!zen-tune-muqss
	^^ ( cfs muqss prjc )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-tune-muqss? ( muqss zen-tune )"

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
	prjc? ( !rt )
	rt? ( cfs !muqss !prjc )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel \
patchset, GraySky2's Kernel GCC Patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # do not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel-gcc-patch? ( GPL-2 )"
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no defaults license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)
LICENSE+=" zen-tune? ( GPL-2 )"
LICENSE+=" zen-tune-muqss? ( GPL-2 )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
SRC_URI+=" \
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

SRC_URI+=" futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-gcc-patch? (
		${KGCCP_SRC_4_9_URI}
		${KGCCP_SRC_8_1_URI}
		${KGCCP_SRC_9_1_URI}
		${KGCCP_SRC_10_1_URI}
		${KGCCP_SRC_11_0_URI}
	   )
	   muqss? ( ${CK_SRC_URI} )
	   O3? ( ${O3_ALLOW_SRC_URI} )
	   prjc? ( ${PRJC_SRC_URI} )
	   rt? ( ${RT_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

SRC_URI_DISABLED+="
	   zen-tune-muqss? ( ${ZENTUNE_MUQSS_SRC_URI} )
"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	if use kernel-gcc-patch ; then
		CC=$(tc-getCC)
		if ! tc-is-gcc ; then
			CC=$(get_abi_CHOST ${ABI})-gcc
		fi
		if has ">=sys-devel/gcc-11" ; then
			if $(gcc-fullversion) -ge 11 ; then
				:;
			else
				ewarn \
"You need to switch your compiler to gcc-11+ for kernel_gcc_patch to work on\n\
new architectures.  For increased compatibility switch and re-emerge with\n\
>=gcc-11."
			fi
		else
			ewarn \
"The kernel_gcc_patch was designed for older kernels and may fail to patch.\n\
Patching anyway.  For increased compatibility switch and re-emerge with\n\
>=gcc-11."
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
			ewarn \
"The zen-tune patch might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
		fi
	fi

	if use tresor ; then
		ewarn \
"TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.2.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/wait.patch"
	#fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPS} -F 3" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		einfo "See ${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.4.patch"
		die ""
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.4.patch"
	else
		einfo "See ${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.4.patch"
		die ""
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.4.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			einfo "See ${FILESDIR}/tresor-256-bit-aes-support-i686-v3-for-5.10.patch"
			die ""
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3-for-5.10.patch"
		fi
	fi

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v3_i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v3_aesni.patch"
	fi

	if ! use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-modes-of-operation-to-128-bit-key-support-for-linux-5.10.patch"
		else
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
		fi
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-testmgr-limit-to-xts-256-bit-key-support-for-linux-5.10.patch"
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	einfo
	einfo \
"You may require the genkernel 4.x series to build the ${K_MAJOR_MINOR}.x\n\
kernel series."
	einfo
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
	if [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
		einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0002-z3fold-stricter-locking-and-more-careful-reclaim.patch" ]] \
		&& ver_test $(ver_cut 1-3 ${PV}) -ge 5.10.4 ; then
		einfo "Already applied ${path} upstream"
	elif [[ "${path}" =~ "0008-x86-mm-highmem-Use-generic-kmap-atomic-implementatio.patch" ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ "${CK_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-dont-attach-ckversion.patch"
	elif [[ "${path}" =~ "${PRJC_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}
