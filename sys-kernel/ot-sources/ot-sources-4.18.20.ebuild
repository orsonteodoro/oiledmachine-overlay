# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKMS:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v4.18...zen-kernel:4.18/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/4.0/4.18/4.18-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v4.18...zen-kernel:4.18/bfq
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

PATCH_UKMS_VER="4.18"
PATCH_ZENTUNE_VER="4.18"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="4.0"
PATCH_CK_MAJOR_MINOR="4.18"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="24"
PATCH_GP_MAJOR_MINOR_REVISION="4.18-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="4.18"
PATCH_PDS_VER="099a"
PATCH_BFQ_VER="4.18"
PATCH_TRESOR_VER="3.18.5"
KERNEL_COMMIT="94710cac0ef4ee177a63b5227664b38c95bbf703" # Linus' tag for 4.18.0
AMD_TAG="amd-18.50"

IUSE="+zentune +o3 +muqss pds +bfq +amd cfs +graysky2 +ukms tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs"
REQUIRED_USE="^^ ( muqss pds cfs ) tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor_i686? ( tresor ) tresor_x86_64? ( tresor ) tresor_aesni? ( tresor )"

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
BFQ_REPO="bfq"
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
	# strip failed sections so that amd parts don't get recked

	# missing idx var patch
	filterdiff \
		-x '*/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c' \
		"${d}/1004_linux-4.18.5.patch" > "${d}/1004_linux-4.18.5.patch.mod"
	mv "${d}/1004_linux-4.18.5.patch.mod" "${d}/1004_linux-4.18.5.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1007_linux-4.18.8.patch" > "${d}/1007_linux-4.18.8.patch.mod"
	mv "${d}/1007_linux-4.18.8.patch.mod" "${d}/1007_linux-4.18.8.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1008_linux-4.18.9.patch" > "${d}/1008_linux-4.18.9.patch.mod"
	mv "${d}/1008_linux-4.18.9.patch.mod" "${d}/1008_linux-4.18.9.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1009_linux-4.18.10.patch" > "${d}/1009_linux-4.18.10.patch.mod"
	mv "${d}/1009_linux-4.18.10.patch.mod" "${d}/1009_linux-4.18.10.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1010_linux-4.18.11.patch" > "${d}/1010_linux-4.18.11.patch.mod"
	mv "${d}/1010_linux-4.18.11.patch.mod" "${d}/1010_linux-4.18.11.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1011_linux-4.18.12.patch" > "${d}/1011_linux-4.18.12.patch.mod"
	mv "${d}/1011_linux-4.18.12.patch.mod" "${d}/1011_linux-4.18.12.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1012_linux-4.18.13.patch" > "${d}/1012_linux-4.18.13.patch.mod"
	mv "${d}/1012_linux-4.18.13.patch.mod" "${d}/1012_linux-4.18.13.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1013_linux-4.18.14.patch" > "${d}/1013_linux-4.18.14.patch.mod"
	mv "${d}/1013_linux-4.18.14.patch.mod" "${d}/1013_linux-4.18.14.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1014_linux-4.18.15.patch" > "${d}/1014_linux-4.18.15.patch.mod"
	mv "${d}/1014_linux-4.18.15.patch.mod" "${d}/1014_linux-4.18.15.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1016_linux-4.18.17.patch" > "${d}/1016_linux-4.18.17.patch.mod"
	mv "${d}/1016_linux-4.18.17.patch.mod" "${d}/1016_linux-4.18.17.patch"

	filterdiff \
		-x '*/drivers/gpu/drm/amd/*' \
		"${d}/1019_linux-4.18.20.patch" > "${d}/1019_linux-4.18.20.patch.mod1"

	filterdiff \
		-i '*/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c' \
		"${d}/1019_linux-4.18.20.patch" > "${d}/1019_linux-4.18.20.patch.mod2"
	cat "${d}/1019_linux-4.18.20.patch.mod1" "${d}/1019_linux-4.18.20.patch.mod2" > "${d}/1019_linux-4.18.20.patch"
	rm "${d}/1019_linux-4.18.20.patch.mod"{1,2}
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

	if use amd ; then
		remove_amd_fixes "${d}"
	fi

	#UNIPATCH doesn't have a _OPS so we have to do it manually
	L=$(ls -A1 "$d" | tail -n +2)
	for l in $L ; do
		_dpatch "${PATCH_OPS} -N" "$d/$l"
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
		_dpatch "${PATCH_OPS}" "${FILESDIR}/MuQSS-4.18-missing-se-member.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/muqss-dont-attach-ckversion.patch"
	fi

	if use pds ; then
		apply_pds
	fi

	if use amd ; then
		fetch_amd
		cd "${S}"
		_tpatch "${PATCH_OPS}" "${T}/${AMD_PATCH_FN}"
	fi

	apply_genpatch_base
	#apply_genpatch_experimental
	apply_genpatch_extras

	if use o3 ; then
		apply_o3
	fi

	if use tresor ; then
		apply_tresor
	fi

	_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.18-kconfig-ioscheds.patch"
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
