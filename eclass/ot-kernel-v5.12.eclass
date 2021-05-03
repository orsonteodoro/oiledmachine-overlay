#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2020-2021 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.12.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.12.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.12 eclass defines specific applicable patching for the 5.12.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="ed1e3e23c0fa1a43f23c7f7f02f96915f6391b40"
PATCH_CK_COMMIT_B="47a8b8135d37e0fc97d9fa875ef88855844ab417" # bottom / newest
PATCH_CK_COMMIT_T="d66b728fed660035a3830f45905d894424ba2d7f" # top / oldest
PATCH_FUTEX_COMMIT_B="75d8034728411113df4c4ced42819f2ddd4392a5" # bottom / newest
PATCH_FUTEX_COMMIT_T="679731128173894efe3d301870dce34651eda786" # top / oldest
PATCH_FUTEX2_COMMIT_B="f24c1ade4967d4bb131e56bc344ac43ad8a6ca66" # bottom / newest
PATCH_FUTEX2_COMMIT_T="83f6018faa64933582396f3ef3081c3e75e69b72" # top / oldest
PATCH_BBRV2_COMMIT_B="8c1770e2a31b54cb392e933dc0c91887a9176915" # bottom / newest
PATCH_BBRV2_COMMIT_T="73d1ca58968168a812f24cf0704e8af5f93510e8" # top / oldest
PATCH_KGCCP_COMMIT="e7b0b23b5d5485eac1cd46c7f642cf3e7d21013a"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# where Y is top and X is bottom
PATCH_ZENSAUCE_COMMITS=\
"1dcc3ec6d794e1e45659a0c6d7f54be2fa05dad9 \
19c6683e94816fbaef422c446a8ff3d54c973cf3 \
96ec49966377694494a8aee6e8fd3f2d11509761 \
e7b0b23b5d5485eac1cd46c7f642cf3e7d21013a \
ed1e3e23c0fa1a43f23c7f7f02f96915f6391b40 \
759bb25de38a637fb6e09fd7f9d8943b4185d4a1 \
5e1e97170390182fd4a3ad9ccb9d857bd2e7cb9e \
d5aa0adb115a345817e6817db470476336c3e7ae \
9d1de069064175427c8ee5366ca2bef3d6d3d6d5 \
93d22865c895696a789f7e70bb9f62e4bd8b8a4d \
0beed1391c7610203fc3dc27c19e23977b75edd7 \
3559da1257c8cf11ea8ece27fd4cfe5ca56c2495 \
d7fbf1677baa401313b46215d018e2da4741bb83 \
c44bcbc63316db1f54d383d9b05742638cc9a739 \
b1e5576879680eb5d45061cca544379dfe3e3e6c \
21e1703ae2528c14987ff48ce77500021c57a837 \
909f6d7cbac4d61583b0af5be6c270716a04afb2 \
710f82dfbbef8ed83f2093070d91baef56968785 \
7d443dabec118b2c869461d8740e010bca976931 \
e9f42c7dd91570d86bcd05fb688e096a4e80ebc5 \
0ba43f5ad2f0fc5f77ebe992f2bf381de0af66b3 \
d6602ad8aa6d79371e8859e4a6ead02eb2d74a6d \
491f1ea03e6f3077cc8e1097f09cfd889e1880a9 \
ced7f3f7b47c3c7fd3afbb0dde3ba48a7f4e81d0 \
a2800f35cbb08c7f1fd5b595bcf2ef5b6e59f87b"

# top / oldest, bottom / newest
# Diced to let user can choose between UKSM, KSWAPD, OOMD
PATCH_DEFER_MADVISE_COMMIT=\
"0ba43f5ad2f0fc5f77ebe992f2bf381de0af66b3"
PATCH_ZENTUNE_COMMITS=\
"710f82dfbbef8ed83f2093070d91baef56968785 \
7d443dabec118b2c869461d8740e010bca976931 \
e9f42c7dd91570d86bcd05fb688e096a4e80ebc5 \
0ba43f5ad2f0fc5f77ebe992f2bf381de0af66b3 \
d6602ad8aa6d79371e8859e4a6ead02eb2d74a6d \
491f1ea03e6f3077cc8e1097f09cfd889e1880a9 \
ced7f3f7b47c3c7fd3afbb0dde3ba48a7f4e81d0 \
a2800f35cbb08c7f1fd5b595bcf2ef5b6e59f87b"
PATCH_BFQ_DEFAULT="7d443dabec118b2c869461d8740e010bca976931"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_BFQ_DEFAULT}
	${PATCH_KGCCP_COMMIT}
	${PATCH_ZENTUNE_COMMITS}
"

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
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
	!genpatches
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

# Upstream or the mirrors are almost always slow by a week or more.
SRC_URI_WIP="
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
"

SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
	   kernel-gcc-patch? (
		${KGCCP_SRC_4_9_URI}
		${KGCCP_SRC_8_1_URI}
		${KGCCP_SRC_9_0_URI}
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
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-i686-v2.5.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.10-aesni-v2.5.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c-for-5.10.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v3.1-for-5.10.patch"
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
