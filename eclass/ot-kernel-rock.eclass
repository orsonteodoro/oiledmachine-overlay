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

# The AMD_STAGING_*_INTERSECS_ROCK_* and the AMD_STAGING_INTERSECTS_KV constants marks the starting point of the amd-staging-drm-next patching.
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

# @FUNCTION: fetch_rock_local_copy
# @DESCRIPTION:
# Clones or updates the ROCk repository.  ROCk patches contain
# additional multi GPU features and optimizations if apps support it.
function fetch_rock_local_copy() {
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

# @FUNCTION: generate_rock_patches
# @DESCRIPTION:
# Grabs all the commits and generates .patch files for individual evaluation.
function generate_rock_patches() {
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

	# It takes a long time to filter through thousands of patches because it goes back since 2014
	# It's not so problematic with just amd-staging-drm-next use flag alone.

	einfo "Saving only the ROCk commits for commit-by-commit evaluation.  This will take a longer than expected."
	C=$(git -P log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H" -- \
		drivers/gpu/drm include/drm drivers/dma-buf include/linux include/uapi/drm \
		| echo -e "\n$(cat -)" | tac)
	mkdir -p "${T}/rock-patches"

	n="1"

	if declare -f ot-kernel-rock_generate_rock_patches_pre > /dev/null ; then
		ot-kernel-rock_generate_rock_patches_pre
	fi

if false; then
	einfo "Generating hash tables"
	unset vk_commits
	declare -A vk_commits
	while read -r h ; do
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			vk_commits[${h}]=1
		fi
	done < "${T}/${LINUX_COMMITS_AMDGPU_RANGE_FN}"

	unset vk_summaries
	declare -A vk_summaries
	OIFS="${IFS}"
	IFS=$'\n'
	L=$(git -P log ${ROCK_BASE}..${target} --pretty=format:"%s")
	for l in ${L} ; do
		local h=$(echo "${l}" | sha1sum | cut -f1 -d" ")
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			vk_summaries[${h}]=1
		fi
	done
	IFS="${OIFS}"

	unset asdn_commits
	declare -A asdn_commits
	for f in $(find "${T}"/amdgpu-merged-patches/ -name "*asdn*") ; do
		local h=$(basename $f | cut -f4 -d'-')
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			asdn_commits[${h}]=1
		fi
	done

	local asdn_target
	local asdn_base

	if use amd-staging-drm-next-snapshot ; then
		asdn_target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		asdn_target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		asdn_target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	fi
	asdn_base="${AMD_STAGING_INTERSECTS_KV}"

	pushd "${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}" || die
	unset asdn_summaries
	declare -A asdn_summaries
	OIFS="${IFS}"
	IFS=$'\n'
	L=$(git -P log ${asdn_base}..${asdn_target} --pretty=format:"%s" -- \
		drivers/gpu/drm include/drm drivers/dma-buf include/linux include/uapi/drm )
	for l in ${L} ; do
		local h=$(echo "${l}" | sha1sum | cut -f1 -d" ")
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			asdn_summaries[${h}]=1
		fi
	done
	IFS="${OIFS}"
	popd
fi

	einfo "Doing commit -> .patch conversion for rock-patches set:"
	for c in $C ; do
		if [[ -n "${vk_commits[${c}]}" ]] ; then
			#einfo "Already added ${c} via vanilla kernel sources.  Skipping..."
			continue
		elif [[ -n "${asdn_commits[${c}]}" ]] ; then
			#einfo "Already added ${c} via amd-staging-drm-next.  Skipping..."
			continue
		fi

		local ct=$(git -P show -s --format=%ct ${c})
		OIFS="${IFS}"
		IFS=$'\n'
		local s=$(git -P show -s --format=%s ${c})
		local h_summary=$(echo "${s}" | sha1sum | cut -f1 -d" ")
		IFS="${OIFS}"

		if echo "${s}" | grep -q -P -e "(drm/amd|amdgpu|amd/powerplay|amdkfd|gpu: amdgpu:|amdgpu_dm)" ; then
			# whitelist all amd drm driver updates
			:;
#		elif [[ "${c}" =~ 0dbd555a011c2d096a7b7e40c83c5776a7df367c || \
#			# whitelist specific commits which includes 5.4-rc* commits
#			:;
		else
			if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
				#einfo "Skipping old commit ${c} : Old timestamp"
				continue
			fi
		fi

if false; then
		if [[ -n "${vk_summaries[${h_summary}]}" ]] ; then
			einfo "Already added ${c} via vanilla kernel sources (with same subject match).  Skipping..."
			continue
		fi

		if [[ -n "${asdn_summaries[${h_summary}]}" ]] ; then
			einfo "Already added ${c} via amd-staging-drm-next kernel sources (with same subject match).  Skipping..."
			continue
		fi

		if [[ "${c}" == "31ad0be4ebf7327591fbca1b96e209f591a19849" ]] ; then
			die "Summary detection failed.  Should not pass."
		fi
fi

		DC_VER=$(git -P show ${c}:drivers/gpu/drm/amd/display/dc/dc.h | grep -e "#define DC_VER" | grep -o -P -e "\"[0-9.]+\"" | sed -e "s|\"||g")

		# repad DC_VER
		DC_VER_MAJOR=$(printf "%02d" $(echo "$DC_VER" | cut -f1 -d "."))
		DC_VER_MINOR=$(printf "%02d" $(echo "$DC_VER" | cut -f2 -d "."))
		DC_VER_PATCH=$(printf "%03d" $(echo "$DC_VER" | cut -f3 -d "."))
		DC_VER="${DC_VER_MAJOR}.${DC_VER_MINOR}.${DC_VER_PATCH}"

		printf -v pn "%06d" ${n}
		local fn="${DC_VER}-${ct}-${pn}-${c}-rock.patch"
		#git format-patch --stdout -1 $c > "${T}"/rock-patches/${fn} # broken
		if git -P diff $c^..$c > "${T}"/rock-patches/${fn} ; then # reliable
			:; #einfo "Added ${fn}"
		else
			die "Failed to add ${fn}"
		fi
		n=$((n+1))
	done
	unset vk_commits
	unset vk_summaries
	unset asdn_commits
	unset asdn_summaries

	if declare -f ot-kernel-rock_generate_rock_patches_post > /dev/null ; then
		ot-kernel-rock_generate_rock_patches_post
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

# @FUNCTION: fetch_rock
# @DESCRIPTION:
# Manages getting a local copy of ROCk project
fetch_rock() {
	if is_rock ; then
		fetch_rock_local_copy
	fi
}
