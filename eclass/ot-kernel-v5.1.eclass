# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.1.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Eclass for patching the 5.1.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.1 eclass defines specific applicable patching for the 5.1.x linux kernel.

ETYPE="sources"

K_MAJOR_MINOR="5.1"
K_PATCH_XV="5.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.0"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.1"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.1"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?21}"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="5.0"
PATCH_PDS_VER="${PATCH_PDS_VER:=099o}"
PATCH_BFQ_VER="5.1"
PATCH_BMQ_VER="096"
PATCH_BMQ_MAJOR_MINOR="5.1"
DISABLE_DEBUG_V="1.1"

IUSE="bfq bmq bmq-quick-fix +cfs disable_debug +graysky2 muqss +o3 pds uksm -zentune"
REQUIRED_USE="^^ ( muqss pds cfs bmq )"

# no released patch for 5.1 yet
REQUIRED_USE+=" !pds !bmq-quick-fix"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs versionator
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates"

CK_URL_BASE="http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

inherit ot-kernel-common

BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.diff"
BMQ_SRC_URL+=" https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}"

SRC_URI="
	 ${CK_SRC_URL}
	 ${KERNEL_URI}
	 ${GENPATCHES_URI}
	 ${ARCH_URI}
	 ${O3_CO_SRC_URL}
	 ${O3_RO_SRC_URL}
	 ${GRAYSKY_SRC_4_9_URL}
	 ${GRAYSKY_SRC_8_1_URL}
	 ${BMQ_SRC_URL}
	 ${GENPATCHES_BASE_SRC_URL}
	 ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	 ${GENPATCHES_EXTRAS_SRC_URL}
	 ${UKSM_SRC_URL}
	 ${KERNEL_PATCH_URLS[@]}
	 "

function ot-kernel-common_ot-kernel-common_pkg_setup_cb() {
	ewarn "This kernel series is EOL and not supported.  It exists for migrating to supported kernels and for propretary drivers that rely on 5.1."
	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi
}

# @FUNCTION: ot-kernel-common_uksm_fixes
# @DESCRIPTION:
# Applies specific UKMS fixes for this kernel major version
function ot-kernel-common_uksm_fixes() {
	# the header patches fine with patch -N
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.1-fixes.patch" # for reuse_ksm_page
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

# @FUNCTION: ot-kernel-common_apply_o3_fixes
# @DESCRIPTION:
# Apply fixes to O3
function ot-kernel-common_apply_bmq_quickfixes() {
	if use bmq-quick-fix ; then
		# Upstream tends to add quick fixes immediately after releases, so this use flag exists.
		# See http://cchalpha.blogspot.com/2019/06/bmq-096-release.html?showComment=1560096391712#c540582441437278845 .
		_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_QUICK_FIX_FN}"
	fi
}

# @FUNCTION: ot-kernel-common_amdgpu_amd_staging_drm_next_fixes
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_ot-kernel-common_pkg_postinst_cb() {
	if use disable_debug ; then
		einfo "The disable debug scripts have been placed in your /usr/src folder."
		einfo "They disable debug paths, logging, output for a performance gain."
		einfo "You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`"
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

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
