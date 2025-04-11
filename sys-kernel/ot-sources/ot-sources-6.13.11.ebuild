# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENPATCHES_FALLBACK_COMMIT="7847c71705cc92ba9e9b1d8728fa8692270170e8" # 2024-11-30 12:29:45 -0500
LINUX_SOURCES_FALLBACK_COMMIT="595523945be0a5a2f12a1c04772383293fbc04a1" # 2025-01-17 15:01:24 -0800
RC_PV="" # See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Makefile#n5

# See
# https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=6.13
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

CLEAR_LINUX_PATCHES_VER="6.13.8-1555"
EBUILD_REV="ebuild_revision_6"
GENPATCHES_VER="13" # can be live only when 9999
PATCH_PROJC_VER="6.13-r0"
PATCH_RT_VER="6.13-rt5"

inherit ot-kernel-v6.13

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.13.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels


# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.13.2 (20250216) with builder profile and -O2

# 6.13.2 USE flags:
# USE="build cfs linux-firmware ncurses openssl symlink zstd -bbrv2 -bbrv3
# (-big-endian) -bzip2 -c2tcp -cet -clang -cpu_flags_riscv_rvv (-debug) -deepcc
# -dwarf4 -dwarf5 -dwarf-auto -exfat -expoline -gdb -genpatches -genpatches_1510
# -gost -graphicsmagick -gtk -gzip -imagemagick -intel-microcode -kcfi -lto -lz4
# -lzma -lzo -nest -orca -pcc -pgo -prjc (-qt5) -qt6 -reiserfs -retpoline -rt
# -rust -shadowcallstack -tresor -tresor_prompt -tresor_sysfs -xz -zen-sauce"
# CPU_FLAGS_X86="redacted"
# EBUILD_REVISION="-6"
# OT_KERNEL_TRAINERS="-2d -3d -crypto_chn -crypto_common -crypto_deprecated
# -crypto_kor -crypto_less_common -crypto_rus -crypto_std -custom -emerge1
# -emerge2 -filesystem -memory -network -p2p -webcam -yt"
# PYTHON_TARGETS="python3_10 -python3_11"

#
# Some USE or OT_KERNEL_USE may be ignored in eclasses.
#

# boot time test - pass
# emerge/compile test - pass
# network - pass
# streaming video playback - pass
# initscript - pass
# runtime stability note:  TBA

# env file builder profile sample:
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_USE="-rt c2tcp -O3 -bbrv2 -bbrv3 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru -genpatches -clang pgo
# -zen-muqss -zen-sauce -cfi -kcfi -zen-multigen_lru -genpatches_1510 build zstd
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
