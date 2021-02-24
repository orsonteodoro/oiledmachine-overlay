#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2020 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.11.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.11.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.11 eclass defines specific applicable patching for the 5.11.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.208"
PATCH_ALLOW_O3_COMMIT="a09abe2fc9c447bcf7c7f9888d63fb448da29ed6"
PATCH_CK_COMMIT_B="83a25030c257da76640039e8786fc11bbf3b5595" # bottom / newest
PATCH_CK_COMMIT_T="18247bb9a2aca72363326f63e868b7cfda0d771c" # top / oldest
PATCH_FUTEX_COMMIT_B="d506c2e27c90e510ca914febfe63a319f89e9eb7" # bottom / newest
PATCH_FUTEX_COMMIT_T="8f408a19dc45e6dc1c0056938358eda0618f0d7d" # top / oldest
PATCH_FUTEX2_COMMIT_B="6a8619d5ff5476c603ba41789999f1695751f5d9" # bottom / newest
PATCH_FUTEX2_COMMIT_T="a64bf661d4fc6dbfde640bf002eae2e22884a419" # top / oldest
PATCH_BBRV2_COMMIT_B="5ded94b0a37ea404ce97aa284b7c8dbfcc39d788" # bottom / newest
PATCH_BBRV2_COMMIT_T="b69dc2803d9603ad726c7f091bc79b1f5666b415" # top / oldest
PATCH_KGCCP_COMMIT="864b64e0d84e9d81a224e3f6319f7495acd743c1"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}"
PATCH_ZENSAUCE_COMMITS=\
"cc1e8edfe1969c80fc006b8c82f682ca744a7c44 \
4680ef2eb0d9e5e2b7e3db865bb98c1deb7aa2fa \
8ac6e5f83e52b69ad7847264b87934333ec99b1f \
864b64e0d84e9d81a224e3f6319f7495acd743c1 \
a09abe2fc9c447bcf7c7f9888d63fb448da29ed6 \
456aec2082a997b3bd1e27092eab880fc140119c \
0970087163d7ef4f3704e2947b36945b761f6115 \
56a15c518cdc7cc7f1691fd935e6d5b63124799c \
330c86c88fd849b55ceaa52b7a7fd19e92e4bec7 \
0ac9a9af0d38e9c4263958108a0497e8c4052234 \
b62736d62bf26d25ff0f294ce00c259d4b4fa251 \
6127d783a34c80525155e8778efd7324774a28cd \
05ce2f5618f9807fe88b23f4fb5a2788d05d6c65 \
a9c7a81daeb8a2ab7ce5015e6b6ed645097f1bd9 \
e0360b4bfc99262c8cd69774163d0ef4625c122c \
2f4f3181c463b84e407a456576e2cfcf01f6077e \
cb1500c08bc621a5bc20c1ed5b3186637960d13e \
3d6ca66a94231013f297ee77351ef1912c66734f \
444c427decabd7ebade07e4d98d9cb874c6bc7d4 \
2d56caddc29a9c335074dc7d3146dbc70aa712b4 \
3b7d035d9e064e2e28f623a66247c829b335e7a4 \
e1dc7c94d318d79aa223568f4044dd9bad178e9d \
fe8a7ad23ed4a990d1a4ea145e103671f1477c96 \
791993e1c1fd68c5c05295efabebb8b4b3579f3a"

# top / oldest, bottom / newest
# Diced to let user can choose between UKSM, KSWAPD, OOMD
PATCH_DEFER_MADVISE_COMMIT=\
"444c427decabd7ebade07e4d98d9cb874c6bc7d4"
PATCH_ZENTUNE_COMMITS=\
"2f4f3181c463b84e407a456576e2cfcf01f6077e \
cb1500c08bc621a5bc20c1ed5b3186637960d13e \
3d6ca66a94231013f297ee77351ef1912c66734f \
444c427decabd7ebade07e4d98d9cb874c6bc7d4 \
444c427decabd7ebade07e4d98d9cb874c6bc7d4 \
2d56caddc29a9c335074dc7d3146dbc70aa712b4 \
3b7d035d9e064e2e28f623a66247c829b335e7a4 \
e1dc7c94d318d79aa223568f4044dd9bad178e9d \
fe8a7ad23ed4a990d1a4ea145e103671f1477c96"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_KGCCP_COMMIT}
	${PATCH_ZENTUNE_COMMITS}
"

# --

# Disabled cb1500c08bc621a5bc20c1ed5b3186637960d13e : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

# top is oldest, bottom is newest
PATCH_ZENTUNE_MUQSS_COMMITS=\
"e544d7be951a96fbb5c6ee839726c3d7754b7509 \
097d88ec2dd7623b2791cf1d94f6905701669469 \
2b541bf1e5e27c51f96326f6c9d6c8abcf682d93 \
a09dda608cbadc92964cb29cf2fef061200e08c2"

IUSE+=" bbrv2 +cfs disable_debug futex-wait-multiple futex2 \
+genpatches +kernel-gcc-patch muqss +O3 prjc rt tresor tresor_aesni \
tresor_i686 tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support \
uksm zen-sauce -zen-tune zen-tune-muqss"
REQUIRED_USE+="
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

LICENSE+=" bbrv2? ( GPL-2 )" # tcp_bbr2.c is Dual BSD/GPL but other parts are based on licensing of original file
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # do not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" futex2? ( GPL-2 Linux-syscall-note GPL-2+ )" # same as original file
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

SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
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
	   zen-sauce? ( ${ZENSAUCE_URIS} )
	   zen-tune? ( ${ZENTUNE_URIS} )
	   zen-tune-muqss? ( ${ZENTUNE_MUQSS_URIS} )"

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
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-prompt-update-for-5.10-v4_aesni.patch"
	fi

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.4.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.4.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3-for-5.10.patch"
		fi
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
