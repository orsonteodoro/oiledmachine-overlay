#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-common.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-common eclass defines common patching steps for any linux
# kernel version.

# UKSM:
#   https://github.com/dolohow/uksm
# zen-tune:
#   https://github.com/torvalds/linux/compare/v5.3...zen-kernel:5.3/zen-tune
# O3 (Optimize Harder):
#   https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#   https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:
#   https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:
#   http://ck.kolivas.org/patches/5.0/5.2/5.2-ck1/
# PDS CPU Scheduler:
#   http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:
#   https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:
#   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:
#   https://github.com/torvalds/linux/compare/v5.3...zen-kernel:5.3/bfq-backports
# TRESOR:
#   http://www1.informatik.uni-erlangen.de/tresor

# TRESOR is maybe broken.  It requires additional coding for skcipher.
# Use the 4.9 series if you want to use TRESOR.
# See aesni-intel_glue.c chacha20_glue.c tresor_glue.c aesni-intel_asm.S
#   aesni-intel_asm.S in arch/x86/crypto
# It needs to fill out the skcipher_alg structure and provide callbacks that
#   use the skcipher_request structure.
# CBC uses CRYPTO_ALG_TYPE_SKCIPHER
# ECB uses CRYPTO_ALG_TYPE_BLKCIPHER

# Parts that still need to be developed:
# TRESOR - incomplete API

case ${EAPI:-0} in
	7) die "this eclass doesn't support EAPI ${EAPI}" ;;
	*) ;;
esac

HOMEPAGE+="
          https://github.com/dolohow/uksm
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

inherit ot-kernel-cve
inherit ot-kernel-asdn
inherit ot-kernel-rock

DEPEND+=" >=dev-util/patchutils-0.3.4_p20190902
	  sys-apps/grep[pcre]"

SRC_URI+=\
" https://github.com/torvalds/linux/commit/52791eeec1d9f4a7e7fe08aaba0b1553149d93bc.patch \
	-> linux--dma-buf-rename-reservation_object-to-dma_resv.patch"

gen_kernel_seq()
{
	# 1-2 2-3 3-4
	local s=""
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" $s $((${to}-1))-${to}"
	done
	echo $s
}

BMQ_FN="${BMQ_FN:=v${PATCH_BMQ_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch}"
BMQ_BASE_URL="https://gitlab.com/alfredchen/bmq/raw/master/${PATCH_BMQ_MAJOR_MINOR}/"
BMQ_SRC_URL="${BMQ_BASE_URL}${BMQ_FN}"

ZENTUNE_URL_BASE="https://github.com/torvalds/linux/compare/v${PATCH_ZENTUNE_VER}...zen-kernel:${PATCH_ZENTUNE_VER}/"
ZENTUNE_REPO="zen-tune"
ZENTUNE_FN="${ZENTUNE_REPO}-${PATCH_ZENTUNE_VER}.diff"
ZENTUNE_DL_URL="${ZENTUNE_URL_BASE}${ZENTUNE_REPO}.diff"
ZENTUNE_SRC_URL="${ZENTUNE_DL_URL} -> ${ZENTUNE_FN}"

UKSM_BASE="https://raw.githubusercontent.com/dolohow/uksm/master/v${PATCH_UKSM_MVER}.x/"
UKSM_FN="uksm-${PATCH_UKSM_VER}.patch"
UKSM_SRC_URL="${UKSM_BASE}${UKSM_FN}"

O3_SRC_URL="https://github.com/torvalds/linux/commit/"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT}.diff"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT}.diff"
O3_CO_DL_FN="${PATCH_O3_CO_COMMIT}.diff"
O3_RO_DL_FN="${PATCH_O3_RO_COMMIT}.diff"
O3_CO_SRC_URL="${O3_SRC_URL}${O3_CO_DL_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URL="${O3_SRC_URL}${O3_RO_DL_FN} -> ${O3_RO_FN}"

GRAYSKY_DL_4_9_FN="${GRAYSKY_DL_4_9_FN:=enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch}"
GRAYSKY_DL_8_1_FN="enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_DL_9_1_FN="enable_additional_cpu_optimizations_for_gcc_v9.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_URL_BASE="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/"
GRAYSKY_SRC_4_9_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_4_9_FN}"
GRAYSKY_SRC_8_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_8_1_FN}"
GRAYSKY_SRC_9_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_9_1_FN}"

GENPATCHES_URL_BASE="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_BASE_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXTRAS_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_VER}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_VER}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_AESNI_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_AESNI_FN}"
TRESOR_I686_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_I686_FN}"
TRESOR_SYSFS_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_SYSFS_FN}"
TRESOR_README_DL_URL="https://www1.informatik.uni-erlangen.de/tresor?q=content/readme"
TRESOR_SRC_URL="${TRESOR_README_DL_URL} -> ${TRESOR_README_FN}"

KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/patch-${K_MAJOR_MINOR}.1.xz"

LINUX_REPO_URL="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

LINUX_COMMITS_AMDGPU_RANGE_FN="${LINUX_COMMITS_AMDGPU_RANGE_FN:=linux.commits.amdgpu_range.${K_MAJOR_MINOR}}"

# intermediate cache files
LINUX_HASHTABLE_COMMITS_VK_FN="${LINUX_HASHTABLE_COMMITS_VK_FN:=linux.hashtable.commits.vk.${K_MAJOR_MINOR}}"
LINUX_HASHTABLE_SUMMARIES_VK_FN="${LINUX_HASHTABLE_SUMMARIES_VK_FN:=linux.hashtable.summaries.vk.${K_MAJOR_MINOR}}"
LINUX_HASHTABLE_COMMITS_ASDN_FN="${LINUX_HASHTABLE_COMMITS_ASDN_FN:=linux.hashtable.commits.asdn.${K_MAJOR_MINOR}}"
LINUX_HASHTABLE_SUMMARIES_ASDN_FN="${LINUX_HASHTABLE_SUMMARIES_ASDN_FN:=linux.hashtable.summaries.asdn.${K_MAJOR_MINOR}}"

# the final commit set
LINUX_HASHTABLE_COMMITS_FINAL_BASENAME_ROCK_FN="${LINUX_HASHTABLE_COMMITS_FINAL_BASENAME_ROCK_FN:=linux.hashtable.commits.final.rock.${K_MAJOR_MINOR}}"
LINUX_HASHTABLE_COMMITS_FINAL_BASENAME_ASDN_FN="${LINUX_HASHTABLE_COMMITS_FINAL_BASENAME_ASDN_FN:=linux.hashtable.commits.final.asdn.${K_MAJOR_MINOR}}"

if [[ -n "${KERNEL_NO_POINT_RELEASE}" && "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; then
	KERNEL_PATCH_URLS=()
elif [[ -n "${KERNEL_0_TO_1_ONLY}" && "${KERNEL_0_TO_1_ONLY}" == "1" ]] ; then
	KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL})
	KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz)
	KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1)
else
	KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(ver_cut 3 ${PV})))
	KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
	KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
	KERNEL_PATCH_FNS_EXT=(patch-${K_MAJOR_MINOR}.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-${K_MAJOR_MINOR}.})
	KERNEL_PATCH_FNS_NOEXT=(patch-${K_MAJOR_MINOR}.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-${K_MAJOR_MINOR}.})
fi

PDS_URL_BASE="https://gitlab.com/alfredchen/PDS-mq/raw/master/${PATCH_PDS_MAJOR_MINOR}/"
PDS_FN="v${PATCH_PDS_MAJOR_MINOR}_pds${PATCH_PDS_VER}.patch"
PDS_SRC_URL="${PDS_URL_BASE}${PDS_FN}"

BFQ_FN="bfq-${PATCH_BFQ_VER}.diff"
BFQ_REPO="bfq-backports"
BFQ_DL_URL="https://github.com/torvalds/linux/compare/v${PATCH_BFQ_VER}...zen-kernel:${PATCH_BFQ_VER}/${BFQ_REPO}.diff"
BFQ_SRC_URL="${BFQ_DL_URL} -> ${BFQ_FN}"

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 500"

# @FUNCTION: _dpatch
# @DESCRIPTION:
# Patch with die check.
# @CODE
# Parameters:
# $1 - patch options
# $2 - path of the patch
# @CODE
function _dpatch() {
	local patchops="$1"
	local path="$2"
	if [[ "${patchops}" =~ "-R" ]] ; then
		einfo "Reverting ${path}"
	else
		einfo "Applying ${path}"
	fi
	patch ${patchops} -i ${path} || die
}

# @FUNCTION: _tpatch
# @DESCRIPTION:
# Patch without die check, which may be followed by intervention corrective
# action, implied true as in normal operation.
# @CODE
# Parameters:
# $1 - patch options
# $2 - path of the patch
# @CODE
function _tpatch() {
	local patchops="$1"
	local path="$2"
	if [[ "${patchops}" =~ "-R" ]] ; then
		einfo "Reverting ${path}"
	else
		einfo "Applying ${path}"
	fi
	patch ${patchops} -i ${path} || true
}

# @FUNCTION: apply_uksm
# @DESCRIPTION:
# Apply the UKSM patches.
#
# ot-kernel-common_uksm_fixes - callback to fix the patch
#
function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"

	if declare -f ot-kernel-common_uksm_fixes > /dev/null ; then
		ot-kernel-common_uksm_fixes
	fi
}

# @FUNCTION: apply_bfq
# @DESCRIPTION:
# Apply the BFQ patches.
function apply_bfq() {
	_dpatch "${PATCH_OPS} -N" "${T}/${BFQ_FN}"
}

# @FUNCTION: apply_zentune
# @DESCRIPTION:
# Apply the ZenTune patches.
function apply_zentune() {
	_dpatch "${PATCH_OPS} -N" "${T}/${ZENTUNE_FN}"
}

# @FUNCTION: apply_genpatch_base
# @DESCRIPTION:
# Apply the base genpatches patchset.
#
# ot-kernel-common_apply_genpatch_base_patchset - callback to apply individual
#   patches
#
function apply_genpatch_base() {
	einfo "Applying the genpatch base"
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" \
		"${S}"/Makefile \
		|| die

	if [[ -n "${KERNEL_NO_POINT_RELEASE}" \
		&& "${KERNEL_NO_POINT_RELEASE}" == "1" ]] ; \
		then
		true
	else
		# genpatches places kernel incremental patches starting at 1000
		for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
			local f="${T}/${a}"
			cd "${T}"
			unpack "$a.xz"
			cd "${S}"
			patch --dry-run ${PATCH_OPS} -N "${f}" \
				| grep -F -e "FAILED at"
			if [[ "$?" == "1" ]] ; then
				# already patched or good
				_tpatch "${PATCH_OPS} -N" "${f}"
			else
				eerror "Failed ${l}"
				die
			fi
		done
	fi

	sed -r -i -e "s|EXTRAVERSION =|EXTRAVERSION = ${EXTRAVERSION}|" \
		"${S}"/Makefile \
		|| die

	cd "${S}"

	if declare -f ot-kernel-common_apply_genpatch_base_patchset \
		> /dev/null ; \
	then
		ot-kernel-common_apply_genpatch_base_patchset
	fi
}

# @FUNCTION: apply_genpatch_experimental
# @DESCRIPTION:
# Apply the experimental genpatches patchset.
#
# ot-kernel-common_apply_genpatch_experimental_patchset - callback to apply
#   individual patches
#
function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	# don't need since we apply upstream
	if declare -f ot-kernel-common_apply_genpatch_experimental_patchset \
		> /dev/null ; \
	then
		ot-kernel-common_apply_genpatch_experimental_patchset
	fi
}

# @FUNCTION: apply_genpatch_extras
# @DESCRIPTION:
# Apply the extra genpatches patchset.
#
# ot-kernel-common_apply_genpatch_extras_patchset - callback to apply \
#   individual patches
#
function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${GENPATCHES_EXTRAS_FN}"

	cd "${S}"

	if declare -f ot-kernel-common_apply_genpatch_extras_patchset \
		> /dev/null ; \
	then
		ot-kernel-common_apply_genpatch_extras_patchset
	fi
}

# @FUNCTION: apply_o3
# @DESCRIPTION:
# Apply the GraySky2 O3 patchset.
#
# ot-kernel-common_apply_o3_fixes - callback for fix to O3 patches
#
function apply_o3() {
	cd "${S}"

	# fix patch
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" \
		"${DISTDIR}"/${O3_CO_FN} \
		> "${T}"/${O3_CO_FN} || die

	einfo "Applying O3"
	ewarn \
"Some patches have hunk(s) failed but still good or may be fixed ASAP."

	einfo "Applying ${O3_CO_FN}"
	_tpatch "${PATCH_OPS}" "${T}/${O3_CO_FN}"

	einfo "Applying ${O3_RO_FN}"
	mkdir -p drivers/gpu/drm/amd/display/dc/basics/
	# trick patch for unattended patching
	touch drivers/gpu/drm/amd/display/dc/basics/logger.c
	_tpatch "-p1 -N" "${DISTDIR}/${O3_RO_FN}"

	if declare -f ot-kernel-common_apply_o3_fixes > /dev/null ; then
		ot-kernel-common_apply_o3_fixes
	fi
}

# @FUNCTION: apply_pds
# @DESCRIPTION:
# Apply the PDS CPU scheduler patchset.
function apply_pds() {
	cd "${S}"
	einfo "Applying pds"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${PDS_FN}"
}

# @FUNCTION: apply_bmq
# @DESCRIPTION:
# Apply the BMQ CPU scheduler patchset.
#
# ot-kernel-common_apply_bmq_quickfixes - callback to apply quick fixes
#
function apply_bmq() {
	cd "${S}"
	einfo "Applying bmq"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_FN}"

	if declare -f ot-kernel-common_apply_bmq_quickfixes > /dev/null ; then
		ot-kernel-common_apply_bmq_quickfixes
	fi
}

# @FUNCTION: apply_tresor
# @DESCRIPTION:
# Apply the TRESOR AES cold boot resistant patchset.
#
# ot-kernel-common_apply_tresor_fixes - callback to apply tresor fixes
#
function apply_tresor() {
	cd "${S}"
	einfo "Applying tresor"
	ewarn \
"Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local platform
	if use tresor_aesni ; then
		platform="aesni"
	fi
	if use tresor_i686 || use tresor_x86_64 ; then
		platform="i686"
	fi

	_tpatch "${PATCH_OPS}" \
		"${DISTDIR}/tresor-patch-${PATCH_TRESOR_VER}_${platform}"
	if declare -f ot-kernel-common_apply_tresor_fixes > /dev/null ; then
		ot-kernel-common_apply_tresor_fixes
	fi
}

# @FUNCTION: fetch_bfq
# @DESCRIPTION:
# Fetches the BFQ patchset.
function fetch_bfq() {
	einfo "Fetching the BFQ patch from a live source..."
	wget -O "${T}/${BFQ_FN}" "${BFQ_DL_URL}" || die
}

# @FUNCTION: fetch_zentune
# @DESCRIPTION:
# Fetches the zentune patchset.
function fetch_zentune() {
	einfo "Fetching the zen-tune patch from a live source..."
	wget -O "${T}/${ZENTUNE_FN}" "${ZENTUNE_DL_URL}" || die
}

# @FUNCTION: fetch_linux_sources
# @DESCRIPTION:
# Fetches a local copy of the linux kernel repo.
function fetch_linux_sources() {
	einfo "Fetching the vanilla Linux kernel sources.  It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"

	if [[ -d "${d}" ]] ; then
		pushd "${d}" || die
		if ! ( git remote -v | grep -F -e "${LINUX_REPO_URL}" ) \
			> /dev/null ; \
		then
			einfo "Removing ${d}"
			rm -rf "${d}" || die
		fi
		popd
	fi

	addwrite "${b}"

	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}" || die
		einfo "Cloning the vanilla Linux kernel project"
		git clone "${LINUX_REPO_URL}" "${d}"
		cd "${d}" || die
		git checkout master
		git checkout -b v${PV} tags/v${PV}
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die \
"You must manually \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the vanilla Linux kernel project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D v${PV}
		git checkout -b v${PV} tags/v${PV}
		git pull
	fi
	cd "${d}" || die
}

# @FUNCTION: get_patch_index
# @DESCRIPTION:
# Returns the index of a commit.
# @CODE
# Parameters:
# $1 - the patchset (the repo folder name containing the commit)
# $2 - commit
# @CODE
function get_patch_index() {
	local patchset_name="${1}"
	local commit="${2}"
	d="${T}/${patchset_name}"
	local idx
	local f
	f=$(basename $(ls "${d}"/*${commit}*))
	idx=$(echo ${f} | cut -f1 -d '-' | sed 's/^0*//' | sed 's|[a-zA-Z]||g')
	echo ${idx}
}

# @FUNCTION: get_linux_commit_list_for_amdgpu_range
# @DESCRIPTION:
# Gets the list of commits between oldest timestamp from between min timestamp"
# of AMD_STAGING_INTERSECTS_KV (2019) and ROCK_BASE (2014) to K_MAJOR_MINOR
function get_linux_commit_list_for_amdgpu_range() {
	if [[ -e "${FILESDIR}/${LINUX_HASHTABLE_COMMITS_VK_FN}" \
		&& -e "${FILESDIR}/${LINUX_HASHTABLE_SUMMARIES_VK_FN}" ]] ; \
	then
		cp -a "${FILESDIR}/${LINUX_HASHTABLE_COMMITS_VK_FN}" "${T}"
		cp -a "${FILESDIR}/${LINUX_HASHTABLE_SUMMARIES_VK_FN}" "${T}"
		return
	fi

	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	d="${distdir}/ot-sources-src/linux"
	cd "${d}" || die
	einfo \
"Grabbing list of already merged amdgpu commits in v${K_MAJOR_MINOR} vanilla\n"
"sources."
	OIFS="${IFS}"
	IFS=$'\n'
	git -P log ${ROCK_BASE}..v${K_MAJOR_MINOR} --oneline \
		--pretty=format:"%H%x07%s" -- \
		drivers/gpu/drm \
		include/drm \
		drivers/dma-buf \
		include/linux \
		include/uapi/drm \
		| echo -e "\n$(cat -)" \
		| tac > "${T}/${LINUX_COMMITS_AMDGPU_RANGE_FN}"

	einfo "Generating hash tables for vanilla kernel"
	unset vk_commits
	unset vk_summaries
	declare -A vk_commits
	declare -A vk_summaries
	while read -r l ; do
		local h
		h=$(echo "${l}" | cut -f1 -d $'\007')
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			vk_commits[${h}]=1
		fi
		local s=$(echo "${l}" | cut -f2 -d $'\007')
		h=$(echo -e "${s}" | sha1sum | cut -f1 -d ' ')
		if [[ -n "${h}" && "${h}" != " " ]] ; then
			vk_summaries[${h}]=1
		fi
	done < "${T}/${LINUX_COMMITS_AMDGPU_RANGE_FN}"
	IFS="${OIFS}"
	typeset -p vk_commits > "${T}/${LINUX_HASHTABLE_COMMITS_VK_FN}"
	typeset -p vk_summaries > "${T}/${LINUX_HASHTABLE_SUMMARIES_VK_FN}"
	sed -i -r -e "s|^declare -A ||" "${T}/${LINUX_HASHTABLE_COMMITS_VK_FN}"
	sed -i -r -e "s|^declare -A ||" "${T}/${LINUX_HASHTABLE_SUMMARIES_VK_FN}"
}

# @FUNCTION: apply_amdgpu
# @DESCRIPTION:
# Applies amd-staging-drm-next and ROCk.
#
# ot-kernel-common_amdgpu_merge_and_apply_patches - optional callback that
#   merges amd-staging-drm-next and ROCk fixes
#
function apply_amdgpu() {
	if use amd-staging-drm-next-snapshot \
		|| use amd-staging-drm-next-milestone \
		|| use rock-snapshot \
		|| use rock-milestone ; \
	then
		if [[ ! -e "${FILESDIR}/${LINUX_HASHTABLE_COMMITS_VK_FN}" \
		|| ! -e "${FILESDIR}/${LINUX_HASHTABLE_SUMMARIES_VK_FN}" ]] ; \
		then
			fetch_linux_sources
		fi
	else
		ewarn \
"It is recommended to use the rock-snapshot or rock-milestone USE flag or you \
need to fetch vanilla sources to regen the commit cache list."
		fetch_linux_sources
	fi

	#AMDGPU_BASE="${AMD_STAGING_INTERSECTS_ROCK}"

	get_linux_commit_list_for_amdgpu_range

	fetch_amd_staging_drm_next
	fetch_rock

	if declare -f ot-kernel-common_amdgpu_merge_and_apply_patches \
		> /dev/null ; \
	then
		ot-kernel-common_amdgpu_merge_and_apply_patches
	fi
}

# @FUNCTION: _check_filterdiff
# @DESCRIPTION:
# Checks if filterdiff can preserve renamed files
function _check_filterdiff() {
	cp -a \
	"${DISTDIR}/linux--dma-buf-rename-reservation_object-to-dma_resv.patch" \
		"${T}"
	filterdiff -i \
		"*/drivers/dma-buf/dma-resv.c" \
"${T}/linux--dma-buf-rename-reservation_object-to-dma_resv.patch" \
> "${T}/linux--dma-buf-rename-reservation_object-to-dma_resv.patch.result"
	if ! grep -q -F -e \
		"--- a/drivers/dma-buf/reservation.c" \
"${T}/linux--dma-buf-rename-reservation_object-to-dma_resv.patch.result" ; \
	then
		die \
"Your filterdiff is broken from the patchutils package which cannot handle\n"
"renamed files correctly.  Use the one from the oiledmachine-overlay or a"
"live version of the package."
	fi
}

# @FUNCTION: ot-kernel-common_src_unpack
# @DESCRIPTION:
# Applies patch sets in order.  It calls kernel-2_src_unpack.
function ot-kernel-common_src_unpack() {
	_check_filterdiff
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
		if $(ver_test $(gcc-version) -ge 9.1) \
			&& test -f "${DISTDIR}/${GRAYSKY_DL_9_1_FN}" ; \
		then
			einfo "GCC patch is 9.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_9_1_FN}"
		elif $(ver_test $(gcc-version) -ge 8.1) \
			&& test -f "${DISTDIR}/${GRAYSKY_DL_8_1_FN}" ; \
		then
			einfo "GCC patch is 8.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_8_1_FN}"
		elif test -f "${DISTDIR}/${GRAYSKY_DL_4_9_FN}" ; then
			einfo "GCC patch is 4.9"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_4_9_FN}"
		else
			die "Cannot find graysky2's GCC patch."
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

	if has pds ${IUSE_EFFECTIVE} ; then
		if use pds ; then
			apply_pds
		fi
	fi

	if has bmq ${IUSE_EFFECTIVE} ; then
		if use bmq ; then
			apply_bmq
		fi
	fi

	apply_genpatch_base
	apply_genpatch_experimental
	apply_genpatch_extras

	# should be done after all the kernel point releases contained in
	# apply_genpatch_base
	fetch_cve_hotfixes

	if has amd-staging-drm-next-snapshot ${IUSE_EFFECTIVE} \
		|| has amd-staging-drm-next-latest ${IUSE_EFFECTIVE} \
		|| has amd-staging-drm-next-milestone ${IUSE_EFFECTIVE} ; \
	then
		apply_amdgpu
	fi

	if use o3 ; then
		apply_o3
	fi

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			apply_tresor
		fi
	fi

	apply_cve_hotfixes

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
}

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel-common_pkg_setup() {
	if declare -f ot-kernel-common_pkg_setup_cb > /dev/null ; then
		ot-kernel-common_pkg_setup_cb
	fi
}

# @FUNCTION: ot-kernel-common_pkg_pretend_cb
# @DESCRIPTION:
# Perform checks and warnings before emerging
function ot-kernel-common_pkg_pretend() {
	if declare -f ot-kernel-common_pkg_pretend_cb > /dev/null ; then
		ot-kernel-common_pkg_pretend_cb
	fi
}

# @FUNCTION: ot-kernel-common_src_compile
# @DESCRIPTION:
# Compiles the userland programs especially the post-boot TRESOR AES post boot
# program.
function ot-kernel-common_src_compile() {
	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			cp -a "${DISTDIR}/tresor_sysfs.c" "${T}"
			cd "${T}"
			einfo "$(tc-getCC) ${CFLAGS}"
			$(tc-getCC) ${CFLAGS} tresor_sysfs.c -o tresor_sysfs || die
		fi
	fi
}

# @FUNCTION: ot-kernel-common_src_install
# @DESCRIPTION:
# Removes patch cruft.
function ot-kernel-common_src_install() {
	find "${S}" -name "*.orig" -print0 -o -name "*.rej" -print0 \
		| xargs -0 rm

	if has tresor ${IUSE_EFFECTIVE} ; then
		if use tresor ; then
			docinto /usr/share/${PF}
			dodoc "${DISTDIR}/tresor-readme.html"
		fi
	fi

}

# @FUNCTION: ot-kernel-common_pkg_postinst
# @DESCRIPTION:
# Present warnings and avoid collision checks.
#
# ot-kernel-common_pkg_postinst_cb - callback if any to handle after emerge phase
#
function ot-kernel-common_pkg_postinst() {
	if use disable_debug ; then
		einfo \
"The disable debug scripts have been placed in your /usr/src folder.\n"\
"They disable debug paths, logging, output for a performance gain.\n"\
"You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`\n"
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" \
			"${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" \
			"${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

	if has tresor_sysfs ${IUSE_EFFECTIVE} ; then
		if use tresor_sysfs ; then
			# prevent merge conflicts
			cd "${T}"
			mv tresor_sysfs "${EROOT}/usr/bin" || die
			chmod 700 "${EROOT}"/usr/bin/tresor_sysfs || die
			# same hash for 5.1 and 5.0.13 for tresor_sysfs
			einfo \
"/usr/bin/tresor_sysfs is provided to set your TRESOR key"
		fi
	fi

	if declare -f ot-kernel-common_pkg_postinst_cb > /dev/null ; then
		ot-kernel-common_pkg_postinst_cb
	fi

}
