# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-asdm.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel with the amd-staging-drm-next
# @DESCRIPTION:
# The ot-kernel-asdm eclass defines functions to merge amd-staging-drm-next into vanilla

# amd-staging-drm-next:         https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next

HOMEPAGE+=" https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next"

IUSE+=" amd-staging-drm-next-snapshot amd-staging-drm-next-milestone amd-staging-drm-next-latest"
IUSE+=" rock-latest rock-snapshot rock-milestone"

REQUIRED_USE+=" amd-staging-drm-next-snapshot? ( !amd-staging-drm-next-latest !amd-staging-drm-next-milestone )
	        amd-staging-drm-next-latest? ( !amd-staging-drm-next-snapshot !amd-staging-drm-next-milestone )
	        amd-staging-drm-next-milestone? ( !amd-staging-drm-next-snapshot !amd-staging-drm-next-latest )"

LINUX_COMMITS_ASDN_RANGE_FN="${LINUX_COMMITS_ASDN_RANGE_FN:=linux.commits.amd_staging_drm_next_range.${K_MAJOR_MINOR}}"

# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_amd_staging_drm_next() {
	if is_amd_staging_drm_next ; then
		fetch_linux_sources
		get_linux_commit_list_for_amd_staging_drm_next_range
		fetch_amd_staging_drm_next_local_copy
	fi
}

# @FUNCTION: get_linux_commit_list_for_amd_staging_drm_next_range
# @DESCRIPTION:
# Gets the list of commits between AMD_STAGING_INTERSECTS_5_X and target
function get_linux_commit_list_for_amd_staging_drm_next_range() {
	einfo "entered get_linux_commit_list_for_amd_staging_drm_next_range"
	if use amd-staging-drm-next-snapshot || use amd-staging-drm-next-milestone ; then
		if [[ -e "${FILESDIR}/${LINUX_COMMITS_ASDN_RANGE_FN}" ]] ; then
			cp -a "${FILESDIR}/${LINUX_COMMITS_ASDN_RANGE_FN}" "${T}"
			return
		fi
	fi

	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	cd "${d}" || die
	einfo "Grabbing list of already merged amd-staging-drm-next commits in v${K_MAJOR_MINOR} vanilla sources."
	git log ${AMD_STAGING_INTERSECTS_5_X}..v${K_MAJOR_MINOR} --oneline --pretty=format:"%H%x07%s%x07%ce" -- \
		drivers/gpu/drm/amd drivers/gpu/drm/ttm drivers/gpu/drm/scheduler drivers/gpu/drm/radeon/cik_reg.h \
		| tac > "${T}/${LINUX_COMMITS_ASDN_RANGE_FN}"
}

# @FUNCTION: fetch_amd_staging_drm_next_local_copy
# @DESCRIPTION:
# Clones or updates the amd-staging-drm-next patchset for recent fixes or GPU compatibility updates.
function fetch_amd_staging_drm_next_local_copy() {
	# I would like to store/cache the converted commits to .patch files in ${FILESDIR}/amd-staging-drm-next/5.3 but unfortunately
	# I cannot do it because of licensing problems.  It would require to prepend each patch with the license or extract the
	# license header from the source code and store it in a single LICENSE file, or creative license fingerprinting and IDing
	# the headers.  It is practically impossible or too time consuming to do it for 1100+ commits which refer to several files each.

	einfo "Fetching the amd-staging-drm-next project please wait.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}" || die
		einfo "Cloning the amd-staging-drm-next project"
		git clone "${AMDREPO_URL}" "${d}"
		cd "${d}" || die
		git checkout master
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die "You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the amd-staging-drm-next project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}" || die
}

# @FUNCTION: fetch_amd_staging_drm_next_commits
# @DESCRIPTION:
# Pulls all the commits as .patch files to be individually evaluated.  It
# also pulls required missing commits to smooth out the patching process.
#
# ot-kernel-common_fetch_amd_staging_drm_next_commits_pre - callback to reorder or fetch patches
# ot-kernel-common_fetch_amd_staging_drm_next_commits_pre_num - callback to set the next patch number
# ot-kernel-common_fetch_amd_staging_drm_next_commits_post - callback to apply additonal patches
#   for fixes to patches before the patching proces
#
function fetch_amd_staging_drm_next_commits() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}" || die

	local target

	# base is not inclusive
	local base

	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	fi

	if is_rock ; then
		base="${AMD_STAGING_INTERSECTS_ROCK}"
	else
		base="${AMD_STAGING_INTERSECTS_5_X}"
	fi

	mkdir -p "${T}/amd-staging-drm-next-patches"
	if declare -f ot-kernel-common_fetch_amd_staging_drm_next_commits_pre > /dev/null ; then
		ot-kernel-common_fetch_amd_staging_drm_next_commits_pre
		n="$(ot-kernel-common_fetch_amd_staging_drm_next_commits_pre_num)"
	else
		n="1"
	fi

	einfo "Saving only the amd-staging-drm-next commits for commit-by-commit evaluation."
	einfo "Doing commit -> .patch conversion for amd-staging-drm-next-patches set:"
	L=$(git log ${base}..${target} --oneline --pretty=format:"%H%x07%s%x07%ce" -- \
		drivers/gpu/drm/amd drivers/gpu/drm/ttm drivers/gpu/drm/scheduler drivers/gpu/drm/radeon/cik_reg.h \
		| cut -f1 -d$'\007' | tac)

	for l in $L ; do
		if grep -q -F "${l}" "${T}/${LINUX_COMMITS_ASDN_RANGE_FN}" ; then
			einfo "Rejected ${l}.  Already merged."
			continue
		fi

		printf -v pn "%06d" ${n}
	        git format-patch --stdout -1 $l > "${T}"/amd-staging-drm-next-patches/${pn}-$l.patch

	        einfo "Added ${pn}-$l.patch"
	        n=$((n+1))
	done

	if declare -f ot-kernel-common_fetch_amd_staging_drm_next_commits_post > /dev/null ; then
		ot-kernel-common_fetch_amd_staging_drm_next_commits_post
	fi
}

# @FUNCTION: _get_amd_staging_drm_next_commit
# @DESCRIPTION:
# Gets an amd-staging-drm-next commit and makes a .patch file
# @CODE
# Parameters:
# $1 - index to generate to file name
# $2 - commit pull and to attach to filename
# $3 - postfix to attack to index (optional)
# @CODE
function _get_amd_staging_drm_next_commit()
{
	local index="${1}"
	local commit="${2}"
	local postfix="${3}"
	printf -v pindex "%06d" ${index}
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}" || die
	git format-patch --stdout -1 ${commit} > "${T}"/amd-staging-drm-next-patches/${pindex}${postfix}-${commit}.patch || die
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
