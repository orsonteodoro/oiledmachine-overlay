#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.4.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 5.4.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.4 eclass defines specific applicable patching for the 5.4.x
# linux kernel.

ETYPE="sources"

K_MAJOR_MINOR="5.4"
K_PATCH_XV="5.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.4"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.4"
PATCH_ALLOW_O3_COMMIT="4edc8050a41d333e156d2ae1ed3ab91d0db92c7e"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.4"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?10}"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="0ebe06178ea25923b33397ff04e9d701356825a0"
PATCH_BFQ_VER="5.4"
PATCH_BMQ_MAJOR_MINOR="5.4"
DISABLE_DEBUG_V="1.1"
ZENTUNE_5_4_COMMIT="3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0"

# KV is kernel version, for the variable below means a commit hash
# "around a major.minor release."

# AMD_STAGING_INTERSECTS_KV starts from DC_VER of 5_x (major.minor kernel
# release milestones) and goes backwards with respect to DC_VER to the
# beginning of the mispatch/missing commit cluster(s).

# Mispatch/missing commit cluster can be caused by backports of DRM updates
# from future major.minor kernel releases.

#AMD_STAGING_INTERSECTS_KV="70bcf2bc5203e358e5e2ac30718caea53204dfe9"
# corresponds to drm/amd/display: 3.2.35 (tested) same as 5.x kernel release

AMD_STAGING_INTERSECTS_KV="5408887141baac0ad1a5e6cf514ceadf33090114"
# corresponds to drm/amd/display: 3.2.30 (testing); needs to go back x.x.-1
#   point release assuming that 3.2.31 is botched.
# 3.2.31 is pattern of missing commits in
#   ot-kernel-common_fetch_amd_staging_drm_next_commits_post

# obtained by:  git -P show -s --format=%ct v5.4 | tail -n 1
LINUX_TIMESTAMP=1574641921

IUSE="  bfq bmq bmq-quick-fix \
	amd-staging-drm-next \
	directgma \
	rock \
	+cfs disable_debug +graysky2 muqss +o3 uksm \
	futex-wait-multiple \
	zenmisc \
	-zentune"
DEPEND=" amd-staging-drm-next? ( dev-vcs/git ) \
	  rock? ( dev-vcs/git ) \
	  dev-util/patchutils"
REQUIRED_USE="^^ ( muqss cfs bmq )
	     directgma? ( rock )
	     rock? ( amd-staging-drm-next )"

# no released patch yet
REQUIRED_USE+=" !bfq !uksm !bmq-quick-fix"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs
detect_version
detect_arch

#DEPEND+=" deblob? ( ${PYTHON_DEPS} )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC \
Patches, MUQSS CPU Scheduler, BMQ CPU Scheduler, \
Genpatches, BFQ updates, amd-staging-drm-next"

AMDREPO_URL="git://people.freedesktop.org/~agd5f/linux"
AMD_PATCH_FN="${AMD_STAGING_DRM_NEXT_DIR}.patch"

CK_URL_BASE=\
"http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

inherit check-reqs ot-kernel-common

#BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.patch"
#BMQ_SRC_URL+=" https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}"

SRC_URI+=" ${CK_SRC_URL}"

SRC_URI+=" ${KERNEL_URI}
	   ${GENPATCHES_URI}
	   ${ARCH_URI}
	   ${O3_ALLOW_SRC_URL}
	   ${GRAYSKY_SRC_4_9_URL}
	   ${GRAYSKY_SRC_8_1_URL}
	   ${GRAYSKY_SRC_9_1_URL}
	   ${BMQ_SRC_URL}
	   ${GENPATCHES_BASE_SRC_URL}
	   ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	   ${GENPATCHES_EXTRAS_SRC_URL}
	   ${KERNEL_PATCH_URLS[@]} "
#	   ${UKSM_SRC_URL}

SRC_URI+=\
"https://github.com/torvalds/linux/commit/4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch \
	-> torvalds-linux-kernel-4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch
https://github.com/torvalds/linux/commit/d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch \
	-> torvalds-linux-kernel-d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch
https://github.com/torvalds/linux/commit/04ed8459f3348f95c119569338e39294a8e02349.patch \
	-> torvalds-linux-kernel-04ed8459f3348f95c119569338e39294a8e02349.patch
https://github.com/torvalds/linux/commit/695af5f9a51914030eb2d9e3ba923d38180a8199.patch \
	-> torvalds-linux-kernel-695af5f9a51914030eb2d9e3ba923d38180a8199.patch"

_set_check_reqs_requirements() {
	# for 3.1 kernel
	# source merge alone: 986.2 MiB
	# linux-amd-staging-drm-next local repo: 2002.72 MiB
	if use rock && use amd-staging-drm-next ; then
		CHECKREQS_DISK_USR="5470M"
	elif use rock ; then
		CHECKREQS_DISK_USR="3467M"
	elif use amd-staging-drm-next ; then
		CHECKREQS_DISK_USR="2990M"
	fi
}

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	if use zentune || use muqss ; then
		ewarn \
"The zen-tune patch or muqss might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
	fi

	if use rock ; then
		ewarn "Patching with ROCk is broken.  For ebuild devs only."

		einfo
		einfo \
"You need PCIe 3.0 or a GPU that doesn't require PCIe atomics to use ROCk.\n\
See needs_pci_atomics field for your GPU family in\n\
  https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/master/drivers/gpu/drm/amd/amdkfd/kfd_device.c\n\
for the exception.  For supported CPUs see\n\
  https://rocm.github.io/hardware.html"
		einfo
	fi

	if ( use rock || use amd-staging-drm-next ) ; then
		ewarn "Patching with amd-staging-drm-next is currently broken."
		_set_check_reqs_requirements
		check-reqs_pkg_setup
	fi
}

# @FUNCTION: ot-kernel-common_pkg_pretend_cb
# @DESCRIPTION:
# Does checks and warnings
function ot-kernel-common_pkg_pretend_cb() {
	if ( use rock || use amd-staging-drm-next ) ; then
		_set_check_reqs_requirements
		check-reqs_pkg_pretend
	fi
}

function ot-kernel-asdn_rm() {
	local l
	# already patched
	l=(
	b48935b3bfc1350737e759fef5e92db14a2e2fbb
	4d7fd9e20b0784b07777728316da5bcc13f9f2ab
	ebecc6c48f39b3c549bee1e4ecb9be01bf341a0f
	ebf8fc31cbcedc9d6a81642082661c82eae284fb
	a6f30079b8562b659e1d06f7cb1bc30951869bbc
	bf2bf52383a09256e11278e7bcb67dcd912078c7 )

	if ver_test ${PV} -ge 5.3.5 ; then
		l+=( e40837afb9b011757e17e9f71d97853ca574bcff )
	fi

	# already applied in torvalds kernel for 5.4 but not 5.3
	# asdn_rm 1faa3b805473d7f4197b943419781d9fd21e4352

	# obsolete (hunks that doesn't appear in the final image (aka head) in
	#   amd-staging-drm-next repo ; replaced by newer
	#   design / architecture / version)
	l+=(
	5fa790f6c936c4705dea5883fa12da9e017ceb4f
	3f61fd41f38328f0a585eaba2d72d339fe9aecda )

	if use amd-staging-drm-next && use rock ; then
		# use rock version instead
		l+=( d0ba51b1cacd27bdc1acfe70cb55699f3329b2b1
		3e205a0849a760166578b4d95b17e904f23d962e
		876923fb92a9e298625067284977917d4741ee2e
		)
	fi

	asdn_rm_list ${l[@]}
}

# merge conflict resolver
function ot-kernel-common_amdgpu_merge_and_apply_patches_asdn() {
  if use amd-staging-drm-next && ! use rock ; then
    cd "${S}"
    L=$(ls -1 "${mpd}" | sort)
    for l in $L ; do
      #
      # Each section is marked easy or hard to indicate difficulty of conflict
      # resolution which connnects to confidence/reliability/quality of the fix.
      #
      # easy = trivial and straightforward
      # medium = takes time to resolve
      # hard = not so straightforward, unofficial custom code to fix, higher
      #   chance of runtime/compile-time failure
      #
      echo $(patch --dry-run ${PATCH_OPS} -i "${mpd}/${l}") | grep -F -e "FAILED at"
      if [[ "$?" == "1" ]] ; then
        case "${l}" in
          *ab2f7a5c18b5c17cc94aaab7ae2e7d1fa08993d6*)
            # Fails enter in else branch so move up here
            # modifies ab2f commit
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-e7f7287bf5f746d29f3607178851246a005dd398-partial-rebase-for-5.3.4-asdn.patch"
            ;;
          *)
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            # Already has been applied or partially patched already or success
            ;;
        esac
      else
        case "${l}" in
          *c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0*)
            # Revert then apply
            _dpatch "${PATCH_OPS} -R" \
"${DISTDIR}/torvalds-linux-kernel-d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch"
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *cfb7c11bb7a590c7e9c3d241d85388db108ceeb7*)
            # Revert then apply
            _dpatch "${PATCH_OPS} -R" \
"${DISTDIR}/torvalds-linux-kernel-4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch"
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *22a8f442866bf539c7a659923155d9afa03d77bb*)
            # Backport.
            # Final state doesn't exist in 5.3 but does in 5.4 ; easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-22a8f442866bf539c7a659923155d9afa03d77bb-rebase-for-5.3.4-asdn.patch"
            ;;
          *fcd90fee8ac22da3bce1c6652cf36bc24e7a0749*)
            # Backport.
            # Easy
            # fcd90 is DC_VER 3.2.42
            # Conflicting commit f0ced3f61b4d2a21a3e0f0aa79fb5ad6c6717c31
            #   is DC_VER 3.2.42
            # Final state doesn't exist in 5.3 but does in 5.4
            # f0ced3f already applied in v5.3 kernel so breaks
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-fcd90fee8ac22da3bce1c6652cf36bc24e7a0749-rebase-for-5.3.4-asdn.patch"
            ;;
          *98eb03bbf0175f009a74c80ac12b91a9680292f4*)
            # Backport.  Final state doesn't exist in 5.3 but does in 5.4 ; easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-98eb03bbf0175f009a74c80ac12b91a9680292f4-rebase-for-5.3.4-asdn.patch"
            ;;
          *)
            die "Patch failure ${mpd}/${l} .  Did not find the intervention patch."
            ;;
        esac
      fi
    done
  fi
}

function ot-kernel-rock_rm() {
	local l
	# already patched
	l+=(
	f761e8303bb1608622fb993531ba95244335c847
# function deleted; the rest already merged in other commits
	973c795c16c872efb874df6e0788fcb5b6f17e20
# vanilla is version 2
	7746b504b45df9f7e6e4dedb0f18dd2a854f1a75
# vanilla is version 3
	4d8288cf6bd58b3770f60704647b4966ed0d7cb4
	db2c1587e1178bfc1cc161f76b54cf40f4167168
# integrated in torvalds kernel 992af942a6cfb32f4b5a9fc29545f101074fa250 under
#   another subject
	5d31c3c0d5f2b753ed8a3170a152b9954a1aa20b
	c7d05e309a2f781a42aa7ecefef1c79224859a37
	bf34bf33eed4296642cf51acd91c2e8942ca5fef
	0bc07fd0aab17d7ecc85a9eb1fea668cbb0f0162
# same as 1faa3b805473d7f4197b943419781d9fd21e4352 in torvalds kernel v5.4 and
#   asdn
	220883377e9c2434fcafaab24e215597752a2d84
# applied in 14328aa58ce523a59996c5a82681c43ec048cc33
	2d2f62874426b347d47eeac492709c3ad0c1b92a

	# obsolete (hunks that doesn't appear in the final image (aka head) in
	#  amd-staging-drm-next/ROCK-Kernel-Driver repo ; replaced by newer
	#  design/architecture/version)
	31ad0be4ebf7327591fbca1b96e209f591a19849
	ad3bf1a3b5d15041e18a7a6c62c731b63db51447
# vanilla is version 2
	7eb512d4585f9d746ffacd40be5b8f95ef87d795
# testing removal ; the revert of the revert is already merged in vanilla and
#   in amd-staging-drm-next ; Revert "drm/amd/display: Rework DC plane filling
#   and surface updates"
	8234806160c533f85b98953f76a1b13455232ffb
# testing removal ; the revert of the revert is already merged in vanilla and
#   in amd-staging-drm-next ; Revert "drm/amd/display: Recalculate pitch when
#   buffers change"
	8a67db18390d686b9d14ff9e554e5165c1814590
	e26e00469e4341d470eb4d56db5b5f517338d096
# testing removal ; the revert of the revert is already merged in vanilla and
#   in amd-staging-drm-next ; Revert "drm/amd/display: Rework DC plane filling
#   and surface updates"
	456fc4538e9d5dbace83acb03e0fbef346d654e6
# testing removal ; the revert of the revert is already merged in vanilla and
#   in amd-staging-drm-next ; Revert "drm/amd/display: Recalculate pitch when
#   buffers change"
	61e96f3cdff3fe103bf675509225747a3ecec57e
# testing removal ; the revert of the revert is already merged in vanilla and
#   in amd-staging-drm-next ; Revert "drm/amdkfd: Separate mqd allocation and
#   initialization"
	ea1d0c448f085ccb4463b42fe78a0064ed07c7dc
# vanilla is version 2
	1013dec3ee8dce5348a85ffadfed52b68346b9fc
	2e5e1c3fed36d74806f2d805601b130605c3efd0
# vanilla is version 4, rock is version 3
	209e519c2caef76407eabfff4ae5061bef320d19
# vanilla is version 3, rock is version 2
	5b4e3b79a1ad5702fbb2e54ee4b74b805ea2b4d2
# already applied in torvald kernel 14328aa58ce523a59996c5a82681c43ec048cc33
	8d4c550acf01c77a00c620b49c91fab8ea9c31c4
# removed at 292a0a4884733bb7292c72f90c05ea35f3138529 in ROCK-Kernel-Driver to
#   keep in sync with 14328aa58ce523a59996c5a82681c43ec048cc33 in vanilla
	5f26b8eebe2f4517e9ca5c471c9cc13efa5b30ce
# vanilla is version 2
	c42436ec04f3d49a7cf3627411e1ddbb5b347953
# amd-staging-drm-next is version 3
	96003fe3ea48157dd7fefc12160a1ea5f0b6f223
# ROCk is version v2 (logic fix), amd-staging-drm-next is version 3
#   (logic simplification)
	3e9f4c949eb5862c9bbee4b862ed604f39861f8e

	# applied later in 8d4c550acf01c77a00c620b49c91fab8ea9c31c4 with same name
# Revert "drm/amdkfd: Added cwsr trap handler for gfx10"
	68e69efdd4d72f1e9fd01eb82ee9951da793d466
# drm/amdkfd: Added cwsr trap handler for gfx10
	86d16a26763d6a86803f524025279d1e40c93b4c

	# applied later in 2d2f62874426b347d47eeac492709c3ad0c1b92a with same name
# Revert "drm/amdkfd: Moved gfx10 cwsr binary to cwsr_trap_handler.h"
	b38921cb275c5030004e0759f2b08fee8c4ce578
# drm/amdkfd: Moved gfx10 cwsr binary to cwsr_trap_handler.h
	ae7e6022c353fed62fc81c4baa024f10fb7b2e07

	# applied later in 5526bb8d854202aba28b20809e1af0ef8e1c714b with same name
# Revert "drm/amdkfd: Introduce DIQ type mqd manager for gfx10"
	7d0e12f600ec3fdd0f29d83cc51b20a868fc143f
# drm/amdkfd: Introduce DIQ type mqd manager for gfx10
	e0d8fd23132af4bd65e8b1db74ac5750698b72f4

	# applied later in a6b8b58d4001def5fb1b619d31b686fcef0f991e with same name
# Revert "drm/amdkfd: Add mqd size in mqd manager struct for gfx10"
	19b4facdabeb52d56093f774257d5f450cb462da
# drm/amdkfd: Add mqd size in mqd manager struct for gfx10
	745e8a141d8f9b4aa473ab15fdfca504ac55bf7f

	# applied later in 5f26b8eebe2f4517e9ca5c471c9cc13efa5b30ce with same name
# Revert "drm/amdkfd: Allocate hiq and sdma mqd from mqd trunk for gfx10"
	b1827a0577fa3abcd0c44ae153f2b05a54094a2c
# drm/amdkfd: Allocate hiq and sdma mqd from mqd trunk for gfx10
	8979cc19b3864a259f3833c17efcafb09bbb81cc

	# applied later in 292a0a4884733bb7292c72f90c05ea35f3138529 with same name
# Revert "drm/amdkfd: update gfx10 support for latest kfd changes"
	e7a487ffe6dfa11278095adb81e3b142c6e905c2
# drm/amdkfd: update gfx10 support for latest kfd changes
	26e8ff97cd56eacfc02703149f7c87a4b37c2564 )

	if ! use directgma ; then
		# the amdgpu_vm_bo_split_mapping should resemble asdn version
		# disabiling directgma should be result in less problematic
		# merge conflict resolution
		l+=(
		f331d74dad4358369a6dfb182ff0a5607a8e7b04
		80f3db1de8277cb3c0a817c92795bdf6f5b8818d
		8098a2f9c3ba6fba0055aa88d3830bbec585268b
		4eff2c42f996e8d70ec874186d3c35a8f64a8235
		388c85610cd4782467bae4f44d7b7c8cacebfaae
		bb02f27489fe4469cf3460549dd0bf45e1cc1746 # ssg
		716c8a9c52f87831094e6617e088f382a569b13c )
	fi

	# reject dkms/kcl
	l+=(
	7bf2fb137fabacdf3457b70d205f1378057d7130
	77843fb3174f0903bf48141cdb7ad0e545364194
	a1d58b7bf915e956f14984fcf1a3d8431657d351
# used in 178d1118dbee5cff09badab7208525b287fa849f
	5b734f8c1205ff65ef2af7484932078bb655f41c
	509649b8d929b5981e57c6f1b8d50756af56e033
	8e162714eeea8bb1539c45d06f845c12c3ea39a6
	ca4dec1752263e90c489874e984714c42787deb5

	# reject cosmetic
	6b719b24a48e31ff2b37b97cce552e4615c7d277 )

	rock_rm_list ${l[@]}
}

# merge conflict resolver
function ot-kernel-common_amdgpu_merge_and_apply_patches_rock() {
  if use amd-staging-drm-next && use rock ; then
    cd "${S}"
    L=$(ls -1 "${mpd}" | sort)
    for l in $L ; do
      #
      # Each section is marked easy or hard to indicate difficulty of conflict
      # resolution which connnects to confidence/reliability/quality of the fix
      #
      # Easy = trivial and straightforward
      # Medium = takes time to resolve
      # Hard = not so straightforward, unofficial custom code to fix, higher
      #   chance of runtime/compile-time failure
      #
      if [[ "${l}" =~ 6ab2f507957f676d2bbdccaaaec570a3d1901fc7 ]] ; then
        einfo "Patching the path of ${l}"
        # in vanilla kernel 5.3 amdgpu_prime.c got renamed
        sed -i -e "s|\
drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c|\
drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c|g" \
		"${mpd}/${l}" || die
      fi

      echo $(patch --dry-run ${PATCH_OPS} -i "${mpd}/${l}") | grep -F -e "FAILED at"
      if [[ "$?" == "1" ]] ; then
        case "${l}" in
          *d732ef0efc3beed8b8c30433aa11d5b6895cb457*rock*)
            # drm/amdkcl: add dkms support ; remove?
            # ROCk addition
            # Revert then apply.  On ROCK-Kernel-Driver and on
            #   amd-staging-drm-next, repo 04ed8 still exists but not applied.
            _dpatch "${PATCH_OPS} -R" \
"${DISTDIR}/torvalds-linux-kernel-04ed8459f3348f95c119569338e39294a8e02349.patch"
            ;;
          *ab2f7a5c18b5c17cc94aaab7ae2e7d1fa08993d6*asdn*)
            # fails enter in else branch so move up here
            # modifies to ab2f commit
            # easy
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-e7f7287bf5f746d29f3607178851246a005dd398-partial-rebase-for-5.3.4-asdn.patch"
            ;;
          *)
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            # already has been applied or partially patched already or success
            ;;
        esac
      else
        case "${l}" in
          *876923fb92a9e298625067284977917d4741ee2e*asdn*)
            die "fixme ${mpd}/${l}"
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *0b4822828a8d5e99074718a3368d96743dd9fad2*rock*)
            if ver_test ${PV} -ge 5.3.6 ; then
              _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
              _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-0b4822828a8d5e99074718a3368d96743dd9fad2-rebase-for-5.3.6.patch"
            else
              _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            fi
            ;;
          *3f1e5c3eeec3a5aff5ddbd46ff07fe580e4bee58*rock*)
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-3f1e5c3eeec3a5aff5ddbd46ff07fe580e4bee58-rebase-for-5.3.4.patch"
            ;;
          *b2ea22af7f5793d351ea65ff2fd2f3d7ba6ec1b6*rock*)
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-b2ea22af7f5793d351ea65ff2fd2f3d7ba6ec1b6-rebase-for-5.3.4.patch"
            ;;
          *95c59fee52c9aee3f99a5a39a3ba8f0fa10c263e*rock*)
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-95c59fee52c9aee3f99a5a39a3ba8f0fa10c263e-rebase-for-5.3.4.patch"
            ;;
          *bb02f27489fe4469cf3460549dd0bf45e1cc1746*rock*)
            # remove kcl header macro reference
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-bb02f27489fe4469cf3460549dd0bf45e1cc1746-skip-drm-ver-check-for-5.3.4.patch"
            # apply patch without kcl macro check
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-bb02f27489fe4469cf3460549dd0bf45e1cc1746-rebase-for-5.3.4.patch"
            ;;
          *fc39d903eb805588cba3696748728627aedfd1bd*asdn*)
            # Easy
            # ignore missing search hunk... it's just refactoring patch
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
           ;;
          *4e3f4a15707d534ce1dd5b23b008469474b80010*asdn*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-4e3f4a15707d534ce1dd5b23b008469474b80010-rebase-for-5.3.4-rasdn-no_dgma.patch"
            ;;
          *60b6a348ac071a6eaa5cc412d15580672fcd2c80*asdn*)
            # Easy-Medium
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-60b6a348ac071a6eaa5cc412d15580672fcd2c80-rebase-for-5.3.4-rasdn-no_dgma.patch"
            ;;
          *e4a525b586f6321aef0691db7365c0c08cd5dec8*asdn*)
            # Ignore %d to %x%x conversion output.  it may break those that parse the info.
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *1c70d3d9c4a6d4e4b4425d78e0a919cfaa3cf8db*asdn*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-1c70d3d9c4a6d4e4b4425d78e0a919cfaa3cf8db-rebase-for-5.3.4-rasdn.patch"
            ;;
          *47930de4aa7068188e64475cdc0f2c8f4e1ff194*asdn*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-47930de4aa7068188e64475cdc0f2c8f4e1ff194-rebase-for-5.3.4-rasdn.patch"
            ;;
          *691bac9d093b13abf39f95bd82db0430a152246c*asdn*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-691bac9d093b13abf39f95bd82db0430a152246c-rebase-for-5.3.4-rasdn.patch"
            ;;
          *64f55e629237e4752db18df4d6969a69e3f4835a*asdn*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-64f55e629237e4752db18df4d6969a69e3f4835a-rebase-for-5.3.4-rasdn.patch"
            ;;
#          *3e205a0849a760166578b4d95b17e904f23d962e*asdn*)
            # Using asdn version of:
            #   'drm/amdkfd: Implement kfd2kgd_calls for Arcturus'
            #   (3e205a0849a760166578b4d95b17e904f23d962e)`
            # then apply additional deletes by
            #   3f1e5c3eeec3a5aff5ddbd46ff07fe580e4bee58 (rock version) with
            # Same commit subject
            # Easy-Medium
#            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
#            die
#            _dpatch "${PATCH_OPS}" \
#"${FILESDIR}/amdgpu-3e205a0849a760166578b4d95b17e904f23d962e-rebase-for-5.3.4-rasdn.patch"
#            ;;
          *f6a44ea23e7dab4d58110cd418c733e165e466ae*rock*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-f6a44ea23e7dab4d58110cd418c733e165e466ae-rebase-for-5.3.4.patch"
            ;;
          *c1d7be9699189e1c762c9249b3deaf827e1743f9*rock*)
            # Easy
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-c1d7be9699189e1c762c9249b3deaf827e1743f9-rebase-for-5.3.4.patch"
            ;;
          *8098a2f9c3ba6fba0055aa88d3830bbec585268b*rock*)
            # drm/amdgpu: Add bo mapping through PCIE
            # parts already applied
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *32add621ba8f6021e3a52cabafe88f660d46a0a4*rock*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-32add621ba8f6021e3a52cabafe88f660d46a0a4-rebase-for-5.3.4.patch"
            ;;
          *bcb1219a6b88068584ccc25fe333d10c2422877a*rock*)
            # Easy
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-bcb1219a6b88068584ccc25fe333d10c2422877a-rebase-for-5.3.4.patch"
            ;;
          *f331d74dad4358369a6dfb182ff0a5607a8e7b04*rock*)
            # Medium
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-f331d74dad4358369a6dfb182ff0a5607a8e7b04-rebase-for-5.3.4.patch"
            ;;
          *c4e16b22d0bfa1d9979a219c34931622693b9cb2*rock*)
            # drm/amdkfd: Revert codes of creating SDMA queue on specific engine
            # drivers/gpu/drm/amd/amdkfd/kfd_chardev.c edits required in final
            #   image
            # drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c edits not
            #   necessary and obsolete
            # include/uapi/linux/kfd_ioctl.h edits already applied
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *4766d6eb3c11d7dffc9e8e34350c5658267b0281*rock*)
            # Contains mispatch
            # Medium-Hard
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-4766d6eb3c11d7dffc9e8e34350c5658267b0281-rebase-for-5.3.4.patch"
            ;;
          *1254b5fe6aaabb58300a5929b6bb290bf1c49f63*rock*)
            # Hard
            # If backporting revisit this commit's
            # include/uapi/linux/kfd_ioctl.h and
            # c4e16b22d0bfa1d9979a219c34931622693b9cb2
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/rock-1254b5fe6aaabb58300a5929b6bb290bf1c49f63-rebase-for-5.3.4.patch"
            ;;
          *c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0*asdn*)
            # Revert then apply
            _dpatch "${PATCH_OPS} -R" \
"${DISTDIR}/torvalds-linux-kernel-d1836f3813ee0742a2067d5f4d78e811d2b76d9d.patch"
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *cfb7c11bb7a590c7e9c3d241d85388db108ceeb7*asdn*)
            # Revert then apply
            # IOCTLs must be ABI compatible explained in
            #   8439cd353b4e1abca8420e71274b018a07fe2e12
            # IOCTLs introduced by ROCk's
            #   1254b5fe6aaabb58300a5929b6bb290bf1c49f63 cause this split.
            _tpatch "${PATCH_OPS} -R" \
"${DISTDIR}/torvalds-linux-kernel-4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0.patch"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/torvalds-kernel-4b3e30ed3ec7864e798403a63ff2e96bd0c19ab0-rebase-for-5.3.4-rasdn.patch"
            _dpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            ;;
          *22a8f442866bf539c7a659923155d9afa03d77bb*asdn*)
            # Backport
	    # Easy
            # Final state doesn't exist in 5.3 but does in 5.4
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-22a8f442866bf539c7a659923155d9afa03d77bb-rebase-for-5.3.4-asdn.patch"
            ;;
          *fcd90fee8ac22da3bce1c6652cf36bc24e7a0749*asdn*)
            # Backport
            # Easy
            # fcd90 is DC_VER 3.2.42
            # conflicting commit f0ced3f61b4d2a21a3e0f0aa79fb5ad6c6717c31 is
            #   DC_VER 3.2.42
            # Final state doesn't exist in 5.3 but does in 5.4
            # f0ced3f already applied in v5.3 kernel so breaks
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-fcd90fee8ac22da3bce1c6652cf36bc24e7a0749-rebase-for-5.3.4-asdn.patch"
            ;;
          *98eb03bbf0175f009a74c80ac12b91a9680292f4*asdn*)
            # Backport
            # Easy
            # Final state doesn't exist in 5.3 but does in 5.4
            _tpatch "${PATCH_OPS} -N" "${mpd}/${l}"
            _dpatch "${PATCH_OPS}" \
"${FILESDIR}/amdgpu-98eb03bbf0175f009a74c80ac12b91a9680292f4-rebase-for-5.3.4-asdn.patch"
            ;;
          *)
            die "Patch failure ${mpd}/${l} .  Did not find the intervention patch."
            ;;
        esac
      fi
    done

    # The last pass will scan source code or the rock patchset for
    # dkms/kcl macro defines and replace them with DRM_VERSION
    # checks.
  fi
}

# @FUNCTION: ot-kernel-common_amdgpu_merge_and_apply_patches
# @DESCRIPTION:
# Apply amd-staging-drm-next and ROCk commits at the same time.
function ot-kernel-common_amdgpu_merge_and_apply_patches() {
	local mpd="${T}/amdgpu-merged-patches"
	mkdir -p "${mpd}"
	if use amd-staging-drm-next ; then
		generate_amd_staging_drm_next_patches
		mv "${T}/amd-staging-drm-next-patches"/* "${mpd}"
	fi
	if use rock ; then
		generate_rock_patches
		mv "${T}/rock-patches"/* "${mpd}"
	fi

	ot-kernel-common_amdgpu_merge_and_apply_patches_rock
	# This is split to isolate amd_staging_drm_next versus
	# amd_staging_drm_next with rock.  It is more difficult to update rock.
	ot-kernel-common_amdgpu_merge_and_apply_patches_asdn
}

# @FUNCTION: ot-kernel-asdn-generate_amd_staging_drm_next_patches_post
# @DESCRIPTION:
# Removes unnecessary hunks
function ot-kernel-asdn-generate_amd_staging_drm_next_patches_post() {
	#_amdgpu_common_filter_patches "amd-staging-drm-next-patches"
	:;
}

# @FUNCTION: ot-kernel-rock_generate_rock_patches_post
# @DESCRIPTION:
# Removes unnecessary hunks
function ot-kernel-rock_generate_rock_patches_post() {
	#_amdgpu_common_filter_patches "rock-patches"
	:;
}

# @FUNCTION: ot-kernel-common_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL and\n\
Idle dynticks system (tickless idle) CONFIG_NO_HZ_IDLE may cause the system\n\
  to lock up.\n\
You must choose Periodic timer ticks (constant rate, no dynticks)\n\
  CONFIG_HZ_PERIODIC for it not to lock up.\n\
The MuQSS scheduler may have random system hard pauses for few seconds to\n\
  around a minute when resource usage is high."
	fi

	if use bmq ; then
		ewarn \
"Using bmq with lots of resources may leave zombie processes, or high CPU\n\
  processes/threads with little processing.\n\
This might result in a denial of service that may require rebooting."
	fi

	if use rock ; then
		rock_postinst_msg
	fi
}
