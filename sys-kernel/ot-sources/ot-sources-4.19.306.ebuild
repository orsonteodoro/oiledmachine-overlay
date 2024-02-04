# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
GENPATCHES_VER="295"
PATCH_RT_VER="4.19.302-rt131"

inherit ot-kernel-v4.19

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v4.19.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  signed-kexec-kernel, signed-kernels

# USE="build cfs disable_debug genpatches linux-firmware lz4 ncurses openssl
# tresor tresor_sysfs tresor_x86_64 zen-sauce -bzip2 (-c2tcp) (-deepcc)
# -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick -intel-microcode
# -kpgo-utils -lzma -lzo -muqss (-orca) -pcc -pds -pgo (-qt5) -reiserfs -rt
# -symlink -tresor_aesni -tresor_i686 -tresor_prompt -uksm -xz -zstd"
# CPU_FLAGS_X86="-aes -avx -avx2 -avx512vl -sha -sse2 -sse4_2 -ssse3"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# OILEDMACHINE-OVERLAY-TEST:  passed (4.19.306, 20240204)
# tresor prompt - passed
# tresor self test from /proc/crypto - passed
