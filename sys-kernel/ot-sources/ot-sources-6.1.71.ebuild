# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
GENPATCHES_VER="80"
PATCH_PROJC_VER="6.1-r4"
PATCH_RT_VER="6.1.70-rt21"

inherit ot-kernel-v6.1

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.1.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 6.1.38 (20230711) with builder profile
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 6.1.38 (20230711) with gamer profile
# USE="bbrv2 build cfs disable_debug genpatches ncurses openssl symlink
# zen-sauce zstd -bzip2 -cfi -clang -clang-pgo -cve_hotfix -exfat
# -genpatches_1510 -graphicsmagick -gtk -gzip -imagemagick -kcfi -lto -lz4
# -lzma -lzo -multigen_lru -pcc -prjc (-qt5) -reiserfs -rt -rust
# -shadowcallstack -tresor -tresor_aesni -tresor_i686 -tresor_prompt
# -tresor_sysfs -tresor_x86_64 -tresor_x86_64-256-bit-key-support -uksm -xz
# -zen-multigen_lru -zen-sauce-all -zen-tune"
# OT_KERNEL_PGT="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"
# CFLAGS=-O2
# Compiler:  GCC 12

# env file builder profile sample:
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_EXTRAVERSION="builder"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_SLAB_ALLOCATOR="slub"
# OT_KERNEL_USB_AUTOSUSPEND=-1
# OT_KERNEL_USE="-c2tcp O3 bbrv2 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru genpatches -clang
# -clang-pgo -zen-muqss zen-sauce -zen-tune -cfi -kcfi -zen-multigen_lru
# -zen-sauce-all -genpatches_1510 build zstd openssl -lto ncurses"
# OT_KERNEL_WORK_PROFILE="builder-interactive"
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="zstd"
# boot:       passed
# show logo:  passed
# network:    passed

# env file gamer profile sample (disabled):
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-interactive"
# OT_KERNEL_EXTRAVERSION="gaming"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_SLAB_ALLOCATOR="slab"
# OT_KERNEL_USB_AUTOSUSPEND=-1
# OT_KERNEL_USE="-c2tcp O3 bbrv2 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru genpatches -clang
# -clang-pgo -zen-muqss zen-sauce -zen-tune -cfi -kcfi -zen-multigen_lru
# -zen-sauce-all -genpatches_1510 build zstd openssl -lto ncurses"
# OT_KERNEL_WORK_PROFILE="pro-gaming"
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="zstd"
# boot:       passed
# show logo:  passed
# network:    passed
