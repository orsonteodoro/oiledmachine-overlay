# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch" # FIXME
GENPATCHES_VER="258"
#PRJC_LTS="-lts"
PATCH_PROJC_VER="5.10-r4"
PATCH_RT_VER="5.10.245-rt139"

inherit ot-kernel-v5.10

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.10.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  signed-kexec, signed-kernels

# OILEDMACHINE-OVERLAY-TEST:  passed 5.10.203 (20231213) with muqss-latency, -O3
# WebAssembly:  3D FPS - smooth, 3D coin collect - smooth
# GL Aquarium:  60 FPS
# CanvasMark:  24-62 FPS
# Video site:  720p, 30 FPS - pass, 1024p, 30 FPS - pass

# Sample gaming-profile (5.10.203, 20231213) env:
# CFLAGS="-march=native -O3 -pipe"
# CXXFLAGS="-march=native -O3 -pipe"
# LDFLAGS="-march=native -O3 -fuse=lld"
# CAMERAS="ep800 uvc"
# OT_KERNEL_CPU_MICROCODE="1"
# OT_KERNEL_BOOT_DECOMPRESSOR="lz4"
# OT_KERNEL_BOOT_SUBSYSTEMS_APPEND="drivers/char/agp drivers/gpu drivers/video"
# OT_KERNEL_BUILD="1"
# OT_KERNEL_DISABLE="0"
# OT_KERNEL_EXTRAVERSION="gaming"
# OT_KERNEL_HARDENING_LEVEL="performance"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_MODULES_COMPRESSOR="lz4"
# OT_KERNEL_PROCESSOR_CLASS="multicore"
# OT_KERNEL_USE="linux-firmware -pgo -uksm -rt muqss -c2tcp -O3 -bbrv2
# disable_debug -tresor -tresor_sysfs -tresor_x86_64
# -tresor_x86_64-256-bit-key-support -tresor_aesni -cfs -prjc
# -kernel_compiler_patch -futex -futex-proton -multigen_lru genpatches
# -zen-muqss zen-sauce -cfi -zen-multigen_lru -genpatches_1510 build lz4 openssl
# -lto ncurses"
# OT_KERNEL_SLAB_ALLOCATOR="slab"
# OT_KERNEL_VERBOSITY=1
# OT_KERNEL_WORK_PROFILE="gaming-tournament"
# OT_KERNEL_TCP_CONGESTION_CONTROLS="bbr cubic dctcp hybla pcc vegas westwood" (default)
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="lz4"


# USE="build disable_debug genpatches linux-firmware lz4 muqss ncurses openssl
# tresor tresor_sysfs tresor_x86_64 zen-sauce -bbrv2 -bzip2 (-c2tcp) -cfs -clang
# (-deepcc) -exfat -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kpgo-utils -lzma -lzo (-orca) -pcc -pgo -prjc (-qt5)
# -reiserfs -rt -symlink -tresor_aesni -tresor_i686 -tresor_prompt
# -tresor_x86_64-256-bit-key-support -uksm -xz -zen-muqss -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11" 0 KiB
# OILEDMACHINE-OVERLAY-TEST:  passed (5.10.209, 20240204)
# tresor prompt - passed
# tresor self test from /proc/crypto (128 bit key size) - passed

# USE="build disable_debug genpatches linux-firmware lz4 muqss ncurses openssl
# tresor tresor_prompt tresor_sysfs tresor_x86_64
# tresor_x86_64-256-bit-key-support zen-sauce -bbrv2 -bzip2 (-c2tcp) -cfs -clang
# (-deepcc) -exfat -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kpgo-utils -lzma -lzo (-orca) -pcc -pgo -prjc (-qt5)
# -reiserfs -rt -symlink -tresor_aesni -tresor_i686 -uksm -xz -zen-muqss -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (5.10.209, 20240208)
# tresor prompt - passed (missing press any key message)
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-xts skcipher (256 bit key size) - passed
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed
# tresor boot init from /var/log/kern.log (expected fail, need aesni tester):
# alg: skcipher: testing: vec->klen=16 for ecb(tresor).  enc=1.
# alg: skcipher: ecb(tresor) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: skcipher: testing: vec->klen=16 for cbc(tresor).  enc=1.
# alg: skcipher: cbc(tresor) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: skcipher: testing: vec->klen=16 for ctr(tresor).  enc=1.
# alg: skcipher: ctr(tresor) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
# alg: skcipher: testing: vec->klen=32 for xts(tresor).  enc=1.
# alg: skcipher: xts(tresor) encryption failed on test vector 0; expected_error=0, actual_error=-524, cfg="in-place"
