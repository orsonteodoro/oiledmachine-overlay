# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.3.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 5.3.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.3 eclass defines specific applicable patching for the 5.3.x linux kernel.

ETYPE="sources"

K_MAJOR_MINOR="5.3"
K_PATCH_XV="5.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.0"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.3"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.3"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?10}"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="0ebe06178ea25923b33397ff04e9d701356825a0"
PATCH_PDS_MAJOR_MINOR="5.0"
PATCH_PDS_VER="${PATCH_PDS_VER:=099o}"
PATCH_BFQ_VER="5.3"
PATCH_TRESOR_VER="3.18.5"
PATCH_BMQ_VER="${PATCH_BMQ_VER:=100}"
PATCH_BMQ_MAJOR_MINOR="5.3"
DISABLE_DEBUG_V="1.1"

# DC_VER 3.2.35 in drivers/gpu/drm/amd/display/dc/dc.h for ${PV}
# KMS_DRIVER 3.33.0 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for ${PV}

AMD_STAGING_DRM_NEXT_LATEST="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_DIR="amd-staging-drm-next"

AMD_STAGING_DRM_NEXT_SNAPSHOT="4a6c7afe7d1acc6d2f4b94d62843c72cbf2c60a" # latest commit I tested which should be ideally head
# 2019-09-20 drm/amdgpu/ras: fix and update the documentation for RAS
AMD_STAGING_DRM_NEXT_STABLE="b2e02e6df8bb7850db1a43389d4afe5d486cdd51" # corresponds to 19.30 latest commit from amd-staging-drm-next
# 2019-09-19 drm/amdgpu/gfx10: update gfx golden settings for navi14

AMD_STAGING_DRM_NEXT_MILESTONE="a35d69a03b08e868ad222b1faa6ae5cc2c39113e" # corresponds to the tagged commit:: 2019-09-17 drm/amd/display: 3.2.51.1

ROCK_DIR="ROCK-Kernel-Driver"
# ROCK_BASE should match ${PV}'s DC_VER

# ROCK_BASE starts at the first commit in ROCK-Kernel-Driver by either these keywords
# drm/amdgpu: [hybrid]
# drm/amdkcl
# drm/amdkfd
# HMM

# if we pull just this, many commits are still missing
#ROCK_BASE="5f62954ac3050cbda03fa70b3cb67b92488e0c65" # 2019-04-08 drm/amd/display: 3.2.35

# Rechange base
# Commit date: Oct 10, 2015
# Commit hash: 61cc8365b3cc4c549dbddd5d1576e6cf499bbef7
# Subject:: drm/amdgpu: [hybrid] add query for aperture va range

# commit below pulls additional commits further back that 3.2.35 depends on that were missing
#ROCK_BASE="61cc8365b3cc4c549dbddd5d1576e6cf499bbef7" # drm/amdgpu: [hybrid] add query for aperture va range

# 61cc8365b3cc4c549dbddd5d1576e6cf499bbef7 depends on ca3324ff2f43c67cc100e67332589b054d97b774

# Rechange base
# Pull the first ROCk commit referencing amdkfd
# Commit date: Jul 15, 2014
# Commit hash: e28740ece34d314002b1ddfa14e8fb7c7b909489
# Subject: drm/radeon: Add radeon <--> amdkfd interface

ROCK_BASE="e28740ece34d314002b1ddfa14e8fb7c7b909489"

# before .program_vline_interrupt = optc1_program_vline_interrupt,
ROCK_SNAPSHOT="38d5546b8cd23bc4e265c4ec430f019de620eaf7" # corresponds to master snapshot at 2019-07-26 drm/amd/dkms: Disable DC_DCN2_0
ROCK_MILESTONE="38d5546b8cd23bc4e265c4ec430f019de620eaf7" # corresponds to snapshot of roc-2.7.0
ROCK_LATEST="master"

# The intersection is defined to be the newer commit of rock_xxxx that intersects amd-staging-drm-next

# The intersection is not in perfect sync or easy to determine.  We will get the bulk of the amd-staging-drm-next and worry about the corner case which is the intersection.
# The deviation from the intersection could be months.

# The ROCk patches get applied first, then the amd-staging-drm-next patches follow after.

# The AMD_STAGING_*_INTERSECS_ROCK_* and the AMD_STAGING_INTERSECTS_5_X constants marks the starting point of the amd-staging-drm-next patching.
# Scan the git history logs (https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/commits/master/ of the drivers/gpu/drm/amd folder
# and https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next) starting from ROCK-Kernel-Driver's
# "drm/amd/display: 3.2.35" [same as min common DC_VER for amd-staging-drm-next (3.2.51.1) [corresponding to AMD_STAGING_DRM_NEXT_MILESTONE] and ROCK-Kernel-Driver (3.2.35) [corresponding to DC_VER]] till you find the recent most last sequential commits.
# You may need to go back a few DC_VER before 3.2.27 to pull missing commits between 3.2.35 and >3.2.3x.
# Get the commit hash from amd-staging-drm-next.
# A 2019-06-11 drm/amdgpu: Add CHIP_VEGAM to amdgpu_amdkfd_device_probe

# Scan the git history logs (https://github.com/torvalds/linux/commits/v5.3/ and https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next of the folder drivers/gpu/drm/amd) starting from linus' tag of v5.3 for "drm/amd/display: 3.2.35"
# [same as the kernel's DC_VER] till you find the last sequential commits before 3.2.36.  Get the commit hash from amd-staging-drm-next.
# You should see the drm-next- tags progressing towards the latest drm-next.  drm-next-5.3, drm-next-5.3-2019-*, and drm-fixes-5.2 tags were present.
# B 2019-07-18 drm/amd/display: handle active dongle port type is DP++ or DP case

AMD_STAGING_LATEST_INTERSECTS_ROCK_LATEST="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_LATEST="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_LATEST="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A

AMD_STAGING_LATEST_INTERSECTS_ROCK_SNAPSHOT="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_SNAPSHOT="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_SNAPSHOT="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A

AMD_STAGING_LATEST_INTERSECTS_ROCK_MILESTONE="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_MILESTONE="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_MILESTONE="9c5ab937b15f87523dd057ba05b9869331283286" # corresponds to A

AMD_STAGING_INTERSECTS_5_X="b70666934b41c081489d5ff3c5bf017796545d35" # corresponds to B

IUSE="bfq bmq bmq-quick-fix amd-staging-drm-next-latest amd-staging-drm-next-snapshot amd-staging-drm-next-milestone +cfs disable_debug +graysky2 muqss +o3 pds rock-latest rock-snapshot rock-milestone uksm tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs -zentune"
REQUIRED_USE="^^ ( muqss pds cfs bmq )
	     tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	     tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	     tresor_i686? ( tresor )
	     tresor_x86_64? ( tresor )
	     tresor_aesni? ( tresor )
	     amd-staging-drm-next-snapshot? ( !amd-staging-drm-next-latest !amd-staging-drm-next-milestone )
	     amd-staging-drm-next-latest? ( !amd-staging-drm-next-snapshot !amd-staging-drm-next-milestone )
	     amd-staging-drm-next-milestone? ( !amd-staging-drm-next-snapshot !amd-staging-drm-next-latest )
	     rock-latest? ( !rock-snapshot !rock-milestone ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )
	     rock-snapshot? ( !rock-latest !rock-milestone ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )
	     rock-milestone? ( !rock-latest !rock-snapshot ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )"

# rock- needs amd-staging-drm-next for diff comparison or it pulls more than it should.  Should use cached copies.

# The reason why we make rock-snapshot a dependency of amd-staging-drm-next so we don't have to git clone torvalds/linux which saves time and space.  We assume that amd-staging-drm-next repo contains torvalds/linux
# This dependency with log comparison provides more accurate way to determine if ROCk commits are duplicates instead of manually eliminating commits which human error can screw up.

# amd-staging-drm-next head will contain Linux 5.3-rc3 which are linux commits up to aug 4, 2019
# In amd-staging-drm-next, Linux 5.3-rc3 is commit e21a712a9685488f5ce80495b37b9fdbe96c230d .
LINUX_KERNEL_LATEST_TAG="e21a712a9685488f5ce80495b37b9fdbe96c230d"
ASDN_KERNEL_LATEST_VER_DESC="Linux 5.3-rc3"

# no released patch yet
REQUIRED_USE+=" !pds !bmq-quick-fix !muqss"

if [[ -z "${OT_SOURCES_DEVELOPER}" ]] || [[ "${OT_SOURCES_DEVELOPER}" != "1" ]] ; then
# disabled because unfinished
REQUIRED_USE+=" !amd-staging-drm-next-snapshot !amd-staging-drm-next-latest !amd-staging-drm-next-milestone !rock-latest !rock-snapshot !rock-milestone"

# disabled because it doesn't work
REQUIRED_USE+=" !tresor !tresor_i686 !tresor_x86_64 !tresor_aesni"
fi

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="rock-latest? ( dev-vcs/git sys-firmware/rock-firmware )
	rock-snapshot? ( dev-vcs/git sys-firmware/rock-firmware )
	rock-milestone? ( dev-vcs/git sys-firmware/rock-firmware )
	amd-staging-drm-next-snapshot? ( dev-vcs/git )
	amd-staging-drm-next-latest? ( dev-vcs/git )
	amd-staging-drm-next-milestone? ( dev-vcs/git )
	dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates, ROCK-Kernel-Driver, amd-staging-drm-next, TRESOR"

ROCKREPO_URL="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver.git"
AMDREPO_URL="git://people.freedesktop.org/~agd5f/linux"
AMD_PATCH_FN="${AMD_STAGING_DRM_NEXT_DIR}.patch"

CK_URL_BASE="http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

inherit check-reqs ot-kernel-common

BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.diff"
BMQ_SRC_URL+=" https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}"

# no release yet
#SRC_URI+=" ${CK_SRC_URL}"

SRC_URI+=" ${KERNEL_URI}
	   ${GENPATCHES_URI}
	   ${ARCH_URI}
	   ${O3_CO_SRC_URL}
	   ${O3_RO_SRC_URL}
	   ${GRAYSKY_SRC_4_9_URL}
	   ${GRAYSKY_SRC_8_1_URL}
	   ${GRAYSKY_SRC_9_1_URL}
	   ${BMQ_SRC_URL}
	   ${GENPATCHES_BASE_SRC_URL}
	   ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	   ${GENPATCHES_EXTRAS_SRC_URL}
	   ${TRESOR_AESNI_DL_URL}
	   ${TRESOR_I686_DL_URL}
	   ${TRESOR_SYSFS_DL_URL}
	   ${TRESOR_README_DL_URL}
	   ${TRESOR_SRC_URL}
	   ${UKSM_SRC_URL}
	   ${KERNEL_PATCH_URLS[@]}
	   https://github.com/torvalds/linux/commit/2fbd6f94accdbb223acccada68940b50b0c668d9.patch -> linux-kernel-2fbd6f94accdbb223acccada68940b50b0c668d9.patch"

_set_check_reqs_requirements() {
	# for 3.1 kernel
	# source merge alone: 986.2 MiB
	# linux-amd-staging-drm-next local repo: 2002.72 MiB
	# ROCk local repo: 2479.55 MiB
	if is_rock && is_amd_staging_drm_next ; then
		CHECKREQS_DISK_USR="5470M"
	elif is_rock ; then
		CHECKREQS_DISK_USR="3467M"
	elif is_amd_staging_drm_next ; then
		CHECKREQS_DISK_USR="2990M"
	fi
}

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi

	if use tresor ; then
		ewarn "TRESOR is broken for ${PV}.  Use 4.9.x series.  For ebuild devs only."
	fi

	if is_rock ; then
		ewarn "Patching with ROCk is broken.  For ebuild devs only."

		einfo ""
		einfo "You need PCIe 3.0 or a GPU that doesn't require PCIe atomics to use ROCK."
		einfo "See needs_pci_atomics field for your GPU family in"
		einfo "https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/master/drivers/gpu/drm/amd/amdkfd/kfd_device.c"
		einfo "for the exception.  For supported CPUs see"
		einfo "https://rocm.github.io/hardware.html"
	fi

	if ( is_rock || is_amd_staging_drm_next ) ; then
		_set_check_reqs_requirements
		check-reqs_pkg_setup
	fi
}

# @FUNCTION: ot-kernel-common_pkg_pretend_cb
# @DESCRIPTION:
# Does checks and warnings
function ot-kernel-common_pkg_pretend_cb() {
	if ( is_rock || is_amd_staging_drm_next ) ; then
		_set_check_reqs_requirements
		check-reqs_pkg_pretend
	fi
}

# @FUNCTION: ot-kernel-common_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel-common_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-fix-addressing-mode-64-bit-index.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait.patch"
	#fi

	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"
}

# @FUNCTION: ot-kernel-common_uksm_fixes
# @DESCRIPTION:
# Applies specific UKMS fixes for this kernel major version
function ot-kernel-common_uksm_fixes() {
	# the header patches fine with patch -N
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.1-fixes.patch" # for reuse_ksm_page
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.2-fixes.patch" # for mmu_notifier_range_init changes related to 6f4f13e8d9e27cefd2cd88dd4fd80aa6d68b9131 and ksm.c
}

# @FUNCTION: ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1
# @DESCRIPTION:
# Prepends necessary amd-staging-drm-next patches that were missing in the range
#function ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches1() {
#	#_get_amd_staging_drm_next_commit 1 94a4ffd1d40b845dd19f9fdbb2cb6bf32de0946b # 2018-08-27 drm/amd/display: fix PIP bugs on Dal3
#	_get_amd_staging_drm_next_commit 1 5eb8c8c5871fa6f10236ecd67005bb0659c15d11 # 2019-02-19 drm/amdgpu: replace get_user_pages with HMM mirror helpers
#	_get_amd_staging_drm_next_commit 2 6b8f7e3dee7883084932bbdfce471a2960c6db5d # 2019-03-19 drm/amdgpu: fix HMM config dependency issue
#	#_get_amd_staging_drm_next_commit 3 3e70b04ab7874670e65c688f89ce210a6a482de6 # 2019-02-19 drm/amdgpu: use HMM callback to replace mmu notifier # already pulled later
#	#_get_amd_staging_drm_next_commit 3 02205685e319bf6507feb95b1ee2ce3fb51fa60d # 2019-02-20 drm/amd/display: PPLIB Hookup # already applied
#	_get_amd_staging_drm_next_commit 4 1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b # 2019-02-19 drm/amdkfd: avoid HMM change cause circular lock
#	_get_amd_staging_drm_next_commit 5 e8074f75f4449b9f9315f3a81d5d72425fba0a8c # 2019-03-14 drm/v3d: Fix calling drm_sched_resubmit_jobs for same sched.
#	true
#}

# @FUNCTION: ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches_num1
# @DESCRIPTION:
# Reports the next commit number for the corresponding code block above
#function ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches_num1() {
#	echo "6"
#}

# @FUNCTION: ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2
# @DESCRIPTION:
# Fixes patches that have missing files
function ot-kernel-common_fetch_amd_staging_drm_next_commits_extra_patches2() {
	# ignore missing commit
	# ffae3e 2019-05-24 drm/scheduler: rework job destruction
#	local idx=$(get_patch_index "amd-staging-drm-next-patches" "ffae3e510d66ba854289f2cdff8a119ecd7f4ded")
#	printf -v pidx "%06d" ${idx}
#	[ ! -e "${T}"/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch ] && die "can't find"
#	filterdiff -x */lima_sched.c "${T}"/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch > "${T}"/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch.1 || die
#	mv "${T}"/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch{.1,} || die
	true
}

# @FUNCTION: ot-kernel-common_apply_genpatch_extras_patchset
# @DESCRIPTION:
# Apply genpatches extra patches
function ot-kernel-common_apply_genpatch_extras_patchset() {
	_tpatch "${PATCH_OPS} -N" "$d/4567_distro-Gentoo-Kconfig.patch"
}


# @FUNCTION: ot-kernel-common_apply_o3_fixes
# @DESCRIPTION:
# Apply fixes to O3
function ot-kernel-common_apply_o3_fixes() {
	einfo "Applying fix for ${O3_CO_FN}"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/O3-config-option-a56a17374772a48a60057447dc4f1b4ec62697fb-fix-for-5.1.patch"
}

# @FUNCTION: ot-kernel-common_fetch_rock_commits_patchset1
# @DESCRIPTION:
# Prepend ROCk commits
#function ot-kernel-common_fetch_rock_commits_patchset1() {
#	prepend_rock_commit "bf96e47b4474f992095d9fae9ccfc46633bf4343" "9c75d5a887d1d5f5815019c105e2ea25a2c9c823" "a" "" "b"
	# bf96e drm/amdgpu: Bring back support for non-upstream FreeSync
	# 9c75d  drm/amdkcl: [4.12] Kcl for drm old/new state iterator and get_old/new/_crtc_state before sw commit

	#prepend_rock_commit "bf96e47b4474f992095d9fae9ccfc46633bf4343" "f331d74dad4358369a6dfb182ff0a5607a8e7b04" "a" "" "b"
	## bf96e drm/amdgpu: Bring back support for non-upstream FreeSync
	## f331d drm/amdgpu: [hybrid] add direct gma(dgma) support
#}

# @FUNCTION: ot-kernel-common_apply_amdgpu_rock_fixes
# @DESCRIPTION:
# Apply ROCk fixes
function ot-kernel-common_apply_amdgpu_rock_fixes() {
	# patches will be appended with x and y.
	# x means amd-staging-drm-next
	# y means rock
	# xy meand both amd-staging-drm-next- and rock- USE flags are activated
	# this system will try to manage the 3 possibilities and independendent.

	# rebasing ROCk will try to do the following
	# 1. eliminate unnessary patchwork
	# 2. the final copy will be used instead of the intermediate change
	# 3. no adding intermediate additions/lines that never made it as the final copy
	# 4. cosmetic changes will rejected
	# 5. renames of variables will be rejected if not the final version

	if is_rock && is_amd_staging_drm_next ; then
		einfo "fixme"
		cd "${S}"
		_dpatch "-p1 -R" "${DISTDIR}/linux-kernel-2fbd6f94accdbb223acccada68940b50b0c668d9.patch"
		L=$(ls -1 "${T}"/rock-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/rock-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*6ec0b971827f8146631dbe7f57ab78786ea6506e*)
						# Already applied
						;;
					*c5bc6042ffb8106680d17e2d0e86130e0111906c*|\
					*077c20b1280db05048733bb3076ffb5403b4b4f7*)
						# not required; obsolete
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*6ec0b971827f8146631dbe7f57ab78786ea6506e*)
						# Already applied
						;;
					*c5bc6042ffb8106680d17e2d0e86130e0111906c*|\
					*077c20b1280db05048733bb3076ffb5403b4b4f7*)
						# not required; obsolete
						;;
					*6999fd9f149e16ffcad6941e317def9ec32bd64c*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-6999fd9f149e16ffcad6941e317def9ec32bd64c-fix-for-linux-5.3.1-xy.patch"
						;;
					*1254b5fe6aaabb58300a5929b6bb290bf1c49f63*)
						# Low confidence patching marked by x?.  They may cause runtime/compile time breakage or not match up with final version matching ROCK-Kernel-Driver.
						# They may need to be revisited to match exactly upstream's version of the files.
						# High confidence patching are ones that are very straightforward and easy to patch.
						#
						# x? drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
						# x? drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
						# x? drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-1254b5fe6aaabb58300a5929b6bb290bf1c49f63-fix-for-linux-5.3.2-xy.patch"
						;;
					*4766d6eb3c11d7dffc9e8e34350c5658267b0281*)
						# x? drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-4766d6eb3c11d7dffc9e8e34350c5658267b0281-fix-for-linux-5.3.2-xy.patch"
						;;
					*)
						eerror "Patch failure ${T}/rock-patches/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if is_rock && ! is_amd_staging_drm_next ; then
		cd "${S}"
		L=$(ls -1 "${T}"/rock-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/rock-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*)
						eerror "Patch failure ${T}/rock-patches/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi
}

# @FUNCTION: ot-kernel-common_amdgpu_amd_staging_drm_next_fixes
# @DESCRIPTION:
# Apply amd-staging-drm-next fixes.
function ot-kernel-common_amdgpu_amd_staging_drm_next_fixes() {
	# patches will be appended with x and y.
	# x means amd-staging-drm-next
	# y means rock
	# xy meand both amd-staging-drm-next- and rock- USE flags are activated
	# this system will try to manage the 3 possibilities and independendent.

	if is_amd_staging_drm_next && is_rock ; then
		einfo "fixme"
		fetch_amd_staging_drm_next_commits
		cd "${S}"
		L=$(ls -1 "${T}"/amd-staging-drm-next-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-staging-drm-next-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*)
						eerror "Patch failure ${T}/amd-staging-drm-next-patches/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if is_amd_staging_drm_next && ! is_rock ; then
		fetch_amd_staging_drm_next_commits
		cd "${S}"
		L=$(ls -1 "${T}"/amd-staging-drm-next-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-staging-drm-next-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*4d7fd9e20b0784b07777728316da5bcc13f9f2ab*)
						# already patched
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*b48935b3bfc1350737e759fef5e92db14a2e2fbb*|\
					*4d7fd9e20b0784b07777728316da5bcc13f9f2ab*)
						# already patched
						;;
					*22a8f442866bf539c7a659923155d9afa03d77bb*)
						# readapted patch
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-22a8f442866bf539c7a659923155d9afa03d77bb-fix-for-linux-5.3.1-x.patch"
						;;
					*fcd90fee8ac22da3bce1c6652cf36bc24e7a0749*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-fcd90fee8ac22da3bce1c6652cf36bc24e7a0749-fix-for-linux-5.3.1-x.patch"
						;;
					*)
						eerror "Patch failure ${T}/amd-staging-drm-next-patches/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi
}

# @FUNCTION: ot-kernel-common_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_pkg_postinst_cb() {
	if use muqss ; then
		ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL and"
		ewarn "Idle dynticks system (tickless idle) CONFIG_NO_HZ_IDLE may cause the system to lock up."
		ewarn "You must choose Periodic timer ticks (constant rate, no dynticks) CONFIG_HZ_PERIODIC for it not to lock up."
		ewarn "The MuQSS scheduler may have random system hard pauses for few seconds to around a minute when resource usage is high."
	fi

	if use bmq ; then
		ewarn "Using bmq with lots of resources may leave zombie processes, or high CPU processes/threads with little processing."
		ewarn "This might result in a denial of service that may require rebooting."
	fi

	if is_rock ; then
		einfo "You must enable HSA kernel driver for AMD GPU devices (CONFIG_HSA_AMD=y) to use ROCM and add your users to the video group."
	fi
}
