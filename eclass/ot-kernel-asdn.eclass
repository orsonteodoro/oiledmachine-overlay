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

# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_amd_staging_drm_next() {
	if is_amd_staging_drm_next ; then
		fetch_amd_staging_drm_next_local_copy
	fi
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

# @FUNCTION: generate_amd_staging_drm_next_patches
# @DESCRIPTION:
# Produces all the commits as .patch files to be individually evaluated.  It
# also pulls required missing commits to smooth out the patching process.
#
# ot-kernel-asdn-generate_amd_staging_drm_next_patches_post - callback to apply additonal patches
#   for fixes to patches before the patching proces
#
function generate_amd_staging_drm_next_patches() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}" || die

	local target
	local base

	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	fi
	base="${AMD_STAGING_INTERSECTS_KV}"

	mkdir -p "${T}/amd-staging-drm-next-patches"
	n="1"

	einfo "Saving only the amd-staging-drm-next commits for commit-by-commit evaluation."
	einfo "Doing commit -> .patch conversion for amd-staging-drm-next-patches set:"
	C=$(git -P log ${base}..${target} --oneline --pretty=format:"%H" -- \
		drivers/gpu/drm include/drm drivers/dma-buf include/linux include/uapi/drm \
		| echo -e "\n$(cat -)" | tac)

	# vk is vanilla kernel
	einfo "Generating hash table"
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
		local h=$(echo -e "${l}" | sha1sum | cut -f1 -d" ")
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			vk_summaries[${h}]=1
		fi
	done
	IFS="${OIFS}"

	einfo "Doing commit -> .patch conversion for amd-staging-drm-next set:"
	for c in $C ; do
		if [[ -n "${vk_commits[${c}]}" ]] ; then
			#einfo "Skipping old commit ${c} :  Already added via vanilla kernel sources."
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
		elif echo "${s}" | grep -q -P -e "(bo->resv to bo->base.resv|use embedded gem object|Fill out gem_object->resv)" ; then
			# whitelist by subject keywords
			:;
		elif [[ "${c}" =~ 0dbd555a011c2d096a7b7e40c83c5776a7df367c || \
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
			"${c}" =~ 2e3c9ec4d151c04d75546dfdc2f85a84ad546eb0 ]] ; then
			# whitelist specific commits which includes 5.4-rc* commits
			:;
		else
			if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
				#einfo "Skipping old commit ${c} : Old timestamp"
				continue
			fi
		fi

		if [[ -n "${vk_summaries[${h_summary}]}" ]] ; then
			einfo "Already added ${c} via vanilla kernel sources (with same subject match).  Skipping..."
			continue
		fi

		DC_VER=$(git -P show ${c}:drivers/gpu/drm/amd/display/dc/dc.h | grep -e "#define DC_VER" | grep -o -P -e "\"[0-9.]+\"" | sed -e "s|\"||g")

		# repad DC_VER
		DC_VER_MAJOR=$(printf "%02d" $(echo "$DC_VER" | cut -f1 -d "."))
		DC_VER_MINOR=$(printf "%02d" $(echo "$DC_VER" | cut -f2 -d "."))
		DC_VER_PATCH=$(printf "%03d" $(echo "$DC_VER" | cut -f3 -d "."))
		DC_VER="${DC_VER_MAJOR}.${DC_VER_MINOR}.${DC_VER_PATCH}"

		printf -v pn "%06d" ${n}
		local fn="${DC_VER}-${ct}-${pn}-${c}-asdn.patch"
	        #git format-patch --stdout -1 $c > "${T}"/amd-staging-drm-next-patches/${fn} # broken but fastest
		if git -P diff $c^..$c > "${T}"/amd-staging-drm-next-patches/${fn} ; then # reliable
		        :; #einfo "Added ${fn}"
		else
			die "Failed to add ${fn}"
		fi
	        n=$((n+1))
	done
	unset vk_commits
	unset vk_summaries

	if declare -f ot-kernel-asdn-generate_amd_staging_drm_next_patches_post > /dev/null ; then
		ot-kernel-asdn-generate_amd_staging_drm_next_patches_post
	fi
}

__asdn_trash() {
	# sept 15 2019 was the merge of 5.3
	einfo "Removing old merges"
	# asdn is linux v5.3-rc3 so throw away the older merges
	L=$(git -P log ${base}..${target} --pretty=format:"%H%x07%s" | grep -P -e "((branch|tag).*5\.(1|2)(-rc[0-9]*)?|2019-(01|02|03|04|05|06|07|08|09)-([0-9]+)|2019(01|02|03|04|05|06|07|08|09))")
	OIFS="${IFS}"
	IFS=$'\n'
	for l in $L ; do
		local c=$(echo "${l}" | cut -f1 -d$'\007')
		if [ -e "${T}/amd-staging-drm-next-patches"/*${c}* ] ; then
			#local s=$(git -P log --oneline --pretty=format:"%H %s" -1 ${c})
			einfo "Removing ${l}"
			rm "${T}/amd-staging-drm-next-patches"/*${c}*
		fi
	done
	IFS="${OIFS}"

	einfo "Removing older other vendor driver commits"
	local OTHER_VENDORS="arc arm armada aspeed ast atmel-hlcdc bochs bridge cirrus etnaviv exynos fsl-dcu gma500 hisilicon i2c i810 i915 imx ingenic lima mcde mediatek meson mga mgag200 msm mxsfb nouveau omapdrm panel panfrost pl111 qxl r128 radeon rcar-du rockchip savage shmobile sis sti stm sun4i tdfx tegra tilcdc tinydrm tve200 udl v3d vboxvideo vc4 vgem via virtio vkms vmwgfx xen zte"
	for f in $(find "${T}/amd-staging-drm-next-patches" | tail -n +2 | sort) ; do
		local c=$(basename "${f}" | cut -f4 -d "-")
		local ct=$(git -P show -s --format=%ct ${c})
		local s=$(git -P show -s --format=%s ${c})
		for v in ${OTHER_VENDORS[@]} ; do
			if [ -e "${f}" ] ; then
				if grep -q -F -e "drivers/gpu/drm/${v}" "${f}" > /dev/null ; then
					if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
						einfo "Removing ${c} ${s}"
						rm "${T}/amd-staging-drm-next-patches"/*${c}*
					fi
				fi
			fi
		done
	done
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
