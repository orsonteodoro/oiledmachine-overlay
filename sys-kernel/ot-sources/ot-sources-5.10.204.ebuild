# Copyright 2019-2023 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBUILD_REV=""
BMQ_FN="bmq_v${PATCH_BMQ_VER}.patch" # FIXME
GENPATCHES_VER="215"
PRJC_LTS="-lts"
PATCH_PROJC_VER="5.10-lts-r3"
PATCH_RT_VER="5.10.201-rt98"

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
