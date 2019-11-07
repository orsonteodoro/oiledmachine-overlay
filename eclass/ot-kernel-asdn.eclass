#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-asdn.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel with the amd-staging-drm-next
# @DESCRIPTION:
# The ot-kernel-asdm eclass defines functions to merge amd-staging-drm-next
# into vanilla

# amd-staging-drm-next:
#   https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next

HOMEPAGE+=\
"https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next"

# @FUNCTION: amd_staging_drm_next_setup
# @DESCRIPTION:
# Does pre-emerge checks
function amd_staging_drm_next_setup() {
	if use amd-staging-drm-next ; then
		if [[ -z "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" ]] ; then
			local m=\
"You must define a AMD_STAGING_DRM_NEXT_BUMP_REQUEST environmental variable\n\
in your make.conf or per-package env containing either: head, \n\
dc_ver, amdgpu_version"
			if [[ "${K_MAJOR_MINOR}" == "5.3" ]] ; then
				m+=", snapshot"
			fi
			if ver_test ${K_MAJOR_MINOR} -ge 5.0 \
				&& ver_test ${K_MAJOR_MINOR} -le 5.3 ; then
				m+=", amdgpu_19_30"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.18 \
				&& ver_test ${K_MAJOR_MINOR} -lt 5.0 ; then
				m+=", amdgpu_19_10"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.15 \
				&& ver_test ${K_MAJOR_MINOR} -lt 4.18 ; then
				m+=", amdgpu_18_40"
			else
				ewarn \
	     "Your kernel version may not be supported by amd-staging-drm-next."
			fi
			die "${m}"
		fi
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
		case ${AMD_STAGING_DRM_NEXT_BUMP_REQUEST} in
			head|snapshot|dc_ver|amdgpu_version|amdgpu_19_30|\
			amdgpu_19_10|amdgpu_18_40)
				;;
			*)
				die \
			       "Invalid AMD_STAGING_DRM_NEXT_BUMP_REQUEST value"
				;;
		esac
		cd_asdn
		git config merge.renamelimit 1999
		chown portage:portage .git/config || die
	fi
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_amd_staging_drm_next() {
	if use amd-staging-drm-next ; then
		local suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
		if [[ \
       ! -d "${FILESDIR}/amd-staging-drm-next/${K_MAJOR_MINOR}" ]]
		then
			# ebuild maintainer only
			einfo \
"Dump amd-staging-drm-next patches to \
${FILESDIR}/amd-staging-drm-next/${K_MAJOR_MINOR}"
			fetch_amd_staging_drm_next_local_copy
		fi
	fi
}

# @FUNCTION: fetch_amd_staging_drm_next_local_copy
# @DESCRIPTION:
# Clones or updates the amd-staging-drm-next patchset for recent fixes or GPU
# compatibility updates.
function fetch_amd_staging_drm_next_local_copy() {
	einfo "Fetching the amd-staging-drm-next project please wait."
	einfo "It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}" || die
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}" || die
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}" || die
		einfo "Cloning the amd-staging-drm-next project"
		git clone "${AMDREPO_URL}" "${d}"
		cd "${d}" || die
		git checkout master
		git checkout -b amd-staging-drm-next \
			remotes/origin/amd-staging-drm-next
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die \
"You must manually: \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the amd-staging-drm-next project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next \
			remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}" || die
}

# @FUNCTION: asdn_rm
# @DESCRIPTION:
# Removes a commit from the patch folder
function asdn_rm() {
	local c="${1}"
	rm "${T}"/amd-staging-drm-next-patches/*${c}*
}

# @FUNCTION: asdn_rm_list
# @DESCRIPTION:
# Removes a list of commits
function asdn_rm_list() {
	for l in $@ ; do
		asdn_rm ${l}
	done
}

# @FUNCTION: amd_staging_drm_next_set_target
# @DESCRIPTION:
# Obtains the commit hash based on AMD_STAGING_DRM_NEXT_BUMP_REQUEST.
function amd_staging_drm_next_set_target() {
	local target
	if [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_version ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_VERSION_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ dc_ver ]] ; then
		target="${AMD_STAGING_DRM_NEXT_DC_VER_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ head ]] ; then
		target="${AMD_STAGING_DRM_NEXT_HEAD_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ snapshot ]] ; then
		if [[ ${K_MAJOR_MINOR} == 5.3 ]] ; then
			target="${AMD_STAGING_DRM_NEXT_SNAPSHOT_C}"
		else
			die \
"snapshot is not supported for AMD_STAGING_DRM_NEXT_BUMP_REQUEST your kernel \
version."
		fi
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_19_30 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_19_30_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_19_10 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_19_10_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_18_40 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_18_40_C}"
	fi
	echo "${target}"
}

# @FUNCTION: amd_staging_drm_next_use_commits
# @DESCRIPTION:
# This will select either FILESDIR or amd-staging-drm-next set
function amd_staging_drm_next_use_commits() {
	if [[ \
	  -d "${FILESDIR}/amd-staging-drm-next/" ]]
	then
		# we don't distribute this because it is 1G+
		cp -a "${FILESDIR}/amd-staging-drm-next"/* \
			"${T}"/amd-staging-drm-next-patches/ \
			|| die
	else
		amd_staging_drm_next_save_all_commits
	fi
}

# @FUNCTION: cd_asdn
# @DESCRIPTION:
# Change directory to asdn
cd_asdn() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}" || die
}

# @FUNCTION: amd_staging_drm_next_save_all_commits
# @DESCRIPTION:
# Saves all amd-staging-drm-next commits as patch files
function amd_staging_drm_next_save_all_commits() {
	cd_asdn
	for c in $C ; do
		local fn
		local ct=$(git -P show -s --format=%ct ${c})
		local s=$(git -P show -s --format=%s ${c})
		local h_summary
		h_summary=$(echo "${s}" | sha1sum | cut -f1 -d ' ')

		DC_VER=$(git -P \
			show ${c}:drivers/gpu/drm/amd/display/dc/dc.h \
			| grep -e "#define DC_VER" \
			| grep -o -P -e "\"[0-9.]+\"" \
			| sed -e "s|\"||g")

		# repad DC_VER
		DC_VER_MAJOR=$(printf "%02d" $(echo "$DC_VER" | cut -f1 -d '.'))
		DC_VER_MINOR=$(printf "%02d" $(echo "$DC_VER" | cut -f2 -d '.'))
		DC_VER_PATCH=$(printf "%03d" $(echo "$DC_VER" | cut -f3 -d '.'))
		DC_VER="${DC_VER_MAJOR}.${DC_VER_MINOR}.${DC_VER_PATCH}"

		printf -v pn "%06d" ${n}
		fn="${DC_VER}-${ct}-${pn}-${c}-asdn.patch"

		if git -P diff $c^..$c \
			> "${T}"/amd-staging-drm-next-patches/${fn} ; then
		        #einfo "Added ${fn}"
			# attach missing commit subject for possible patch tarball
			git -P show -s --pretty=email ${c} \
			  > "${T}/amd-staging-drm-next-patches/${fn}.t" || die
			cat "${T}/amd-staging-drm-next-patches/${fn}" \
			  >> "${T}/amd-staging-drm-next-patches/${fn}.t" || die
			mv "${T}"/amd-staging-drm-next-patches/${fn}{.t,} \
			  || die
		else
			die "Failed to add ${c} ${fn}"
		fi
	        n=$((n+1))
	done

	einfo "Attaching licenses to amd-staging-drm-next patches"
	"${HOME}/patachie" -p "${T}"/amd-staging-drm-next-patches \
		-s "${S}" \
		-of "${T}/asdn-licenses" \
		-od "${T}/asdn-processed"
	mv "$(pwd)/attachied" "$(pwd)/asdn-attachied" || die
	einfo \
"Maintainer:  $(pwd)/asdn-attachied contains patches with attached licenses\n\
and ${T}/asdn-licenses contains all the licenses in one file."
}

# @FUNCTION: __remove_asdn_patch
# @DESCRIPTION:
# (PRIVATE) Removes an amd-staging-drm-next .patch file
function __remove_asdn_patch() {
	rm "${T}"/amd-staging-drm-next-patches/*${c}*asdn* > /dev/null
}

# @FUNCTION: amd_staging_drm_next_filter_by_git_commit_metadata
# @DESCRIPTION:
# Removes commits before merging
function amd_staging_drm_next_filter_by_git_commit_metadata() {
	cd_asdn
	local whitelisted
	for c in $C ; do
		local fn
		if [[ -n "${vk_commits[${c}]}" ]] ; then
#			einfo \
#"Skipping old commit ${c} :  Already added via vanilla kernel sources."
			__remove_asdn_patch
			continue
		fi

		local s=$(git -P show -s --format=%s ${c})
		local h_summary=$(echo "${s}" | sha1sum | cut -f1 -d ' ')

		local whitelisted=0
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
			# whitelist specific commits which includes \
			# 5.4-rc* commits
			whitelisted=1
		elif echo "${s}" | grep -q -P \
-e "(drm/amd|amdgpu|amd/powerplay|amdkfd|gpu: amdgpu:|amdgpu_dm)" ; then
			# whitelist all amd drm driver updates for
			# evaluation
			:;
		elif echo "${s}" | grep -q -P \
-e "(bo->resv to bo->base.resv|use embedded gem object|Fill out gem_object->resv)" ; then
			# whitelist by subject keywords
			whitelisted=1
		else
			local ct=$(git -P show -s --format=%ct ${c})
			if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
				#einfo "Skipping old commit ${c} : Old timestamp"
				__remove_asdn_patch
				continue
			fi
		fi
		if [[ "${whitelisted}" == "1" ]] ; then
			:;
		elif [[ -n "${vk_summaries[${h_summary}]}" ]] ; then
			einfo \
"Already added ${c} via vanilla kernel sources (with same subject match). \
Skipping..."
			__remove_asdn_patch
			continue
		fi
	done
}

# @FUNCTION: generate_amd_staging_drm_next_commit_list
# @DESCRIPTION:
# Fills a variable named C with list of commits
function generate_amd_staging_drm_next_commit_list() {
	cd_asdn
	einfo \
"Saving only the amd-staging-drm-next commits for commit-by-commit evaluation.\n\
Doing commit -> .patch conversion for amd-staging-drm-next-patches set:"
	C=$(git -P log ${base}..${target} --oneline \
		--pretty=format:"%H" -- \
		drivers/gpu/drm include/drm drivers/dma-buf \
		include/linux include/uapi/drm \
		| echo -e "\n$(cat -)" | tac)
	pickle_string "C" "${T}/asdn_commit_list.${K_MAJOR_MINOR}${suffix_asdn}"
}

# @FUNCTION: amd_staging_drm_next_use_commit_list
# @DESCRIPTION:
# Generates or uses a amd-staging-drm-next commit list
function amd_staging_drm_next_use_commit_list() {
	if has_amd_staging_drm_next_database ; then
		local suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
		einfo "Using the amd-staging-drm-next commit list"
		source "${T}/asdn_commit_list.${K_MAJOR_MINOR}${suffix_asdn}"
	else
		einfo "Generating amd-staging-drm-next commit list"
		generate_amd_staging_drm_next_commit_list
	fi
}

# @FUNCTION: amd_staging_drm_next_generate_database
# @DESCRIPTION:
# Generates database files so that dependence on git will
# be removed.
#
# Preconditions: asdn_summary_raw, asdn_summary_hash,
# asdn_commit_time must be declared associative
# arrays first
function amd_staging_drm_next_generate_database() {
	cd_asdn
	for c in $C ; do
		local s=$(git -P show -s --format=%s ${c})
		local ct=$(git -P show -s --format=%ct ${c})
		local h_summary=$(echo "${s}" | sha1sum | cut -f1 -d ' ')
		asdn_summary_raw[${c}]="${s}"
		asdn_summary_hash[${c}]="${h_summary}"
		asdn_commit_time[${c}]=${ct}
	done
	pickle_associative_array "asdn_summary_raw" \
		"${T}/${ASDN_DB_SUMMARY_RAW_FN}"
	pickle_associative_array "asdn_summary_hash" \
		"${T}/${ASDN_DB_SUMMARY_HASH_FN}"
	pickle_associative_array "asdn_commit_time" \
		"${T}/${ASDN_DB_COMMIT_TIME_FN}"
}

# @FUNCTION: has_amd_staging_drm_next_database
# @DESCRIPTION:
# Checks for the existance of the amd-staging-drm-next databases
function has_amd_staging_drm_next_database() {
	if [[ -e "${FILESDIR}/${ASDN_DB_SUMMARY_RAW_FN}" \
		&& -e "${T}/${ASDN_DB_SUMMARY_HASH_FN}" \
		&& -e "${T}/${ASDN_DB_COMMIT_TIME_FN}" ]]
	then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: amd_staging_drm_next_use_database
# @DESCRIPTION:
# Loads the amd-staging-drm-next databases
function amd_staging_drm_next_use_database() {
	unset asdn_summary_raw
	unset asdn_summary_hash
	unset asdn_commit_time
	declare -Ax asdn_summary_raw
	declare -Ax asdn_summary_hash
	declare -Ax asdn_commit_time
	if has_amd_staging_drm_next_database ; then
		einfo "Using the amd-staging-drm-next database"
		cp -a "${FILESDIR}/${ASDN_DB_SUMMARY_RAW_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_SUMMARY_HASH_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_COMMIT_TIME_FN}" \
			"${T}" || die
	else
		einfo "Generating the amd-staging-drm-next database"
		amd_staging_drm_next_generate_database
	fi
	source "${T}/${ASDN_DB_SUMMARY_RAW_FN}"
	source "${T}/${ASDN_DB_SUMMARY_HASH_FN}"
	source "${T}/${ASDN_DB_COMMIT_TIME_FN}"
}


# @FUNCTION: generate_amd_staging_drm_next_patches
# @DESCRIPTION:
# Produces all the commits as .patch files to be individually evaluated.  It
# also pulls required missing commits to smooth out the patching process.
#
# ot-kernel-asdn-generate_amd_staging_drm_next_patches_post - callback to apply
#   additonal patches for fixes to patches before the patching proces
#
function generate_amd_staging_drm_next_patches() {
	cd_asdn

	local suffix_asdn
	local target=$(amd_staging_drm_next_set_target)
	suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
	local base="${AMD_STAGING_INTERSECTS_KV}"

	mkdir -p "${T}/amd-staging-drm-next-patches"
	n="1"

	unset vk_commits
	unset vk_summaries
	declare -A vk_commits
	declare -A vk_summaries

	local C
	einfo "Querying amd-staging-drm-next commit list"
	amd_staging_drm_next_use_commit_list
	einfo "Querying the amd-staging-drm-next database"
	amd_staging_drm_next_use_database
	einfo "Saving all amd-staging-drm-next commits"
	amd_staging_drm_next_use_commits
	einfo "Filtering amd-staging-drm-next commits by git commit metadata"
	amd_staging_drm_next_filter_by_git_commit_metadata

	if declare \
		-f ot-kernel-asdn-generate_amd_staging_drm_next_patches_post \
		> /dev/null ; then
		ot-kernel-asdn-generate_amd_staging_drm_next_patches_post
	fi

	if declare -f ot-kernel-asdn_rm > /dev/null ; then
		# per version removal
		ot-kernel-asdn_rm
	fi
}

# @FUNCTION: generate_amd_staging_drm_next_hash_tables
# @DESCRIPTION:
# Generates amd-staging-drm-next hash tables for
# deduping.
function generate_amd_staging_drm_next_hash_tables() {
	cd_asdn
	einfo \
		"Generating hash tables for amd-staging-drm-next"
	for f in \
		$(find "${T}"/amdgpu-merged-patches/ -name "*asdn*") ; \
	do
	  local c
	  c=$(basename $f | cut -f4 -d '-')
	  if [[ -n "${c}" && "${c}" != " " ]] ; then
	    asdn_commits[${c}]=1
	    local s=$(git -P show -s --format=%s ${c})
	    local h=$(echo "${s}" | sha1sum \
	      | cut -f1 -d ' ')
	    if [[ -n "${h}" && "${h}" != " " ]] ; then
	      asdn_summaries[${h}]=1
	    fi
	  fi
	done
	pickle_associative_array "asdn_commits" "${T}/${HT_ASDN_FN}"
	pickle_associative_array "asdn_summaries" "${T}/${HT_ASDNS_FN}"
}

# @FUNCTION: amd_staging_drm_next_hash_use_hash_tables
# @DESCRIPTION:
# Loads amd-staging-drm-next hash tables for deduping
#
# Preconditions: the caller function must declare associative
# arrays named asdn_commits and asdn_summaries
function amd_staging_drm_next_hash_use_hash_tables() {
	if [[   ! -e "${FILESDIR}/${HT_ASDN_FN}" && \
		! -e "${FILESDIR}/${HT_ASDNS_FN}" ]] ; \
	then
		generate_amd_staging_drm_next_hash_tables
	else
		cp -a "${FILESDIR}/${HT_ASDN_FN}" "${T}"
		cp -a "${FILESDIR}/${HT_ASDNS_FN}" "${T}"
		einfo \
		  "Using cached hash tables for amd-staging-drm-next"
		source "${T}/${HT_ASDN_FN}"
		source "${T}/${HT_ASDNS_FN}"
	fi
}
