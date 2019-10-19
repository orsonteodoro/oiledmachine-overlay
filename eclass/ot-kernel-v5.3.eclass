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
PATCH_UKSM_VER="5.3"
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

# When the Kernel version is >5.3, the AMD_STAGING_DRM_NEXT variables should be no longer updated, otherwise it may exhibit runtime errors.  This is based on experience.

CURRENT_DC_VER="03.02.054" # found in drivers/gpu/drm/amd/display/dc/dc.h for ${PV}

AMD_STAGING_DRM_NEXT_LATEST="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_DIR="amd-staging-drm-next"

AMD_STAGING_DRM_NEXT_SNAPSHOT="e025c334b6c7aa66c0fc67548643bd52c4a39eef" # latest commit I tested which should be ideally head
# 2019-10-04 drm/amdgpu: remove redundant variable r and redundant return statement

AMD_STAGING_DRM_NEXT_MILESTONE="a35d69a03b08e868ad222b1faa6ae5cc2c39113e" # corresponds to the tagged commit:: 2019-09-17 drm/amd/display: 3.2.51.1

#AMD_STAGING_INTERSECTS_ROCK="9c5ab937b15f87523dd057ba05b9869331283286" # DC_VER=3.2.35

# KV is kernel version, for the variable below means a commit hash "around a major.minor release."

# AMD_STAGING_INTERSECTS_KV starts from DC_VER of 5_x (major.minor kernel release milestones) and goes backwards with respect to DC_VER to the beginning of the mispatch/missing commit cluster(s).
# Mispatch/missing commit cluster can be caused by backports of DRM updates from future major.minor kernel releases.

#AMD_STAGING_INTERSECTS_KV="70bcf2bc5203e358e5e2ac30718caea53204dfe9" # corresponds to drm/amd/display: 3.2.35 (tested) same as 5.x kernel release
AMD_STAGING_INTERSECTS_KV="5408887141baac0ad1a5e6cf514ceadf33090114" # corresponds to drm/amd/display: 3.2.30 (testing); needs to go back x.x.-1 point release assuming that 3.2.31 is botched.
# 3.2.31 is pattern of missing commits in ot-kernel-common_fetch_amd_staging_drm_next_commits_post

# obtained by:  git -P show -s --format=%ct v5.3 | tail -n 1
LINUX_TIMESTAMP=1568582372

IUSE="bfq bmq bmq-quick-fix amd-staging-drm-next-latest amd-staging-drm-next-snapshot amd-staging-drm-next-milestone +cfs disable_debug +graysky2 muqss +o3 pds uksm tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs -zentune"
REQUIRED_USE="^^ ( muqss pds cfs bmq )
	     tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	     tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	     tresor_i686? ( tresor )
	     tresor_x86_64? ( tresor )
	     tresor_aesni? ( tresor )"

# no released patch yet
REQUIRED_USE+=" !pds !bmq-quick-fix !muqss"

if [[ -z "${OT_SOURCES_DEVELOPER}" ]] || [[ "${OT_SOURCES_DEVELOPER}" != "1" ]] ; then
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
DEPEND="amd-staging-drm-next-snapshot? ( dev-vcs/git )
	amd-staging-drm-next-latest? ( dev-vcs/git )
	amd-staging-drm-next-milestone? ( dev-vcs/git )
	dev-util/patchutils"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates, amd-staging-drm-next, TRESOR"

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
	   "

SRC_URI+="https://github.com/torvalds/linux/commit/4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch
	  https://github.com/torvalds/linux/commit/d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch"

_set_check_reqs_requirements() {
	# for 3.1 kernel
	# source merge alone: 986.2 MiB
	# linux-amd-staging-drm-next local repo: 2002.72 MiB
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

function ot-kernel-common_amdgpu_merge_and_apply_patches_asdn() {
	if is_amd_staging_drm_next && ! is_rock ; then
		# already patched
		rm "${mpd}"/*b48935b3bfc1350737e759fef5e92db14a2e2fbb*
		rm "${mpd}"/*4d7fd9e20b0784b07777728316da5bcc13f9f2ab*
		rm "${mpd}"/*ebecc6c48f39b3c549bee1e4ecb9be01bf341a0f*
		rm "${mpd}"/*ebf8fc31cbcedc9d6a81642082661c82eae284fb*
		rm "${mpd}"/*a6f30079b8562b659e1d06f7cb1bc30951869bbc*
		rm "${mpd}"/*bf2bf52383a09256e11278e7bcb67dcd912078c7*

		# obsolete
		rm "${mpd}"/*5fa790f6c936c4705dea5883fa12da9e017ceb4f*
		rm "${mpd}"/*3f61fd41f38328f0a585eaba2d72d339fe9aecda*

		cd "${S}"
		L=$(ls -1 "${mpd}" | sort)
		for l in $L ; do
			echo $(patch --dry-run ${PATCH_OPS} -i "${mpd}/${l}") | grep -F -e "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*ab2f7a5c18b5c17cc94aaab7ae2e7d1fa08993d6*)
						# fails enter in else branch so move up here
						# modifies to ab2f commit
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-e7f7287bf5f746d29f3607178851246a005dd398-partial-rebase-for-5.3.4-asdn.patch"
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0*)
						# revert then apply
						_dpatch "${PATCH_OPS} -R" "${DISTDIR}/d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch"
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						;;
					*cfb7c11bb7a590c7e9c3d241d85388db108ceeb7*)
						# revert then apply
						_dpatch "${PATCH_OPS} -R" "${DISTDIR}/4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch"
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						;;
					*22a8f442866bf539c7a659923155d9afa03d77bb*)
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-22a8f442866bf539c7a659923155d9afa03d77bb-rebase-for-5.3.4-asdn.patch"
						;;
					*fcd90fee8ac22da3bce1c6652cf36bc24e7a0749*)
						# fcd90 is DC_VER 3.2.42 :							 1564547001-000283
						# conflicting commit f0ced3f61b4d2a21a3e0f0aa79fb5ad6c6717c31 is DC_VER 3.2.42 : 1564759838-000402
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						# f0ced3f already applied in v5.3 kernel so breaks
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-fcd90fee8ac22da3bce1c6652cf36bc24e7a0749-rebase-for-5.3.4-asdn.patch"
						;;
					*98eb03bbf0175f009a74c80ac12b91a9680292f4*)
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-98eb03bbf0175f009a74c80ac12b91a9680292f4-rebase-for-5.3.4-asdn.patch"
						;;
					*)
						eerror "Patch failure ${mpd}/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi
}

function ot-kernel-common_amdgpu_merge_and_apply_patches_rock() {
	if is_amd_staging_drm_next && is_rock ; then
		# already patched
		rm "${mpd}"/*b48935b3bfc1350737e759fef5e92db14a2e2fbb*
		rm "${mpd}"/*4d7fd9e20b0784b07777728316da5bcc13f9f2ab*
		rm "${mpd}"/*ebecc6c48f39b3c549bee1e4ecb9be01bf341a0f*
		rm "${mpd}"/*ebf8fc31cbcedc9d6a81642082661c82eae284fb*
		rm "${mpd}"/*a6f30079b8562b659e1d06f7cb1bc30951869bbc*
		rm "${mpd}"/*bf2bf52383a09256e11278e7bcb67dcd912078c7*
		#
		rm "${mpd}"/*f761e8303bb1608622fb993531ba95244335c847*
		#rm "${mpd}"/**
		rm "${mpd}"/*87076c8829465b8ae71225f7e639e0e28ab4b4a2*
		rm "${mpd}"/*3605d1c0a0d8becfbaef64e5e166b50b21f1520e*

		# obsolete
		rm "${mpd}"/*5fa790f6c936c4705dea5883fa12da9e017ceb4f*
		rm "${mpd}"/*3f61fd41f38328f0a585eaba2d72d339fe9aecda*
		rm "${mpd}"/*31ad0be4ebf7327591fbca1b96e209f591a19849*

		cd "${S}"
		L=$(ls -1 "${mpd}" | sort)
		for l in $L ; do
			echo $(patch --dry-run ${PATCH_OPS} -i "${mpd}/${l}") | grep -F -e "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*ab2f7a5c18b5c17cc94aaab7ae2e7d1fa08993d6*)
						# fails enter in else branch so move up here
						# modifies to ab2f commit
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-e7f7287bf5f746d29f3607178851246a005dd398-partial-rebase-for-5.3.4-asdn.patch"
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0*)
						# revert then apply
						_dpatch "${PATCH_OPS} -R" "${DISTDIR}/d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch"
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						;;
					*cfb7c11bb7a590c7e9c3d241d85388db108ceeb7*)
						# revert then apply
						_dpatch "${PATCH_OPS} -R" "${DISTDIR}/4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch"
						_dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						;;
					*22a8f442866bf539c7a659923155d9afa03d77bb*)
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-22a8f442866bf539c7a659923155d9afa03d77bb-rebase-for-5.3.4-asdn.patch"
						;;
					*fcd90fee8ac22da3bce1c6652cf36bc24e7a0749*)
						# fcd90 is DC_VER 3.2.42 :							 1564547001-000283
						# conflicting commit f0ced3f61b4d2a21a3e0f0aa79fb5ad6c6717c31 is DC_VER 3.2.42 : 1564759838-000402
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						# f0ced3f already applied in v5.3 kernel so breaks
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-fcd90fee8ac22da3bce1c6652cf36bc24e7a0749-rebase-for-5.3.4-asdn.patch"
						;;
					*98eb03bbf0175f009a74c80ac12b91a9680292f4*)
						# Backport.  Final state doesn't exist in 5.3 but does in 5.4
						_tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amdgpu-98eb03bbf0175f009a74c80ac12b91a9680292f4-rebase-for-5.3.4-asdn.patch"
						;;
					*)
						eerror "Patch failure ${mpd}/${l} .  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi
}

# @FUNCTION: ot-kernel-common_amdgpu_merge_and_apply_patches
# @DESCRIPTION:
# Apply amd-staging-drm-next and ROCk commits at the same time.
function ot-kernel-common_amdgpu_merge_and_apply_patches() {
	local mpd="${T}/amdgpu-merged-patches"
	mkdir -p "${mpd}"
	if is_amd_staging_drm_next ; then
		generate_amd_staging_drm_next_patches
		mv "${T}/amd-staging-drm-next-patches"/* "${mpd}"
	fi
	if is_rock ; then
		generate_rock_patches
		mv "${T}/rock-patches"/* "${mpd}"
	fi

	ot-kernel-common_amdgpu_merge_and_apply_patches_rock
	# This is split to isolate amd_staging_drm_next versus amd_staging_drm_next with rock.  It is more difficult to update rock.
	ot-kernel-common_amdgpu_merge_and_apply_patches_asdn
}

_amdgpu_common_filter_patches_trashB() {
	local patchset="${1}"
	if [[ "${patchset}" == "amd-staging-drm-next-patches" ]] ; then
		p=$(ls "${T}/amd-staging-drm-next-patches"/*5f680625d9765a2f936707465659acac8e44f514*)
		if [ -e "${p}" ] ; then
			einfo "Filtering ${p}"
			filterdiff \
				-i "*/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c" \
				-i "*/drivers/gpu/drm/i915/gem/i915_gem_object.c" \
				-i "*/drivers/gpu/drm/i915/gt/intel_engine_pool.c" \
				"${p}" > "${p}.t" || die
			mv "${p}.t" "${p}" || die
		fi
	fi
}


# @FUNCTION: _amdgpu_common_filter_patches
# @DESCRIPTION:
# Selects parts of the patch to be merged
_amdgpu_common_filter_patches_trashA() {
	local patchset="${1}"
	einfo "Stripping modules for drivers/gpu/drm/{amd,ttm,scheduler,radeon}"
	local REQUIRED_MODULES="amd ttm scheduler"
	local MISC="lib ttm selftests"
	local OTHER_VENDORS="arc arm armada aspeed ast atmel-hlcdc bochs bridge cirrus etnaviv exynos fsl-dcu gma500 hisilicon i2c i810 i915 imx ingenic lima mcde mediatek meson mga mgag200 msm mxsfb nouveau omapdrm panel panfrost pl111 qxl r128 radeon rcar-du rockchip savage shmobile sis sti stm sun4i tdfx tegra tilcdc tinydrm tve200 udl v3d vboxvideo vc4 vgem via virtio vkms vmwgfx xen zte"
	F=$(find "${T}/${patchset}" | tail -n +2 | sort | sed -r \
		-e "s/\S+(0424fdaf883a689d5185c0d0665b265373945898|e4fa8457b2197118538a1400b75c898f9faaf164|b5031e86a9afd9f01104178faa24b3096bded907|d3bc25f3bff30881051012bf949dc89f8cfcfd1f|b82a6fd04ec371e1100984aabf7b93d28502649e|2550416ccf19cf882f2f8c06b6aa97fa732c552f|40e546c5f9ca0054087ce5ee04de96a4f28e9a97|8c6555d4a6fb18eb05a78173becc90e00333e6c6|c5be0ddd500dd6201d168b4fdd1ffa90846cb437|bf6f1fa62e76f93d1030a9e22923881cebc770b3|3baeeb21983a5ecc16955cc3f1d986bee88939f2|4bcc9543ad4ccbe88e2cfc2c432eec62da605064|d229c592d12d1cf1c288adb03fe6f087c6b206e6|4fdfffc8f31830aef2016bb3c2de050056f975a2|78fc89063f0c73aed9b9d35c84c81277b7115c6c|a23916462848873018e2300a54dc195899223548|baa78332a7ca01f72390d8fe7ade9b278ab7f5d4|b392cb98dfff242d4edb6e045e52f155c12bcd8b|f59bcca620e84a9e7a21779d9acfeca373b41731|cf64beca45f9dec6e87a2820a49a2872a846925a|03988e4fa15689da0ab954457c8578773c6e05b6|b8764eaf8ad85615245e6039b7d2ca8a92940014|52de698543c94807c753bdf40d9addbcff3dc2d8|cb822cab0537a8b65d68f2750534fd199e2ef84e|8a015561479639b8a7a2c3214bd24dbb055d8d39|aada617da7b657e625aa3bca4dab8830cd5c6401|f30dec2f82402c21b6ddf81b8f8350e72d49c90e|42169858d75c08558e288921c3d21d5fa1995072|634cdf7fd91a44f52a4d56fb9a94c376c322f82a|31070a871fdcb16dd209e6bc0e6ca16be7cfb938|0ccf52badd40efd3d5c8df91845df4d65e7caab9|0dbd555a011c2d096a7b7e40c83c5776a7df367c|0e580c6d7d2f2d490add0fcf70c5b7ec2300e636|e0828d54c81cb111ead1a7c47a5ef1b319610a1d|ce77038fdae385f947757a37573d90f2e83f0271|c105de2828e13931cd218e8b801cd6762b618992|f8659be8addd731480037eb44ecb521084ae1d11|1e053b10ba60eae6a3f9de64cbc74bdf6cb0e715|b96f3e7c8069b749a40ca3a33c97835d57dd45d2|2e3c9ec4d151c04d75546dfdc2f85a84ad546eb0|e532a135d7044b5477c1c56169fa131d77c57f75|336ac942f115dd076bd7287c7cf03f37c710895c|4922f55294bbc48d670bb57c025904b4d4878d1b|5a5011a72489545343a1599362e9ec126d7bd297|27c44acebd3fab5448aa3cffdc1996c897965a4a|5c69f132a2660435ec30d8531d77515b7ba4148e|7a4db29660a9d16024fd843b720fb7449ebc2538|e7f0141a217fa28049d7a3bbc09bee9642c47687|4c2488cfaa997e396aeb9d6496db94c25b97c671|67c97fb79a7f8621d4514275691d75f5ff158c46|dd7a7d1ff2f199a8a80ee233480922d4f17adc6d|52791eeec1d9f4a7e7fe08aaba0b1553149d93bc|f2cb60e9a3881e679465f84140754bc9d29956ea)\S+/ /g")

	# commit list obtained from using the vanilla kernel:
	# range is FROM Drop drm_gem_prime_export/import (jun 14) TO Store the timestamp in the same union as the cb_list (aug 17)
	# git log b40d73784ffc33f3c6431e7ceec3b20fffcd95c3..f2cb60e9a3881e679465f84140754bc9d29956ea --oneline --pretty=format:"%H %s" \
	# | grep -F \
	#	-e "reservation_object_fences" \
	#	-e "from bo->resv to bo->base.resv" \
	#	-e "drop ttm_buffer_object->resv" \
	#	-e "set both resv and base.resv pointers" \
	#	-e "use gem vma_node" \
	#	-e "use gem reservation object" \
	#	-e "use embedded gem object" \
	#	-e "add more reservation object locking wrappers" \
	#	-e "stop using seqcount for fence pruning" \
	#	-e "Set GEM object functions for PRIME" \
	#	-e "Don't export driver callback functions for PRIME" \
	#	-e "Drop drm_gem_prime_export/import" \
	#	-e "rename reservation_object to dma_resv" \
	#	-e "Actually remove DRIVER_PRIME everywhere" \
	#	-e "Store the timestamp in the same union as the cb_list" \
	#	-e "Align gem_prime_export with obj_funcs.export" \
	# | cut -f1 -d " " | tac | tr "\n" "|"

	for f in ${F} ; do
		if [ ! -e "${f}" ] ; then
			ewarn "${f} does not exist to filter"
			continue
		fi

		# We are only interested in ${REQUIRED_MODULES} and modified headers below but some of the patches that refer to them reside in non conforming subject tags.
		# In the DKMS module, it will only distribute the drivers/gpu/drm/${REQUIRED_MODULES} yet still compile fine against compatible MAJOR.MINOR kernel version.

		# DKMS will have a KCL (kernel compatibility layer) module that will add functions, macros, constants without tampering with the DRM .h or .c files.
		# We need to carefully add those parts without side effects that would alter the behavior of other vendor drm drivers.

		if grep -q -F -e "rename to" "${f}" > /dev/null ; then
			local paths=$(grep -e "rename to" "${f}" | sed -E -e "s|rename to (.*)|\1|g")
			ewarn "Detected rename for ${paths} .  This may filter out very important hunks."
		fi

		local B=()
		for v in ${OTHER_VENDORS[@]} ; do
			if grep -q -F -e "drivers/gpu/drm/${v}" "${f}" > /dev/null ; then
				B+=( ${v} )
			fi
		done

		if (( ${#B[@]} > 1 )) ; then
			local c=$(basename "${f}" | cut -f4 -d '-')
			ewarn "Detected ${#B[@]} vendor edits.  ${c} may break other drivers if changes do not to apply to all DRM drivers.  ${B[@]} drivers could all break."
			die "Add exclusion to proceed"
		fi

		# If the struct changes, then we may need to allow all drm drivers update.  So no filter.
		# This was an abandoned because it doesn't handle function name changes and we already don't filter many drm drivers edits case.
		#
		# if grep -q -o -P -e "([+-]{3}) \S*include/\S+.h" "${f}"  ; then
		# else
		# fi

		einfo "Filtering ${f}"
		filterdiff -i "*/drivers/gpu/drm/amd/*" \
			-i "*/drivers/gpu/drm/radeon/cik_reg.h" \
			-i "*/drivers/gpu/drm/ttm/*" \
			-i "*/drm/gpu/drm/scheduler/*" \
			-i "*/include/drm/amd_asic_type.h" \
			-i "*/include/drm/gpu_scheduler.h" \
			-i "*/include/drm/gpu_scheduler_trace.h" \
			-i "*/include/drm/spsc_queue.h" \
			-i "*/include/drm/ttm/*" \
			-i "*/include/uapi/drm/amdgpu_drm.h" \
			-i "*/include/uapi/linux/kfd_ioctl.h" \
			-i "*/drivers/dma-buf/*" \
			-i "*/include/linux/reservation.h" \
			-i "*/include/linux/dma-resv.h" \
			"${f}" > "${f}.t"
		mv "${f}.t" "${f}"
	done
	rm "${T}/${patchset}/"*.t > /dev/null
}

# @FUNCTION: ot-kernel-asdn-generate_amd_staging_drm_next_patches_post
# @DESCRIPTION:
# Removes unnecessary hunks
ot-kernel-asdn-generate_amd_staging_drm_next_patches_post() {
	_amdgpu_common_filter_patches "amd-staging-drm-next-patches"
}

# @FUNCTION: ot-kernel-rock_generate_rock_patches_post
# @DESCRIPTION:
# Removes unnecessary hunks
ot-kernel-rock_generate_rock_patches_post() {
	_amdgpu_common_filter_patches "rock-patches"
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
}
