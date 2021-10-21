# Copyright 2019-2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel eclass defines common patching steps for any linux
# kernel version.

# bbr2:
#   https://github.com/google/bbr/compare/2c85ebc...v2alpha-2021-07-07
#   https://github.com/google/bbr/compare/f428e49...v2alpha-2021-08-21
#   2c85ebc f428e49 - comes from /Makefile commit history in v2alpha branch
#		      that corresponds to the same version for that tag
# BMQ CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/BMQ
#   https://gitlab.com/alfredchen/projectc/-/blob/master/LICENSE
# futex (aka futex_wait_multiple):
#   https://gitlab.collabora.com/tonyk/linux/-/commits/futex-proton-v3
# futex2:
#   https://gitlab.collabora.com/tonyk/linux/-/commits/futex2
#   https://gitlab.collabora.com/tonyk/linux/-/commits/futex2-proton
# genpatches:
#   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
#   https://dev.gentoo.org/~mpagano/genpatches/releases-4.14.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.4.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.10.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.12.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.14.html
#   The person below who updates the release links above lag. See instead:
#     https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-kernel/gentoo-sources
# kernel_compiler_patch:
#   https://github.com/graysky2/kernel_compiler_patch
#   https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler (official, EOL 5.12):
#   https://github.com/torvalds/linux/compare/v4.14...ckolivas:4.14-ck
#   https://github.com/torvalds/linux/compare/v5.4...ckolivas:5.4-ck
#   https://github.com/torvalds/linux/compare/v5.10...ckolivas:5.10-ck
# MUQSS CPU Scheduler (zen):
#   https://github.com/torvalds/linux/compare/v5.14...zen-kernel:5.14/muqss
# Multigenerational LRU:
#   https://github.com/torvalds/linux/compare/v5.14...zen-kernel:5.14/lru
#   https://github.com/torvalds/linux/compare/v5.14...zen-kernel:5.14/lru-v3
# O3 (Allow O3):
#   5.4 https://github.com/torvalds/linux/commit/4edc8050a41d333e156d2ae1ed3ab91d0db92c7e
#   5.10 https://github.com/torvalds/linux/commit/228e792a116fd4cce8856ea73f2958ec8a241c0c
# O3 (Optimize Harder):
#   4.9 (O3) https://github.com/torvalds/linux/commit/7d0295dc49233d9ddff5d63d5bdc24f1e80da722
#   circa 2018 (infiniband O3 read overflow fix) \
#     https://github.com/torvalds/linux/commit/562a14babcd56efc2f51c772cb2327973d8f90ad
# PDS CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/PDS
#   https://gitlab.com/alfredchen/PDS-mq/-/tree/master
# PGO:
#   https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/clang/pgo
# PREEMPT_RT:
#  https://wiki.linuxfoundation.org/realtime/start
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/4.14/
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.4/
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.10/
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.14/
# Project C CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/Project%20C
#   https://gitlab.com/alfredchen/projectc/-/tree/master
# TRESOR:
#   https://www1.informatik.uni-erlangen.de/tresor
# UKSM:
#   https://github.com/dolohow/uksm
# x86-cfi-v3:
#   https://github.com/torvalds/linux/compare/d0ee23f9...samitolvanen:x86-cfi-v3
#   d0ee23f9 - comes from commit of master
# zen-sauce, zen-tune:
#   https://github.com/torvalds/linux/compare/v5.4...zen-kernel:5.4/zen-sauce
#   https://github.com/torvalds/linux/compare/v5.10...zen-kernel:5.10/zen-sauce
#   https://github.com/torvalds/linux/compare/v5.14...zen-kernel:5.14/zen-sauce

case ${EAPI:-0} in
	7) ;;
	*) die "this eclass doesn't support EAPI ${EAPI}" ;;

esac

# I did a grep -i -r -e "SPDX" ./ | cut -f 3 -d ":" | sort | uniq
# and looked it up through github.com or my copy to confirm the license on the file.

# Solo licenses detected by:
#   `grep -E -r -e "SPDX.*GPL-2" ./ | grep -i -v "GPL"`
# Replace GPL-2 with SPDX identifier

# For kernel license templates see:
# https://github.com/torvalds/linux/tree/master/LICENSES
# See also https://github.com/torvalds/linux/blob/master/Documentation/process/license-rules.rst
LICENSE+=" GPL-2 Linux-syscall-note" #  Applies to whole source  \
#   that are GPL-2 compatible.  See paragraph 3 of the above link for details.
# The following licenses applies to individual files:
LICENSE+=" ZLIB" # See lib/zlib_dfltcc/dfltcc.c, ...
LICENSE+=" ISC" # See linux/drivers/net/wireless/ath/wil6210/trace.c, \
# linux/drivers/net/wireless/ath/ath5k/Makefile, ...
LICENSE+=" all-rights-reserved GPL-2" # See lib/zstd/compress.c, ... ;
# The GPL-2 license doesn't come with all rights reserved.
# The all rights reserved is explicitly stated in several files with GPL.
LICENSE+=" LGPL-2.1" # See fs/ext4/migrate.c, ...
LICENSE+=" LGPL-2+ Linux-syscall-note" # See arch/x86/include/uapi/asm/mtrr.h
LICENSE+=" MIT" # See drivers/gpu/drm/drm_dsc.c
LICENSE+=" BSD-2" # See include/linux/firmware/broadcom/tee_bnxt_fw.h
LICENSE+=" BSD" # See include/linux/packing.h, ...
LICENSE+=" Clear-BSD" # See drivers/net/wireless/ath/ath11k/core.h, ...
LICENSE+=" Apache-2.0" # See drivers/staging/wfx/hif_api_cmd.h

HOMEPAGE+="
          https://algo.ing.unimo.it/people/paolo/disk_sched/
	  https://cchalpha.blogspot.com/search/label/BMQ
	  https://cchalpha.blogspot.com/search/label/PDS
	  https://cchalpha.blogspot.com/search/label/Project%20C
	  https://ck-hack.blogspot.com/
          https://dev.gentoo.org/~mpagano/genpatches/
          https://github.com/dolohow/uksm
          https://github.com/graysky2/kernel_compiler_patch
          https://liquorix.net/
	  https://wiki.linuxfoundation.org/realtime/start
	  https://www1.informatik.uni-erlangen.de/tresor
"

OT_KERNEL_SLOT_STYLE=${OT_KERNEL_SLOT_STYLE:="MAJOR_MINOR"}
KEYWORDS=${KEYWORDS:=\
"~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"}
SLOT=${SLOT:=${PV}}
K_TAG="-ot"
S="${WORKDIR}/linux-${PV}${K_TAG}"

inherit check-reqs ot-kernel-cve toolchain-funcs

BDEPEND+=" dev-util/patchutils
	   sys-apps/grep[pcre]"

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_compile src_install \
		pkg_postinst

# @FUNCTION: gen_kernel_seq
# @DESCRIPTION:
# Generates a sequence for point releases
# @CODE
# Parameters:
# $1 - x >= 2
# @CODE
gen_kernel_seq()
{
	# 1-2 2-3 3-4, $1 >= 2
	local s=""
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" ${s} $((${to}-1))-${to}"
	done
	echo $s
}

# @FUNCTION: gen_zensauce_uris
# @DESCRIPTION:
# Generates zen secret sauce URIs
ZENSAUCE_BASE_URI="https://github.com/torvalds/linux/commit/"
gen_zensauce_uris()
{
	local commits=(${@})
	local len="${#commits[@]}"
	local s=""
	for (( c=0 ; c < ${len} ; c+=1 )) ; do
		local id="${commits[c]}"
		s=" ${s} ${ZENSAUCE_BASE_URI}${id}.patch -> zen-sauce-${K_MAJOR_MINOR}-${id:0:7}.patch"
	done
	echo "$s"
}

BMQ_FN="${BMQ_FN:=v${K_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch}"
BMQ_BASE_URI="https://gitlab.com/alfredchen/bmq/raw/master/${K_MAJOR_MINOR}/"
BMQ_SRC_URI="${BMQ_BASE_URI}${BMQ_FN}"

BBRV2_COMMITS="${PATCH_BBRV2_COMMIT_A}^..${PATCH_BBRV2_COMMIT_D}" # [oldest,newest] [top,bottom]
BBRV2_COMMITS_SHORT=\
"${PATCH_BBRV2_COMMIT_A:0:7}-${PATCH_BBRV2_COMMIT_D:0:7}" # [oldest,newest] [top,bottom]
BBRV2_BASE_URI=\
"https://github.com/google/bbr/compare/${BBRV2_COMMITS}"
BBRV2_FN=\
"bbrv2-${K_MAJOR_MINOR}-${BBRV2_COMMITS_SHORT}.patch"
BBRV2_SRC_URI=\
"${BBRV2_BASE_URI}.patch -> ${BBRV2_FN}"

CLANG_PGO_FN="clang-pgo-${PATCH_CLANG_PGO_COMMIT_A:0:7}-${PATCH_CLANG_PGO_COMMIT_D:0:7}.patch"
CLANG_PGO_BASE_URI="https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/patch/?h=for-next/clang/pgo"
CLANG_PGO_URI="
${CLANG_PGO_BASE_URI}&id=${PATCH_CLANG_PGO_COMMIT_D}&id2=${PATCH_CLANG_PGO_COMMIT_A_PARENT}
		-> ${CLANG_PGO_FN}" # [oldest,newest]

GENPATCHES_URI_BASE_URI="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
GENPATCHES_BASE_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_EXTRAS_FN}"

KCP_COMMIT_SNAPSHOT="f1d0af2c9d807b137909e98c11caf7504f4e2066" # 20210818

KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
KERNEL_SERIES_TARBALL_FN="linux-${K_MAJOR_MINOR}.tar.xz"
KERNEL_INC_BASE_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/incr/"
KERNEL_PATCH_0_TO_1_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/patch-${K_MAJOR_MINOR}.1.xz"

KCP_CORTEX_A72_BN=\
"build-with-mcpu-for-cortex-a72"
if ver_test ${K_MAJOR_MINOR} -ge 5.8 ; then
KCP_9_0_BN=\
"more-uarches-for-kernel-5.8%2B"
KCP_8_1_BN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B"
KCP_4_9_BN=\
"enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B"
elif ver_test ${K_MAJOR_MINOR} -ge 5.4 ; then
KCP_9_0_BN=\
"more-uarches-for-kernel-4.19-5.4"
KCP_8_1_BN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B"
KCP_4_9_BN=\
"enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B"
elif ver_test ${K_MAJOR_MINOR} -ge 4.13 ; then
KCP_8_1_BN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B"
KCP_4_9_BN=\
"enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B"
fi
KCP_URI_BASE=\
"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/${KCP_COMMIT_SNAPSHOT}/"
if [[ -n "${KCP_4_9_BN}" ]] ; then
KCP_SRC_4_9_URI="${KCP_URI_BASE}/outdated_versions/${KCP_4_9_BN}.patch -> ${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch"
fi
if [[ -n "${KCP_8_1_BN}" ]] ; then
KCP_SRC_8_1_URI="${KCP_URI_BASE}/outdated_versions/${KCP_8_1_BN}.patch -> ${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch"
fi
if [[ -n "${KCP_9_0_BN}" ]] ; then
KCP_SRC_9_0_URI="${KCP_URI_BASE}${KCP_9_0_BN}.patch -> ${KCP_9_0_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch"
fi
KCP_SRC_CORTEX_A72_URI="${KCP_URI_BASE}${KCP_CORTEX_A72_BN}.patch -> ${KCP_CORTEX_A72_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch"

LRU_GEN_COMMITS="${PATCH_LRU_GEN_COMMIT_A}^..${PATCH_LRU_GEN_COMMIT_D}" # [oldest,newest] [top,bottom]
LRU_GEN_COMMITS_SHORT=\
"${PATCH_LRU_GEN_COMMIT_A:0:7}-${PATCH_LRU_GEN_COMMIT_D:0:7}" # [oldest,newest] [top,bottom]
LRU_GEN_BASE_URI=\
"https://github.com/torvalds/linux/compare/${LRU_GEN_COMMITS}"
LRU_GEN_FN=\
"lru_gen-${K_MAJOR_MINOR}-${LRU_GEN_COMMITS_SHORT}.patch"
LRU_GEN_SRC_URI=\
"${LRU_GEN_BASE_URI}.patch -> ${LRU_GEN_FN}"

ZEN_LRU_GEN_COMMITS="${PATCH_ZEN_LRU_GEN_COMMIT_A}^..${PATCH_ZEN_LRU_GEN_COMMIT_D}" # [oldest,newest] [top,bottom]
ZEN_LRU_GEN_COMMITS_SHORT=\
"${PATCH_ZEN_LRU_GEN_COMMIT_A:0:7}-${PATCH_ZEN_LRU_GEN_COMMIT_D:0:7}" # [oldest,newest] [top,bottom]
ZEN_LRU_GEN_BASE_URI=\
"https://github.com/torvalds/linux/compare/${ZEN_LRU_GEN_COMMITS}"
ZEN_LRU_GEN_FN=\
"zen-lru_gen-${K_MAJOR_MINOR}-${ZEN_LRU_GEN_COMMITS_SHORT}.patch"
ZEN_LRU_GEN_SRC_URI=\
"${ZEN_LRU_GEN_BASE_URI}.patch -> ${ZEN_LRU_GEN_FN}"

ZEN_MUQSS_BASE_URI=\
"https://github.com/torvalds/linux/commit/"

is_zen_muquss_excluded() {
	local wanted_commit="${1}"
	for bad_commit in ${ZEN_MUQSS_EXCLUDED_COMMITS[@]} ; do
		[[ "${bad_commit}" == "${wanted_commit}" ]] && return 0
	done
	return 1
}

gen_zen_muqss_uris() {
	local s=""
	for c in ${ZEN_MUQSS_COMMITS[@]} ; do
		s+=" ${ZEN_MUQSS_BASE_URI}${c}.patch -> zen-muqss-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
	echo "${s}"
}
ZEN_MUQSS_SRC_URIS=" "$(gen_zen_muqss_uris)

CK_BASE_URI=\
"https://github.com/torvalds/linux/commit/"
gen_ck_uris() {
	local s=""
	for c in ${CK_COMMITS[@]} ; do
		s+=" ${CK_BASE_URI}${c}.patch -> ck-${MUQSS_VER}-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
	echo "${s}"
}
CK_SRC_URIS=" "$(gen_ck_uris)

CFI_X86_BASE_URI=\
"https://github.com/torvalds/linux/commit/"
gen_cfi_x86_uris() {
	local s=""
	for c in ${CFI_X86_COMMITS[@]} ; do
		s+=" ${CFI_X86_BASE_URI}${c}.patch -> cfi-x86-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
	echo "${s}"
}
CFI_X86_SRC_URIS=" "$(gen_cfi_x86_uris)

FUTEX_BASE_URI=\
"https://gitlab.collabora.com/tonyk/linux/-/commit/"
gen_futex_uris() {
	local s=""
	for c in ${FUTEX_COMMITS[@]} ; do
		s+=" ${FUTEX_BASE_URI}${c}.patch -> futex-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
	echo "${s}"
}
FUTEX_SRC_URIS=" "$(gen_futex_uris)

FUTEX2_BASE_URI=\
"https://gitlab.collabora.com/tonyk/linux/-/commit/"
gen_futex2_uris() {
	local s=""
	for c in ${FUTEX2_COMMITS[@]} ; do
		s+=" ${FUTEX2_BASE_URI}${c}.patch -> futex2-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
	echo "${s}"
}
FUTEX2_SRC_URIS=" "$(gen_futex2_uris)

LINUX_REPO_URI=\
"https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

O3_SRC_URI="https://github.com/torvalds/linux/commit/"
O3_ALLOW_FN="O3-allow-unrestricted-${PATCH_ALLOW_O3_COMMIT:0:7}.patch"
O3_ALLOW_SRC_URI="${O3_SRC_URI}${PATCH_ALLOW_O3_COMMIT}.patch -> ${O3_ALLOW_FN}"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT:0:7}.patch"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT:0:7}.patch"
O3_CO_SRC_FN="${PATCH_O3_CO_COMMIT}.patch"
O3_RO_SRC_FN="${PATCH_O3_RO_COMMIT}.patch"
O3_CO_SRC_URI="${O3_SRC_URI}${O3_CO_SRC_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URI="${O3_SRC_URI}${O3_RO_SRC_FN} -> ${O3_RO_FN}"

PDS_URI_BASE=\
"https://gitlab.com/alfredchen/PDS-mq/raw/master/${K_MAJOR_MINOR}/"
PDS_FN="v${K_MAJOR_MINOR}_pds${PATCH_PDS_V}.patch"
PDS_SRC_URI="${PDS_URI_BASE}${PDS_FN}"

PRJC_URI_BASE=\
"https://gitlab.com/alfredchen/projectc/-/raw/master/${K_MAJOR_MINOR}/"
PRJC_FN="prjc_v${PATCH_PROJC_VER}.patch"
PRJC_SRC_URI="${PRJC_URI_BASE}${PRJC_FN}"

RT_BASE_URI=\
"http://cdn.kernel.org/pub/linux/kernel/projects/rt/${K_MAJOR_MINOR}/"
RT_FN="patches-${PATCH_RT_VER}.tar.xz"
RT_SRC_URI="${RT_BASE_URI}${RT_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_V}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_V}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_PDF_FN="tresor.pdf"
TRESOR_DOMAIN_URI="www1.informatik.uni-erlangen.de"
TRESOR_BASE_URI=\
"https://${TRESOR_DOMAIN_URI}/filepool/projects/tresor/"
TRESOR_AESNI_SRC_URI="${TRESOR_BASE_URI}${TRESOR_AESNI_FN}"
TRESOR_I686_SRC_URI="${TRESOR_BASE_URI}${TRESOR_I686_FN}"
TRESOR_SYSFS_SRC_URI="${TRESOR_BASE_URI}${TRESOR_SYSFS_FN}"
TRESOR_README_SRC_URI=\
"https://${TRESOR_DOMAIN_URI}/tresor?q=content/readme"
TRESOR_RESEARCH_PDF_SRC_URI=\
"${TRESOR_BASE_URI}${TRESOR_PDF_FN}"
TRESOR_README_SRC_URI="${TRESOR_README_SRC_URI} -> ${TRESOR_README_FN}"

UKSM_BASE_URI=\
"https://raw.githubusercontent.com/dolohow/uksm/master/v${K_MAJOR}.x/"
UKSM_FN="uksm-${K_MAJOR_MINOR}.patch"
UKSM_SRC_URI="${UKSM_BASE_URI}${UKSM_FN}"

ZENSAUCE_URIS=$(gen_zensauce_uris "${PATCH_ZENSAUCE_COMMITS[@]}")

if ver_test ${PV} -eq ${K_MAJOR_MINOR} ; then
KERNEL_NO_POINT_RELEASE="1"
elif ver_test ${PV} -eq ${K_MAJOR_MINOR}.0 ; then
KERNEL_0_TO_1_ONLY="1"
fi

if [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
	KERNEL_PATCH_URIS=()
elif [[ -n "${KERNEL_0_TO_1_ONLY}" && "${KERNEL_0_TO_1_ONLY}" == "1" ]] ; then
	KERNEL_PATCH_URIS=(${KERNEL_PATCH_0_TO_1_URI})
	KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz)
	KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1)
else
	KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(ver_cut 3 ${PV})))
	KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
	KERNEL_PATCH_FNS_EXT=\
(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_FNS_NOEXT=\
(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_URIS=\
(${KERNEL_PATCH_0_TO_1_URI} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASE_URI}})
	KERNEL_PATCH_FNS_EXT=\
(patch-${K_MAJOR_MINOR}.1.xz ${KERNEL_PATCH_FNS_EXT[@]})
	KERNEL_PATCH_FNS_NOEXT=\
(patch-${K_MAJOR_MINOR}.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
fi

PATCH_OPS="--no-backup-if-mismatch -r - -p1"

RESTRICT="mirror"

# @FUNCTION: _fpatch
# @DESCRIPTION:
# Filtered patch
# @CODE
# Parameters:
# $1 - path of the patch
# @CODE
function _fpatch() {
	local path="${1}"
	local msg_extra="${2}"
	if declare -f ot-kernel_filter_patch_cb > /dev/null ; then
		ot-kernel_filter_patch_cb "${path}"
	else
		_dpatch "${PATCH_OPS}" "${path}" "${msg_extra}"
	fi
}

# @FUNCTION: _dpatch
# @DESCRIPTION:
# Patch with die
function _dpatch() {
	local opts="${1}"
	local path="${2}"
	local msg_extra="${3}"
einfo "Applying ${path}${msg_extra}"
	patch ${opts} -i "${path}" || die
}

# @FUNCTION: _tpatch
# @DESCRIPTION:
# Patch with no die used for conflict resolution.
# Refrain from using it though because it requires periodic revaluation in
# larger patchsets that are not split which future FAILED hunks may not be
# caught.
function _tpatch() {
	local opts="${1}"
	local path="${2}"
	local failed_hunks_acceptable="${3}" # must be the same as n_failures (part 1)
	local reversed_acceptable="${4}" # must be the same as n_reversed (part 2)
	local msg_extra="${5}"
einfo
einfo "Applying ${path}${msg_extra}"
einfo "  with ${failed_hunks_acceptable} hunk(s) failed and"
einfo "  with ${reversed_acceptable} already patched warnings"
einfo "which will be resolved or patched immediately."
einfo
einfo "These estimates may be far less than the actual."
einfo

	local n_failures=0
	for x_i in $(patch ${opts} --dry-run -i "${path}" \
		| grep -E -e "hunks? FAILED" | cut -f 1 -d " ") ; do
		n_failures=$((${n_failures}+${x_i}))
	done
	if (( ${n_failures} != ${failed_hunks_acceptable} )) ; then
eerror
eerror "${path} needs a rebase. n_failures=${n_failures} \
failed_hunks_acceptable=${failed_hunks_acceptable}"
eerror
		die
	fi

	local n_reversed=$(patch ${opts} --dry-run -i "${path}" \
			| grep -F -e "Reversed (or previously applied) patch detected!" \
			| wc -l)
	if (( ${n_reversed} != ${reversed_acceptable} )) ; then
eerror
eerror "${path} needs a rebase. n_reversed=${n_reversed} \
reversed_acceptable=${reversed_acceptable}"
eerror
		die
	fi

	if (( ${reversed_acceptable} > 0 )) ; then
		opts="-N ${opts}"
	fi

	patch ${opts} -i "${path}" || true
}

# @FUNCTION: ot-kernel_pkg_pretend
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel_pkg_pretend() {
	if declare -f ot-kernel_pkg_pretend_cb > /dev/null ; then
		ot-kernel_pkg_pretend_cb
	fi
}

# @FUNCTION: _report_eol
# @DESCRIPTION:
# Reports the estimated End Of Life (EOL).  Sourced from
# https://www.kernel.org/category/releases.html
function _report_eol() {
	if [[ "${K_MAJOR_MINOR}" == "5.10" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is"
einfo "Dec 2022."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${K_MAJOR_MINOR}" == "5.4" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is"
einfo "Dec 2025."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${K_MAJOR_MINOR}" == "4.19" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is"
einfo "Dec 2024."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	elif [[ "${K_MAJOR_MINOR}" == "4.14" ]] ; then
einfo
einfo "The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is"
einfo "Jan 2024."
einfo
einfo "Use the virtual/ot-sources-lts meta package to ensure proper updates in"
einfo "the same major.minor branch."
einfo
	else
ewarn
ewarn "The ${K_MAJOR_MINOR} kernel series is not a Long Term Support (LTS)"
ewarn "kernel.  It may suddenly stop receiving security updates completely"
ewarn "between a week to several months."
ewarn
einfo
einfo "Use the virtual/ot-sources-stable meta package to ensure a smooth"
einfo "updates between stable releases differing between major.minor branches"
einfo
	fi
}

# @FUNCTION: check_zen_tune_deps
# @DESCRIPTION:
# Checks zen-tune's dependency on zen-sauce
check_zen_tune_deps() {
	local zentune_commit="${1}"
	local v="ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}"
	if ver_test ${K_MAJOR_MINOR} -ge 5.10 ; then
		for p in ${PATCH_ZENTUNE_COMMITS_DEPS_ZENSAUCE[@]} ; do
			local ztc=$(echo "${p}" | cut -f 1 -d ":")
			local zsc=$(echo "${p}" | cut -f 2 -d ":")
			if [[ ${ztc} == ${zentune_commit} ]] ; then
				if [[ ! ( ${!v} =~ ${zsc} || ${!v} =~ ${zsc:0:7} ) ]] ; then
eerror "zen-tune requires ${zsc} be added to ${v} and also the zen-sauce USE flag"
					die
				fi
			fi
		done
	fi
}

# @FUNCTION: zentune_setup
# @DESCRIPTION:
# Checks zen-tune's dependency on zen-sauce at pkg_setup
function zentune_setup() {
	if use zen-sauce ; then
		for c in ${PATCH_ZENTUNE_COMMITS[@]} ; do
			check_zen_tune_deps "${c}"
		done
	fi
}

# @FUNCTION: zensauce_setup
# @DESCRIPTION:
# Checks the existance for the ZENSAUCE_WHITELIST_5_3 variable
function zensauce_setup() {
	if use zen-sauce ; then
		local v1="ZENMISC_WHITELIST_${K_MAJOR_MINOR/./_}"
		if [[ -n "${!v1}" ]] ; then
eerror
eerror "ZENMISC_WHITELIST_${K_MAJOR_MINOR/./_} has been been renamed to"
eerror "ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}.  Rename or remove this envvar"
eerror "to continue"
eerror
			die
		fi

		local ZW="ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}"
		if [[ -z "${!ZW}" ]] ; then
			local zensauce_uri
			local zensauce_cmprange=\
"v${K_MAJOR_MINOR}...zen-kernel:${K_MAJOR_MINOR}"
			local zensauce_cmpbase_uri=\
"https://github.com/torvalds/linux/compare/${zensauce_cmprange}"
			if ver_test ${PV} -ge 5.4 ; then
				zensauce_uri=\
"${zensauce_cmpbase_uri}/zen-sauce"
			else
				zensauce_uri=\
"${zensauce_cmpbase_uri}/misc"
			fi

eerror
eerror "You must define a ZENSAUCE_WHITELIST_${K_MAJOR_MINOR//./_} in your"
eerror "/etc/make.conf or as a per-package env containing commits to accepted"
eerror "from ${zensauce_uri}.  You may supply the envvar with a space as a"
eerror "placeholder."
eerror
eerror "For example:"
eerror
eerror "  ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}=\"\
214d031dbeef940efe1dbba274caf5ccc4ff2774 \
83d7f482c60b6dfda030325394ec07baac7f5a30\""
eerror "  ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}=\"214d031 83d7f48\""
eerror "  ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}=\" \""
eerror "Only 40 or 7 digit commit IDs are accepted."
eerror
			die
		fi
	fi
}

# @FUNCTION: _check_network_sandbox
# @DESCRIPTION:
# Check if sandbox is more lax when downloading in unpack phase
function _check_network_sandbox() {
	# justifications
	# cve-hotfix - requires to download patch URI linked from NVD website
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to use live patches."
eerror
		die
	fi
}

NO_INSTR_FIX_COMMIT="193e41c987127aad86d0380df83e67a85266f1f1"
NO_INSTR_FIX_TIMESTAMP="1624048424" # Fri Jun 18 08:33:44 PM UTC 2021

NO_INSTRUMENT_FUNCTION="a63d4f6cbab133b0f1ce9afb562546fcc5bb2680"
NO_INSTRUMENT_FUNCTION_TIMESTAMP="1624300463" # Mon Jun 21 06:34:23 PM UTC 2021

verify_clang_compiler_updated() {
	local p
	for p in "sys-devel/llvm-13.0.0.9999" "sys-devel/clang-13.0.0.9999" "sys-devel/clang-runtime-13.0.0.9999" ; do
		einfo "Verifying prereqs for PGO for ${p}"
		if has_version "=${p}" ; then
			local emerged_llvm_commit=$(bzless \
				"${ESYSROOT}/var/db/pkg/${p}/environment.bz2" \
				| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
			local emerged_llvm_time_desc=$(wget -q -O - \
				https://github.com/llvm/llvm-project/commit/${emerged_llvm_commit}.patch \
				| grep -F -e "Date:" | sed -e "s|Date: ||")
			local emerged_llvm_timestamp=$(date -u -d "${emerged_llvm_time_desc}" +%s)
			if (( ${emerged_llvm_timestamp} <= ${NO_INSTRUMENT_FUNCTION_TIMESTAMP} )) \
				&& (( ${emerged_llvm_timestamp} <= ${NO_INSTRUMENT_FUNCTION_TIMESTAMP} )) ; then
				die "Re-emerge =${p}"
			else
				# If on the same day it may be broken
				einfo "Clang and LLVM is up-to-date"
			fi
		fi
	done
}

IPD_RAW_V=5 # < llvm-13 Dec 28, 2020
IPD_RAW_V_MIN=6
IPD_RAW_V_MAX=7
verify_profraw_compatibility() {
	einfo "Verifying profraw version compatibility"
	# The profiling data format is very version sensitive.
	# If wrong version, expect something like this:
	# warning: /usr/src/linux/vmlinux.profraw: unsupported instrumentation profile format version
	# error: no profile can be merged

# This data structure must be kept in sync.
# https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/tree/kernel/pgo/fs.c?h=for-next/clang/pgo#n63
# https://github.com/llvm/llvm-project/blob/main/compiler-rt/include/profile/InstrProfData.inc#L130

	local found_upstream_version=0 # corresponds to original patch requirements for < llvm 13 (broken)
	local found_patched_version=0 # corresponds to oiledmachine patches to use >= llvm 13 (fixed)
	local v
	for v in "10.0.1" "11.1.0" "12.0.1" "13.0.0" "13.0.0.9999" "14.0.0.9999" ; do
		(! has_version "~sys-devel/llvm-${v}" ) && continue
		local llvm_version
		if [[ "${v}" =~ "9999" ]] ; then
			local llvm_version=$(bzless \
				"${ESYSROOT}/var/db/pkg/sys-devel/llvm-${v}"*"/environment.bz2" \
				| grep -F -e "EGIT_VERSION" | head -n 1 | cut -f 2 -d '"')
		else
			llvm_version="llvmorg-${v/_/-}"
		fi
		local instr_prof_raw_v=$(wget -q -O - \
https://raw.githubusercontent.com/llvm/llvm-project/${llvm_version}/llvm/include/llvm/ProfileData/InstrProfData.inc \
			| grep "INSTR_PROF_RAW_VERSION" \
			| head -n 1 \
			| grep -E -o -e "[0-9]+")
		if (( ${instr_prof_raw_v} == ${IPD_RAW_V} )) ; then
			found_upstream_version=1
		fi
		if (( ${instr_prof_raw_v} >= ${IPD_RAW_V_MIN} && ${instr_prof_raw_v} <= ${IPD_RAW_V_MAX} )) ; then
			found_patched_version=1
		fi
	done
	if (( ${found_upstream_version} != 1 )) ; then
eerror
eerror "No installed LLVM versions are with compatible."
eerror "INSTR_PROF_RAW_VERSION == ${IPD_RAW_V} is required"
eerror
		ewarn
	fi
	if (( ${found_patched_version} != 1 )) ; then
eerror
eerror "INSTR_PROF_RAW_VERSION >= ${IPD_RAW_V_MIN} and"
eerror "INSTR_PROF_RAW_VERSION <= ${IPD_RAW_V_MAX} is required"
eerror
eerror "No installed LLVM versions are compatible.  Please send an issue"
eerror "request with your LLVM version.  If you are using a live LLVM version,"
eerror "send the EGIT_VERSION found in"
eerror "\${ESYSROOT}/var/db/pkg/sys-devel/llvm-\${v}*/environment.bz2"
eerror
		die
	fi
}

# @FUNCTION: ot-kernel_pkg_setup
# @DESCRIPTION:
# Perform checks, warnings, and initialization before emerging
function ot-kernel_pkg_setup() {
	_report_eol
	if declare -f ot-kernel_pkg_setup_cb > /dev/null ; then
		ot-kernel_pkg_setup_cb
	fi
	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		if use zen-sauce ; then
			zensauce_setup
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
			zentune_setup
		fi
	fi
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		if use cve_hotfix ; then
			_check_network_sandbox
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if [[ -z "${OT_KERNEL_DEVELOPER}" ]] && use tresor ; then
			if use tresor_i686 && ! grep -F -q "sse2" /proc/cpuinfo ; then
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
					die "tresor_i686 requires SSE2 CPU support"
				fi
				if ! grep -F -q "mmx" /proc/cpuinfo ; then
					die "tresor_i686 requires MMX CPU support"
				fi
			elif use tresor_x86_64 && ! grep -F -q "sse2" /proc/cpuinfo ; then
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
					die "tresor_x86_64 requires SSE2 CPU support"
				fi
				if ! grep -F -q "mmx" /proc/cpuinfo ; then
					die "tresor_x86_64 requires MMX CPU support"
				fi
			elif use tresor_aesni ; then
				if ! grep -F -q "aes" /proc/cpuinfo ; then
					die "tresor_aesni requires AES-NI CPU support"
				fi
				if ! grep -F -q "sse2" /proc/cpuinfo ; then
					die "tresor_aesni requires SSE2 CPU support"
				fi
			fi
		fi
	fi

	if has clang-pgo ${IUSE_EFFECTIVE} ; then
		if use clang-pgo ; then
			verify_clang_compiler_updated
			verify_profraw_compatibility
		fi
	fi
}

# @FUNCTION: get_current_tag_for_k_major_minor_branch
# @DESCRIPTION:
# Gets the tag name at HEAD
function get_current_tag_for_k_major_minor_branch() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	pushd "${d}" 2>/dev/null 1>/dev/null || die
		echo $(git --no-pager tag --points-at HEAD)
	popd 2>/dev/null 1>/dev/null
}

# @FUNCTION: get_current_commit_for_k_major_minor_branch
# @DESCRIPTION:
# Gets the commit ID at HEAD
function get_current_commit_for_k_major_minor_branch() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	pushd "${d}" 2>/dev/null 1>/dev/null || die
		echo $(git rev-parse HEAD)
	popd 2>/dev/null 1>/dev/null
}

# @FUNCTION: ot-kernel_fetch_linux_sources
# @DESCRIPTION:
# Fetches a local copy of the linux kernel repo.
function ot-kernel_fetch_linux_sources() {
einfo "Fetching the vanilla Linux kernel sources.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}" || die
	d="${distdir}/ot-sources-src/linux"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}" || die

	if [[ -d "${d}" ]] ; then
		pushd "${d}" || die
		if ! ( git remote -v | grep -F -e "${LINUX_REPO_URI}" ) \
			> /dev/null ; \
		then
einfo "Removing ${d}"
			rm -rf "${d}" || die
		fi
		popd
	fi

	addwrite "${b}"

	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}" || die
einfo "Cloning the vanilla Linux kernel project"
		git clone "${LINUX_REPO_URI}" "${d}"
		cd "${d}" || die
		git checkout master
		if [[ -n "${FETCH_VANILLA_SOURCES_BY_TAG}" \
			&& "${FETCH_VANILLA_SOURCES_BY_TAG}" == "1" ]] ; then
			git checkout -b v${PV} tags/v${PV}
		elif [[ -n "${FETCH_VANILLA_SOURCES_BY_BRANCH}" \
			&& "${FETCH_VANILLA_SOURCES_BY_BRANCH}" == "1" ]] ; then
			git checkout -b linux-${K_MAJOR_MINOR}.y \
				origin/linux-${K_MAJOR_MINOR}.y
		fi
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
die "You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
einfo "Updating the vanilla Linux kernel project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		if [[ -n "${FETCH_VANILLA_SOURCES_BY_TAG}" \
			&& "${FETCH_VANILLA_SOURCES_BY_TAG}" == "1" ]] ; then
			git branch -D v${PV}
			git checkout -b v${PV} tags/v${PV}
		elif [[ -n "${FETCH_VANILLA_SOURCES_BY_BRANCH}" \
			&& "${FETCH_VANILLA_SOURCES_BY_BRANCH}" == "1" ]] ; then
			git branch -D linux-${K_MAJOR_MINOR}.y
			git checkout -b linux-${K_MAJOR_MINOR}.y \
				origin/linux-${K_MAJOR_MINOR}.y
		fi
		git pull
		if [[ -n "${TEST_REWIND_SOURCES_BACK_TO}" ]] ; then
			git checkout ${TEST_REWIND_SOURCES_BACK_TO}
		fi
	fi
	cd "${d}" || die
}

# @FUNCTION: ot-kernel_unpack_tarball
# @DESCRIPTION:
# Unpacks the main tarball
ot-kernel_unpack_tarball() {
	cd "${WORKDIR}" || die
	unpack "${KERNEL_SERIES_TARBALL_FN}"
}

# @FUNCTION: ot-kernel_unpack_tarball
# @DESCRIPTION:
# Unpacks all point release tarballs
ot-kernel_unpack_point_releases() {
	cd "${T}" || die
	for p in ${KERNEL_PATCH_FNS_EXT[@]} ; do
		unpack "${p}"
	done
}

# @FUNCTION: apply_rt
# @DESCRIPTION:
# Apply the PREEMPT_RT patches.
function apply_rt() {
einfo "Applying PREEMPT_RT patches"
	mkdir -p "${T}/rt" || die
	pushd "${T}/rt" || die
		unpack "${DISTDIR}/${RT_FN}"
	popd
	for p in $(cat "${T}/rt/patches/series" | grep -E -e "^[^#]") ; do
		_fpatch "${T}/rt/patches/${p}"
	done
}

# @FUNCTION: apply_zensauce
# @DESCRIPTION:
# Applies whitelisted zen sauce patches.
function apply_zensauce() {
	local ZW="ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}"
	local ZB="ZENSAUCE_BLACKLIST_${K_MAJOR_MINOR/./_}"

	local whitelisted=""
	local blacklisted=""

	for c in ${!ZW} ; do
		whitelisted+=" ${c:0:7}"
	done

	for c in ${!ZB} ; do
		blacklisted+=" ${c:0:7}"
	done

	if has O3 ${IUSE_EFFECTIVE} ; then
		if use O3 ; then
			whitelisted+=" ${PATCH_ALLOW_O3_COMMIT:0:7}"
		fi
	fi

	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
			for c in ${PATCH_ZENTUNE_COMMITS[@]} ; do
				whitelisted+=" ${c:0:7}"
			done
		fi
	fi

	if has zen-sauce-all ${IUSE_EFFECTIVE} ; then
		if use zen-sauce-all ; then
			for c in ${PATCH_ZENSAUCE_COMMITS[@]} ; do
				whitelisted+=" ${c:0:7}"
			done
		fi
	fi

	use_blacklisted+=" ${PATCH_ZENSAUCE_BL[@]}"

	whitelisted=$(echo "${whitelisted}" | tr " " "\n"| sort | uniq | tr "\n" " ")
	blacklisted=$(echo "${blacklisted}" | tr " " "\n"| sort | uniq | tr "\n" " ")
	use_blacklisted=$(echo "${use_blacklisted}" | tr " " "\n"| sort | uniq | tr "\n" " ")

	for c in ${PATCH_ZENSAUCE_COMMITS[@]} ; do
		local is_whitelisted=0
		for c_wl in ${whitelisted[@]} ; do
			if [[ "${c:0:7}" == "${c_wl:0:7}" ]] ; then
				is_whitelisted=1
				break
			fi
		done
		(( ${is_whitelisted} == 0 )) && continue

		local is_blacklisted=0
		if [[ -n "${#use_blacklisted}" ]] ; then
			for c_bl in ${use_blacklisted} ; do
				if [[ "${c:0:7}" == "${c_bl:0:7}" ]] ; then
ewarn
ewarn "If ${c} is already applied via USE flag.  Please remove it from the"
ewarn "ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_} and use the USE flag instead."
ewarn "This is to ensure the BDEPENDS/RDEPENDS/DEPENDs are met."
ewarn "Skipping ${c} for now."
ewarn
					is_blacklisted=1
					break
				fi
			done
		fi
		(( ${is_blacklisted} == 0 )) && continue

		local is_blacklisted=0
		if [[ -n "${#blacklisted}" ]] ; then
			for c_bl in ${blacklisted} ; do
				if [[ "${c:0:7}" == "${c_bl:0:7}" ]]
				then
einfo
einfo "Skipping ${c}"
einfo
					is_blacklisted=1
					break
				fi
			done
		fi
		(( ${is_blacklisted} == 0 )) && continue

		_fpatch "${DISTDIR}/zen-sauce-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_cfi_x86
# @DESCRIPTION:
# Adds cfi protection for the x86-64 platform
function apply_cfi_x86() {
	for c in ${CFI_X86_COMMITS[@]} ; do
		_fpatch "${DISTDIR}/cfi-x86-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_futex
# @DESCRIPTION:
# Adds a new syscall operation FUTEX_WAIT_MULTIPLE to the futex
# syscall.  It may shave of < 5% CPU usage.
function apply_futex() {
	for c in ${FUTEX_COMMITS[@]} ; do
		_fpatch "${DISTDIR}/futex-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_futex2
# @DESCRIPTION:
# Adds a new futex2 syscalls.  It may shave of < 5% CPU usage.
function apply_futex2() {
	for c in ${FUTEX2_COMMITS[@]} ; do
		local blacklisted=0
		if has futex2-proton ${IUSE_EFFECTIVE} ; then
			if ! use futex2-proton ;then
				for b in ${FUTEX2_PROTON_COMPAT[@]} ; do
					if [[ "${b}" == "${c}" ]] ; then
						blacklisted=1
						break
					fi
				done
			fi
			(( ${blacklisted} == 1 )) && continue
		fi
		_fpatch "${DISTDIR}/futex2-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_bbrv2
# @DESCRIPTION:
# Adds BBRv2 to have ~ 1% retransmits in comparison to BBRv1 at ~ 5%
# the expense of some bandwidth (~ 10 mbps) relative to BBR but significantlly
# better than CUBIC.  BBRv1 will will still maintain ~ 38% throughput after
# some packet loss 3% but CUBIC will have < 1% thoughput when there is a
# few percent of packet loss.
function apply_bbrv2() {
	_fpatch "${DISTDIR}/${BBRV2_FN}"
}

# @FUNCTION: apply_lru_gen
# @DESCRIPTION:
# Uses multigenerational LRU to improve page reclamation.
function apply_lru_gen() {
	_fpatch "${DISTDIR}/${LRU_GEN_FN}"
}

# @FUNCTION: apply_zen_lru_gen
# @DESCRIPTION:
# Uses zen's modified multigenerational LRU to improve page reclamation.
function apply_zen_lru_gen() {
	_fpatch "${DISTDIR}/${ZEN_LRU_GEN_FN}"
}

# @FUNCTION: _filter_genpatches
# @DESCRIPTION:
# Applies a genpatch if not blacklisted.
#
# Define GENPATCHES_BLACKLIST as a space seperated string in make.conf or
# as a per-package env
#
# For example,
# GENPATCHES_BLACKLIST="2500 2600"
function _filter_genpatches() {
	P_GENPATCHES_BLACKLIST=""
	if ! use genpatches_1510 ; then
		# Possibly locks up computer during OOM tests
		P_GENPATCHES_BLACKLIST+=" 1510"
	fi
	# Already applied since 5.13.14
	P_GENPATCHES_BLACKLIST+=" 2700"
	# Already applied 5010-5013 GraySky2's kernel_compiler_patches
	P_GENPATCHES_BLACKLIST+=" 5010 5011 5012 5013"
	# Already applied 5000-5007 ZSTD patches
	P_GENPATCHES_BLACKLIST+=" 5000 5001 5002 5003 5004 5005 5006 5007"
	# Already applied bmq.
	P_GENPATCHES_BLACKLIST+=" 5020 5021"
	# Already applied the pelt.h patch conditionally.
	P_GENPATCHES_BLACKLIST+=" 5022"
	if declare -f ot-kernel_filter_genpatches_blacklist_cb > /dev/null ; then
		# Disable failing patches
		P_GENPATCHES_BLACKLIST+=$(ot-kernel_filter_genpatches_blacklist_cb)
	fi

	pushd "${d}" || die
		for f in $(ls -1) ; do
#einfo "Processing ${f}"
			if [[ "${f}" =~ \.patch$ ]] ; then
				local l=$(echo "${f}" | cut -f 1 -d"_")
				if (( ${l} < 1500 )) ; then
					# vanilla kernel inc patches
					# already applied
					continue
				fi
				local is_blacklisted
				is_blacklisted=0
				for x in ${P_GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklisted=1
						break
					fi
				done
				if [[ "${is_blacklisted}" == "1" ]] ; then
einfo "Skipping genpatches ${l}"
					continue
				fi

				is_blacklisted=0
				for x in ${GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklisted=1
						break
					fi
				done
				if [[ "${is_blacklisted}" == "1" ]] ; then
einfo "Skipping genpatches ${l}"
					continue
				fi

				pushd "${S}" || die
					_fpatch "${d}/${f}"
				popd
			fi
		done
	popd
}

# @FUNCTION: apply_bmq
# @DESCRIPTION:
# Apply the BMQ CPU scheduler patchset.
function apply_bmq() {
	cd "${S}" || die
einfo "Applying bmq"
	_fpatch "${DISTDIR}/${BMQ_FN}"
}

# @FUNCTION: apply_ck
# @DESCRIPTION:
# applies the ck patchset
function apply_ck() {
	for c in ${CK_COMMITS[@]} ; do
		local blacklisted=0
		for b in ${CK_COMMITS_BL[@]} ; do
			if [[ "${c}" == "${b}" ]] ; then
				blacklisted=1
				break
			fi
			if ver_test ${K_MAJOR_MINOR} -eq 4.14 ; then
				if ! use bfq-mq ; then
					for b2 in ${CK_BFQ_MQ[@]} ; do
						if [[ "${c}" == "${b2}" ]] ; then
							blacklisted=1
							break
						fi
					done
				fi
			fi
			(( ${blacklisted} == 1 )) && break
		done
		(( ${blacklisted} == 1 )) && continue
		_fpatch "${DISTDIR}/ck-${MUQSS_VER}-${K_MAJOR_MINOR}-${c:0:7}.patch"
	done
}

# @FUNCTION: apply_genpatches_base
# @DESCRIPTION:
# Apply the base genpatches patchset.
function apply_genpatches_base() {
einfo "Applying the genpatches base"
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d" || die
	unpack "${GENPATCHES_BASE_FN}"

	sed -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" \
		"${S}"/Makefile \
		|| die

	# Section replaced by apply_vanilla_point_release

	sed -i -e "s|EXTRAVERSION =|EXTRAVERSION = ${EXTRAVERSION}|" \
		"${S}"/Makefile \
		|| die

	cd "${S}" || die

	_filter_genpatches
}

# @FUNCTION: apply_genpatches_experimental
# @DESCRIPTION:
# Apply the experimental genpatches patchset.
function apply_genpatches_experimental() {
einfo "Applying genpatches experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d" || die
	unpack "${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}" || die

	_filter_genpatches
}

# @FUNCTION: apply_genpatches_extras
# @DESCRIPTION:
# Apply the extra genpatches patchset.
function apply_genpatches_extras() {
einfo "Applying genpatches extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d" || die
	unpack "${GENPATCHES_EXTRAS_FN}"

	cd "${S}" || die
	_filter_genpatches
}

# @FUNCTION: apply_o3
# @DESCRIPTION:
# Apply the O3 patchset.
#
# ot-kernel_apply_o3_fixes - callback for fix to O3 patches
#
function apply_o3() {
	cd "${S}" || die
	if ver_test "${K_MAJOR_MINOR}" -eq 4.14 ; then
		# fix patch
		sed -e 's|-1028,6 +1028,13|-1076,6 +1076,13|' \
			"${DISTDIR}/${O3_CO_FN}" \
			> "${T}/${O3_CO_FN}" || die

einfo "Applying O3"
einfo "Applying ${O3_CO_FN}"
		_fpatch "${T}/${O3_CO_FN}"

einfo "Applying ${O3_RO_FN}"
		mkdir -p drivers/gpu/drm/amd/display/dc/basics/
		# trick patch for unattended patching
		touch drivers/gpu/drm/amd/display/dc/basics/logger.c
		_fpatch "${DISTDIR}/${O3_RO_FN}"
	fi
}

# @FUNCTION: apply_pds
# @DESCRIPTION:
# Apply the PDS CPU scheduler patchset.
function apply_pds() {
	cd "${S}" || die
einfo "Applying PDS"
	_fpatch "${DISTDIR}/${PDS_FN}"
}

# @FUNCTION: apply_prjc
# @DESCRIPTION:
# Apply the Project C CPU scheduler patchset.
function apply_prjc() {
	cd "${S}" || die
einfo "Applying Project C"
	_fpatch "${DISTDIR}/${PRJC_FN}"
}

# @FUNCTION: apply_tresor
# @DESCRIPTION:
# Apply the TRESOR AES cold boot resistant patchset.
#
# ot-kernel_apply_tresor_fixes - callback to apply tresor fixes
#
function apply_tresor() {
	cd "${S}" || die
einfo "Applying TRESOR"
	local platform
	if use tresor_aesni ; then
		platform="aesni"
	fi
	if use tresor_i686 || use tresor_x86_64 ; then
		platform="i686"
	fi

	_fpatch \
		"${DISTDIR}/tresor-patch-${PATCH_TRESOR_V}_${platform}"
	sed -i -E -e "s|[ ]?-tresor[0-9.]+||g" "${S}/Makefile" || die
}

# @FUNCTION: apply_uksm
# @DESCRIPTION:
# Apply the UKSM patches.
#
# ot-kernel_uksm_fixes - callback to fix the patch
#
function apply_uksm() {
	_fpatch "${DISTDIR}/${UKSM_FN}"
}

# @FUNCTION: apply_vanilla_point_releases
# @DESCRIPTION:
# Applies all the point releases
function apply_vanilla_point_releases() {
	if [[ -n "${KERNEL_NO_POINT_RELEASE}" \
		&& "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; \
		then
		true
	else
		# genpatches places kernel incremental patches starting at 1000
		for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
			local f="${T}/${a}"
			cd "${T}" || die
			unpack "$a.xz"
			cd "${S}" || die
			patch --dry-run ${PATCH_OPS} -N "${f}" \
				| grep -F -e "FAILED at"
			if [[ "$?" == "1" ]] ; then
				# already patched or good
				_fpatch "${f}"
			else
eerror "Failed ${a}"
				die
			fi
		done
	fi
}

# @FUNCTION: apply_zen_muqss
# @DESCRIPTION:
# Apply a fork of MuQSS maintained by the zen-kernel team.
function apply_zen_muqss() {
einfo "Applying some of the zen-kernel MuQSS patches"
	for x in ${ZEN_MUQSS_COMMITS[@]} ; do
		local id="${x:0:7}"
		is_zen_muquss_excluded "${x}" && continue
		_fpatch "${DISTDIR}/zen-muqss-${K_MAJOR_MINOR}-${id}.patch"
	done
}

# @FUNCTION: apply_clang_pgo
# @DESCRIPTION:
# Apply the PGO patch for use with clang
apply_clang_pgo() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	_fpatch "${distdir}/${CLANG_PGO_FN}"
}

# @FUNCTION: ot-kernel_src_unpack
# @DESCRIPTION:
# Applies patch sets in order.
function ot-kernel_src_unpack() {
	_PATCHES=()
	if [[ "${IUSE}" =~ kernel-compiler-patch ]] ; then
		local gcc_v=$(best_version "sys-devel/gcc" | sed -e "s|sys-devel/gcc-||")
		local clang_v=$(best_version "sys-devel/clang" | sed -e "s|sys-devel/clang-||")
		#local vendor_id=$(cat /proc/cpuinfo | grep vendor_id | head -n 1 | cut -f 2 -d ":" | sed -E -e "s|[ ]+||g")
		#local cpu_family=$(printf "%02x" $(cat /proc/cpuinfo | grep -F -e "cpu family" | head -n 1 | grep -E -o "[0-9]+"))
		#local cpu_model=$(printf "%02x" $(cat /proc/cpuinfo | grep -F -e "model" | head -n 1 | grep -E -o "[0-9]+"))
einfo "Best GCC version:  ${gcc_v}"
einfo "Best Clang version:  ${clang_v}"

		if (  (				 $(ver_test ${gcc_v}   -ge 9.0) ) \
		   || ( [[ -n "${clang_v}" ]] && $(ver_test ${clang_v} -ge 9.0) ) \
		   ) \
			&& test -f "${DISTDIR}/${KCP_9_0_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 9.0 or clang >= 9.0."
			_PATCHES+=( "${DISTDIR}/${KCP_9_0_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch")
		elif ( tc-is-gcc && $(ver_test ${gcc_v} -ge 8.1) ) \
			&& test -f "${DISTDIR}/${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 8.1"
			_PATCHES+=( "${DISTDIR}/${KCP_8_1_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
		elif ( tc-is-gcc && $(ver_test ${gcc_v} -ge 4.9) ) \
			&& test -f "${DISTDIR}/${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" ; \
		then
einfo "Queuing the kernel_compiler_patch for use under gcc >= 4.9"
			_PATCHES+=( "${DISTDIR}/${KCP_4_9_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
		else
ewarn "Cannot find a compatible kernel_compiler_patch for gcc_v = ${gcc_v}"
ewarn "and kernel ${K_MAJOR_MINOR}.  Skipping the kernel_compiler_patch."
		fi
	fi

	if has kernel-compiler-patch-cortex-a72 ${IUSE_EFFECTIVE} ; then
		if use kernel-compiler-patch-cortex-a72 ; then
einfo "Queuing the kernel_compiler_patch for the Cortex A72"
			_PATCHES+=( "${DISTDIR}/${KCP_CORTEX_A72_BN}-${KCP_COMMIT_SNAPSHOT:0:7}.patch" )
		fi
	fi

	ot-kernel_unpack_tarball
	# unpacking point releases found in apply_vanilla_point_releases
	cd "${WORKDIR}" || die
	mv "linux-${K_MAJOR_MINOR}" "${S}" || die

	cd "${S}" || die

	apply_vanilla_point_releases

	# This should be done immediately after all the kernel point releases.
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		if use cve_hotfix ; then
			fetch_tuxparoni
			unpack_tuxparoni
			fetch_cve_hotfixes
			get_cve_report
			test_cve_hotfixes
			apply_cve_hotfixes
ewarn
ewarn "Applying custom patchsets on top of cve_hotfix USE flag may fail to"
ewarn "patch or fail to compile."
ewarn
		fi
	fi

	if has rt ${IUSE_EFFECTIVE} ; then
		if use rt ; then
			apply_rt
		fi
	fi

	if has futex ${IUSE_EFFECTIVE} ; then
		if use futex ; then
			apply_futex
		fi
	fi

	if has futex2 ${IUSE_EFFECTIVE} ; then
		if use futex2 ; then
			apply_futex2
		fi
	fi

	if use uksm ; then
		apply_uksm
	fi

	if has lru_gen ${IUSE_EFFECTIVE} ; then
		if use lru_gen ; then
			apply_lru_gen
		fi
	fi

	if has zen-lru_gen ${IUSE_EFFECTIVE} ; then
		if use zen-lru_gen ; then
			apply_zen_lru_gen
		fi
	fi

	if has bmq ${IUSE_EFFECTIVE} ; then
		if use bmq ; then
			apply_bmq
		fi
	fi

	if has pds ${IUSE_EFFECTIVE} ; then
		if use pds ; then
			apply_pds
		fi
	fi

	if has prjc ${IUSE_EFFECTIVE} ; then
		if use prjc ; then
			apply_prjc
		fi
	fi

	if has muqss ${IUSE_EFFECTIVE} ; then
		if use muqss ; then
			apply_ck
		fi
	fi

	if has zen-muqss ${IUSE_EFFECTIVE} ; then
		if use zen-muqss ; then
			apply_zen_muqss
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			apply_tresor
		fi
	fi

	if has genpatches ${IUSE_EFFECTIVE} ; then
		if use genpatches ; then
			apply_genpatches_base
			apply_genpatches_extras
			apply_genpatches_experimental
		fi
	fi

	if has O3 ${IUSE_EFFECTIVE} ; then
		if use O3 ; then
			apply_o3
		fi
	fi

	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		if use zen-sauce ; then
			apply_zensauce
		fi
	fi

	if has bbrv2 ${IUSE_EFFECTIVE} ; then
		if use bbrv2 ; then
			apply_bbrv2
		fi
	fi

	if has clang-pgo ${IUSE_EFFECTIVE} ; then
		if use clang-pgo ; then
			apply_clang_pgo
		fi
	fi

	if has cfi ${IUSE_EFFECTIVE} ; then
		if use cfi && use amd64 ; then
			apply_cfi_x86
		fi
	fi

	if (( ${#_PATCHES[@]} > 0 )) ; then
		eapply ${_PATCHES[@]}
	fi
}

# @FUNCTION: ot-kernel_src_compile
# @DESCRIPTION:
# Compiles the userland programs especially the TRESOR AES post-boot
# program.
function ot-kernel_src_compile() {
	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			cp -a "${DISTDIR}/tresor_sysfs.c" "${T}"
			cd "${T}" || die
einfo "Running:  $(tc-getCC) ${CFLAGS} -Wno-unused-result tresor_sysfs.c -o \
tresor_sysfs"
			$(tc-getCC) ${CFLAGS} -Wno-unused-result \
				tresor_sysfs.c -o tresor_sysfs || die
		fi
	fi
}

# @FUNCTION: ot-kernel_src_install
# @DESCRIPTION:
# Removes patch cruft.
function ot-kernel_src_install() {
	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			docinto /usr/share/${PF}
			dodoc "${DISTDIR}/${TRESOR_README_FN}"
			dodoc "${DISTDIR}/${TRESOR_PDF_FN}"
		fi
	fi
	# usually we sanitize permissions but skip for now
	dodir /usr/src
	mv "${S}" "${ED}/usr/src" || die
}

# @FUNCTION: ot-kernel_pkg_postinst
# @DESCRIPTION:
# Present warnings and avoid collision checks.
#
# ot-kernel_pkg_postinst_cb - callback if any to handle after emerge phase
#
function ot-kernel_pkg_postinst() {
	if use disable_debug ; then
einfo
einfo "The disable debug scripts have been placed in your /usr/src folder."
einfo "They disable debug paths, logging, output for a performance gain."
einfo "You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`"
einfo
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" \
			"${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" \
			"${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			# prevent merge conflicts
			cd "${T}" || die
			mv tresor_sysfs "${EROOT}/usr/bin" || die
			chmod 700 "${EROOT}"/usr/bin/tresor_sysfs || die
			# same hash for 5.1 and 5.0.13 for tresor_sysfs
einfo
einfo "The /usr/bin/tresor_sysfs CLI command which uses /sys/kernel/tresor/key too"
einfo "is provided to set your TRESOR key directly.  Your key should be a"
einfo "case-insensitive hex string without spaces and without any prefixes at least"
einfo "{128,192,256}-bits corresponding to AES-128, AES-192, AES-256.  Because"
einfo "it is custom, you may supply your own key deriviation function (KDF) and/or"
einfo "hashing algorithm, the result from gpg, or hardware key."
einfo
einfo "If using /sys/kernel/tresor/password for plaintext passwords, they can only"
einfo "be 53 characters maxiumum without the null character.  They will be sent to"
einfo "a key derivation function that is 2000 iterations of SHA256."
einfo
einfo "It's recommend that new users use /sys/kernel/tresor/password or set the"
einfo "password at boot."
einfo
einfo "Advanced users may use /sys/kernel/tresor/key instead."
einfo
		else
			if has tresor ${IUSE_EFFECTIVE} ; then
				if use tresor ; then
ewarn
ewarn "You can only enter a password that is 53 characters long without the null"
ewarn "character though the boot time TRESOR prompt."
ewarn
				fi
			fi
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
einfo
einfo "To prevent the prompt on boot from scrolling off the screen, you can do"
einfo "one of the following:"
einfo
einfo "  Set CONSOLE_LOGLEVEL_QUIET <= 5 AND add \`quiet\` as a kernel"
einfo "  parameter to the bootloader config."
einfo
einfo "or"
einfo
einfo "  Set CONFIG_CONSOLE_LOGLEVEL_DEFAULT <= 5 (if you didn't set the"
einfo "  \`quiet\` kernel parameter.)"
einfo
einfo "Setting CONFIG_CONSOLE_LOGLEVEL_DEFAULT and CONSOLE_LOGLEVEL_QUIET to"
einfo "<= 2 will wipe out all the boot time verbosity leaking into the TRESOR"
einfo "prompt from drivers."
einfo
einfo
ewarn "TRESOR was not designed for parallel usage.  Only one TRESOR device at a"
ewarn "time can be used."
ewarn
ewarn "TRESOR AES-192 and AES-256 is only available for the tresor_aesni"
ewarn "USE flag."
ewarn
ewarn "For 4.14, TRESOR with ECB and CBC are only available."
ewarn "CBC is recommended for production in the 4.14 series."
ewarn
ewarn "For LTS and stable, TRESOR with ECB, CBC, CTR, XTS are only available."
ewarn "CBC is currently recommended for production.  CTR and XTS are still in"
ewarn "development and strongly not recommended.  The XTS and CTR"
ewarn "implementations will be reworked if possible in assembly code and"
ewarn "registers.  Currently, both CTS and CTR implementation allows copies of"
ewarn "these infos into RAM memory and not philosophically in alignment TRESOR"
ewarn "which keeps keys out of memory.  Further XTS support may require modding"
ewarn "at the kernel source code level."
ewarn
ewarn "ECB is NOT recommended and should only be used for testing."
ewarn
ewarn "The kernel may require modding the setkey portions to support different"
ewarn "crypto systems whenever crypto_cipher_setkey or crypto_skcipher_setkey"
ewarn "gets called.  The module tries to avoid copies the key to memory and"
ewarn "needs the key dump to registers at the time the user enters the key."
ewarn "See CONFIG_CRYPTO_TRESOR code blocks in crypto/testmgr.c for details."
ewarn
ewarn "Because it uses hardware breakpoint debug address registers, these"
ewarn "debugging features are mutually exclusive when TRESOR is being used."
ewarn
ewarn "TRESOR-XTS is limited to 64-bit arches and 256-bit keys, but 128-bit key"
ewarn "for the crypto key."
ewarn
ewarn "Using TRESOR with fscrypt is currently not supported.  The ebuild"
ewarn "developer is currently working towards that goal.  Changing the key in"
ewarn "the middle of writing may result in data loss, meaning half the data may"
ewarn "be encrypted with two different keys.  The fscrypt with TRESOR support"
ewarn "will address this problem."
ewarn
		fi
		if use tresor_aesni ; then
ewarn
ewarn "TRESOR for AES-NI has not been tested.  It's left for users to test and"
ewarn "fix."
ewarn
		fi
	fi

einfo
einfo "For Genkernel users.  It's recommended to add either"
einfo
einfo "  --compress-initramfs-type=zstd"
einfo
einfo "or"
einfo
einfo "  --compress-initramfs-type=lz4"
einfo
einfo "to genkernel invocation if the compression type is present in the"
einfo "kernel series."
einfo

	if declare -f ot-kernel_pkg_postinst_cb > /dev/null ; then
		ot-kernel_pkg_postinst_cb
	fi

	# For possible impractical passthough (pt) DMA attack, see
	# https://link.springer.com/article/10.1186/s13173-017-0066-7#Fn1
ewarn
ewarn "Please upgrade both the motherboard and CPU with support with either"
ewarn "VT-d or AMD-Vi to mitigate from cold-boot attack if using full disk"
ewarn "encryption.  Ensure that that IOMMU is being used.  Do not disable IOMMU"
ewarn "or use passthrough (pt).  See"
ewarn
ewarn "  https://en.wikipedia.org/wiki/List_of_IOMMU-supporting_hardware"
ewarn
ewarn "for IOMMU supported hardware.  For details about the DMA side-channel"
ewarn "attack, see"
ewarn
ewarn "  https://en.wikipedia.org/wiki/DMA_attack"
ewarn
ewarn "If you cannot afford the hardware, you may consider removing DMA based"
ewarn "ports, soldering connections, hardware based encrypted RAM, and"
ewarn "disabling DMA to mitigate against a DMA attack."
ewarn
ewarn "Any crypto algorithm or password store that stores keys in memory or"
ewarn "registers are vulnerable.  This includes TRESOR as well."
ewarn
ewarn "To properly use full disk encryption, do not use suspend to RAM and"
ewarn "shutdown the computer immediately on idle."
ewarn
ewarn "Futher mitigation recommendations can be found at"
ewarn
ewarn "  https://en.wikipedia.org/wiki/Cold_boot_attack#Mitigation"
ewarn
	if has rt $FEATURES ; then
		if use rt ; then
einfo
einfo "Don't forget to set CONFIG_PREEMPT_RT found at \"General setup\" in"
einfo "newer kernels or in \"Processor type and features\" in older kernels"
einfo "> Preemption Model >  Fully Preemptible Kernel (Real-Time)."
einfo
ewarn
ewarn "The rt patchset for this package may drop anytime if lack of update"
ewarn "activity after several months due to project funding problems."
ewarn "Dated: Jun 16, 2021"
ewarn
		fi
	fi

	# Remove genkernel problem with GK_FILENAME_CONFIG having spaces in EXTRAVERSION in file
	local path="${EROOT}/usr/src/linux-${PV}-ot/include/config/kernel.release"
	if [[ -f "${EROOT}/usr/src/linux-${PV}-ot/include/config/kernel.release" ]] ; then
einfo
einfo "Removed ${path} for genkernel"
		rm -rf "${path}" || die
	fi

	local has_cfi

	local has_llvm=0
	local llvm_v_maj=12 # set to highest kcp arch requirement
	local wants_cfi=0
	local wants_lto=0
	local gcc_v=$(best_version "sys-devel/gcc" \
		| sed -r -e "s|sys-devel/gcc-||g" \
		-e "s|-r[0-9]+||"| cut -f 1-3 -d ".")
	if has_version "sys-devel/clang" ; then
		has_llvm=1
		llvm_v_maj=$(best_version "sys-devel/clang" \
		| sed -r -e "s|sys-devel/clang-||g" \
		-e "s|-r[0-9]+||" | cut -f 1 -d ".")
	fi

	if has cfi ${IUSE_EFFECTIVE} ; then
		if use cfi ; then
			wants_cfi=1
		fi
	fi
	if has lto ${IUSE_EFFECTIVE} ; then
		if use lto ; then
			wants_lto=1
		fi
	fi

	local kcp_arches=(
		kernel-compiler-patch-zen3
		kernel-compiler-patch-cooper_lake
		kernel-compiler-patch-tiger_lake
		kernel-compiler-patch-sapphire_rapids
		kernel-compiler-patch-rocket_lake
		kernel-compiler-patch-alder_lake
	)

	has_newer_kcp_arch=0
	for a in ${kcp_arches[@]} ; do
		if has ${a} ${IUSE_EFFECTIVE} ; then
			if use ${a} ; then
				has_newer_kcp_arch=1
			fi
		fi
	done

	if (( ${wants_lto} == 1 || ${wants_cfi} == 1 )) ; then
einfo
einfo "It's recommend to use sys-devel/genpatches[llvm]::oiledmachine-overlay"
einfo "when building with LTO and/or CFI with the --llvm passed to genkernel."
einfo
einfo "To present the CFI/LTO options, you must:"
einfo
einfo "  \`make menuconfig \
AR=/usr/lib/llvm/${llvm_v_maj}/bin/llvm-ar \
AS=/usr/lib/llvm/${llvm_v_maj}/bin/llvm-as \
CC=/usr/lib/llvm/${llvm_v_maj}/bin/clang \
LD=/usr/bin/ld.lld \
NM=/usr/lib/llvm/${llvm_v_maj}/bin/llvm-nm \
CLANG_FLAGS=\"-integrated-as\"\`"
einfo
einfo "CFI or LTO requires that the menuconfig settings are changed to:"
einfo
einfo "  General architecture-dependent options > Link Time Optimization (LTO) > Clang ThinLTO (EXPERIMENTAL)"
einfo
einfo "For CFI, the menuconfig item is found at:"
einfo
einfo "  General architecture-dependent options > Use Clang's Control Flow Integrity (CFI)"
einfo
einfo "For ShadowCallStack, the menuconfig item is found at:"
einfo
einfo "  General architecture-dependent options > Clang Shadow Call Stack"
einfo
	elif (( ${has_newer_kcp_arch} == 1 )) ; then
einfo
einfo "The kernel_compiler patch requires that you either add"
einfo
einfo "  --kernel-cc=/usr/bin/${CHOST}-gcc-${gcc_v}"
		if [[ -n "${has_llvm}" ]] ; then
einfo
einfo "    or"
einfo
einfo "  use the sys-devel/genpatches[llvm]::oiledmachine-overlay package"
einfo "  with the --llvm argument passed to genkernel"
		fi
einfo
einfo "to optimize for newer microarchitectures."
einfo
	fi

	if has bbrv2 ${IUSE_EFFECTIVE} ; then
		if use bbrv2 ; then
einfo
einfo "To enable BBRv2 go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > BBR2 TCP"
einfo
einfo "To make BBRv2 the default go to"
einfo
einfo "  Networking support > Networking options >  TCP: advanced congestion control > Default TCP congestion control > BBR2"
einfo
		fi
	fi

	if has futex ; then
		if use futex ; then
einfo
einfo "Enable futex also in Configure standard kernel features (expert users) > Enable futex support"
einfo
einfo "Additional envvars may be required like WINEFSYNC=1.  Check the forked"
einfo "wine code for details."
einfo
		fi
	fi
	if has futex2 ; then
		if use futex2 ; then
einfo
einfo "Enable futex also in Configure standard kernel features (expert users) > Enable futex support"
einfo
einfo "  with"
einfo
einfo "Enable futex2 also in Configure standard kernel features (expert users) > Enable futex2 support"
einfo
einfo
einfo "Additional envvars may be required like WINEFSYNC_FUTEX2=1.  Check the"
einfo "forked wine code for details."
einfo
		fi
	fi

	if has tresor ; then
		if use tresor ; then
ewarn
ewarn "TRESOR is currently not compatible with Integrated Assembler used by."
ewarn "LLVM It is only compatible with GAS.  You may try to pass"
ewarn "-no-integrated-as to CLANG_FLAGS or CFLAGS or build only with the GCC"
ewarn "toolchain only.  Compatibility with Integrated Assembler may be"
ewarn "provided later."
ewarn
		fi
	fi
}
