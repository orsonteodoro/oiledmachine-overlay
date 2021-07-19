# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.13.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.13.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.13 eclass defines specific applicable patching for the 5.13.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="56350f1ad743dbb258229fe93a896fb441c8c396"
PATCH_CK_COMMIT_B="" # bottom / newest (not ready yet)
PATCH_CK_COMMIT_T="" # top / oldest
PATCH_FUTEX_COMMIT_B="74d0568c6f3aa4a5f2682f6d6b5a4d59044a762e" # bottom / newest
PATCH_FUTEX_COMMIT_T="93ea4d3978ab84892db3d44445bc12c51fa627e3" # top / oldest
PATCH_FUTEX2_COMMIT_B="db649ce1f5de12432be5bfedd8388eacc2f85efc" # bottom / newest
PATCH_FUTEX2_COMMIT_T="f12c1f14276bce0f66e514b419e68506fb5bad55" # top / oldest
PATCH_BBRV2_COMMIT_B="50a9bcbda886c487541cbe02e2ff6bf54107028c" # bottom / newest
PATCH_BBRV2_COMMIT_T="03eeb3dfa421116c48e86376a2079fa7dd25e783" # top / oldest
PATCH_KCP_COMMIT="aa17c1c6e894e75943950b0818af8695ae4a23b2"
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# where Y is top and X is bottom
PATCH_ZENSAUCE_COMMITS=\
"c4ab3a5b4ba139dc102566f66fc5dba96e728ddb \
617425f6f45fdc270a58344726ed4353a0bf027d \
74e3df8f6e24c8c473b326a1d750de7d8b77b177 \
aa17c1c6e894e75943950b0818af8695ae4a23b2 \
56350f1ad743dbb258229fe93a896fb441c8c396 \
41ce5e63eefb481bd4542505422858989bb2ef95 \
0380e4196b867209d9608b4aca063ac8c7b3308c \
3a68480245b4d09c65e62aced58868eb3d896e4a \
d30d478300a8b426cb6a787c38f0eccc0bff6475 \
6fbfd6ca165a7cf601bacb2bce656b280b0ff920 \
104e1e00288490f7e24802e9098a342efa9e530b \
830b77e138f36de9498887b931ec629d68b8d71f \
aa69255290392c2c4f1d5aabc0f8b0dee02fd908 \
0d1bf74b6ba31c78febdc5523f5c2cf8a56c1962 \
1153e0cc8136663b5273b3d5c35197dce4d3c680 \
bfbbf9734a3f01fb0677bd7ab7f6b1e96e2cb293 \
ad88458494fbecc930dab11ff54430c083260c06 \
b9e0aa2f3f28601a2ba794c927ffe4c7b3e59b60 \
519eab42710cd0b9abab9dc4d5a313f80b66ecec \
1eb5e3fe1b2094e9d50c442ff4d7feb59cfe9f60 \
552079568fdb272fdcae5767cdb2877e9fdf269a \
33da506ff25488b142d25efd3362f361cde9984b \
732e5405c0311f1e32e6e4b0cd30fc104209e6bd \
aec8f00a3066a2589dd6ea97d5f86d81c8d40c4a \
2e4c5f603d9942213fe76b88323d832048f5ad8c \
67850ef3720d3e2b363db6b347ab59544b433bd7"

# top / oldest, bottom / newest
# Diced to let user can choose between UKSM, KSWAPD, OOMD
PATCH_DEFER_MADVISE_COMMIT=\
"519eab42710cd0b9abab9dc4d5a313f80b66ecec"
PATCH_ZENTUNE_COMMITS=\
"bfbbf9734a3f01fb0677bd7ab7f6b1e96e2cb293 \
ad88458494fbecc930dab11ff54430c083260c06 \
b9e0aa2f3f28601a2ba794c927ffe4c7b3e59b60 \
519eab42710cd0b9abab9dc4d5a313f80b66ecec \
1eb5e3fe1b2094e9d50c442ff4d7feb59cfe9f60 \
552079568fdb272fdcae5767cdb2877e9fdf269a \
33da506ff25488b142d25efd3362f361cde9984b \
732e5405c0311f1e32e6e4b0cd30fc104209e6bd"
PATCH_BFQ_DEFAULT="ad88458494fbecc930dab11ff54430c083260c06"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_BFQ_DEFAULT}
	${PATCH_KCP_COMMIT}
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

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 cfi +cfs disable_debug futex-wait-multiple futex2
+genpatches +kernel-compiler-patch lto muqss +O3 prjc rt tresor tresor_aesni
tresor_i686 tresor_sysfs tresor_x86_64 tresor_x86_64-256-bit-key-support uksm
zen-sauce -zen-tune zen-tune-muqss"
REQUIRED_USE+="
	!muqss
	!prjc
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
patchset, GraySky2's kernel_compiler_patch, MUQSS CPU Scheduler, \
Project C CPU Scheduler, genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" bbrv2? ( GPL-2 )" # tcp_bbr2.c is Dual BSD/GPL but other parts are based on licensing of original file
LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" prjc? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # does not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" futex2? ( GPL-2 Linux-syscall-note GPL-2+ )" # same as original file
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel-compiler-patch? ( GPL-2 )"
gen_kcp_license() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		out+=" kernel-compiler-patch-${a}? ( GPL-2 )"
	done
	echo "${out}"
}
LICENSE+=" "$(gen_kcp_license)
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

CFI_RDEPEND="
	(
		sys-devel/clang:12
		sys-devel/llvm:12
		>=sys-devel/lld-12
	)
	(
		sys-devel/clang:13
		sys-devel/llvm:13
		>=sys-devel/lld-13
	)"

LTO_CLANG_RDEPEND="
	(
		sys-devel/clang:11
		sys-devel/llvm:11
		>=sys-devel/lld-11
	)
	(
		sys-devel/clang:12
		sys-devel/llvm:12
		>=sys-devel/lld-12
	)
	(
		sys-devel/clang:13
		sys-devel/llvm:13
		>=sys-devel/lld-13
	)"

KCP_RDEPEND="
	>=sys-devel/gcc-6.5.0
	(
		sys-devel/clang:10
		sys-devel/llvm:10
	)
	(
		sys-devel/clang:11
		sys-devel/llvm:11
	)
	(
		sys-devel/clang:12
		sys-devel/llvm:12
	)
	(
		sys-devel/clang:13
		sys-devel/llvm:13
	)"

KCP_TC0="
	|| (
		>=sys-devel/gcc-10
		(
			sys-devel/clang:10
			sys-devel/llvm:10
		)
		(
			sys-devel/clang:11
			sys-devel/llvm:11
		)
		(
			sys-devel/clang:12
			sys-devel/llvm:12
		)
		(
			sys-devel/clang:13
			sys-devel/llvm:13
		)
	)"

KCP_TC1="
	|| (
		>=sys-devel/gcc-10.3
		(
			sys-devel/clang:10
			sys-devel/llvm:10
		)
		(
			sys-devel/clang:11
			sys-devel/llvm:11
		)
		(
			sys-devel/clang:12
			sys-devel/llvm:12
		)
		(
			sys-devel/clang:13
			sys-devel/llvm:13
		)
	)"

KCP_TC2="
	|| (
		>=sys-devel/gcc-11.1
		(
			sys-devel/clang:12
			sys-devel/llvm:12
		)
		(
			sys-devel/clang:13
			sys-devel/llvm:13
		)
	)"

KCP_MA_RDEPEND="
	kernel-compiler-patch-zen3? ( ${KCP_TC1} )
	kernel-compiler-patch-cooper_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-tiger_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-sapphire_rapids? ( ${KCP_TC2} )
	kernel-compiler-patch-rocket_lake? ( ${KCP_TC2} )
	kernel-compiler-patch-alder_lake? ( ${KCP_TC2} )"

RDEPEND+=" ${KCP_MA_RDEPEND}
	   cfi? ( || ( ${CFI_RDEPEND} ) )
	   kernel-compiler-patch? (
		|| ( ${KCP_RDEPEND} )
	   )
	   lto? ( || ( ${LTO_CLANG_RDEPEND} ) )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
SRC_URI+="
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

# Not ready or not planned
#	   muqss? ( ${CK_SRC_URI} )
#	   prjc? ( ${PRJC_SRC_URI} )

# For CPU microarchitectures >= year 2020, assumes mutually exclusive
# kernel-compiler-patch* USE flag usage
gen_kcp_ma_uri() {
	local out=""
	for a in ${KCP_MA[@]} ; do
		[[ "${a}" =~ cortex-a72 ]] && continue
		out+="
	   kernel-compiler-patch-${a}? (
		${KCP_SRC_9_0_URI}
	   )"
	done
	echo "${out}"
}

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_0_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   O3? ( ${O3_ALLOW_SRC_URI} )
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
	if use tresor ; then
		if [[ -n "${OT_KERNEL_DEVELOPER}" && "${OT_KERNEL_DEVELOPER}" == "1" ]] ; then
			:;
		else
eerror
eerror "Building for TRESOR is currently broken for ${PV}.  Use the older LTS"
eerror "branches instead.  Disable the tresor USE flag for this series to"
eerror "continue."
eerror
			die
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
ewarn
ewarn "The zen-tune patch might cause lock up or slow io under heavy load"
ewarn "like npm.  These use flags are not recommended."
ewarn
		fi
	fi

#	if use tresor ; then
#ewarn
#ewarn "TRESOR for ${PV} is tested working.  See dmesg for details on correctness."
#ewarn
#	fi

	if ! use arm64 ; then
ewarn
ewarn "CFI is only offered on the arm64 platform."
ewarn
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
einfo "You may require the genkernel 4.x series to build the ${K_MAJOR_MINOR}.x"
einfo "kernel series."
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
	if [[ "${path}" =~ "prjc_v5.12-r1.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ prjc_v5.12 ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
ewarn
ewarn "Applying genpatches 5022 kernel/sched/pelt.h fix for newer Project C."
ewarn "It still needs testing.  Remove this notice or codeblock if it is a"
ewarn "success or fixed upstream."
ewarn
		_dpatch "${PATCH_OPS}" "${FILESDIR}/5022_BMQ-and-PDS-compilation-fix.patch"
	elif [[ "${path}" =~ "ck-0.210-for-5.12-d66b728-47a8b81.patch" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/ck-patchset-5.12-ck1-fix-cpufreq-gov-performance.patch"
	elif [[ "${path}" =~ "0001-z3fold-simplify-freeing-slots.patch" ]] \
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
