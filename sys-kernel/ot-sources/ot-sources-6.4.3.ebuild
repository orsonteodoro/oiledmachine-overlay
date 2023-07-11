# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENPATCHES_VER="5"
PATCH_PROJC_VER="6.4-r0"
PATCH_RT_VER="6.4-rt6"

inherit ot-kernel-v6.4

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.4.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels

# OILEDMACHINE-OVERLAY-TEST:  PASSED 6.4.1 (20230702)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 6.4.2 (20230702)
# USE="bbrv2 build cfs disable_debug genpatches ncurses openssl symlink
# zen-sauce zstd -bzip2 -cfi -clang -clang-pgo -cve_hotfix -exfat
# -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick -kcfi -lto -lz4 -lzma
# -lzo -multigen_lru -pcc -prjc (-qt5) -reiserfs -rt -rust -shadowcallstack
# -tresor -tresor_aesni -tresor_i686 -tresor_prompt -tresor_sysfs -tresor_x86_64
# -tresor_x86_64-256-bit-key-support -uksm -xz -zen-multigen_lru -zen-sauce-all
# -zen-tune"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# env file sample:
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_WORK_PROFILE="builder-interactive"
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="zstd"

