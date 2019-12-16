#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-rock.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel with ROCk
# @DESCRIPTION:
# The ot-kernel-rock eclass will patch vanilla sources with ROCk kernel driver

# ROCK-Kernel-Driver:
#   https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/

HOMEPAGE+=" https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"

# The amdgpu-19_30 USE flag will simulate the production of the same source as
# amdgpu-dkms without dkms matching the same DC_VER and last ROCk commit found

# Clarifications about the sources
# The amdgpu-dkms driver is basically
#     https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-19.30
#   It is a bit older than the ROCk-kernel-driver.  ROCk for 19.30 is
#   around ROCk 2.7.0 + newer commits
# The ROCk kernel driver is the rock-dkms package found in
#   http://repo.radeon.com/rocm/apt/debian/pool/main/r/
#     and explained in
#   https://rocm-documentation.readthedocs.io/en/latest/InstallGuide.html#add-the-rocm-apt-repository
# The amd-staging-drm-next
#   https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next
#   is basically bleeding edge amdgpu drm driver with older kernel, newer DRM api.
# This module will try to merge both amd-staging-drm-next and the
#   ROCk kernel driver, which was done in amdgpu-dkms, and apply it to the
#   current stable.

# kernel versions of each amdgpu DRM driver.
# amd-19.30 is v5.0-rc1 kernel
# ROCk kernel driver is v5.0-rc1
# amd-staging-drm-next is 5.3-rc3, with 5.4 DRM API

# ROCK-Kernel-Driver should be used as reference compared to the older
# amd-19.30's ROCk based on:
# "drm/amdkfd: remove duplicated PCIE atomics request"
#   ( 2764662c71945662967c3824d752574c920db594 )

# This module tries to rebase to v5.3 final stable which should resemble
# amd-19.30 with 5.3 (final) compatibility patches with some 5.4 DRM API
# updates making sure other vendors DRM drivers don't break

# ROCk will add around 166 commits without kcl/dkms from all the commit-dedupes
# from vanilla kernel and amd-staging-drm-next

ROCK_DIR="ROCK-Kernel-Driver"
# ROCK_BASE should match ${PV}'s DC_VER

# ROCK_BASE starts at the first commit in ROCK-Kernel-Driver by either these
# keywords:

# drm/amdgpu: [hybrid]
# drm/amdkcl
# drm/amdkfd
# HMM

# If we pull just this,
#   ROCK_BASE="5f62954ac3050cbda03fa70b3cb67b92488e0c65"
#     # 2019-04-08 drm/amd/display: 3.2.35 ,
# many commits are still missing.

# Rechange base
# Commit date: Oct 10, 2015
# Commit hash: 61cc8365b3cc4c549dbddd5d1576e6cf499bbef7
# Subject:: drm/amdgpu: [hybrid] add query for aperture va range

# commit below pulls additional commits further back that 3.2.35 depends on
# that were missing:
# ROCK_BASE="61cc8365b3cc4c549dbddd5d1576e6cf499bbef7"
#   drm/amdgpu: [hybrid] add query for aperture va range

# 61cc8365b3cc4c549dbddd5d1576e6cf499bbef7 depends on
# ca3324ff2f43c67cc100e67332589b054d97b774

# Rechange base
# Pull the first ROCk commit referencing amdkfd
# Commit date: Jul 15, 2014
# Commit hash: e28740ece34d314002b1ddfa14e8fb7c7b909489
# Subject: drm/radeon: Add radeon <--> amdkfd interface

ROCK_BASE="e28740ece34d314002b1ddfa14e8fb7c7b909489"

if [[ "${K_MAJOR_MINOR}" == "5.3" ]] ; then
ROCK_SNAPSHOT="38d5546b8cd23bc4e265c4ec430f019de620eaf7" # merged in past
#ROCK_SNAPSHOT="217c2b3894e783d7e1751e4caa9dabc25977c27d"
fi
ROCK_LATEST="217c2b3894e783d7e1751e4caa9dabc25977c27d"
ROCK_2_9_0="217c2b3894e783d7e1751e4caa9dabc25977c27d" # KV is 5.0-rc1
ROCK_2_8_0="89baa3f89c8cb0d76e999c01bf304301e35abc9b" # KV is 5.0-rc1
ROCK_2_7_0="38d5546b8cd23bc4e265c4ec430f019de620eaf7" # KV is 5.0-rc1
ROCK_1_9_2="348f05754dda33523a8e5168f7df2fc9eee125b0" # KV is 4.15
ROCK_1_8_3="ca2a6a781973e82ca2c7be8e4fdf7c880f60cb8d" # KV is 4.13
ROCK_HEAD="master"

# The intersection is defined to be the newer commit of rock_xxxx that
# intersects amd-staging-drm-next

# The intersection is not in perfect sync or easy to determine.  We will get
# the bulk of the amd-staging-drm-next and worry about the corner case which is
# the intersection.

# The deviation from the intersection could be months.

# The ROCk patches get applied first, then the amd-staging-drm-next patches
# follow after.

# The AMD_STAGING_*_INTERSECS_ROCK_* and the AMD_STAGING_INTERSECTS_KV
# constants marks the starting point of the amd-staging-drm-next patching.
# Scan the git history logs:
#   https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/commits/master/
# of the drivers/gpu/drm/amd folder and:
#   https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next
# starting from ROCK-Kernel-Driver's
# "drm/amd/display: 3.2.35" [same as min common DC_VER for
#   amd-staging-drm-next (3.2.51.1)
#   [corresponding to AMD_STAGING_DRM_NEXT_LATEST]
#     and
#   ROCK-Kernel-Driver (3.2.35)
#   [corresponding to DC_VER]]
# till you find the recent most last sequential commits.
# You may need to go back a few DC_VER before 3.2.27 to pull missing commits
# between 3.2.35 and >3.2.3x.  Get the commit hash from amd-staging-drm-next.
# A 2019-06-11 drm/amdgpu: Add CHIP_VEGAM to amdgpu_amdkfd_device_probe

# Scan the git history logs
#   https://github.com/torvalds/linux/commits/v5.3/
#     and
#   https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next
# of the folder drivers/gpu/drm/amd starting from linus' tag of v5.3 for
# "drm/amd/display: 3.2.35" [which is the same as the kernel's DC_VER]
# till you find the last sequential commits before 3.2.36.  Get the commit hash
# from amd-staging-drm-next.
# You should see the drm-next- tags progressing towards the latest drm-next.
# drm-next-5.3, drm-next-5.3-2019-*, and drm-fixes-5.2 tags were present.
# B 2019-07-18 drm/amd/display: handle active dongle port type is DP++ or
#   DP case

# The rock- USE flag will try to simulate a copy and feature set of
# amdgpu-dkms driver


# @FUNCTION: rock_setup
# @DESCRIPTION:
# Does pre-emerge checks
function rock_setup() {
	if use rock ; then
		if [[ -z "${ROCK_BUMP_REQUEST}" ]] ; then
			local m=\
"You must define a ROCK_BUMP_REQUEST environmental variable in make.conf or\n\
per-package env containing either: latest, head, snapshot\n"
			if [[ "${K_MAJOR_MINOR}" == "5.3" ]] ; then
				m+=", snapshot"
			fi

			if ver_test ${K_MAJOR_MINOR} -ge 5.0 \
				&& ver_test ${K_MAJOR_MINOR} -le 5.3 ; then
				m+=", 2_9_0, 2_8_0, 2_7_0"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.15 \
				&& ver_test ${K_MAJOR_MINOR} -lt 5.0 ; then
				m+=", 1_9_2"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.13 \
				&& ver_test ${K_MAJOR_MINOR} -lt 4.15 ; then
				m+=", 1_8_3"
			else
				ewarn \
			     "Your kernel version may not be supported by rock."
			fi
			die "${m}"
		fi
		case ${ROCK_BUMP_REQUEST} in
			head|snapshot|latest|2_9_0|2_8_0|2_7_0|1_9_2|\
			1_8_3)
				;;
			*)
				die "Invalid ROCK_BUMP_REQUEST value"
				;;
		esac
		cd_rock
		git config diff.renamelimit 2936 # recommended by output
		chown portage:portage .git/config || die
	fi
}

# @FUNCTION: fetch_rock_local_copy
# @DESCRIPTION:
# Clones or updates the ROCk repository.  ROCk patches contain
# additional multi GPU features and optimizations if apps support it.
function fetch_rock_local_copy() {
	einfo "Fetching the ROCk project please wait.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}" || die
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}" || die
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning the ROCk project"
		git clone "${ROCKREPO_URL}" "${d}"
		cd "${d}" || die
		git checkout master
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die \
	"You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the ROCk project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
	fi
	cd "${d}" || die
}

# @FUNCTION: rock_rm_cached
# @DESCRIPTION:
# Removes a commit from the patch folder
function rock_rm() {
	local c="${1}"
	rm "${ROCK_T_CACHE}"/*${c}*
}

# @FUNCTION: rock_rm_list
# @DESCRIPTION:
# Removes a list of commits
function rock_rm_list() {
	for l in $@ ; do
		rock_rm ${l}
	done
}

# @FUNCTION: rock_set_target
# @DESCRIPTION:
# Obtains the commit hash based on ROCK_BUMP_REQUEST.
function rock_set_target() {
	local target
	if [[ "${ROCK_BUMP_REQUEST}" =~ snapshot ]] ; then
		target="${ROCK_SNAPSHOT}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ head ]] ; then
		target="${ROCK_HEAD}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ latest ]] ; then
		target="${ROCK_LATEST}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ 2_9_0 ]] ; then
		target="${ROCK_2_9_0}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ 2_8_0 ]] ; then
		target="${ROCK_2_8_0}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ 2_7_0 ]] ; then
		# KV is 5.0-rc1
		target="${ROCK_2_7_0}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ 1_9_2 ]] ; then
		# KV is 4.15
		target="${ROCK_1_9_2}"
	elif [[ "${ROCK_BUMP_REQUEST}" =~ 1_8_3 ]] ; then
		# KV is 4.13
		target="${ROCK_1_8_3}"
	fi
	echo "${target}"
}

# @FUNCTION: rock_save_all_commits
# @DESCRIPTION:
# Saves all ROCk commits as patch files
function rock_save_all_commits() {
	einfo "Saving all ROCk commits as patches from scratch"
	cd_rock
	for c in $C ; do
		local fn="${c}.patch"
		if git -P diff $c^..$c > "${ROCK_T_CACHE}"/${fn} ; then
			#einfo "Added ${fn}"
			# attach missing commit subject for a possible patch
			# tarball
			git -P show -s --pretty=email ${c} \
				> "${ROCK_T_CACHE}/${fn}.t" || die
			cat "${ROCK_T_CACHE}/${fn}" \
				>> "${ROCK_T_CACHE}/${fn}.t" || die
			mv "${ROCK_T_CACHE}/${fn}"{.t,} || die
		else
			die "Failed to add ${fn}"
		fi
	done
}

# @FUNCTION: rock_prepend_licenses_in_patches
# @DESCRIPTION:
# Adds licenses to top of patches.
function rock_prepend_licenses_in_patches() {
	if [[ -n "${USE_PATACHIE}" && "${USE_PATACHIE}" == "1" ]] ; then
		einfo "Attaching licenses to ROCk patches"
		"${HOME}/patachie" -p "${ROCK_T_CACHE}" \
			-s "${S}" \
			-of "${T}/rock-licenses" \
			-od "${T}/rock-processed"
		mv "$(pwd)/attachied" "$(pwd)/rock-attachied" || die
		einfo \
"Maintainer:  $(pwd)/rock-processed contains patches with attached licenses\n\
and ${T}/rock-licenses contains all the licenses in one file."
	fi
}

# @FUNCTION: __remove_rock_patch
# @DESCRIPTION:
# (PRIVATE) Removes a ROCk .patch file
function __remove_rock_patch() {
	rm "${ROCK_T_CACHE}"/*${c}* > /dev/null
}

# @FUNCTION: rock_filter_by_git_commit_metadata
# @DESCRIPTION:
# Removes patches before merging
function rock_filter_by_git_commit_metadata() {
	local finished=0
	for c in $C ; do
		#einfo "Processing ${c}"

		local fn=""
		if [[ -n "${vk_commits[${c}]}" ]] ; then
			#einfo \
#"Already added ${c} via vanilla kernel sources.  Skipping..."
			__remove_rock_patch
			continue
		elif [[ -n "${asdn_commits[${c}]}" ]] ; then
			#einfo \
#"Already added ${c} via amd-staging-drm-next.  Skipping..."
			__remove_rock_patch
			continue
		fi

		local s="${rock_summary_raw[${c}]}"

		if echo "${s}" | grep -q -P \
-e "(drm/admkcl|drm/amdkcl|dkms|autoconf)" ; then
			# reject compatibility layer and dkms
			# only interested in enhancement commits
			__remove_rock_patch
			continue
		fi

		# remove some reversions or commits found in vanilla or
		#   those with .*\(v[0-9]\) subject pattern.
		# some reverts are required if their anti is not found
		#   in torvald's kernel
		if echo "${s}" | grep -q -F \
-e "drm/amd/display: Rework DC plane filling and surface updates" ; \
		then
			# rework already applied in vanilla
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amd/display: Recalculate pitch when buffers change" ; \
		then
			# same content different location
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdkfd: Separate mqd allocation and initialization" ; \
		then
			# fixed by
			#   06b89b38f3cc518a761164f9f958a9607bbb3587
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdkfd: Refactor create_queue_nocpsch" ; \
		then
			# fixed by
			#   06b89b38f3cc518a761164f9f958a9607bbb3587
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdkfd: Only load sdma mqd when queue is active" ; \
		then
			# same content pre and post revert
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amd/display: fix issue with eDP not detected on driver load" ; \
		then
			# same content pre and post revert
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdgpu: re-enable retry faults" ; \
		then
			# obsolete
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdkfd: Add navi10 support to amdkfd" ; \
		then
			# obsolete ; vanilla is version 3, ROCk is version 2
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdgpu: Add navi10 kfd support for amdgpu" ; \
		then
			# already added by vanilla
			__remove_rock_patch
			continue
		elif echo "${s}" | grep -q -F \
-e "drm/amdgpu: Move KFD parameters to amdgpu" ; \
		then
			# already added by vanilla
			__remove_rock_patch
			continue
		fi

		local h_summary="${rock_summary_hash[${c}]}"

		if [[ \
		"${c}" =~ 0dbd555a011c2d096a7b7e40c83c5776a7df367c || \
		"${c}" =~ 1e053b10ba60eae6a3f9de64cbc74bdf6cb0e715 || \
		"${c}" =~ e532a135d7044b5477c1c56169fa131d77c57f75 || \
		"${c}" =~ 52791eeec1d9f4a7e7fe08aaba0b1553149d93bc || \
		"${c}" =~ bd630a86be381992fac99f9ab82c5c5b43a5ee3b || \
		"${c}" =~ 67c97fb79a7f8621d4514275691d75f5ff158c46 || \
		"${c}" =~ 4c2488cfaa997e396aeb9d6496db94c25b97c671 || \
		"${c}" =~ dd7a7d1ff2f199a8a80ee233480922d4f17adc6d || \
		"${c}" =~ 31070a871fdcb16dd209e6bc0e6ca16be7cfb938 || \
		"${c}" =~ 96e95496b02dbf1b19a2d4ce238810572e149606 || \
		"${c}" =~ 94eb1e10a34d3c7fc42208faaa4954fe482ac091 || \
		"${c}" =~ 8735f16803f00f5efca7738afe3b9a304b539181 || \
		"${c}" =~ 5d344f58da760b226562e7d5199fb73294eb93fa || \
		"${c}" =~ 93505ee7d05e836fd18894019e93c3875198fcc5 || \
		"${c}" =~ 0e1d8083bddb38b7169f6240905422f95d3c31b9 || \
		"${c}" =~ 4f5368b5541a902f6596558b05f5c21a9770dd32 || \
		"${c}" =~ b016cd6ed4b772759804e0d6082bd1f5ca63b8ee || \
		"${c}" =~ 51c98747113e93b6229f12d1a744a51fd59eff3a || \
		"${c}" =~ 8eb8833e7ed362977c021116d2f34451a7009ca3 || \
		"${c}" =~ 100163df420305b78153e6f5ec10c90d755acee3 || \
		"${c}" =~ e1a29c6c59553d80a8e17d63494c65a13fb8e241 || \
		"${c}" =~ d8f4981e2e8a968411105db568f3d48256b2ebbc || \
		"${c}" =~ 274840e544225657fbca4f12efa1ee55474bb800 || \
		"${c}" =~ c01b6a1d38675652199d12b898c1c23b96b5055f || \
		"${c}" =~ 354e6e14ef947f07055d3570b4bd7a33196b57f6 || \
		"${c}" =~ 562836a269e363cdb74b551e3be7021c9d228378 || \
		"${c}" =~ e7f0141a217fa28049d7a3bbc09bee9642c47687 || \
		"${c}" =~ 2e3c9ec4d151c04d75546dfdc2f85a84ad546eb0 || \
		"${c}" =~ c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0 || \
		"${c}" =~ 97797a93ffb905304df11dc42e1daab9aa7faa9b || \
		"${c}" =~ 2a1e00c3c0d37f65241236d7731ef6bb92f0d07f \
			]] ; then
			# ASDN set (already included)
			__remove_rock_patch
			continue
		elif [[	\
		"${c}" =~ 4766d6eb3c11d7dffc9e8e34350c5658267b0281 || \
		"${c}" =~ add4edf21054c25915bf43096d5a6dd046df3f1d || \
		"${c}" =~ 3f1e5c3eeec3a5aff5ddbd46ff07fe580e4bee58 || \
		"${c}" =~ 4b59cd9a98043f3b6e2ccf4d1270b7219aa437c9 \
			]] ; then
			# ROCk whitelist
			# whitelist specific commits which includes
			#   5.4-rc* commits
			continue
		elif echo "${s}" | grep -q -P \
-e "(drm/amd|amdgpu|amd/powerplay|amdkfd|gpu: amdgpu:|amdgpu_dm)" ; then
			# whitelist all amd drm driver updates for
			#   evaluation
			# the ROCk kernel modifications don't explicitly
			#   say ROCk addition but get mixed with these
			#   subject tags
			:; # still filter it though
		elif echo "${s}" | grep -q -P \
-e "(bo->resv to bo->base.resv|use embedded gem object|Fill out gem_object->resv)" ; \
		then
			# ASDN set (already included)
			continue
		else
			# don't filter ROCk by timestamp because it dates back
			#   since 2014
			# don't filter ASDN by timestamp because upstream may
			#   not accept all commits
			local ct="${rock_commit_time[${c}]}"
			if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
				#einfo "Skipping old commit ${c} :  Old timestamp"
				__remove_rock_patch
				continue
			fi
		fi

		if [[ -n "${vk_summaries[${h_summary}]}" ]] ; then
			#einfo \
#"Already added ${c} via vanilla kernel sources (with same subject match).  \
#Skipping..."
			__remove_rock_patch
			continue
		fi

		if use amd-staging-drm-next ; then
			if [[ -n "${asdn_summaries[${h_summary}]}" ]] ; then
				#einfo \
#"Already added ${c} via amd-staging-drm-next kernel sources (with same subject \
#match).  Skipping..."
				__remove_rock_patch
				continue
			fi
		fi

		# deferred to the end to check whitelist
		if [[ "${finished}" == "1" ]] ; then
			#einfo \
#"Deleting the rest of commits."
			__remove_rock_patch
			continue
		elif [[ ${c} == "${target}" ]] ; then
			#einfo "Last commit ${c} encountered"
			finished=1
		fi
	done
}

# @FUNCTION: rock_generate_commit_list
# @DESCRIPTION:
# Fills a variable named C containing all ROCk commits
#
# C, the ROCk commit list, is consumed by:
# rock_generate_database
# rock_save_all_commits
# rock_filter_by_git_commit_metadata
function rock_generate_commit_list() {
	cd_rock
	einfo \
"Saving only the ROCk commits for commit-by-commit evaluation.  This will\n\
take longer than expected."
	C=$(git -P log ${ROCK_BASE}..${target} --oneline \
		--pretty=format:"%H" -- \
		drivers/gpu/drm \
		include/drm \
		drivers/dma-buf \
		include/linux \
		include/uapi/drm \
		| echo -e "\n$(cat -)" | tac)

	# amd-staging-drm-next-stable is currently not used, may be
	# changed to only 5.3 only without 5.4 commits.

	# C+=$'\n'"add4edf21054c25915bf43096d5a6dd046df3f1d"

	#if [[ "${target}" == "${ROCK_2_7_0}" ]] ; then
	#	# referenced in ad91b134a2e6e18f4c7ea32043f96e46a569ae43 in ${ROCK_2_7_0} but not tagged in ${ROCK_2_7_0}
	#	C+=$'\n'"3f1e5c3eeec3a5aff5ddbd46ff07fe580e4bee58"
	#fi

	pickle_string "C" "${T}/rock_commit_list.${K_MAJOR_MINOR}${SUFFIX_ASDN}"
}

# @FUNCTION: cd_rock
# @DESCRIPTION:
# Changes directory to ROCk repo
function cd_rock() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	cd "${d}" || die
}

# @FUNCTION: rock_generate_database
# @DESCRIPTION:
# Generates database files so that dependence on git will
# be removed.
#
# Preconditions: rock_summary_raw, rock_summary_hash,
# rock_commit_time must be declared associative
# arrays first
function rock_generate_database() {
	cd_rock
	local n="1"
	for c in $C ; do
		local s=$(git -P show -s --format="%s" ${c})
		local ct=$(git -P show -s --format="%ct" ${c})
		local h_summary=$(\
			echo "${s}" | sha1sum | cut -f1 -d ' ')

		# 1506464219 is Aug 19, 2017 for 7fb77c51f3b8e91499b6fd1973804c9230d2d8d3
		# for the first appearance of the DC_VER constant.
		# the git command below is very time expensive and a bottleneck.
		if (( ${ct} >= 1506464219 )) ; then
			DC_VER=$(git -P show \
				${c}:drivers/gpu/drm/amd/display/dc/dc.h 2>/dev/null \
				| grep -F -e "#define DC_VER" \
				| grep -o -P -e "\"[0-9.]+\"" \
				| sed -e "s|\"||g")

			# repad DC_VER
			DC_VER_MAJOR=$(printf "%02d" $(echo "$DC_VER" | cut -f1 -d '.'))
			DC_VER_MINOR=$(printf "%02d" $(echo "$DC_VER" | cut -f2 -d '.'))
			DC_VER_PATCH=$(printf "%03d" $(echo "$DC_VER" | cut -f3 -d '.' | sed -e "s|^0*||"))
			DC_VER="${DC_VER_MAJOR}.${DC_VER_MINOR}.${DC_VER_PATCH}"
		else
			DC_VER="00.00.000"
		fi

		printf -v pn "%06d" ${n}

		rock_summary_raw[${c}]="${s}"
		rock_summary_hash[${c}]="${h_summary}"
		rock_commit_time[${c}]=${ct}
		rock_dc_ver[${c}]="${DC_VER}"
		rock_pn[${c}]=${pn}
		n=$((n+1))
	done
	pickle_associative_array "rock_summary_raw" \
		"${T}/${ROCK_DB_SUMMARY_RAW_FN}"
	pickle_associative_array "rock_summary_hash" \
		"${T}/${ROCK_DB_SUMMARY_HASH_FN}"
	pickle_associative_array "rock_commit_time" \
		"${T}/${ROCK_DB_COMMIT_TIME_FN}"
	pickle_associative_array "rock_dc_ver" \
		"${T}/${ROCK_DB_DC_VER_FN}"
	pickle_associative_array "rock_pn" \
		"${T}/${ROCK_DB_PN_FN}"
}

# @FUNCTION: has_rock_database
# @DESCRIPTION:
# Checks for the existance of the ROCk databases
function has_rock_database() {
	if [[ -e "${FILESDIR}/${ROCK_DB_SUMMARY_RAW_FN}" \
		&& -e "${FILESDIR}/${ROCK_DB_SUMMARY_HASH_FN}" \
		&& -e "${FILESDIR}/${ROCK_DB_COMMIT_TIME_FN}" \
		&& -e "${FILESDIR}/${ROCK_DB_DC_VER_FN}" \
		&& -e "${FILESDIR}/${ROCK_DB_PN_FN}"  ]]
	then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: rock_use_commit_list
# @DESCRIPTION:
# Generates or uses a ROCk commit list
function rock_use_commit_list() {
	if has_rock_database ; then
		einfo "Using the ROCk commit list"
		source "${FILESDIR}/rock_commit_list.${K_MAJOR_MINOR}${SUFFIX_ROCK}"
	else
		einfo "Generating ROCk commit list"
		rock_generate_commit_list
	fi
}

# @FUNCTION: rock_use_database
# @DESCRIPTION:
# Loads the ROCk databases
function rock_use_database() {
	if has_rock_database ; then
		einfo "Using the ROCk database"
		cp -a "${FILESDIR}/${ROCK_DB_SUMMARY_RAW_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ROCK_DB_SUMMARY_HASH_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ROCK_DB_COMMIT_TIME_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ROCK_DB_DC_VER_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ROCK_DB_PN_FN}" \
			"${T}" || die
	else
		einfo "Generating the ROCk database"
		rock_generate_database
	fi
	source "${T}/${ROCK_DB_SUMMARY_RAW_FN}"
	source "${T}/${ROCK_DB_SUMMARY_HASH_FN}"
	source "${T}/${ROCK_DB_COMMIT_TIME_FN}"
	source "${T}/${ROCK_DB_DC_VER_FN}"
	source "${T}/${ROCK_DB_PN_FN}"
	# not necessary to generate ${ROCK_BASE} to ${K_MAJOR_MINOR} db and commit lists
	# for both vk_kernel and asdn_.  The timestamp filters will
	# reject them.
}

# @FUNCTION: rock_use_commits
# @DESCRIPTION:
# This will generate or reuse pre-generate patch files from commit hash
function rock_use_commits() {
	if rock_is_cache_usable ; then
		einfo "Using cached commits from ${ROCK_LOCAL_CACHE}"
		# we don't distribute this because it is 4.3G+ starting from July 15, 2014
		mkdir -p "${ROCK_T_CACHE}"
		cp -a "${ROCK_LOCAL_CACHE}"/* \
			"${ROCK_T_CACHE}"/ \
			|| die
	else
		rock_save_all_commits
		rock_prepend_licenses_in_patches
		if [[ -n "${OT_KERNEL_MAINTAINER}" \
			&& "${OT_KERNEL_MAINTAINER}" == "1" ]] ; then
			einfo \
"Copying ROCk patches to ${ROCK_T_CACHE}.bak before they get filtered.\n\
They should be placed in ${ROCK_LOCAL_CACHE} ."
			cp -a "${ROCK_T_CACHE}" \
				"${ROCK_T_CACHE}.bak"
		fi
	fi
}

# @FUNCTION: rock_rename_commits
# @DESCRIPTION:
# This will rename ${c}.patch to fn="${DC_VER}-${ct}-${pn}-${c}-rock.patch" .
# We use ${c}.patch minimize wiping entire set and reloading it on repo server.
# We rename to latter for easy merging between ROCk and ASDN and to separate
# merge ordering (pn aka padded n) if it changed.
function rock_rename_commits() {
	for c in $C ; do
		local DC_VER="${rock_dc_ver[${c}]}"
		local ct=${rock_commit_time[${c}]}
		local pn=${rock_pn[${c}]}
		mv "${ROCK_T_CACHE}/${c}.patch" \
			"${ROCK_T_CACHE}/${DC_VER}-${ct}-${pn}-${c}-rock.patch"
	done
}

# @FUNCTION: generate_rock_patches
# @DESCRIPTION:
# Grabs all the commits and generates .patch files for individual evaluation.
function generate_rock_patches() {
	cd_rock

	local target=$(rock_set_target)

	git checkout ${target} . || die

	mkdir -p "${ROCK_T_CACHE}"

	# It takes a long time to filter through thousands of patches because
	#   it goes back since 2014
	# It's not so problematic with just amd-staging-drm-next use flag alone.
	# It takes 159m (or 2 hours ~40 min) to merge without caches.

	unset rock_summary_raw
	unset rock_summary_hash
	unset rock_commit_time
	unset rock_dc_ver
	unset rock_pn
	unset asdn_commits
	unset asdn_summaries

	# If you see:

	# environment: line 7788: 90489ce18c3a504c781c8cfcec013258c3459328:
	# value too great for base (error token is
	# "90489ce18c3a504c781c8cfcec013258c3459328"),

	# it may be caused by associative array not being declared like below

	declare -Ax rock_summary_raw
	declare -Ax rock_summary_hash
	declare -Ax rock_commit_time
	declare -Ax rock_dc_ver
	declare -Ax rock_pn
	declare -Ax asdn_commits
	declare -Ax asdn_summaries

	amd_staging_drm_next_hash_use_hash_tables

	local C
	einfo "Finding the ROCk commit list"
	rock_use_commit_list
	einfo "Finding the ROCk database"
	rock_use_database
	einfo "Finding all ROCk commits"
	rock_use_commits
	einfo "Renaming all ROCk patch files"
	rock_rename_commits
	einfo "Filtering ROCk commits by git commit metadata"
	rock_filter_by_git_commit_metadata

	if declare -f ot-kernel-rock_generate_rock_patches_post \
		> /dev/null ; then
		ot-kernel-rock_generate_rock_patches_post
	fi

	if declare -f ot-kernel-rock_rm > /dev/null ; then
		# per version removal
		ot-kernel-rock_rm
	fi
}

# @FUNCTION: fetch_rock
# @DESCRIPTION:
# Manages getting a local copy of ROCk project
function fetch_rock() {
	if use rock ; then
		if ! rock_is_cache_usable ; then
			einfo \
"Dump ROCk .patch files to ${ROCK_LOCAL_CACHE}"
			# ebuild maintainer only
			fetch_rock_local_copy
		fi
	fi
}

# @FUNCTION: rock_is_cache_usable
# @DESCRIPTION:
# Checks if we can use the cache
# @RETURNS: 0 - yes we can, 1 - no we can't
function rock_is_cache_usable() {
	if [[ ! -d "${ROCK_LOCAL_CACHE}" ]] ; then
		return 1
	fi
	case ${ROCK_BUMP_REQUEST} in
		head)
			return 1
			;;
		snapshot)
			local target=$(rock_set_target)
			if [[ ! -e "${ROCK_LOCAL_CACHE}/${target}.patch" ]] ; then
				einfo "Could not find ${ROCK_LOCAL_CACHE}/${target}.patch"
				return 1
			fi
			;;
		*)
			;;
	esac
	return 0
}

# @FUNCTION: rock_postinst_msg
# @DESCRIPTION:
# Reports required settings for ROCk
function rock_postinst_msg() {
	einfo
	einfo "The following kernel config flags are required in order to have"
	einfo "a feature complete ROCk build:"
	einfo
	einfo "CONFIG_HSA_AMD=y"
	einfo "CONFIG_DRM_TTM=m"
	einfo "CONFIG_DRM_AMDGPU=m"
	einfo "CONFIG_DRM_SCHED=m"
	einfo "CONFIG_DRM_AMDGPU_CIK=y"
	einfo "CONFIG_DRM_AMDGPU_SI=y"
	einfo "CONFIG_DRM_AMDGPU_USERPTR=y"
	einfo "CONFIG_DRM_AMD_DC=y"
	einfo "CONFIG_DRM_AMD_DC_DCN1_0=y"
	einfo "CONFIG_DRM_AMD_DC_DCN1_01=y"
	einfo "CONFIG_DRM_AMD_DC_DCN2_0=y"
	einfo
	einfo "These were listed in the module only amdgpu-dkms driver, but you"
	einfo "can set them all to y."
	einfo
	einfo
	einfo "Additional config flags may be required:"
	einfo
	einfo "CONFIG_MMU_NOTIFIER=y/m"
	einfo "CONFIG_TRIM_UNUSED_KSYMS=n or unset"
	einfo "CONFIG_DRM_AMD_ACP=y/m"
	einfo "CONFIG_MFD_CORE=y/m"
	einfo
	einfo
	einfo "The following are required for SSG (Solid State Graphics)"
	einfo "enhanced feature support (e.g. direct data transfer SSG VRAM"
	einfo "with DISK transfer bypassing system DRAM):"
	einfo
	einfo "The directgma USE flag"
	einfo "CONFIG_ZONE_DEVICE=y"
	einfo "CONFIG_MEMORY_HOTPLUG=y"
	einfo "CONFIG_MEMORY_HOTREMOVE=y"
	einfo "CONFIG_SPARSEMEM_VMEMMAP=y"
	einfo "CONFIG_ARCH_HAS_PTE_DEVMAP=y"
	einfo
}
