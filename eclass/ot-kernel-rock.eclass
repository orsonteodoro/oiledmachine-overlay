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

# ROCK-Kernel-Driver:		https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/

HOMEPAGE+=" https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
IUSE+=" rock-latest rock-snapshot rock-milestone"
IUSE+=" amd-staging-drm-next-snapshot amd-staging-drm-next-milestone amd-staging-drm-next-latest"

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

REQUIRED_USE+="
	     rock-latest? ( !rock-snapshot !rock-milestone ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )
	     rock-snapshot? ( !rock-latest !rock-milestone ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )
	     rock-milestone? ( !rock-latest !rock-snapshot ^^ ( amd-staging-drm-next-snapshot amd-staging-drm-next-latest amd-staging-drm-next-milestone ) )"

DEPEND+=" rock-latest? ( dev-vcs/git )
	  rock-snapshot? ( dev-vcs/git )
	  rock-milestone? ( dev-vcs/git )
	  dev-util/patchutils"

LINUX_COMMITS_ROCK_RANGE_FN="${LINUX_COMMITS_ROCK_RANGE_FN:=linux.commits.rock_range.${K_MAJOR_MINOR}}"

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

# @FUNCTION: get_linux_commit_list_for_rock_range
# @DESCRIPTION:
# Gets the list of ROCk commits between ROCK_BASE and v${K_MAJOR_MINOR}
function get_linux_commit_list_for_rock_range() {
	if use rock-snapshot || use rock-milestone ; then
		if [[ -e "${FILESDIR}/${LINUX_COMMITS_ROCK_RANGE_FN}" ]] ; then
			cp -a "${FILESDIR}/${LINUX_COMMITS_ROCK_RANGE_FN}" "${T}"
			return
		fi
	fi

	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	cd "${d}"
	einfo "Grabbing list of already merged ROCk commits in v${K_MAJOR_MINOR}."
	L=$(git log ${ROCK_BASE}..v${K_MAJOR_MINOR} --oneline --pretty=format:"%H%x07%s%x07%ce" | grep -e "@amd.com" | \
			cut -f1 -d$'\007' | tac)

	cat /dev/null > "${T}/${LINUX_COMMITS_ROCK_RANGE_FN}"
	for l in $L ; do
		echo "${l}" >> "${T}/${LINUX_COMMITS_ROCK_RANGE_FN}"
	done
}

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

	if declare -f ot-kernel-common_fetch_rock_commits_pre > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_pre
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

	if declare -f ot-kernel-common_fetch_rock_commits_post > /dev/null ; then
		ot-kernel-common_fetch_rock_commits_post
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

# @FUNCTION: fetch_rock_main
# @DESCRIPTION:
# Manages getting rock commits
fetch_rock_main() {
	if is_rock ; then
		fetch_rock

		get_linux_commit_list_for_rock_range

		get_missing_rock_commits_list
		get_missing_rock_commits
	fi
}
