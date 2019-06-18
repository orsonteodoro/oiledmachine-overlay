# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.0/5.0-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/bfq-backports
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

K_MAJOR_MINOR="4.20"
K_PATCH_XV="4.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="4.20"
PATCH_UKSM_MVER="4"
PATCH_ZENTUNE_VER="4.20"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="4.0"
PATCH_CK_MAJOR_MINOR="4.20"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="18"
PATCH_GP_MAJOR_MINOR_REVISION="4.20-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="4.20"
PATCH_PDS_VER="099n"
PATCH_BFQ_VER="4.20"
PATCH_TRESOR_VER="3.18.5"
DISABLE_DEBUG_V="1.1"

IUSE="bfq +cfs disable_debug +graysky2 muqss +o3 pds uksm tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs -zentune"
REQUIRED_USE="^^ ( muqss pds cfs )
	      tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	      tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	      tresor_i686? ( tresor )
	      tresor_x86_64? ( tresor )
	      tresor_aesni? ( tresor )"

REQUIRED_USE+="" # disabled for now

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs versionator
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="
	dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, Genpatches, BFQ updates, TRESOR"

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

SRC_URI="${KERNEL_URI}
	 ${GENPATCHES_URI}
	 ${ARCH_URI}
	 ${UKSM_SRC_URL}
	 ${O3_CO_SRC_URL}
	 ${O3_RO_SRC_URL}
	 ${GRAYSKY_SRC_4_9_URL}
	 ${GRAYSKY_SRC_8_1_URL}
	 ${CK_SRC_URL}
	 ${PDS_SRC_URL}
	 ${GENPATCHES_BASE_SRC_URL}
	 ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	 ${GENPATCHES_EXTRAS_SRC_URL}
	 ${TRESOR_AESNI_DL_URL}
	 ${TRESOR_I686_DL_URL}
	 ${TRESOR_SYSFS_DL_URL}
	 ${TRESOR_README_DL_URL}
	 ${TRESOR_SRC_URL}
	 ${KERNEL_PATCH_URLS[@]}
	 "

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 100"

pkg_setup() {
	ewarn "ot-sources is only for research purposes or to access tresor devices.  It is vulnerable and EOL."

	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
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

function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"
	#_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-4.19-invalidate-range-linux-5.0.6.patch"
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
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-5.0.13.patch"
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

	apply_genpatch_base
	#apply_genpatch_experimental
	apply_genpatch_extras

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
		ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will cause a kernel panic on boot."
		ewarn "The MuQSS scheduler may have random system hard pauses for few seconds to around a minute when resource usage is high."
	fi
}
