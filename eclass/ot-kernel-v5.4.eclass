#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v5.4.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the 5.4.x kernel
# @DESCRIPTION:
# The ot-kernel-v5.4 eclass defines specific applicable patching for the 5.4.x
# linux kernel.

# All benchmarks and tests are done on 5.4 series with sse2 version of TRESOR.

#cryptsetup benchmark --cipher tresor-cbc --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        24.9 MiB/s        14.7 MiB/s

#cryptsetup benchmark --cipher tresor-ecb --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        23.3 MiB/s        14.1 MiB/s

#cryptsetup benchmark --cipher tresor-ctr --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        128b        22.0 MiB/s        22.6 MiB/s

#cryptsetup benchmark --cipher aes-cbc --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        128b        92.6 MiB/s        88.6 MiB/s

#cryptsetup benchmark --cipher aes-ecb --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        128b        98.3 MiB/s       101.3 MiB/s

#cryptsetup benchmark --cipher aes-ctr --key-size 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ctr        128b        91.4 MiB/s        84.8 MiB/s

#cryptsetup benchmark --cipher tresor-xts --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-xts        256b        22.6 MiB/s        13.9 MiB/s

#cryptsetup benchmark --cipher aes-xts --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-xts        256b        98.8 MiB/s        98.9 MiB/s

#cryptsetup benchmark --cipher serpent-xts --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#serpent-xts        256b       123.6 MiB/s       121.4 MiB/s


# cryptsetup benchmark --cipher aes-cbc --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        192b        87.7 MiB/s        94.7 MiB/s

# cryptsetup benchmark --cipher aes-ctr --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ctr        192b        83.0 MiB/s        91.3 MiB/s

# cryptsetup benchmark --cipher aes-ecb --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        192b        95.8 MiB/s       102.3 MiB/s


#cryptsetup benchmark --cipher aes-cbc --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        256b        78.2 MiB/s        81.9 MiB/s

# cryptsetup benchmark --cipher aes-ctr --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ctr        256b        76.3 MiB/s        75.2 MiB/s

# cryptsetup benchmark --cipher aes-ecb --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        256b        93.9 MiB/s        88.9 MiB/s


# cryptsetup benchmark --cipher tresor-cbc --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        192b        31.3 MiB/s        17.9 MiB/s

#cryptsetup benchmark --cipher tresor-ctr --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        192b        33.3 MiB/s        32.1 MiB/s

# cryptsetup benchmark --cipher tresor-ecb --key-size 192
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        192b        32.6 MiB/s        18.1 MiB/s


# cryptsetup benchmark --cipher tresor-cbc --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        256b        19.1 MiB/s        13.5 MiB/s

# cryptsetup benchmark --cipher tresor-ctr --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ctr        256b        21.3 MiB/s        23.4 MiB/s

# cryptsetup benchmark --cipher tresor-ecb --key-size 256
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        256b        21.7 MiB/s        13.7 MiB/s





#Results of /proc/crypto for kernel 5.4.49 using tresor i686 with sse2 modded for x86_64:
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16
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
#max keysize  : 16

#--------------------------------------------------------
# With the 256 bit keys support patch for TRESOR sse2.
# Taken in Jul 24, 2020 with 5.4.52 kernel.

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

# 5.4.x dmesg errors (in 4.14 there were dmesg errors):
# alg: skcipher: ecb(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
# alg: skcipher: cbc(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
# alg: skcipher: ctr(tresor) encryption test failed (wrong result) on test vector 0, cfg="in-place"
# alg: skcipher: xts(tresor) encryption test failed (wrong result) on test vector 1, cfg="in-place"

DISABLE_DEBUG_V="1.1"
EXTRAVERSION="-ot"
GENPATCHES_BLACKLIST=" 2400"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?1}"
K_MAJOR=$(ver_cut 1 ${PV})
K_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
MUQSS_VER="0.196"
PATCH_ALLOW_O3_COMMIT="4edc8050a41d333e156d2ae1ed3ab91d0db92c7e"
PATCH_CK_COMMIT_B="5b6cd7cfe6cf6e1263b0a5d2ee461c8058b76213" # bottom / oldest
PATCH_CK_COMMIT_T="7acac2e4000e75f3349106a8847cf1021651446b" # top / newest
PATCH_FUTEX_COMMIT_B="1ade6c3ea42b794a49296a486ac8ad780d1faf46" # bottom / oldest
PATCH_FUTEX_COMMIT_T="dee34186c97c4b224d97f16bf1bbd75c2ea2492e" # top / newest
PATCH_KGCCP_COMMIT="cbf238bae1a5132b8b35392f3f3769267b2acaf5"
PATCH_TRESOR_V="3.18.5"
PATCH_ZENSAUCE_COMMITS=\
"1baa02fbd7a419fdd0e484ba31ba82c90c7036cf \
ef12d902c1323bbbeacc3babc91aae15976474ca \
56f6f4315aedbbcbef8ad61f187347c20a270e49 \
e4afee68d66b61cfd0bdabe937a0e0eb1cea5844 \
a1ced5e49a5044e14f4b46e7db2ff4a5afe92118 \
e92e67143385cf285851e12aa8b7f083dd38dd24 \
f75e102a6ad92d8acb4354895a799d3a60193990 \
ee18749616cbf6ff69de3fc9147737bd021aa519 \
304fc592677954ea3028109e4ebd66408da8f7d6 \
cbf238bae1a5132b8b35392f3f3769267b2acaf5 \
4edc8050a41d333e156d2ae1ed3ab91d0db92c7e \
cba81e70bf716d85151dd20fb4fd001517c98579 \
3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0 \
92f669d8f5542fe3981115706a7b9066a0903b4a \
c9a8f36311f14311a3202501c88009f758683c0f \
90dd01794267f5713bf98910c691f01e00debc4b \
e6e7b853433c818466bdb54263fe5333b141c0af \
7e92cd42bc8f1bdc7b7eaa7d66db53e624c694e8 \
15ec264afa9883c6bd3032b1a3af63da502a215e \
d28734240cb56a0efb60b13ecd7f33141da41314 \
f6b72de6bd17972cee50c4ce97b67954048833de \
a7c2e93c81a96375414db26fdd18cb9fae8421b9 \
376d7ed3c04b5576fe753c0dbe588a423c8be9c3"
PATCH_ZENTUNE_COMMIT_C="3e05ad861b9b2b61a1cbfd0d98951579eb3c85e0"
PATCH_ZENTUNE_COMMIT_B="${PATCH_ZENTUNE_COMMIT_C}" # bottom / oldest
PATCH_ZENTUNE_COMMIT_T="${PATCH_ZENTUNE_COMMIT_C}" # top / newest
PATCH_ZENTUNE_MUQSS_P0="6c8fd1641dea5418c68dad4bf48d2d128a2a13e5"
PATCH_ZENTUNE_MUQSS_P1="dce8f01fd3d28121e3bf215255c5eded3855e417"
PATCH_ZENTUNE_MUQSS_P2="3ca137b68d689fcb1c5cadad1416c7791d84d48e"
PATCH_ZENTUNE_MUQSS_P3="d1bebeb959a56324fe436443ea2f21a8391632d9"
ZENTUNE_MUQSS_SRC_URI_BASE="https://github.com/torvalds/linux/commit/"
PATCH_ZENTUNE_MUQSS_F0=\
"zen-tune-muqss-${K_MAJOR_MINOR}-${PATCH_ZENTUNE_MUQSS_P0}.patch"
PATCH_ZENTUNE_MUQSS_F1=\
"zen-tune-muqss-${K_MAJOR_MINOR}-${PATCH_ZENTUNE_MUQSS_P1}.patch"
PATCH_ZENTUNE_MUQSS_F2=\
"zen-tune-muqss-${K_MAJOR_MINOR}-${PATCH_ZENTUNE_MUQSS_P2}.patch"
PATCH_ZENTUNE_MUQSS_F3=\
"zen-tune-muqss-${K_MAJOR_MINOR}-${PATCH_ZENTUNE_MUQSS_P3}.patch"
ZENTUNE_MUQSS_SRC_URI="
	${ZENTUNE_MUQSS_SRC_URI_BASE}${PATCH_ZENTUNE_MUQSS_P0}.patch \
		-> ${PATCH_ZENTUNE_MUQSS_F0}
	${ZENTUNE_MUQSS_SRC_URI_BASE}${PATCH_ZENTUNE_MUQSS_P1}.patch \
		-> ${PATCH_ZENTUNE_MUQSS_F1}
	${ZENTUNE_MUQSS_SRC_URI_BASE}${PATCH_ZENTUNE_MUQSS_P2}.patch \
		-> ${PATCH_ZENTUNE_MUQSS_F2}
	${ZENTUNE_MUQSS_SRC_URI_BASE}${PATCH_ZENTUNE_MUQSS_P3}.patch \
		-> ${PATCH_ZENTUNE_MUQSS_F3}
"
ZENTUNE_COMMITS="
	${PATCH_ZENTUNE_MUQSS_P0}
	${PATCH_ZENTUNE_MUQSS_P1}
	${PATCH_ZENTUNE_MUQSS_P2}
	${PATCH_ZENTUNE_MUQSS_P3}
"
PATCH_ZENSAUCE_BL="
	${PATCH_ALLOW_O3_COMMIT}
	${PATCH_KGCCP_COMMIT}
	${ZENTUNE_COMMITS}
"

IUSE="bmq +cfs disable_debug +genpatches +kernel_gcc_patch muqss +O3 \
futex-wait-multiple tresor rt tresor_aesni tresor_i686 tresor_sysfs \
tresor_x86_64 tresor_x86_64-256-bit-key-support uksm zen-sauce \
-zen-tune zen-tune-muqss"
REQUIRED_USE="
	^^ ( bmq cfs muqss )
	tresor? ( ^^ ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_aesni? ( tresor )
	tresor_i686? ( tresor )
	tresor_sysfs? ( || ( tresor_aesni tresor_i686 tresor_x86_64 ) )
	tresor_x86_64? ( tresor )
	tresor_x86_64-256-bit-key-support? ( tresor tresor_x86_64 )
	zen-tune-muqss? ( muqss zen-tune )"

if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
REQUIRED_USE+="
	muqss? ( !rt )
	bmq? ( !rt )
	rt? ( cfs !bmq !muqss )
"
fi

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="A customizeable kernel package UKSM, zen-kernel patchset, \
GraySky2's Kernel GCC Patch, MUQSS CPU Scheduler, BMQ CPU Scheduler, \
genpatches, CVE fixes, TRESOR"

inherit ot-kernel

LICENSE+=" cfs? ( GPL-2 )" # This is just a placeholder to not use a
  # third-party CPU scheduler but the stock CPU scheduler.
LICENSE+=" bmq? ( GPL-2 Linux-syscall-note )" # some new files in the patch \
  # do not come with an explicit license but defaults to
  # GPL-2 with Linux-syscall-note.
LICENSE+=" futex-wait-multiple? ( GPL-2 Linux-syscall-note GPL-2+ )"
LICENSE+=" genpatches? ( GPL-2 )" # same as sys-kernel/gentoo-sources
LICENSE+=" kernel_gcc_patch? ( GPL-2 )"
LICENSE+=" muqss? ( GPL-2 )"
LICENSE+=" O3? ( GPL-2 )"
LICENSE+=" rt? ( GPL-2 )"
LICENSE+=" tresor? ( GPL-2 )"
LICENSE+=" uksm? ( all-rights-reserved GPL-2 )" # \
  # GPL-2 applies to the files being patched \
  # all-rights-reserved applies to new files introduced and no default license
  #   found in the project.  (The implementation is based on an academic paper
  #   from public universities.)
LICENSE+=" zen-tune? ( GPL-2 )"
LICENSE+=" zen-tune-muqss? ( GPL-2 )"

if [[ -n "${K_LIVE_PATCHABLE}" && "${K_LIVE_PATCHABLE}" == "1" ]] ; then
	:;
else
KERNEL_DOMAIN_URI=${KERNEL_DOMAIN_URI:="cdn.kernel.org"}
SRC_URI+=" \
https://${KERNEL_DOMAIN_URI}/pub/linux/kernel/v${K_MAJOR}.x/${KERNEL_SERIES_TARBALL_FN}
	   ${KERNEL_PATCH_URIS[@]}"
fi

SRC_URI+=" bmq? ( ${BMQ_SRC_URI} )
	   futex-wait-multiple? ( ${FUTEX_WAIT_MULTIPLE_SRC_URI} )
	   genpatches? (
		${GENPATCHES_URI}
		${GENPATCHES_BASE_SRC_URI}
		${GENPATCHES_EXPERIMENTAL_SRC_URI}
		${GENPATCHES_EXTRAS_SRC_URI}
	   )
	   kernel_gcc_patch? (
		${KGCCP_SRC_4_9_URI}
		${KGCCP_SRC_8_1_URI}
		${KGCCP_SRC_9_1_URI}
		${KGCCP_SRC_10_1_URI}
	   )
	   muqss? ( ${CK_SRC_URI} )
	   O3? ( ${O3_ALLOW_SRC_URI} )
	   rt? ( ${RT_SRC_URI} )
	   tresor? (
		${TRESOR_AESNI_SRC_URI}
		${TRESOR_I686_SRC_URI}
		${TRESOR_README_SRC_URI}
		${TRESOR_RESEARCH_PDF_SRC_URI}
		${TRESOR_SYSFS_SRC_URI}
	   )
	   uksm? ( ${UKSM_SRC_URI} )
	   zen-tune-muqss? ( ${ZENTUNE_MUQSS_SRC_URI} )
	   zen-sauce? ( ${ZENSAUCE_URIS} )"

# @FUNCTION: ot-kernel_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel_pkg_setup_cb() {
	if use kernel_gcc_patch ; then
		CC=$(tc-getCC)
		if ! tc-is-gcc ; then
			CC=$(get_abi_CHOST ${ABI})-gcc
		fi
		if has ">=sys-devel/gcc-10.1" ; then
			if $(gcc-fullversion) -ge 10.1 ; then
				:;
			else
				ewarn \
"You need to switch your compiler to gcc-10.1+ for kernel_gcc_patch to work on\n\
new architectures.  For increased compatibility switch and re-emerge with\n\
>=gcc-10.1."
			fi
		else
			ewarn \
"The kernel_gcc_patch was designed for older kernels and may fail to patch.\n\
Patching anyway.  For increased compatibility switch and re-emerge with\n\
>=gcc-10.1."
		fi
	fi
	if has zen-tune ${IUSE_EFFECTIVE} ; then
		if use zen-tune ; then
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
		if [[ -z "${OT_KERNEL_DEVELOPER}" ]] ; then
			ewarn \
"The TRESOR may not work for the ${K_MAJOR_MINOR} series.  Please\n\
use the older branches."
		fi
	fi
}

# @FUNCTION: ot-kernel_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel_apply_tresor_fixes() {
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_asm_64_v2.1.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/tresor-tresor_key_64.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/wait.patch"
	#fi

	# for 5.x series uncomment below
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS} -F 3" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"

        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-i686.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-ptrace-mispatch-fix-for-5.4-aesni.patch"
	fi
	_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-expose-aes-generic-tables-for-5.4.patch"

	if use tresor_x86_64 || use tresor_i686 ; then
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-i686-v2.1.patch"
	else
		_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-glue-skcipher-cbc-ecb-ctr-xts-support-for-5.4-aesni-v2.1.patch"
	fi

	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-fix-warnings-for-tresor_key_c.patch"
	if use tresor_x86_64-256-bit-key-support ; then
		if use tresor_x86_64 || use tresor_i686 ; then
			_dpatch "${PATCH_OPS}" \
"${FILESDIR}/tresor-256-bit-aes-support-i686-v2-for-5.4.patch"
		fi
	fi
}

# @FUNCTION: ot-kernel_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL and\n\
Idle dynticks system (tickless idle) CONFIG_NO_HZ_IDLE may cause the system\n\
  to lock up.\n\
You must choose Periodic timer ticks (constant rate, no dynticks)\n\
  CONFIG_HZ_PERIODIC for it not to lock up."
	fi
	if use tresor_x86_64-256-bit-key-support ; then
		ewarn \
"\n\
192- and 256-bit key support was added to TRESOR (sse2 for 64-bit) but is\n\
experimental.\n\
\n"
	fi
}

# @FUNCTION: ot-kernel_filter_patch_cb
# @DESCRIPTION:
# Filtered patch function
function ot-kernel_filter_patch_cb() {
	local path="${1}"
	if [[ "${path}" =~ "${BMQ_FN}" ]] ; then
		_dpatch "${PATCH_OPS}" "${path}"
	elif [[ "${path}" =~ "${CK_FN}" ]] ; then
		# Using --dry-run reports more failures than on the actual.
		# The point is that --dry-run is not reliable in some way.
		# The reason is that patching is restarted from the original
		# and does not resume at the not the intermediate images.
		# In the actual patching, 2 hunks actually failed.
		_tpatch "${PATCH_OPS}" "${path}" 10 0 ""
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-0.196-rebase-for-5.4.86.patch"
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/muqss-dont-attach-ckversion.patch"
	elif [[ "${path}" =~ "${O3_ALLOW_FN}" ]] ; then
		_dpatch "${PATCH_OPS} -F 3" "${path}"
	elif [[ "${path}" =~ (${TRESOR_AESNI_FN}|${TRESOR_I686_FN}) ]] ; then
		local fuzz_factor=3
		[[ "${path}" =~ "${TRESOR_I686_FN}" ]] && fuzz_factor=4
		_dpatch "${PATCH_OPS} -F ${fuzz_factor}" "${path}"
		ot-kernel_apply_tresor_fixes
	elif [[ "${path}" =~ "${UKSM_FN}" ]] ; then
		_tpatch "${PATCH_OPS}" "${path}" 2 0 ""
		_dpatch "${PATCH_OPS}" \
			"${FILESDIR}/uksm-5.4-rebase-for-5.4.85.patch"
	elif [[ "${path}" == "${ZENTUNE_MUQSS_VIRTUAL_PATCH}" ]] ; then
		_dpatch "${PATCH_OPS}" \
			"${DISTDIR}/${${PATCH_ZENTUNE_MUQSS_F0}}"
		_dpatch "${PATCH_OPS}" \
			"${DISTDIR}/${${PATCH_ZENTUNE_MUQSS_F0}}"
		_dpatch "${PATCH_OPS}" \
			"${DISTDIR}/${${PATCH_ZENTUNE_MUQSS_F0}}"
		_dpatch "${PATCH_OPS}" \
			"${DISTDIR}/${${PATCH_ZENTUNE_MUQSS_F0}}"
	else
		_dpatch "${PATCH_OPS}" "${path}"
	fi
}

# @FUNCTION: ot-kernel_filter_genpatches_blacklist_cb
# @DESCRIPTION:
# Filter
ot-kernel_filter_genpatches_blacklist_cb() {
	if ( ver_test $(ver_cut 1-3 ${PV}) -eq 5.4.85 ) \
		&& ( ver_test ${K_GENPATCHES_VER} -eq 87 ) ; then
		echo "2400"
	else
		echo ""
	fi
}
