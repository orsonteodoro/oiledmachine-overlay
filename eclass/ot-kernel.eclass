#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019-2020 Orson Teodoro
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

# BMQ CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:
#   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
#   https://dev.gentoo.org/~mpagano/genpatches/releases-4.14.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.4.html
#   https://dev.gentoo.org/~mpagano/genpatches/releases-5.10.html
#   The person below who updates the release links above lag. See instead:
#     https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-kernel/gentoo-sources
# kernel_gcc_patch:
#   https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:
#   https://github.com/torvalds/linux/compare/v4.14...ckolivas:4.14-ck
#   https://github.com/torvalds/linux/compare/v5.4...ckolivas:5.4-ck
# O3 (Allow O3):
#   5.4 https://github.com/torvalds/linux/commit/4edc8050a41d333e156d2ae1ed3ab91d0db92c7e
#   5.10 https://github.com/torvalds/linux/commit/d0ee207cac1217d2b111bef6f0f9581a10b35f6c
# O3 (Optimize Harder):
#   4.9 (O3) https://github.com/torvalds/linux/commit/7d0295dc49233d9ddff5d63d5bdc24f1e80da722
#   circa 2018 (infiniband O3 read overflow fix) \
#     https://github.com/torvalds/linux/commit/562a14babcd56efc2f51c772cb2327973d8f90ad
# PDS CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/PDS
# PREEMPT_RT
#  https://wiki.linuxfoundation.org/realtime/start
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/4.14/
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.4/
#  http://cdn.kernel.org/pub/linux/kernel/projects/rt/5.10/
# Project C CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/Project%20C
# TRESOR:
#   https://www1.informatik.uni-erlangen.de/tresor
# UKSM:
#   https://github.com/dolohow/uksm
# zen-kernel 5.4/futex-backports
#   https://github.com/torvalds/linux/compare/v5.4...zen-kernel:5.4/futex-backports
# zen-kernel 5.{8..10}/futex-multiple-wait-v3
#   https://github.com/torvalds/linux/compare/v5.10...zen-kernel:5.10/futex-multiple-wait-v3
# zen-tune:
#   https://github.com/torvalds/linux/compare/v5.4...zen-kernel:5.4/zen-sauce
#     in particular 3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0
#   https://github.com/torvalds/linux/compare/v5.10...zen-kernel:5.10/zen-sauce
#     in particular in between \
#     [890ac858741436a40c274efb3514c5f6a96c7c80^..b7b24b494b62e02c21a9a349da2d036849f9dd8b] \
#     [exclusive-old^,inclusive-new] [top,bottom]

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
LICENSE="GPL-2 Linux-syscall-note" #  Applies to whole source  \
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
          https://github.com/graysky2/kernel_gcc_patch
          https://liquorix.net/
	  https://wiki.linuxfoundation.org/realtime/start
	  https://www1.informatik.uni-erlangen.de/tresor
"

OT_KERNEL_SLOT_STYLE=${OT_KERNEL_SLOT_STYLE:="MAJOR_MINOR"}
KEYWORDS=${KEYWORDS:=\
"~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"}
SLOT=${SLOT:=${PV}}
K_TAG="-ot"
S="${WORKDIR}/linux-${PV}${K_TAG}"

inherit check-reqs ot-kernel-cve toolchain-funcs

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
RDEPEND+=" dev-vcs/git
	   sys-kernel/kpatch
	   sys-kernel/kpatch-daemon"
fi

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
		s=" ${s} ${ZENSAUCE_BASE_URI}${id}.patch -> zen-sauce-${K_MAJOR_MINOR}-${id}.patch"
	done
	echo "$s"
}

BMQ_FN="${BMQ_FN:=v${K_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch}"
BMQ_BASE_URI="https://gitlab.com/alfredchen/bmq/raw/master/${K_MAJOR_MINOR}/"
BMQ_SRC_URI="${BMQ_BASE_URI}${BMQ_FN}"

CK_COMMITS="${PATCH_CK_COMMIT_T}^..${PATCH_CK_COMMIT_B}" # [oldest,newest] [top,bottom]
CK_COMMITS_SHORT="${PATCH_CK_COMMIT_T:0:7}-${PATCH_CK_COMMIT_B:0:7}" # [oldest,newest] [top,bottom]
CK_FN=\
"ck-${MUQSS_VER}-for-${K_MAJOR_MINOR}-${CK_COMMITS_SHORT}.patch"
CK_SRC_URI=\
"https://github.com/torvalds/linux/compare/${CK_COMMITS}.patch"
CK_SRC_URI="${CK_SRC_URI} -> ${CK_FN}"

FUTEX_WAIT_MULTIPLE_COMMITS="${PATCH_FUTEX_COMMIT_T}^..${PATCH_FUTEX_COMMIT_B}" # [oldest,newest] [top,bottom]
FUTEX_WAIT_MULTIPLE_COMMITS_SHORT=\
"${PATCH_FUTEX_COMMIT_T:0:7}-${PATCH_FUTEX_COMMIT_B:0:7}" # [oldest,newest] [top,bottom]
FUTEX_WAIT_MULTIPLE_BASE_URI=\
"https://github.com/torvalds/linux/compare/${FUTEX_WAIT_MULTIPLE_COMMITS}"
FUTEX_WAIT_MULTIPLE_FN=\
"futex-multiple-wait-${K_MAJOR_MINOR}-${FUTEX_WAIT_MULTIPLE_COMMITS_SHORT}.patch"
FUTEX_WAIT_MULTIPLE_SRC_URI=\
"${FUTEX_WAIT_MULTIPLE_BASE_URI}.patch -> ${FUTEX_WAIT_MULTIPLE_FN}"

GENPATCHES_URI_BASE_URI="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
GENPATCHES_BASE_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${GENPATCHES_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URI="${GENPATCHES_URI_BASE_URI}${GENPATCHES_EXTRAS_FN}"

KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
KERNEL_SERIES_TARBALL_FN="linux-${K_MAJOR_MINOR}.tar.xz"
KERNEL_INC_BASE_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/incr/"
KERNEL_PATCH_0_TO_1_URI=\
"https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/patch-${K_MAJOR_MINOR}.1.xz"

if ver_test ${K_MAJOR_MINOR} -ge 5.10 ; then
KGCCP_11_0_FN=\
"enable_additional_cpu_optimizations_for_gcc_v11.0%2B_kernel_v5.10%2B.patch"
KGCCP_10_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.8%2B.patch"
KGCCP_9_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v5.8%2B.patch"
KGCCP_8_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
KGCCP_4_9_FN=\
"${KGCCP_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
elif ver_test ${K_MAJOR_MINOR} -ge 5.9 ; then
KGCCP_10_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.8%2B.patch"
KGCCP_9_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v5.8%2B.patch"
KGCCP_8_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
KGCCP_4_9_FN=\
"${KGCCP_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
elif ver_test ${K_MAJOR_MINOR} -ge 5.4 ; then
KGCCP_10_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v4.19-v5.4.patch"
KGCCP_9_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v4.13%2B.patch"
KGCCP_8_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
KGCCP_4_9_FN=\
"${KGCCP_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
elif ver_test ${K_MAJOR_MINOR} -ge 4.13 ; then
KGCCP_9_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v4.13%2B.patch"
KGCCP_8_1_FN=\
"enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
KGCCP_4_9_FN=\
"${KGCCP_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
fi
KGCCP_URI_BASE=\
"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/"
if [[ -n "${KGCCP_4_9_FN}" ]] ; then
KGCCP_SRC_4_9_URI="${KGCCP_URI_BASE}/outdated_versions/${KGCCP_4_9_FN}"
fi
if [[ -n "${KGCCP_8_1_FN}" ]] ; then
KGCCP_SRC_8_1_URI="${KGCCP_URI_BASE}/outdated_versions/${KGCCP_8_1_FN}"
fi
if [[ -n "${KGCCP_9_1_FN}" ]] ; then
KGCCP_SRC_9_1_URI="${KGCCP_URI_BASE}${KGCCP_9_1_FN}"
fi
if [[ -n "${KGCCP_10_1_FN}" ]] ; then
KGCCP_SRC_10_1_URI="${KGCCP_URI_BASE}${KGCCP_10_1_FN}"
fi
if [[ -n "${KGCCP_11_0_FN}" ]] ; then
KGCCP_SRC_11_0_URI="${KGCCP_URI_BASE}${KGCCP_11_0_FN}"
fi

LINUX_REPO_URI=\
"https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

O3_SRC_URI="https://github.com/torvalds/linux/commit/"
O3_ALLOW_FN="O3-allow-unrestricted-${PATCH_ALLOW_O3_COMMIT}.patch"
O3_ALLOW_SRC_URI="${O3_SRC_URI}${PATCH_ALLOW_O3_COMMIT}.patch -> ${O3_ALLOW_FN}"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT}.patch"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT}.patch"
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
"https://raw.githubusercontent.com/dolohow/uksm/master/v${K_MAJOR_MINOR}.x/"
UKSM_FN="uksm-${K_MAJOR_MINOR}.patch"
UKSM_SRC_URI="${UKSM_BASE_URI}${UKSM_FN}"

ZENSAUCE_URIS=$(gen_zensauce_uris "${PATCH_ZENSAUCE_COMMITS}")

ZENTUNE_FN="zen-tune-${K_MAJOR_MINOR}.patch"
ZENTUNE_COMMITS="${PATCH_ZENTUNE_COMMIT_T}^..${PATCH_ZENTUNE_COMMIT_B}" # [oldest,newest] [top,bottom]
ZENTUNE_MUQSS_VIRTUAL_PATCH="zen-tune-muqss"
ZENTUNE_BASE_URI="https://github.com/torvalds/linux/commit/"
ZENTUNE_SRC_URI="${ZENTUNE_BASE_URI}${ZENTUNE_COMMITS}.patch -> ${ZENTUNE_FN}"

if ver_test ${PV} -eq ${K_MAJOR_MINOR} ; then
KERNEL_NO_POINT_RELEASE="1"
elif ver_test ${PV} -eq ${K_MAJOR_MINOR}.0 ; then
KERNEL_0_TO_1_ONLY="1"
fi

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
elif [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
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
	local failed_hunks_acceptable="${3}"
	local reversed_acceptable="${4}"
	local msg_extra="${5}"
	einfo \
"Applying ${path}${msg_extra}\n\
with ${failed_hunks_acceptable} hunk(s) failed and\n\
with ${reversed_acceptable} already patched warnings\n\
which will be resolved or patched immediately.  These estimates may be far\n\
less than the actual."

	local n_failures=0
	for x_i in $(patch ${opts} --dry-run -i "${path}" \
		| grep -E -e "hunks? FAILED" | cut -f 1 -d " ") ; do
		n_failures=$((${n_failures}+${x_i}))
	done
	if (( ${n_failures} != ${failed_hunks_acceptable} )) ; then
		die \
"${path} needs a rebase. n_failures=${n_failures}\n\
failed_hunks_acceptable=${failed_hunks_acceptable}"
	fi

	local n_reversed=$(patch ${opts} --dry-run -i "${path}" \
			| grep -F -e "Reversed (or previously applied) patch detected!" \
			| wc -l)
	if (( ${n_reversed} != ${reversed_acceptable} )) ; then
		die \
"${path} needs a rebase. n_reversed=${n_reversed}\n\
reversed_acceptable=${reversed_acceptable}"
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
	if [[ "${K_MAJOR_MINOR}" == "5.4" ]] ; then
		einfo \
"\n\
The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is\n\
Dec 2025.\n\
\n\
Use the virtual/ot-sources-lts meta package to ensure proper updates in the\n\
same major.minor branch.\n\
"
	elif [[ "${K_MAJOR_MINOR}" == "4.19" ]] ; then
		einfo \
"\n\
The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is\n\
Dec 2024.\n\
\n\
Use the virtual/ot-sources-lts meta package to ensure proper updates in the\n\
same major.minor branch.\n\
"
	elif [[ "${K_MAJOR_MINOR}" == "4.14" ]] ; then
		einfo \
"\n\
The expected End Of Life (EOL) for the ${K_MAJOR_MINOR} kernel series is\n\
Jan 2024.\n\
\n\
Use the virtual/ot-sources-lts meta package to ensure proper updates in the\n\
same major.minor branch.\n\
"
	else
		ewarn \
"\n\
The ${K_MAJOR_MINOR} kernel series is not a Long Term Support (LTS)\n\
kernel.  It may suddenly stop receiving security updates completely between a\n\
week to several months.\n\
\n\
Use the virtual/ot-sources-stable meta package to ensure a smooth update\n\
between stable releases differing between major.minor branches\n\
"
	fi
}

# @FUNCTION: zensauce_setup
# @DESCRIPTION:
# Checks the existance for the ZENSAUCE_WHITELIST_5_3 variable
function zensauce_setup() {
	if use zen-sauce ; then
		if [[ -n "ZENMISC_WHITELIST_${K_MAJOR_MINOR/./_}" ]] ; then
			die \
"ZENMISC_WHITELIST_${K_MAJOR_MINOR/./_} has been been renamed to\n\
ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}.  Rename or remove this envvar\n\
to continue"
		fi
		einfo "Applying the Zen secret sauce"
		local ZM="ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}"
		if [[ -z "${!ZM}" ]] ; then
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

			eerror \
"You must define ZENSAUCE_WHITELIST_${K_MAJOR_MINOR} in /etc/make.conf\n\
or as a per-package env containing commits to accepted from\n\
${zensauce_uri}\n\
\n\
For example:\n\
\n\
  ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}=\"214d031dbeef940efe1dbba274caf5ccc4ff2774 \
83d7f482c60b6dfda030325394ec07baac7f5a30\"\n\
  ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}=\"214d031 83d7f48\"\n\
\n\
This must be in chronological and topological order (if the timestamp is the\n\
same) from oldest-left to newest-right.  Only 40 or 7 digit IDs are accepted."
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
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to use\n\
live patches."
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

	if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
		einfo "Live patchable branches is experimental and is a Work In Progress (WIP)"
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
			die \
"You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
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
# Applies whitelisted Zen misc patches.
function apply_zensauce() {
	local ZM="ZENSAUCE_WHITELIST_${K_MAJOR_MINOR/./_}"
	read -a C_WHITELISTED <<< ${!ZM}
	for c_wl in ${C_WHITELISTED[@]} ; do
		read -a C_BLACKLISTED <<< ${PATCH_ZENSAUCE_BL}
		local blacklisted=0
		if [[ -n "${#C_BLACKLISTED}" ]] ; then
			for c_bl in ${c_BLACKLISTED[@]} ; do
				if [[ ( "${#c_wl}" == "7" \
					&& "${c_wl}" == "${c_bl:0:7}" ) \
					|| ( "${#c_wl}" == "40" \
					&& "${c_wl}" == "${c_bl}" ) ]] ; \
				then
					ewarn \
"${c} is already applied via USE flag.  Activate via USE flag instead."
					blacklisted=1
					continue
				fi
			done
		fi
		if (( ${blacklisted} == 0 )) ; then
			if [[ "${#c_wl}" == "7" ]] ; then
				local p=$(basename $(head -n 1 \
	<<< $(ls "${DISTDIR}/zen-sauce-${K_MAJOR_MINOR}-${c_wl}"*".patch")))
				_fpatch "${DISTDIR}/${p}"
			else
				_fpatch \
			"${DISTDIR}/zen-sauce-${K_MAJOR_MINOR}-${c_wl}.patch"
			fi
		fi
	done
}

# @FUNCTION: apply_futex_wait_multiple
# @DESCRIPTION:
# Adds a new syscall operation FUTEX_WAIT_MULTIPLE to the futex
# syscall.  It may shave of <5% CPU usage.
function apply_futex_wait_multiple() {
	_fpatch "${DISTDIR}/${FUTEX_WAIT_MULTIPLE_FN}"
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
	# Already applied 5010-5013 GraySky2's kernel_gcc_patche
	P_GENPATCHES_BLACKLIST=" 5010 5011 5012 5013"
	# Already applied 5000-5007 ZSTD patches
	P_GENPATCHES_BLACKLIST+=" 5000 5001 5002 5003 5004 5005 5006 5007"
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
				local is_blacklist
				is_blacklist=0
				for x in ${P_GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklist=1
					fi
				done
				if [[ "${is_blacklist}" == "1" ]] ; then
					continue
				fi

				is_blacklist=0
				for x in ${GENPATCHES_BLACKLIST} ; do
					if [[ "${l}" == "${x}" ]] ; then
						is_blacklist=1
					fi
				done
				if [[ "${is_blacklist}" == "1" ]] ; then
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
	_fpatch "${DISTDIR}/${CK_FN}"
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

	if ver_test "${K_MAJOR_MINOR}" -ge 5.4 ; then
		einfo "Allow O3 unrestricted"
		_fpatch "${DISTDIR}/${O3_ALLOW_FN}"
	elif ver_test "${K_MAJOR_MINOR}" -lt 5.4 ; then
		# fix patch
		sed -e 's|-1028,6 +1028,13|-1076,6 +1076,13|' \
			"${DISTDIR}"/${O3_CO_FN} \
			> "${T}"/${O3_CO_FN} || die

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

# @FUNCTION: apply_zentune
# @DESCRIPTION:
# Apply the ZenTune patches.
function apply_zentune() {
	_fpatch "${T}/${ZENTUNE_FN}"
}

# @FUNCTION: apply_zentune_muqss
# @DESCRIPTION:
# Apply the Zen timing MuQSS patches.
function apply_zentune_muqss() {
	_fpatch "${ZENTUNE_MUQSS_VIRTUAL_PATCH}"
}


# @FUNCTION: ot-kernel_src_unpack
# @DESCRIPTION:
# Applies patch sets in order.
function ot-kernel_src_unpack() {
	_PATCHES=()
	if use kernel-gcc-patch ; then
		CC=$(tc-getCC)
		if ! tc-is-gcc ; then
			CC=$(get_abi_CHOST ${ABI})-gcc
		fi
		if $(ver_test $(gcc-version) -ge 11.0) \
			&& test -f "${DISTDIR}/${KGCCP_11_0_FN}" ; \
		then
			einfo "GCC patch is 11.0"
			_PATCHES+=( "${DISTDIR}/${KGCCP_11_0_FN}" )
		elif $(ver_test $(gcc-version) -ge 10.1) \
			&& test -f "${DISTDIR}/${KGCCP_10_1_FN}" ; \
		then
			einfo "GCC patch is 10.1"
			_PATCHES+=( "${DISTDIR}/${KGCCP_10_1_FN}" )
		elif $(ver_test $(gcc-version) -ge 9.1) \
			&& test -f "${DISTDIR}/${KGCCP_9_1_FN}" ; \
		then
			einfo "GCC patch is 9.1"
			_PATCHES+=( "${DISTDIR}/${KGCCP_9_1_FN}")
		elif $(ver_test $(gcc-version) -ge 8.1) \
			&& test -f "${DISTDIR}/${KGCCP_8_1_FN}" ; \
		then
			einfo "GCC patch is 8.1"
			_PATCHES+=( "${DISTDIR}/${KGCCP_8_1_FN}" )
		elif test -f "${DISTDIR}/${KGCCP_4_9_FN}" ; then
			einfo "GCC patch is 4.9"
			_PATCHES+=( "${DISTDIR}/${KGCCP_4_9_FN}" )
		else
			die \
"Cannot find a compatible kernel_gcc_patch for "$(gcc-version)" and\n\
kernel ${K_MAJOR_MINOR}.  Skipping kernel_gcc_patch."
		fi
	fi

	if [[ -z "${K_LIVE_PATCHABLE}" ]] ; then
		ot-kernel_unpack_tarball
		# unpacking point releases found in apply_vanilla_point_releases
		cd "${WORKDIR}" || die
		mv "linux-${K_MAJOR_MINOR}" "${S}" || die
	else
		ot-kernel_fetch_linux_sources
		cp -r "${d}" "${WORKDIR}" || die
		cd "${WORKDIR}" || die
		mv linux "${S}" || die
		echo $(get_current_tag_for_k_major_minor_branch) \
			> "${S}/tag" || die
		echo $(get_current_commit_for_k_major_minor_branch) \
			> "${S}/commit" || die
		rm -rf "${S}/.git" || die
	fi

	cd "${S}" || die

	if [[ -z "${K_LIVE_PATCHABLE}" ]] ; then
		apply_vanilla_point_releases
	fi

	# This should be done immediately after all the kernel point releases.
	if has cve_hotfix ${IUSE_EFFECTIVE} ; then
		if use cve_hotfix ; then
			fetch_tuxparoni
			unpack_tuxparoni
			fetch_cve_hotfixes
			get_cve_report
			test_cve_hotfixes
			apply_cve_hotfixes
			ewarn \
"Applying custom patchsets on top of cve_hotfix USE flag may fail to patch or\n\
fail to compile."
		fi
	fi

	if has rt ${IUSE_EFFECTIVE} ; then
		if use rt ; then
			apply_rt
		fi
	fi

	if has futex-wait-multiple ${IUSE_EFFECTIVE} ; then
		if use futex-wait-multiple ; then
			apply_futex_wait_multiple
		fi
	fi

	if use uksm ; then
		apply_uksm
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

	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
			apply_zentune
		fi
	fi

	if has zen-tune-muqss ${IUSE_EFFECTIVE} ; then
		if use zen-tune-muqss ; then
			apply_zentune_muqss
		fi
	fi

	if has zen-sauce ${IUSE_EFFECTIVE} ; then
		if use zen-sauce ; then
			apply_zensauce
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
			einfo \
"Running:  $(tc-getCC) ${CFLAGS} -Wno-unused-result tresor_sysfs.c -o tresor_sysfs"
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
		einfo \
"The disable debug scripts have been placed in your /usr/src folder.\n"\
"They disable debug paths, logging, output for a performance gain.\n"\
"You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`\n"
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
			einfo \
"\n\
/usr/bin/tresor_sysfs CLI command which uses /sys/kernel/tresor/key too\n\
are provided to set your TRESOR key directly.  Your key should be a\n\
case-insensitive hex string without spaces and without any prefixes at least\n\
{128,192,256}-bits corresponding to AES-128, AES-192, AES-256.  Because\n\
it is custom, you may supply your own key deriviation function (KDF) and/or\n\
hashing algorithm, the result from gpg, or hardware key.\n\
\n\
If using /sys/kernel/tresor/password for plaintext passwords, they can only\n\
be 53 characters maxiumum without the null character.  They will be sent to\n\
a key derivation function that is 2000 iterations of SHA256.\n\
\n\
It's recommend that new users use /sys/kernel/tresor/password or set the\n\
password at boot.\n\
\n\
Advanced users may use /sys/kernel/tresor/key instead.\n\
\n"
		else
			if has tresor ${IUSE_EFFECTIVE} ; then
				if use tresor ; then
					einfo \
"\n\
You can only enter a password that is 53 characters long without the null\n\
character though the boot time TRESOR prompt.\n\
\n"
				fi
			fi
		fi
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			einfo \
"\n\
To prevent the prompt on boot from scrolling off the screen, you can do one\n\
of the following:\n\
\n
  Set CONSOLE_LOGLEVEL_QUIET <= 5 AND add \`quiet\` as a kernel\n\
  parameter to the bootloader config.\n\
\n\
or\n\
\n\
  Set CONFIG_CONSOLE_LOGLEVEL_DEFAULT <= 5 (if you didn't set the\n\
  \`quiet\` kernel parameter.)\n\
\n\
Setting CONFIG_CONSOLE_LOGLEVEL_DEFAULT and CONSOLE_LOGLEVEL_QUIET to <= 2\n\
will wipe out all the boot time verbosity leaking into the TRESOR prompt\n\
from drivers.\n\
\n\
TRESOR was not designed for parallel usage.  Only one TRESOR device at a\n\
time can be used.\n\
\n\
TRESOR AES-192 and AES-256 is only available for the tresor_aesni USE flag.\n\
\n\
For 4.14, TRESOR with ECB and CBC are only available.\n\
CBC is recommended for production in the 4.14 series.\n\
\n\
For LTS and stable, TRESOR with ECB, CBC, CTR, XTS are only available.\n\
CBC is currently recommended for production.  CTR and XTS are still in\n\
development and strongly not recommended.  The XTS and CTR implementations\n\
will be reworked if possible in assembly code and registers.  Currently,\n\
both CTS and CTR implementation allows copies of these infos into RAM memory\n\
and not philosophically in alignment TRESOR which keeps keys out of memory.\n\
Further XTS support may require modding at the kernel source code level.\n\
\n\
ECB is NOT recommended and should only be used for testing.\n\
\n\
The kernel may require modding the setkey portions to support different\n\
crypto systems whenever crypto_cipher_setkey or crypto_skcipher_setkey\n\
gets called.  The module tries to avoid copies the key to memory and\n\
needs the key dump to registers at the time the user enters the key.\n\
See CONFIG_CRYPTO_TRESOR code blocks in crypto/testmgr.c for details.\n\
\n\
Because it uses hardware breakpoint debug address registers, these debugging\n\
features are mutually exclusive when TRESOR is being used.\n\
\n
TRESOR-XTS is limited to 64-bit arches and 256-bit keys, but 128-bit key for\n\
the crypto key."
		fi
		if use tresor_aesni ; then
			einfo \
"\n\
TRESOR for AES-NI has not been tested.  It's left for users to test and fix."
		fi
	fi

	einfo \
"\n\
For Genkernel users.  It's recommended to add either\n\
  --compress-initramfs-type=zstd\n\
or\n\
  --compress-initramfs-type=lz4\n\
to genkernel invocation if the compression type is present in the kernel\n\
series.\n\
\n"

	if declare -f ot-kernel_pkg_postinst_cb > /dev/null ; then
		ot-kernel_pkg_postinst_cb
	fi

	if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
		local sublevel=$(grep -F -e "SUBLEVEL =" \
			"${EROOT}"/usr/src/linux-${K_MAJOR_MINOR}.9999-ot/Makefile \
			| head -n 1 | cut -f 3 -d " ")
		local machine=$(uname -m)
		ewarn \
"If you use dkms, you must manually set the symlink to the kernel modules\n\
from /lib/modules/${K_MAJOR_MINOR}.${sublevel}-ot-${machine} to\n\
/lib/modules/${K_MAJOR_MINOR}.9999-ot-${machine}"
	fi

	# For possible impractical passthough (pt) DMA attack, see
	# https://link.springer.com/article/10.1186/s13173-017-0066-7#Fn1
	einfo \
"Please upgrade both the motherboard and CPU with support with either VT-d\n\
or AMD-Vi to mitigate from cold-boot attack if using full disk encryption.\n\
Ensure that that IOMMU is being used.  Do not disable IOMMU or use\n\
passthrough (pt).  See\n\
\n\
  https://en.wikipedia.org/wiki/List_of_IOMMU-supporting_hardware\n\
\n\
for IOMMU supported hardware.  For details about the DMA side-channel attack, see\n\
\n\
  https://en.wikipedia.org/wiki/DMA_attack\n\
\n\
If you cannot afford the hardware, you may consider removing DMA based\n\
ports, soldering connections, hardware based encrypted RAM, and\n\
disabling DMA to mitigate against a DMA attack.\n\
\n\
Any crypto algorithm or password store that stores keys in memory or\n\
registers are vulnerable.  This includes TRESOR as well.\n\
\n\
To properly use full disk encryption, do not use suspend to RAM and\n\
shutdown the computer immediately on idle.\n\
\n\
Futher mitigation recommendations can be found at\n\
\n\
  https://en.wikipedia.org/wiki/Cold_boot_attack#Mitigation"
	if has rt $FEATURES ; then
		if use rt ; then
			einfo \
"Don't forget to set CONFIG_PREEMPT_RT found at \"General setup\" in newer\n\
kernels or in \"Processor type and features\" in older kernels\n\
> Preemption Model >  Fully Preemptible Kernel (Real-Time)."
		fi
	fi

	# Remove genkernel problem with GK_FILENAME_CONFIG having spaces in EXTRAVERSION in file
	local path="${EROOT}/usr/src/linux-${PV}-ot/include/config/kernel.release"
	if [[ -f "${EROOT}/usr/src/linux-${PV}-ot/include/config/kernel.release" ]] ; then
		einfo
		einfo "Removed ${path} for genkernel"
		rm -rf "${path}" || die
	fi
}
