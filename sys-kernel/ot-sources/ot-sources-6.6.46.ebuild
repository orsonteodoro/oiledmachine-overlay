# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
CLEAR_LINUX_PATCHES_VER="6.6.12-1400"
GENPATCHES_VER="53"
PATCH_PROJC_VER="6.6-r0"
PATCH_RT_VER="6.6.44-rt39"

inherit ot-kernel-v6.6

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.5.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels


# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.6 (20231101) with builder profile and GCC_PGI with -O3 and -march=native (performance flags)
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.6.0.9999 (6.6.0-rc7 commit: 3a568e3a961ba330091cd031647e4c303fa0badb) (20231027) with builder profile
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.6.1 (20231109) with builder profile with -O2 and -march=generic (stable flags) and no PGI/PGO

#
# Some USE or OT_KERNEL_USE may be ignored in eclasses.
#
# USE="build cfs disable_debug genpatches kpgo-utils ncurses openssl pgo symlink
# zen-sauce zstd -bbrv2 bbrv3 -bzip2 (-c2tcp) -clang (-deepcc) -exfat
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
# runtime stability note:  may randomly freeze/deadlock during compile + media streaming during short run or long run (6.6)
# runtime stability note:  freeze/deadlock during compile within 2 days (6.6.1)

# env file builder profile sample:
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_USE="-rt c2tcp O3 -bbrv2 bbrv3 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru genpatches -clang pgo
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


# USE="build cfs clear disable_debug genpatches linux-firmware ncurses openssl
# symlink tresor tresor_prompt tresor_sysfs tresor_x86_64 zen-sauce zstd -bbrv2
# -bbrv3 -bzip2 (-c2tcp) -clang (-deepcc) -exfat -genpatches_1510
# -graphicsmagick -gtk -gzip -imagemagick -intel-microcode -kcfi -kpgo-utils
# -lto -lz4 -lzma -lzo -nest (-orca) -pcc -pgo -prjc (-qt5) -reiserfs -rt -rust
# -shadowcallstack -tresor_aesni -tresor_i686 -tresor_x86_64-256-bit-key-support
# -xz"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (6.6.15, 20240205)
# tresor prompt - passed
# tresor self test from /proc/crypto for tresor-cbc (128 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb (128 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr (128 bit key size) - unknown (unsupported until pass)

# USE="build cfs clear disable_debug genpatches linux-firmware ncurses openssl
# symlink tresor tresor_prompt tresor_sysfs tresor_x86_64
# tresor_x86_64-256-bit-key-support zen-sauce zstd -bbrv2 -bbrv3 -bzip2 (-c2tcp)
# -clang (-deepcc) -exfat -genpatches_1510 -graphicsmagick -gtk -gzip
# -imagemagick -intel-microcode -kcfi -kpgo-utils -lto -lz4 -lzma -lzo -nest
# (-orca) -pcc -pgo -prjc (-qt5) -reiserfs -rt -rust -shadowcallstack
# -tresor_aesni -tresor_i686 -xz"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (6.6.16, 20240208)
# tresor prompt - passed
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed

# USE="build cfs clear genpatches linux-firmware ncurses openssl symlink tresor
# tresor_aesni tresor_prompt tresor_sysfs zen-sauce zstd -bbrv2 -bbrv3 -bzip2
# (-c2tcp) -clang (-deepcc) -disable_debug -exfat -genpatches_1510
# -graphicsmagick -gtk -gzip -imagemagick -intel-microcode -kcfi -kpgo-utils
# -lto -lz4 -lzma -lzo -nest (-orca) -pcc -pgo -prjc (-qt5) -reiserfs -rt -rust
# -shadowcallstack -tresor_i686 -tresor_x86_64
# -tresor_x86_64-256-bit-key-support -xz"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  (6.6.16, 20240210)
# tresor prompt - passed (missing press any key message)
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed
# tresor boot init from /var/log/kern.log (expected fail, need aesni tester):
# alg: skcipher: testing: vec->klen=16 for ecb-tresor-aesni.  enc=1.
# alg: skcipher: ecb-tresor-aesni encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place (one sglist)"
# alg: self-tests for ecb(tresor) using ecb(tresor) failed (rc=-524)
# Call Trace:
# <redacted>
# alg: skcipher: testing: vec->klen=16 for cbc-tresor-aesni.  enc=1.
# alg: skcipher: cbc-tresor-aesni encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place (one sglist)"
# alg: self-tests for cbc(tresor) using cbc(tresor) failed (rc=-524)
# Call Trace:
# <redacted>
# alg: skcipher: testing: vec->klen=16 for ctr(tresor-driver).  enc=1.
# alg: skcipher: ctr(tresor-driver) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place (one sglist)"
# alg: self-tests for ctr(tresor) using ctr(tresor-driver) failed (rc=-524)
# Call Trace:
# <redacted>
# alg: skcipher: failed to allocate transform for ctr(tresor): -2
# alg: self-tests for ctr(tresor) using ctr(tresor) failed (rc=-2)
# alg: No test for xts(tresor) (xts(tresor))

# shows Press or hold any key for tresor
