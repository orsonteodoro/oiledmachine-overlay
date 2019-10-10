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

# DC_VER 3.2.35 in drivers/gpu/drm/amd/display/dc/dc.h for ${PV}
# KMS_DRIVER 3.33.0 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for ${PV}

AMD_STAGING_DRM_NEXT_LATEST="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_DIR="amd-staging-drm-next"

AMD_STAGING_DRM_NEXT_SNAPSHOT="e025c334b6c7aa66c0fc67548643bd52c4a39eef" # latest commit I tested which should be ideally head
# 2019-10-04 drm/amdgpu: remove redundant variable r and redundant return statement

AMD_STAGING_DRM_NEXT_MILESTONE="a35d69a03b08e868ad222b1faa6ae5cc2c39113e" # corresponds to the tagged commit:: 2019-09-17 drm/amd/display: 3.2.51.1

AMD_STAGING_INTERSECTS_ROCK="9c5ab937b15f87523dd057ba05b9869331283286"

#AMD_STAGING_INTERSECTS_5_X="70bcf2bc5203e358e5e2ac30718caea53204dfe9" # corresponds to drm/amd/display: 3.2.35 (tested) same as 5.x kernel release
AMD_STAGING_INTERSECTS_5_X="5408887141baac0ad1a5e6cf514ceadf33090114" # corresponds to drm/amd/display: 3.2.30 (testing); needs to go back x.x.-1 point release assuming that 3.2.31 is botched.
# 3.2.31 is pattern of missing commits in ot-kernel-common_fetch_amd_staging_drm_next_commits_post

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

# @FUNCTION: ot-kernel-common_amdgpu_amd_staging_drm_next_fixes
# @DESCRIPTION:
# Apply amd-staging-drm-next fixes.
function ot-kernel-common_amdgpu_amd_staging_drm_next_fixes() {
	if is_amd_staging_drm_next ; then
		fetch_amd_staging_drm_next_commits

		cd "${S}"
		L=$(ls -1 "${T}"/amd-staging-drm-next-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-staging-drm-next-patches/${l}") | grep -F "FAILED at"
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
}

ot-kernel-common_fetch_amd_staging_drm_next_commits_post() {
	einfo "Stripping modules for drivers/gpu/drm/{amd,ttm,scheduler,radeon}"
	REQUIRED_MODULES="amd ttm scheduler"
	OTHER_VENDORS="arc arm armada aspeed ast atmel-hlcdc bochs bridge cirrus etnaviv exynos fsl-dcu gma500 hisilicon i2c i810 i915 imx ingenic lib lima mcde mediatek meson mga mgag200 msm mxsfb nouveau omapdrm panel panfrost pl111 qxl r128 radeon rcar-du rockchip savage selftests shmobile sis sti stm sun4i tdfx tegra tilcdc tinydrm tve200 udl v3d vboxvideo vc4 vgem via virtio vkms vmwgfx xen zte"
	for f in $(find "${T}/amd-staging-drm-next-patches" | sort) ; do
		# we are only interested in ${REQUIRED_MODULES} but some of the patches that refer to them reside in non conforming subject tags
		# in the dkms module it will only distribute the drivers/gpu/drm/${REQUIRED_MODULES} yet still compile fine against compatible MAJOR.MINOR kernel version
		einfo "Filtering ${f}"
		filterdiff -i "*/drivers/gpu/drm/amd/*" -i "*/drivers/gpu/drm/ttm/*" -i "*/drm/gpu/drm/scheduler/*" -i "*/drivers/gpu/drm/radeon/cik_reg.h" > "${f}.t"
		mv "${f}.t" "${f}"
	done
	[ -e "${T}/amd-staging-drm-next-patches.t" ] && rm "${T}/amd-staging-drm-next-patches.t"
}

# @FUNCTION: ot-kernel-common_apply_amdgpu_rock_fixes
# @DESCRIPTION:
# Apply ROCk fixes
function ot-kernel-common_apply_amdgpu_rock_fixes() {
	if is_rock && is_amd_staging_drm_next ; then
		einfo "fixme"
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
