# Copyright 2020-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.14.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.14.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.14 eclass defines specific applicable patching for the 5.14.x
# linux kernel.

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.210"
PATCH_ALLOW_O3_COMMIT="40fecdec8599c28fc9d1003c301d2202e39db8a6"
PATCH_CK_COMMIT_B="" # bottom / newest (EOL 5.12-ck is the last patchset)
PATCH_CK_COMMIT_T="" # top / oldest
PATCH_FUTEX_COMMIT_B="bff1c1603cc294ddcbbd7612b1806d7c8f55e7bd" # bottom / newest
PATCH_FUTEX_COMMIT_T="cba204184fc7af716d29bb3659ccfe9d6c84ecd0" # top / oldest
PATCH_FUTEX2_COMMIT_B="fa99bbb4cf0a5c6ed18cf58ecca678e82e008cb9" # bottom / newest
PATCH_FUTEX2_COMMIT_T="cc20b5f100d4f345e0b090a7a76daea256e6097d" # top / oldest
PATCH_BBRV2_COMMIT_B="fc632709b757850d62d2b295f749e80c19093da3" # bottom / newest
PATCH_BBRV2_COMMIT_T="5da5aaa858dd7fac0afd439de4ff7565a00d4f32" # top / oldest
PATCH_KCP_COMMIT="b9369c4a4f43b8cf182c9726dc5c7e6eb4115722"
PATCH_LRU_GEN_COMMIT_B="58423b0ba935bb76ff3f6754703e8fb8533ecae3" # bottom / newest
PATCH_LRU_GEN_COMMIT_T="1d1d59e750744b3c6b7cb51006cb59392e2fef65" # top / oldest
PATCH_TRESOR_V="3.18.5"
# To update some of these sections you can
# wget -O - https://github.com/torvalds/linux/compare/Y^..X.patch \
#   | grep -E -o -e "From [0-9a-z]{40}" | cut -f 2 -d " "
# where Y is top and X is bottom
PATCH_ZENSAUCE_COMMITS=\
"6c19e74f92407b935262366c90fcd1259d939fcf \
40cbbf2a2215c36d24676746ae98b20c77806355 \
7ab2a592090c1cf843bb10d267bb585317d0e289 \
b9369c4a4f43b8cf182c9726dc5c7e6eb4115722 \
40fecdec8599c28fc9d1003c301d2202e39db8a6 \
04fcedd90e574042883f5ba655903fcfc7f2cfae \
67f2b942ab4f2eab6dfafee23ad4c27575ec95f3 \
fed9cf973d6c74ed9736d2b95c42075894d53ed2 \
39376e2c9e2d20de215dc154cc27c3a1c44e0288 \
5ce4b72d373ab3fad2b1cc45450f59370e6ffb5a \
1a931f871e849e85123de286919641e6c4d502e4 \
76933ae58372a45bfad754d242ff2124758b07de \
0902f17304380ccf89112984a099b08505f3535c \
a655ad71e371e811943afdb533d52946155a2a6b \
149d85a8e32e7802340e8288829a126d711d8e58 \
a04d09fad3419e0db39db29f9fd35b3eed5948a6 \
c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73 \
2a92000db1307319f691020858a443495e40f7e5 \
c7ab6359906def4fbdbfd2510f8038826f27060f \
4c7ea2cb54eaa2d1d76722b4f7b2e28a837ef138 \
f69969a3ab15a2b66a535791dc5c23242099fce3 \
2aeeaeba306699007a9a9295a2f43f639b2415d0 \
1c8509527a7a90511fdefba4df904fc5c2fa543d \
f05a76bbac2ea8737c5b6a64a1e842da8c52a146 \
146ae111c1c1a112b0f267a0bd72794cc3c70013 \
0d419b3e995b3dfbd5f9261d1604a3c6656c825d"

# top / oldest, bottom / newest
# Diced to let user can choose between UKSM, KSWAPD, OOMD
PATCH_DEFER_MADVISE_COMMIT=\
"519eab42710cd0b9abab9dc4d5a313f80b66ecec"
PATCH_ZENTUNE_COMMITS=\
"a04d09fad3419e0db39db29f9fd35b3eed5948a6 \
c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73 \
2a92000db1307319f691020858a443495e40f7e5 \
c7ab6359906def4fbdbfd2510f8038826f27060f \
4c7ea2cb54eaa2d1d76722b4f7b2e28a837ef138 \
f69969a3ab15a2b66a535791dc5c23242099fce3 \
2aeeaeba306699007a9a9295a2f43f639b2415d0 \
1c8509527a7a90511fdefba4df904fc5c2fa543d"
PATCH_BFQ_DEFAULT="c6d1cd7ca0e23d3d17abab2350eb49f2aa00ac73"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_BFQ_DEFAULT}
	${PATCH_KCP_COMMIT}
	${PATCH_ZENTUNE_COMMITS}
"

# --

# Disabled 7d443dabec118b2c869461d8740e010bca976931 : ZEN: INTERACTIVE: Use BFQ as our elevator
# Reason: It's better to change via sysfs.  Benchmarks show performance throughput degration with SSD with BFQ.

# ZEN interactive MuQSS patches
# top is oldest, bottom is newest
PATCH_ZENTUNE_MUQSS_COMMITS=\
"a1b3431fbd525c30c52a138a72dfba17e4c31a63 \
6e4aab0c82cbf44dae51a91fd7633b49b1f4114d \
339325b9f946004ed40b0fc03c393197391a70b6"

KCP_MA=(cortex-a72 zen3 cooper_lake tiger_lake sapphire_rapids rocket_lake alder_lake)
KCP_IUSE=" ${KCP_MA[@]/#/kernel-compiler-patch-}"

IUSE+=" ${KCP_IUSE} bbrv2 cfi +cfs clang disable_debug futex-wait-multiple
futex2 +genpatches +kernel-compiler-patch lru_gen lto muqss +O3 prjc rt
shadowcallstack tresor tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64
tresor_x86_64-256-bit-key-support uksm zen-sauce -zen-tune zen-tune-muqss"
# genpatches tarball is not downloadable yet
REQUIRED_USE+="
	!muqss
	!genpatches
	^^ ( cfs muqss prjc )
	prjc? ( !rt )
	shadowcallstack? ( cfi )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-tune-muqss? ( muqss zen-tune )"

EXCLUDE_SCS=( alpha amd64 arm hppa ia64 mips ppc ppc64 riscv s390 sparc x86 )
gen_scs_exclusion() {
        for a in ${EXCLUDE_SCS[@]} ; do
                echo " ${a}? ( !shadowcallstack )"
	done
}
REQUIRED_USE+=" "$(gen_scs_exclusion)

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
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
LICENSE+=" prjc? ( GPL-3 )" # see \
  # https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
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
LICENSE+=" lru_gen? ( GPL-2 )"
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

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_cfi_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
		)
		     "
	done
}

gen_shadowcallstack_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
		)
		     "
	done
}

gen_lto_rdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
			=sys-devel/clang-runtime-${v}*
			>=sys-devel/lld-${v}
		)
		"
	done
}

RDEPEND+=" cfi? ( || ( $(gen_cfi_rdepend 12 14) ) )"
RDEPEND+=" lto? ( || ( $(gen_lto_rdepend 11 14) ) )"
RDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_rdepend 10 14) ) ) )"

gen_clang_gcc_pair() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}
			sys-devel/llvm:${v}
		)
		     "
	done
}

KCP_RDEPEND="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-6.5.0
		)
		$(gen_clang_gcc_pair 10 14)
	)
"

KCP_TC0="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC1="
	clang? ( $(gen_clang_gcc_pair 10 14) )
	|| (
		(
			>=sys-devel/gcc-10.3
		)
		$(gen_clang_gcc_pair 10 14)
	)"

KCP_TC2="
	clang? ( $(gen_clang_gcc_pair 12 14) )
	|| (
		(
			>=sys-devel/gcc-11.1
		)
		$(gen_clang_gcc_pair 12 14)
	)"

KCP_MA_RDEPEND="
	kernel-compiler-patch-zen3? ( ${KCP_TC1} )
	kernel-compiler-patch-cooper_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-tiger_lake? ( ${KCP_TC0} )
	kernel-compiler-patch-sapphire_rapids? ( ${KCP_TC2} )
	kernel-compiler-patch-rocket_lake? ( ${KCP_TC2} )
	kernel-compiler-patch-alder_lake? ( ${KCP_TC2} )"

RDEPEND+=" ${KCP_MA_RDEPEND}
	   kernel-compiler-patch? ( ${KCP_RDEPEND} )"

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

# Not on the servers yet
NOT_READY_YET="
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
"

SRC_URI+=" "$(gen_kcp_ma_uri)
SRC_URI+=" bbrv2? ( ${BBRV2_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   futex2? ( ${FUTEX2_SRC_URI} )
	   kernel-compiler-patch? (
		${KCP_SRC_4_9_URI}
		${KCP_SRC_8_1_URI}
		${KCP_SRC_9_0_URI}
	   )
	   kernel-compiler-patch-cortex-a72? (
		${KCP_SRC_CORTEX_A72_URI}
	   )
	   lru_gen? ( ${LRU_GEN_SRC_URI} )
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

	if ! use arm64 && use cfi ; then
ewarn
ewarn "CFI is only offered on the arm64 platform."
ewarn
	fi
	if ! use arm64 && use shadowcallstack ; then
ewarn
ewarn "ShadowCallStack is only offered on the arm64 platform."
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
