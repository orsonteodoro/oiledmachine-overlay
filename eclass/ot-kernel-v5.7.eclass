#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2020 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.7.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 5.7.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.7 eclass defines specific applicable patching for the 5.7.x
# linux kernel.

# /proc/crypto for TRESOR sse2 with kernel 5.7.10
# using the 256-bit AES patch
#name         : __xts(tresor)
#driver       : cryptd(__xts-tresor-sse2)
#module       : kernel
#priority     : 451
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 32
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : xts(tresor)
#driver       : xts-tresor-sse2
#module       : kernel
#priority     : 401
#refcnt       : 1
#selftest     : passed
#internal     : no
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 32
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __ctr(tresor)
#driver       : cryptd(__ctr-tresor-sse2)
#module       : kernel
#priority     : 450
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : yes
#blocksize    : 1
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : ctr(tresor)
#driver       : ctr-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : no
#type         : skcipher
#async        : yes
#blocksize    : 1
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __cbc(tresor)
#driver       : cryptd(__cbc-tresor-sse2)
#module       : kernel
#priority     : 450
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : cbc(tresor)
#driver       : cbc-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : no
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __ecb(tresor)
#driver       : cryptd(__ecb-tresor-sse2)
#module       : kernel
#priority     : 450
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 0
#chunksize    : 16
#walksize     : 16

#name         : ecb(tresor)
#driver       : ecb-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : no
#type         : skcipher
#async        : yes
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 0
#chunksize    : 16
#walksize     : 16

#name         : __xts(tresor)
#driver       : __xts-tresor-sse2
#module       : kernel
#priority     : 401
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : no
#blocksize    : 16
#min keysize  : 32
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __ctr(tresor)
#driver       : __ctr-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : no
#blocksize    : 1
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __cbc(tresor)
#driver       : __cbc-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : no
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 16
#chunksize    : 16
#walksize     : 16

#name         : __ecb(tresor)
#driver       : __ecb-tresor-sse2
#module       : kernel
#priority     : 400
#refcnt       : 1
#selftest     : passed
#internal     : yes
#type         : skcipher
#async        : no
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32
#ivsize       : 0
#chunksize    : 16
#walksize     : 16

#name         : tresor
#driver       : tresor-driver
#module       : kernel
#priority     : 100
#refcnt       : 1
#selftest     : passed
#internal     : no
#type         : cipher
#blocksize    : 16
#min keysize  : 16
#max keysize  : 32


#cryptsetup benchmark --cipher tresor-cbc --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        28.8 MiB/s        20.0 MiB/s

# cryptsetup benchmark --cipher tresor-cbc --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        192b        35.6 MiB/s        21.2 MiB/s

# cryptsetup benchmark --cipher tresor-cbc --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        256b        24.4 MiB/s        15.9 MiB/s


# cryptsetup benchmark --cipher tresor-ctr --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        128b        29.5 MiB/s        30.2 MiB/s

# cryptsetup benchmark --cipher tresor-ctr --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        192b        39.0 MiB/s        39.5 MiB/s

# cryptsetup benchmark --cipher tresor-ctr --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        256b        25.2 MiB/s        25.6 MiB/s


# cryptsetup benchmark --cipher tresor-ecb --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        29.9 MiB/s        19.4 MiB/s

# cryptsetup benchmark --cipher tresor-ecb --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        192b        38.5 MiB/s        22.0 MiB/s

# cryptsetup benchmark --cipher tresor-ecb --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        256b        25.3 MiB/s        15.7 MiB/s


# cryptsetup benchmark --cipher tresor-xts --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-xts        256b        28.2 MiB/s        19.2 MiB/s


# 5.7.x dmesg errors (in 4.14 there were dmesg errors):
#[    2.899917] alg: skcipher: ecb(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
#[    2.899940] alg: skcipher: cbc(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
#[    2.899960] alg: skcipher: ctr(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
#[    2.900098] alg: skcipher: xts(tresor) encryption test failed (wrong result) on test vector 1, cfg="in-place"


ETYPE="sources"

K_MAJOR_MINOR="5.7"
K_PATCH_XV="5.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.7"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.7"
PATCH_ALLOW_O3_COMMIT="f27de4dd3cd87dfcbacab7dba5eef893c19dcf3b"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?10}"
PATCH_GP_MAJOR_MINOR_REVISION="${K_MAJOR_MINOR}-${K_GENPATCHES_VER}"
PATCH_BFQ_VER="5.7"
PATCH_BMQ_MAJOR_MINOR="5.7"
PATCH_PROJECT_C_MAJOR_MINOR="5.7"
DISABLE_DEBUG_V="1.1"
ZENTUNE_5_7_COMMIT="03344d1ad1076dd6374f208f8de4c7f6da9dbcee..13f40f309a6a443fcdcc51759dc3a4a0f9b7910f" # (exclusive-end,inclusive-start]
PATCH_TRESOR_VER="3.18.5"
ZSTD_VER="4"
MUQSS_VER="0.202"

IUSE="bfq bmq +cfs disable_debug futex-wait-multiple +genpatches +graysky2 \
muqss +o3 prjc tresor tresor_aesni tresor_i686 tresor_sysfs tresor_x86_64 \
tresor_x86_64-256-bit-key-support uksm zenmisc -zentune zstd"
REQUIRED_USE="\
!bfq
^^ ( bmq cfs muqss prjc ) \
tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
tresor_aesni? ( tresor )
tresor_i686? ( tresor )
tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
tresor_x86_64? ( tresor )
tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED=${K_SECURITY_UNSUPPORTED:="1"}

inherit kernel-2 toolchain-funcs
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package containing UKSM, zen-kernel patchset, GraySky's GCC \
Patches, MUQSS CPU Scheduler, BMQ CPU Scheduler, Project C CPU Scheduler, \
Genpatches, BFQ updates, CVE fixes, TRESOR, zstd"

inherit check-reqs ot-kernel-common

#BMQ_QUICK_FIX_FN="3606d92b4e7dd913f485fb3b5ed6c641dcdeb838.patch"
#BMQ_SRC_URL+=" https://gitlab.com/alfredchen/linux-bmq/commit/${BMQ_QUICK_FIX_FN}"

SRC_URI+=" ${ARCH_URI}
	   ${KERNEL_PATCH_URLS[@]}
	   ${KERNEL_URI}
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URL}
		${GENPATCHES_EXPERIMENTAL_SRC_URL}
		${GENPATCHES_EXTRAS_SRC_URL}
	   )
	   bmq? ( ${BMQ_SRC_URL} )
	   graysky2? (
		${GRAYSKY_SRC_4_9_URL}
		${GRAYSKY_SRC_8_1_URL}
		${GRAYSKY_SRC_9_1_URL}
		${GRAYSKY_SRC_10_1_URL}
	   )
	   o3? ( ${O3_ALLOW_SRC_URL} )
	   prjc? ( ${PRJC_SRC_URL} )
	   tresor? (
		${TRESOR_AESNI_DL_URL}
		${TRESOR_I686_DL_URL}
		${TRESOR_README_DL_URL2}
		${TRESOR_RESEARCH_PDF_DL_URL}
		${TRESOR_SYSFS_DL_URL}
	   )
	   uksm? ( ${UKSM_SRC_URL} )"

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	if has zentune ${IUSE_EFFECTIVE} ; then
		if use zentune ; then
		ewarn \
"The zen-tune patch might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
		fi
	fi

	if use tresor ; then
		if ver_test ${PV} -ge 4.17 ; then
			ewarn \
	"TRESOR is experimental for ${PV}.  Use 4.14.x series for stable TRESOR."
		fi
	fi
}

# @FUNCTION: ot-kernel-common_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel-common_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64_v2.1.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait.patch"
	#fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-i686-v2.1.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-glue-remove-xts-casts-and-api-updates-for-5.6-i686.patch"
	else
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-aesni-v2.1.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-glue-remove-xts-casts-and-api-updates-for-5.6-aesni.patch"
	fi

	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-fix-warnings-for-tresor_key_c.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-256-bit-aes-support-i686-v2-for-5.7.patch"
		fi
	fi
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
	if use tresor_x86_64-256-bit-key-support ; then
		ewarn \
"\n\
192- and 256-bit key support was added to TRESOR (sse2 for 64-bit) but is\n\
experimental.\n\
\n"
	fi
}
