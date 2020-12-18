#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v4.14.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 4.14.x kernel
# @DESCRIPTION:
# The ot-kernel-v4.14 eclass defines specific applicable patching for the
# 4.14.x linux kernel.

# tresor passes cipher but not skcipher in self test (/proc/crypto); there is
# a error in dmesg

# [    4.036411] alg: skcipher: setkey failed on test 2 for ecb(tresor-driver): flags=200000
# [    4.038166] alg: skcipher: Failed to load transform for ecb(tresor): -2
# [    4.042266] alg: skcipher: setkey failed on test 3 for cbc(tresor-driver): flags=200000
# [    4.043783] alg: skcipher: Failed to load transform for cbc(tresor): -2

# errors from dmesg in 4.9

# [    3.355692] alg: skcipher: setkey failed on test 2 for ecb(tresor-driver): flags=200000
# [    3.357297] alg: skcipher: Failed to load transform for ecb(tresor): -2
# [    3.361164] alg: skcipher: setkey failed on test 3 for cbc(tresor-driver): flags=200000



# some of these wont appear unless you use them in userspace with crypsetup
# benchmark results for /proc/crypto in 4.9

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

# Results for 4.9.182
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


# Results for 4.9.199
# cryptsetup benchmark -c tresor-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        26.0 MiB/s        19.0 MiB/s

# cryptsetup benchmark -c tresor-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        25.4 MiB/s        18.8 MiB/s

# cryptsetup benchmark -c aes-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        128b       130.6 MiB/s       157.8 MiB/s

# cryptsetup benchmark -c aes-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        128b       158.5 MiB/s       177.5 MiB/s


K_MAJOR_MINOR="4.14"
K_PATCH_XV="4.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="4.14"
PATCH_UKSM_MVER="4"
PATCH_ZENTUNE_VER="4.19"
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_KGCCP_COMMIT="c53ae690ee282d129fae7e6e10a4c00e5030d588" # GraySky2's kernel_gcc_patch
PATCH_PDS_MAJOR_MINOR="4.14"
PATCH_PDS_VER="${PATCH_PDS_VER:=098i}"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?135}"
PATCH_GP_MAJOR_MINOR_REVISION="4.14-${K_GENPATCHES_VER}"
PATCH_BFQ_VER="4.19"
PATCH_TRESOR_VER="3.18.5"
DISABLE_DEBUG_V="1.1"
BFQ_BRANCH="bfq"
MUQSS_VER="0.162"

# Obtained from:  date -d "2017-11-12 10:46:13 -0800" +%s
LINUX_TIMESTAMP=1510512373

IUSE="+cfs disable_debug +genpatches +kernel_gcc_patch muqss pds \
+O3 tresor tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64 uksm"
REQUIRED_USE="^^ ( cfs muqss pds )
tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
tresor_aesni? ( tresor )
tresor_i686? ( tresor )
tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
tresor_x86_64? ( tresor )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, GraySky2's Kernel \
GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, genpatches, TRESOR"

inherit ot-kernel

LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" kernel_gcc_patch? ( GPL-2 )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" pds? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # do not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no default license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v${K_PATCH_XV}/linux-${K_MAJOR_MINOR}.tar.xz
	   ${KERNEL_PATCH_URLS[@]}"
fi

SRC_URI+=" genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URL}
		${GENPATCHES_EXPERIMENTAL_SRC_URL}
		${GENPATCHES_EXTRAS_SRC_URL}
	   )
	   kernel_gcc_patch? (
		${KGCCP_SRC_4_9_URL}
		${KGCCP_SRC_8_1_URL}
	   )
	   O3? (
		${O3_CO_SRC_URL}
		${O3_RO_SRC_URL}
	   )
	   pds? ( ${PDS_SRC_URL} )
	   tresor? (
		${TRESOR_AESNI_DL_URL}
		${TRESOR_I686_DL_URL}
		${TRESOR_SYSFS_DL_URL}
		${TRESOR_README_DL_URL2}
		${TRESOR_RESEARCH_PDF_DL_URL}
	   )
	   uksm? ( ${UKSM_SRC_URL} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	# tresor for x86_64 generic was known to pass crypto testmgr on this
	# version.
	ewarn \
"This ot-sources ${PV} release is only for research purposes or to access \n\
tresor devices.  This 4.14.x series is EOL for this repo but not for\n\
upstream.  It will be removed immediately once tresor has been fixed for\n\
mainline / stable for >=5.x ."

	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
			ewarn \
"The zen-tune patch might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
		fi
	fi

	if use muqss ; then
		ewarn \
"muqss might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
	fi

	if use tresor ; then
		if ver_test ${PV} -ge 4.17 ; then
			ewarn \
	"TRESOR is broken for ${PV}.  Use 4.14.x series.  For ebuild devs only."
		fi
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	# for 4.20 series and 5.x use tresor-testmgr-ciphers-update.patch instead
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update-for-linux-4.14.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64_v2.1.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait.patch"
	#fi

	# for 5.x series uncomment below
	#_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-4.14.127.patch"

        #_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-fix-warnings-for-tresor_key_c.patch"
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will\n\
  cause a kernel panic on boot."
	fi
}

# @FUNCTION: ot-kernel_apply_o3_fixes
# @DESCRIPTION:
# Fixes the O3 patch
function ot-kernel_apply_o3_fixes() {
	if use O3 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/O3-config-option-7d0295dc49233d9ddff5d63d5bdc24f1e80da722-fix-for-4.14.patch"
	fi
}
