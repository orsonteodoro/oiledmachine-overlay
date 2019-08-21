# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-common.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-common eclass defines common patching steps for any linux kernel version.

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.1...zen-kernel:5.1/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.1/5.1-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:		https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.2...zen-kernel:5.2/bfq-backports
# amd-staging-drm-next:         https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next
# ROCK-Kernel-Driver:		https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/
# TRESOR:			http://www1.informatik.uni-erlangen.de/tresor

# TRESOR is maybe broken.  It requires additional coding for skcipher.
# Use the 4.9 series if you want to use TRESOR.
# See aesni-intel_glue.c chacha20_glue.c tresor_glue.c aesni-intel_asm.S aesni-intel_asm.S in arch/x86/crypto
# It needs to fill out the skcipher_alg structure and provide callbacks that use the skcipher_request structure.
# CBC uses CRYPTO_ALG_TYPE_SKCIPHER
# ECB uses CRYPTO_ALG_TYPE_BLKCIPHER

# Parts that still need to be developed:
# TRESOR - incomplete API
# ROCK-Kernel-Driver - forward porting incomplete

HOMEPAGE+="
          https://github.com/dolohow/uksm
          https://liquorix.net/
          https://github.com/graysky2/kernel_gcc_dpatch
	  http://ck-hack.blogspot.com/
          https://dev.gentoo.org/~mpagano/genpatches/
          http://algo.ing.unimo.it/people/paolo/disk_sched/
	  http://cchalpha.blogspot.com/search/label/PDS
	  https://cchalpha.blogspot.com/search/label/BMQ
	  http://www1.informatik.uni-erlangen.de/tresor
	  https://rocm.github.io/
          "

gen_kernel_seq()
{
	# 1-2 2-3 3-4
	local s=""
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" $s $((${to}-1))-${to}"
	done
	echo $s
}

BMQ_FN="v${PATCH_BMQ_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch"
BMQ_BASE_URL="https://gitlab.com/alfredchen/bmq/raw/master/${PATCH_BMQ_MAJOR_MINOR}/"
BMQ_SRC_URL="${BMQ_BASE_URL}${BMQ_FN}"

ZENTUNE_URL_BASE="https://github.com/torvalds/linux/compare/v${PATCH_ZENTUNE_VER}...zen-kernel:${PATCH_ZENTUNE_VER}/"
ZENTUNE_REPO="zen-tune"
ZENTUNE_FN="${ZENTUNE_REPO}-${PATCH_ZENTUNE_VER}.diff"
ZENTUNE_DL_URL="${ZENTUNE_URL_BASE}${ZENTUNE_REPO}.diff"
ZENTUNE_SRC_URL="${ZENTUNE_DL_URL} -> ${ZENTUNE_FN}"

UKSM_BASE="https://raw.githubusercontent.com/dolohow/uksm/master/v${PATCH_UKSM_MVER}.x/"
UKSM_FN="uksm-${PATCH_UKSM_VER}.patch"
UKSM_SRC_URL="${UKSM_BASE}${UKSM_FN}"

O3_SRC_URL="https://github.com/torvalds/linux/commit/"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT}.diff"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT}.diff"
O3_CO_DL_FN="${PATCH_O3_CO_COMMIT}.diff"
O3_RO_DL_FN="${PATCH_O3_RO_COMMIT}.diff"
O3_CO_SRC_URL="${O3_SRC_URL}${O3_CO_DL_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URL="${O3_SRC_URL}${O3_RO_DL_FN} -> ${O3_RO_FN}"

GRAYSKY_DL_4_9_FN="${GRAYSKY_DL_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
GRAYSKY_DL_8_1_FN="enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_DL_9_1_FN="enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_URL_BASE="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/"
GRAYSKY_SRC_4_9_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_4_9_FN}"
GRAYSKY_SRC_8_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_8_1_FN}"
GRAYSKY_SRC_9_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_9_1_FN}"

GENPATCHES_URL_BASE="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_BASE_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXTRAS_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_VER}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_VER}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_AESNI_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_AESNI_FN}"
TRESOR_I686_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_I686_FN}"
TRESOR_SYSFS_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_SYSFS_FN}"
TRESOR_README_DL_URL="https://www1.informatik.uni-erlangen.de/tresor?q=content/readme"
TRESOR_SRC_URL="${TRESOR_README_DL_URL} -> ${TRESOR_README_FN}"

KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(get_version_component_range 3 ${PV})))
KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/patch-${K_MAJOR_MINOR}.1.xz"

KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})

PDS_URL_BASE="https://gitlab.com/alfredchen/PDS-mq/raw/master/${PATCH_PDS_MAJOR_MINOR}/"
PDS_FN="v${PATCH_PDS_MAJOR_MINOR}_pds${PATCH_PDS_VER}.patch"
PDS_SRC_URL="${PDS_URL_BASE}${PDS_FN}"

BFQ_FN="bfq-${PATCH_BFQ_VER}.diff"
BFQ_REPO="bfq-backports"
BFQ_DL_URL="https://github.com/torvalds/linux/compare/v${PATCH_BFQ_VER}...zen-kernel:${PATCH_BFQ_VER}/${BFQ_REPO}.diff"
BFQ_SRC_URL="${BFQ_DL_URL} -> ${BFQ_FN}"

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 100"

# @FUNCTION: _dpatch
# @DESCRIPTION:
# Patch with die check.
# @CODE
# Parameters:
# $1 - patch options
# $2 - path of the patch
# @CODE
function _dpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}"
	patch ${patchops} -i ${path} || die
}

# @FUNCTION: _tpatch
# @DESCRIPTION:
# Patch without die check, which may be followed by intervention corrective action, implied true as in normal operation.
# @CODE
# Parameters:
# $1 - patch options
# $2 - path of the patch
# @CODE
function _tpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}..."
	patch ${patchops} -i ${path} || true
}

# @FUNCTION: apply_uksm
# @DESCRIPTION:
# Apply the UKSM patches.
#
# ot-kernel-common_uksm_fixes - callback to fix the patch
#
function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"

	if declare -f ot-kernel-common_uksm_fixes > /dev/null ; then
		ot-kernel-common_uksm_fixes
	fi
}

# @FUNCTION: apply_bfq
# @DESCRIPTION:
# Apply the BFQ patches.
function apply_bfq() {
	_dpatch "${PATCH_OPS} -N" "${T}/${BFQ_FN}"
}

# @FUNCTION: apply_zentune
# @DESCRIPTION:
# Apply the ZenTune patches.
function apply_zentune() {
	_dpatch "${PATCH_OPS} -N" "${T}/${ZENTUNE_FN}"
}

# @FUNCTION: apply_genpatch_base
# @DESCRIPTION:
# Apply the base genpatches patchset.
#
# ot-kernel-common_apply_genpatch_base_patchset - callback to apply individual patches
#
function apply_genpatch_base() {
	einfo "Applying genpatch base"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" "${S}"/Makefile || die

	# genpatches places kernel incremental patches starting at 1000
	for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
		local f="${T}/${a}"
		cd "${T}"
		unpack "$a.xz"
		cd "${S}"
		patch --dry-run ${PATCH_OPS} -N "${f}" | grep "FAILED at"
		if [[ "$?" == "1" ]] ; then
			# already patched or good
			_tpatch "${PATCH_OPS} -N" "${f}"
		else
			eerror "Failed ${l}"
			die
		fi
	done

	sed -r -i -e "s|EXTRAVERSION =|EXTRAVERSION = ${EXTRAVERSION}|" "${S}"/Makefile || die

	cd "${S}"

	if declare -f ot-kernel-common_apply_genpatch_base_patchset > /dev/null ; then
		ot-kernel-common_apply_genpatch_base_patchset
	fi
}

# @FUNCTION: apply_genpatch_experimental
# @DESCRIPTION:
# Apply the experimental genpatches patchset.
#
# ot-kernel-common_apply_genpatch_experimental_patchset - callback to apply individual patches
#
function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	# don't need since we apply upstream
	if declare -f ot-kernel-common_apply_genpatch_experimental_patchset > /dev/null ; then
		ot-kernel-common_apply_genpatch_experimental_patchset
	fi
}

# @FUNCTION: apply_genpatch_extras
# @DESCRIPTION:
# Apply the extra genpatches patchset.
#
# ot-kernel-common_apply_genpatch_extras_patchset - callback to apply individual patches
#
function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXTRAS_FN}"

	cd "${S}"

	if declare -f ot-kernel-common_apply_genpatch_extras_patchset > /dev/null ; then
		ot-kernel-common_apply_genpatch_extras_patchset
	fi
}

# @FUNCTION: apply_o3
# @DESCRIPTION:
# Apply the GraySky2 O3 patchset.
#
# ot-kernel-common_apply_o3_fixes - callback for fix to O3 patches
#
function apply_o3() {
	cd "${S}"

	# fix patch
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" ${DISTDIR}/${O3_CO_FN} > ${T}/${O3_CO_FN} || die

	einfo "Applying O3"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."

	einfo "Applying ${O3_CO_FN}"
	_tpatch "${PATCH_OPS}" "${T}/${O3_CO_FN}"

	einfo "Applying ${O3_RO_FN}"
	mkdir -p drivers/gpu/drm/amd/display/dc/basics/
	touch drivers/gpu/drm/amd/display/dc/basics/logger.c # trick patch for unattended patching
	_tpatch "-p1 -N" "${DISTDIR}/${O3_RO_FN}"

	if declare -f ot-kernel-common_apply_o3_fixes > /dev/null ; then
		ot-kernel-common_apply_o3_fixes
	fi
}

# @FUNCTION: apply_pds
# @DESCRIPTION:
# Apply the PDS CPU scheduler patchset.
function apply_pds() {
	cd "${S}"
	einfo "Applying pds"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${PDS_FN}"
}

# @FUNCTION: apply_bmq
# @DESCRIPTION:
# Apply the BMQ CPU scheduler patchset.
#
# ot-kernel-common_apply_bmq_quickfixes - callback to apply quick fixes
#
function apply_bmq() {
	cd "${S}"
	einfo "Applying bmq"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_FN}"

	if declare -f ot-kernel-common_apply_bmq_quickfixes > /dev/null ; then
		ot-kernel-common_apply_bmq_quickfixes
	fi
}

# @FUNCTION: apply_tresor
# @DESCRIPTION:
# Apply the TRESOR AES cold boot resistant patchset.
#
# ot-kernel-common_apply_tresor_fixes - callback to apply tresor fixes
#
function apply_tresor() {
	cd "${S}"
	einfo "Applying tresor"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local platform
	if use tresor_aesni ; then
		platform="aesni"
	fi
	if use tresor_i686 || use tresor_x86_64 ; then
		platform="i686"
	fi

	_tpatch "${PATCH_OPS}" "${DISTDIR}/tresor-patch-${PATCH_TRESOR_VER}_${platform}"
	if declare -f ot-kernel-common_apply_tresor_fixes > /dev/null ; then
		ot-kernel-common_apply_tresor_fixes
	fi
}

# @FUNCTION: fetch_bfq
# @DESCRIPTION:
# Fetches the BFQ patchset.
function fetch_bfq() {
	einfo "Fetching bfq patch from live source..."
	wget -O "${T}/${BFQ_FN}" "${BFQ_DL_URL}" || die
}

# @FUNCTION: fetch_zentune
# @DESCRIPTION:
# Fetches the zentune patchset.
function fetch_zentune() {
	einfo "Fetching zentune patch from live source..."
	wget -O "${T}/${ZENTUNE_FN}" "${ZENTUNE_DL_URL}" || die
}

# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Clones or updates the amd-staging-drm-next patchset for recent fixes or GPU compatibility updates.
function fetch_amd_staging_drm_next() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning amd-staging-drm-next project"
		git clone ${AMDREPO_URL} "${d}"
		cd "${d}"
		git checkout master
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
	else
		einfo "Updating amd-staging-drm-next project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git checkout master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}"
}

# @FUNCTION: fetch_amd_staging_drm_next_commits
# @DESCRIPTION:
# Pulls all the commits as .patch files to be individually evaluated.  It
# also pulls required missing commits to smooth out the patching process.
#
# ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1 - callback to reorder or fetch patches
# ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1_num - callback to set the next patch number
# ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2 - callback to apply additonal patches
#   for fixes to patches before the patching proces
#
function fetch_amd_staging_drm_next_commits() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}"

	local target
	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	else
		target="${AMD_STAGING_DRM_NEXT_STABLE}"
	fi

	# base is not inclusive
	local base
	if   use amd-staging-drm-next-latest && use rock-latest ; then
		einfo "amd-staging-drm-next-latest and rock-latest"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_LATEST}"
	elif use amd-staging-drm-next-snapshot && use rock-latest ; then
		einfo "amd-staging-drm-next-snapshot and rock-latest"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_LATEST}"
	elif use amd-staging-drm-next-milestone && use rock-latest ; then
		einfo "amd-staging-drm-next-snapshot and rock-latest"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_LATEST}"

	elif use amd-staging-drm-next-latest && use rock-snapshot ; then
		einfo "amd-staging-drm-next-latest and rock-snapshot"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_SNAPSHOT}"
	elif use amd-staging-drm-next-snapshot && use rock-snapshot ; then
		einfo "amd-staging-drm-next-snapshot and rock-snapshot"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_SNAPSHOT}"
	elif use amd-staging-drm-next-milestone && use rock-snapshot ; then
		einfo "amd-staging-drm-next-snapshot and rock-snapshot"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_SNAPSHOT}"

	elif use amd-staging-drm-next-latest && use rock-milestone ; then
		einfo "amd-staging-drm-next-latest and rock-milestone"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_MILESTONE}"
	elif use amd-staging-drm-next-snapshot && use rock-milestone ; then
		einfo "amd-staging-drm-next-snapshot and rock-milestone"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_MILESTONE}"
	elif use amd-staging-drm-next-milestone && use rock-milestone ; then
		einfo "amd-staging-drm-next-snapshot and rock-milestone"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_MILESTONE}"

	elif is_amd_staging_drm_next && ! is_rock ; then
		einfo "amd-staging-drm-next-* and ${K_PATCH_XV}"
		# use 5.1.x
		base="${AMD_STAGING_INTERSECTS_5_X}"
	else
		die "cannot handle case"
	fi

	mkdir -p "${T}/amd-staging-drm-next-patches"
	if ! is_rock ; then
		if declare -f ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1 > /dev/null ; then
			ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1
			n="$(ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches_num1)"
		else
			n="1"
		fi

	else
		n="1"
	fi

	einfo "Saving only the amd-staging-drm-next commits for commit-by-commit evaluation."
	L=$(git log ${base}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	for l in $L ; do
	        einfo "$n $l"
		printf -v pn "%06d" ${n}
	        git format-patch --stdout -1 $l > "${T}"/amd-staging-drm-next-patches/${pn}-$l.patch
	        n=$((n+1))
	done

	if declare -f ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2 > /dev/null ; then
		ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2
	fi
}

# @FUNCTION: _get_rock_commit
# @DESCRIPTION:
# Gets a rock commit and makes a .patch file.
# @CODE
# Parameters:
# $1 - index to generate to file name
# $2 - commit pull and to attach to filename
# $3 - postfix a-z letter to control ordering
# @CODE
function _get_rock_commit()
{
	local index="${1}"
	local commit="${2}"
	local postfix="${3}"
	printf -v pindex "%06d" ${index}
	git format-patch --stdout -1 ${commit} > "${T}"/rock-patches/${pindex}${postfix}-${commit}.patch || die
}

# @FUNCTION: _get_amd_staging_drm_next_commit
# @DESCRIPTION:
# Gets an amd-staging-drm-next commit and makes a .patch file
# @CODE
# Parameters:
# $1 - index to generate to file name
# $2 - commit pull and to attach to filename
# @CODE
function _get_amd_staging_drm_next_commit()
{
	local index="${1}"
	local commit="${2}"
	printf -v pindex "%06d" ${index}
	git format-patch --stdout -1 ${commit} > "${T}"/amd-staging-drm-next-patches/${pindex}-${commit}.patch || die
}

# @FUNCTION: fetch_rock
# @DESCRIPTION:
# Clones or updates the ROCK repository.  ROCK patches contain
# additional multi GPU features and optimizations if apps support it.
function fetch_rock() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning ROCK project"
		git clone ${ROCKREPO_URL} "${d}"
		cd "${d}"
		git checkout master
	else
		einfo "Updating ROCK project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git checkout master
		git pull
	fi
	cd "${d}"
}

# @FUNCTION: prepend_rock_commit
# @DESCRIPTION:
# Allows to add ROCK commits before others if necessary for smoothing patching.
# Patch A comes before patch B.
# @CODE
# Parameters:
# $1 - patch A
# $2 - patch B
# $3 - A's postfix to append
# $4 - B's postfix before modification
# $5 - C's postfix after modification
# @CODE
function prepend_rock_commit() {
	# a followed by b
	local commit_a="${1}"
	local commit_b="${2}"
	local commit_a_postfix="${3}"
	local commit_b_postfix_before="${4}"
	local commit_b_postfix_after="${5}"
	einfo "Prepending ${commit_a} before ${commit_b}"
	d="${T}/rock-patches"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${commit_b_postfix_before}*${commit_b}*))
	idx=$(echo ${f} | cut -c 1-6)
	if [[ "${f}" != "${idx}${commit_b_postfix_after}-${commit_b}.patch" ]] ; then
		mv "${d}"/${f} "${d}"/${idx}${commit_b_postfix_after}-${commit_b}.patch
	fi
	_get_rock_commit $(echo ${idx} | sed 's/^0*//') ${commit_a} "${commit_a_postfix}"
	sha1sum "${d}"/${idx}${commit_a_postfix}-${commit_a}.patch | cut -c 1-40 >> "${T}"/hashes
}

# @FUNCTION: move_rock_commit
# @DESCRIPTION:
# Allows to reorder ROCK commits before others if necessary for smoothing patching.
# @CODE
# Parameters:
# $1 - commit
# $2 - postfix before modification
# $3 - postfix after modification
# @CODE
function move_rock_commit() {
	# a followed by b
	local commit="${1}"
	local postfix_before="${2}"
	local postfix_after="${3}"
	d="${T}/rock-patches"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${postfix_before}*${commit}*))
	idx=$(echo ${f} | cut -c 1-6)
	einfo "idx=${idx} f=${f}"
	mv "${d}"/${f} "${d}"/${idx}${postfix_after}-${commit}.patch || die
	einfo "Moved to ${idx}${postfix_after}-${commit}.patch"
}

# @FUNCTION: get_patch_index
# @DESCRIPTION:
# Returns the index of a commit.
# @CODE
# Parameters:
# $1 - the patchset (the repo folder name containing the commit)
# $2 - commit
# @CODE
function get_patch_index() {
	local patchset_name="${1}"
	local commit="${2}"
	d="${T}/${patchset_name}"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${commit}*))
	idx=$(echo ${f} | cut -c 1-6 | sed 's/^0*//')
	echo ${idx}
}

# @FUNCTION: fetch_rock_commits
# @DESCRIPTION:
# Grabs all the commits and generates .patch files for individual evaluation.
function fetch_rock_commits() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	cd "${d}"

	local target
	if use rock-snapshot ; then
		target="${ROCK_SNAPSHOT}"
	elif use rock-latest ; then
		target="${ROCK_LATEST}"
	else
		target="${ROCK_MILESTONE}"
	fi

	git checkout ${target} . || die

	einfo "Saving only the AMD ROCK commits for commit-by-commit evaluation."
	L=$(git log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | \
			cut -c 1-40 | tac)
	mkdir -p "${T}/rock-patches"

	n="${NEXT_ROCK_COMMIT}"

	if declare -f ot-kernel-common_fetch_rock_commits_patchset1 > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_patchset1
	fi

	local p
	for l in $L ; do
	        einfo "$n $l"
		printf -v pn "%06d" ${n}
		p="${T}"/rock-patches/${pn}-$l.patch
	        git format-patch --stdout -1 $l > "${T}"/rock-patches/${pn}-$l.patch
		h=$(sha1sum ${p} | cut -c 1-40)

		# avoid adding duplicates
		grep -F -e "${h}" "${T}"/hashes > /dev/null
		if [[ "$?" == "1" ]] ; then
		        n=$((n+1))
		else
			einfo "Found dupe $(basename ${p} | cut -c 8-47)"
			rm "${p}" || die
		fi
	done

	if declare -f ot-kernel-common_fetch_rock_commits_patchset2 > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_patchset2
	fi
}

# @FUNCTION: get_missing_rock_commits_list
# @DESCRIPTION:
# Gets a list of rock commits that were not found in the amd-staging-drm-next repository.
function get_missing_rock_commits_list() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local index

	index=1
	d_staging="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d_staging}"
	einfo "Generating commit list for amd-staging-drm-next."
	git log --reverse --pretty=tformat:"%H %s" > "${T}"/amd-staging-drm-next.commits

	cat /dev/null > "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
	L=$(cat "${T}"/amd-staging-drm-next.commits)
	IFS=$'\n'
	A=""
	for l in ${L} ; do
		printf -v pindex "%06d" ${index}
		echo "${pindex} ${l}" >> "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
		index=$((${index} + 1))
	done
	unset IFS

	index=1
	d_rock="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	cd "${d_rock}"
	einfo "Generating commit list for ROCK."
	git log --reverse --pretty=tformat:"%H %s" > "${T}"/rock.commits

	cat /dev/null > "${T}"/rock.commits.indexed.${PVR}
	L=$(cat "${T}"/rock.commits)
	IFS=$'\n'
	A=""
	for l in ${L} ; do
		printf -v pindex "%06d" ${index}
		echo "${pindex} ${l}" >> "${T}"/rock.commits.indexed.${PVR}
		index=$((${index} + 1))
	done
	unset IFS

	cat "${T}"/amd-staging-drm-next.commits.indexed.${PVR} | cut -c 49- | sort > "${T}"/amd-staging-drm-next.summaries
	cat "${T}"/rock.commits.indexed.${PVR} | cut -c 49- | sort > "${T}"/rock.summaries

	einfo "Comparing commit lists"
	diff -urp "${T}"/rock.summaries "${T}"/amd-staging-drm-next.summaries > "${T}"/results
	grep -e "^-" "${T}"/results | cut -c 2- > "${T}"/results.no-dash
}

# @FUNCTION: get_missing_rock_commits
# @DESCRIPTION:
# Gets the ROCK commit list and generates .patch files for step-by-step evaluation.
function get_missing_rock_commits() {
	local commit
	mkdir -p "${T}"/rock-patches
	local index

	OIFS=${IFS}
	IFS=$'\n'
	L=$(cat "${T}"/results.no-dash)

	cat /dev/null > "${T}"/rock.found

	einfo "Picking commits"
	for l in ${L} ; do
		grep -F -e "${l}" "${T}/rock.commits.indexed.${PVR}" >> "${T}/rock.found"
	done

	cat "${T}"/rock.found | sort | uniq > "${T}"/rock.found.sorted

	cat /dev/null > "${T}"/hashes
	C=$(cat "${T}"/rock.found.sorted | cut -c 8-47)
	einfo "Generating commits"
	index=1
	local p
	for c in ${C} ; do
		einfo "$index ${c}"
		printf -v pindex "%06d" ${index}
		p="${T}"/rock-patches/${pindex}-${c}.patch
		git format-patch --stdout -1 ${c} > "${p}" || die
		sha1sum ${p} | cut -c 1-40 >> "${T}"/hashes
		index=$((index + 1))
	done
	export NEXT_ROCK_COMMIT="${index}"
	IFS="${OIFS}"
	einfo "NEXT_ROCK_COMMIT=${NEXT_ROCK_COMMIT}"
}

# @FUNCTION: fetch_staging_with_rock
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_staging_with_rock() {
	if is_amd_staging_drm_next ; then
		fetch_amd_staging_drm_next
	fi
	if is_rock ; then
		fetch_rock

		get_missing_rock_commits_list
		get_missing_rock_commits
	fi
}

# @FUNCTION: is_rock
# @DESCRIPTION:
# Check if user wanted rock
# @RETURN: zero - user wants rock; non-zero user doesn't want rock
function is_rock() {
	if use rock-snapshot || use rock-latest || use rock-milestone ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: is_amd_staging_drm_next
# @DESCRIPTION:
# Check if user wanted amd-staging-drm-next
# @RETURN: zero - user wants amd-staging-drm-next; non-zero user doesn't want amd-staging-drm-next
function is_amd_staging_drm_next() {
	if use amd-staging-drm-next-snapshot || use amd-staging-drm-next-latest || use amd-staging-drm-next-milestone ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: apply_amdgpu
# @DESCRIPTION:
# Applies intervention patches, or patches for mispatches, for both rock and amd-staging-drm-next.
#
# ot-kernel-common_apply_amdgpu_rock_fixes - optional callback for rock fixes
# ot-kernel-common_amdgpu_amd_staging_drm_next_fixes - optional callback for amd-staging-drm-next fixes
#
function apply_amdgpu() {
	fetch_staging_with_rock

	if declare -f ot-kernel-common_apply_amdgpu_rock_fixes > /dev/null ; then
		ot-kernel-common_apply_amdgpu_rock_fixes
	fi

	if declare -f ot-kernel-common_amdgpu_amd_staging_drm_next_fixes > /dev/null ; then
		ot-kernel-common_amdgpu_amd_staging_drm_next_fixes
	fi
}

# @FUNCTION: ot-kernel-common_src_unpack
# @DESCRIPTION:
# Applies patch sets in order.  It calls kernel-2_src_unpack.
function ot-kernel-common_src_unpack() {
	#if use zentune ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${ZENTUNE_FN}"
	#fi
	#if use uksm ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${UKSM_FN}"
	#fi
	if use muqss ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${CK_FN}"
	fi
	if use graysky2 ; then
		if $(version_is_at_least 9.1 $(gcc-version)) && test -f "${DISTDIR}/${GRAYSKY_DL_9_1_FN}" ; then
			einfo "gcc patch is 9.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_9_1_FN}"
		elif $(version_is_at_least 8.1 $(gcc-version)) && test -f "${DISTDIR}/${GRAYSKY_DL_8_1_FN}" ; then
			einfo "gcc patch is 8.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_8_1_FN}"
		elif test -f "${DISTDIR}/${GRAYSKY_DL_4_9_FN}" ; then
			einfo "gcc patch is 4.9"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_4_9_FN}"
		else
			die "Cannot find graysky2's gcc patch."
		fi
	fi
	#if use bfq ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${BFQ_FN}"
	#fi

	kernel-2_src_unpack

	cd "${S}"

	if use zentune ; then
		fetch_zentune
		apply_zentune
	fi

	if use uksm ; then
		apply_uksm
	fi

	if use bfq ; then
		fetch_bfq
		apply_bfq
	fi

	if use muqss ; then
		#_dpatch "${PATCH_OPS}" "${FILESDIR}/MuQSS-4.18-missing-se-member.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/muqss-dont-attach-ckversion.patch"
	fi

	if has pds ; then
		if use pds ; then
			apply_pds
		fi
	fi

	if has bmq ; then
		if use bmq ; then
			apply_bmq
		fi
	fi

	apply_genpatch_base
	apply_genpatch_experimental
	apply_genpatch_extras

	if has amd-staging-drm-next-snapshot || has amd-staging-drm-next-latest || has amd-staging-drm-next-milestone || \
		has rock-snapshot || has rock-latest || has rock-milestone ; then
		apply_amdgpu
	fi

	if use o3 ; then
		apply_o3
	fi

	if has tresor ; then
		if use tresor ; then
			apply_tresor
		fi
	fi

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
}

# @FUNCTION: ot-kernel-common_ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel-common_pkg_setup() {
	if declare -f ot-kernel-common_ot-kernel-common_pkg_setup_cb > /dev/null ; then
		ot-kernel-common_ot-kernel-common_pkg_setup_cb
	fi
}

# @FUNCTION: ot-kernel-common_src_compile
# @DESCRIPTION:
# Compiles the userland programs especially the post-boot TRESOR AES post boot program.
function ot-kernel-common_src_compile() {
	if has tresor_sysfs ; then
		if use tresor_sysfs ; then
			cp -a "${DISTDIR}/tresor_sysfs.c" "${T}"
			cd "${T}"
			einfo "$(tc-getCC) ${CFLAGS}"
			$(tc-getCC) ${CFLAGS} tresor_sysfs.c -o tresor_sysfs || die
		fi
	fi
}

# @FUNCTION: ot-kernel-common_src_install
# @DESCRIPTION:
# Removes patch cruft.
function ot-kernel-common_src_install() {
	find "${S}" -name "*.orig" -print0 -o -name "*.rej" -print0 | xargs -0 rm
}

# @FUNCTION: ot-kernel-common_pkg_postinst
# @DESCRIPTION:
# Present warnings and avoid collision checks.
#
# ot-kernel-common_ot-kernel-common_pkg_postinst_cb - callback if any to handle after emerge phase
#
function ot-kernel-common_pkg_postinst() {
	if declare -f ot-kernel-common_ot-kernel-common_pkg_postinst_cb > /dev/null ; then
		ot-kernel-common_ot-kernel-common_pkg_postinst_cb
	fi

}

# @FUNCTION: ot-kernel-common_pkg_postrm
# @DESCRIPTION:
# Clean up kruft from older releases.
function ot-kernel-common_pkg_postrm() {
	[ -e "${T}"/amd-staging-drm-next.commits.indexed.${PVR} ] && rm "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
	[ -e "${T}"/rock.commits.indexed.${PVR} ] && rm "${T}"/rock.commits.indexed.${PVR}

}
