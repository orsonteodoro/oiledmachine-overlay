# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.1...zen-kernel:5.1/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.1/5.1-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:		https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.2...zen-kernel:5.2/bfq-backports
# amd-staging-drm-next:         https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next
# ROCK-Kernel-Driver:		https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/
# TRESOR:			http://www1.informatik.uni-erlangen.de/tresor

# TRESOR is maybe broken.  It requires additional coding for skcipher.
# Use the 4.9 series if you want to use TRESOR.
# See aesni-intel_glue.c chacha20_glue.c tresor_glue.c aesni-intel_asm.S aesni-intel_asm.S in arch/x86/crypto
# It needs to fill out the skcipher_alg structure and provide callbacks that use the skcipher_request structure.
# CBC uses CRYPTO_ALG_TYPE_SKCIPHER
# ECB uses CRYPTO_ALG_TYPE_BLKCIPHER

# Parts that still need to be developed:
# TRESOR - incomplete API
# ROCK-Kernel-Driver - forward porting incomplete

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://github.com/dolohow/uksm
          https://liquorix.net/
          https://github.com/graysky2/kernel_gcc_dpatch
	  http://ck-hack.blogspot.com/
          https://dev.gentoo.org/~mpagano/genpatches/
          http://algo.ing.unimo.it/people/paolo/disk_sched/
	  http://cchalpha.blogspot.com/search/label/PDS
	  https://cchalpha.blogspot.com/search/label/BMQ
	  http://www1.informatik.uni-erlangen.de/tresor
	  https://rocm.github.io/
          "

K_MAJOR_MINOR="5.2"
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
K_GENPATCHES_VER="2"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="5.0"
PATCH_PDS_VER="099o"
PATCH_BFQ_VER="5.2"
PATCH_TRESOR_VER="3.18.5"
PATCH_BMQ_VER="098"
PATCH_BMQ_MAJOR_MINOR="5.2"
DISABLE_DEBUG_V="1.1"

# DC_VER 3.2.27 in drivers/gpu/drm/amd/display/dc/dc.h for ${PV}
# KMS_DRIVER 3.32.0 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c for ${PV}

AMD_STAGING_DRM_NEXT_LATEST="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_DIR="amd-staging-drm-next"

AMD_STAGING_DRM_NEXT_SNAPSHOT="412ef3eb157ed3096afb89597b1ca9afb9fd864b" # latest commit I tested which should be ideally head
# 2019-07-12 drm/amd/powerplay: add pstate mclk(uclk) support for navi10
AMD_STAGING_DRM_NEXT_STABLE="33e7fe16c02688478346e33f056f0a1f77fcedb1" # corresponds to 19.30 latest commit from amd-staging-drm-next
# 2019-07-11 drm/amdgpu: support key database loading for navi10

AMD_STAGING_DRM_NEXT_MILESTONE="e51341620d8958fdb950ff4e3513e8134b30c35b" # corresponds to the tagged commit:: 2019-06-10 drm/amd/display: 3.2.35

ROCK_DIR="ROCK-Kernel-Driver"
# ROCK_BASE should match ${PV}'s DC_VER
ROCK_BASE="be24e5a1149ddf4f4d97cafe5d82e868b2748e53" # 2019-04-08 drm/amd/display: 3.2.27
## commit below pulls additional commits that 3.2.27 depends on that were missing
#ROCK_BASE="" #
# before .program_vline_interrupt = optc1_program_vline_interrupt,
ROCK_SNAPSHOT="b639e86df2f3456976ccbc089778245a705ff9ef" # corresponds to master snapshot at 2019-04-24 Revert "drm/amdgpu: re-enable retry faults"
ROCK_MILESTONE="d529f2173a45572dd517a7f53fcfda82a10e5ac5" # corresponds to snapshot of roc-2.6.0
ROCK_LATEST="master"

# The intersection is defined to be the newer commit of rock_xxxx that intersects amd-staging-drm-next

# The intersection is not in perfect sync or easy to determine.  We will get the bulk of the amd-staging-drm-next and worry about the corner case which is the intersection.
# The deviation from the intersection could be months.

# Scan the git history logs (https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/commits/master/ and https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next) starting from ROCK-Kernel-Driver's
# "drm/amd/display: 3.2.24" [same as min common DC_VER for amd-staging-drm-next (3.2.35) and ROCK-Kernel-Driver (3.2.24)] till you find the last sequential commits.  Get the commit hash from amd-staging-drm-next.
# A 2019-03-15 drm/amd/display: fix odm output gamma programming

# Scan the git history logs (https://github.com/torvalds/linux/commits/v5.2/ and https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next) starting from linus' tag of v5.2 for "drm/amd/display: 3.2.27" [same as the kernel's DC_VER]
# till you find the last sequential commits before 3.2.28.  Get the commit hash from amd-staging-drm-next.
# B 2019-05-16 Merge tag 'drm-next-2019-05-16' of git://anongit.freedesktop.org/drm/drm

AMD_STAGING_LATEST_INTERSECTS_ROCK_LATEST="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_LATEST="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_LATEST="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A

AMD_STAGING_LATEST_INTERSECTS_ROCK_SNAPSHOT="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_SNAPSHOT="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_SNAPSHOT="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A

AMD_STAGING_LATEST_INTERSECTS_ROCK_MILESTONE="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_MILESTONE="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_MILESTONE="4f366c6bc25e666f237f1a336a31686a4490eef2" # corresponds to A

AMD_STAGING_INTERSECTS_5_X="cc7ce90153e74f8266eefee9fba466faa1a2d5df" # corresponds to B

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
	     rock-latest? ( !rock-snapshot !rock-milestone )
	     rock-snapshot? ( !rock-latest !rock-milestone )
	     rock-milestone? ( !rock-latest !rock-snapshot )"

# no released patch yet
REQUIRED_USE+=" !pds !muqss"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs versionator
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="rock-latest? ( dev-vcs/git )
	rock-snapshot? ( dev-vcs/git )
	rock-milestone? ( dev-vcs/git )
	amd-staging-drm-next-snapshot? ( dev-vcs/git )
	amd-staging-drm-next-latest? ( dev-vcs/git )
	amd-staging-drm-next-milestone? ( dev-vcs/git )
	dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates, ROCK-Kernel-Driver, amd-staging-drm-next, TRESOR"

BMQ_FN="v${PATCH_BMQ_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch"
BMQ_BASE_URL="https://gitlab.com/alfredchen/bmq/raw/master/${PATCH_BMQ_MAJOR_MINOR}/"
BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.diff"
BMQ_SRC_URL="${BMQ_BASE_URL}${BMQ_FN}
	     https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}
            "

ROCKREPO_URL="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver.git"
AMDREPO_URL="git://people.freedesktop.org/~agd5f/linux"
AMD_PATCH_FN="${AMD_STAGING_DRM_NEXT_DIR}.patch"

UKSM_BASE="https://raw.githubusercontent.com/dolohow/uksm/master/v${PATCH_UKSM_MVER}.x/"
UKSM_FN="uksm-${PATCH_UKSM_VER}.patch"
UKSM_SRC_URL="${UKSM_BASE}${UKSM_FN}"

ZENTUNE_URL_BASE="https://github.com/torvalds/linux/compare/v${PATCH_ZENTUNE_VER}...zen-kernel:${PATCH_ZENTUNE_VER}/"
ZENTUNE_REPO="zen-tune"
ZENTUNE_FN="${ZENTUNE_REPO}-${PATCH_ZENTUNE_VER}.diff"
ZENTUNE_DL_URL="${ZENTUNE_URL_BASE}${ZENTUNE_REPO}.diff"
ZENTUNE_SRC_URL="${ZENTUNE_DL_URL} -> ${ZENTUNE_FN}"

O3_SRC_URL="https://github.com/torvalds/linux/commit/"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT}.diff"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT}.diff"
O3_CO_DL_FN="${PATCH_O3_CO_COMMIT}.diff"
O3_RO_DL_FN="${PATCH_O3_RO_COMMIT}.diff"
O3_CO_SRC_URL="${O3_SRC_URL}${O3_CO_DL_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URL="${O3_SRC_URL}${O3_RO_DL_FN} -> ${O3_RO_FN}"

GRAYSKY_DL_4_9_FN="enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch"
GRAYSKY_DL_8_1_FN="enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_URL_BASE="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/"
GRAYSKY_SRC_4_9_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_4_9_FN}"
GRAYSKY_SRC_8_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_8_1_FN}"

CK_URL_BASE="http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

PDS_URL_BASE="https://gitlab.com/alfredchen/PDS-mq/raw/master/${PATCH_PDS_MAJOR_MINOR}/"
PDS_FN="v${PATCH_PDS_MAJOR_MINOR}_pds${PATCH_PDS_VER}.patch"
PDS_SRC_URL="${PDS_URL_BASE}${PDS_FN}"

GENPATCHES_URL_BASE="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_BASE_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXTRAS_FN}"

BFQ_FN="bfq-${PATCH_BFQ_VER}.diff"
BFQ_REPO="bfq-backports"
BFQ_DL_URL="https://github.com/torvalds/linux/compare/v${PATCH_BFQ_VER}...zen-kernel:${PATCH_BFQ_VER}/${BFQ_REPO}.diff"
BFQ_SRC_URL="${BFQ_DL_URL} -> ${BFQ_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_VER}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_VER}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_AESNI_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_AESNI_FN}"
TRESOR_I686_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_I686_FN}"
TRESOR_SYSFS_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_SYSFS_FN}"
TRESOR_README_DL_URL="https://www1.informatik.uni-erlangen.de/tresor?q=content/readme"
TRESOR_SRC_URL="${TRESOR_README_DL_URL} -> ${TRESOR_README_FN}"

gen_kernel_seq()
{
	# 1-2 2-3 3-4
	local s=""
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" $s $((${to}-1))-${to}"
	done
	echo $s
}

KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(get_version_component_range 3 ${PV})))
KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/patch-${K_MAJOR_MINOR}.1.xz"

KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})

#	 ${PDS_SRC_URL}
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
	 ${GENPATCHES_EXTRAS_SRC_URL}
	 ${TRESOR_AESNI_DL_URL}
	 ${TRESOR_I686_DL_URL}
	 ${TRESOR_SYSFS_DL_URL}
	 ${TRESOR_README_DL_URL}
	 ${TRESOR_SRC_URL}
	 ${UKSM_SRC_URL}
	 ${KERNEL_PATCH_URLS[@]}
	 "
#	 ${GENPATCHES_EXPERIMENTAL_SRC_URL}

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 100"

pkg_setup() {
	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi

	#use deblob && python-any-r1_pkg_setup
        kernel-2_pkg_setup

	if use tresor ; then
		ewarn "TRESOR is broken for ${PV}.  Use 4.9.x series.  For ebuild devs only."
	fi

	if is_rock ; then
		ewarn "Patching with rock is broken.  For ebuild devs only."

		einfo ""
		einfo "You need PCIe 3.0 or a GPU that doesn't require PCIe atomics to use ROCK."
		einfo "See needs_pci_atomics field for your GPU family in"
		einfo "https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/master/drivers/gpu/drm/amd/amdkfd/kfd_device.c"
		einfo "for the exception.  For supported CPUs see"
		einfo "https://rocm.github.io/hardware.html"
	fi

	if is_amd_staging_drm_next ; then
		ewarn "Patching with amd-staging-drm-next is broken.  For ebuild devs only."
	fi
}

function _dpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}"
	patch ${patchops} -i ${path} || die
}

function _tpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}..."
	patch ${patchops} -i ${path} || true
}

function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"
	# the header patches fine with patch -N
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.1-fixes.patch" # for reuse_ksm_page
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.2-fixes.patch" # for mmu_notifier_range_init changes related to 6f4f13e8d9e27cefd2cd88dd4fd80aa6d68b9131 and ksm.c
}

function apply_bfq() {
	_dpatch "${PATCH_OPS} -N" "${T}/${BFQ_FN}"
}

function apply_zentune() {
	_dpatch "${PATCH_OPS} -N" "${T}/${ZENTUNE_FN}"
}

function apply_genpatch_base() {
	einfo "Applying genpatch base"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" "${S}"/Makefile || die

	# genpatches places kernel incremental patches starting at 1000
	for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
		local f="${T}/${a}"
		cd "${T}"
		unpack "$a.xz"
		cd "${S}"
		patch --dry-run ${PATCH_OPS} -N "${f}" | grep "FAILED at"
		if [[ "$?" == "1" ]] ; then
			# already patched or good
			_tpatch "${PATCH_OPS} -N" "${f}"
		else
			eerror "Failed ${l}"
			die
		fi
	done

	sed -r -i -e "s|EXTRAVERSION =|EXTRAVERSION = ${EXTRAVERSION}|" "${S}"/Makefile || die

	cd "${S}"

	_tpatch "${PATCH_OPS} -N" "$d/1500_XATTR_USER_PREFIX.patch"
	_tpatch "${PATCH_OPS} -N" "$d/1510_fs-enable-link-security-restrictions-by-default.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2600_enable-key-swapping-for-apple-mac.patch"
}

function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	# don't need since we apply upstream
}

function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXTRAS_FN}"

	cd "${S}"

	_tpatch "${PATCH_OPS} -N" "$d/4567_distro-Gentoo-Kconfig.patch"
}

function apply_o3() {
	cd "${S}"

	# fix patch
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" ${DISTDIR}/${O3_CO_FN} > ${T}/${O3_CO_FN} || die

	einfo "Applying O3"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	einfo "Applying ${O3_CO_FN}"
	_tpatch "${PATCH_OPS}" "${T}/${O3_CO_FN}"
	einfo "Applying fix for ${O3_CO_FN}"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/O3-config-option-a56a17374772a48a60057447dc4f1b4ec62697fb-fix-for-5.1.patch"
	einfo "Applying ${O3_RO_FN}"
	touch drivers/gpu/drm/amd/display/dc/basics/logger.c # trick patch for unattended patching
	_tpatch "-p1 -N" "${DISTDIR}/${O3_RO_FN}"
}

function apply_pds() {
	cd "${S}"
	einfo "Applying pds"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${PDS_FN}"
}

function apply_bmq() {
	cd "${S}"
	einfo "Applying bmq"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_FN}"
	if use bmq-quick-fix ; then
		# Upstream tends to add quick fixes immediately after releases, so this use flag exists.
		# See http://cchalpha.blogspot.com/2019/06/bmq-096-release.html?showComment=1560096391712#c540582441437278845 .
		_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_QUICK_FIX_FN}"
	fi
}

function apply_tresor() {
	cd "${S}"
	einfo "Applying tresor"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local platform
	if use tresor_aesni ; then
		platform="aesni"
	fi
	if use tresor_i686 || use tresor_x86_64 ; then
		platform="i686"
	fi

	_tpatch "${PATCH_OPS}" "${DISTDIR}/tresor-patch-${PATCH_TRESOR_VER}_${platform}"
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

function fetch_bfq() {
	einfo "Fetching bfq patch from live source..."
	wget -O "${T}/${BFQ_FN}" "${BFQ_DL_URL}" || die
}

function fetch_zentune() {
	einfo "Fetching zentune patch from live source..."
	wget -O "${T}/${ZENTUNE_FN}" "${ZENTUNE_DL_URL}" || die
}

function fetch_amd_staging_drm_next() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning amd-staging-drm-next project"
		git clone ${AMDREPO_URL} "${d}"
		cd "${d}"
		git checkout master
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
	else
		einfo "Updating amd-staging-drm-next project"
		cd "${d}"
		git clean -fdx
		git checkout master
		git reset --hard master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}"
}

function fetch_amd_staging_drm_next_commits() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}"

	local target
	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_STAGING_DRM_NEXT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_STAGING_DRM_NEXT_LATEST}"
	elif use amd-staging-drm-next-milestone ; then
		target="${AMD_STAGING_DRM_NEXT_MILESTONE}"
	else
		target="${AMD_STAGING_DRM_NEXT_STABLE}"
	fi

	# base is not inclusive
	local base
	if   use amd-staging-drm-next-latest && use rock-latest ; then
		einfo "amd-staging-drm-next-latest and rock-latest"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_LATEST}"
	elif use amd-staging-drm-next-snapshot && use rock-latest ; then
		einfo "amd-staging-drm-next-snapshot and rock-latest"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_LATEST}"
	elif use amd-staging-drm-next-milestone && use rock-latest ; then
		einfo "amd-staging-drm-next-snapshot and rock-latest"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_LATEST}"

	elif use amd-staging-drm-next-latest && use rock-snapshot ; then
		einfo "amd-staging-drm-next-latest and rock-snapshot"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_SNAPSHOT}"
	elif use amd-staging-drm-next-snapshot && use rock-snapshot ; then
		einfo "amd-staging-drm-next-snapshot and rock-snapshot"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_SNAPSHOT}"
	elif use amd-staging-drm-next-milestone && use rock-snapshot ; then
		einfo "amd-staging-drm-next-snapshot and rock-snapshot"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_SNAPSHOT}"

	elif use amd-staging-drm-next-latest && use rock-milestone ; then
		einfo "amd-staging-drm-next-latest and rock-milestone"
		base="${AMD_STAGING_LATEST_INTERSECTS_ROCK_MILESTONE}"
	elif use amd-staging-drm-next-snapshot && use rock-milestone ; then
		einfo "amd-staging-drm-next-snapshot and rock-milestone"
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_MILESTONE}"
	elif use amd-staging-drm-next-milestone && use rock-milestone ; then
		einfo "amd-staging-drm-next-snapshot and rock-milestone"
		base="${AMD_STAGING_MILESTONE_INTERSECTS_ROCK_MILESTONE}"

	elif is_amd_staging_drm_next && ! is_rock ; then
		einfo "amd-staging-drm-next-* and ${K_PATCH_XV}"
		# use 5.1.x
		base="${AMD_STAGING_INTERSECTS_5_X}"
	else
		die "cannot handle case"
	fi

	mkdir -p "${T}/amd-staging-drm-next-patches"
	if ! is_rock ; then
		#_get_amd_staging_drm_next_commit 1 94a4ffd1d40b845dd19f9fdbb2cb6bf32de0946b # 2018-08-27 drm/amd/display: fix PIP bugs on Dal3
		_get_amd_staging_drm_next_commit 1 5eb8c8c5871fa6f10236ecd67005bb0659c15d11 # 2019-02-19 drm/amdgpu: replace get_user_pages with HMM mirror helpers
		_get_amd_staging_drm_next_commit 2 6b8f7e3dee7883084932bbdfce471a2960c6db5d # 2019-03-19 drm/amdgpu: fix HMM config dependency issue
		#_get_amd_staging_drm_next_commit 3 3e70b04ab7874670e65c688f89ce210a6a482de6 # 2019-02-19 drm/amdgpu: use HMM callback to replace mmu notifier # already pulled later
		#_get_amd_staging_drm_next_commit 3 02205685e319bf6507feb95b1ee2ce3fb51fa60d # 2019-02-20 drm/amd/display: PPLIB Hookup # already applied
		_get_amd_staging_drm_next_commit 4 1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b # 2019-02-19 drm/amdkfd: avoid HMM change cause circular lock
		_get_amd_staging_drm_next_commit 5 e8074f75f4449b9f9315f3a81d5d72425fba0a8c # 2019-03-14 drm/v3d: Fix calling drm_sched_resubmit_jobs for same sched.
		n="6"
	else
		n="1"
	fi

	einfo "Saving only the amd-staging-drm-next commits for commit-by-commit evaluation."
	L=$(git log ${base}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	for l in $L ; do
	        einfo "$n $l"
		printf -v pn "%06d" ${n}
	        git format-patch --stdout -1 $l > "${T}"/amd-staging-drm-next-patches/${pn}-$l.patch
	        n=$((n+1))
	done
	#bef7f3fbb1ae4f48917559de8870506a653dd7ce

	# ignore missing commit
	# ffae3e 2019-05-24 drm/scheduler: rework job destruction
	local idx=$(get_patch_index "amd-staging-drm-next-patches" "ffae3e510d66ba854289f2cdff8a119ecd7f4ded")
	printf -v pidx "%06d" ${idx}
	[ ! -e ${T}/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch ] && die "can't find"
	filterdiff -x */lima_sched.c ${T}/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch > ${T}/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch.1 || die
	mv ${T}/amd-staging-drm-next-patches/${pidx}-ffae3e510d66ba854289f2cdff8a119ecd7f4ded.patch{.1,} || die
}

function _get_rock_commit()
{
	local index="${1}"
	local commit="${2}"
	local postfix="${3}"
	printf -v pindex "%06d" ${index}
	git format-patch --stdout -1 ${commit} > "${T}"/rock-patches/${pindex}${postfix}-${commit}.patch || die
}

function _get_amd_staging_drm_next_commit()
{
	local index="${1}"
	local commit="${2}"
	printf -v pindex "%06d" ${index}
	git format-patch --stdout -1 ${commit} > "${T}"/amd-staging-drm-next-patches/${pindex}-${commit}.patch || die
}

function fetch_rock() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning ROCK project"
		git clone ${ROCKREPO_URL} "${d}"
		cd "${d}"
		git checkout master
	else
		einfo "Updating ROCK project"
		cd "${d}"
		git clean -fdx
		git checkout master
		git reset --hard master
		git pull
	fi
	cd "${d}"
}

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
	idx=$(echo ${f} | cut -c 1-6)
	if [[ "${f}" != "${idx}${commit_b_postfix_after}-${commit_b}.patch" ]] ; then
		mv "${d}"/${f} "${d}"/${idx}${commit_b_postfix_after}-${commit_b}.patch
	fi
	_get_rock_commit $(echo ${idx} | sed 's/^0*//') ${commit_a} "${commit_a_postfix}"
	sha1sum "${d}"/${idx}${commit_a_postfix}-${commit_a}.patch | cut -c 1-40 >> "${T}"/hashes
}

function move_rock_commit() {
	# a followed by b
	local commit="${1}"
	local postfix_before="${2}"
	local postfix_after="${3}"
	d="${T}/rock-patches"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${postfix_before}*${commit}*))
	idx=$(echo ${f} | cut -c 1-6)
	einfo "idx=${idx} f=${f}"
	mv "${d}"/${f} "${d}"/${idx}${postfix_after}-${commit}.patch || die
	einfo "Moved to ${idx}${postfix_after}-${commit}.patch"
}

function get_patch_index() {
	local patchset_name="${1}"
	local commit="${2}"
	d="${T}/${patchset_name}"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${commit}*))
	idx=$(echo ${f} | cut -c 1-6 | sed 's/^0*//')
	echo ${idx}
}

function fetch_rock_commits() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
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

	einfo "Saving only the AMD ROCK commits for commit-by-commit evaluation."
	L=$(git log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | \
			cut -c 1-40 | tac)
	mkdir -p "${T}/rock-patches"

	n="${NEXT_ROCK_COMMIT}"

	prepend_rock_commit "bf96e47b4474f992095d9fae9ccfc46633bf4343" "9c75d5a887d1d5f5815019c105e2ea25a2c9c823" "a" "" "b"
	# bf96e drm/amdgpu: Bring back support for non-upstream FreeSync
	# 9c75d  drm/amdkcl: [4.12] Kcl for drm old/new state iterator and get_old/new/_crtc_state before sw commit

	#prepend_rock_commit "bf96e47b4474f992095d9fae9ccfc46633bf4343" "f331d74dad4358369a6dfb182ff0a5607a8e7b04" "a" "" "b"
	## bf96e drm/amdgpu: Bring back support for non-upstream FreeSync
	## f331d drm/amdgpu: [hybrid] add direct gma(dgma) support

	local p
	for l in $L ; do
	        einfo "$n $l"
		printf -v pn "%06d" ${n}
		p="${T}"/rock-patches/${pn}-$l.patch
	        git format-patch --stdout -1 $l > "${T}"/rock-patches/${pn}-$l.patch
		h=$(sha1sum ${p} | cut -c 1-40)

		# avoid adding duplicates
		grep -F -e "${h}" "${T}"/hashes > /dev/null
		if [[ "$?" == "1" ]] ; then
		        n=$((n+1))
		else
			einfo "Found dupe $(basename ${p} | cut -c 8-47)"
			rm "${p}" || die
		fi
	done
}

function get_missing_rock_commits_list() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local index

	index=1
	d_staging="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d_staging}"
	einfo "Generating commit list for amd-staging-drm-next."
	git log --reverse --pretty=tformat:"%H %s" > "${T}"/amd-staging-drm-next.commits

	cat /dev/null > "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
	L=$(cat "${T}"/amd-staging-drm-next.commits)
	IFS=$'\n'
	A=""
	for l in ${L} ; do
		printf -v pindex "%06d" ${index}
		echo "${pindex} ${l}" >> "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
		index=$((${index} + 1))
	done
	unset IFS

	index=1
	d_rock="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	cd "${d_rock}"
	einfo "Generating commit list for ROCK."
	git log --reverse --pretty=tformat:"%H %s" > "${T}"/rock.commits

	cat /dev/null > "${T}"/rock.commits.indexed.${PVR}
	L=$(cat "${T}"/rock.commits)
	IFS=$'\n'
	A=""
	for l in ${L} ; do
		printf -v pindex "%06d" ${index}
		echo "${pindex} ${l}" >> "${T}"/rock.commits.indexed.${PVR}
		index=$((${index} + 1))
	done
	unset IFS

	cat "${T}"/amd-staging-drm-next.commits.indexed.${PVR} | cut -c 49- | sort > "${T}"/amd-staging-drm-next.summaries
	cat "${T}"/rock.commits.indexed.${PVR} | cut -c 49- | sort > "${T}"/rock.summaries

	einfo "Comparing commit lists"
	diff -urp "${T}"/rock.summaries "${T}"/amd-staging-drm-next.summaries > "${T}"/results
	grep -e "^-" "${T}"/results | cut -c 2- > "${T}"/results.no-dash
}

function get_missing_rock_commits() {
	local commit
	mkdir -p "${T}"/rock-patches
	local index

	OIFS=${IFS}
	IFS=$'\n'
	L=$(cat "${T}"/results.no-dash)

	cat /dev/null > "${T}"/rock.found

	einfo "Picking commits"
	for l in ${L} ; do
		grep -F -e "${l}" "${T}/rock.commits.indexed.${PVR}" >> "${T}/rock.found"
	done

	cat "${T}"/rock.found | sort | uniq > "${T}"/rock.found.sorted

	cat /dev/null > "${T}"/hashes
	C=$(cat "${T}"/rock.found.sorted | cut -c 8-47)
	einfo "Generating commits"
	index=1
	local p
	for c in ${C} ; do
		einfo "$index ${c}"
		printf -v pindex "%06d" ${index}
		p="${T}"/rock-patches/${pindex}-${c}.patch
		git format-patch --stdout -1 ${c} > "${p}" || die
		sha1sum ${p} | cut -c 1-40 >> "${T}"/hashes
		index=$((index + 1))
	done
	export NEXT_ROCK_COMMIT="${index}"
	IFS="${OIFS}"
	einfo "NEXT_ROCK_COMMIT=${NEXT_ROCK_COMMIT}"
}

function fetch_staging_with_rock() {
	if is_amd_staging_drm_next ; then
		fetch_amd_staging_drm_next
	fi
	if is_rock ; then
		fetch_rock

		get_missing_rock_commits_list
		get_missing_rock_commits
	fi
}

function is_rock() {
	if use rock-snapshot || use rock-latest || use rock-milestone ; then
		return 0
	else
		return 1
	fi
}

function is_amd_staging_drm_next() {
	if use amd-staging-drm-next-snapshot || use amd-staging-drm-next-latest || use amd-staging-drm-next-milestone ; then
		return 0
	else
		return 1
	fi
}

function apply_amdgpu() {
	fetch_staging_with_rock

	if is_rock ; then
		fetch_rock_commits
		cd "${S}"
		L=$(ls -1 "${T}"/rock-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/rock-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*e8639130ca069a27acc9efd7b71de1b1183fedd8*)
						# fix kfd_doorbell_vm_fault
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-e8639130ca069a27acc9efd7b71de1b1183fedd8-fix-for-linux-5.1.4.patch"
						;;
					*a703e062643f7fc299e8a13da025a1d6d3e660b1*)
						# parts already applied
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-a703e062643f7fc299e8a13da025a1d6d3e660b1-fix.patch"
						;;
					*9c75d5a887d1d5f5815019c105e2ea25a2c9c823*)
						# add missing part to patch
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-9c75d5a887d1d5f5815019c105e2ea25a2c9c823-fix-for-linux-5.1.4.patch"
						;;
					*816ebd64c1afdd6befaa8d8938e88087edfb5456*)
						# redid
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-816ebd64c1afdd6befaa8d8938e88087edfb5456-fix.patch"
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*7d747bad71d72d0201603e796c7056c09d25d89f*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-7d747bad71d72d0201603e796c7056c09d25d89f-fix-for-linux-5.1.4.patch"
						;;
					*a1be09e2817415a3895b7f28fd7fe589ef9feed4*|\
					*e45d1970b20cb5d8dc9d0a6a9106fc79e0e77e5e*|\
					*86f6dd1570da50f251e3be75bf0b6b4d6569a8f4*|\
					*e2263ebec8e63ee717bcba0814d95d58cd01f24f*|\
					*df11ff163bdb2044ef065b1fed4279add3c4467b*|\
					*6039db78b84f29b139b1b322ba22d2533a917176*|\
					*afd27cb14a2f02036fe50e74dbb1c1de16a842a1*|\
					*13af41ffc770c1d8d5b14cfb2e2e9af3686ec641*|\
					*6d024da0c04e5773035da655a9565076efcfe450*|\
					*bc6f1b9f1dd933d10629b008581d4a896568995c*|\
					*b9e3f8cf2dffaeb2e78fdda1d46135e1c717d99a*|\
					*fde9186cb498d7c88825989d642cdcafcb7f5084*|\
					*467b936fa96e1499c0f3eee7d101d88918c54faa*|\
					*70023b1c6c90d16fb19caae23b215a0bd68d0072*|\
					*d37cef24547645e5aeb45036114342dfd15b8418*|\
					*726817c26335f534c79d5fa74cf48fc120d7486e*|\
					*a998e6220284191cd48dbb40d0d8b72a2a056e37*|\
					*925da7afcb540ab42ac8c9fc0d9f7f699a832d66*|\
					*3e70b04ab7874670e65c688f89ce210a6a482de6*|\
					*5eb8c8c5871fa6f10236ecd67005bb0659c15d11*|\
					*e1803f2f16251964db33bdbebfd5ed253db53ae9*|\
					*1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b*|\
					*ab829777dc809eec1226913249f759b818237849*|\
					*1e6f9843e8151706a0da2925145f575920678f9c*|\
					*36394f28027839bfea67772715802dffa9288d38*|\
					*2879b8edac1dc148c781ade8c374399c6785a825*)
						# a1be0 already applied
						# e45d1 it disappears in latest
						# 86f6d not required, version compat, skip
						# e2263 not required, version compat, skip
						# df11f not required, version compat, skip
						# 6039d not required, version compat, skip
						# afd27 not required, version compat, skip (temporary ignore, may need to revisit since I don't see the pattern.)
						# 13af4 not required, version compat, skip
						# 6d024 not required, version compat, skip
						# bc6f1 already applied
						# b9e3f not required, version compat, skip
						# fde91 may not be required, version compat, likely skip but missing parts
						# 467b9 not required, version compat, skip
						# 70023 it disappears in latest
						# d37ce already applied
						# 72681 some parts not applied in final or missing parts don't exist
						# a998e missing parts or outdated backport
						# 925da missing parts or outdated backport
						# 3e70b gets reverted
						# 5eb8c gets reverted
						# e1803 already applied reversion
						# 1c033 gets reverted
						# ab829 already applied reversion
						# 1e6f9 already applied but in a different way
						# 36394 not required, version compat, skip
						# 2879b already applied
						;;
					*7bd1d22945d8927c882b7dcbca5cc503d0d7f007*)
						# adapted from amd-staging-drm-next
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7bd1d22945d8927c882b7dcbca5cc503d0d7f007-fix-for-linux-5.1.patch"
						;;
					*4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8*)
						# redid full patch
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8-fix.patch"
						;;
					*d6e22eaa160e455ca53157c6f79ab2cd5b0b9800*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-d6e22eaa160e455ca53157c6f79ab2cd5b0b9800-fix.patch"
						;;
					*1254b5fe6aaabb58300a5929b6bb290bf1c49f63*)
						# parts of patch already applied and patched missing part
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-1254b5fe6aaabb58300a5929b6bb290bf1c49f63-fix.patch"
						;;
					*8098a2f9c3ba6fba0055aa88d3830bbec585268b*)
						# parts already patched
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						;;
					*bdca2f6e470b8e6c1cab75f80e9b01f06b0376da*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-bdca2f6e470b8e6c1cab75f80e9b01f06b0376da-fix.patch"
						;;
					*686bea628e37dd279a3b34a890f66fa42d46f40a*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-686bea628e37dd279a3b34a890f66fa42d46f40a-fix.patch"
						;;
					*6abe8339ca1f77c3d86146e8ce91e4f56a852a65*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-6abe8339ca1f77c3d86146e8ce91e4f56a852a65-fix.patch"
						;;
					*)
						eerror "Patch failure ${l}.  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if is_amd_staging_drm_next ; then
		fetch_amd_staging_drm_next_commits
		cd "${S}"
		L=$(ls -1 "${T}"/amd-staging-drm-next-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-staging-drm-next-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*e49f69363adf8920883fff7e8ffecb802d897c6b*)
						# already partially applied but one chunk didn't apply
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-e49f69363adf8920883fff7e8ffecb802d897c6b-fix.patch"
						;;
					*f55be0be5b7296e73f1634e2839a1953dc12d11e*)
						# fix mispatch
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-f55be0be5b7296e73f1634e2839a1953dc12d11e-fix-2.patch"
						;;
#					*7d8865d9e8600701fedceb76f16e8287553a52e9*)
#						# 7d8865 5.2 kernel only
#						;;
					*96b44440a670e9b329ae94c0b292fc8441d0ba81*)
						# mispatch
						if is_rock ; then
							# fix mispatch
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-96b44440a670e9b329ae94c0b292fc8441d0ba81-fix-mispatch.patch"
						else
							_dpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# should work fine
						fi
						;;
					*c55b6c3d4c9b3fc2b423a6e390b620066ddf1e0c*)
						if is_rock ; then
							# fix mispatch
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-c55b6c3d4c9b3fc2b423a6e390b620066ddf1e0c-fix.patch"
						else
							_dpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# looks like it works fine
						fi
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*1bff7f6c679fb605d2d3fae77c9dd8d4cbad92b9*)
						# 1 chunk disappears, in latest.  ignore it.
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						;;
					*0921c41e19028314830b33daa681e46b46477c5e*|\
					*915d3eecfa23693bac9e54cdacf84fb4efdcc5c4*|\
					*899fbde1464639e3d12eaffdad8481a59b367fcb*)
						# 0921c doesn't exist in final
						# 915d3 already applied
						# 899fb already applied
						;;
					*8628d02f60d4a568d02fc12a26273a55f7718ec0*)
						if is_rock ; then
							# fixme
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						else
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-8628d02f60d4a568d02fc12a26273a55f7718ec0-fix.patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*2c5a51f57042f9d686d72b96a41eb81dbfb86a64*)
						if is_rock ; then
							# fixme
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						else
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-2c5a51f57042f9d686d72b96a41eb81dbfb86a64-fix.patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*baf2289cda05bf9c8b2a156a87a11f703159bec9*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-baf2289cda05bf9c8b2a156a87a11f703159bec9-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*2b5db50a2ec201acb6316eebdde8f156da8f70fc*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# most need to be applied except one
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*3cadf1f029a0a8ef91b9abfa8a12c91d99c64bee*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-3cadf1f029a0a8ef91b9abfa8a12c91d99c64bee-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*776df42de9f7714befff0e0bc0cb29e570c0605d*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-776df42de9f7714befff0e0bc0cb29e570c0605d-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*7968cbfa6959461e71e039fad6d480dfefab573b*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7968cbfa6959461e71e039fad6d480dfefab573b-fix.patch"
						else
							die "${l} need intervention patch"
							ewarn "testing"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*ae471b5535209bc38add7d2504463e4e25c6891a*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-ae471b5535209bc38add7d2504463e4e25c6891a-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*e8aee8084f49d6ccd4bec6fe770a0f10fcd22b4f*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-e8aee8084f49d6ccd4bec6fe770a0f10fcd22b4f-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*b999cb839ff2508d224942db2da6c065871539ee*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-b999cb839ff2508d224942db2da6c065871539ee-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*0e68dad5fc27f09e7b5039b4e35481ce4689ce2f*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-0e68dad5fc27f09e7b5039b4e35481ce4689ce2f-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*87ae89cca015539488fdeeb7628770574424f3a8*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-87ae89cca015539488fdeeb7628770574424f3a8-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*7e00e5d884c1dbff63600a10979f2f0dd598fdfc*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7e00e5d884c1dbff63600a10979f2f0dd598fdfc-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*686496f25d4b1b2ccf2f388a3d4afd5c08414f94*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-686496f25d4b1b2ccf2f388a3d4afd5c08414f94-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*d8c7144bbcae4ae7bfd0e6ec54208f625b15f502*|\
					*037f41cd2e01f395e5ef35048e316d4945d036b2*)
						if is_rock ; then
							# 037f41c avoid potential unnecessary patch
							# d8c7144 already applied
							continue
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*7bd1d22945d8927c882b7dcbca5cc503d0d7f007*) # 21
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7bd1d22945d8927c882b7dcbca5cc503d0d7f007-fix-for-linux-5.1.patch"
						;;
					*4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8*) # 25
						_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8-fix-for-linux-5.1.patch"
						;;
					*d4731305a287b4aa890dff42e819b494443eef09*) # 42
						# already added upstream in 5.1 kernel
						;;
					*e90c17872ba9af8879a936909d94477ecb89ebde*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# the -N switch manages to patch the header
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-e90c17872ba9af8879a936909d94477ecb89ebde-fix.patch"
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*c936ad50d179d675578f755726b9506e9f6fd7c1*)
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# the -N switch manages to patch the header
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-c936ad50d179d675578f755726b9506e9f6fd7c1-fix.patch"
							# some of the patch was removed from above patch because of -N
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*c6fcd3a65b9873e250aba0f5ab40838633145b10*)
						if is_rock ; then
							# already applied
							continue
						else
							ewarn "testing"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-c6fcd3a65b9873e250aba0f5ab40838633145b10-fix-for-linux-5.1.patch"
						fi
						;;
					*ab4f554d55931743a45ed9fccc8fda8c66f38079*)
						if is_rock ; then
							# already applied
							continue
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*3cdc2f9ca0cd9d3d0143bfce07d7ceacf0a86a58*) # 605
						if is_rock ; then
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							# -N will patch some
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-3cdc2f9ca0cd9d3d0143bfce07d7ceacf0a86a58-fix-for-linux-5.1-rock.patch"
							# some of the patch was removed from above patch because of -N
						else
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
							_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-3cdc2f9ca0cd9d3d0143bfce07d7ceacf0a86a58-fix-for-linux-5.1.patch"
						fi
						;;
					*288b883a67126a7c251fb1222e1b9d7a6485d46c*) # 620
						if is_rock ; then
							# not needed eventually both in ROCK-Kernel-Driver and amd-staging-drm-next heads
							true
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*86e62fe3d7b7edb949b44200607a12645da494f7*|\
					*7fb91961f073edb64bc9ac1dfa55916931fa4e3d*|\
					*7a71ad2b707c27f0bac27774facd6edb8386b58c*)
						# 86e62 may have been already applied
						# 7fb91 may have been already applied
						if is_rock ; then
							# already applied
							true
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					*)
						eerror "Patch failure ${l}.  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if is_amd_staging_drm_next ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-feb13542aca1d60c37d01a661b54dc0dae46ed6e-dedupe.patch"
	fi
}

src_unpack() {
	#if use zentune ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${ZENTUNE_FN}"
	#fi
	#if use uksm ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${UKSM_FN}"
	#fi
	if use muqss ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${CK_FN}"
	fi
	if use graysky2 ; then
		if $(version_is_at_least 8.1 $(gcc-version)) ; then
			einfo "gcc patch is 8.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_8_1_FN}"
		else
			einfo "gcc patch is 4.9"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_4_9_FN}"
		fi
	fi
	#if use bfq ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${BFQ_FN}"
	#fi

	kernel-2_src_unpack

	cd "${S}"

	if use zentune ; then
		fetch_zentune
		apply_zentune
	fi

	if use uksm ; then
		apply_uksm
	fi

	if use bfq ; then
		fetch_bfq
		apply_bfq
	fi

	if use muqss ; then
		#_dpatch "${PATCH_OPS}" "${FILESDIR}/MuQSS-4.18-missing-se-member.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/muqss-dont-attach-ckversion.patch"
	fi

	if use pds ; then
		apply_pds
	fi

	if use bmq ; then
		apply_bmq
	fi

	apply_genpatch_base
	#apply_genpatch_experimental
	apply_genpatch_extras

	apply_amdgpu

	if use o3 ; then
		apply_o3
	fi

	if use tresor ; then
		apply_tresor
	fi

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
}

src_compile() {
	kernel-2_src_compile
	if use tresor_sysfs ; then
		cp -a "${DISTDIR}/tresor_sysfs.c" "${T}"
		cd "${T}"
		einfo "$(tc-getCC) ${CFLAGS}"
		$(tc-getCC) ${CFLAGS} tresor_sysfs.c -o tresor_sysfs || die
	fi
}

src_install() {
	# cleanup patch cruft
	find "${S}" -name "*.orig" -print0 -o -name "*.rej" -print0 | xargs -0 rm

	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst
	if use disable_debug ; then
		einfo "The disable debug scripts have been placed in your /usr/src folder."
		einfo "They disable debug paths, logging, output for a performance gain."
		einfo "You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`"
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

	if use tresor_sysfs ; then
		# prevent merge conflicts
		cd "${T}"
		mv tresor_sysfs "${EROOT}/usr/bin" || die
		chmod 700 "${EROOT}"/usr/bin/tresor_sysfs || die
		# same hash for 5.1 and 5.0.13 for tresor_sysfs
		einfo "/usr/bin/tresor_sysfs is provided to set your TRESOR key"
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

	if is_rock ; then
		einfo "You must enable HSA kernel driver for AMD GPU devices (CONFIG_HSA_AMD=y) to use ROCM and add your users to the video group."
	fi
}

pkg_postrm() {
	[ -e "${T}"/amd-staging-drm-next.commits.indexed.${PVR} ] && rm "${T}"/amd-staging-drm-next.commits.indexed.${PVR}
	[ -e "${T}"/rock.commits.indexed.${PVR} ] && rm "${T}"/rock.commits.indexed.${PVR}
}
