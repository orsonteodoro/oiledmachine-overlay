# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v4.9.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 4.9.x kernel
# @DESCRIPTION:
# The ot-kernel-v4.9 eclass defines specific applicable patching for the 4.9.x linux kernel.

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.0/5.0-ck1/
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/bfq-backports
# TRESOR:			http://www1.informatik.uni-erlangen.de/tresor

# This ebuild exists because less patching required for tresor.  It is mostly working.

# errors from dmesg

# [    3.355692] alg: skcipher: setkey failed on test 2 for ecb(tresor-driver): flags=200000
# [    3.357297] alg: skcipher: Failed to load transform for ecb(tresor): -2
# [    3.361164] alg: skcipher: setkey failed on test 3 for cbc(tresor-driver): flags=200000

# results for /proc/crypto

# name         : cbc(tresor)
# driver       : cbc(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16
# ivsize       : 16
# geniv        : <default>

# name         : tresor
# driver       : tresor-driver
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : cipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16

# name         : xts(tresor)
# driver       : xts(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 32
# max keysize  : 32
# ivsize       : 16
# geniv        : <default>

# name         : ecb(tresor)
# driver       : ecb(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16
# ivsize       : 0
# geniv        : <default>

# results from cryptsetup

# cryptsetup benchmark -c tresor-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        15.1 MiB/s        10.0 MiB/s

# cryptsetup benchmark -c tresor-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        14.8 MiB/s        10.0 MiB/s

# cryptsetup benchmark -c aes-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        128b        75.3 MiB/s        83.6 MiB/s

# cryptsetup benchmark -c aes-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        128b        90.5 MiB/s        90.5 MiB/s

ETYPE="sources"

K_MAJOR_MINOR="4.9"
K_PATCH_XV="4.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="4.9"
PATCH_UKSM_MVER="4"
PATCH_ZENTUNE_VER="4.9"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="4.0"
PATCH_CK_MAJOR_MINOR="4.9"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?187}"
PATCH_GP_MAJOR_MINOR_REVISION="4.9-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_BFQ_VER="4.9"
PATCH_TRESOR_VER="3.18.5"
DISABLE_DEBUG_V="1.1"

IUSE="bfq +cfs disable_debug +graysky2 muqss +o3 uksm tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs -zentune"
REQUIRED_USE="^^ ( muqss cfs )
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
inherit python-any-r1 kernel-2 toolchain-funcs
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="
	dev-util/patchutils
	<sys-devel/gcc-8.0
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, Genpatches, BFQ updates, TRESOR"

CK_URL_BASE="http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

GRAYSKY_DL_4_9_FN="enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v3.15%2B.patch"

inherit ot-kernel-common

SRC_URI+=" ${KERNEL_URI}
	   ${GENPATCHES_URI}
	   ${ARCH_URI}
	   ${UKSM_SRC_URL}
	   ${O3_CO_SRC_URL}
	   ${O3_RO_SRC_URL}
	   ${GRAYSKY_SRC_4_9_URL}
	   ${CK_SRC_URL}
	   ${GENPATCHES_BASE_SRC_URL}
	   ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	   ${GENPATCHES_EXTRAS_SRC_URL}
	   ${TRESOR_AESNI_DL_URL}
	   ${TRESOR_I686_DL_URL}
	   ${TRESOR_SYSFS_DL_URL}
	   ${TRESOR_README_DL_URL}
	   ${TRESOR_SRC_URL}
	   ${KERNEL_PATCH_URLS[@]}"

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	# tresor for x86_64 generic was known to pass crypto testmgr on this version.
	ewarn "This ot-sources ${PV} release is only for research purposes or to access tresor devices.  This 4.9.x series EOL for this repo but not for upstream."

	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi

	GCC_V=$(gcc-version)
	version_compare ${GCC_V} 8.0
	if (( $? >= 3 )) ; then
		ewarn "You must switch your gcc to <8.0 to compile this version of ot-sources"
	fi
}

# @FUNCTION: ot-kernel-common_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel-common_apply_tresor_fixes() {
#	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-ciphers-update-for-linux-4.14.patch"

	if use tresor_x86_64 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-fix-addressing-mode-64-bit-index.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait-for-linux-4.9.182.patch"
	#fi

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-4.14.127.patch"
        #_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"
}

# @FUNCTION: ot-kernel-common_apply_genpatch_experimental_patchset
# @DESCRIPTION:
# Applies specific genpatches for this kernel major version
function ot-kernel-common_apply_genpatch_experimental_patchset() {
	_tpatch "${PATCH_OPS} -N" "$d/5001_block-cgroups-kconfig-build-bits-for-BFQ-v7r11-4.9.patch"
	_tpatch "${PATCH_OPS} -N" "$d/5002_block-introduce-the-BFQ-v7r11-I-O-sched-for-4.9.patch1"
	_tpatch "${PATCH_OPS} -N" "$d/5003_block-bfq-add-Early-Queue-Merge-EQM-to-BFQ-v7r11-for-4.9.patch"
	_tpatch "${PATCH_OPS} -N" "$d/5004_Turn-BFQ-v7r11-into-BFQ-v8r7-for-4.9.0.patch1"
	_tpatch "${PATCH_OPS} -N" "$d/5010_enable-additional-cpu-optimizations-for-gcc.patch"
}

# @FUNCTION: ot-kernel-common_apply_genpatch_extras_patchset
# @DESCRIPTION:
# Apply genpatches extra patches
function ot-kernel-common_apply_genpatch_extras_patchset() {
	_tpatch "${PATCH_OPS} -N" "$d/4200_fbcondecor.patch"
	_tpatch "${PATCH_OPS} -N" "$d/4400_alpha-sysctl-uac.patch"
	_tpatch "${PATCH_OPS} -N" "$d/4567_distro-Gentoo-Kconfig.patch"
}

# @FUNCTION: ot-kernel-common_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_pkg_postinst_cb() {
	if use muqss ; then
		ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will cause a kernel panic on boot."
		ewarn "The MuQSS scheduler may have random system hard pauses for few seconds to around a minute when resource usage is high."
	fi
}
