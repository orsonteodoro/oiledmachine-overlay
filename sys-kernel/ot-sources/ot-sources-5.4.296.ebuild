# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV="ebuild_revision_5"
PATCH_BMQ_VER="5.4-r2"
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch"
GENPATCHES_VER="264"
PATCH_RT_VER="5.4.296-rt100"

inherit ot-kernel-v5.4

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v5.4.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  signed-kexec-kernel, signed-kernels


# USE="build cfs disable_debug genpatches linux-firmware lz4 ncurses openssl
# rock-dkms tresor tresor_sysfs tresor_x86_64 zen-sauce -bmq -bzip2 (-c2tcp)
# -clang (-deepcc) -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kpgo-utils -lzma -lzo -muqss (-orca) -pcc -pgo (-qt5) -r4
# -reiserfs -rt -symlink -tresor_aesni -tresor_i686 -tresor_prompt
# -tresor_x86_64-256-bit-key-support -uksm -xz -zen-muqss -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (5.4.268, 20240204)
# tresor prompt - passed
# tresor self test from /proc/crypto (128 bit key size) - passed

# USE="build cfs disable_debug genpatches linux-firmware lz4 ncurses openssl
# rock-dkms tresor tresor_prompt tresor_sysfs tresor_x86_64
# tresor_x86_64-256-bit-key-support zen-sauce -bmq -bzip2 (-c2tcp) -clang
# (-deepcc) -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick
# -intel-microcode -kpgo-utils -lzma -lzo -muqss (-orca) -pcc -pgo (-qt5) -r4
# -reiserfs -rt -symlink -tresor_aesni -tresor_i686 -uksm -xz -zen-muqss -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# OILEDMACHINE-OVERLAY-TEST:  passed (5.4.268, 20240208)
# tresor prompt - passed
# tresor self test from /proc/crypto for tresor-cbc skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ecb skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-ctr skcipher (128-256 bit key size) - passed
# tresor self test from /proc/crypto for tresor-xts skcipher (256 bit key size) - passed
# tresor self test from /proc/crypto for tresor cipher (128-256 bit key size) - passed

# USE="build cfs genpatches linux-firmware lz4 ncurses openssl rock-dkms tresor
# tresor_aesni tresor_prompt tresor_sysfs zen-sauce -bmq -bzip2 (-c2tcp) -clang
# (-deepcc) -disable_debug -genpatches_1510 -graphicsmagick -gtk -gzip
# -imagemagick -intel-microcode -kpgo-utils -lzma -lzo -muqss (-orca) -pcc -pgo
# (-qt5) -r4 -reiserfs -rt -symlink -tresor_i686 -tresor_x86_64
# -tresor_x86_64-256-bit-key-support -uksm -xz -zen-muqss -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# OILEDMACHINE-OVERLAY-TEST:  (5.4.268, 20240210)
# PYTHON_TARGETS="python3_10 -python3_11"
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
