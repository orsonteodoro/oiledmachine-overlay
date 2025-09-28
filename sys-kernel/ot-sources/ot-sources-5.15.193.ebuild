# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
GENPATCHES_VER="203"
PATCH_PROJC_VER="5.15-r1"
PATCH_RT_VER="5.15.193-rt89"

inherit ot-kernel-v5.15

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.15.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels

# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 5.15.137 (20231106) with builder profile and -O2 -march=generic (stability flags)
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 5.15.139 (20231121) with builder profile and -O2 -march=generic (stability flags)

#
# Some USE or OT_KERNEL_USE may be ignored in eclasses.
#
# USE="build cfs disable_debug genpatches kpgo-utils ncurses openssl -pgo symlink
# zen-sauce zstd -bbrv2 -bbrv3 -bzip2 (-c2tcp) -clang (-deepcc) -exfat
# -fallback-commit -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kcfi -linux-firmware -lto -lz4 -lzma -lzo (-orca) -pcc -prjc
# (-qt5) -reiserfs -rt -rust -shadowcallstack -tresor -tresor_aesni -tresor_i686
# -tresor_prompt -tresor_sysfs -tresor_x86_64 -tresor_x86_64-256-bit-key-support
# -xz"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11" 0 KiB

# boot time test - pass
# emerge/compile test - pass
# network - pass
# streaming video playback - pass
# initscript - pass
# runtime stability note:  freeze/deadlock encountered during building + media streaming after a day passed (5.15.137)
# runtime stability note:  freeze/deadlock less than a day passed (5.15.139) with rock-dkms:5.7 driver and with USE="disable_debug genpatches rock-dkms cfs" enabled and others USE flag disabled while listening and watching video stream.

# env file builder profile sample:
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_USE="-rt c2tcp -O3 -bbrv2 -bbrv3 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru genpatches -clang -pgo
# -zen-muqss zen-sauce -cfi -kcfi -zen-multigen_lru -genpatches_1510 build zstd
# openssl -lto ncurses"
# OT_KERNEL_VERBOSITY=1
# OT_KERNEL_WORK_PROFILE="builder-interactive"
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_EXTRAVERSION="builder"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_SLAB_ALLOCATOR="slub"
# OT_KERNEL_USB_AUTOSUSPEND=-1

# env file gamer profile sample (disabled):
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-interactive"
# OT_KERNEL_EXTRAVERSION="gaming"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_SLAB_ALLOCATOR="slab"
# OT_KERNEL_USB_AUTOSUSPEND=-1
# OT_KERNEL_WORK_PROFILE="pro-gaming"
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="zstd"


# USE="build cfs disable_debug genpatches linux-firmware ncurses openssl
# rock-dkms tresor tresor_sysfs tresor_x86_64 zstd -bbrv2 -bzip2 (-c2tcp) -cfi
# -clang (-deepcc) -exfat -genpatches_1510 -graphicsmagick -gtk -gzip
# -imagemagick -intel-microcode -kpgo-utils -lto -lz4 -lzma -lzo -multigen_lru
# -nest (-orca) -pcc -pgo -prjc (-qt5) -reiserfs -rt -shadowcallstack -symlink
# -tresor_aesni -tresor_i686 -tresor_prompt -tresor_x86_64-256-bit-key-support
# -uksm -xz -zen-multigen_lru -zen-sauce"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11" 0 KiB
# OILEDMACHINE-OVERLAY-TEST:  passed (5.15.148, 20240204)
# tresor prompt - passed
# tresor self test from /proc/crypto for tresor-cbc (128 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb (128 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr (128 bit key size) - unknown (unsupported until pass)

# USE="build cfs disable_debug genpatches linux-firmware ncurses openssl
# rock-dkms tresor tresor_prompt tresor_sysfs tresor_x86_64
# tresor_x86_64-256-bit-key-support zstd -bbrv2 -bzip2 (-c2tcp) -cfi -clang
# (-deepcc) -exfat -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kpgo-utils -lto -lz4 -lzma -lzo -multigen_lru -nest (-orca)
# -pcc -pgo -prjc (-qt5) -reiserfs -rt -shadowcallstack -symlink -tresor_aesni
# -tresor_i686 -uksm -xz -zen-multigen_lru -zen-sauce"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (5.15.148, 20240208)
# tresor prompt - passed
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed

# USE="build cfs genpatches linux-firmware ncurses openssl rock-dkms tresor
# tresor_aesni tresor_prompt tresor_sysfs zstd -bbrv2 -bzip2 (-c2tcp) -cfi
# -clang (-deepcc) -disable_debug -exfat -genpatches_1510 -graphicsmagick -gtk
# -gzip -imagemagick -intel-microcode -kpgo-utils -lto -lz4 -lzma -lzo
# -multigen_lru -nest (-orca) -pcc -pgo -prjc (-qt5) -reiserfs -rt
# -shadowcallstack -symlink -tresor_i686 -tresor_x86_64
# -tresor_x86_64-256-bit-key-support -uksm -xz -zen-multigen_lru -zen-sauce"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  (5.15.148, 20240210)
# tresor prompt - passed (missing press any key message)
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr skcipher (128-256 bit key size) - unknown
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed
# tresor boot init from /var/log/kern.log (expected fail, need aesni tester):
# alg: skcipher: testing: vec->klen=16 for ecb-tresor-aesni.  enc=1.
# alg: skcipher: ecb-tresor-aesni encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: self-tests for ecb(tresor) using ecb(tresor) failed (rc=-524)
# Call Trace:
# <redacted>
# alg: skcipher: testing: vec->klen=16 for cbc-tresor-aesni.  enc=1.
# alg: skcipher: cbc-tresor-aesni encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: self-tests for cbc(tresor) using cbc(tresor) failed (rc=-524)
# Call Trace:
# <redacted>
# alg: skcipher: testing: vec->klen=16 for ctr(tresor-driver).  enc=1.
# alg: skcipher: ctr(tresor-driver) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: self-tests for ctr(tresor) using ctr(tresor-driver) failed (rc=-524)
# Call Trace:
# <redacted>
