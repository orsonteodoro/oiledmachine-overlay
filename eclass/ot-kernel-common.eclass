# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-common.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-common eclass defines common patching steps for any linux kernel version.

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.3...zen-kernel:5.3/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.2/5.2-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:		https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.3...zen-kernel:5.3/bfq-backports
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

case ${EAPI:-0} in
	7) die "this eclass doesn't support EAPI ${EAPI}" ;;
	*) ;;
esac

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

inherit ot-kernel-cve

DEPEND+=" dev-util/patchutils"

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

KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/patch-${K_MAJOR_MINOR}.1.xz"

LINUX_REPO_URL="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"

if [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
	KERNEL_PATCH_URLS=()
elif [[ -n "${KERNEL_0_TO_1_ONLY}" && "${KERNEL_0_TO_1_ONLY}" == "1" ]] ; then
	KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL})
	KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz)
	KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1)
else
	KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(ver_cut 3 ${PV})))
	KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
	KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
	KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
fi

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
	einfo "Applying ${path}"
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
	einfo "Applying the genpatch base"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" "${S}"/Makefile || die

	if [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
		true
	else
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
	fi

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
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" "${DISTDIR}"/${O3_CO_FN} > "${T}"/${O3_CO_FN} || die

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
	einfo "Fetching the BFQ patch from a live source..."
	wget -O "${T}/${BFQ_FN}" "${BFQ_DL_URL}" || die
}

# @FUNCTION: fetch_zentune
# @DESCRIPTION:
# Fetches the zentune patchset.
function fetch_zentune() {
	einfo "Fetching the zen-tune patch from a live source..."
	wget -O "${T}/${ZENTUNE_FN}" "${ZENTUNE_DL_URL}" || die
}

function fetch_linux_sources() {
	einfo "Fetching the vanilla Linux kernel sources.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning the vanilla Linux kernel project"
		git clone "${LINUX_REPO_URL}" "${d}"
		cd "${d}"
		git checkout master
		git checkout -b v${K_MAJOR_MINOR} tags/v${K_MAJOR_MINOR}
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die "You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the vanilla Linux kernel project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D v${K_MAJOR_MINOR}
		git checkout -b v${K_MAJOR_MINOR} tags/v${K_MAJOR_MINOR}
		git pull
	fi
	cd "${d}"
}

# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Clones or updates the amd-staging-drm-next patchset for recent fixes or GPU compatibility updates.
function fetch_amd_staging_drm_next() {
	einfo "Fetching the amd-staging-drm-next project please wait.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning the amd-staging-drm-next project"
		git clone "${AMDREPO_URL}" "${d}"
		cd "${d}"
		git checkout master
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die "You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the amd-staging-drm-next project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}"
}

function set_amd_staging_drm_next_commits_target_base() {
	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	else
		target="${AMD_STAGING_DRM_NEXT_STABLE}"
	fi

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
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}"

	local target

	# base is not inclusive
	local base

	set_amd_staging_drm_next_commits_target_base

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
	einfo "Doing commit -> .patch conversion for amd-staging-drm-next-patches set:"
	L=$(git log ${base}..${target} --oneline --pretty=format:"%H%x07%s%x07%ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -f1 -d$'\007' | tac)
	for l in $L ; do
		printf -v pn "%06d" ${n}
	        git format-patch --stdout -1 $l > "${T}"/amd-staging-drm-next-patches/${pn}-$l.patch
	        einfo "Added ${pn}-$l.patch"
	        n=$((n+1))
	done

	if declare -f ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2 > /dev/null ; then
		ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2
	fi
}

# @FUNCTION: _get_rock_commit
# @DESCRIPTION:
# Gets a ROCk commit and makes a .patch file.
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
# Clones or updates the ROCk repository.  ROCk patches contain
# additional multi GPU features and optimizations if apps support it.
function fetch_rock() {
	einfo "Fetching the ROCk project please wait.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning the ROCk project"
		git clone "${ROCKREPO_URL}" "${d}"
		cd "${d}"
		git checkout master
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die "You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the ROCk project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
	fi
	cd "${d}"
}

# @FUNCTION: prepend_rock_commit
# @DESCRIPTION:
# Allows to add ROCk commits before others if necessary for smoothing patching.
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
	idx=$(echo ${f} | cut -f1 -d'-')
	if [[ "${f}" != "${idx}${commit_b_postfix_after}-${commit_b}.patch" ]] ; then
		mv "${d}"/${f} "${d}"/${idx}${commit_b_postfix_after}-${commit_b}.patch
	fi
	_get_rock_commit $(echo ${idx} | sed 's/^0*//') ${commit_a} "${commit_a_postfix}"
	sha1sum "${d}"/${idx}${commit_a_postfix}-${commit_a}.patch | cut -f1 -d' ' >> "${T}"/hashes
}

# @FUNCTION: move_rock_commit
# @DESCRIPTION:
# Allows to reorder ROCk commits before others if necessary for smoothing patching.
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
	idx=$(echo ${f} | cut -f1 -d'-')
	einfo "move_rock_commit:  idx=${idx} f=${f}"
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
	idx=$(echo ${f} | cut -f1 -d'-' | sed 's/^0*//')
	echo ${idx}
}

# @FUNCTION: get_linux_commit_list_for_rock
# @DESCRIPTION:
# Gets the list of ROCk commits between ROCK_BASE and v${K_MAJOR_MINOR}
function get_linux_commit_list_for_rock() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	cd "${d}"
	einfo "Grabbing list of already merged ROCk commits in v${K_MAJOR_MINOR}."
	L=$(git log ${ROCK_BASE}..v${K_MAJOR_MINOR} --oneline --pretty=format:"%H%x07%s%x07%ce" | grep -e "@amd.com" | \
			cut -f1 -d$'\007' | tac)

	cat /dev/null > "${T}/linux.commits.rock"
	for l in $L ; do
		echo "${l}" >> "${T}/linux.commits.rock"
	done
}

# DEPRECATED: TO BE REMOVED
# @FUNCTION: fetch_rock_commits
# @DESCRIPTION:
# Grabs all the commits and generates .patch files for individual evaluation.
function fetch_rock_commits() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
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

	einfo "Saving only the ROCk commits for commit-by-commit evaluation."
	L=$(git log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H%x07%s%x07%ce" | grep -e "@amd.com" | \
			cut -f1 -d$'\007' | tac)
	mkdir -p "${T}/rock-patches"

	n="${NEXT_ROCK_COMMIT}"

	if declare -f ot-kernel-common_fetch_rock_commits_patchset1 > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_patchset1
	fi

	OIFS="${IFS}"
	IFS=$'\n'
	local p
	einfo "Doing commit -> .patch conversion for rock-patches set:"
	for l in $L ; do
		printf -v pn "%06d" ${n}
		p="${T}"/rock-patches/${pn}-$l.patch
	        git format-patch --stdout -1 $l > "${T}"/rock-patches/${pn}-$l.patch
		h=$(sha1sum ${p} | cut -f1 -d' ')

		# avoid adding duplicates
		grep -F -e "${h}" "${T}"/hashes > /dev/null
		if [[ "$?" == "1" ]] ; then
		        einfo "Added ${pn}-$l.patch"
		        n=$((n+1))
		else
			h=$(basename ${p} | sed -e "s|[.]|-|" | cut -f2 -d'-')
			einfo "Found dupe ${h}"
			rm "${p}" || die
		fi
	done
	IFS="${OIFS}"

	if declare -f ot-kernel-common_fetch_rock_commits_patchset2 > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_patchset2
	fi
}

# @FUNCTION: get_missing_rock_commits_list
# @DESCRIPTION:
# Gets a list of ROCk commits that were not found in the amd-staging-drm-next repository.
function get_missing_rock_commits_list() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local index

	index=1

	touch "${T}"/amd-staging-drm-next.commits
	touch "${T}"/amd-staging-drm-next.commits.indexed.${PVR}

	if is_amd_staging_drm_next ; then
		d_staging="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
		cd "${d_staging}"
		einfo "Generating a commit list for amd-staging-drm-next."
		git log --reverse --pretty=tformat:"%H%x07%s" | column -t -s $'\007' -o $'\t' > "${T}"/amd-staging-drm-next.commits

		cat /dev/null > "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
		L=$(cat "${T}"/amd-staging-drm-next.commits)
		OIFS="${IFS}"
		IFS=$'\n'
		A=""
		for l in ${L} ; do
			printf -v pindex "%06d" ${index}
			echo -e "${pindex}\t${l}" >> "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
			index=$((${index} + 1))
		done
		IFS="${OIFS}"
	fi

	index=1
	d_rock="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	cd "${d_rock}"

	local target
	if use rock-snapshot ; then
		target="${ROCK_SNAPSHOT}"
	elif use rock-latest ; then
		target="${ROCK_LATEST}"
	else
		target="${ROCK_MILESTONE}"
	fi

	git checkout ${target} . || die

	einfo "Generating a commit list for ROCk."
	git log ${ROCK_BASE}..${target} --reverse --pretty=tformat:"%H%x07%s" | column -t -s $'\007' -o $'\t' > "${T}"/rock.commits

	cat /dev/null > "${T}"/rock.commits.indexed.${PVR}
	L=$(cat "${T}"/rock.commits)
	OIFS="${IFS}"
	IFS=$'\n'
	A=""
	for l in ${L} ; do
		printf -v pindex "%06d" ${index}
		echo -e "${pindex}\t${l}" >> "${T}"/rock.commits.indexed.${PVR}
		index=$((${index} + 1))
	done
	IFS="${OIFS}"

	cat "${T}"/amd-staging-drm-next.commits.indexed.${PVR} | cut -f3 | sort > "${T}"/amd-staging-drm-next.summaries
	cat "${T}"/rock.commits.indexed.${PVR} | cut -f3 | sort > "${T}"/rock.summaries

	# It's important that amd-staging-drm-next- USE flag be enabled or else all the commits will be pulled in rock.commits.indexed.${PVR}.
	# A cached copy of amd-staging-drm-next.commits can be used with modifcations below, or one can modify the below section to compare against the linux vanilla commit list if the amd-staging-drm-next- USE flag is disabled.

	# The ROCk patch set is the set of commits assumed to be the set not in amd-staging-drm-next commit set
	einfo "Comparing commit lists"
	diff -urp "${T}"/rock.summaries "${T}"/amd-staging-drm-next.summaries | tail -n +3 > "${T}"/results
	grep -a -P -e "^-" "${T}"/results | cut -c 2- > "${T}"/results.no-dash
}

# @FUNCTION: _add_rock_patch
# @DESCRIPTION:
# Add ROCk patch and increments index
function _add_rock_patch() {
	git format-patch --stdout -1 ${c} > "${p}" || die
	einfo "Added ${pindex}-${c}.patch"
	sha1sum ${p} | cut -f1 -d' ' >> "${T}"/hashes
	index=$((index + 1))
}

# @FUNCTION: get_missing_rock_commits
# @DESCRIPTION:
# Gets the ROCk commit list and generates .patch files for step-by-step evaluation.
function get_missing_rock_commits() {
	local commit
	mkdir -p "${T}"/rock-patches
	local index

	OIFS="${IFS}"
	IFS=$'\n'
	L=$(cat "${T}"/results.no-dash)

	cat /dev/null > "${T}"/rock.found

	einfo "Picking commits"
	for l in ${L} ; do
		local entry=$(grep -a -F -e "${l}" "${T}/rock.commits.indexed.${PVR}")
		local c=$(echo "${entry}" | cut -f2)
		if echo "${l}" | grep -F -q -e "drm/amdkcl" ; then
			# kcl is the Kernel Compatibility Layer
			einfo "Rejected \"${l}\" because using the non DKMS."
		elif echo "${l}" | grep -P -q -e "\[(RHEL|SLE|DEBIAN)[ .0-9_]*\]" ; then
			einfo "Rejected \"${l}\" because it does not apply to Gentoo."
		elif echo "${l}" | grep -P -q -e "\[DKMS[ .0-9_]*\]" ; then
			einfo "Rejected \"${l}\" because using the non DKMS version."
		elif echo "${l}" | grep -P -q -e "\[[ .0-9_]*\]" ; then
			einfo "Rejected \"${l}\" because it does not apply to v${K_MAJOR_MINOR} kernel version."
		elif [[ "${c}" =~ 1c0e722ee1bf41681a8cc7101b7721e52f503da9 || \
			"${c}" =~ 593428bcfeb90e93621b66dbb2909b91da999344 ]] ; then
			# 1c0e [PATCH] drm/amdkcl: [KFD] ALL in One KFD KCL Fix for 4.18 rebase
			# 5934 drm/amdkcl: [4.5] fix drm encoder and plane functions
			einfo "Rejected \"${l}\" because it does not apply to v${K_MAJOR_MINOR} kernel version."
		elif [[ "${c}" =~ 58dfa09e4da6c13a4e074d1e6602b98e7f69474d || \
			"${c}" =~ cb487f9804a402f1b082ba6cc7e9736659951c6a || \
			"${c}" =~ d732ef0efc3beed8b8c30433aa11d5b6895cb457 || \
			"${c}" =~ c580415a6e1187f629b487f6c84e6453b67a4cd7 || \
			"${c}" =~ 02507c4d6d3111ec9f3918aad1ec68e5293ca32a || \
			"${c}" =~ 1e13f29eebc9f436419b7e15ad16a4eecd164953 || \
			"${c}" =~ 56e3a504356d5b1d39d3a06d9b70ebaab1ca0120 || \
			"${c}" =~ fbb2398b29e0de236e9ee3ad48385095ebcb2a84 || \
			"${c}" =~ dc8d9340b03c49743081707f1a9e845fd7347bfc || \
			"${c}" =~ 77843fb3174f0903bf48141cdb7ad0e545364194 || \
			"${c}" =~ 5fb3731bafd89d2cb5fc24651410ec79980eff4b || \
			"${c}" =~ d6a1c6e9da2ed2e2ceffc7742c6c316a1b66d92c || \
			"${c}" =~ 38d5546b8cd23bc4e265c4ec430f019de620eaf7 || \
			"${c}" =~ 05b0848bf51c7e4f33c633c72aecb3c94366482f || \
			"${c}" =~ 9b5c679e8175c5f311c45df5d2eed70aa3a7cddf || \
			"${c}" =~ 21e7a42fe26d0dcee15b988b1d523363324d07c5 ]] ; then
			# 58df drm/amdkcl: Enable DC by default on dce8 for dkms builds
			# cb48 drm/amd/dkms: enable dcn2 in dkms
			# d732 drm/amdkcl: add dkms support
			# c580 drm/amd/autoconf: Add AC_AMDGPU_CONFIG macro with basic configuration
			# 0250 drm/amdkcl: fix ttm_buffer_object has no moving
			# 1e13 drm/amd/autoconf: Add initial autoconf framework to DKMS build
			# 56e3 drm/amd/autoconf: Add AC_KERNEL_TRY_COMPILE macro
			# fbb2 drm/amd/autoconf: fix in-build error for O=...
			# dc8d Drop autogen.sh call
			# 7784 drm/amdgpu: add DKMS support for amdkfd module build in amdgpu.
			# 5fb3  drm/amdkcl: fix amdkfd moudle confusion by correcting value of CONFIG_HSA_AMD
			# d6a1 drm/amd/autoconf: Add AC_KERNEL_TRY_COMPILE_SYMBOL macro
			# 38d5 drm/amd/dkms: Disable DC_DCN2_0
			# 05b0 drm/amdkcl: [KFD] add kfd dkms support
			# 9b5c [PATCH] drm/amd/autoconf: Test whether ACPI_HANDLE is defined
			# 21e7 drm/amdkcl: fix no pci_enable_atomic_ops_to_root
			einfo "Rejected \"${l}\" because using the non DKMS version of ROCk."
		elif [[ "${c}" =~ 84eda13eb222032258084a330a334ced3b247f84 || \
			"${c}" =~ 58818a063b4f2db5dfb3cf45bbfb3cc6c1d66547 || \
			"${c}" =~ 8835687645d32c218aaab226b71276263174ef72 ]] ; then
			# 84ed drm/amdkcl: fix ubuntu 4.15-oem modprobe error
			einfo "Rejected \"${l}\" because it doesn't apply to Gentoo."
		else
			echo "${entry}" >> "${T}/rock.found"
		fi
	done

	# drm/amdgpu: remove chash (04ed8459f3348f95c119569338e39294a8e02349) gets removed in +5.2 we need to add it temporarly for smoother patching
	# the patch below will re add it back

	# /drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
	# gets renamed in 2fbd6f94accdbb223acccada68940b50b0c668d9
	# drm/amdgpu: rename amdgpu_prime.[ch] into amdgpu_dma_buf.[ch]
	# may 6, 2019
	# reverse the patch

	# inject missing patches
	# This one was in 5.1 vanilla repo but does not show up in the tarball
	echo -e "000000\t5d86b2c391965cbcb295e8fa795276977b2a416e\tdrm/amd: Closed hash table with low overhead (v2)" >> "${T}/rock.found" || die

	cat "${T}"/rock.found | sort | uniq > "${T}"/rock.found.sorted

	index=1
	cat /dev/null > "${T}"/hashes
	if [[ $(stat -c %s "${T}/rock.found.sorted") != "0" ]] ; then
		C=$(cat "${T}"/rock.found.sorted | cut -f2)
		einfo "Saving only the missing ROCk commits for commit-by-commit evaluation."
		local p
		for c in ${C} ; do
			printf -v pindex "%06d" ${index}
			p="${T}"/rock-patches/${pindex}-${c}.patch

			if [[ "${c}" == "5d86b2c391965cbcb295e8fa795276977b2a416e" || \
			      "${c}" == "2fbd6f94accdbb223acccada68940b50b0c668d9" ]] ; then
				_add_rock_patch
			elif grep -q -a -F -e "${c}" "${T}/linux.commits.rock" ; then
				einfo "Already merged ${c} in vanilla linux kernel v${K_MAJOR_MINOR}.  Skipping..."
			else
				_add_rock_patch
			fi
		done
	fi
	export NEXT_ROCK_COMMIT="${index}"
	IFS="${OIFS}"
	einfo "NEXT_ROCK_COMMIT=${NEXT_ROCK_COMMIT}"
}

# @FUNCTION: fetch_staging_with_rock
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_staging_with_rock() {
	if is_amd_staging_drm_next || is_rock; then
		if [[ -z "$OT_KERNEL_CACHED_COMMITS" ]] ; then
			fetch_linux_sources
		else
			fetch_linux_sources_cached
		fi
	fi
	if is_amd_staging_drm_next ; then
		get_linux_commit_list_for_amd_staging_drm_next
		if [[ -z "$OT_KERNEL_CACHED_COMMITS" ]] ; then
			fetch_amd_staging_drm_next
		else
			fetch_amd_staging_drm_next_cached
		fi
	fi
	if is_rock ; then
		fetch_rock

		if [[ -z "$OT_KERNEL_CACHED_COMMITS" ]] ; then
			get_linux_commit_list_for_rock
		else
			get_linux_commit_list_for_rock_cached
		fi

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
# Applies intervention patches, or patches for mispatches, for both ROCk and amd-staging-drm-next.
#
# ot-kernel-common_apply_amdgpu_rock_fixes - optional callback for ROCk fixes
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
		if $(ver_test $(gcc-version) -ge 9.1) && test -f "${DISTDIR}/${GRAYSKY_DL_9_1_FN}" ; then
			einfo "GCC patch is 9.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_9_1_FN}"
		elif $(ver_test $(gcc-version) -ge 8.1) && test -f "${DISTDIR}/${GRAYSKY_DL_8_1_FN}" ; then
			einfo "GCC patch is 8.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_8_1_FN}"
		elif test -f "${DISTDIR}/${GRAYSKY_DL_4_9_FN}" ; then
			einfo "GCC patch is 4.9"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_4_9_FN}"
		else
			die "Cannot find graysky2's GCC patch."
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

	if has pds ${IUSE_EFFECTIVE} ; then
		if use pds ; then
			apply_pds
		fi
	fi

	if has bmq ${IUSE_EFFECTIVE} ; then
		if use bmq ; then
			apply_bmq
		fi
	fi

	apply_genpatch_base
	apply_genpatch_experimental
	apply_genpatch_extras

	# should be done after all the kernel point releases contained in apply_genpatch_base
	fetch_cve_hotfixes

	if has amd-staging-drm-next-snapshot ${IUSE_EFFECTIVE} || has amd-staging-drm-next-latest ${IUSE_EFFECTIVE} || has amd-staging-drm-next-milestone ${IUSE_EFFECTIVE} || \
		has rock-snapshot ${IUSE_EFFECTIVE} || has rock-latest ${IUSE_EFFECTIVE} || has rock-milestone ${IUSE_EFFECTIVE} ; then
		apply_amdgpu
	fi

	if use o3 ; then
		apply_o3
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			apply_tresor
		fi
	fi

	apply_cve_hotfixes

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
}

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel-common_pkg_setup() {
	if declare -f ot-kernel-common_pkg_setup_cb > /dev/null ; then
		ot-kernel-common_pkg_setup_cb
	fi
}

# @FUNCTION: ot-kernel-common_pkg_pretend_cb
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel-common_pkg_pretend() {
	if declare -f ot-kernel-common_pkg_pretend_cb > /dev/null ; then
		ot-kernel-common_pkg_pretend_cb
	fi
}

# @FUNCTION: ot-kernel-common_src_compile
# @DESCRIPTION:
# Compiles the userland programs especially the post-boot TRESOR AES post boot program.
function ot-kernel-common_src_compile() {
	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
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

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			docinto /usr/share/${PF}
			dodoc "${DISTDIR}/tresor-readme.html"
		fi
	fi

}

# @FUNCTION: ot-kernel-common_pkg_postinst
# @DESCRIPTION:
# Present warnings and avoid collision checks.
#
# ot-kernel-common_pkg_postinst_cb - callback if any to handle after emerge phase
#
function ot-kernel-common_pkg_postinst() {
	if use disable_debug ; then
		einfo "The disable debug scripts have been placed in your /usr/src folder."
		einfo "They disable debug paths, logging, output for a performance gain."
		einfo "You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`"
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			# prevent merge conflicts
			cd "${T}"
			mv tresor_sysfs "${EROOT}/usr/bin" || die
			chmod 700 "${EROOT}"/usr/bin/tresor_sysfs || die
			# same hash for 5.1 and 5.0.13 for tresor_sysfs
			einfo "/usr/bin/tresor_sysfs is provided to set your TRESOR key"
		fi
	fi

	if declare -f ot-kernel-common_pkg_postinst_cb > /dev/null ; then
		ot-kernel-common_pkg_postinst_cb
	fi

}

# @FUNCTION: ot-kernel-common_pkg_postrm
# @DESCRIPTION:
# Clean up kruft from older releases.
function ot-kernel-common_pkg_postrm() {
	[ -e "${T}"/amd-staging-drm-next.commits.indexed.${PVR} ] && rm "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
	[ -e "${T}"/rock.commits.indexed.${PVR} ] && rm "${T}"/rock.commits.indexed.${PVR}

}
