# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKMS:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v4.20...zen-kernel:4.20/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/4.0/4.20/4.20-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v4.20...zen-kernel:4.20/bfq-backports
# AMD kernel updates:           https://cgit.freedesktop.org/~agd5f/linux/
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
	  http://www1.informatik.uni-erlangen.de/tresor
          "

PATCH_UKMS_VER="4.20"
PATCH_ZENTUNE_VER="4.20"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="4.0"
PATCH_CK_MAJOR_MINOR="4.20"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="15"
PATCH_GP_MAJOR_MINOR_REVISION="4.20-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="4.20"
PATCH_PDS_VER="099n"
PATCH_BFQ_VER="4.20"
PATCH_TRESOR_VER="3.18.5"
KERNEL_COMMIT="8fe28cb58bcb235034b64cbbb7550a8a43fd88be" # Linus' tag for 4.20.0
AMD_TAG="amd-staging-drm-next"
AMD_COMMIT_LAST_STABLE="fa16d1eb6a78b265480bd4c2b8739c1ea261cdd8" # amd-18.50 branch latest commit equivalent

IUSE="-zentune +o3 muqss +pds +bfq +amd amd-testing cfs +graysky2 +ukms tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs"
REQUIRED_USE="^^ ( muqss pds cfs ) tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor_i686? ( tresor ) tresor_x86_64? ( tresor ) tresor_aesni? ( tresor ) amd-testing? ( amd )"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs versionator
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="amd? ( dev-vcs/git )
	dev-util/patchutils"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKMS, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, Genpatches, BFQ updates, AMD kernel updates, TRESOR"

AMDREPO_URL="git://people.freedesktop.org/~agd5f/linux"
AMD_PATCH_FN="${AMD_TAG}.patch"

UKMS_BASE="https://raw.githubusercontent.com/dolohow/uksm/master/v4.x/"
UKMS_FN="uksm-${PATCH_UKMS_VER}.patch"
UKMS_SRC_URL="${UKMS_BASE}${UKMS_FN}"

ZENTUNE_URL_BASE="https://github.com/torvalds/linux/compare/v${PATCH_ZENTUNE_VER}...zen-kernel:${PATCH_ZENTUNE_VER}/"
ZENTUNE_FN="zen-tune.diff"
ZENTUNE_DL_URL="${ZENTUNE_URL_BASE}${ZENTUNE_FN}"
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


SRC_URI="${KERNEL_URI}
	 ${GENPATCHES_URI}
	 ${ARCH_URI}
	 ${UKMS_SRC_URL}
	 ${ZENTUNE_SRC_URL}
	 ${O3_CO_SRC_URL}
	 ${O3_RO_SRC_URL}
	 ${GRAYSKY_SRC_4_9_URL}
	 ${GRAYSKY_SRC_8_1_URL}
	 ${CK_SRC_URL}
	 ${PDS_SRC_URL}
	 ${BFQ_SRC_URL}
	 ${ZENTUNE_SRC_URL}
	 ${GENPATCHES_BASE_SRC_URL}
	 ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	 ${GENPATCHES_EXTRAS_SRC_URL}
	 ${TRESOR_AESNI_DL_URL}
	 ${TRESOR_I686_DL_URL}
	 ${TRESOR_SYSFS_DL_URL}
	 ${TRESOR_README_DL_URL}
	 ${TRESOR_SRC_URL}
	 "

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 100"

pkg_setup() {
	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi

	if use bfq ; then
		ewarn "The bfq patch applied may cause a kernel panic if it doesn't turn on the feature"
		ewarn "\"SCSI: use blk-mq I/O path by default\" (CONFIG_SCSI_MQ_DEFAULT) or uses another IO scheduler other than BFQ."
	fi

	#use deblob && python-any-r1_pkg_setup
        kernel-2_pkg_setup
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

function apply_genpatch_base() {
	einfo "Applying genpatch base"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_BASE_FN}"

	cd "${S}"

	#UNIPATCH doesn't have a _OPS so we have to do it manually
	L=$(ls -A1 "$d" | tail -n +2)
	for l in $L ; do
		patch --dry-run ${PATCH_OPS} -N | grep "FAILED at"
		if [[ "$?" == "1" ]] ; then
			# already patched or good
			_tpatch "${PATCH_OPS} -N" "$d/$l"
		else
			eerror "Failed ${l}"
			die
		fi
	done
}

function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	#UNIPATCH doesn't have a _OPS so we have to do it manually
	L=$(ls -1 "$d" | tail -n +2)
	for l in $L ; do
		_dpatch "${PATCH_OPS}" "$d/$l"
	done
}

function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXTRAS_FN}"

	cd "${S}"

	#UNIPATCH doesn't have a _OPS so we have to do it manually
	L=$(ls -1 "$d" | tail -n +2)
	for l in $L ; do
		_dpatch "${PATCH_OPS}" "$d/$l"
	done
}

function apply_o3() {
	cd "${S}"

	# fix patch
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" ${DISTDIR}/${O3_CO_FN} > ${T}/${O3_CO_FN} || die

	einfo "Applying O3"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	einfo "Applying ${O3_CO_FN}"
	_dpatch "${PATCH_OPS}" "${T}/${O3_CO_FN}"
	einfo "Applying ${O3_RO_FN}"
	touch drivers/gpu/drm/amd/display/dc/basics/logger.c # trick patch for unattended patching
	_tpatch "-p1 -N" "${DISTDIR}/${O3_RO_FN}"
}

function apply_pds() {
	cd "${S}"
	einfo "Applying pds"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${PDS_FN}"
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
}

function fetch_amd() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_TAG}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	mkdir -p "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		einfo "Cloning AMD project"
		git clone -b ${AMD_TAG} ${AMDREPO_URL} "${d}"
	else
		einfo "Updating AMD project"
		cd "${d}"
		git pull
	fi
	cd "${d}"
	einfo "Generating AMD patch"
	git diff ${KERNEL_COMMIT}..origin/${AMD_TAG} > "${T}/${AMD_PATCH_FN}"

	local target
	if use amd-testing ; then
		target="${AMD_TAG}"
	else
		target="${AMD_COMMIT_LAST_STABLE}"
	fi

	#L=$(git log ${KERNEL_COMMIT}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e " drm:" -e "drm/syncobj" -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	#L=$(git log ${KERNEL_COMMIT}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "syncobj" -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	L=$(git log ${KERNEL_COMMIT}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	n="1"
	mkdir "${T}/amd-patches"
	for l in $L ; do
	        echo "Getting patch for $l"
	        git format-patch --stdout -1 $l > "${T}"/amd-patches/$(printf "%05d" $n)-$l.patch
	        n=$((n+1))
	done
}

src_unpack() {
	if use zentune ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${ZENTUNE_FN}"
	fi
	if use ukms ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${UKMS_FN}"
	fi
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
	if use bfq ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${BFQ_FN}"
	fi

	kernel-2_src_unpack

	cd "${S}"

	if use muqss ; then
		#_dpatch "${PATCH_OPS}" "${FILESDIR}/MuQSS-4.18-missing-se-member.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/muqss-dont-attach-ckversion.patch"
	fi

	if use pds ; then
		apply_pds
	fi

	if use amd ; then
		fetch_amd
		cd "${S}"
		L=$(ls -1 "${T}"/amd-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*86bbd89d5da66fe760049ad3f04adc407ec0c4d6*)
						# fix failed patching
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-86bbd89d5da66fe760049ad3f04adc407ec0c4d6-fix.patch"
						;;
					*333f340fac75dc203a53194dec078016b43e40fe*|\
					*b9d0c7f1631709a0a98df01e63847fd5824c97b4*|\
					*ec462192691e57e231a5a36799a7849f2af2485f*|\
					*f0371ac7148c901a305ba5cdc4b6f85dbb3e2076*)
						# 5.0 kernel only
						;;
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*24f7dd7ea98dc54fa45a0dd10c7a472e00ca01d4*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-24f7dd7ea98dc54fa45a0dd10c7a472e00ca01d4-fix.patch"
						;;
					*45cf8c23f3564e3f39ae09b70b9dff24acae4a56*|\
					*4fb2c933c9656435e8300fd6011daa3d4b0128fd*)
						# already applied or not needed
						;;
					*333f340fac75dc203a53194dec078016b43e40fe*|\
					*b9d0c7f1631709a0a98df01e63847fd5824c97b4*|\
					*ec462192691e57e231a5a36799a7849f2af2485f*|\
					*f0371ac7148c901a305ba5cdc4b6f85dbb3e2076*)
						# 5.0 kernel only
						;;
					*131280a162e7fc2a539bb939efd28dd0b964c62c*)
						# needs custom patch
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						die
						;;
					*694d0775ca94beccfa8332d9284c1e8b6b19ad01*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-694d0775ca94beccfa8332d9284c1e8b6b19ad01-fix.patch"
						;;
					*2d3030a00ef1dbdbf3df8893c225cb37d88a1ff2*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-2d3030a00ef1dbdbf3df8893c225cb37d88a1ff2-dedupe.patch"
						;;
					*206bbafe00dcacccf40e6f09e624329ec124201b*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-206bbafe00dcacccf40e6f09e624329ec124201b-fix.patch"
						;;
					*a9f34c70fd168b164aadffd46bb757ded52e25b9*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-a9f34c70fd168b164aadffd46bb757ded52e25b9-fix.patch"
						;;
					*0aa7aa24cc11720a05b4492345f0adba8373c226*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-0aa7aa24cc11720a05b4492345f0adba8373c226-fix.patch"
						;;
					*43cf1fc0e27e2f7eeb5d6c15fd023813a5b49987*)
#						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
#						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-43cf1fc0e27e2f7eeb5d6c15fd023813a5b49987-fix.patch"
						# skip patch
						;;
					*0b258ed1a219a9776e8f6967eb34837ae0332e64*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-0b258ed1a219a9776e8f6967eb34837ae0332e64-fix.patch"
						;;
					*61a98b1b9a8c7a21a2d666a090dcf5f1c70c659f*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-61a98b1b9a8c7a21a2d666a090dcf5f1c70c659f-fix.patch"
						;;
					*3e70b04ab7874670e65c688f89ce210a6a482de6*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-3e70b04ab7874670e65c688f89ce210a6a482de6-fix.patch"
						;;
					*)
						eerror "Patch failure ${l}.  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	apply_genpatch_base
	#apply_genpatch_experimental
	apply_genpatch_extras

	if use amd ; then
		# fix patching errors caused by "patch -N" with apply_genpatch_*
		_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-72deff05bd4662b9aca75812b44a9bea646da1b0-dedupe.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/1004_linux-4.20.5-fix.patch"
		if use amd-testing ; then
			_dpatch "${PATCH_OPS}" "${FILESDIR}/1007_linux-4.20.8-fix-mispatch-amd-testing.patch"
			_dpatch "${PATCH_OPS}" "${FILESDIR}/1010_linux-4.20.11-fix.patch"
			_dpatch "${PATCH_OPS}" "${FILESDIR}/1012_linux-4.20.13-fix.patch"
		else
			_dpatch "${PATCH_OPS}" "${FILESDIR}/1007_linux-4.20.8-fix-mispatch-non-amd-testing.patch"
		fi
	fi

	if use o3 ; then
		apply_o3
	fi

	if use tresor ; then
		apply_tresor
	fi

	_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
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

	if use tresor_sysfs ; then
		cd "${T}"
		dobin tresor_sysfs
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	if use tresor_sysfs ; then
		einfo "/usr/bin/tresor_sysfs is provided to set your TRESOR key"
	fi
}
