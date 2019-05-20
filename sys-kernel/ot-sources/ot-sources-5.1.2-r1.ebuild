# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.1...zen-kernel:5.1/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.0/5.0-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:		https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/bfq-backports
# AMD kernel updates:           https://cgit.freedesktop.org/~agd5f/linux/
# ROCK-Kernel-Driver		https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/
# TRESOR:			http://www1.informatik.uni-erlangen.de/tresor

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://github.com/dolohow/uksm
          https://liquorix.net/
          https://github.com/graysky2/kernel_gcc_dpatch
          http://users.on.net/~ckolivas/kernel/
          https://dev.gentoo.org/~mpagano/genpatches/
          http://algo.ing.unimo.it/people/paolo/disk_sched/
	  http://cchalpha.blogspot.com/search/label/PDS
	  https://cchalpha.blogspot.com/search/label/BMQ
	  http://www1.informatik.uni-erlangen.de/tresor
          "

K_MAJOR_MINOR="5.1"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.0"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.1"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.0"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="1"
PATCH_GP_MAJOR_MINOR_REVISION="5.1-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="5.0"
PATCH_PDS_VER="099o"
PATCH_BFQ_VER="5.0"
PATCH_TRESOR_VER="3.18.5"
PATCH_BMQ_VER="094"
PATCH_BMQ_MAJOR_MINOR="5.1"
DISABLE_DEBUG_V="1.1"

# KERNEL_COMMIT is not inclusive, but it pulls the next commit afterwards
KERNEL_COMMIT="bf71edb16c6fc40b12b2f748d2b907a85d10ca0a"
# 2019-02-19 Revert "drm/amdgpu: Delete user queue doorbell variables"

# included in 5.1.2:
# DC_VER 3.2.17 in drivers/gpu/drm/amd/display/dc/dc.h 2019-02-06
# KMS_DRIVER 3.30.0 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c 2019-02-21

AMD_STAGING_DRM_NEXT_LATEST="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_DIR="amd-staging-drm-next"
AMD_STAGING_DRM_NEXT_LAST="f7fa4d8745fce7db056ee9fa040c6e31b50f2389" # amd-19.10 branch latest commit equivalent
# 2019-04-17 drm/amdgpu: amdgpu_device_recover_vram got NULL of shadow->parent

AMD_STAGING_DRM_NEXT_SNAPSHOT="ca925147df370b66e3db7ae0cb3f90ffd5e16429" # latest commit I tested
# 2019-05-09 drm/amd/display: Make some functions static
AMD_STAGING_DRM_NEXT_STABLE="f7fa4d8745fce7db056ee9fa040c6e31b50f2389" # corresponds to 19.10 picked commit from latest amd-staging-drm-next
# 2019-04-17 drm/amdgpu: amdgpu_device_recover_vram got NULL of shadow->parent

AMD_STAGING_DRM_NEXT_MILESTONE="20a9e4ceb383dfe7cd73c16631d5966c0006f464" # corresponds to the commit before the current milestone:: drm/amd/display: 3.2.29
# 2019-05-06 drm/amd/display: Disable cursor when offscreen in negative direction

# the 19.10 is behind ROCK-Kernel-Driver in AMDGPU_VERSION defined in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
ROCK_DIR="ROCK-Kernel-Driver"
#ROCK_BASE="11dd3bb45bce45103a79c9f044cfa74d33f898c9" # 2019-01-25 drm/amd/display: 3.2.17
## KMS_DRIVER is 3.29.0 for DC_VER 3.2.17
ROCK_BASE="98c0172f3afd877554fde2db46f0541b1ab9e781" # 2019-01-25  drm/amd/display: Clear stream->mode_changed after commit
# before .program_vline_interrupt = optc1_program_vline_interrupt,
ROCK_SNAPSHOT="b639e86df2f3456976ccbc089778245a705ff9ef" # corresponds to master snapshot at 2019-04-24 Revert "drm/amdgpu: re-enable retry faults"
ROCK_MILESTONE="b639e86df2f3456976ccbc089778245a705ff9ef" # corresponds to snapshot of roc-2.4.0
ROCK_LATEST="master"

# The intersection is defined to be the newer commit of rock_xxxx that intersects amd-staging-drm-next

# The intersection is not in perfect sync or easy to determine.  We will get the bulk of the amd-staging-drm-next and worry about the corner case which is the intersection.
# The deviation from the intersection could be months.

# base addresses relative to ROCK-Kernel-Driver
# 'A 2019-04-01 drm/amdgpu: Add preferred_domain check when determine XGMI state ; or beyond DC_VER = 3.2.24; this is almost easy to sync.  most are accepted except about half of 3.2.25.

# 'B 2019-02-20 drm/amd/display: PPLIB Hookup ; start at DC_VER = 3.2.18 inclusive; this is difficult to sync because of the deviations.  It says 3.2.17, but it looks like most of 3.2.17 have been accepted, so start at 3.2.18.

AMD_STAGING_LATEST_INTERSECTS_ROCK_LATEST="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_LATEST="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_LATEST="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A

AMD_STAGING_LATEST_INTERSECTS_ROCK_SNAPSHOT="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_SNAPSHOT="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_SNAPSHOT="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A

AMD_STAGING_LATEST_INTERSECTS_ROCK_MILESTONE="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_SNAPSHOT_INTERSECTS_ROCK_MILESTONE="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A
AMD_STAGING_MILESTONE_INTERSECTS_ROCK_MILESTONE="2941c091ffe6ad7a891c7961d6548d9404b040c2" # corresponds to 'A

AMD_STAGING_LATEST_INTERSECTS_5_X="02205685e319bf6507feb95b1ee2ce3fb51fa60d" # corresponds to 'B
AMD_STAGING_SNAPSHOT_INTERSECTS_5_X="02205685e319bf6507feb95b1ee2ce3fb51fa60d" # corresponds to 'B
AMD_STAGING_MILESTONE_INTERSECTS_5_X="02205685e319bf6507feb95b1ee2ce3fb51fa60d" # corresponds to 'B

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

# no released patch for 5.1 yet
REQUIRED_USE+=" !muqss !pds !bfq"

# ebuild support still in development
#REQUIRED_USE+=" !rock-latest !rock-snapshot !rock-milestone"
#REQUIRED_USE+=" !amd-staging-drm-next-snapshot !amd-staging-drm-next-latest !amd-staging-drm-next-milestone"

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
	dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates, AMD kernel updates, TRESOR"

BMQ_FN="v${PATCH_BMQ_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch"
BMQ_BASE_URL="https://gitlab.com/alfredchen/bmq/raw/master/${PATCH_BMQ_MAJOR_MINOR}/"
BMQ_SRC_URL="${BMQ_BASE_URL}${BMQ_FN}
	     https://gitlab.com/alfredchen/linux-bmq/commit/c98f44724fac5c2b42d831f0ad986008420d13c2.diff
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
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
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
KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v5.x/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.1.1.xz"

KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
KERNEL_PATCH_FNS_EXT=(patch-5.1.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
KERNEL_PATCH_FNS_NOEXT=(patch-5.1.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})

#	 ${CK_SRC_URL}
#	 ${PDS_SRC_URL}
SRC_URI="
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

	addwrite /var/cache
	mkdir -p /var/cache/ot-sources
	addwrite /var/cache/ot-sources
	if [ ! -e /var/cache/ot-sources/amd-staging-drm-next.commits.indexed ] ; then
		cat /dev/null > /var/cache/ot-sources/amd-staging-drm-next.commits.indexed
		chmod 600 /var/cache/ot-sources/amd-staging-drm-next.commits.indexed || die
		chown portage:portage /var/cache/ot-sources/amd-staging-drm-next.commits.indexed || die
		export NEW_AMD_STAGING_DRM_NEXT_INDEX="1"
	else
		export NEW_AMD_STAGING_DRM_NEXT_INDEX="0"
	fi
	if [ ! -e /var/cache/ot-sources/rock.commits.indexed ] ; then
		cat /dev/null > /var/cache/ot-sources/rock.commits.indexed
		chmod 600 /var/cache/ot-sources/rock.commits.indexed || die
		chown portage:portage /var/cache/ot-sources/rock.commits.indexed || die
		export NEW_ROCK_INDEX="1"
	else
		export NEW_ROCK_INDEX="0"
	fi
	local date_amd_staging_drm_next
	local date_rock

	date_amd_staging_drm_next=$(date -r /var/cache/ot-sources/amd-staging-drm-next.commits.indexed +%s)
	date_rock=$(date -r /var/cache/ot-sources/rock.commits.indexed +%s)

	if (( $(date +%s) > ${date_amd_staging_drm_next}+604800 )) || [[ "${NEW_AMD_STAGING_DRM_NEXT_INDEX}" == "1" ]] ; then
		cat /dev/null > /var/cache/ot-sources/amd-staging-drm-next.commits.indexed || die
		export CACHED_AMD_STAGING_DRM_NEXT_INDEX="0"
		einfo "Clearing stale amd-staging-drm-next.commits.indexed"
	else
		export CACHED_AMD_STAGING_DRM_NEXT_INDEX="1"
		einfo "Using cached amd-staging-drm-next.commits.indexed"
		einfo "Remove /var/cache/ot-sources/amd-staging-drm-next.commits.indexed if you changed your use flags.  Data cached for 1 week."
	fi
	if (( $(date +%s) > ${date_rock}+604800 )) || [[ "${NEW_ROCK_INDEX}" == "1" ]] ; then
		cat /dev/null > /var/cache/ot-sources/rock.commits.indexed || die
		export CACHED_ROCK_INDEX="0"
		einfo "Clearing stale rock.commits.indexed"
	else
		export CACHED_ROCK_INDEX="1"
		einfo "Using cached rock.commits.indexed"
		einfo "Remove /var/cache/ot-sources/rock.commits.indexed if you changed your use flags.  Data cached for 1 week."
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

function remove_amd_fixes() {
	local d="$1"
}

function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"
	# the header patches fine with patch -N
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.1-fixes.patch" # for reuse_ksm_page
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
	unpack "${DISTDIR}/${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" "${S}"/Makefile || die

	# genpatches places kernel incremental patches starting at 1000
	for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
		local f="${T}/${a}"
		cd "${T}"
		unpack "${DISTDIR}/$a.xz"
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
	_tpatch "${PATCH_OPS} -N" "$d/2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2600_enable-key-swapping-for-apple-mac.patch"
}

function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	# don't need since we apply upstream
}

function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXTRAS_FN}"

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
		# See https://gitlab.com/alfredchen/bmq/issues/5 .
		# This issue wasn't an issue for me so it is optional.
		_dpatch "${PATCH_OPS}" "${DISTDIR}/c98f44724fac5c2b42d831f0ad986008420d13c2.diff"
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
		git clone -b ${AMD_STAGING_DRM_NEXT_DIR} ${AMDREPO_URL} "${d}"
	else
		einfo "Updating amd-staging-drm-next project"
		cd "${d}"
		git pull
	fi
	cd "${d}"
}

function fetch_amd_staging_drm_next_commits() {
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

	elif use amd-staging-drm-next-latest && ! use rock-latest && ! use rock-milestone ; then
		einfo "amd-staging-drm-next-latest and 5.x"
		# use 5.1.x
		base="${AMD_STAGING_LATEST_INTERSECTS_5_X}"
	elif use amd-staging-drm-next-snapshot && ! use rock-latest && ! use rock-milestone ; then
		einfo "amd-staging-drm-next-snapshot and 5.x"
		# use 5.1.x
		base="${AMD_STAGING_SNAPSHOT_INTERSECTS_5_X}"
	elif use amd-staging-drm-next-milestone && ! use rock-latest && ! use rock-milestone ; then
		einfo "amd-staging-drm-next-milestone and 5.x"
		# use 5.1.x
		base="${AMD_STAGING_MILESTONE_INTERSECTS_5_X}"
	else
		die "cannot handle case"
	fi

	mkdir -p "${T}/amd-staging-drm-next-patches"
	if ! use rock-latest && ! use rock-milestone && ! use rock-snapshot ; then
		_get_amd_staging_drm_next_commit 1 5eb8c8c5871fa6f10236ecd67005bb0659c15d11 # 2019-02-19 drm/amdgpu: replace get_user_pages with HMM mirror helpers
		_get_amd_staging_drm_next_commit 2 346f2337dd44830751c3a66118df986a975c49f4 # 2019-02-21 drm/amdgpu: fix HMM config dependency issue
		_get_amd_staging_drm_next_commit 3 3e70b04ab7874670e65c688f89ce210a6a482de6 # 2019-02-19 drm/amdgpu: use HMM callback to replace mmu notifier
		_get_amd_staging_drm_next_commit 4 02205685e319bf6507feb95b1ee2ce3fb51fa60d # 2019-02-20 drm/amd/display: PPLIB Hookup
		_get_amd_staging_drm_next_commit 5 1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b # 2019-02-19 drm/amdkfd: avoid HMM change cause circular lock
		n="6"
	else
		n="1"
	fi

	einfo "Saving only the amd-staging-drm-next commits for commit-by-commit evaluation."
	L=$(git log ${base}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	for l in $L ; do
	        echo "Getting patch for $l"
	        git format-patch --stdout -1 $l > "${T}"/amd-staging-drm-next-patches/$(printf "%05d" $n)-$l.patch
	        n=$((n+1))
	done
}

function _get_rock_commit()
{
	local index="${1}"
	local commit="${2}"
	git format-patch --stdout -1 ${commit} > "${T}"/rock-patches/$(printf "%05d" ${index})-${commit}.patch || die
}

function _get_amd_staging_drm_next_commit()
{
	local index="${1}"
	local commit="${2}"
	git format-patch --stdout -1 ${commit} > "${T}"/amd-staging-drm-next-patches/$(printf "%05d" ${index})-${commit}.patch || die
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
	else
		einfo "Updating ROCK project"
		cd "${d}"
		git checkout master
		git reset --hard
		git pull
	fi
	cd "${d}"
}

function fetch_rock_commits() {
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
#			grep -v -e "\[4.[0-9]*\]" | \
	L=$(git log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | \
			cut -c 1-40 | tac)
	mkdir -p "${T}/rock-patches"

#	_get_rock_commit 1 bf96e47b4474f992095d9fae9ccfc46633bf4343 # drm/amdgpu: Bring back support for non-upstream FreeSync
	#_get_rock_commit 2 3c7df662ed3217805f988dafe87690daca4f4279 # drm/amdkcl: [4.8][4.12] fix drm_crtc_accurate_vblank_count implicit declaration build error

#	n="2"
	n="${NEXT_ROCK_COMMIT}"
	for l in $L ; do
	        echo "Getting patch for $l"
	        git format-patch --stdout -1 $l > "${T}"/rock-patches/$(printf "%05d" $n)-$l.patch
	        n=$((n+1))
	done
}

function get_missing_rock_commits_list() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local index

	if [[ "${CACHED_AMD_STAGING_DRM_NEXT_INDEX}" == "1" ]] ; then
		einfo "Using cached amd-staging-drm-next.commits.indexed"
		#index=$(tail /var/cache/ot-sources/amd-staging-drm-next.commits.indexed | cut -c 1-6 | sed -e "s|^0*||")
		#index=$((${index} + 1))
	else
		index=1
		d_staging="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
		cd "${d_staging}"
		einfo "Generating commit list for amd-staging-drm-next.  It may take half an hour."
		git log --reverse --pretty=tformat:"%H %s" > "${T}"/amd-staging-drm-next.commits

		while IFS= read -r l ; do
			echo $(printf "%06d" ${index})" ${l}" >> /var/cache/ot-sources/amd-staging-drm-next.commits.indexed
			index=$((${index} + 1))
		done < "${T}"/amd-staging-drm-next.commits
	fi

	if [[ "${CACHED_ROCK_INDEX}" == "1" ]] ; then
		einfo "Using cached rock.commits.indexed"
		#index=$(tail /var/cache/ot-sources/rock.commits.indexed | cut -c 1-6 | sed -e "s|^0*||")
		#index=$((${index} + 1))
	else
		index=1
		d_rock="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
		cd "${d_rock}"
		einfo "Generating commit list for ROCK.  It may take half an hour."
		git log --reverse --pretty=tformat:"%H %s" > "${T}"/rock.commits

		while IFS= read -r l ; do
			echo $(printf "%06d" ${index})" ${l}" >> /var/cache/ot-sources/rock.commits.indexed
			index=$((${index} + 1))
		done < "${T}"/rock.commits
	fi

	cat /var/cache/ot-sources/amd-staging-drm-next.commits.indexed | cut -c 49- | sort > "${T}"/amd-staging-drm-next.summaries
	cat /var/cache/ot-sources/rock.commits.indexed | cut -c 49- | sort > "${T}"/rock.summaries

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
		grep -F -e "${l}" "/var/cache/ot-sources/rock.commits.indexed" >> "${T}/rock.found"
	done

	cat "${T}"/rock.found | sort | uniq > "${T}"/rock.found.sorted

	C=$(cat "${T}"/rock.found.sorted | cut -c 8-47)
	einfo "Generating commits"
	index=1
	for c in ${C} ; do
		einfo "$index ${c}"
		git format-patch --stdout -1 ${c} > "${T}"/rock-patches/$(printf "%05d" ${index})-${c}.patch || die
		index=$((index + 1))
	done
	export NEXT_ROCK_COMMIT="${index}"
	IFS="${OIFS}"
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

	if   use rock-milestone && use amd-staging-drm-next-milestone ; then
		einfo "rock-milestone amd-staging-drm-next-milestone should compile fine."
	elif use rock-milestone && use amd-staging-drm-next-snapshot ; then
		einfo "rock-milestone amd-staging-drm-next-milestone should compile fine."
	elif use rock-snapshot && use amd-staging-drm-next-milestone ; then
		einfo "rock-snapshot amd-staging-drm-next-milestone breaks."
	elif use rock-snapshot && use amd-staging-drm-next-snapshot ; then
		einfo "rock-snapshot !amd-staging-drm-next-snapshot should compile fine."
	elif use rock-milestone && ! use amd-staging-drm-next-snapshot && ! use amd-staging-drm-next-milestone && ! use amd-staging-drm-next-latest ; then
		einfo "rock-milestone !amd-staging-drm-next-snapshot !amd-staging-drm-next-milestone !amd-staging-drm-next-latest should compile fine."
	elif use rock-snapshot && ! use amd-staging-drm-next-snapshot && ! use amd-staging-drm-next-milestone && ! use amd-staging-drm-next-latest ; then
		einfo "rock-snapshot !amd-staging-drm-next-snapshot !amd-staging-drm-next-milestone !amd-staging-drm-next-latest should compile fine."

	elif use amd-staging-drm-next-snapshot ; then
		einfo "amd-staging-drm-next-snapshot should compile fine."

	elif use rock-latest ; then
		einfo "rock-latest may break anytime."
	elif use amd-staging-drm-next-latest ; then
		einfo "amd-staging-drm-next-latest may break anytime."
	elif ! use amd-staging-drm-next-snapshot && ! use amd-staging-drm-next-milestone && ! use amd-staging-drm-next-latest && \
		! use rock-snapshot && ! use rock-milestone && ! use rock-latest ; then
		einfo "testing !rock-* && !amd-staging-drm-next-*"
	else
		die "untested combo of rock-* amd-staging-drm-next-*"
	fi

	fetch_staging_with_rock

	if is_rock ; then
		fetch_rock_commits
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
					*a1be09e2817415a3895b7f28fd7fe589ef9feed4*|\
					*7d747bad71d72d0201603e796c7056c09d25d89f*|\
					*e45d1970b20cb5d8dc9d0a6a9106fc79e0e77e5e*)
						# already applied
						# 7d747 resultant shows it disappears
						# e45d1 resultant shows it disappears
						;;
					*7bd1d22945d8927c882b7dcbca5cc503d0d7f007*)
						# adapted from amd-staging-drm-next
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7bd1d22945d8927c882b7dcbca5cc503d0d7f007-fix-for-linux-5.1.patch"
						;;
					*4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8*)
						# adapted from amd-staging-drm-next
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8-fix-for-linux-5.1.patch"
						;;
					*1e6f9843e8151706a0da2925145f575920678f9c*)
						# missing patch?
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-1e6f9843e8151706a0da2925145f575920678f9c-fix.patch"
						;;
					*d6e22eaa160e455ca53157c6f79ab2cd5b0b9800*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-d6e22eaa160e455ca53157c6f79ab2cd5b0b9800-fix.patch"
						;;
					*36394f28027839bfea67772715802dffa9288d38*)
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/rock-36394f28027839bfea67772715802dffa9288d38-fix.patch"
						;;
					*1254b5fe6aaabb58300a5929b6bb290bf1c49f63*|\
					*9c75d5a887d1d5f5815019c105e2ea25a2c9c823*)
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
							# 037f41cd2e01f39 avoid potential unnecessary patch
							# d8c7144 already applied
							continue
						else
							die "${l} need intervention patch"
							_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
						fi
						;;
					#*1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b*) # 3 in linux 5.1
					#	if use rock ; then
					#		# skip patch.  ROCK-Kernel-Driver reverts it
					#		true
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
					#	fi
					#	;;
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
					#*9032ea09e2d2ef0d10e5cd793713bf2eb21643c5*) # 286
					#	if use rock ; then
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
					#		_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-9032ea09e2d2ef0d10e5cd793713bf2eb21643c5-fix-rock.patch"
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-staging-drm-next-patches/${l}"
					#	fi
					#	;;
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
	if use disable_debug ; then
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${T}/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${T}/disable_debug" || die
	fi
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
		ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will cause a kernel panic on boot."
		ewarn "The MuQSS scheduler may have random system hard pauses for few seconds to around a minute when resource usage is high."
	fi

	if use bmq ; then
		ewarn "Using bmq with lots of resources may leave zombie processes, or high CPU processes/threads with little processing."
		ewarn "This might result in a denial of service that may require rebooting."
	fi
}
